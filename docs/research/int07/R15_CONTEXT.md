# R15 · Контекст ArmyFire._spot

> Історичний матеріал з `toolchain/int07.4IWmLXCl/handoff/R15_CONTEXT.md`. [Реєстр досліджень](../INDEX.md)

Джерело вимірювань — R14 на beta 0.36.5 і кандидатові 0.36.5. У INT-07 `_spot` і виклики лишилися без змін. Нове профілювання для R15 не запускали.

| R14 CPU-пара | Кадр, індекс від 0 | Тик | Inclusive A → B, мс | Exclusive A → B, мс |
| --- | ---: | ---: | ---: | ---: |
| D2100 №1 | 17 | 63 | 103,635 → 101,579 | 91,098 → 88,770 |
| D2100 №1 | 48 | 94 | 107,175 → 97,988 | 94,604 → 87,721 |
| D2100 №2 | 17 | 63 | 100,636 → 107,434 | 88,150 → 94,245 |
| D2100 №2 | 48 | 94 | 118,367 → 102,647 | 104,277 → 91,831 |

У кожному зі чотирьох профільних прогонів було 4 виклики за 120 виміряних тіків, по одному на тиках 63, 94, 125 і 156 (кадри 17, 48, 79, 110). Пік CPU-пари №2 A на тику 94 мав кадр 164,532 мс, тик 140,158 мс, `Army.update` 137,205 мс inclusive, `_spot` 118,367 мс inclusive, `_impact` 1,797 мс і `_advance` 7,525 мс. Вкладені scopes перекриваються. Витяг з усіх чотирьох прогонів (`../evidence/r15-spot-extract.txt`).

## Відтворення R14

Збережені профільні PCK `stage-impact-A` і `stage-impact-B` та той самий official Godot 4.7.2. Виконувати лише за окремим завданням R15, по одному прогону:

```bash
cd /home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B
python3 run.py r15-reference-spot-A D2100 --pack impact-A --ticks 120
python3 run.py r15-reference-spot-B D2100 --pack impact-B --ticks 120
```

D2100 генерується fixture з seed `20261016`, 2100 юнітів, цільові 1080 споруд, 45 warmup + 120 виміряних тіків, камера `(2629.199, 1236.892)`, zoom `1.111111`. 1280×720, Vulkan Mobile, RTX 4060 Laptop, VSync/FPS cap off. Вихідні NetHash `b1a480e4da8d8d82`, перед заміром `acdbda3ae7f4f39c`, кінцевий `6bee855c1a62f9d0`, CRC команд `1722618560`. Конфіг D2100 (`/home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B/raw/cpu-D2100-2-A/config.json`) · Raw профіль і команди (`/home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B/raw/cpu-D2100-2-A/result.json`)

Late E snapshot міститься в `/home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B/fixtures/late-e.snapshot`. Він є окремим контрольним сценарієм. D2100 save із `raw/qa-disk-A/active-battle.save` придатний для Save/Load і ручного порівняння. Раннє вікно піків D2100 відтворюється генератором і потоком команд вище.

- R03 — `/home/zagor/projects/droneflames-toolchain/performance/r03/`. Історичний PoC `R03_OPTIMIZED.patch`, staged source `build-B/source/`, differential fixture `test_spot.gd`, звіти `R03_ANALYSIS.md`, `R03_AB_RESULTS.md`, `R03_DETERMINISM.md`.
- R09 — `/home/zagor/projects/droneflames-toolchain/performance/r09.vlpdda5t/`. `R09_CPU_BREAKDOWN.md` і `R09_OPTIMIZATION_BACKLOG.md` фіксують п'ять викликів за 150 тіків і 76,52 мс exclusive в середньому на виклик у D2100.
- R14 — `/home/zagor/projects/droneflames-toolchain/performance/r14.GEz1Tr3B/`. `evidence/R14_CPU_SCOPES.csv`, `R14_RAW_FRAMES.csv`, `BENCHMARK.md`, `fixtures/` і пакети збережено.

Наявні заміри дають cadence, inclusive/exclusive, tick і frame time. Підфази `_spot` потребують цільового профілювання: побудова eyes, unit та facility grid queries, повторні кандидати, `done_u`/`done_f`, distance, smoke, naval, output і алокації. Перед PoC потрібен свіжий baseline beta 0.36.6. Для differential зберегти порядок `spotted` і `seen`, `nearest_spotted` при рівній відстані, recon/trench/smoke, поріг списку споруд, cadence, RNG і NetHash.

R03 виміряв 3 594 954 скопійованих посилань у D2100 за 12 викликів. Його PoC усував копіювання в `_spot_u` зі збереженням числа кандидатів і перевірок `done_u`. Історичний fixed-view D2100 дав `_spot` −10,6% і frame p99 200,75 → 160,01 мс, водночас D1920 втратив 5,5% FPS. Ці дані походять із бази `c91e0e6` і слугують гіпотезою для свіжого профілю. [Механізм R03](../r03/R03_ANALYSIS.md) · [Парні результати](../r03/R03_AB_RESULTS.md)
