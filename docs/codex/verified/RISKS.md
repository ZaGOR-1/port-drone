> Історичний реєстр. Поточні пріоритети, невиконані перевірки й ризики наведено в [PROJECT_STATE](../../PROJECT_STATE.md), [Windows QA](../../WINDOWS_QA.md) та [BACKLOG](BACKLOG.md).


# Phase 5 status overlay — 2026-11-20

Нова стратегія незалежного порту:0.41 source migration DEFERRED і не поточний blocker. Цільові PR10 PA01/02/03/04/06 закриті локальним uncommitted diff у перевіреному scope. Старі updater R01/R03/R04, save fault matrix, transport admission та R17/R18 не виправлені. **R02 HIGH відтворений:** failed restore помилково advances/rejoins; це integration blocker. Airport/cooldown/cancel також FAIL, GUI/actual2-peer NOT RUN, p99 success не підтверджений. Exact evidence — PR10_REGRESSION_RESULTS, окремі fixes — PHASE5B_PLAN. Нижче історичний baseline risk register, не перелік нових fixes.


---

## Історичний документ / попередній scope (збережено)

# Ризики й підтверджені проблеми

HEAD `af1b4c9`, 2026-11-19. Severity — очікуваний вплив; confidence — сила доказів. «Підтверджено статично» означає наявність конкретного шляху коду, не виконаний Godot reproduction. CRITICAL runtime incident цим аудитом не встановлений. Не всі пункти є gameplay-багами.

Phase3: R01–R18 нижче описують0.33 source/baseline, не автоматично native0.41. Для0.41 додані migration blockers R19–R21; деталі VERSION_041_ANALYSIS/DIFF/MIGRATION_041.

| ID | Severity / confidence | Статус і вплив | Доказ | Безпечна перевірка |
|---|---|---|---|---|
| R01 | HIGH / high | **Підтверджений дефект deletion scope.** Updater видаляє сторонні `.old/.new/.tmp` біля EXE; втрата чужих файлів | `game/pc/updater.gd:114` `_cleanup_old`, без whitelist | Temp install directory: owned artifacts + `notes.tmp`, `backup.old`, підтека; запуск cleanup у pinned Godot; сторонні байти мають лишитися |
| R02 | HIGH / high | **Підтверджений дефект failure handling.** Failed snapshot restore пересуває clock/turn і може повідомити успіх rejoin | `game/net/net_session.gd:2999`, ok перевіряється лише для vision, далі exec_turn/flags змінюються | Synthetic invalid wrapper/body, stub restore=false, перевірити go/rejoining/turn/UI; потім 2-peer recovery |
| R03 | HIGH / high | **Підтверджена неповнота DLL install.** ZIP без потрібних DLL може отримати libs.rev/relaunch; partial writes без спільного rollback | `updater.gd:328`…`358`; rename/write results/повнота не перевірені | Fake ZIP: missing/duplicate/truncated DLL, denied write для другого файла; marker не змінюється, старий набір працездатний |
| R04 | HIGH / high | **Integrity/timeout gap.** EXE digest optional, libs ZIP без digest, download timeout0, create_process результат і rollback помилка не обробляються | `updater.gd:215`, `241`, `247`, `294`; `SHA256SUMS` клієнт не читає | Fake HTTPS metadata/artifacts; missing digest, same-size corrupt bytes, stalled transfer, failed rename/relaunch у temp tree |
| R05 | HIGH / high | **Durability failure windows.** fresh slot cleanup перед final rename; MP save видаляє старий файл перед неперевіреною rename | `save_slots.gd:273`, `save.gd:805`, `net_config.gd:140`; migration rename також без повного check | Synthetic copies, ін'єкція ENOSPC/rename/permissions/crash на кожному кроці; хоча б одна валідна recoverable copy |
| R06 | HIGH / high | **Release gate gap.** Успішний pack/magic і Python release tests можуть опублікувати EXE без Godot parse/startup/game regression | `.github/workflows/build.yml:3`, `:35`, `:66`; `tools/packproj/pack.gd:20`; `build.py:52` | Тільки локальний build + smoke; PR pipeline планувати окремо. Push/main/manual dispatch не використовувати як тест |
| R07 | HIGH / medium | **Protocol input hardening gap.** ALLOWED не перевіряє повністю arity/types/nested owners/rate; snapshot parts не bounded/size-validated | `net_session.gd:1975`, `:2002`, `:2072`, `:2968`; `Save.net_restore:273` | Offline fixtures + 2 local peers: allowed method з порожніми/поганими args, великі commands, invalid indices/length; жодних production peers |
| R08 | MEDIUM / high | **Steam ID collision/admission gap.** Modulo mapping має колізії; host HELLO замінює існуючий pid, wants_session не звіряє lobby members | `steam_peer.gd:41`, `:72`, `:150`; `steam_net.gd:115` | Synthetic account IDs1 і2147483001; mock collision/admission test, потім погоджений Steam test |
| R09 | MEDIUM / high | **Неповна локалізація.** ES4284/4367 порожніх non-header entries; EN222, UK244. Phase2 уточнення: LangPicker.SHOW_ES=false, ES прихований у звичайному picker | `game/translations/*.po`, `ui/lang_picker.gd:18`, `:61`; Loc підтримуєes | Language/pseudo smoke; ES QA до увімкнення picker, не стверджувати доступність ES у звичайному UI |
| R10 | MEDIUM / high | **Source reproducibility gap.** Основний project/scene та textures/audio є відновленими binary/import cache; toolkit fetch без digest, PCK traversal unsorted | `project.binary`, `main.tscn.remap`, `.godot/imported`, `fetch_godot.py`, `pack.gd` | Hash-verified editor/template; 2 clean temp builds порівняти file list/bytes; не видаляти cache з єдиними resources |
| R11 | MEDIUM / medium | **Native API compatibility неповна.** Phase2 Windows startup реально завантажив усі3 DLL, extension-load errors немає. Linux/debug binaries відсутні; real Steam/WebRTC calls не перевірені | `libs/`, `.gdextension`, `logs/winlocal-smoke-result.json` | DLL load PASS не замінює2-peer/native API smoke; Linux native check BLOCKED, файли не підміняти |
| R12 | MEDIUM / medium | **UI масштабування має два джерела.** PcPort і Save.apply_ui_scale пишуть root content_scale_factor з різних налаштувань | `pc_port.gd:100`, `save.gd:977`, `menus.gd:80` | Ізольовані prefs: desktop scale→restart→menus settings, 960×540/16:9/ultrawide, ctrl+/−/0; desired precedence узгодити перед fix |
| R13 | MEDIUM / medium | **Потенційна concurrency/continuation проблема.** Save worker оновлює shared metadata caches; Cad344 phases не збережені | `save.gd:782`, `save_slots.gd::meta/after_write`, `cad344.gd` без state codec | UI slots read під час autosave; before/after load continuation з однаковими inputs; race/semantic result ще не відтворено |
| R14 | MEDIUM / high | **Maintenance/coverage debt.**267 scripts/174121 lines, великі UI/AI/front/naval класи. Phase2 current compile/regression baseline є; усі gameplay branches не reviewed | `menus.gd`4307, `front_plan.gd`3876, `operations.gd`3352, `net_session.gd`3045 | Ручний аудит за ризиком/залежностями, differential tests до refactor; формальні100% читання не є acceptance Phase2 |
| R15 | LOW / high | **Підтверджені відсутні dev entrypoints.** CLI flags `--net-test`/`--mp-shots` завантажують неіснуючі scripts | `game/game/main.gd:70`…`78` | Лише dev isolated startup із цими flags; відновити harness або явне повідомлення, не приховувати інші errors |
| R16 | HIGH / high щодо README; права UNKNOWN | **Організаційний release risk.** Похідний closed-beta code/art, підтвердження прав на дистрибуцію немає; CI здатний публікувати автоматично | `README.md:6`, workflow trigger | Перевірити дозволи власників перед будь-яким поширенням. Аудит не публікує артефакти |
| R17 | MEDIUM / high | **Підтверджений Windows SteamMock portability defect.** Valid mock ID викликає make_dir_recursive_absolute('/tmp/df_steam_mock'), Windows не створює /tmp. Concurrent IDs із тим самим modulo1000 додатково конфліктують | `game/pc/steam_mock.gd:13`, `:36`; Phase2 initial probe stderr | Окремий portable temp root і namespace для2+ Windows peers; current SP launcher ID0 лише обходить init, не виправляє mock |
| R18 | MEDIUM / high щодо diagnostics | **Відтворені exit leaks.** Linux/Windows повертають ObjectDB/RID/resources-at-exit diagnostics; long-run growth не доведений | Phase2 regression/boot/save logs; Windows204 ObjectDB/43 resources/1 CanvasItem RID | Clean-shutdown criterion FAIL окремо від functional PASS. Verbose object/resource lifetime audit, repeated new-game/load/quit; не замовчувати cleanup errors |
| R19 | HIGH / high | **Source/reproducibility blocker0.41.** Encrypted PCK directory та stripped native game/net images; matching sources/custom engine/bridge toolchain не надані | PCK flags3, stock mount exit2; outer ZIP25 files; public branch trees | Отримати matching dev package/nonencrypted catalog/build inputs; binaries не видавати за source migration |
| R20 | HIGH / high | **Tag/source provenance mismatch.** Release0.41 tag/main мають exact старі881 blobs af1b4c9; PORT credits посилаються на0.31/0.32 і відкриті GD, не підтверджені ZIP | GitHub tag/tree API, PORT texts, file inventory | Зафіксувати separate binary hashes і вимагати matching source commit; не вважати тег чи credits доказом повноти0.41 |
| R21 | HIGH / high щодо невідомого | **Compatibility невстановлена.** Numeric PROTO/Save FORMAT, schemas, SceneTree/native API0.41 недоступні; pc34-v1 лише manifest label | Native PROTO/FORMAT identifiers без значень, locked PCK | Source schemas + synthetic migration/replay/2 peers; не переносити7/FORMAT1/старий updater/Steam callbacks автоматично |

## Ризики детермінізму

Підтверджено: MP має fixed dt/command order/job delay, власний RNG; SP має variable frame subdivision/CPU budget і discarded sim_lag. Це різні режими, а не доказ MP desync. Потрібні peers із різною швидкістю CPU, однаковим build/config/seed, replay команд і hash/serialization comparison.

NetHash — неповний aggregate; однаковий hash не доводить рівності всіх fields. Save codec відкидає caches/Callables/Cad344 state; тому resync відновлює host і всіх guests разом. Статичні scripts і UI caches можуть змінювати стан поза tick; NetGuard може допомогти, але його current-run результати відсутні.

## Що перевірено й НЕ оголошено дефектом

- Raw `main.tscn` відсутній, але remap target існує; це не встановлений missing-scene bug.
- 209 `.import` містять кінцевий NUL; їх текст і всі targets прочитані програмно, це не доказ пошкодження.
- `atlas_fx7.png/json` відсутні, але `_ready` викликає load_atlas з optional=true, helper має placeholder fallback.
- `FileAccess.get_size` є в офіційній документації Godot4.7 (звірено Context7); не позначати як API-помилку за знаннями старіших версій.
- Ship.c / `_owns(...country_id)` — підтверджена розбіжність полів, але існуючий UI path із прямим Ship argument ще не доведений; не заявляти, що всі ship commands зламані.
- Regex знайшов4 printf-кандидати в EN, ручні приклади — звичайний `% of/% each` у prose. Вони не підтверджують formatting bug.
- Linux missing WebRTC/Steam extensions — відома platform limitation; Phase2 реально відтворив ці diagnostics. Gameplay regression пройшов за незмінним allowlist наявного runner; Linux native transport лишається BLOCKED.
- Global RNG occurrences у simulation files не всі є gameplay RNG: `Army._kill:654` передає випадкову позицію у `ArmyFire.cook_off:539`, який лише створює VFX/audio; `Operations._barrage:2353` randomizes far audio, а shell trajectory бере ArmyFire.rf/rfr. Ці переглянуті приклади не підтверджують desync. Recon має окремий seeded RandomNumberGenerator і зберігає seed/state (`recon.gd:94`, `:825`, `:853`). Повна перевірка всіх RNG data flows залишається окремим завданням.

## Межа аудиту

Немає доказу відсутності інших дефектів/секретів, повного security/crypto review, runtime coverage, GPU performance або прав на публікацію. `net/ed25519.gd`, server/account flows і значна частина gameplay/UI пройшли лише повнотекстовий статичний індекс, не повний ручний семантичний review. Конкретні непрочитані paths/ranges залишені у FILE_COVERAGE.
