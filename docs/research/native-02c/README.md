# NATIVE-02C handoff

> Історичний матеріал з `toolchain/native-02c/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

Результати й розбір семантики у `source/research/native-02c/README.md`. Архів містить сирі GUI-профілі, overlay кожного PCK, скрипти й контрольні хеші. `SHA256SUMS` охоплює вміст. Маніфест у `evidence/test-binary-sha256.txt` окремо фіксує локальні PCK і зовнішні runtime.

Виконувати з фізичної копії `harness/`. `DF_N02C_BASE` вказує на чистий worktree beta `93bd6af`, `DF_R09_TOOLCHAIN` на каталог з `official-4.7.2/godot`, `DF_R09_RUNTIME` на готовий INT-10 Linux runtime 0.36.9 з `addons/`. Harness налаштовано на X11/Vulkan, RTX 4060 Laptop з GPU index 1. Під час відтворення на іншому хості звірити вибір GPU і параметри telemetry.

```bash
set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1
mkdir -p raw reports
python3 prepare.py vision-A "$DF_N02C_BASE"
python3 prepare.py vision-exact-A "$DF_N02C_BASE"
python3 run-profile.py vision-D5000 D5000 --pack vision-A --warm 45 --ticks 90 --budget 150
python3 run-profile.py vision-dense-D5000 D5000 --pack vision-A --warm 45 --ticks 90 --budget 150 --dense
DF_N02C_EXACT_STAMPS=1 python3 run-profile.py vision-exact-dense-D5000 D5000 --pack vision-exact-A --warm 45 --ticks 90 --budget 150 --dense
python3 report-vision.py
```

Для аналізу записаних результатів з'єднати `harness/raw/` з `evidence/raw/` у відновленій копії та створити `harness/reports/`. PCK хеші ідентифікують конкретні заміри. Порядок файлів після повторного пакування може залежати від файлової системи.
