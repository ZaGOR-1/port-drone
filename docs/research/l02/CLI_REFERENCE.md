# df · Команди

> Історичний матеріал з `toolchain/l02-portability.H0BQrG/Перевірка overlay/dev-environment/docs/CLI_REFERENCE.md`. [Реєстр досліджень](../INDEX.md)

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
- Linux L01 official підтримує doctor, build, run і run --check. Пакет для користувачів повертає NOT_IMPLEMENTED. Patched або відсутні pinned assets повертають BLOCKED. [Linux L01](../l01/L01_LINUX_PACKAGE.md)

| Exit code | Значення |
| --- | --- |
| 0 | Команда або перевірка завершилася |
| 2 | Некоректні аргументи або manifest |
| 3 | BLOCKED, немає потрібного інструмента чи бекенду для цього host |
| 4 | NOT_IMPLEMENTED, Linux build/run/package |
| Інший | Код чинного Windows бекенду, verifier або PowerShell |

Див. також [Windows workflow](../dev-01/WINDOWS_READINESS.md) та поточні докази (`CROSS_PLATFORM_BUILD.md`).

## Linux L02 · Локальна розробка

Linux official пакує PCK із зазначеного Git ref через спільний `tools/packproj`.
Потрібні pinned Linux editor, ELF і Linux extensions. Готовий Windows пакет
більше не є передумовою. `linux-native/latest-l02` вказує на останній успішний
L02 build. Попередня L01 збірка через `latest` доступна до першого L02 build.

```bash
df doctor --platform linux
df build --platform linux --profile official --source /path/to/checkout --revision HEAD
df run --platform linux --profile official --check
df run --platform linux --profile official --profile-dir "/path/with spaces"
df run --platform linux --renderer gl_compatibility
GODOT_WAYLAND_DISABLE_LIBDECOR=1 df run --platform linux --display-driver wayland
```

Типовий запуск використовує X11/XWayland і Vulkan Mobile, ізольований XDG
профіль `linux-native/profiles/cli-l02` та успадковує вибір GPU від середовища.
Linux run замінює процес CLI через exec, тому повертається код гри.

Параметри розміщення toolchain, build roots і native Windows host launch з WSL2 описано в [переносимому workflow](PORTABLE_DEVELOPMENT_OVERLAY_CHECK.md).
