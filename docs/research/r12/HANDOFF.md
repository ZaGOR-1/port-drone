# DroneFlames R12 · NO_GO

> Історичний матеріал з `toolchain/performance/r12.VIKojgL3/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

Baseline `8c83d91d06989cc3857c7560c4690188bf88a964`. Candidate `e1cd267466874952f0af4f1326f77a730198f4dc`, local documentation commit `b278ce7b3722f0898ab47fee034dd7db63b9547c`. Version 0.36.5. `perf/ground-unit-rendering` is local.

- `evidence/R12_RESULTS.md` and `evidence/BENCHMARK.md` contain the decision, medians/ranges, frame/tick metrics, counter tables and CPU breakdown.
- `evidence/METHOD.md` documents the equivalent geometry, source instrumentation, measurement methodology and superseded samples. `evidence/D2100-TIMING.txt` partitions the D2100 timing gap into measured tick time and time outside it.
- `raw/` contains per-run JSON, configurations, telemetry and logs. `evidence/R12_RAW_FRAMES.csv` and `evidence/R12_CPU_SCOPES.csv` provide flat data. Recompute with `python3 analyze.py`, `python3 benchmark-report.py`, and `python3 diagnose-timing.py`.
- `evidence/visual-final-A` and `evidence/visual-final-B` contain eight PNGs and ordered binary draw traces per variant. `verify-visual.py visual-final` verifies the matching artifacts. `evidence/QA.md` indexes lifecycle, regression, replay and platform checks.
- `candidate/` contains clean source provenance from official Linux and Windows builds of the local experiment and smoke logs. Production-code diff and SHA identities are in `provenance/`. The archived PCK fingerprints refer to separate instrumented, disposable stages.

For a fresh run, materialize the baseline using `DF_PERF_SOURCE=/home/zagor/projects/port-drone ./portable/source r12 source` in a fresh copy of this directory. The candidate worktree is `/home/zagor/projects/port-drone-r12`. Prepare new A/B stages with `prepare.py` and preserve archived `raw/` in a separate location before running. Use the exact DEV-02 toolchain and official INT-06 Linux runtime from `provenance/runtime-path.txt`. The minimal modes use no scope or count instrumentation. Root `SHA256SUMS.txt` verifies the handoff.
