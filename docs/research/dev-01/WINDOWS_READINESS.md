# Windows 11 x64 · Readiness

> Історичний матеріал з `toolchain/dev-environment/docs/WINDOWS_READINESS.md`. [Реєстр досліджень](../INDEX.md)

## Native Windows

Для редагування спільного Git checkout є PowerShell setup/check і вимоги до Git, Python, Node/npm, Codex, Godot 4.7.2 Windows editor та за потреби MSVC/Windows SDK. Вибір official/patched вирішує, який Windows x64 runtime pin перевіряти. Вказати редактор через DF_GODOT або параметр -Godot. Новий Python df doctor передає --workspace-root і --profile наявному check-windows.ps1 через pwsh. На Ubuntu обидва PowerShell скрипти пройшли parse. Native Windows запуск bootstrap, збірка та відтворення patched runtime — NOT RUN.

Native build/run/package через новий CLI повертають BLOCKED. Для локального GUI використовується перевірений Windows EXE, усі три DLL і Run-DroneFlames.ps1 з QA пакета. Для Steam QA потрібні реальний клієнт і Run-MultiplayerQA.ps1 у режимі Steam (у цій гілці скрипт прибирає DF_STEAM_MOCK). df-windows run передає DF_STEAM_MOCK=0. Поточний SteamNet читає будь-яке непорожнє значення як запит mock, тому звичайний запуск через цей адаптер не перевіряє реальний Steam. LAN/Steam між фізичними клієнтами — NOT RUN. [Bootstrap](docs/SETUP_WINDOWS.md)

## Ubuntu або WSL2

На Ubuntu x86_64 відтворено обидві збірки й SHA256/identity checks. Пакування гри використовує Linux editor, Git, Python і GNU sha256sum. Wine залучається для run без --check. MinGW POSIX потрібен для побудови нового SFX launcher або повторної компіляції patched runtime. Готовий patched template у звичайній збірці копіюється та перевіряється. Встановлення Wine на Windows не потрібне.

WSL2 використовує той самий Linux backend. Власний WSL2 прогін NOT RUN. Для QA можна передати Windows package у native Windows, а Linux editor/інструменти тримати у файловій системі WSL2. Play/GUI у Wine залежить від WSLg. Єдині hardcoded абсолютні шляхи у розглянутому workflow — історичні аргументи компіляції MinGW/ANGLE/AccessKit у BUILD_MANIFEST.json. Вони є provenance. Свіжий pack використав інший workspace зі шляхом із пробілами.
