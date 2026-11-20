# Phase5C — integration results / точний checkpoint

2026-11-20. **READY FOR FINAL QA**, виключно ізольований Windows/Multiplayer QA; **не READY FOR BETA MERGE**. [Gemini review](PHASE5C_GEMINI_REVIEW.md), [18 ручних сценаріїв](WINDOWS_BETA_QA_CHECKLIST.md). Відомі HIGH updater integrity/network validation risks, shutdown FAIL і непроведений full two-peer залишаються gates перед beta.

## Робочий стан та артефакти

- Worktree `/home/zagor/projects/port-drone-pr10-critical`; branch `codex/fix-pr10-critical`; HEAD `96053d66eb984cc24e3acce647a55a195136abd2` + **uncommitted Phase5/R02/5B2/5C**. Не checkout/reset/stash/rebase/clean; голий HEAD не містить fixes.
- Усі нові stage artifacts тут: `/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/`; [machine-readable final report](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/final_results.json), `*_result.json` містять argv/cwd/exit/time, `logs/` — stdout/stderr. Command files `run_checks.py`, `run_final_checks.py`, `run_admission.py`, `run_windows.py`, `run_cleanup_windows.py` відтворюють локальні дії, **не** CI/release scripts.
- Source PCK `candidate_review.pck` SHA256 **`5ed8822e33cf9d59dd033f9ad2391ac4b0cb566123d060d586aa5d6452f8e35e`**. Manifest883files. Це source candidate, окремий від disposable cleanup fixture PCK.
- Windows комплект `windows-release/DroneFlames.exe`, три оригінальні DLL, `SHA256SUMS.txt`, два manual launchers. EXE SHA256 **`53d73aa29733efd46d962cdb3ae2a2a3af6cdd7b46ac30f300e6f06a191887f6`**,215004264bytes. Embedded PCK105735772bytes. [Integrity](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/windows_integrity.json).
- Build використовує наявний Menus label `0.34.0`, repo порожній; це **не** затверджений новий stable release і не source version bump. `game/pc/version.cfg` лишається0.33.2.3, Menus.VERSION лишаєтьсяv0.34.0. Build-time normalization у disposable copy задокументований у `windows_manifest.json`.
- Godot **4.7.2.stable.official.ed1daf0bf**, pinned editor/template з primary `godot_dl/`. Native modules/templates не змінювали.

## Що інтегровано

1. G01 whitelist cleanup після runtime review: лише actual updater producers, збереження всіх `.old`, symlink/path/cwd/Windows casing/permission protection. Це не download/transaction integrity fix.
2. G02 targeted `.gitignore`, без видалення або untracking ресурсів;625 не є підтвердженим tracked count. Baseline881→HEAD903 (+23−1); game/.godot213 незмінні.
3. G03 [corrected18-case QA](WINDOWS_BETA_QA_CHECKLIST.md), усі manual NOT RUN; artifact launchers з ізольованими user paths.
4. G04 `.github/pull_request_template.md`, beta/manual review/compatibility/attribution/N/A; template не встановлює GitHub base branch/settings.
5. Owner-authorized `SIM_REV=pr10-phase5b2-1` у `game/net/net_config.gd`; transport PROTO7 та save FORMAT1 number незмінні.
6. Локальний CI: main/beta push і PR — tests/build only; publication лише explicit manual main+publish_release=true+непорожня approved numeric release_version+successful build. Build-only repo empty. Remote workflow **не змінений**, до integration може діяти старий auto-release. Workflow не запускався.

## Simulation identity / admission

`NetConfig.version()` дає `Menus.VERSION/7/pr10-phase5b2-1`. Production `_on_connected` надсилає його в `_hello`; `_hello` спочатку порівнює exact identity, **до** token rejoin/in-match bypass. Steam lobby metadata `v` та join callback теж порівнюють identity; `resume_host()` відхиляє old saved-match `v` **до** leave/config/reset/snapshot mutation. Жодних нових packet kinds, protocol changes або weakening до «достатньо Protocol7».

**RED** actual ENet: перед bump host `pr10-critical-1` прийняв Phase5B2 та R02 з тим самим identity, хоча semantics різні. OriginalPR10 без revision уже відхилявся. [RED results](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/admission_red/).

**GREEN** actual два loopback процеси / production RPC:

| Host → Guest | Очікування / факт |
|---|---|
| Phase5C → exact same Phase5C PCK | ACCEPT; host roster2, guest slot1 |
| Phase5C → original PR10 `/7` | REJECT; roster1, version diagnostic |
| Phase5C → Phase5B2 `/7/pr10-critical-1` | REJECT; roster1 |
| Phase5C → R02 `/7/pr10-critical-1` | REJECT; roster1 |
| Phase5B2 old host → Phase5C guest | REJECT; roster1 |

[П’ять result.json і логи обох процесів](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/admission_green/). Saved match identity tests:30checks, missing/old/protocol-only/future identities, repeated refusal, unchanged session/turn/tick/flags/queues. Saved old network sessions тепер очікувано не resume; SP saves лишаються FORMAT1 з попередньою optional-field policy.

**Обмеження:** SIM_REV є задекларованою сумісністю, не fingerprint і не доказом ідентичного executable. Дві різні модифікації можуть навмисно/помилково мати однаковий рядок; crypto/content gate не додано. Однаковий revision не сертифікує determinism. Приймати QA лише за exact same EXE+DLL SHA на обох peers. Loopback lobby admission не перевіряє gameplay lockstep, Steam/LAN end-to-end, reconnect/resync чи host migration.

## Фактично виконані перевірки

Усі tests використовують isolated XDG/APPDATA/LOCALAPPDATA та owned temporary fixtures. Production updater/користувацькі saves/Steam accounts не використовувалися.

| Перевірка | Результат | Evidence у stage directory |
|---|---|---|
| Повний Python discovery після всіх test edits | **PASS26**, без SKIP | `logs/python_all_final.log`, `python_all_final_result.json` |
| Godot deterministic regression | **PASS2476** | `regression_release/regression.json` |
| Mechanic assertions | **PASS309** | `mechanics_release.json` |
| Phase5 critical | **PASS81** | `critical_release.json` |
| R02 unit failure-injection | **PASS111** | `restore_unit_release.json` |
| R02 real Main integration failure-injection | **PASS41** | `restore_integration_release.json` |
| FIX05 airport UI→command + validation | **PASS21** | `final_fix05.json` |
| FIX06 territory cooldown persistence | **PASS41** | `final_fix06.json`, `new_cooldown_snapshot.bin` |
| FIX07 REBASE / AIRDROP | **PASS33+33** | `final_fix07R.json`, `final_fix07A.json` |
| FIX08 lazy upkeep / same economy outputs | **PASS26** | `final_upkeep.json`; Python fixture теж PASS |
| Main/HUD save→load→continue / normal vs extra render | **PASS23+23** | `phase5_release_normal.json`, `phase5_release_extra.json` |
| SIM revision / saved-match early refusal | **PASS30** | `sim_revision.json`, Python final fixture log |
| Real ENet admission | **PASS5/5 scenarios** | `admission_green/*/result.json` |
| Actual GDScript cleanup Linux | **PASS35**,0skip | `cleanup_green.json`, Python final cleanup fixture |
| Actual native Windows cleanup | **PASS36**,3skip/N/A | `cleanup_windows.json`, `windows-cleanup/test-logs/` |
| Original Gemini Python model/static suite, readonly | **PASS12** | `logs/gemini_original_python.log`; не доказ runtime |
| CI publication policy | **PASS4 unittest methods /9 event combinations + structural check** | `logs/ci_policy_green_verified.log`, final Python26 |
| YAML parse / push branches / opt-in default | **PASS offline**, не GitHub execution | `workflow_yaml_check.json`; actionlint NOT RUN (відсутній) |
| GDScript loading / source PCK hashes / Main | **PASS269 scripts /883files** | `compile_release.json` |
| Windows x64 build / trailer / native hashes | **PASS**,3DLL byte-identical | `windows_build_release_result.json`, `windows_integrity.json` |
| Windows embedded PCK loading/hashes / Main | **PASS269/883** | `windows_embedded.json` |
| Windows native headless startup | **PASS functional**, exit0 | `windows_native_result.json`, `windows-release/test-logs/smoke-result.json` |
| SP / MP launcher PowerShell AST | **PASS2 parse**, MP runtime NOT RUN | `logs/launcher_parse.log` |
| Старий R02 reader нового cooldown snapshot | **PASS2 compatibility probes**, cooldown_lost=true | `old_reader_compat_corrected.json`; downgrade **unsupported** |
| Windows GUI18cases / full real two-peer / Steam | **NOT RUN** | Manual checklist; це gates перед beta |
| Linux native Steam/WebRTC | **BLOCKED**: repo має Windows DLL, потрібних Linux .so немає | GDExtension diagnostics в Linux logs |
| Clean shutdown | **FAIL / OPEN**, inherited | Native Windows:11CanvasItem RIDs,225ObjectDB,44resources; `smoke-stderr.log` |
| Новий whole-game performance benchmark | **NOT RUN**: лише startup cleanup/identity/CI, simulation hot path не змінювався | Попередній p99 OPEN; [Phase5B2 measurements](PHASE5B2_PERFORMANCE.md) |
| Production updater full update / GitHub Actions | **NOT RUN**, заборонені/поза ізольованим scope | No production writes, no dispatch/publication |

Діагностики не приховані: R02 integration **навмисно** викликає `r02_injected_ui_failure`, malformed Variant decode та fail-closed warnings; suite перевіряє їх як fault injection. Це не «zero script diagnostics» run. Linux missing native extensions і відомі shutdown/resource messages лишилися в logs. Windows native main-startup не має script errors/extension load failures, але має наведені shutdown leaks. `Published https://github.com/owner/game/...` у Python log — stdout mocked release tests, **не** реальна публікація (release.gh замінений mock).

Технічні невдалі спроби збережені: `old_reader_compat_result.json` exit1 через помилковий шлях до неіснуючого `candidate_release.pck` у5B2; повтор із правильним R02 artifact → `old_reader_compat_corrected` PASS2. Перший CI policy GREEN probe дав1FAIL через parser теста, який міняв `'true'` у quoted strings; parser виправлено, production gate не послаблювали, verified/final tests PASS. Початкові G01/CI/admission RED не переписані.

## Determinism та сумісність

Main/HUD контрольний continuation: обидва render cadences дають hash **`9c88c42bb828b5fc`**, RNG**1905021893**, snow**0.5**, simulation time**170.666666666666**. [Preservation](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/preservation.json): **881/883 source files byte-identical до5B2**, відрізняються тільки `net/net_config.gd` і `pc/updater.gd`. Отже Phase5/R02/FIX05–08 implementation збережена; suites підтверджені. Це scoped evidence, не доказ усіх multiplayer states.

Protocol7, FORMAT1 number, native DLL, Steam implementation, command ordering та snapshot restore code не змінені в5C. Optional FORMAT1 cooldown field з5B2 лишається: old→new defaults, new→old втрачає cooldown. New revision gate відділяє мережеві cohorts, але **не захищає offline save від downgrade**. Старі network save v відхиляються до mutation.

Cleanup виконується тільки у startup updater path, не normal simulation tick. Version comparison існував раніше; змінено declared string. Немає підстав заявляти нове прискорення. Історичні p99 medians42.255/44.342/50.711ms з розкидом не замінені новими startup timings; p99 лишається окремою задачею.

## Змінені файли саме5C

Tracked: `game/pc/updater.gd`, `game/net/net_config.gd`, `.gitignore`, `.github/workflows/build.yml`, `README.md`. Pre-existing untracked `AGENTS.md` оновлений, не прихований. Нові tests: `test_updater_cleanup.py/.gd`, `run_updater_cleanup.gd`, `test_ci_policy.py`, `test_sim_revision.py/.gd`. Новий `.github/pull_request_template.md`. Нові verified docs: цей report, `PHASE5C_GEMINI_REVIEW.md`, `WINDOWS_BETA_QA_CHECKLIST.md`; updated CURRENT_STATE/BACKLOG/TEST_MATRIX/COLLABORATION_WORKFLOW/DECISIONS/PR_RISKS/PHASE5B_PROGRESS/PHASE5B3_PLAN/BUILD_RELEASE/INTEGRATION_STRATEGY. Попередні фази не squash/revert, їхні historical reports збережені.

Phase5C-only patch та full working checkpoint містяться у stage directory: `PHASE5C-only.patch`, `final_working.patch`, `final_working_files.tar.gz`, `final_working_manifest.json`, `final_restore_verified.json`. Patch5C відносно **pre5C dirty state**, не від голого HEAD. Patches/тарбал не є Git commit. Для продовження відновлювати лише в окремій review копії; не застосовувати поверх цих уже наявних fixes без перевірки.

## До beta та наступна сесія

1. ZaGOR-1/OKREDU review cumulative PR10+fixes (один результат, ancestry/людське авторство збережені), cleanup conservative policy, SIM_REV та workflow. PR не створений; default target beta вибирається вручну. Немає підстав інтегрувати10cumulativePR окремими squash/cherry-picks.
2. Виконати18WindowsGUI сценаріїв; обидва peers exact same EXE/DLL, canonical turns/hash/RNG, failure→manual retry/reconnect/resync/host change; Steam/LAN окремі докази. SP launcher робить Steam bypass; MP launcher тільки підготовлено й parse-validated, не запускався.
3. Окремо закрити або явно прийняти updater R03/R04 integrity/transaction, general network schema R07, save durability R05, shutdown R18 та p99 ризики. Updater у QA **залишається off**. Final QA readiness не є дозволом включати небезпечний production updater чи publishing.
4. Узгодити gameplay rules: gift consent/TTL90/one pending pair/directional cooldown; carrier wing loss без бази; cancel до/після submission без нових refunds. Нових правил5C не ввів.
5. Перед майбутнім PR знову звірити actual remote beta/PR10 heads, conflicts, required CI, exact artifact provenance і no competing cumulative PR. Поточний local ref preservation не гарантує незмінність GitHub після останнього fetch.
6. Лише окрема команда власника дозволяє commit/push/PR/merge/release. `main`, `beta`, OKREDU, Gemini та migration branches не змінені.0.41 — DEFERRED, пошуку не проводили.

Інструменти: Git/rg/Python, pinned Godot/PCK packer, Windows PowerShell/runtime; Serena initialization для репозиторію, Context7 official Godot4.7 DirAccess/FileAccess path/link API. Browser/Figma/Playwright не використовували — Godot GUI не є web UI. CI/settings/account operations не виконували.
