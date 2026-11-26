# Windows 11 x64 · середовище розробки

> Історичний матеріал з `toolchain/backups/20261123-dev-environment-v1.J78ugB/essential.tar.zst::droneflames-toolchain/dev-environment/docs/SETUP_WINDOWS.md`. [Реєстр досліджень](../../INDEX.md)

Встанови Git for Windows, Python, Node.js/npm, Codex CLI, PowerShell 7.4+ та офіційний **Windows editor** Godot 4.7.2. Залежності для C++ задач — Visual Studio Build Tools з Desktop development with C++, x64 MSVC, Windows SDK, за потреби x64 VC++ runtime. Для відтворення саме патченого MinGW runtime використовуй pinned Ubuntu/WSL toolchain. Встановлення MSVC не визначає еквівалентного patched профілю. [PowerShell 7 на Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) · [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio)

На новій машині віднови архів через Ubuntu або WSL2 згідно з [Ubuntu restore](RESTORE_UBUNTU.md). Для нативного checkout скопіюй перевірений `git-snapshot/port-drone.bundle` і створи окремий checkout на Windows. Для діагностичного дерева використай повний Ubuntu/WSL restore і його Git worktree links. Для профілів перенеси `official-4.7.2/`, `mingw-patched/`, `windows-dev/` і потрібний SFX у такий самий відносний layout. Шлях до Windows редактора передай явно.

```powershell
$workspace = 'D:\DroneFlames workspace'
$bundle = 'D:\Recovery\git-snapshot\port-drone.bundle'
$source = Join-Path $workspace 'port-drone'
git -c core.autocrlf=false clone --branch beta $bundle $source
git -C $source fetch $bundle 'refs/remotes/origin/main:refs/heads/main'
git -C $source remote set-url origin 'https://github.com/ZaGOR-1/port-drone.git'
Set-Location (Join-Path $workspace 'droneflames-toolchain/dev-environment')
./windows/setup-windows.ps1 -DryRun
./windows/check-windows.ps1 -WorkspaceRoot $workspace -Godot 'D:\Tools\Godot\Godot_v4.7.2-stable_win64_console.exe' -Profile patched
```

`official` і `patched` вибирають Windows Release template для PCK. QA EXE служить для fixture, редактор має власний pin. Steam, WebRTC та Steam API DLL йдуть із поточного checkout/перевіреного пакета. Використовуй правильний x64 комплект. Збірки з `windows-dev/builds/**/package` можна перевірити за `SHA256SUMS.txt`; для діагностики є `Run-DroneFlames.ps1` і `Run-MultiplayerQA.ps1`. Для нативного GUI/LAN QA вимикай updater і користуйся ізольованим тестовим Windows профілем.

`df-windows`, build preflight і performance-метрики з `/proc` використовуй під Ubuntu/WSL2. Вбудовування Windows runtime у спільний build interface заплановано. Синтаксис PowerShell перевіряється в Ubuntu, нативний Windows setup/build/GUI/Steam/LAN тут має статус **NOT RUN**.
