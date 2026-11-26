# PERF-HOST-01 · HOST_NOT_READY

> Історичний матеріал з `toolchain/performance/perf-host-01.ZAytfEP7/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

Дата 2026-11-25, Europe/Kyiv. Виконано один preflight за R17C, exit 3. Джерела R17C та R18B містять побайтно однакові `host.py` та `monitor.py`. Маніфести політики й harness пройшли SHA256. Команда з каталогу R17C:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 host.py /home/zagor/projects/droneflames-toolchain/performance/perf-host-01.ZAytfEP7/raw/preflight 60
```

| Критерій | Спостереження |
| --- | --- |
| 60 односекундних інтервалів | PASS, 60 відліків за 60,041 с. Фактичні інтервали 0,9985–1,0015 с. |
| Сторонній CPU ≤19% у кожному інтервалі | FAIL, 25,33–60,33%, медіана 35,37%. Усі 60 інтервалів понад 19% і понад 23%. |
| Розмах CPU ≤8 п.п. | FAIL, 35,00 п.п. |
| Memory PSI some | PASS за правилом двох послідовних інтервалів понад 2%. Є один такий відлік, №51, максимум 5,319%. |
| CPU <80 °C та GPU <70 °C | PASS, CPU 66,38–71,00 °C, GPU 45–48 °C. |
| Наявні сигнатури стороннього benchmark/build/packaging | Збігів 0. QEMU/KVM підтверджено. Навантаження всередині гостьової ОС з хоста не встановлено. |
| Різниця A/B ≤3 п.п. | NOT RUN, 0 пар. |

Ubuntu 26.04.1 LTS, Linux 7.0.0-44-generic, 12 logical CPUs, affinity 0–11. За знімками живлення від мережі (`ACAD/online=1`), профіль `balanced`. Runnable tasks 5 медіана, 20 максимум. Найвищий відлік окремого logical CPU 82,65%. Середня частота CPU за відліками 3,32–4,68 ГГц. RTX 4060 Laptop GPU, graphics 270–1020 МГц, memory 405–7001 МГц, usage 3–52%. Swap-in 33 351 сторінка (130,28 MiB), swap-out 48 384 (189 MiB), сторінка 4096 B. PSI full за додатковим розрахунком до 4,84%.

## Процеси й потоки

Наведено CPU-секунди за 60 с з `largest_other`, який зберігає до десяти назв на інтервал. Це діагностичні оцінки за записаними відліками.

| Процес | CPU-с |
| --- | ---: |
| QEMU/KVM, гість win11 | 102,18 |
| Chrome | 85,80 |
| VS Code | 48,11 |
| localsearch-3 | 14,42 |
| Discord | 7,07 |
| Codex | 3,01 |
| Steam і steamwebhelper | 0,75 |

У піковому інтервалі QEMU, Chrome та VS Code дали 365%, 151% та 108% від одного logical CPU відповідно. Позасерійний `pidstat -u -t 1 5` зафіксував QEMU PID 225417 з 240,96% одного CPU. Чотири головні KVM-потоки споживали 81,54%, 47,31%, 45,58% і 47,88% кожен. У тому самому вікні гарячі потоки GNOME Shell, Chrome та VS Code дали 65,38%, 27,50% і 24,23% відповідно. Графічні процеси, у тому числі GNOME Shell, за preflight дали 41,07 CPU-с окремо. Зафіксовані процеси Codex належали одному дереву, з двома app-server під спільним батьком. Незалежне активне завдання Codex за процесами хоста не підтверджене. Після preflight з'явився інший QEMU PID 230788 у новому scope того самого гостя.

## Методика телеметрії

- `/proc/<pid>/stat` дає `utime + stime` у тіках `CLK_TCK=100`. Різниця тіків, поділена на `CLK_TCK × Δt`, дає частку одного CPU. `unrelated_pct` множить її на 100 і ділить на 12 доступних CPU. `largest_other` показує відсотки одного CPU. `host.py` перетворює їх у CPU-секунди з урахуванням інтервалу. Для агрегації CPU використовуються лише PID процесів, TID з окремого pidstat служать для атрибуції.
- R17B runner виключає PID Godot та обгортки `/usr/bin/time`, а `monitor.py` виділяє CPU основного Python-збирача і процесів графічного стека в окремі метрики. У 60-секундному preflight ігровий процес відсутній. Безпосередні витрати Python-збирача склали 2,39 CPU-с, медіана 0,33%, максимум 0,42% від 12 CPU. Витрати дочірнього `nvidia-smi` окремо не вимірювалися.
- Збирач враховує PID з однаковим starttime на обох кінцях інтервалу. Короткоживучі процеси можуть випасти, зокрема `nvidia-smi`. Список тяжких робіт працює за сигнатурами та наявністю PID. Тому він може пропустити короткий job або роботу в гості і спрацювати на idle процес з відомою назвою. QEMU враховано в сторонньому CPU. Навіть арифметичне віднімання його округленого внеску лишає 55 із 60 зафіксованих інтервалів понад 19%. Цей розрахунок описує записані інтервали, а майбутнє навантаження після завершення VM потребує нового виміру.
- Знайдено окрему невідповідність у шестисекундному `preflight.py`. Він перевіряє розмах, температури й `other_heavy` та за опцією медіану CPU, але пропускає per-interval cap 19%, memory PSI і розширений job scan, заявлені в `readiness.md` для кожного плеча. 60-секундний `host.py` застосував свою чинну політику цілком. Пропозиція на окреме погодження — перевикористати перевірки `host.py` у короткому preflight, додати тест відповідності протоколу та окремий облік дочірніх процесів телеметрії. Історичні відліки й пороги зберігаються.

## Стан проєкту і QA

- `/home/zagor/projects/port-drone` чистий, `beta` та `origin/beta` на `d6a38e8db58361430df69ffe0a98e628acac6d8b`. `origin/main` та remote main на `172df65e3bd004efed9a5444e90a284d9d69db10`. Версія 0.36.7 підтверджена через build identity. Список 23 worktrees і stash `40a9f64be2729b80cff7d6139f9addd64a687993` звірено до й після.
- R17 у `/home/zagor/projects/port-drone-r17` на `perf/operations-membership-lookup`, HEAD `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Локальний PoC із п'ятьма GDScript-файлами та чернеткою PROJECT_STATE побайтно збігся з R17C. SHA256 diff гри `ac2c387167a8e647cbb6b9a4a4b24a74315e805a05363f88d77bebfec163b54e`. Звірено fixtures, minimal A/B, detail/proof PCK і runtime R17B, також хеші handoff R17B/R17C/R18B.
- R18A у `/home/zagor/projects/port-drone-r18` на `perf/impact-candidate-enumeration`, HEAD `6d83ef995a154e842906d2ebdb15a41c5a883ce3`, локальний diff PROJECT_STATE збігається з R18B. Нових комітів, push і PR немає.
- R17 gate **NOT RUN**, нуль нових Late E пар. Історичні D2100/D5000 профілі, детермінізм і repeated restore R17/R17B залишаються доказами в їхніх перевірених сценаріях. Детермінізм нового вікна, дисковий Save/Load, ENet, repeated restore, long-running control, official Linux/Windows builds, Linux native і Wine smoke, Windows A/B пакет та фізичний Windows QA **NOT RUN**. R18B і R19 **NOT RUN**.

Наступний крок для власника — узгодити вікно після завершення гостьової роботи Windows, зберегти роботу й призупинити активні вкладки Chrome та задачі VS Code, дочекатися завершення індексації, за наявності активності призупинити Discord/Steam. Після цього в окремому запуску виконати один 60-секундний preflight за чинними межами. Альтернатива — виділений стабільний хост з тим самим протоколом та окремо зафіксованими характеристиками. До HOST_READY R17 залишається локальним.

Сирі дані збережено в `raw/preflight/`, окрема діагностика потоків у `raw/cpu-threads-before.txt`, SHA і Git у `provenance/`. Історичні артефакти лежать у `/home/zagor/projects/droneflames-toolchain/performance/r17b.tcCPTLHp/`, `/home/zagor/projects/droneflames-toolchain/performance/r17c.bisE12lZ/` і `/home/zagor/projects/droneflames-toolchain/performance/r18b.LG5dtpLy/`.
