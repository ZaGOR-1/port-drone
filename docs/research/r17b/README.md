# DroneFlames R17B · Controlled validation

> Історичний матеріал з `toolchain/performance/r17b.tcCPTLHp/README.md`. [Реєстр досліджень](../INDEX.md)

A є beta `d6a38e8db58361430df69ffe0a98e628acac6d8b`. B є незакоміченим R17 PoC версії 0.36.7 з резервної копії (`backup/`). Перевірено точну відповідність diff та SHA256 зі збереженого handoff діагностичних PCK. R17B використовує ті самі мінімальні PCK для FPS. Додаткова інструментація тільки в окремому діагностичному пакеті. Резервна копія охоплює повний diff, оригінальні змінені файли, базову Git-ревізію і SHA256.

[Критерії приймання до запуску](CRITERIA.md) · [Висновок](R17B_RESULTS.md) · [Усі пари](PAIRS.md) · CPU, частоти, температури і RSS (`reports/controlled-host.csv`)

Сирі логи, CSV, налаштування та traces у `raw/`. Там є виключені пари. `system.csv` містить прирости CPU часу процесів, верхні десять сторонніх імен і `/proc/PID/schedstat` головного потоку. `host.csv` та `pressure.csv` походять із R17 runner. У kernel `sched_schedstats=0`, але `/proc/PID/schedstat` повертав ненульові прирости runnable wait. Відліки співвіднесено з вікном `sample_epoch_s`. `turn.total`, `tick` та scope timings експортуються рушієм як elapsed wall-clock. CPU utilization і scheduler waits взято з Linux counters. Дані viewport і render setup можуть належати різним фазам підготовки та GPU. Для wall-clock декомпозиції використано лише неперекривні `turn.total` і решту `frame_us - turn.total`.

## Відтворення

Розпакуйте в новий ізольований каталог і перевірте `sha256sum -c SHA256SUMS`. Використовуйте DEV-02 unified df та runtime з `provenance/runtime-path.txt`. Відновіть A через `git archive` в `source-A`. Відновіть B до `source-B` з тієї ж Git-бази та `backup/candidate.patch`. Для основної серії знадобляться збережені PCK R17 `minimal-A/B` з перевіреними SHA256 або їхнє відтворення через R17 `prepare.py`. Окремі старі proof/detail PCK також вказані в manifest. У `raw/*/config.json` є фактичні параметри. Початковий порядок визначено `series.sh 1 2 3 4`. Дві дозволені заміни виконано через `replacements.sh`. `targeted.sh` задає окремі пакети та lifecycle replay. Після прогонів `analyze.py`, `evaluate.py`, `tables.py` та `targeted.py` формують таблиці й звірки. Історичний raw input для `analyze.py` та перевірки хешів є в handoff R17 за сусіднім шляхом `r17.xD07pkTL`.

Перевірки оригінального дерева та історичних refs записано в `provenance/final-source.log`. Налаштування ОС і користувацькі процеси залишилися під контролем власника.
