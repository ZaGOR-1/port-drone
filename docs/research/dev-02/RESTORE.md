# Development Environment v2 · відновлення і перенесення

> Історичний матеріал з `toolchain/dev02.tMRUbu/Development-Environment-v2/RESTORE.md`. [Реєстр досліджень](../INDEX.md)

Комплект відновлює beta 0.36.1 на commit 11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b. GitHub для відновлення не потрібен. Запас для розпакування і тестових збірок — 12 ГБ. Архіви переносимо файлами. Виконувані файли розпаковуємо в Linux filesystem, щоб зберегти права. Приватні облікові дані й реальні збереження відновлюються окремо.

## Копіювання

У поточному Ubuntu відкрий цей каталог як робочий і підстав шлях до вже змонтованого носія. Команда створює новий каталог, копіює всі рядки BACKUP_FILES.tsv і звіряє SHA256. Команда не перевикористовує каталог, який уже існує.

```bash
handoff="$PWD"
target="/media/$USER/Мій носій/DroneFlames-DEV02"
bash "$handoff/copy-dev02.sh" "$target"
(cd "$target" && sha256sum -c --strict SHA256SUMS.txt)
```

На носії потрібні v1/ з Essential, старими bootstrap-файлами та checksum manifest, l01/ із Linux runtime та наявним extractor, l02/ з overlay, dev02/ зі змінами і Git increment, а також restore-dev02.sh і SHA256SUMS.txt. BACKUP_FILES.tsv містить SHA256, розміри й поточні абсолютні шляхи. INT-01 ZIP для майбутнього фізичного QA можна перенести додатково, перевіривши за OPTIONAL_QA_FILE.tsv. Його не використовує restore.

## Нативна Ubuntu x86_64

Перевір наявність Git, Bash, Python 3.12+, zstd, tar та coreutils. Для Wine smoke знадобляться Wine і його host dependencies. Для Windows SFX потрібен MinGW-w64 POSIX та binutils. На чистій підтримуваній Ubuntu команди нижче встановлюють ці залежності після явного ручного підтвердження адміністратора. Versions та перелік додаткових інструментів є в dev-environment/manifests/environment.json і setup-ubuntu.sh --dry-run.

```bash
sudo apt update
sudo apt install ca-certificates curl git python3 zstd tar coreutils unzip rsync
# За потреби для Windows smoke і SFX
sudo apt install wine wine64 g++-mingw-w64-x86-64-posix binutils-mingw-w64-x86-64

media="/media/$USER/Мій носій/DroneFlames-DEV02"
workspace="$HOME/projects/DroneFlames"
mkdir -p "$(dirname "$workspace")"
(cd "$media" && sha256sum -c --strict SHA256SUMS.txt)
bash "$media/restore-dev02.sh" "$workspace"

toolchain="$workspace/droneflames-toolchain"
"$toolchain/dev-environment/ubuntu/setup-ubuntu.sh" --dry-run
"$toolchain/dev-environment/scripts/install-df"
export PATH="${XDG_BIN_HOME:-$HOME/.local/bin}:$PATH"
export DF_BUILD_ROOT="$workspace/QA вихід"
df doctor --platform linux
df doctor --platform windows --profile official
df doctor --platform windows --profile patched
df build --platform linux --revision HEAD
df check --platform linux
df run --platform linux --headless --quit-after 120 --profile-dir "$workspace/QA профіль"
df build --platform windows --profile official --revision HEAD
df check --platform windows --profile official
df build --platform windows --profile patched --revision HEAD
df check --platform windows --profile patched
```

Для Linux GUI запуск без --headless. Якщо host не має потрібних бібліотек, перевір df doctor та ldd на ELF і .so з linux-native/runtime. Якщо df перенесений після встановлення symlink, встанови його з нового шляху в інший bin-каталог або прибери лише свій застарілий symlink після перевірки його цілі.

Інсталятор друкує команду для поточного PATH. Постійний PATH можна додати вручну після збереження копії своєї shell конфігурації. У worktree для редагування користуйся тим самим AGENTS.md. Godot editor/import запускай лише у фізичній shadow-копії гри. Для новішої beta після відновлення baseline спочатку виконай git fetch origin, перевір refs і використовуй git merge --ff-only origin/beta лише на чистій локальній beta.

## Windows 11 + WSL2 Ubuntu

1. У PowerShell перевір wsl --list --verbose. Для нового середовища вибери доступну Ubuntu через wsl --list --online та wsl --install -d Ubuntu. Для WSLg онови WSL через wsl --update. Підтвердь, що дистрибутив має версію 2. [Microsoft WSL installation](https://learn.microsoft.com/en-us/windows/wsl/install)
2. У WSL Ubuntu виконай кроки відновлення вище. Для media передай смонтований Windows диск, наприклад /mnt/d/DroneFlames-DEV02. Для workspace залиш шлях під $HOME/projects у Linux filesystem. Бінарні залежності й Git відновлюються з пакета. Для незалежного мережевого checkout, якщо потрібен, використовуй git clone --branch beta https://github.com/ZaGOR-1/port-drone.git і передай його через df build --source. [Розміщення файлів у WSL](https://learn.microsoft.com/en-us/windows/wsl/filesystems)
3. Збери Windows official у WSL. Щоб запустити EXE нативно, створи батьківський каталог на Windows диску і передай новий дочірній каталог. df скопіює QA файли, перевірить їх та викличе PowerShell на Windows-хості. Для повтору вибери інший дочірній каталог.

```bash
windows_qa="/mnt/c/Users/<Windows user>/DroneFlames QA"
mkdir -p "$windows_qa"
df run --platform windows --profile official --windows-host-out "$windows_qa/0.36.1"
```

Якщо interop вимкнений, скопіюй вміст перевіреного Windows package на Windows диск. З PowerShell у цій папці виконай pwsh -NoProfile -File .\Run-DroneFlames.ps1. Для WSLg перевір DISPLAY або WAYLAND_DISPLAY, запусти Linux GUI і звір renderer у логу. За доступної XWayland-сесії режим діагностики можна явно вибрати через --display-driver x11 --renderer gl_compatibility. Фізичний WSL2, WSLg і Windows native запуск мають статус NOT RUN. [Microsoft WSLg](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)

## Нативні Windows 11 development tools

Встанови Git for Windows, PowerShell 7.4+, відповідні Python/Node.js та Codex CLI за dev-environment/docs/SETUP_WINDOWS.md. Для доступного GitHub зроби окремий checkout на NTFS з того самого remote, beta і commit. Для offline відновлення спочатку створи verified checkout у WSL, із нього можна отримати звичайний Git bundle для Native Windows. Доступ до Git, Codex і MCP налаштовується локально. AGENTS.md залишається тим самим.

Отримай готовий Windows x64 Godot **editor** тієї ж версії 4.7.2 та задай DF_GODOT. В архівах є Windows export templates і Linux editor. Windows editor — окрема готова залежність. Якщо потрібно її перевезти, окремо збережи офіційний бінарний файл та SHA256.

```powershell
$env:DF_GODOT = 'C:\Tools\Godot 4.7.2\Godot.exe'
pwsh -NoProfile -File .\dev-environment\windows\setup-windows.ps1 -DryRun
pwsh -NoProfile -File .\dev-environment\windows\check-windows.ps1 -WorkspaceRoot 'C:\Projects\DroneFlames'
git -C 'C:\Projects\DroneFlames\port-drone' status --short --branch
codex mcp list
```

Команди PowerShell запускаються з Windows-копії toolchain поруч із checkout. Відтворювані Windows builds ідуть через WSL2 або наявний CI. Windows QA package запускається через Run-DroneFlames.ps1. Доступ до приватних тестових середовищ вводиться окремо за потреби.

Для офлайн Git checkout у нативній Windows після restore можна перенести повний bundle beta з WSL на Windows диск. Команди нижче запускаються відповідно у WSL і PowerShell. Підстав для них той самий Windows диск та каталог.

```bash
git -C "$workspace/port-drone" bundle create /mnt/d/DroneFlames-beta.bundle beta
```

```powershell
git -c core.autocrlf=false clone --branch beta 'D:\DroneFlames-beta.bundle' 'C:\Projects\DroneFlames\port-drone'
git -C 'C:\Projects\DroneFlames\port-drone' remote set-url origin https://github.com/ZaGOR-1/port-drone.git
```

Для перевірки Windows bootstrap потрібні також файли dev-environment/windows, його manifests і обраний runtime з manifest. Розміщення за замовчуванням — у C:\Projects\DroneFlames\droneflames-toolchain поруч із port-drone. runtime та manifest можна скопіювати з уже відновленого WSL workspace. Параметр -Profile patched перевірить pinned patched release EXE.
