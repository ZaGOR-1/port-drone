> Історичний матеріал з `toolchain/performance/r22/handoff/harness/README.md`. [Реєстр досліджень](../INDEX.md)

Відтворити аналіз із сирих JSON/CSV, зображень і snapshots можна без запуску Godot.

```sh
cd harness
export PYTHONDONTWRITEBYTECODE=1
python3 report.py
python3 verify-visual.py visual
python3 verify-proof.py
```

Для запуску створити фізичний source-A з git archive game/ бази, зазначеної у звіті. Скопіювати в source-B і застосувати ../evidence/production.patch. DF_R09_TOOLCHAIN вказує на каталог із наявним official-4.7.2/godot, DF_R09_RUNTIME на готовий official Linux runtime INT-12. Зібрати render-A/render-B через prepare.py в новому каталозі й відтворити аргументи raw/screen-*/config.json. Скрипти run-proof.sh, run-visual.sh і run-lifecycle.sh відтворюють окремі цільові перевірки. Для GUI fixtures потрібні наявні debug GDExtension бібліотеки. Production Godot не компілюється.
