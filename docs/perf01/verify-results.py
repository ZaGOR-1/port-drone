"""Require equivalent targets, wire commands, queues and fixed-tick state."""
import argparse
import json
from pathlib import Path


def read(run):
    result = json.loads((run / "result.json").read_text())
    if not result["passed"]:
        raise ValueError(f"{run}: {result['failures']}")
    log = (run / "run.log").read_text()
    if "SCRIPT ERROR:" in log:
        raise ValueError(f"{run}: see script errors in run.log")
    return result["samples"]


def equivalent(a, b, keys):
    for key in keys:
        if a[key] != b[key]:
            raise ValueError(f"{key}: A={a[key]} differs from B={b[key]}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    parser.add_argument("gui_runs", nargs="+")
    args = parser.parse_args()
    gui = [read(args.root / name) for name in args.gui_runs]
    for run in gui:
        equivalent(gui[0]["workload"], run["workload"],
                   ("tels", "magazine", "seed", "viewport", "camera", "zoom", "game_time", "net_hash_initial"))
        for n in (10, 50, 100, 150, 199, 200, 201, 250, 300, 500):
            equivalent(gui[0][str(n)], run[str(n)], ("display",))
        for n in (50, 200, 300, 500):
            equivalent(gui[0][str(n)], run[str(n)], ("plan",))
        equivalent(gui[0]["execution"], run["execution"],
                   ("net_hash_before_order", "net_hash_after_order", "net_hash_after_ticks",
                    "queues", "queued", "live_missiles"))
    result = {
        "gui_runs": args.gui_runs,
        "gui_initial_hash": gui[0]["workload"]["net_hash_initial"],
        "gui_500_post_launch_hash": gui[0]["execution"]["net_hash_after_ticks"],
        "host": {},
    }
    for count in (50, 200, 300, 500):
        a, b = (read(args.root / f"{variant}-mp-{count}") for variant in ("A", "B"))
        equivalent(a[str(count)], b[str(count)], ("plan",))
        equivalent(a["host"], b["host"], ("wire",))
        keys = ("queues", "queued", "live_missiles", "net_hash_before_order", "net_hash_after_order",
                "net_hash_after_ticks")
        equivalent(a["execution"], b["execution"], keys)
        if b["execution"]["queued"] != count or not b["execution"]["live_missiles"]:
            raise ValueError(f"{count}: host did not queue and launch expected missiles")
        result["host"][str(count)] = {
            "wire": b["host"]["wire"],
            **{key: b["execution"][key] for key in keys},
        }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
