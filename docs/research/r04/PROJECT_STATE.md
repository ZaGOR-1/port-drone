# DroneFlames · Стан Performance R04

> Історичний матеріал з `toolchain/performance/r04/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

2026-11-23. Production `/home/zagor/projects/port-drone` чиста на `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`. Для R01/R02 detached `/home/zagor/projects/droneflames-toolchain/performance/source` і окремого R03 `/home/zagor/projects/droneflames-toolchain/performance/r03/source` збігаються status, binary diff і хеші untracked файлів. R04 — окремий клон без remote у `/home/zagor/projects/droneflames-toolchain/performance/r04/source`, branch `perf/r04`, той самий HEAD. Зміни й діагностика локальні. Production `docs/PROJECT_STATE.md` лишився на committed baseline.

Статус **PARTIAL**. Повторне обчислення руху усунуто, у D2100 `_advance` стала дешевшою в усіх трьох парах. Загальний FPS і p95/p99 **INCONCLUSIVE**. Інтеграція не рекомендована. Пріоритет далі — профілювати waypoint і speed setup та повторити тест за контрольованого фонового навантаження.

Для наступної резервної копії зберегти R04 звіти, scripts, inputs, raw runs, diffs, provenance, SHAs і QA EXE. Каталог `wine-r02/` — локальний профіль. `build-*/profile` — тимчасовий build scratch, який відтворюється зі staged patch. Старі архіви лишилися на місці.

[Аналіз](R04_ANALYSIS.md) · [Зміна](R04_CHANGES.md) · [A/B](R04_AB_RESULTS.md) · [Детермінізм](R04_DETERMINISM.md) · [Наступні кроки](R04_NEXT_STEPS.md)
