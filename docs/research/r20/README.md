> Історичний матеріал з `toolchain/performance/r20/handoff/harness/README.md`. [Реєстр досліджень](../INDEX.md)

Поточні вимірювання можна повторно обчислити без запуску гри.

```sh
cd harness
PYTHONDONTWRITEBYTECODE=1 python3 report.py screen-D5000-A screen-dense-D5000-A
```

Для повтору Profile B створити фізичний каталог source-A з git archive SHA, наведеного у звіті. Вказати DF_R09_TOOLCHAIN на каталог з official-4.7.2/godot і DF_R09_RUNTIME на official Linux runtime INT-11. Запустити prepare.py minimal-A source-A, потім run-profile.py з аргументами у raw/*/config.json. Шляхи запуску повинні бути свіжими. Runtime, thread clock і SHA256 початкового PCK наведено в evidence/runtime.sha256.
