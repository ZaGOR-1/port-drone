# NATIVE-02D handoff

> Історичний матеріал з `toolchain/native-02d/handoff/README.md`. [Реєстр досліджень](../INDEX.md)

Результати, контракт пакета та оцінка A/B/C у `source/research/native-02d/README.md`. `SHA256SUMS` охоплює весь вміст архіву. `evidence/test-binary-sha256.txt` ідентифікує PCK та runtime конкретних замірів.

Для нового прогону зробити фізичну копію `harness/`. Вказати `DF_N02D_BASE` на чистий worktree beta `93bd6af`, `DF_R09_TOOLCHAIN` на каталог з `official-4.7.2/godot`, `DF_R09_RUNTIME` на готовий INT-10 Linux runtime 0.36.9 з `addons/`. Запустити `bash run.sh`. Використовується X11/Vulkan та GPU index 1 для RTX 4060 Laptop. На іншій машині звірити вибір GPU й параметри telemetry. Оверлеї фіксують точні probe scripts кожного записаного етапу. Різний файловий порядок під час пакування може змінити SHA256 повторного PCK.

Для перевірки записаних результатів з'єднати `harness/raw/` з `evidence/raw/`, створити `harness/reports/` і виконати `python3 report-advance.py`. Порівняти створений `reports/measurements.json` з `evidence/measurements.json`.
