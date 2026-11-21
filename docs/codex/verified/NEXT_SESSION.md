# Наступна сесія Codex

2026-11-21. DroneFlames — нова навмисно створена Git-історія `ZaGOR-1/port-drone`, Godot4.7.2/GDScript PC port. **v0.36 прийнята у beta через PR #4**, code checkpoint `0f26040994043827a7c14913d945a3df02e00fdd`. Після docs PR #1 beta може мати новіший SHA: перевіряй actual Git, не використовуй checkpoint як вічний HEAD.

1. Прочитай [AGENTS](../../../AGENTS.md), [CURRENT_STATE](CURRENT_STATE.md), [V036_FIX_RESULTS](V036_FIX_RESULTS.md), потім документи лише своєї задачі. [ARCHITECTURE_AND_FLOWS](ARCHITECTURE_AND_FLOWS.md), [SOURCE_COVERAGE](SOURCE_COVERAGE.md), [REONBOARDING_AUDIT](REONBOARDING_AUDIT.md) зберігають факти й межі без повторного великого аудиту.
2. `git status --short`, `git fetch origin`, `git branch -vv`, `git worktree list`, `git ls-remote --heads origin main beta`; не чіпай чужі зміни. Нові feature/*,fix/*,docs/* від actual beta; main stable змінює власник окремо. Тимчасові branches можуть бути видалені після merge; історію збережено в beta.
3. CI **вже відновлено PR #2**. PR #4 і beta push CI PASS:43 tests з Godot,2476 regressions, Windows build/integrity/identity. Не відновлювати CI повторно й не вважати missing-workflow FAIL початкового onboarding поточним.
4. Identity `v0.36.0/7/v036-integration-1`, FORMAT1; source UI/updater узгоджені, build --version лише assertion. П’ять HIGH виправлені, hash/upgrades/tooltips теж. Same identity не fingerprint: один exact EXE/DLL SHA256 cohort.
5. Наступний етап — [Windows GUI/two-peer QA](WINDOWS_TWO_PEER_QA_PLAN.md), лише після конкретної команди. Один pinned CI package, updater off, isolated test-user/mpqa-user. GUI18cases, SP/save/load, LAN, Steam за наявності accounts, hashes/RNG, navy/UrbanHold/power/convoy, disconnect/rejoin/resync, Chronicle/restore. Це **ще NOT RUN**, автоматичні loopback/headless не заміняють цей етап.

Ризики: CPU mean/p99 погіршилися у noisy early-world runs; shutdown leaks10/224/44 збережені; updater integrity/atomicity, save durability/deep malformed і general network schemas OPEN. New→old save downgrade unsupported. Old→new optional defaults перевірені targeted tests. Chronicle — adaptive SP keyframes, не command replay; automatic host change LAN/Steam не заявляється.

Доступні команди (з кореня checkout; cached engine перевірити, не завантажувати без потреби):

```bash
python3 tools/build.py --print-version
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py' -v
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py' -v
# Якщо pinned engine наявний:
DF_GODOT="$PWD/godot_dl/godot" python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --godot godot_dl/godot --mode regression --out dist/session-regression
```

Без Godot wrappers SKIP — не engine PASS. Для іншого worktree DF_GODOT може бути абсолютним шляхом до перевіреного cache. Build/verification commands у Windows plan. Performance CLI bots1..7; не підмінюй ним інший UI contract.

`game/project.binary`, tracked game/.godot та binary remapped main scene зберігати. Не створюй game/project.godot. Editor/import — лише disposable copy. Native DLL/PROTO/FORMAT/identity не змінюй без погодженої задачі й compatibility tests.

Ця база знань не є 100% semantic audit: початковий FULL/PARTIAL/INDEXED ledger датований172df65; v0.36 changes мають окремі targeted evidence/freshness overlay. Дочитай лише потрібні файли/extends/tests/serialized dependencies перед наступною зміною.

Старі Phase5–7 permissions/worktrees/SHA,0.34 labels і missing engine/workflow reports — історичні. Стан PR #1 перевір `gh pr view 1`; #3 автоматично marked MERGED після #4, не відкритий pending fix. Поточна команда на завершення docs не дає постійних дозволів на майбутні Git/publication дії. Без нового scope: main/releases/tags/dispatch/updater/real saves/accounts та0.41 migration не чіпати.
