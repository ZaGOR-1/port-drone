# df CLI · DEV-02

> Історичний матеріал з `toolchain/dev-environment/docs/CLI_REFERENCE.md`. [Реєстр досліджень](../../INDEX.md)

Встановлення на рівні користувача в Ubuntu/WSL2. Скрипт ставить symlink, зберігає наявний файл df та друкує команду для поточного shell.

```bash
toolchain="$HOME/projects/DroneFlames/droneflames-toolchain"
"$toolchain/dev-environment/scripts/install-df"
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
df --help
```

DF_WORKSPACE_ROOT або --workspace-root задає layout workspace. За замовчуванням його визначає розташування CLI. Передавай --source для іншого checkout. Build бере зафіксований локальний Git ref, за замовчуванням HEAD. Build і run мають використовувати той самий DF_BUILD_ROOT або --build-root. Окремі runtime paths і WSL2 описано в [PORTABLE_DEVELOPMENT.md](../../l02/PORTABLE_DEVELOPMENT_FINAL.md).

```bash
df doctor --platform linux
df build --platform linux --profile official --revision HEAD
df check --platform linux
df run --platform linux --profile-dir "$HOME/df-profile"
df run --platform linux --headless --quit-after 120
df package --platform linux --format tar.gz --out "$PWD/DroneFlames-Linux-QA.tar.gz"

df doctor --platform windows --profile official
df build --platform windows --profile official --revision HEAD
df check --platform windows --profile official
df run --platform windows --profile official                    # Wine на Ubuntu

df doctor --platform windows --profile patched
df build --platform windows --profile patched --revision HEAD
df check --platform windows --profile patched
df package --platform windows --format sfx --out "$PWD/DroneFlames-SFX-QA"
df package --platform windows --verify "$PWD/DroneFlames-SFX-QA"
```

df check еквівалентний df run --check і перевіряє SHA256 та package metadata без запуску. Він бере останній успішний build вибраного профілю. Linux tar.gz пакує перевірений official ELF, PCK і Linux extensions, шлях --out має бути новим файлом. Windows SFX використовує patched build та MinGW. Official Windows build дає portable каталог EXE + DLL. Нативні Windows tools описані в [SETUP_WINDOWS.md](SETUP_WINDOWS.md).
