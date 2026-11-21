# Windows EXE та два незалежні peers — наступний етап

План від2026-11-21 для нового репозиторію; **Windows build / GUI / live multiplayer NOT RUN у re-onboarding**. Він замінює операційні шляхи/SHA старого PHASE8 плану; [18 сценаріїв](WINDOWS_BETA_QA_CHECKLIST.md) використовуються повторно. Production updater заборонений для QA: repo empty + DF_NO_UPDATE=1. Не використовувати особисті saves/accounts як fixtures і не публікувати комплект.

## Phase1 — prerequisites і один точний build

Після нової команди власника зафіксувати actual beta SHA, clean source checkout/worktree та дату. Обидва peers отримують **один раз зібраний комплект**, а не дві незалежні збірки з тим самим branch name. До нього додати source SHA, engine/template version+SHA256, build argv, UTC і hashes EXE/DLL/ZIP/launchers. Документаційна dirty branch не змінює game payload, проте не підміняє погоджений beta commit для QA.

Наразі у цьому checkout немає `godot_dl/godot` та `godot_dl/windows_release_x86_64.exe`; Godot у PATH відсутній. Потрібен **Linux editor4.7.2 і matching Windows x64 release template4.7.2**. Fetch script має default4.7.2-stable, але не перевіряє digest і reuse кешу ґрунтується на існуванні; engine authenticity/version перевірити окремо за офіційними metadata. Не встановлювати іншу версію заради запуску. Наявні Windows PowerShell та WSL interop самі по собі не забезпечують engine/template.

Підтримувані командами скриптів кроки (підготовлені, **не виконані**):

```bash
# Лише після дозволу на отримання/підготовку залежностей наступного етапу:
GODOT_VERSION=4.7.2-stable python3 tools/fetch_godot.py godot_dl
godot_dl/godot --version
sha256sum godot_dl/godot godot_dl/windows_release_x86_64.exe

# Із clean checkout обраного точного beta SHA:
DF_GODOT="$PWD/godot_dl/godot" PYTHONDONTWRITEBYTECODE=1 \
  python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --godot godot_dl/godot \
  --mode regression --out dist/windows-qa/regression
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version 0.34.0 --repo "" --out dist/windows-qa/package
cp tools/qa/Run-*.ps1 dist/windows-qa/package/
sha256sum libs/*.dll
```

`0.34.0` — existing Menus label, не новий stable release або source version bump. Власник має погодити конкретний build argument; не змінювати version.cfg/Menus у source для цього. Build змінює їх лише у temp copy. Доки `.github/workflows/build.yml` відсутній, full unittest має відомий FAIL CI policy. Відновити CI окремою задачею або явно записати цей known failure у build report; не оголошувати повний suite green й не вимикати test.

[build.py](../../../tools/build.py) створює `DroneFlames.exe`, `DroneFlames-libs-r1.zip`, `SHA256SUMS.txt`. PCK вбудовується: template +64-byte alignment +PCK +12-byte size/magic trailer. Окремий PCK поруч не потрібний. Packer обійде **всі**, включно hidden, файли game/ без сортування; не запускайте editor/import у tracked game/.godot і не вкладайте туди локальні сторонні файли. Побітова reproducibility двох збірок не встановлена. Build сам перевіряє PCK magic, але не компіляцію всіх scripts/цілісність усього resource graph.

Перед передачею перевірити `sha256sum -c SHA256SUMS.txt` у package directory. Витягти DLL ZIP у тестовий каталог, перевіривши рівно три очікувані імена без дублікатів. Launcher/DLL hashes додати до окремого QA manifest: build SHA256SUMS охоплює EXE і ZIP, **не кожну DLL/launcher окремо**.

| DLL біля EXE | Bytes | Поточний source SHA256 |
|---|---:|---|
| libgodotsteam.windows.template_release.x86_64.dll |3980800|6535af56d325af0fff52dbb5de3703d110bb430fdef4e3026d7ece617270e530|
| libwebrtc_native.windows.template_release.x86_64.dll |4058112|3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd|
| steam_api64.dll |319128|8de54d32508e216c9135b8bf025749243d44e404c1c22a8e5fe35acecabe7a9c|

PE AMD64 перевірено статично; actual native load у цьому запуску NOT RUN. DLL не замінювати. Український/англійський README містять підтримувані build options; відсутній workflow не відновлювати зі старих Git branches автоматично.

## Phase2 — Windows11 single-player GUI

На writable тестовому каталозі Windows перевірити manifest:

```powershell
Get-FileHash -Algorithm SHA256 .\DroneFlames.exe
Get-FileHash -Algorithm SHA256 .\*.dll
Get-FileHash -Algorithm SHA256 .\Run-*.ps1
& .\Run-DroneFlames.ps1 -Mode Smoke
& .\Run-DroneFlames.ps1 -Mode Gui
```

Smoke — native headless240 engine iterations із120s launcher timeout; не GUI. Gui чекає ручного закриття, без такого timeout. Launcher задає process-local APPDATA/LOCALAPPDATA в test-user/{Roaming,Local}, DF_NO_UPDATE=1, DF_STEAM_MOCK=0, DF_NO_OPENING=1, DF_LANG=uk. User data очікується під `test-user/Roaming/Godot/app_userdata/DroneFlames`; перевірити фактичний шлях. Він **обходить intro/first-language і Steam initialization**, тому first-run/intro потребує окремого ізольованого launcher/environment випадку зі збереженим updater-off. Не оголошувати їх пройденими звичайним Gui run.

Перевикористати всі TC-WIN-01..18: menu/world/bots, camera/input/hotkeys, fullscreen/scale, economy/building, seasons/render, AD/air, airport action, rebase/airdrop cancel, carriers/ownership/loss, nuclear/ABM, diplomacy/land consent/cooldown, Chronicle, save/load/continue,30+min soak, shutdown. Для TC-WIN-14 потрібні два human peers — виконати у Phase3, не позначати PASS після SP. Наявність меню/кнопки не засвідчує simulation result.

Щонайменше16:9 та інший доступний aspect ratio;960×540/1600×900 і native monitor resolution,125–200%DPI за можливості. Фіксувати CPU/GPU/driver/RAM/resolution/scale/seed/map/bots/ticks/checkpoint. Немає погодженого FPS або startup/exit budget: записати фактичні величини; CPU sim p99 окремо від rendered frame-time.

SP logs: `test-logs/{gui,smoke}-{engine,stdout,stderr}.log`, result.json. Launcher перезаписує ці імена, тому **архівувати каталог після кожного run**. Loaded-module polling може не встигнути захопити DLL; порожній список не доводить unloaded DLL. Exit0 не перекриває script errors або resource-at-exit diagnostics.

## Phase3 — два незалежні Windows ПК

На A/B звірити EXE, кожну DLL, ZIP і launcher SHA256; порівняти full admission identity `v0.34.0/7/pr10-phase5b2-1` для build argument вище. Не покладатися на SIM_REV як code fingerprint. Окремі test users і логи; лише synthetic/copied saves.

```powershell
# ПК A (роль створюється в UI; -Peer — лише label каталогів):
& .\Run-MultiplayerQA.ps1 -Transport LAN -Peer host
# ПК B:
& .\Run-MultiplayerQA.ps1 -Transport LAN -Peer guest

# Окремий ручний Steam test двома дозволеними тестовими accounts:
& .\Run-MultiplayerQA.ps1 -Transport Steam -Peer playerA
# На ПК B відповідно -Peer playerB
```

LAN mode встановлює invalid mock ID0 і використовує ENet; Steam mode прибирає bypass і справді дозволяє Steam init. AppID480 — Spacewar, не комерційне приймання. Launcher не створює lobby автоматично й не змінює firewall. LAN port24600, discovery24601/24602: записати Windows network profile/firewall стан; дозволи змінює людина лише для тестової гри. Public backend/online/ranked не потрібні й не запускати без окремого scope.

| Case | Дії та очікувані докази | Початковий статус |
|---|---|---|
| MP01 | Create/list/direct-IP join LAN;2 roster entries, version; окремо Steam lobby/invite | NOT RUN |
| MP02 | Host start, seed/config/slots/countries, ready barrier, capitals на обох | NOT RUN |
| MP03 | Обоє: airport/build/train/air/navy/nuclear/land actions; effects/cost/owners і canonical order | NOT RUN |
| MP04 | Різні FPS/focus/stalls/speed wishes; ті самі tick checkpoints, hash/RNG; відсутність desync | NOT RUN |
| MP05 | Human land gift/buy/sell/swap до/після consent; stale/duplicate/reject/TTL90sim-s/cooldown90; save/resume | NOT RUN |
| MP06 | Disconnect guest, AI control, reconnect/rejoin seat, valid snapshot, продовження команд | NOT RUN |
| MP07 | Same-build resync на всіх peers/host, clocks/player/fog; failed restore без false success, explicit retry | NOT RUN |
| MP08 | Host exit/save/relaunch/resume + guest return; не вимагати automatic migration LAN/Steam | NOT RUN |
| MP09 | Unapproved identity у synthetic isolated admission fixture відхиляється; old network save до mutation | NOT RUN |
| MP10 | Довгий матч/кілька load/new cycles/штатний вихід, no stuck process, archived logs і saves | NOT RUN |
| MP11 | Automatic online casual host promotion/handover | N/A для normal PC LAN/Steam; окремий backend scope |

**Diagnostic gap:** launcher не має Trace/Guard параметрів; коментарі про `--net-trace/--net-guard` не доводять чинний CLI handler. NetHash рахується кожні50 turns, але parts/trace друкуються за NetConfig.trace/net_trace_logs; trace вимкнений за замовчуванням. Для доказового MP04 до тесту підготувати окремо дозволений diagnostic harness/спосіб отримати однакові turn/hash/RNG обох peers. Не змінювати один EXE окремо, не приписувати logs полів, яких вони не містять. Скріншоти схожих карт не доводять hash equality.

Malformed snapshot/chunk/duplicate/rate-limit cases спочатку виконувати автоматичними ізольованими fixtures; не ламати єдиний live QA match. [tests/test_network_admission.gd](../../../tests/test_network_admission.gd) — standalone host/guest loopback harness, **не автоматичний unittest тест повного матчу**. Для нього Linux editor запускає один source PCK двома процесами з --role/--port/--ready/--stop/--host_version/--out; різні ports/paths та log files. `--host_version` тут лише очікуваний текст помилки, **не override фактичної версії**. Один PCK дозволяє positive same-version case; negative mismatch потребує окремого synthetic PCK з іншим identity у temp copy або дозволеного injection harness, не production source edit. Цей fixture не тестує повний rejoin/resync. Wrapper-orchestration старої сесії в checkout немає, старі PCK не вимагати.

MP launcher: `mpqa-user/<peer>/{Roaming,Local}` і `mpqa-logs/<peer>/`; імена всередині теж перезаписуються. Архівувати обидві сторони з UTC/seed/ticks; перед передачею logs перевірити на account/token/Steam private data. Updater весь час off.

## Phase4 — дефекти після фактичного QA

Для кожного case PASS/FAIL/SKIP/NOT RUN/N/A і причина. Дефект: ID, source/build/SHA, expected/actual, мінімальні кроки, frequency N/M, seed/config/checkpoint копія, обидва logs за network case, screenshot/video за UI. Functional failures та shutdown diagnostics вести окремо.

Після окремої команди: fix/* від actual beta → повне читання залежностей → мінімальний fix + regression → review → PR у beta. Commit/push/merge і тим більше main/release потребують прямого дозволу. Цей план не запускає жодну з фаз автоматично.
