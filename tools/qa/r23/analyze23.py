"""Reduce the R23 frame logs without launching the game."""
import argparse
import csv
from collections import defaultdict
import json
from math import ceil
from pathlib import Path
import re
from statistics import mean, median

VERSIONS = (4, 7, 11)
CASES = ("medium", "C1200", "D2100", "D2100-dense", "D3000", "D4000",
         "D5000", "D5000-dense", "D2100-restore", "Late-E")
WINDOW = ("start_tick", "warm_ticks", "ticks_done", "ticks_requested",
          "loaded_state", "seed", "size", "window", "camera_position",
          "camera_zoom", "vsync", "fps_cap", "renderer", "driver", "gpu",
          "version", "gui", "burst", "detail")
STATE = ("initial_hash", "hash_before", "hash_after", "movement_hash", "rng_after",
         "orders", "checkpoints")
WORK = ("ground_active", "ground_total", "ground_with_target", "ground_in_view",
        "artillery_shells", "projectiles_selected", "grid_unit_entries", "grid_bucket_max",
        "operations", "watchdogs", "queued_barracks", "operation_queue",
        "delayed_events", "nav_jobs", "building_live", "cities", "map_objects")
WORK_SIGNATURE = ("ground_active", "ground_total", "ground_with_target",
                  "artillery_shells", "projectiles_selected", "grid_unit_entries",
                  "grid_bucket_max", "operations", "watchdogs",
                  "queued_barracks", "operation_queue", "delayed_events",
                  "building_live", "cities", "map_objects")


def percentile(values, q):
    return sorted(values)[ceil(len(values) * q) - 1] if values else None


def interval_metrics(values, prefix):
    names = ("p50", "p95", "p99", "max")
    return {f"{prefix}_{name}_ms": percentile(values, q)
            for name, q in zip(names, (.50, .95, .99, 1.0), strict=True)}


def slow_bins(wall):
    """Count complete five-second bins by the frame completion timestamp."""
    bins = [0] * int(sum(wall) // 5000)
    elapsed = 0
    for gap in wall:
        elapsed += gap
        index = ceil(elapsed / 5000) - 1
        if 0 <= index < len(bins):
            bins[index] += 1
    in_band = [10 <= frames <= 15 for frames in bins]
    longest = streak = 0
    for slow in in_band:
        streak = streak + 1 if slow else 0
        longest = max(longest, streak)
    return {"total": len(bins), "2_to_3_fps": sum(in_band),
            "at_most_3_fps": sum(frames <= 15 for frames in bins),
            "longest_2_to_3_fps_s": longest * 5}


def measurements(frames):
    wall = [r["frame_us"] / 1000 for r in frames]
    seconds = sum(wall) / 1000
    ticks = [r for r in frames if r["ticks"]]
    # This fixture supplies one tick per dispatch. Reject partial or batched samples.
    assert all(r["ticks"] == r["calls"].get("tick") == 1 for r in ticks)
    sim = [r["r22"]["scopes"]["simulation"][0] / 1e6 for r in ticks]
    tick_wall = [r["us"]["tick"] / 1000 for r in ticks]
    executor = [r["us"]["turn.total"] / 1000 for r in ticks]
    completion = []
    turn_work = []
    cycle_us = 0
    active_turn = False
    for frame in frames:
        if frame["ticks"] and frame["tick"] % 3 == 1:
            active_turn = True
            cycle_us = 0
            turn_work = []
        if active_turn:
            cycle_us += frame["frame_us"]
            if frame["ticks"]:
                turn_work.append(frame["us"]["turn.total"])
                if frame["tick"] % 3 == 0:
                    assert len(turn_work) == 3
                    completion.append(cycle_us / 1000)
                    active_turn = False

    slow_wall = longest_wall = 0
    for gap in wall:
        slow_wall = slow_wall + gap if gap >= 1000 / 3 else 0
        longest_wall = max(slow_wall, longest_wall)
    return {
        "frames": len(wall), "ticks": len(ticks), "seconds": seconds,
        "fps": len(wall) / seconds, "low_1": 1000 / mean(sorted(wall)[-ceil(len(wall) / 100):]),
        "ticks_s": len(ticks) / seconds, "sim_cpu_ms": mean(sim) if sim else None,
        "sim_cpu_total_ms": sum(sim), "sim_cpu_gt33": sum(v > 1000 / 30 for v in sim),
        "frame_gt100": sum(v > 100 for v in wall), "frame_gt200": sum(v > 200 for v in wall),
        "tick_gt100": sum(v > 100 for v in tick_wall), "tick_gt200": sum(v > 200 for v in tick_wall),
        "slow_3fps_streak_s": longest_wall / 1000,
        "slow_5s_bins": slow_bins(wall),
        "turns_completed": len(completion),
        **interval_metrics(wall, "frame"), **interval_metrics(tick_wall, "tick"),
        **interval_metrics(executor, "dispatch"), **interval_metrics(completion, "turn_observed"),
        "render_setup_ms": median(r["render_setup_cpu_ms"] for r in frames),
        "viewport_cpu_ms": median(r["render_viewport_cpu_ms"] for r in frames),
        "viewport_gpu_ms": median(r["render_viewport_gpu_ms"] for r in frames),
        "draw_calls": median(r["draw_calls"] for r in frames),
        "video_mib": max(r["render_video_bytes"] for r in frames) / 2**20,
    }


def samples(path, time_key, start, end):
    with path.open() as stream:
        return [r for r in csv.DictReader(stream) if r.get(time_key) and
                start <= float(r[time_key]) <= end]


def host_metrics(path, start, end):
    host = samples(path / "host.csv", "unix_s", start, end)
    system = samples(path / "system.csv", "unix_s", start, end)
    result = {"host_samples": len(host), "system_samples": len(system),
              "other_heavy": sorted({r["other_heavy"] for r in system if r["other_heavy"]})}
    for source, field, name, op in (
        (host, "game_main_pct", "main_cpu_pct", median),
        (host, "game_cpu_pct", "process_cpu_pct", median),
        (host, "host_cpu_pct", "host_cpu_pct", median),
        (host, "game_rss_mib", "window_rss_mib", max),
        (host, "vram_used_mib", "gpu_global_vram_mib", max),
        (host, "host_available_mib", "available_mib", min),
        (system, "unrelated_pct", "background_pct", median),
        (system, "unrelated_pct", "background_max_pct", max),
        (system, "main_wait_pct", "main_wait_pct", median),
        (system, "memory_psi_pct", "memory_psi_pct", median),
        (system, "cpu_psi_pct", "cpu_psi_pct", median),
    ):
        values = [float(r[field]) for r in source if r[field]]
        result[name] = op(values) if values else None
    return result


def scope_metrics(frames):
    scopes = defaultdict(lambda: [0, 0, 0, 0])
    for row in frames:
        for key, values in row["r22"]["scopes"].items():
            counts = scopes[key]
            for index in range(3):
                counts[index] += values[index]
            counts[3] = max(counts[3], values[3])
    n = len(frames) * 1e6
    return {name: {"inclusive_ms_frame": i / n, "exclusive_ms_frame": e / n,
                   "calls": count, "max_call_ms": peak / 1e6}
            for name, (i, e, count, peak) in scopes.items()}


def reduce_run(path, data):
    settings = {key: data[key] for key in WINDOW}
    setup = json.loads((path / "config.json").read_text())["effective"]
    result = measurements(data["frames"])
    start = data["sample_epoch_s"]
    result.update(host_metrics(path, start, start + result["seconds"]))
    time_log = (path / "time.txt").read_text()
    rss = re.search(r"Maximum resident set size \(kbytes\):\s+(\d+)", time_log)
    result["peak_rss_mib"] = int(rss[1]) / 1024 if rss else None
    result["complete"] = (data["reason"] == "ticks" and result["ticks"] == setup["TICKS"] and
                          data["ticks_done"] - data["start_tick"] == setup["WARM"] + setup["TICKS"])
    result["reason"] = data["reason"]
    result["settings"] = settings
    result["workload"] = {stage: data[stage] for stage in ("initial", "before", "after")}
    observed = [f["workload"] for f in data["frames"] if "workload" in f]
    result["work_medians"] = {k: median([r[k] for r in observed]) for k in WORK} if observed else {}
    result["visible_median"] = median([f["visible_live_units"] for f in data["frames"]
                                        if "visible_live_units" in f])
    result["scopes"] = scope_metrics(data["frames"])
    layers = ("UnitsLayer._draw", "UnitsLayer._draw_outline", "UnitsLayer._process")
    result["units_cpu_ms_frame"] = sum(result["scopes"].get(name, {}).get("inclusive_ms_frame", 0)
                                       for name in layers)
    return result


def compare(a, b):
    mismatches = [k for k in (*WINDOW, *STATE) if a[k] != b[k]]
    checkpoints = []
    for run in (a, b):
        work = [(r["tick"], tuple(r["workload"][k] for k in WORK_SIGNATURE))
                for r in run["frames"] if "workload" in r]
        checkpoints.append(work)
    if checkpoints[0] != checkpoints[1]:
        mismatches.append("workload_at_ticks")
    return mismatches


def long_windows(path, data):
    frames = data["frames"]
    begin = data["sample_epoch_s"]
    current = []
    elapsed = 0.0
    windows = []
    for f in frames:
        current.append(f)
        relative_tick = f["tick"] - data["start_tick"]
        if not f["ticks"] or relative_tick % 300:
            continue
        row = measurements(current)
        start, end = begin + elapsed, begin + elapsed + row["seconds"]
        row.update(host_metrics(path, start, end))
        row.update(current[-1]["workload"])
        row.update(tick_end=relative_tick, wall_s=end - begin)
        windows.append(row)
        if len(windows) == 1:
            row["tick_start"] = 0
        else:
            row["tick_start"] = windows[-2]["tick_end"]
        elapsed += row["seconds"]
        current = []
    return windows


def write_csv(reports, name, rows):
    if not rows:
        return
    fields = list(dict.fromkeys(key for row in rows for key in row))
    with (reports / name).open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fields)
        writer.writeheader()
        writer.writerows(rows)


def analyze(root, reports):
    runs = {}
    sources = {}
    long = {}
    for path in sorted((root / "raw").glob("*/result.json")):
        name = path.parent.name
        data = json.loads(path.read_text())
        assert data["fixed_tick"] and data["gui"] and data["window"] == "(1280, 720)", name
        runs[name] = reduce_run(path.parent, data)
        # Avoid retaining every per-frame telemetry record in memory.
        sources[name] = {key: data[key] for key in (*WINDOW, *STATE)}
        sources[name]["frames"] = [{"tick": f["tick"], "workload": f["workload"]}
                                    for f in data["frames"] if "workload" in f]
        if name.startswith("long-"):
            long[name] = long_windows(path.parent, data)
    if not runs:
        raise ValueError("No raw run results found")
    scalar = [k for k, v in next(iter(runs.values())).items()
              if not isinstance(v, (list, dict)) and k not in ("reason", "complete")]
    absolute = []
    paired = []
    proof = {}
    for case in CASES:
        for v in VERSIONS:
            names = [n for n in (f"s{i}-{case}-v{v}" for i in (1, 2, 3))
                     if n in runs and runs[n]["complete"]]
            if not names:
                continue
            rows = [runs[n] for n in names]
            record = {"case": case, "version": f"0.36.{v}", "n": len(rows)}
            for field in scalar:
                values = [r[field] for r in rows if r[field] is not None]
                record[field] = median(values) if values else None
            for k in WORK:
                record[k] = median(r["work_medians"][k] for r in rows)
            record["active_start"] = median(r["workload"]["before"]["ground_active"] for r in rows)
            record["active_end"] = median(r["workload"]["after"]["ground_active"] for r in rows)
            absolute.append(record)
        for a, b in ((4, 7), (7, 11), (4, 11)):
            pairs = []
            for i in (1, 2, 3):
                n, m = (f"s{i}-{case}-v{v}" for v in (a, b))
                if n not in runs or m not in runs:
                    continue
                mismatches = compare(sources[n], sources[m])
                if not runs[n]["complete"] or not runs[m]["complete"]:
                    mismatches.append("incomplete")
                proof[f"{n}/{m}"] = mismatches
                if not mismatches:
                    pairs.append((runs[n], runs[m]))
            if pairs:
                for field in scalar:
                    values = [((right[field] - left[field]), 100 * (right[field] / left[field] - 1)
                               if left[field] else None)
                              for left, right in pairs if left[field] is not None and right[field] is not None]
                    if values:
                        pcts = [pct for _, pct in values if pct is not None]
                        paired.append({"case": case, "versions": f"{a}→{b}", "field": field, "n": len(values),
                                       "delta": median(d for d, _ in values),
                                       "pct": median(pcts) if pcts else None,
                                       "pct_min": min(pcts) if pcts else None,
                                       "pct_max": max(pcts) if pcts else None})
    if len(long) == 2:
        a, b = sorted(long)
        proof[f"{a}/{b}"] = compare(sources[a], sources[b])
    for name in runs:
        if name.startswith("profile-"):
            counterpart = name.replace("profile-", "s1-") + "-v11"
            if counterpart in runs:
                proof[f"{counterpart}/{name}"] = compare(sources[counterpart], sources[name])
    reports.mkdir(parents=True, exist_ok=True)
    (reports / "summary.json").write_text(json.dumps(
        {"runs": runs, "absolute": absolute, "paired": paired, "proof": proof, "long": long},
        ensure_ascii=False, indent=2) + "\n")
    write_csv(reports, "absolute.csv", absolute)
    write_csv(reports, "paired.csv", paired)
    write_csv(reports, "long.csv", [dict(run=name, **row) for name, rows in long.items() for row in rows])
    print(f"{len(runs)} runs, {len(absolute)} aggregate rows, {len(proof)} comparisons")
    for name, delta in proof.items():
        if delta:
            print(name, delta)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("harness", type=Path, help="R23 handoff harness containing raw and fixtures")
    parser.add_argument("--out", type=Path, required=True, help="Reports directory outside the handoff")
    args = parser.parse_args()
    if not __debug__:
        parser.error("Run without -O to enable the original tick checks")
    root = args.harness.resolve()
    reports = args.out.resolve()
    if reports.is_relative_to(root.parent):
        parser.error("--out must be outside the handoff directory")
    try:
        analyze(root, reports)
    except (AssertionError, OSError, ValueError, KeyError, TypeError) as exc:
        parser.exit(1, f"R23 analysis failed: {exc}\n")


if __name__ == "__main__":
    main()
