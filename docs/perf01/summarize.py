"""Summarize retained A/B fixture samples and export tidy raw CSVs."""
import argparse
import collections
import csv
import json
import math
import statistics
from pathlib import Path


def percentile(values, p):
    ordered = sorted(values)
    return ordered[max(0, math.ceil(len(ordered) * p) - 1)]


def scope_per_frame(phase, name):
    return sum(phase["scopes_us"].get(name, [])) / len(phase["frame_us"]) / 1000


def metrics(phase):
    frames = phase["frame_us"]
    return {
        "fps": 1_000_000 / statistics.mean(frames),
        "p50_ms": percentile(frames, 0.50) / 1000,
        "p95_ms": percentile(frames, 0.95) / 1000,
        "p99_ms": percentile(frames, 0.99) / 1000,
        "max_ms": max(frames) / 1000,
        "ui_ms_per_frame": scope_per_frame(phase, "_strike_update"),
        "render_prep_ms_per_frame": sum(scope_per_frame(phase, name)
                                       for name in ("route_overlay_draw", "strike_marks_draw", "_draw_ghost")),
        "draw_calls_median": statistics.median(phase["draw_calls"]),
        "motion_p95_us": percentile(phase["motion_us"], 0.95) if phase["motion_us"] else None,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("out", type=Path)
    parser.add_argument("runs", type=Path, nargs="+")
    args = parser.parse_args()
    args.out.mkdir(exist_ok=False)
    grouped = collections.defaultdict(list)
    summary = {}
    with (args.out / "frames.csv").open("w", newline="") as frame_out, (
        args.out / "scopes.csv"
    ).open("w", newline="") as scope_out, (args.out / "clicks.csv").open("w", newline="") as click_out:
        frames, scopes, clicks = (csv.writer(f) for f in (frame_out, scope_out, click_out))
        frames.writerow(["run", "targets", "stage", "sample", "frame_us", "draw_calls", "motion_us"])
        scopes.writerow(["run", "targets", "stage", "scope", "call", "elapsed_us"])
        clicks.writerow(["run", "target", "elapsed_us"])
        for run in args.runs:
            result = json.loads((run / "result.json").read_text())
            if not result["passed"]:
                raise ValueError(f"{run}: {result['failures']}")
            samples = result["samples"]
            summary[run.name] = run_summary = {"workload": samples["workload"]}
            for i, elapsed in enumerate(samples["add_us"], 1):
                clicks.writerow([run.name, i, elapsed])
            for target, entry in samples.items():
                if not target.isdigit():
                    continue
                run_summary[target] = {}
                for stage in ("idle", "hover"):
                    phase = entry[stage]
                    result_metrics = metrics(phase)
                    run_summary[target][stage] = result_metrics
                    grouped[(run.name[0], target, stage)].append(result_metrics)
                    for i, (time, draws) in enumerate(zip(phase["frame_us"], phase["draw_calls"], strict=True)):
                        motion = phase["motion_us"][i] if phase["motion_us"] else ""
                        frames.writerow([run.name, target, stage, i, time, draws, motion])
                    for scope, calls in phase["scopes_us"].items():
                        for i, elapsed in enumerate(calls):
                            scopes.writerow([run.name, target, stage, scope, i, elapsed])
    aggregate = {}
    for (variant, target, stage), entries in grouped.items():
        destination = aggregate.setdefault(variant, {}).setdefault(target, {}).setdefault(stage, {})
        for metric in entries[0]:
            values = [entry[metric] for entry in entries if entry[metric] is not None]
            if values:
                destination[metric] = {
                    "median": statistics.median(values), "min": min(values), "max": max(values),
                }
    (args.out / "summary.json").write_text(json.dumps({"runs": summary, "aggregate": aggregate}, indent=2) + "\n")


if __name__ == "__main__":
    main()
