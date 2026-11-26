# R05 · Умови benchmark

> Історичний матеріал з `toolchain/performance/r05/R05_BENCHMARK_CONDITIONS.md`. [Реєстр досліджень](../INDEX.md)

**PARTIAL.** Відтворено ігровий стан і параметри viewport. Хост не пройшов калібрування FPS. Після цього виконано тільки обмежені діагностичні прогони. Оптимізаційний A/B не проводився.

## R02 19,69 FPS проти R04 9,91 FPS

| D2100 | R02 повний | R02 у спільному вікні | R04 центральний baseline |
| --- | ---: | ---: | ---: |
| Measured ticks | 1 800 | 300 | 300 |
| Warm-up / кінцевий tick | 45 / 1845 | 45 / 345 | 45 / 345 |
| FPS | 19,69 | 18,94 | 9,91 |
| Frame p95/p99, мс | 85,80/138,31 | 108,13/152,12 | 201,62/250,97 |
| Активні юніти, медіана/пік | 875/1890 | 1696/1890 | 1696/1890 |
| Живі споруди, медіана/пік | 843/867 | 852/867 | 852/867 |
| Снаряди, медіана/пік | 68/632 | 112/632 | 112/632 |
| Видимі юніти, медіана/пік | 370/1731 | 585/1731 | 586/700 |
| Army.update, мс/tick | 16,43 | 23,14 | 41,80 |
| UnitsLayer._draw, мс/tick | 5,26 | 4,82 | 10,52 |
| Operations.update, мс/tick | 4,18 | 1,21 | 2,81 |
| Tctl max за повний запуск, °C | 79,25 | 79,25 | 91,25 |

R02 і R04 мали 1280×720 у звіті, Vulkan Mobile, uncapped, VSYNC off, Wine 10.0, той самий kernel і SHA patched template. Пік видимого workload у R02 вищий. R02 не записував camera pose та zoom у JSON і не фіксував ввід так, як R04. Стан фокусу та розмір вікна на кожному окремому кадрі R02 **NOT RECORDED**. Ці прогони не є A/B. Спільні seed 20261016/91234, 4 scripted factions + 2 AI, 2100 стартових юнітів і 1080 записів споруд. Initial NetHash `b1a480e4da8d8d82`, warm `acdbda3ae7f4f39c`, tick 300 і префікс пакетів команд збіглися. Обидва fixture згенерували свій стан за seed. Вхідний бінарний snapshot у D2100 не використовувався.

Вибірка пояснює частину 19,69 → 9,91 FPS. Після вирівнювання тиків природа симуляційного workload збігається, але витрати Army і draw зросли в різних сферах. Під час R04 були сторонні 3D-процес і Discord. Перші GPU зразки показують 0–5% і 418–579 MiB у R02 проти 80–82% і 6651–6813 MiB у R04. Це host-wide вибірки запуску. Теплові, power/clock і scheduler умови могли впливати разом. Tctl 91,25 °C сама по собі не встановлює thermal throttling. Точний внесок фону, камери, термальних умов і відмінностей EXE **не ізольовано**.

R02 та R04 A мають спільні основні таймери. R04 A має fixed-view harness і фінальний movement digest, а детальні таймери R04 P вимкнені в A. R05 P/Q додають діагностику. Overhead окремо не виміряний на стабільному хості. P/Q придатні для атрибуції підетапів у власному прогоні, їхній FPS не порівнюється як ефект змін.

## Калібрування A/A

Після першого запуску в новому ізольованому Wine prefix виконано два повтори того самого R04 A EXE на D2100. По 45 warm-up + 120 measured ticks. Однакові команди, NetHash, точний movement digest, камера, zoom і послідовність видимих та активних юнітів. У raw workload відрізнялися лічильники visual-only nodes і FX sprites. FPS **11,02 → 9,01** (−18,2%), p95 **184,81 → 208,40 мс**, p99 **215,40 → 236,07 мс**. Піки CPU 89,38/90,75 °C. Фонові процеси залишалися активними. Калібрування (`calibration-check.json`) · Хост (`host-background.jsonl`)

## Стандарт R05

Один runner із R04 і тонкий preset (`preset.sh`), один клієнт, окремий Wine prefix. C1200/D1920/D2100 — 45 warm-up + 120 measured ticks, 720/1080/1080 цільових записів споруд. E long-running — 150 measured ticks із наявного late E snapshot від tick 4650. Цей preset повторює пізній стан без багатохвилинного прогріву. Для вивчення тренду використовуються п'ять архівних вікон по 900 тиків, новий довгий E від старту **NOT RUN**.

| Pin | Значення |
| --- | --- |
| Source | `c91e0e6a7eef831687e6e63550560bba739a6b87` |
| Patched template SHA256 | `8af875561fbaf0b38151cca25dcad67e8cfcd27dc2cd920a4faa988ade8f1f93` |
| E snapshot SHA256 | `5d83751abcc0ab1cfc35141b0133b78d3982b2001dc9b2dbb8320af16131fcda` |
| GUI | 1280×720, Vulkan Mobile, uncapped, VSYNC off, fixed pose/zoom у raw |
| Pacing | `SIM_DT=1/30`, R02 canonical executor, реальний wall pacing |
| Watchdog | 105 с, RSS до 3 100 000 KiB, host MemAvailable від 1 550 000 KiB |

Для майбутнього A/B узяти однакове інструментування й camera hook з P у двох пакетах, звірити template та SHA артефактів, потім два A/A повтора на прогрітому prefix. Практичний acceptance gate для стенда — FPS до 5% різниці, p95/p99 до 10%, плюс однаковий state/presentation. Це критерій допуску, а не статистична гарантія. Скрипт `check-pair.py` перевіряє записи. У R05 він повернув FAIL для стабільності й PASS для state/presentation. Після допуску зробити одну коротку пару та один повтор зі зворотним порядком у головному сценарії. Свіжі output directories зберігають raw frame JSON і process RSS. Дані (`R05_RESULTS.json`)

Команди для повтору в нові output directories.

```bash
./preset.sh d2100 A runs/aa-1
./preset.sh d2100 A runs/aa-2
python3 check-pair.py runs/aa-1 runs/aa-2 --calibration
./preset.sh e-long P runs/late-baseline
python3 analyze.py
```

A — побайтовий R04 baseline для калібрування. P — R05 діагностичний пакет зі спільною фіксацією камери для replay E. Q — додаткові observers черги. Для нового A/B обидва варіанти мають мати однаковий фіксований harness. SHA256 і staged patches (`R05_SHA256SUMS.txt`)
