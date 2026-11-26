# Відтворення R26

> Історичний матеріал з `toolchain/performance/r26/REPRODUCE.md`. [Реєстр досліджень](../INDEX.md)

A — `1e912390394e6eafab004eb4d3ff82794dd2baeb`. B — відповідне дерево з `candidate.patch`. Профілі походять із R23, візуальний fixture — адаптація R22. `criteria.md` та його SHA256 зафіксовано до прогонів. `builds.sha256` ідентифікує точні локальні пакети та спільний runtime.

Офлайн після розпакування виконайте `sha256sum -c SHA256SUMS`, `python3 analyze-r26.py`, `python3 verify-replay.py` та `python3 verify-visual.py`. Для порівняння RGBA потрібен Pillow. Код завершення 1 візуального аналізатора означає наявність розбіжностей, якщо створено `visual-summary.json`. `paired-summary.json` містить усі пари, абсолютні метрики, парні зміни й телеметрію в межах вікна. Перевірка fixture передбачає isolated SubViewport, production outline та ground draw, контрольовану камеру й вибір армії.

Для нових прогонів використайте свіжий каталог із копіями скриптів, `clock/`, `fixtures/` і `packproj/`. Відновіть базу та окрему фізичну копію з патчем. Налаштуйте шляхи runtime в `env.sh` і Godot 4.7.2. Після `source env.sh` виконайте `mkdir raw`, `python3 prepare.py bench-A /path/to/A` та `python3 prepare.py bench-B /path/to/B`. Далі послідовно виконайте `bash run-pairs.sh`, `bash run-visual.sh` та `bash run-replay.sh`. Для `run-gates.sh` підставте власні шляхи дерев A/B. Кожна конфігурація benchmark записана у відповідному `raw/*/config.json`.

CPU scopes використовують існуючий QA clock R23 з `CLOCK_THREAD_CPUTIME_ID`. Зміни діагностичних скриптів пакуються тільки у фізичних copies. Під час benchmark зберігається звичайне навантаження desktop. XDG-профілі та ігрові бінарні збірки залишено поза архівом.
