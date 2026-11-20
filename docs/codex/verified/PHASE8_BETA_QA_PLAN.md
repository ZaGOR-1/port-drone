# Phase 8 — QA інтегрованої beta

Це план, не звіт про виконання. Windows GUI18cases/full two-peer/Steam/LAN **NOT RUN**. Exact merged beta SHA буде записаний після Phase7 у local `dist/phase7_20261120-224516/PHASE8_BETA_QA_PLAN.md` та final report. Для нового запуску не довіряти рухомому branch name: `git fetch origin`, `git rev-parse origin/beta`, звірити записаний повний SHA і створити окремий clean QA worktree без переключення Gemini/migration.

## Збірка точного snapshot

Після merge використати exact beta SHA з фінального звіту замість `BETA_SHA`:

```bash
git fetch origin
git worktree add --detach /home/zagor/projects/port-drone-beta-qa BETA_SHA
cd /home/zagor/projects/port-drone-beta-qa
# Використати вже перевірені pinned editor/template4.7.2; не оновлювати native DLL.
mkdir -p dist/phase8-beta
python3 tools/build.py --godot /home/zagor/projects/port-drone/godot_dl/godot \
  --template /home/zagor/projects/port-drone/godot_dl/windows_release_x86_64.exe \
  --version 0.34.0 --repo '' --out dist/phase8-beta
cp tools/qa/Run-*.ps1 dist/phase8-beta/
```

0.34.0 — existing Menus label для відтворення candidate, не новий stable version/release. Build змінює version.cfg лише у disposable copy. ZIP містить три existing DLL; витягти їх поруч з EXE, перевіривши whitelist filenames і SHA256 оригіналів. `SHA256SUMS.txt` перевірити до запуску. PCK already embedded; за потреби standalone PCK:

```bash
/home/zagor/projects/port-drone/godot_dl/godot --headless --path tools/packproj \
  --script res://pack.gd -- "$PWD/game" "$PWD/dist/phase8-beta/source.pck"
sha256sum dist/phase8-beta/DroneFlames.exe dist/phase8-beta/source.pck libs/*.dll
```

CI build-only version має automatic numeric suffix і порожній updater repo; не змішувати різні CI/local builds в одному match. Побудувати комплект **один раз** і передати той самий EXE/DLL обом peers; SIM_REV pr10-phase5b2-1 не fingerprint коду. Не створювати release/tag для передачі тестового комплекту.

## Windows GUI

У каталозі Windows комплекту PowerShell:

```powershell
& .\Run-DroneFlames.ps1 -Mode Smoke
& .\Run-DroneFlames.ps1 -Mode Gui
```

Launcher ізолює APPDATA/LOCALAPPDATA у build/test-user, задає DF_NO_UPDATE=1, робить Steam bypass (`DF_STEAM_MOCK=0`). Це лише SP/native startup, не Steam QA. [18 Windows cases](WINDOWS_BETA_QA_CHECKLIST.md): menu/world/camera/hotkeys/scaling/economy/seasons/AD/airport/cancel/carrier/nuclear/diplomacy/land/Chronicle/save-load/long match/shutdown. Зберігати logs перед повторним запуском (launcher filenames можуть перезаписуватися). FPS budgets не вигадувати. Відомі shutdown leaks не маскувати exit0.

## Два independent peers

На двох машинах з тим самим комплектом:

```powershell
& .\Run-MultiplayerQA.ps1 -Transport LAN -Peer host
# На другій машині:
& .\Run-MultiplayerQA.ps1 -Transport LAN -Peer guest
# Окремо, лише вручну з дозволеними тестовими Steam accounts:
& .\Run-MultiplayerQA.ps1 -Transport Steam -Peer playerA
```

LAN launcher bypass Steam; Steam mode явно дозволяє його initialization, автоматично не запускався. Окремі user/log dirs per peer. Створення/приєднання через штатний UI, потім UI commands обох гравців → canonical turns/ticks/order → hashes/RNG → save/snapshot → continue. Economy/seasons/airport/rebase/airdrop/carrier/land consent/cooldown перевірити разом. Окремо: disconnect/reconnect, valid snapshot, malformed/truncated failure без false success, manual retry/resync, host disconnect/change, late/duplicate packets. Old revision negative admission не заміняє same-build gameplay test.

## Докази та рішення

Зібрати exact beta/source/tested EXE/DLL/PCK SHA, Windows/CPU/GPU/RAM/driver/resolution/refresh/UI scale, seed/map/bots/checkpoint/ticks, timestamps. Logs обох peers, engine/stdout/stderr, hash/RNG samples і desync details, reproduction steps N/M, screenshots/video, тільки isolated save copies. Не вкладати tokens/Steam config/особисті saves. Кожен case: PASS/FAIL/BLOCKED/NOT RUN/N/A з причиною.

Production updater download/replacement **не використовувати**: R03/R04 OPEN; repo empty та DF_NO_UPDATE=1. Save downgrade unsupported, general network validation/shutdown/global p99 OPEN. Рішення щодо beta quality — після цих доказів, stable release лише окремо власником. Нових features або повторного повного аудиту цей план не доручає.
