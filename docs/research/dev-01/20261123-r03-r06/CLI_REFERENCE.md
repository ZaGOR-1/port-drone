# df · Команди

> Історичний матеріал з `toolchain/backups/20261123-r03-r06.0PbwwJ/dev-environment-cross-platform-v1.tar.zst::dev-environment/docs/CLI_REFERENCE.md`. [Реєстр досліджень](../../INDEX.md)

Python 3.12+ і стандартна бібліотека. На Ubuntu викликати scripts/df напряму або додати scripts до PATH. На Windows 11 використовувати py -3 .\scripts\df. Опції --workspace-root і --manifest ідуть перед підкомандою. CLI за замовчуванням бере корінь із DF_WORKSPACE_ROOT чи з розкладки інсталяції.

```bash
df doctor --platform windows --profile official
df doctor --platform windows --profile patched
df doctor --platform linux

df build --platform windows --profile official
df build --platform windows --profile patched --revision c91e0e6
df run --platform windows --profile patched --check
df run --platform windows --profile patched
df package --platform windows --format sfx --verify
df package --platform windows --format sfx --out "/path/to/new sfx"
```

- build за замовчуванням вибирає HEAD чистого checkout. --source вказує інший checkout, --engine-dir інший каталог pinned Linux editor і official template. Скрипт передає ці опції чинному df-windows.
- run бере останню успішну збірку вибраного профілю. --check виконує package manifest SHA256 та profile check без Wine. Запуск без --check іде в чинний QA Wine prefix.
- package без --verify працює з останньою перевіреною patched збіркою. --out вказує новий каталог. --verify [DIRECTORY] перевіряє наявний SFX, за замовчуванням artifact з paths.sfx. Ці режими взаємовиключні.
- Linux build/run/package повертають NOT_IMPLEMENTED. Doctor для Linux показує стан потрібних бібліотек і повертає BLOCKED, поки немає підтвердженого бекенду.

| Exit code | Значення |
| --- | --- |
| 0 | Команда або перевірка завершилася |
| 2 | Некоректні аргументи або manifest |
| 3 | BLOCKED, немає потрібного інструмента чи бекенду для цього host |
| 4 | NOT_IMPLEMENTED, Linux build/run/package |
| Інший | Код чинного Windows бекенду, verifier або PowerShell |

Див. також [Windows workflow](../WINDOWS_READINESS.md) та [поточні докази](CROSS_PLATFORM_BUILD.md).
