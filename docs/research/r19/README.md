# R19 handoff

> Історичний матеріал з `toolchain/performance/r19/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

Результати і поведінка в `source/docs/r19/R19_RESULTS.md`. `SHA256SUMS` охоплює payload архіву. QA-збірки лишаються в каталозі `qa/build-result` поруч з оригінальним handoff. `evidence/official-sha256.txt` ідентифікує локальні EXE/PCK та нативні бібліотеки. Архів містить сирі дані, відтворювальні скрипти, PCK identity та перевірку вихідного дерева.

Для відтворення скопіювати `harness/` і вказати `DF_R19_BASE` на чистий worktree beta `93bd6af`, `DF_R19_SOURCE` на worktree R19, `DF_R09_TOOLCHAIN` на каталог з `official-4.7.2/godot`, `DF_R09_RUNTIME` на готовий Linux INT-10 runtime. Для editor fixtures використовується локальний `linux-native/runtime` із debug Steam/WebRTC. X11/Vulkan harness налаштовано на RTX 4060 Laptop з GPU index 1.

```bash
set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1
mkdir -p raw reports
python3 prepare.py minimal-A "$DF_R19_BASE"
python3 prepare.py minimal-B "$DF_R19_SOURCE"
python3 run-profile.py screen-dense-D5000-A D5000 --pack minimal-A --warm 45 --ticks 90 --budget 160 --dense
python3 run-profile.py screen-dense-D5000-B D5000 --pack minimal-B --warm 45 --ticks 90 --budget 160 --dense
python3 run-profile.py screen-D5000-B D5000 --pack minimal-B --warm 45 --ticks 90 --budget 160
python3 run-profile.py screen-D5000-A D5000 --pack minimal-A --warm 45 --ticks 90 --budget 160
python3 report-r19.py
bash run-series.sh
bash run-proof.sh
python3 verify-proof.py
# Після проходження gate
bash run-qa.sh
```

Для повторного аналізу даних з'єднати `harness/raw/` з `evidence/raw/`, створити `harness/reports/` та запустити `report-r19.py` і `verify-proof.py`. Початкові заміри без обмеження кешу збережено в `evidence/ungated/`. Хеші PCK фіксують конкретні запуски, файловий порядок повторної збірки може відрізнятися.
