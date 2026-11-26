# DroneFlames 0.36.4 · R09 handoff

> Історичний матеріал з `toolchain/performance/r09.vlpdda5t/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

Початковий звіт і методика — [R09_BASELINE.md](R09_BASELINE.md). Матриці, контрольні режими та висновки є в [CPU breakdown](R09_CPU_BREAKDOWN.md), [GPU analysis](R09_GPU_ANALYSIS.md), [frame times](R09_FRAME_TIMES.md), [late game](R09_LATE_GAME.md) та [backlog](R09_OPTIMIZATION_BACKLOG.md).

## Відтворення

Потрібні наявні DEV-02, unified `df`, official Linux runtime із INT-05 та репозиторій із beta `d8114afac56c2475ca9ded5bd8627d4d42000041`. `provenance/runtime-path.txt` містить використаний шлях, `provenance/RUNTIME_MANIFEST.json` і `provenance/SHA256SUMS.txt` — вихідні контрольні суми. Тримайте staging на тому самому файловому томі, що й runtime, для hardlink ELF. Під час перенесення вкажіть шлях до тієї самої розпакованої збірки через `DF_R09_RUNTIME`. Для нових результатів розпакуйте handoff в окремий каталог і перемістіть каталог `raw` із записаними прогонами за межі робочого каталогу, якщо плануєте повністю повторити матрицю. Скрипти створюють нові профілі та відмовляються перезаписувати наявні run directories.

```bash
export DF_PERF_SOURCE=/home/zagor/projects/port-drone
export DF_R09_TOOLCHAIN=/home/zagor/projects/droneflames-toolchain
./portable/source r09 ./source
mkdir -p raw
python3 prepare.py minimal
./matrix.sh
./detail-suite.sh
./impact-suite.sh
python3 analyze.py
python3 render-reports.py
python3 verify-results.py
```

`fixtures/input.json` задає workload і command stream. `fixtures/late-e.snapshot` — історичний стан тика 4650. `fixtures/late-e-reference.json` — контрольна траса R08. `raw/long-D2100/state.snapshot` — фінальний стан окремого тривалого прогону. C/D/Small/Medium відтворюються з seed і fixture. Мінімальна перевірка replay після створення staging `python3 run.py verify-late late --mode headless --trace`.

`raw/<run>/result.json` зберігає покадрову трасу, початковий і кінцевий стан, commit provenance через конфігурацію, команди та workload samples. `host.csv`, списки процесів і `run.log` зберігають телеметрію та фактичний renderer. Агреговані таблиці — `R09_RAW_FRAMES.csv`, `R09_CPU_CALLS.csv`, `R09_RESULTS.json`. `instrumentation/` містить diff від незміненого `game/` для кожного staging та перелік виміряних scopes. ELF, PCK, DEV-02 й оригінальні історичні архіви залишаються в toolchain.

Перевірка `sha256sum -c SHA256SUMS.txt` виконується з кореня handoff.
