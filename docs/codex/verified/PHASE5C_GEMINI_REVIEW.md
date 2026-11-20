# Phase5C — review Gemini G01–G04

2026-11-20. Worktree `port-drone-pr10-critical`, branch `codex/fix-pr10-critical`, HEAD `96053d66eb984cc24e3acce647a55a195136abd2` + uncommitted fixes. Review лише чотирьох transfer tasks і identity/CI; повного аудиту повторно не проводили. Gemini worktree read-only. [Фактичні тести й рішення](PHASE5C_INTEGRATION_RESULTS.md).

## Походження та безпека

Оригінальні transfer-файли: `/home/zagor/projects/port-drone-gemini-updater/transfer_codex_g01/` … `transfer_codex_g04/`. `GEMINI_UPDATER_CLEANUP_REPORT.md` **відсутній усередині G01 transfer**, але наявний у корені Gemini worktree й прочитаний там; відсутність не прихована. Patch preimage відповідає updater з HEAD; `git apply --check` PASS, Gemini patched blob `7a59e6537d24931cc4bb8058a79a9338c0bc1891`. Patch застосовано лише в Codex worktree і потім звужено за результатами runtime review.

Pre-stage backup: [70 файлів і перевірене реальне extraction/hash відновлення](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/backup/restore_verified.json). Tracked/staged diff, inventory, refs, status і tar не перезаписували попередні rollback. [Preservation](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/preservation.json): усі refs незмінні, шість Gemini transfer inputs і updater blob/status незмінні; усі 70 початкових файлів присутні. Без commit/push/merge/PR/CI dispatch.

## G01 — ACCEPTED WITH CORRECTIONS

Gemini правильно замінив generic suffix sweep на whitelist і додав symlink/running-file/path guards. Початковий код міг видаляти будь-які сторонні `.old/.new/.tmp`. Проте позитивна Python-модель не доводила коректність GDScript:

| Знахідка | Наслідок / рішення |
|---|---|
| `.old` видаляється за самого існування primary | Існування не доводить complete/healthy committed update; library writer може залишити partial primary. HIGH rollback loss. **Усі `.old` збережені** до окремої transaction/integrity policy. |
| GDScript `file_exists(primary)` слідує link; Python модель перевіряє primary link інакше | Model/runtime discrepancy. Regular non-symlink primary та size>0 для disposable staging; runtime tests обох symlink шляхів. |
| Whitelist DLL `.new/.tmp` та EXE `.tmp` без реального producer | Не доведено ownership цих імен у поточному updater: retain. EXE download asset/debug name не дорівнює локальному basename: `_do_update` пише `_exe + ".new"`. |
| `libs.zip.tmp` видаляється при missing/zero primary | Retain ZIP, якщо будь-яка з трьох DLL відсутня/нульова/link; retain усі rollback незалежно від primary. |
| `.` fallback при відсутньому executable path | Не вгадувати install dir за cwd; absolute `_exe` required. |
| Помилки remove не діагностуються | Перевірка error, diagnostic print, без script exception; retry ідемпотентний. |

У `game/pc/updater.gd::_cleanup_old/_is_safe_updater_artifact/_cleanup_primary_present` тепер лише доведені producers: `write.test.tmp`; `_exe+.new` за regular nonempty primary; `libs.zip.tmp` за наявних regular nonempty DLL. Не видаляються running EXE, усі `.old`, чужі suffix files, directories, artifact links, path traversal/ADS names. Windows names порівнюються case-insensitively. Nonempty primary **не** є integrity proof: це лише conservative disposable-temp guard; rollback навмисно не визнано зайвим.

**RED:** реальний GDScript Gemini, [35 checks / 14 failed](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/gemini_cleanup_red_verified.json); це rollback/unproduced staging/incomplete-install/symlink cases. Ранні probing RED з меншою fixture містили залежний running-old failure; corrected verified fixture відтворює 14 наведених порушень незалежно. **GREEN:** [Linux35/35, без skips](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/cleanup_green.json); [Windows36, 3 skips](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/cleanup_windows.json). Native Windows перевірив реальний case-insensitive доступ і deny-delete з відкритим handle та cleanup після close. Symlink creation на Windows UNC failed — ці два cases SKIP, POSIX permission case N/A; Linux symlink/permission fixtures PASS. NTFS junction/exclusive ACL matrix не сертифікована.

Оригінальні 12 Gemini cleanup Python tests локально PASS; заявлені Gemini28 — це **весь його набір**:12cleanup+15release+1GodotSKIP, а не28 cleanup tests. [Readonly reproduction log](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/logs/gemini_original_python.log). У поточному repo duplicate Python implementation замінено wrapper, який пакує actual source і запускає actual GDScript на ізольованих dummy files; оригінал збережений у stage artifacts.

Не змінювали `_download/_do_update/_libs`, native DLL або install/update transaction. R03/R04 download integrity/ZIP completeness/atomic activation/relaunch лишаються OPEN. Cleanup не виправляє повністю updater. QA використовує repo-empty build та DF_NO_UPDATE=1, production update не запускався.

## G02 — PARTIALLY ACCEPTED

`.gitignore`: тільки локальна Serena, `game/.godot/editor`, `game/.godot/shader_cache`, `tools/packproj/.godot`, Python bytecode, root `.venv`, `.DS_Store`. **Не** blanket ignore/delete/untrack `game/.godot`, DLL/EXE/ZIP/certificates, AGENTS/docs. Tracked imported resources потрібні сценам; їх не видаляли. `git clean` не застосовувався. Docs/AGENTS залишаються видимими untracked для майбутнього owner-approved review/commit; нині staging/commit заборонені.

Точне пояснення кількості: baseline `af1b4c975564bac916db079d8470c2394d4920e5` має **881 tracked**, HEAD96053 має **903**:23 added−1 deleted=+22,105 modified. Єдина історична deletion у cumulative PRs — `game/net/server/signal_server.gd`, не імпортовані ресурси й не результат Phase5C. Game-only863→883; tracked `.godot`213→213; hidden-path exclusion666→688. **625 не відтворюється жодним із цих Git-підрахунків**; походження такого числа в Gemini report не підтверджене. Воно не є доказом втрати256файлів. [Exact delta/list](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/tracked_delta.json), [ignore positive/negative tests](/home/zagor/projects/port-drone-pr10-critical/dist/phase5c_20261120-220811/gitignore_checks.json). Git index не змінювався.

## G03 — ACCEPTED AS CORRECTED QA PLAN

Усі18сценаріїв звірені; [остаточний Windows Beta checklist](WINDOWS_BETA_QA_CHECKLIST.md). Усі ручні statuses NOT RUN. Прибрані непогоджені stable v0.34.0, FPS30/60 і startup/exit budgets; уточнено фактичні hotkeys/context/speed order, F6Politics, SP Steam-bypass launcher, Airport **build** dispatch, pre-submit cancel boundary, conservative carrier loss, human consent/directional cooldown, Chronicle keyframes (не command replay), FORMAT1 downgrade limitation. GUI не доводить determinism. Окремий full two-peer/Steam/LAN acceptance зі exact same EXE SHA; current admission tests не підміняють його.

## G04 — ACCEPTED WITH EDITS

Встановлено локально `.github/pull_request_template.md`: beta target вибирається явно, main тільки owner-approved stable, human review, automated/manual statuses окремо, N/A з причиною, compatibility/negative tests/save downgrade, actual human attribution, AI assistance окремо. Прибрано blanket «будь-який unsorted Dictionary — bug» та автоматичне прирівнювання AI до авторства людей. Template не змінює GitHub default base/branch protections і не створює PR.

## Межі рішення

Gemini worktree не змінений. Прийняття G01–04 означає local reviewed edits; жодних публікацій/Settings changes. Нові власні gameplay механіки не створювали. Подальші updater integrity/shutdown/p99/network schema задачі — окремо; поточний пакет може переходити до **ізольованого final QA**, не до автоматичного merge.
