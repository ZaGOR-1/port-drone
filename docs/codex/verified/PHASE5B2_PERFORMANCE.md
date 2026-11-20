# Phase 5B.2 — FIX-08 performance

2026-11-20. Порівняно immutable fix07.pck (FIX05–07, eager fallback) та candidate.pck (той самий source + один рядок lazy fallback). Пізніший candidate_review.pck додає лише targeted network validation; це окремо від вимірюваного upkeep/simulation path. Не підміняти hashes цих пакетів: manifest/final results зберігають кожну роль.

Pinned Godot4.7.2.ed1daf0bf, WSL2/AMD Ryzen5 7640HS,6vCPU; один host, sequential runs, паралельні Godot tests не запускалися. Checkpoint `late_checkpoint.bin`, SHA256 e3e0018353af083d83b6f5ecbc83490fd3d3505b985e99ae18f7b5e49d68f704,1024 map/seed20261016/4bots/t1200, global seed91234. Зовнішній host workload/governor не зафіксований; timings мають системний розкид. Exact argv/result/logs — у /home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631.

## Профіль власне upkeep

`tests/benchmark_upkeep_fallback.gd`: real Upkeep._step,500 successive upkeep intervals, щоразу той самий початковий checkpoint для кожного run. Інші world systems/AI між upkeep intervals не виконуються; це профіль модуля, не повний матч. Spy лише рахує production tally calls, повертає super.tally. Однакові economic digest/NetHash/RNG у всіх6runs. Перші3before виміряно до edit FIX08; after3 після, без concurrency.

| Build / run | p50 ms | p99 ms | avg ms | max ms | fallback calls |
|---|---:|---:|---:|---:|---:|
| before/1 | 3.089 | 5.596 | 3.248 | 6.275 | 2500 |
| before/2 | 3.018 | 5.846 | 3.194 | 10.389 | 2500 |
| before/3 | 2.903 | 5.429 | 3.110 | 7.464 | 2500 |
| after/1 | 1.758 | 3.911 | 1.893 | 5.523 | 0 |
| after/2 | 1.800 | 4.045 | 1.929 | 6.261 | 0 |
| after/3 | 1.772 | 3.975 | 1.907 | 5.444 | 0 |

Median average 3.194→1.907ms; median p99 5.596→3.975ms.2500 зайвих per-country traversals→0 за500intervals. Це відтворена користь цього одного рядка; формули/баланс не змінено. Digest `b1726f9ca82985af20f7bf6e85e82ab14c50c726b36c81417a2cad26582d784d` однаковий. Missing key досі використовує fallback (окремий unit differential). Memory у module microbenchmark NOT MEASURED.

## Повна _sim_step — окрема контрольована серія

`benchmark_simulation.gd`: копія попереднього samples harness із доданими final hash/RNG та `GameWorld.lab_tick`.300ticks dt0.2/warmup0/60simulation seconds, same checkpoint. Парний порядок before1→after1→after2→before2→before3→after3. Lab mode примусово чекає worker jobs та використовує logical tick для cache/budget. Це забезпечило однаковий кінцевий hash/RNG/facilities/units у всіх6runs, але **змінило умови відносно старого Phase5 benchmark**.

Timings — elapsed wall time всередині _sim_step, включно з synchronous worker waits у цьому lab mode, а не чистий active CPU instruction time. _poll_roads та autosave поза timed region. GPU/rendering/FPS не вимірювалися. Не порівнювати675ms цієї серії зі старими42–50ms як production regression: worker scheduling/очікування різні. Вимірюваний процес CPU time / peak RSS містять також startup/load/autosave, не лише simulation.

| Build / run | p50 ms | p99 ms | avg ms | max ms | peak process RSS MiB |
|---|---:|---:|---:|---:|---:|
| before/1 | 10.523 | 674.599 | 27.997 | 895.568 | 1004.3 |
| before/2 | 10.551 | 683.063 | 27.939 | 860.792 | 1012.2 |
| before/3 | 10.601 | 647.296 | 28.047 | 874.559 | 1011.8 |
| after/1 | 10.291 | 648.756 | 27.387 | 854.037 | 1003.4 |
| after/2 | 10.841 | 662.782 | 28.165 | 862.158 | 1003.4 |
| after/3 | 10.791 | 716.260 | 28.055 | 852.708 | 1011.3 |

Median p99 674.599→662.782ms; діапазони647.296–683.063 та648.756–716.260 перекриваються. Median average27.997→28.055ms. Тому **не заявляємо глобального прискорення або сертифікованої відсутності p99 регресії**. Нової відтвореної причинної tail regression від lazy fallback не встановлено; whole-game p99 acceptance OPEN. Endpoint hash ae7725e972216777/RNG3689456877 однакові;183facilities/60units в обох builds. Static flow/money/RNG ordering та differential economic tests збережені.

Старі Phase5 median p99: baseline42.255 / PR10 44.342 / Phase5 50.711ms — історичні результати з іншою worker completion policy, без нових запусків старої0.33 у цьому scope. Вони залишаються відкритою performance-задачею. Окремий next stage має профілювати asynchronous production mode та worker waits/AI/Chronicle, з відповідними hash/continuation controls; не лікувати їх масштабним refactor тут.

## Рішення щодо FIX08

Зберегти мінімальний lazy fallback: профільна користь повторена тричі,2500→0 calls, identical economy digest/hash/RNG, new cache/invalidation відсутні. Це НЕ закриття загального p99 backlog. Raw sorted samples, memory files, result argv, system totals/peaks і machine-readable performance_summary.json збережені. Memory не є доказом відсутності leaks.
