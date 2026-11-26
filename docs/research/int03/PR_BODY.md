> Історичний матеріал з `toolchain/int03.IGMm9Fth/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## PERF-03 та beta 0.36.2

На Linux Vulkan і RTX 4060 Laptop GPU PERF-03 скоротив підтвердження удару з 88,89 до 16,31 мс на 500/420, з 244,71 до 13,14 мс на 500/250 і з 493,77 до 8,19 мс на 500/0. GUI на 500/500 та 500/499 лишається INCONCLUSIVE. Для 500/500 headless CPU median 12,92 → 12,92 мс. Повну матрицю PERF-03 в INT-03 не повторювали. [Методика й результати PERF-03](../../perf03/PERF03_RESULTS.md)

Цільовий review PASS. Фільтри придатності, включні межі дальності, порядок призначення та причини відмов еквівалентні. Координати перевикористовуються лише в межах одного синхронного планування. Змішані та відкладені пуски перевіряють актуальний запас.

Коміт `a08f24d` підвищує `0.36.1 → 0.36.2`, синхронізує конфіг, Menus.VERSION і build guards, додає локалізовану примітку «Що нового». PROTO 7, SIM_REV v036-integration-1, Save.FORMAT 1 та NetHash збережені. Чинна перевірка повної версії вимагає однакової версії клієнтів.

## Перевірки INT-03

- Simulation 2476/2476, Python 47/47 без SKIP, version consistency та L10N PASS. Примітку меню перевірено в ru/uk/en.
- ОТРК 500/420 в SP і на хості, змішані й відкладені пуски та HUD/input PASS. Результати збігаються з PERF-03.
- DEV-02 Linux native smoke, Windows official x64 build і Wine headless smoke PASS. PCK збігається між платформами.
- Windows native QA — NOT RUN, відкладено власником. Фізичний LAN і Steam — NOT RUN.
- Автоматичний workflow виконує CI та зберігає QA-артефакти. Release job вимкнено для PR і push.

[CI кандидата — PASS](https://github.com/ZaGOR-1/port-drone/actions/runs/45455652643)

[Post-merge CI на beta — PASS](https://github.com/ZaGOR-1/port-drone/actions/runs/45456781081)
