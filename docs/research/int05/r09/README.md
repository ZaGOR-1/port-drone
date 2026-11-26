# R09 · Вхідні дані для актуального performance baseline

> Історичний матеріал з `toolchain/int05.qp8pp1c0/handoff/r09/README.md`. [Реєстр досліджень](../../INDEX.md)

Поточна beta 0.36.4 — `d8114afac56c2475ca9ded5bd8627d4d42000041`.

У всіх трьох optimized прогонах R08 найбільша тривалість кадру припала на watchdog на тику 4746, від 162,162 до 167,222 мс. Медіана залишкової затримки пакета команд на 4693 — 121,996 мс. Результат FPS INCONCLUSIVE. Історичні виміри Army.update, Army._acquire, ArmyFire._spot, UnitsLayer._draw і pathfinding потребують нового вимірювання на точному SHA beta. Вони є орієнтирами для вибору scopes. У INT-05 новий profiling suite не запускався.

| Сценарій | Вхід і runner | Сирі виміри |
| --- | --- | --- |
| Late E 4650–4800 | `../r08/late-e.snapshot`, `../r08/input.json`, `../r08/fixtures/r06/`, `../r08/prepare-r08.py`, `../r08/run.sh` і README R08 | `../r08/e-{1,2,3}-{A,B}/result.json`, `../r08/r08-frames.csv`, `../r08/r08-commands.csv`, `../r08/audit-B4/result.json` |
| C1200, контроль R08 | `../r08/run.sh VARIANT OUTPUT g C`, згенерований стан за seed, fixtures R08 | `../r08/normal-{A,B}/result.json` і telemetry |
| C1200, D1920 і D2100, історичний профіль | `/home/zagor/projects/droneflames-toolchain/performance/r05/preset.sh`, `r05/run_r04.py`, `r05/instrument.py`, fixture `r05/build-P/source/game/game/r02_probe.gd` і `r01_timing.gd` у тому самому каталозі, seed 20261016. Ці сценарії генерують стан, вхідний snapshot для них не потрібен | `/home/zagor/projects/droneflames-toolchain/performance/r05/runs/profile-{c1200,d1920,d2100}/`, `r05/R05_FRAMES.csv`, `r05/R05_CPU_BREAKDOWN.md` |
| D2100 і lockstep C1200, перехресний історичний контроль | `/home/zagor/projects/droneflames-toolchain/performance/r06/reproduce.sh`, `r06/run_r04.py`, `r06/instrument.py` | `/home/zagor/projects/droneflames-toolchain/performance/r06/runs/{d2100-A,d2100-B,c600-A,c600-B}/`, `r06/R06_FRAMES.csv` |

Оригінальний історичний Late E snapshot також збережено в `/home/zagor/projects/droneflames-toolchain/performance/r06/inputs/e-long/state.snapshot` поряд із `frames.json`. Його контрольна копія в R08 має SHA256 `5d83751abcc0ab1cfc35141b0133b78d3982b2001dc9b2dbb8320af16131fcda`. Новий baseline прив'язуй до одного випуску runtime, GPU, камери, seed і workload. Історичні Wine та Linux GUI виміри залишаються прив'язаними до власних середовищ.
