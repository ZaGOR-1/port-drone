# DroneFlames 0.36.4 · R11 handoff

> Історичний матеріал з `toolchain/performance/r11.AZ9TDOdC/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

`R11_REPORT.md` містить рішення та повну матрицю. `R11_RESULTS.json`, `R11_RAW_FRAMES.csv` й `R11_CPU_SCOPES.csv` містять зведення та сирі виміри. У кожному каталозі `raw/<run>/` збережено аргументи, форми сценарію, часові ряди, cross-check і host telemetry. `provenance/` містить diff, зафіксовані refs та відбитки runtime/PCK. `scopes/` містить таблиці таймерів. QA результати й журнали доступні під `qa/` та `platform/`. Відновлені бій і save в архіві згенеровано тестами.

Перевірка handoff виконується через `sha256sum -c SHA256SUMS.txt` із кореня розпакованого каталогу. Артефакти R10 не входять до архіву R11. На контролі використано існуючий official Linux runtime з INT-05, DEV-02 і спільні fixtures R09/R10.

Для повтору розпакувати handoff в окремий каталог під `droneflames-toolchain/performance`, зберегти фактичні `raw` і `qa` поза робочим каталогом, матеріалізувати точний baseline у `source/` та створити порожній `raw/`. Скрипти підготують PCK у фізичних копіях. Використайте той самий GPU/renderer та pinned engine, шлях до якого збережено в `provenance/runtime-path.txt`.

```bash
git -C /home/zagor/projects/port-drone archive d8114afac56c2475ca9ded5bd8627d4d42000041 | tar -x --one-top-level=source
mkdir raw
candidate=/home/zagor/projects/port-drone-r11
bash baseline.sh
bash pilot.sh
bash pilot-extra.sh
bash final-matrix.sh "$candidate"
bash check-fixture.sh "$candidate"
bash extra-repeats.sh
bash controls.sh
bash finish-qa.sh "$candidate"
python3 evidence-summary.py
python3 report-data.py
```

Для Linux/Windows smoke використовується локальна зіставлена збірка за чистим Git SHA. Власницький Windows R10 A/B ZIP лишився на місці, його вихідний SHA256 записано в `provenance/r10-kit.sha256`. Режими `minimal`, `self`, `detail`, `audit` і `trace` мають різний діагностичний overhead. `PROTOCOL.md` задає правила порівняння.
