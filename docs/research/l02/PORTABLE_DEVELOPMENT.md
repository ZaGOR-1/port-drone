# Переносиме середовище DroneFlames · L02

> Історичний матеріал з `toolchain/l02-portability.H0BQrG/PORTABLE_DEVELOPMENT.md`. [Реєстр досліджень](../INDEX.md)

Один Git remote і одна історія. Робочі гілки створюються від актуальної beta за правилами AGENTS.md. Для Godot editor/import використовуй фізичну shadow-копію проєкту. Звір джерело версії в `game/pc/version.cfg` та `Menus.VERSION`. Linux і Windows пакують спільний PCK.

| Середовище | Робочий процес | Статус L02 |
| --- | --- | --- |
| Нативна Ubuntu x86_64 | Git, Codex CLI, pinned Linux Godot editor. `df` збирає Linux ELF/PCK і Windows EXE. Windows smoke через Wine за потреби. | Перенесена збірка і перевірка обох пакетів пройшли. Linux headless пройшов. |
| Windows 11 + WSL2 Ubuntu x86_64 | Репозиторій, toolchain і staging на Linux filesystem під `~/projects`. Спільний Linux builder. Windows QA-пакет копіюється на Windows диск і запускається через PowerShell interop. Linux GUI через WSLg, якщо доступний. | Перевірено архітектуру, передачу параметрів і логіку handoff. Фактичні WSL2, native Windows interop і WSLg NOT RUN. |
| Нативна Windows 11 x64 | Git for Windows, PowerShell, Python, Node/npm, Codex CLI і Windows Godot editor. Checkout на NTFS. `check-windows.ps1` перевіряє локальні інструменти. Перевірений Windows EXE запускається з QA пакета. Повторювані official/patched пакети будуються через WSL2 або CI. | PowerShell syntax перевірено на Ubuntu. Нативні tools, editor і EXE на Windows NOT RUN. |

[Microsoft WSL interop і розміщення файлів](https://learn.microsoft.com/en-us/windows/dev-environment/wsl-interop) · [WSLg](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps) · Windows tools (`SETUP_WINDOWS.md`) · [Codex і MCP](../dev-01/CODEX_MCP.md)

## Відновлення

1. Перенеси перевірені Development Environment v1 Essential, Linux L01 runtime increment і L02 portability overlay. Потрібні pinned Linux editor, official Windows template, Linux ELF та .so. Для patched Windows також потрібні manifest і вже зібрані release/QA templates. Ubuntu restore (`RESTORE_UBUNTU.md`) · [L01 restore](../l01/RESTORE_L01.md)
2. У новому workspace віднови Essential і L01 за їхніми інструкціями. Звір SHA256. Розпакуй `DroneFlames-L02-portability-overlay.tar.gz` поверх **цієї відновленої копії** toolchain. Tar зберігає LF і executable bits. Через exFAT/NTFS перенось сам архів, а executable tooling розпаковуй у Linux FS. Цілісність binary pins перевіряється перед пакуванням. Перебудова Godot для наявних сумісних assets не потрібна.
3. У відновленому Git checkout звір remote, виконай `git fetch origin`, потім `git merge --ff-only origin/beta` на чистій локальній beta. Для окремого native Windows checkout використовуй той самий remote або bundle. Звір `git rev-parse HEAD`, а з незакоміченими правками працюй через Git diff або збережений snapshot. Два інструменти на різних ОС мають власні локальні checkouts тієї самої історії.
4. Встанови потрібні платформні залежності. Codex CLI зручно запускати в тому самому середовищі, де лежить його checkout. Додай MCP з наявних шаблонів за потреби, перевір `codex mcp list` і застосовуй поточний AGENTS.md. Платформні редактори та MCP binaries добирай для відповідної ОС. Auth відновлюй локально.
5. Для WSL2 розпаковуй workspace у Linux FS. У Windows використовуй окремий checkout або пакет на NTFS. У WSL2 звертайся до Windows диска для передачі готових QA-файлів. Для WSLg спочатку звір наявність `DISPLAY` або `WAYLAND_DISPLAY` і renderer у логу Godot. За доступного XWayland можна окремо спробувати `--display-driver x11 --renderer gl_compatibility`. Headless не вимагає desktop.

## Build і запуск

`--workspace-root` або `DF_WORKSPACE_ROOT` задає спільний layout. `--source` приймає checkout в іншій папці. `--engine-dir` приймає каталог pinned Linux editor і, для Windows, official template. `DF_LINUX_RUNTIME_DIR` задає каталог Linux ELF/.so, `DF_WINDOWS_PATCHED_RUNTIME_DIR` — каталог patched Windows manifest і assets. `--build-root` або `DF_BUILD_ROOT` задає спільний корінь з окремими `linux/` та `windows/`. Передавай той самий build root для build і run.

```bash
workspace="$HOME/projects/DroneFlames workspace"
toolchain="$workspace/droneflames-toolchain"
DF="$toolchain/dev-environment/scripts/df"
export DF_BUILD_ROOT="$HOME/builds/DroneFlames QA"
"$DF" --workspace-root "$workspace" doctor --platform linux
"$DF" --workspace-root "$workspace" build --platform linux --source "$workspace/port-drone" --revision HEAD
"$DF" --workspace-root "$workspace" run --platform linux --check
"$DF" --workspace-root "$workspace" run --platform linux --headless --quit-after 120
"$DF" --workspace-root "$workspace" build --platform windows --profile official --source "$workspace/port-drone"
"$DF" --workspace-root "$workspace" run --platform windows --profile official --check
```

Linux build читає Git archive вибраного commit з явними `core.autocrlf=false` і `core.eol=lf`. Windows build створює ізольований checkout з `core.autocrlf=false`. Обидва маршрути використовують байти джерела з Git. Текстові CRLF робочої копії та executable bits архіву перевірено окремо.

**Запуск Windows EXE з WSL2.** Коли interop і `wslpath` доступні, створи батьківський каталог на Windows диску. Передай новий дочірній каталог у формі Linux-шляху. Команда копіює лише QA-файли, перевіряє SHA256 і викликає `Run-DroneFlames.ps1` через нативний PowerShell. Wine для цього шляху не потрібен.

```bash
windows_qa="/mnt/c/Users/<Windows user>/DroneFlames QA"
mkdir -p "$windows_qa"
"$DF" --workspace-root "$workspace" run --platform windows --profile official \
  --windows-host-out "$windows_qa/0.36.1"
```

Якщо interop вимкнений, перенеси перевірений package на Windows диск. У Windows виконай `pwsh -NoProfile -File .\Run-DroneFlames.ps1` з папки пакета. Для нового тестового прогону використовуй окрему копію QA-пакета з власними logs і профілем. Нативний Windows запуск і WSLg потрібно підтвердити в DEV-02.
