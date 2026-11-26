# DroneFlames R17 · Ordered Unit Membership Lookup

> Історичний матеріал з `toolchain/performance/r17.xD07pkTL/README.md`. [Реєстр досліджень](../../INDEX.md)

База A `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Варіант B — зміни з `provenance/candidate.patch` у worktree `/home/zagor/projects/port-drone-r17` на гілці `perf/operations-membership-lookup`. Обидва використовують продуктову версію 0.36.7. Опис шляхів мутації в [LIFECYCLE.md](../LIFECYCLE.md), окремі пари та медіани в [TABLES.md](../TABLES.md) і ab-pairs.csv (`reports/ab-pairs.csv`).

## Методика

Native Ubuntu 26.04.1, official Godot 4.7.2, NVIDIA RTX 4060 Laptop GPU, Vulkan Forward Mobile, X11 у Wayland-сесії, 1280×720, zoom 1,111111, без VSync та ліміту FPS. Official runtime з INT-08 перевірено unified `df doctor` та SHA256. Вікна D2100 restore і D5000 restore охоплюють по 120 тіків, відповідно 4801–4920 і 946–1065. Порядок запусків A/B, B/A, A/B. Контролі охоплюють активний D2100 після 45 warmup тіків і Late E від 4650 до 4800. Команди, seed, стан камери та результат звірено у парі.

Мінімальна інструментація R16 вимірює кадри за wall-clock і тики в `GameWorld.net_step`. 1% low обчислено як обернене середнє найповільніших `ceil(N/100)` кадрів. Для перцентилів використано лінійну інтерполяцію. RSS за весь запуск взято з `/usr/bin/time -v`. Детальні CPU scopes та лічильники зібрано в окремих запусках. Показник membership CPU складається з exclusive `_army`, `membership_scan`, `membership_build` і `membership_clear`. `Operations.update` inclusive відображається окремо. Перевірка ревізій під час пошуку входить у відповідний scope. Окремий контроль обліковує оновлення ревізій у джерелах мутацій. Для native очищення наведено консервативну верхню оцінку візитів за розміром проходу побудови. Точний лічильник тимчасових алокацій рушія недоступний. Робота `strength_units` за межами внутрішнього виклику `_army` відображається в inclusive Operations, якщо відбулася в цьому виклику.

`fixtures/d2100-current.snapshot` відповідає `raw/long-D2100/state.snapshot` зі звіту R16 `detail-current4800`. Початковий хеш 4800 — `1b05f1b5ed18fc7f`. D5000 взято з `raw/long-heavy/state.snapshot` R16 на 945. Файл `fixtures/long-d2100-4800.snapshot` є окремим історичним входом R16. Late E — незмінний `late-e.snapshot`. SHA256 кожного входу є в manifest.

## Відтворення

Розпакуйте в новий каталог, щоб всі вимірювання запускалися з чистими профілями. Перевірте `sha256sum -c SHA256SUMS` до запуску. Підготуйте окремі каталоги для нового `raw` і `build`. У `provenance/runtime-path.txt` або через `DF_R09_RUNTIME` задайте шлях до перевіреного Linux runtime. Задайте `DF_R09_TOOLCHAIN=/home/zagor/projects/droneflames-toolchain`. Створіть джерело A через `git archive d6a38e8` і B через той самий archive із застосуванням `provenance/candidate.patch`. Виконайте `python3 prepare.py proof-A source-A` і `python3 prepare.py proof-B source-B`. Повторіть для `minimal-A`, `minimal-B`, `detail-A` і `detail-B` з відповідним джерелом. Запустіть `bash verify.sh`, `python3 compare_traces.py`, `bash gate.sh`, `python3 metrics.py` та `python3 tables.py`. Серія `gate.sh` не потребує інших фонових прогонів. У `raw/*/config.json` є параметри кожного виклику R16 runner.

Покрокова траса звіряє відфільтровані ID в початковому порядку, постові HP, стан Operations, watchdog, шляхи, впорядкований стан реєстру, NetHash, RNG і команди. Історичний Late E містить додаткові watchdog events. Для звірки з ним порівнюються історичні хеші, watchdog digest і той самий набір подій `apply`. Порівняння R17 A/B охоплює всі поля, зібрані однаковими probe-ами.

У відновлених headless і GUI сценаріях є штатні для цих fixtures попередження на виході про ObjectDB/resources. Їхні первинні журнали збережено. Під час діагностики лишилися також журнали невдалої опції runner і початкового порівняння історичних подій.

## Висновок

[Gate і рекомендація щодо інтеграції](../R17_RESULTS.md). Для додаткових контрольних прогонів використано `bash controls.sh source-B`. У `provenance/worktree.patch` збережено повний локальний diff із записом у PROJECT_STATE.
