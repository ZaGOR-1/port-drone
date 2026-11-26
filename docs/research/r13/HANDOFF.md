# DroneFlames R13 · NO_GO

> Історичний матеріал з `toolchain/performance/r13.C0NIjw0t/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

Exact baseline `8c83d91d06989cc3857c7560c4690188bf88a964`, version 0.36.5. The local experiment is `perf/army-advance` in `/home/zagor/projects/port-drone-r13`, preserved as an uncommitted production diff. `provenance/source.diff` and `provenance/poc.sha256` identify the exact candidate. Stage D and QA packaging were held behind the early gate.

- `evidence/R13_RESULTS.md`, `evidence/BENCHMARK.md` and `evidence/METHOD.md` contain the finding, pair metrics, profiler breakdown and measurement boundaries.
- `raw/` contains per-run result/config JSON, host telemetry, snapshots of processes and logs. Flat data are in `evidence/R13_RAW_FRAMES.csv`, `evidence/R13_CPU_SCOPES.csv`, and `evidence/R13_PHASES.csv`.
- `movement.gd`, `short-replay.py`, `gate.sh` and `fixtures/` reproduce the early movement checks. `evidence/movement-A` and `evidence/movement-B` contain the identical fixture output.
- `evidence/R04_ANALYSIS.md` and `evidence/R04_OPTIMIZED.patch` preserve the historical reference. R13's source diff is independent of that patch.

Use `DF_PERF_SOURCE=/home/zagor/projects/port-drone ./portable/source r13 source` in a fresh copy to materialize the baseline. For the B stages, use the exact local worktree or apply the preserved production diff to an independent copy of the baseline. Prepare `phases-A`, `profile-A`, `minimal-A` and `trace-A` first with `prepare.py`. Use the INT-06 native runtime from `provenance/runtime-path.txt` and the same DEV-02 toolchain. Create a fresh `raw` directory before running the gate. Run `python3 analyze.py`, `python3 phase-report.py`, and `python3 benchmark-report.py` to recompute the reports. Check the handoff with `sha256sum -c SHA256SUMS.txt`.
