# DroneFlames R01 — виміряний baseline

> Історичний матеріал з `toolchain/performance/PERFORMANCE_BASELINE.md`. [Реєстр досліджень](../INDEX.md)

**PARTIAL.** 2–3 FPS не відтворено. Виміряно Wine GUI з наземним боєм та двома синтетичними сейвами. У 20 прогонах і 5 880 кадрах немає жодного ≥333,3 мс. Найдовший кадр 196,04 мс зафіксовано у C2 з іншим розміром вікна. Причина історичного просідання потребує реального checkpoint. Ранги підсистем і план наведено в [PERFORMANCE_BOTTLENECKS.md](PERFORMANCE_BOTTLENECKS.md) та [OPTIMIZATION_PLAN.md](OPTIMIZATION_PLAN.md).

## Середовище й відтворення

Ubuntu 26.04.1 LTS, Ryzen 5 7640HS, RTX 4060 Laptop GPU, NVIDIA 595.99.02, 16 GB RAM, Wine 10.0. Windows x64 Godot `4.7.2.stable.custom_build.ed1daf0bf`, Vulkan 1.4.329 Forward Mobile на NVIDIA. Розмір вікна в основних парах 1280×720, VSync вимкнено, cap 60. Зафіксовано фактичний розмір вікна наприкінці кожного прогону. Початкові параметри в results/summary.json та `runs/<run>/metadata.json`.

Production worktree `/home/zagor/projects/port-drone`, чиста `beta` на `c91e0e6a7eef831687e6e63550560bba739a6b87`. Діагностика в detached worktree `performance/source` на тому самому HEAD. `v0.36.0`, PROTO 7, SIM_REV `v036-integration-1`, Save Format 1. Подано diff (`R01_DIAGNOSTICS.patch`). Windows-кандидат зібрано штатним `tools/build.py` в ізоляції з готового patched Release template. `df-windows` вимагає чистий revision, тому для незакоміченого діагностичного diff викликано underlying packer. Під час налагодження виправлено конфлікт імені GDScript і порядок підготовки війни. Усі фінальні прогони мають один SHA256 EXE `d76742f23d81d40743db04f7555f963824b59c7a1ecfed4782252043e930adc3`. Provenance (`BUILD_PROVENANCE.json`) · Хеші EXE і DLL (`package/QA-SHA256SUMS.txt`)

```bash
cd /home/zagor/projects/droneflames-toolchain/performance
(cd package && sha256sum -c QA-SHA256SUMS.txt)
python3 run_r01.py A runs/local-a
python3 run_r01.py B runs/local-b
python3 run_r01.py C runs/local-c
python3 run_r01.py C runs/local-c-540p --width 960
python3 run_r01.py C runs/local-c-uncapped --fps-cap 0
python3 run_r01.py C runs/local-c-headless --headless --fps-cap 0
python3 run_r01.py D runs/local-d --save checkpoints/aged-1800/synthetic.save
python3 summarize_r01.py runs --out results
```

Запускай послідовно з новими назвами вихідних каталогів. Для стабільного порівняння не змінюй zoom, вікно або фокус під час прогонів. Скрипт створює окремий `wine-r01/`, копіює вхідний save, встановлює 75 с timeout та перевіряє RSS процесу з лімітом 2,5 GB. `--warm` приймає 20–600 кадрів, `--frames` 60–1200, `--timeout` до 180 с. `--coarse` лишає верхньорівневі таймери, `--counters-off` збирає лише frame/workload і renderer counters. `--adaptive` відновлює штатний SP frame delta. Поза запуском з `DF_R01_CASE` діагностичні таймери та фіксований крок вимкнені. У діагностичному EXE залишаються guard branches та прості обгортки викликів, їхній нульовий overhead окремо не встановлено.

Для реального D передай шлях до копії штатного SP save з важким боєм. Перший автоматичний replay бере стан і камеру зі snapshot. За потреби відтвори ту саму сцену з `--adaptive`. Зовнішній запис кадрів і GPU/CPU trace під Wine або на native Windows потрібні для ручного відтворення зі сценарієм дій/камери. Збирай дані від моменту перед просіданням. Приватну копію save з вихідного каталогу не додавай до публічного звіту.

## Сценарії й статистика

Map seed **20261016**, RNG seed **91234**. A–C використовують карту **1024×1024**. За замовчуванням 60 кадрів прогріву після побудови/restore, 240 кадрів вимірювання та діагностичний SP dt 1/60. Вікно C-wide-warm збільшено до 180/360 кадрів. C-adaptive використовує штатний dt. Кадри за часом початку сусідніх `process_frame` виміряно монотонним `Time.get_ticks_usec()`. FPS = число кадрів / час усієї вибірки. p50 — медіана, p95/p99 — nearest rank.

| Сценарій і повтори | Навантаження | FPS | p50 мс | p95 мс | p99 мс | max мс | Середній sim мс/кадр |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A1 / A2 | 6 наземних, 2 боти, ~29,3 тис. об'єктів, без бою | 57,98 / 60,03 | 16,65 / 16,67 | 17,49 / 16,75 | 48,38 / 16,80 | 100,34 / 17,75 | 0,687 / 0,696 |
| B2 / B3 | 72→50 наземних, два накази по 36, 4 боти, 1 війна, до 18 снарядів у врахованих чергах | 59,11 / 60,00 | 16,67 / 16,67 | 17,24 / 16,89 | 22,25 / 18,18 | 71,77 / 44,64 | 1,395 / 1,393 |
| C1 / C3 | 192→153 наземних, 48–120 у non-idle, два накази по 96, 16–48 із ціллю, до 50 снарядів, 4 боти, 1 війна, ~29,9 тис. об'єктів | 60,01 / 60,02 | 16,66 / 16,67 | 17,07 / 16,78 | 24,90 / 20,00 | 26,71 / 28,90 | 2,166 / 2,183 |
| D1 / D2 | 420 симс, 24 idle наземних, 61 споруда, 22 міста, 1 дрон | 58,94 / 54,17 | 16,66 / 16,67 | 17,43 / 17,79 | 26,03 / 80,67 | 86,42 / 99,15 | 0,938 / 0,909 |
| D1800-1 / D1800-2 | 1800 симс, 66 наземних (4–8 non-idle), 201 споруда, 32 міста, 24 дрони, 6 літаків, 2 війни, 33 407 об'єктів | 60,04 / 60,04 | 16,67 / 16,67 | 16,74 / 16,75 | 18,55 / 19,97 | 24,41 / 25,98 | 2,055 / 2,109 |
| D1800-live | Той самий save, adaptive SP, 180 кадрів прогріву і 1 200 кадрів вибірки | 60,00 | 16,67 | 16,75 | 16,82 | 35,94 | 1,843 |

A — один штатний barracks з 6 одиницями. B і C — відповідно 3 і 8 barracks на сторону по 12 юнітів за `Army.BARRACKS_CAP`. Використано штатний API розміщення споруд без оплати з перевіркою території, штатний spawn, контрольовані стартові позиції та штатний наказ наступу; формування армій штучне. Віддалені країни продовжували AI. C перевіряє наземні зіткнення, рух, acquisition та снаряди. У його вибірках відсутні літаки, флоти й ударні дрони; високонавантажений повітряний бій і масова ППО — NOT RUN. Місткість армії виміряно в межах barracks, оцінки глобального ліміту немає. Історичний профіль у `docs/performance.md` мав 234 наземні після години на 2048×2048, але той save у доступних тестових матеріалах відсутній.

D використав однакові байти локальних синтетичних saves для кожної пари. Генерація в окремому XDG-профілі офіційним редактором на вихідному PCK, крок 0,2 симс, штатний Save, після цього Windows Restore у Wine. Це прискорене накопичення стану, без послідовності дій живого гравця. Зростання tick cost між 420 та 1800 симс видно, сталого падіння медіани кадру в цій парі немає. Фактичні user saves не шукали і не змінювали. Для нового синтетичного save виконай `python3 generate_aged.py checkpoints/local --seconds 1800`.

C-low пройшов із таким самим start/end NetHash, як C1. Render metrics в основному C були ~379–383 draw calls за медіаною, ~0,93–0,98 мс root viewport render CPU p95 і ~0,33–0,55 мс GPU p95. C uncapped мав середнє 122 FPS і p50 6,36 мс, A uncapped — 354 FPS і p50 2,60 мс, але при цьому змінюється час успадкованих visual/worker callbacks та GPU cadence. C headless p50 6,97 мс і sim mean 2,08 мс залишаються діагностичними значеннями; hash від GUI відрізнявся. Вони не вимірюють rendered FPS та не дають ізолювати GPU шлях від інших витрат. C2 з кінцевим вікном 1853×1011 збережений як спостереження, виключений з основної пари. Повний розподіл порогів ≥33,3/50/100/333,3/500 мс — у CSV.

## Що і як вимірювали

- SP `GameWorld._process` у грі має adaptive substeps із номіналом 0,2, максимум 8 і budget 12 мс. `NetSession._run` для MP має `SIM_DT=1/30`, три ticks/turn і власний budget; MP — NOT RUN у R01. `_sim_step` послідовно запускає військові, економічні, world й AI підсистеми. Окремо від sim frame виконує road poll, Vision, texture flush і visual/UI callbacks.
- Таймери R01 на головному потоці агрегують систему, вкладені рух/пошук цілей/бій/снаряди/частину pathfinding, visual callbacks і кількість викликів. Запис у JSON після вибірки. Профіль не виконує додаткових операцій у worker threads. Тривалість асинхронних worker jobs із чинних логів лишається окремою від main scopes. Це wall time, який може включати очікування.
- Прямі viewport timestamp API Godot для CPU render/GPU, frame setup CPU та draw calls. Інструменти не вимірюють загальний GPU frame/present latency, driver queue або весь CPU процес по кадрах. Renderer timing може відповідати раніше завершеному кадру. Main GDScript scopes, render timing і worker intervals не складаємо в один бюджет.
- Workload записується кожні 15 кадрів. Non-idle — живий Unit зі state, відмінним від IDLE, зокрема MOVE/FIGHT/SIEGE; юніти з валідним target рахуються окремо. Projectiles — наземні shells/rockets/grenades, Defense shots, missiles і AAM. Це вибрані черги, без VFX, усіх navy/arty queues та tracer counts. Ground-in-view — камера `_on_screen`, render objects — engine root viewport. Map objects — активні слоти map registry. Вони не взаємозамінні.
- Release `Performance.MEMORY_STATIC` повернув нуль. Для RSS, swap і CPU процесу збережено `host_process.json` з `/proc` раз на 250 мс. GPU-пам’ять і алокації per frame — NOT RUN. Процес Windows гри у виміряних C1/C3 мав ~1 955–1 957 MiB peak RSS, опитування не виявило VmSwap. Це не виключає короткі алокації або тиск пам'яті на хості. Повні scheduler/lock/contention метрики недоступні через perf permissions.
- У production вже є `ui/perf_probe.gd`, `GameWorld.perf_prof/perf_sys/sim_ms/perf_job_wait_max`, Vision timings, `VfxBlast.cost_us`, road/job логи та `tools/performance_benchmark.gd`. R01 перевикористовує межі `GameWorld._pf` й додає raw per-frame wall time, вкладені scopes і viewport timestamps. Штатний probe зберігає максимуми per key та застосовує додаткову теплову пробу, тож він не є взаємозамінним із R01.

## Коректність і файли

- Штатна simulation regression на ізольованому діагностичному дереві, офіційний Linux editor — **2476/2476 PASS**. Це тести source/стану. Wine headless зі змінним `DF_R01_CASE` відсутнім пройшов звичайний boot і не створив `r01.json`. Regression JSON (`results/regression/regression.json`)
- A1/A2, B2/B3, обидві пари D збіглися за start/end NetHash. C1/coarse/counters-off мали однакові обидва hashes, що контролює вплив таймерів у цій парі. C3 починав із відмінним hash, але збігся наприкінці з C1. C2 і headless мають відмінності, тому bitwise SP replay під різними render/worker schedules не встановлено. Живий двопірний MP, Steam/LAN і native Windows — NOT RUN. Diff не змінює save layout, RPC, версії й core order. Production `beta` лишилася чистою.
- Зведення CSV (`results/summary.csv`), детальні метрики JSON (`results/summary.json`), активні юніти і frame time (`results/frame_vs_active.csv`). Сирі rows у `runs/<run>/frames.json`; логи Wine, Godot та CPU/RSS поряд. Пізніші визначені контрольні точки слід архівувати окремо від приватних користувацьких saves.
