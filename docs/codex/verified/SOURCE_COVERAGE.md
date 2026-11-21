# Покриття re-onboarding — пофайловий інвентар

2026-11-21; baseline172df65e3bd004efed9a5444e90a284d9d69db10. У таблицях нижче **всі970 tracked paths** baseline, без пропусків і без успадкування FULL зі старого FILE_COVERAGE. Розміри/рядки стосуються baseline до documentation edits. Нові5 Markdown +1 drawio перелічені окремо й не входять до зафіксованого baseline count; після їх commit поточний tracked count буде976. Статуси читання описують первинний аналіз, не змінюються через публікацію документації.

| Статус | Файлів | Що означає |
|---|---:|---|
| FULL |104|Повністю виведений/прочитаний текст; не гарантія runtime behavior або повного dependency review|
| PARTIAL |17|Проіндексовано весь файл, агент прочитав зазначені діапазони|
| INDEXED |559|Повний автоматичний облік/лексичний або структурний аналіз; **не повне семантичне читання**|
| BINARY |290|Path/size/hash/type metadata, не інтерпретація як текст|
| UNAVAILABLE |0|Усі tracked files доступні для читання; runtime/tool dependencies окремо відсутні|

Text680, binary290; text10951776 bytes/354461 lines. GDScript284: FULL33, PARTIAL16, INDEXED235; вручну прочитано 11886 різних рядків GDScript із182509 (6.51%). Це **не100% audit і не line/function test coverage**. Markdown48: FULL47, PARTIAL1 (FILE_COVERAGE, лише1–220/918 вручну; усі881metadata rows машинно зіставлені).

Початковий автоматичний прохід декодував усі текстові файли й побудував lexical classes/functions/extends/references/clock/RNG/async sites. Додаткові actual checks:14Python ast.parse,93JSON json.loads,4PO syntax/no duplicate keys,209.import+1.remap targets існують,130classes відповідають cache. Для структурних imports/atlas JSON це корисне покриття, але статус INDEXED не підвищується до FULL. Для великих translations не заявляється якість перекладу лише за parser result.

Діапазони FULL/PARTIAL з read ledger; великі tool outputs з truncation не вважаються автоматично прочитаними: важливі пропуски дочитані окремими ranges. FILE_COVERAGE machine table pass навмисно лишається PARTIAL. Binary project ECFG26entries і DLL PE metadata прочитані статично, PackedScene тільки RSRC/ref metadata; Godot instantiate НЕ виконаний. Binary types вказані за extension/container metadata; content semantics можуть бути UNVERIFIED.

Старий inventory:881rows,769byte-identical/110changed/2missing проти initial checkout. Збіг bytes не перетворює попереднє читання іншої сесії на current FULL. Новий список є джерелом точних прогалин. Перед production change прочитати повністю відповідні implementation/extends/tests/serialized dependencies.

## Нові документаційні артефакти цієї сесії

- [NEXT_SESSION.md](NEXT_SESSION.md) — швидкий контекст.
- [REONBOARDING_AUDIT.md](REONBOARDING_AUDIT.md) — doc/code matrix, tests, risks, limits.
- [ARCHITECTURE_AND_FLOWS.md](ARCHITECTURE_AND_FLOWS.md) — source-backed flows/mechanics.
- Цей SOURCE_COVERAGE.md — автоматично звірений повний path inventory/read ranges.
- [WINDOWS_TWO_PEER_QA_PLAN.md](WINDOWS_TWO_PEER_QA_PLAN.md) — майбутній build/GUI/MP план.
- [reonboarding-flows.drawio](reonboarding-flows.drawio) — редагована схема3pages; schema/XML/export verification описано у audit.

Оновлені baseline Markdown зберігають тут baseline path/size/read coverage; review нового diff — окрема перевірка документації. CURRENT_STATE перевикористаний зі старим текстом під HISTORICAL. Решта historical reports не видалені.

## Усі tracked текстові джерела

Діапазони — inclusive line numbers; «—» означає INDEXED без повного ручного читання. Відносні links ведуть до поточного файла, номер рядка baseline може змінитися для edited Markdown.


### .

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [.gitignore](../../../.gitignore) | 222 / 13 | FULL | 1–13 |
| [AGENTS.md](../../../AGENTS.md) | 15818 / 92 | FULL | 1–92 |
| [README.en.md](../../../README.en.md) | 8013 / 100 | FULL | 1–100 |
| [README.md](../../../README.md) | 12184 / 100 | FULL | 1–100 |

### docs/codex/verified

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ARCHITECTURE.md](../../../docs/codex/verified/ARCHITECTURE.md) | 10599 / 85 | FULL | 1–85 |
| [BACKLOG.md](../../../docs/codex/verified/BACKLOG.md) | 23573 / 166 | FULL | 1–166 |
| [BUILD_RELEASE.md](../../../docs/codex/verified/BUILD_RELEASE.md) | 9572 / 62 | FULL | 1–62 |
| [COLLABORATION_WORKFLOW.md](../../../docs/codex/verified/COLLABORATION_WORKFLOW.md) | 8237 / 52 | FULL | 1–52 |
| [CURRENT_STATE.md](../../../docs/codex/verified/CURRENT_STATE.md) | 33075 / 176 | FULL | 1–176 |
| [DECISIONS.md](../../../docs/codex/verified/DECISIONS.md) | 18595 / 100 | FULL | 1–100 |
| [ENVIRONMENT_SETUP.md](../../../docs/codex/verified/ENVIRONMENT_SETUP.md) | 6110 / 57 | FULL | 1–57 |
| [FEATURE_CATALOG.md](../../../docs/codex/verified/FEATURE_CATALOG.md) | 24502 / 126 | FULL | 1–126 |
| [FILE_COVERAGE.md](../../../docs/codex/verified/FILE_COVERAGE.md) | 178423 / 918 | PARTIAL | 1–220 |
| [GAMEPLAY_SYSTEMS.md](../../../docs/codex/verified/GAMEPLAY_SYSTEMS.md) | 21320 / 136 | FULL | 1–136 |
| [INTEGRATION_STRATEGY.md](../../../docs/codex/verified/INTEGRATION_STRATEGY.md) | 9616 / 75 | FULL | 1–75 |
| [MIGRATION_041.md](../../../docs/codex/verified/MIGRATION_041.md) | 27260 / 159 | FULL | 1–159 |
| [MODULE_INDEX.md](../../../docs/codex/verified/MODULE_INDEX.md) | 27836 / 273 | FULL | 1–273 |
| [MULTIPLAYER_PROTOCOL.md](../../../docs/codex/verified/MULTIPLAYER_PROTOCOL.md) | 18306 / 119 | FULL | 1–119 |
| [PHASE5B2_FIXES.md](../../../docs/codex/verified/PHASE5B2_FIXES.md) | 11710 / 51 | FULL | 1–51 |
| [PHASE5B2_PERFORMANCE.md](../../../docs/codex/verified/PHASE5B2_PERFORMANCE.md) | 5918 / 43 | FULL | 1–43 |
| [PHASE5B2_REGRESSION_RESULTS.md](../../../docs/codex/verified/PHASE5B2_REGRESSION_RESULTS.md) | 10708 / 69 | FULL | 1–69 |
| [PHASE5B3_PLAN.md](../../../docs/codex/verified/PHASE5B3_PLAN.md) | 6095 / 33 | FULL | 1–33 |
| [PHASE5B_PLAN.md](../../../docs/codex/verified/PHASE5B_PLAN.md) | 8425 / 53 | FULL | 1–53 |
| [PHASE5B_PROGRESS.md](../../../docs/codex/verified/PHASE5B_PROGRESS.md) | 10540 / 66 | FULL | 1–66 |
| [PHASE5C_GEMINI_REVIEW.md](../../../docs/codex/verified/PHASE5C_GEMINI_REVIEW.md) | 9705 / 48 | FULL | 1–48 |
| [PHASE5C_INTEGRATION_RESULTS.md](../../../docs/codex/verified/PHASE5C_INTEGRATION_RESULTS.md) | 16232 / 106 | FULL | 1–106 |
| [PHASE7_BETA_INTEGRATION.md](../../../docs/codex/verified/PHASE7_BETA_INTEGRATION.md) | 6911 / 48 | FULL | 1–48 |
| [PHASE8_BETA_QA_PLAN.md](../../../docs/codex/verified/PHASE8_BETA_QA_PLAN.md) | 5297 / 60 | FULL | 1–60 |
| [PR10_BETA_PR_DRAFT.md](../../../docs/codex/verified/PR10_BETA_PR_DRAFT.md) | 1739 / 13 | FULL | 1–13 |
| [PR10_CRITICAL_FIXES.md](../../../docs/codex/verified/PR10_CRITICAL_FIXES.md) | 10901 / 55 | FULL | 1–55 |
| [PR10_REGRESSION_RESULTS.md](../../../docs/codex/verified/PR10_REGRESSION_RESULTS.md) | 18041 / 116 | FULL | 1–116 |
| [PROJECT_FACTS.md](../../../docs/codex/verified/PROJECT_FACTS.md) | 8075 / 69 | FULL | 1–69 |
| [PR_01_TO_10_REVIEW.md](../../../docs/codex/verified/PR_01_TO_10_REVIEW.md) | 128635 / 335 | FULL | 1–335 |
| [PR_AUDIT_OVERVIEW.md](../../../docs/codex/verified/PR_AUDIT_OVERVIEW.md) | 8834 / 54 | FULL | 1–54 |
| [PR_DEPENDENCY_GRAPH.md](../../../docs/codex/verified/PR_DEPENDENCY_GRAPH.md) | 5636 / 62 | FULL | 1–62 |
| [PR_RISKS.md](../../../docs/codex/verified/PR_RISKS.md) | 28173 / 236 | FULL | 1–236 |
| [PR_TEST_RESULTS.md](../../../docs/codex/verified/PR_TEST_RESULTS.md) | 15610 / 94 | FULL | 1–94 |
| [R02_FAILURE_INJECTION_TESTS.md](../../../docs/codex/verified/R02_FAILURE_INJECTION_TESTS.md) | 9950 / 77 | FULL | 1–77 |
| [R02_SNAPSHOT_RESTORE_FIX.md](../../../docs/codex/verified/R02_SNAPSHOT_RESTORE_FIX.md) | 8477 / 41 | FULL | 1–41 |
| [RESOURCES_AND_UI.md](../../../docs/codex/verified/RESOURCES_AND_UI.md) | 10038 / 57 | FULL | 1–57 |
| [RISKS.md](../../../docs/codex/verified/RISKS.md) | 14488 / 59 | FULL | 1–59 |
| [RUNTIME_BASELINE.md](../../../docs/codex/verified/RUNTIME_BASELINE.md) | 11052 / 90 | FULL | 1–90 |
| [SAVE_FORMAT.md](../../../docs/codex/verified/SAVE_FORMAT.md) | 15581 / 110 | FULL | 1–110 |
| [TEST_MATRIX.md](../../../docs/codex/verified/TEST_MATRIX.md) | 22550 / 168 | FULL | 1–168 |
| [VERSION_041_ANALYSIS.md](../../../docs/codex/verified/VERSION_041_ANALYSIS.md) | 15901 / 108 | FULL | 1–108 |
| [VERSION_041_DIFF.md](../../../docs/codex/verified/VERSION_041_DIFF.md) | 11168 / 65 | FULL | 1–65 |
| [WINDOWS_BETA_QA_CHECKLIST.md](../../../docs/codex/verified/WINDOWS_BETA_QA_CHECKLIST.md) | 20502 / 121 | FULL | 1–121 |
| [WINDOWS_TESTING.md](../../../docs/codex/verified/WINDOWS_TESTING.md) | 6484 / 70 | FULL | 1–70 |
| [droneflames-architecture.drawio](../../../docs/codex/verified/droneflames-architecture.drawio) | 7482 / 99 | INDEXED | — |
| [pr-dependency-graph.drawio](../../../docs/codex/verified/pr-dependency-graph.drawio) | 7407 / 96 | INDEXED | — |
| [r02-snapshot-restore-lifecycle.drawio](../../../docs/codex/verified/r02-snapshot-restore-lifecycle.drawio) | 8939 / 2 | INDEXED | — |

### docs

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [performance.md](../../../docs/performance.md) | 5607 / 59 | FULL | 1–59 |

### game/.godot

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [extension_list.cfg](../../../game/.godot/extension_list.cfg) | 100 / 2 | FULL | 1–2 |
| [global_script_class_cache.cfg](../../../game/.godot/global_script_class_cache.cfg) | 20742 / 1041 | INDEXED | — |

### game/addons/df_device

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [df_device.gdextension](../../../game/addons/df_device/df_device.gdextension) | 599 / 13 | INDEXED | — |

### game/addons/godotsteam

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [godotsteam.gdextension](../../../game/addons/godotsteam/godotsteam.gdextension) | 2053 / 28 | FULL | 1–28 |

### game/addons/webrtc_native

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [webrtc_native.gdextension](../../../game/addons/webrtc_native/webrtc_native.gdextension) | 920 / 20 | INDEXED | — |

### game/assets/audio/music

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [game.mp3.import](../../../game/assets/audio/music/game.mp3.import) | 151 / 6 | INDEXED | — |
| [menu.mp3.import](../../../game/assets/audio/music/menu.mp3.import) | 151 / 6 | INDEXED | — |
| [opening.ogg.import](../../../game/assets/audio/music/opening.ogg.import) | 174 / 6 | INDEXED | — |

### game/assets/audio/sfx

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [aa_gun.ogg.import](../../../game/assets/audio/sfx/aa_gun.ogg.import) | 174 / 6 | INDEXED | — |
| [aid_sent.ogg.import](../../../game/assets/audio/sfx/aid_sent.ogg.import) | 176 / 6 | INDEXED | — |
| [air_rumble_loop.ogg.import](../../../game/assets/audio/sfx/air_rumble_loop.ogg.import) | 182 / 6 | INDEXED | — |
| [alarm_general_quarters.ogg.import](../../../game/assets/audio/sfx/alarm_general_quarters.ogg.import) | 190 / 6 | INDEXED | — |
| [ambient_battle_loop.ogg.import](../../../game/assets/audio/sfx/ambient_battle_loop.ogg.import) | 186 / 6 | INDEXED | — |
| [ambient_wind_loop.ogg.import](../../../game/assets/audio/sfx/ambient_wind_loop.ogg.import) | 185 / 6 | INDEXED | — |
| [artillery_far.ogg.import](../../../game/assets/audio/sfx/artillery_far.ogg.import) | 181 / 6 | INDEXED | — |
| [artillery_fire.ogg.import](../../../game/assets/audio/sfx/artillery_fire.ogg.import) | 181 / 6 | INDEXED | — |
| [asm_flyby.ogg.import](../../../game/assets/audio/sfx/asm_flyby.ogg.import) | 177 / 6 | INDEXED | — |
| [asm_launch.ogg.import](../../../game/assets/audio/sfx/asm_launch.ogg.import) | 178 / 6 | INDEXED | — |
| [atgm_hit.ogg.import](../../../game/assets/audio/sfx/atgm_hit.ogg.import) | 176 / 6 | INDEXED | — |
| [atgm_launch.ogg.import](../../../game/assets/audio/sfx/atgm_launch.ogg.import) | 179 / 6 | INDEXED | — |
| [attack_jet_loop.ogg.import](../../../game/assets/audio/sfx/attack_jet_loop.ogg.import) | 183 / 6 | INDEXED | — |
| [battle_close_loop.ogg.import](../../../game/assets/audio/sfx/battle_close_loop.ogg.import) | 184 / 6 | INDEXED | — |
| [birds_day_loop.ogg.import](../../../game/assets/audio/sfx/birds_day_loop.ogg.import) | 182 / 6 | INDEXED | — |
| [bomber_loop.ogg.import](../../../game/assets/audio/sfx/bomber_loop.ogg.import) | 178 / 6 | INDEXED | — |
| [bomber_pass.ogg.import](../../../game/assets/audio/sfx/bomber_pass.ogg.import) | 179 / 6 | INDEXED | — |
| [bow_wash_loop.ogg.import](../../../game/assets/audio/sfx/bow_wash_loop.ogg.import) | 181 / 6 | INDEXED | — |
| [building_collapse.ogg.import](../../../game/assets/audio/sfx/building_collapse.ogg.import) | 185 / 6 | INDEXED | — |
| [call_to_arms.ogg.import](../../../game/assets/audio/sfx/call_to_arms.ogg.import) | 180 / 6 | INDEXED | — |
| [cannonade_loop.ogg.import](../../../game/assets/audio/sfx/cannonade_loop.ogg.import) | 182 / 6 | INDEXED | — |
| [chaff_burst.ogg.import](../../../game/assets/audio/sfx/chaff_burst.ogg.import) | 179 / 6 | INDEXED | — |
| [ciws_burst.ogg.import](../../../game/assets/audio/sfx/ciws_burst.ogg.import) | 177 / 6 | INDEXED | — |
| [concrete_thud.ogg.import](../../../game/assets/audio/sfx/concrete_thud.ogg.import) | 181 / 6 | INDEXED | — |
| [conference_gong.ogg.import](../../../game/assets/audio/sfx/conference_gong.ogg.import) | 182 / 6 | INDEXED | — |
| [container_clank.ogg.import](../../../game/assets/audio/sfx/container_clank.ogg.import) | 183 / 6 | INDEXED | — |
| [convoy_horn.ogg.import](../../../game/assets/audio/sfx/convoy_horn.ogg.import) | 178 / 6 | INDEXED | — |
| [crickets_night_loop.ogg.import](../../../game/assets/audio/sfx/crickets_night_loop.ogg.import) | 186 / 6 | INDEXED | — |
| [cruise_launch_vls.ogg.import](../../../game/assets/audio/sfx/cruise_launch_vls.ogg.import) | 185 / 6 | INDEXED | — |
| [cruise_missile_loop.ogg.import](../../../game/assets/audio/sfx/cruise_missile_loop.ogg.import) | 187 / 6 | INDEXED | — |
| [cruise_missile_pass.ogg.import](../../../game/assets/audio/sfx/cruise_missile_pass.ogg.import) | 187 / 6 | INDEXED | — |
| [decoy_flares.ogg.import](../../../game/assets/audio/sfx/decoy_flares.ogg.import) | 180 / 6 | INDEXED | — |
| [dig_trench.ogg.import](../../../game/assets/audio/sfx/dig_trench.ogg.import) | 178 / 6 | INDEXED | — |
| [dock_crane.ogg.import](../../../game/assets/audio/sfx/dock_crane.ogg.import) | 178 / 6 | INDEXED | — |
| [drone_buzz_loop.ogg.import](../../../game/assets/audio/sfx/drone_buzz_loop.ogg.import) | 183 / 6 | INDEXED | — |
| [drone_launch.ogg.import](../../../game/assets/audio/sfx/drone_launch.ogg.import) | 179 / 6 | INDEXED | — |
| [ew_hum.ogg.import](../../../game/assets/audio/sfx/ew_hum.ogg.import) | 174 / 6 | INDEXED | — |
| [expl_big_1.ogg.import](../../../game/assets/audio/sfx/expl_big_1.ogg.import) | 178 / 6 | INDEXED | — |
| [expl_big_2.ogg.import](../../../game/assets/audio/sfx/expl_big_2.ogg.import) | 178 / 6 | INDEXED | — |
| [expl_far.ogg.import](../../../game/assets/audio/sfx/expl_far.ogg.import) | 176 / 6 | INDEXED | — |
| [expl_small_1.ogg.import](../../../game/assets/audio/sfx/expl_small_1.ogg.import) | 179 / 6 | INDEXED | — |
| [expl_small_2.ogg.import](../../../game/assets/audio/sfx/expl_small_2.ogg.import) | 180 / 6 | INDEXED | — |
| [far_boom_1.ogg.import](../../../game/assets/audio/sfx/far_boom_1.ogg.import) | 178 / 6 | INDEXED | — |
| [far_boom_2.ogg.import](../../../game/assets/audio/sfx/far_boom_2.ogg.import) | 178 / 6 | INDEXED | — |
| [far_boom_3.ogg.import](../../../game/assets/audio/sfx/far_boom_3.ogg.import) | 177 / 6 | INDEXED | — |
| [fire_loop.ogg.import](../../../game/assets/audio/sfx/fire_loop.ogg.import) | 177 / 6 | INDEXED | — |
| [fpv_buzz.ogg.import](../../../game/assets/audio/sfx/fpv_buzz.ogg.import) | 176 / 6 | INDEXED | — |
| [grenade.ogg.import](../../../game/assets/audio/sfx/grenade.ogg.import) | 175 / 6 | INDEXED | — |
| [heli_loop.ogg.import](../../../game/assets/audio/sfx/heli_loop.ogg.import) | 177 / 6 | INDEXED | — |
| [hyper_launch.ogg.import](../../../game/assets/audio/sfx/hyper_launch.ogg.import) | 180 / 6 | INDEXED | — |
| [industry_hum_loop.ogg.import](../../../game/assets/audio/sfx/industry_hum_loop.ogg.import) | 185 / 6 | INDEXED | — |
| [intercept_pop.ogg.import](../../../game/assets/audio/sfx/intercept_pop.ogg.import) | 180 / 6 | INDEXED | — |
| [jet_flyby.ogg.import](../../../game/assets/audio/sfx/jet_flyby.ogg.import) | 176 / 6 | INDEXED | — |
| [jet_pass.ogg.import](../../../game/assets/audio/sfx/jet_pass.ogg.import) | 176 / 6 | INDEXED | — |
| [jet_uav_loop.ogg.import](../../../game/assets/audio/sfx/jet_uav_loop.ogg.import) | 180 / 6 | INDEXED | — |
| [jet_uav_pass.ogg.import](../../../game/assets/audio/sfx/jet_uav_pass.ogg.import) | 180 / 6 | INDEXED | — |
| [kab_fall.ogg.import](../../../game/assets/audio/sfx/kab_fall.ogg.import) | 176 / 6 | INDEXED | — |
| [mg_burst.ogg.import](../../../game/assets/audio/sfx/mg_burst.ogg.import) | 175 / 6 | INDEXED | — |
| [missile_cruise_launch.ogg.import](../../../game/assets/audio/sfx/missile_cruise_launch.ogg.import) | 188 / 6 | INDEXED | — |
| [missile_launch.ogg.import](../../../game/assets/audio/sfx/missile_launch.ogg.import) | 181 / 6 | INDEXED | — |
| [missile_whistle.ogg.import](../../../game/assets/audio/sfx/missile_whistle.ogg.import) | 182 / 6 | INDEXED | — |
| [mlrs_salvo.ogg.import](../../../game/assets/audio/sfx/mlrs_salvo.ogg.import) | 178 / 6 | INDEXED | — |
| [mortar_fire.ogg.import](../../../game/assets/audio/sfx/mortar_fire.ogg.import) | 178 / 6 | INDEXED | — |
| [naval_gun.ogg.import](../../../game/assets/audio/sfx/naval_gun.ogg.import) | 176 / 6 | INDEXED | — |
| [navbase_ambient_loop.ogg.import](../../../game/assets/audio/sfx/navbase_ambient_loop.ogg.import) | 188 / 6 | INDEXED | — |
| [net_catch.ogg.import](../../../game/assets/audio/sfx/net_catch.ogg.import) | 177 / 6 | INDEXED | — |
| [protest_note.ogg.import](../../../game/assets/audio/sfx/protest_note.ogg.import) | 180 / 6 | INDEXED | — |
| [pumpjack_loop.ogg.import](../../../game/assets/audio/sfx/pumpjack_loop.ogg.import) | 181 / 6 | INDEXED | — |
| [radar_ping.ogg.import](../../../game/assets/audio/sfx/radar_ping.ogg.import) | 178 / 6 | INDEXED | — |
| [recon_drone_buzz.ogg.import](../../../game/assets/audio/sfx/recon_drone_buzz.ogg.import) | 184 / 6 | INDEXED | — |
| [repair_work.ogg.import](../../../game/assets/audio/sfx/repair_work.ogg.import) | 178 / 6 | INDEXED | — |
| [rifle_burst_1.ogg.import](../../../game/assets/audio/sfx/rifle_burst_1.ogg.import) | 181 / 6 | INDEXED | — |
| [rifle_burst_2.ogg.import](../../../game/assets/audio/sfx/rifle_burst_2.ogg.import) | 180 / 6 | INDEXED | — |
| [river_loop.ogg.import](../../../game/assets/audio/sfx/river_loop.ogg.import) | 178 / 6 | INDEXED | — |
| [rpg_fire.ogg.import](../../../game/assets/audio/sfx/rpg_fire.ogg.import) | 176 / 6 | INDEXED | — |
| [sam_launch.ogg.import](../../../game/assets/audio/sfx/sam_launch.ogg.import) | 178 / 6 | INDEXED | — |
| [sawmill_saw.ogg.import](../../../game/assets/audio/sfx/sawmill_saw.ogg.import) | 179 / 6 | INDEXED | — |
| [sea_explosion.ogg.import](../../../game/assets/audio/sfx/sea_explosion.ogg.import) | 180 / 6 | INDEXED | — |
| [shell_whistle_in.ogg.import](../../../game/assets/audio/sfx/shell_whistle_in.ogg.import) | 184 / 6 | INDEXED | — |
| [ship_engine_loop.ogg.import](../../../game/assets/audio/sfx/ship_engine_loop.ogg.import) | 184 / 6 | INDEXED | — |
| [ship_fire_loop.ogg.import](../../../game/assets/audio/sfx/ship_fire_loop.ogg.import) | 182 / 6 | INDEXED | — |
| [ship_hit.ogg.import](../../../game/assets/audio/sfx/ship_hit.ogg.import) | 176 / 6 | INDEXED | — |
| [ship_horn.ogg.import](../../../game/assets/audio/sfx/ship_horn.ogg.import) | 177 / 6 | INDEXED | — |
| [ship_sam_launch.ogg.import](../../../game/assets/audio/sfx/ship_sam_launch.ogg.import) | 183 / 6 | INDEXED | — |
| [ship_sinking.ogg.import](../../../game/assets/audio/sfx/ship_sinking.ogg.import) | 180 / 6 | INDEXED | — |
| [siren_loop.ogg.import](../../../game/assets/audio/sfx/siren_loop.ogg.import) | 178 / 6 | INDEXED | — |
| [splash_big.ogg.import](../../../game/assets/audio/sfx/splash_big.ogg.import) | 177 / 6 | INDEXED | — |
| [surf_loop.ogg.import](../../../game/assets/audio/sfx/surf_loop.ogg.import) | 177 / 6 | INDEXED | — |
| [tank_cannon.ogg.import](../../../game/assets/audio/sfx/tank_cannon.ogg.import) | 179 / 6 | INDEXED | — |
| [territory_claim.ogg.import](../../../game/assets/audio/sfx/territory_claim.ogg.import) | 183 / 6 | INDEXED | — |
| [town_hum_loop.ogg.import](../../../game/assets/audio/sfx/town_hum_loop.ogg.import) | 181 / 6 | INDEXED | — |
| [train_horn.ogg.import](../../../game/assets/audio/sfx/train_horn.ogg.import) | 178 / 6 | INDEXED | — |
| [train_roll_loop.ogg.import](../../../game/assets/audio/sfx/train_roll_loop.ogg.import) | 183 / 6 | INDEXED | — |
| [treaty_signed.ogg.import](../../../game/assets/audio/sfx/treaty_signed.ogg.import) | 181 / 6 | INDEXED | — |
| [truck_pass.ogg.import](../../../game/assets/audio/sfx/truck_pass.ogg.import) | 178 / 6 | INDEXED | — |
| [ui_alert.ogg.import](../../../game/assets/audio/sfx/ui_alert.ogg.import) | 176 / 6 | INDEXED | — |
| [ui_build.ogg.import](../../../game/assets/audio/sfx/ui_build.ogg.import) | 176 / 6 | INDEXED | — |
| [ui_cancel.ogg.import](../../../game/assets/audio/sfx/ui_cancel.ogg.import) | 177 / 6 | INDEXED | — |
| [ui_capture.ogg.import](../../../game/assets/audio/sfx/ui_capture.ogg.import) | 177 / 6 | INDEXED | — |
| [ui_city_lost.ogg.import](../../../game/assets/audio/sfx/ui_city_lost.ogg.import) | 180 / 6 | INDEXED | — |
| [ui_click.ogg.import](../../../game/assets/audio/sfx/ui_click.ogg.import) | 175 / 6 | INDEXED | — |
| [ui_close.ogg.import](../../../game/assets/audio/sfx/ui_close.ogg.import) | 176 / 6 | INDEXED | — |
| [ui_defeat.ogg.import](../../../game/assets/audio/sfx/ui_defeat.ogg.import) | 177 / 6 | INDEXED | — |
| [ui_error.ogg.import](../../../game/assets/audio/sfx/ui_error.ogg.import) | 176 / 6 | INDEXED | — |
| [ui_money.ogg.import](../../../game/assets/audio/sfx/ui_money.ogg.import) | 176 / 6 | INDEXED | — |
| [ui_open.ogg.import](../../../game/assets/audio/sfx/ui_open.ogg.import) | 174 / 6 | INDEXED | — |
| [ui_select.ogg.import](../../../game/assets/audio/sfx/ui_select.ogg.import) | 177 / 6 | INDEXED | — |
| [ui_tab.ogg.import](../../../game/assets/audio/sfx/ui_tab.ogg.import) | 174 / 6 | INDEXED | — |
| [ui_victory.ogg.import](../../../game/assets/audio/sfx/ui_victory.ogg.import) | 178 / 6 | INDEXED | — |
| [ui_war.ogg.import](../../../game/assets/audio/sfx/ui_war.ogg.import) | 174 / 6 | INDEXED | — |
| [vassal_sworn.ogg.import](../../../game/assets/audio/sfx/vassal_sworn.ogg.import) | 180 / 6 | INDEXED | — |
| [vls_hatch_open.ogg.import](../../../game/assets/audio/sfx/vls_hatch_open.ogg.import) | 182 / 6 | INDEXED | — |
| [warship_horn.ogg.import](../../../game/assets/audio/sfx/warship_horn.ogg.import) | 179 / 6 | INDEXED | — |

### game/assets/fonts

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [DFSymbols-Bold.ttf.import](../../../game/assets/fonts/DFSymbols-Bold.ttf.import) | 171 / 6 | INDEXED | — |
| [PressStart2P-Regular.ttf.import](../../../game/assets/fonts/PressStart2P-Regular.ttf.import) | 177 / 6 | INDEXED | — |
| [Rubik-Variable.ttf.import](../../../game/assets/fonts/Rubik-Variable.ttf.import) | 171 / 6 | INDEXED | — |
| [RussoOne-Regular.ttf.import](../../../game/assets/fonts/RussoOne-Regular.ttf.import) | 172 / 6 | INDEXED | — |

### game/assets/palettes

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [main.png.import](../../../game/assets/palettes/main.png.import) | 193 / 9 | INDEXED | — |
| [main_named.json](../../../game/assets/palettes/main_named.json) | 1669 / 68 | INDEXED | — |
| [terrain19.json](../../../game/assets/palettes/terrain19.json) | 1615 / 24 | INDEXED | — |
| [terrain_colors.json](../../../game/assets/palettes/terrain_colors.json) | 1201 / 112 | INDEXED | — |

### game/assets/sprites

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [atlas_acc1.json](../../../game/assets/sprites/atlas_acc1.json) | 801 / 67 | INDEXED | — |
| [atlas_acc1.png.import](../../../game/assets/sprites/atlas_acc1.png.import) | 198 / 9 | INDEXED | — |
| [atlas_air316.json](../../../game/assets/sprites/atlas_air316.json) | 2229 / 121 | INDEXED | — |
| [atlas_air316.png.import](../../../game/assets/sprites/atlas_air316.png.import) | 200 / 9 | INDEXED | — |
| [atlas_ally320.json](../../../game/assets/sprites/atlas_ally320.json) | 897 / 76 | INDEXED | — |
| [atlas_ally320.png.import](../../../game/assets/sprites/atlas_ally320.png.import) | 202 / 9 | INDEXED | — |
| [atlas_carrier3.json](../../../game/assets/sprites/atlas_carrier3.json) | 11135 / 1147 | INDEXED | — |
| [atlas_carrier3ui.json](../../../game/assets/sprites/atlas_carrier3ui.json) | 1203 / 90 | INDEXED | — |
| [atlas_cm28.json](../../../game/assets/sprites/atlas_cm28.json) | 687 / 48 | INDEXED | — |
| [atlas_cm28.png.import](../../../game/assets/sprites/atlas_cm28.png.import) | 198 / 9 | INDEXED | — |
| [atlas_cosm_bn.json](../../../game/assets/sprites/atlas_cosm_bn.json) | 3087 / 249 | INDEXED | — |
| [atlas_cosm_bn.png.import](../../../game/assets/sprites/atlas_cosm_bn.png.import) | 202 / 9 | INDEXED | — |
| [atlas_cosm_bn_anim.json](../../../game/assets/sprites/atlas_cosm_bn_anim.json) | 4595 / 351 | INDEXED | — |
| [atlas_cosm_bn_anim.png.import](../../../game/assets/sprites/atlas_cosm_bn_anim.png.import) | 207 / 9 | INDEXED | — |
| [atlas_cosm_fr.json](../../../game/assets/sprites/atlas_cosm_fr.json) | 3028 / 249 | INDEXED | — |
| [atlas_cosm_fr.png.import](../../../game/assets/sprites/atlas_cosm_fr.png.import) | 202 / 9 | INDEXED | — |
| [atlas_cosm_tt.json](../../../game/assets/sprites/atlas_cosm_tt.json) | 1568 / 136 | INDEXED | — |
| [atlas_cosm_tt.png.import](../../../game/assets/sprites/atlas_cosm_tt.png.import) | 202 / 9 | INDEXED | — |
| [atlas_debris314.json](../../../game/assets/sprites/atlas_debris314.json) | 3258 / 311 | INDEXED | — |
| [atlas_debris314.png.import](../../../game/assets/sprites/atlas_debris314.png.import) | 204 / 9 | INDEXED | — |
| [atlas_dip26.json](../../../game/assets/sprites/atlas_dip26.json) | 2496 / 193 | INDEXED | — |
| [atlas_dip26.png.import](../../../game/assets/sprites/atlas_dip26.png.import) | 200 / 9 | INDEXED | — |
| [atlas_dip331.json](../../../game/assets/sprites/atlas_dip331.json) | 3865 / 305 | INDEXED | — |
| [atlas_dip331.png.import](../../../game/assets/sprites/atlas_dip331.png.import) | 200 / 9 | INDEXED | — |
| [atlas_dmg314_asia.json](../../../game/assets/sprites/atlas_dmg314_asia.json) | 40813 / 3212 | INDEXED | — |
| [atlas_dmg314_asia.png.import](../../../game/assets/sprites/atlas_dmg314_asia.png.import) | 206 / 9 | INDEXED | — |
| [atlas_dmg314_clad.json](../../../game/assets/sprites/atlas_dmg314_clad.json) | 190399 / 13836 | INDEXED | — |
| [atlas_dmg314_clad.png.import](../../../game/assets/sprites/atlas_dmg314_clad.png.import) | 206 / 9 | INDEXED | — |
| [atlas_dmg314_east.json](../../../game/assets/sprites/atlas_dmg314_east.json) | 38771 / 3212 | INDEXED | — |
| [atlas_dmg314_east.png.import](../../../game/assets/sprites/atlas_dmg314_east.png.import) | 205 / 9 | INDEXED | — |
| [atlas_dmg314_usa.json](../../../game/assets/sprites/atlas_dmg314_usa.json) | 40373 / 3212 | INDEXED | — |
| [atlas_dmg314_usa.png.import](../../../game/assets/sprites/atlas_dmg314_usa.png.import) | 205 / 9 | INDEXED | — |
| [atlas_dmg314_west.json](../../../game/assets/sprites/atlas_dmg314_west.json) | 40770 / 3212 | INDEXED | — |
| [atlas_dmg314_west.png.import](../../../game/assets/sprites/atlas_dmg314_west.png.import) | 206 / 9 | INDEXED | — |
| [atlas_fauna319.json](../../../game/assets/sprites/atlas_fauna319.json) | 6068 / 528 | INDEXED | — |
| [atlas_fauna319.png.import](../../../game/assets/sprites/atlas_fauna319.png.import) | 203 / 9 | INDEXED | — |
| [atlas_flora.json](../../../game/assets/sprites/atlas_flora.json) | 8896 / 699 | INDEXED | — |
| [atlas_flora.png.import](../../../game/assets/sprites/atlas_flora.png.import) | 199 / 9 | INDEXED | — |
| [atlas_fui_crane.json](../../../game/assets/sprites/atlas_fui_crane.json) | 816 / 50 | INDEXED | — |
| [atlas_fui_crane.png.import](../../../game/assets/sprites/atlas_fui_crane.png.import) | 204 / 9 | INDEXED | — |
| [atlas_fx.json](../../../game/assets/sprites/atlas_fx.json) | 1656 / 125 | INDEXED | — |
| [atlas_fx.png.import](../../../game/assets/sprites/atlas_fx.png.import) | 197 / 9 | INDEXED | — |
| [atlas_fx2.json](../../../game/assets/sprites/atlas_fx2.json) | 1449 / 105 | INDEXED | — |
| [atlas_fx2.png.import](../../../game/assets/sprites/atlas_fx2.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx3.json](../../../game/assets/sprites/atlas_fx3.json) | 825 / 55 | INDEXED | — |
| [atlas_fx3.png.import](../../../game/assets/sprites/atlas_fx3.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx314.json](../../../game/assets/sprites/atlas_fx314.json) | 4786 / 373 | INDEXED | — |
| [atlas_fx314.png.import](../../../game/assets/sprites/atlas_fx314.png.import) | 200 / 9 | INDEXED | — |
| [atlas_fx4.json](../../../game/assets/sprites/atlas_fx4.json) | 1197 / 85 | INDEXED | — |
| [atlas_fx4.png.import](../../../game/assets/sprites/atlas_fx4.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx5.json](../../../game/assets/sprites/atlas_fx5.json) | 734 / 60 | INDEXED | — |
| [atlas_fx5.png.import](../../../game/assets/sprites/atlas_fx5.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx6.json](../../../game/assets/sprites/atlas_fx6.json) | 1234 / 90 | INDEXED | — |
| [atlas_fx6.png.import](../../../game/assets/sprites/atlas_fx6.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx8.json](../../../game/assets/sprites/atlas_fx8.json) | 738 / 50 | INDEXED | — |
| [atlas_fx8.png.import](../../../game/assets/sprites/atlas_fx8.png.import) | 198 / 9 | INDEXED | — |
| [atlas_fx_navy.json](../../../game/assets/sprites/atlas_fx_navy.json) | 2651 / 169 | INDEXED | — |
| [atlas_fx_navy.png.import](../../../game/assets/sprites/atlas_fx_navy.png.import) | 201 / 9 | INDEXED | — |
| [atlas_kpp30.json](../../../game/assets/sprites/atlas_kpp30.json) | 73218 / 6260 | INDEXED | — |
| [atlas_kpp30.png.import](../../../game/assets/sprites/atlas_kpp30.png.import) | 199 / 9 | INDEXED | — |
| [atlas_life.json](../../../game/assets/sprites/atlas_life.json) | 6198 / 503 | INDEXED | — |
| [atlas_life.png.import](../../../game/assets/sprites/atlas_life.png.import) | 199 / 9 | INDEXED | — |
| [atlas_mines27.json](../../../game/assets/sprites/atlas_mines27.json) | 6799 / 449 | INDEXED | — |
| [atlas_mines27.png.import](../../../game/assets/sprites/atlas_mines27.png.import) | 201 / 9 | INDEXED | — |
| [atlas_navy1.json](../../../game/assets/sprites/atlas_navy1.json) | 32713 / 2649 | INDEXED | — |
| [atlas_navy1.png.import](../../../game/assets/sprites/atlas_navy1.png.import) | 199 / 9 | INDEXED | — |
| [atlas_navy30.json](../../../game/assets/sprites/atlas_navy30.json) | 1691 / 92 | INDEXED | — |
| [atlas_navy30.png.import](../../../game/assets/sprites/atlas_navy30.png.import) | 201 / 9 | INDEXED | — |
| [atlas_net29.json](../../../game/assets/sprites/atlas_net29.json) | 2188 / 179 | INDEXED | — |
| [atlas_net29.png.import](../../../game/assets/sprites/atlas_net29.png.import) | 200 / 9 | INDEXED | — |
| [atlas_nuke2.json](../../../game/assets/sprites/atlas_nuke2.json) | 3087 / 209 | INDEXED | — |
| [atlas_nuke2ui.json](../../../game/assets/sprites/atlas_nuke2ui.json) | 482 / 40 | INDEXED | — |
| [atlas_rail332.json](../../../game/assets/sprites/atlas_rail332.json) | 8430 / 549 | INDEXED | — |
| [atlas_rail332.png.import](../../../game/assets/sprites/atlas_rail332.png.import) | 202 / 9 | INDEXED | — |
| [atlas_step4.json](../../../game/assets/sprites/atlas_step4.json) | 1524 / 110 | INDEXED | — |
| [atlas_step4ui.json](../../../game/assets/sprites/atlas_step4ui.json) | 5831 / 440 | INDEXED | — |
| [atlas_step5ui.json](../../../game/assets/sprites/atlas_step5ui.json) | 1193 / 90 | INDEXED | — |
| [atlas_style_asia.json](../../../game/assets/sprites/atlas_style_asia.json) | 22689 / 2168 | INDEXED | — |
| [atlas_style_asia.png.import](../../../game/assets/sprites/atlas_style_asia.png.import) | 205 / 9 | INDEXED | — |
| [atlas_style_clad.json](../../../game/assets/sprites/atlas_style_clad.json) | 49197 / 3255 | INDEXED | — |
| [atlas_style_clad.png.import](../../../game/assets/sprites/atlas_style_clad.png.import) | 205 / 9 | INDEXED | — |
| [atlas_style_usa.json](../../../game/assets/sprites/atlas_style_usa.json) | 23159 / 2241 | INDEXED | — |
| [atlas_style_usa.png.import](../../../game/assets/sprites/atlas_style_usa.png.import) | 204 / 9 | INDEXED | — |
| [atlas_style_west.json](../../../game/assets/sprites/atlas_style_west.json) | 26115 / 2645 | INDEXED | — |
| [atlas_style_west.png.import](../../../game/assets/sprites/atlas_style_west.png.import) | 205 / 9 | INDEXED | — |
| [atlas_ui.json](../../../game/assets/sprites/atlas_ui.json) | 3039 / 276 | INDEXED | — |
| [atlas_ui.png.import](../../../game/assets/sprites/atlas_ui.png.import) | 197 / 9 | INDEXED | — |
| [atlas_ui10.json](../../../game/assets/sprites/atlas_ui10.json) | 1667 / 142 | INDEXED | — |
| [atlas_ui10.png.import](../../../game/assets/sprites/atlas_ui10.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui11.json](../../../game/assets/sprites/atlas_ui11.json) | 987 / 82 | INDEXED | — |
| [atlas_ui11.png.import](../../../game/assets/sprites/atlas_ui11.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui12.json](../../../game/assets/sprites/atlas_ui12.json) | 214 / 18 | INDEXED | — |
| [atlas_ui12.png.import](../../../game/assets/sprites/atlas_ui12.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui13.json](../../../game/assets/sprites/atlas_ui13.json) | 258 / 22 | INDEXED | — |
| [atlas_ui13.png.import](../../../game/assets/sprites/atlas_ui13.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui14.json](../../../game/assets/sprites/atlas_ui14.json) | 563 / 46 | INDEXED | — |
| [atlas_ui14.png.import](../../../game/assets/sprites/atlas_ui14.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui15.json](../../../game/assets/sprites/atlas_ui15.json) | 1564 / 124 | INDEXED | — |
| [atlas_ui15.png.import](../../../game/assets/sprites/atlas_ui15.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui16.json](../../../game/assets/sprites/atlas_ui16.json) | 856 / 70 | INDEXED | — |
| [atlas_ui16.png.import](../../../game/assets/sprites/atlas_ui16.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui17.json](../../../game/assets/sprites/atlas_ui17.json) | 308 / 25 | INDEXED | — |
| [atlas_ui17.png.import](../../../game/assets/sprites/atlas_ui17.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui18.json](../../../game/assets/sprites/atlas_ui18.json) | 219 / 18 | INDEXED | — |
| [atlas_ui18.png.import](../../../game/assets/sprites/atlas_ui18.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui19.json](../../../game/assets/sprites/atlas_ui19.json) | 5005 / 389 | INDEXED | — |
| [atlas_ui19.png.import](../../../game/assets/sprites/atlas_ui19.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui2.json](../../../game/assets/sprites/atlas_ui2.json) | 1344 / 118 | INDEXED | — |
| [atlas_ui2.png.import](../../../game/assets/sprites/atlas_ui2.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui20.json](../../../game/assets/sprites/atlas_ui20.json) | 2352 / 193 | INDEXED | — |
| [atlas_ui20.png.import](../../../game/assets/sprites/atlas_ui20.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui3.json](../../../game/assets/sprites/atlas_ui3.json) | 603 / 52 | INDEXED | — |
| [atlas_ui3.png.import](../../../game/assets/sprites/atlas_ui3.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui316.json](../../../game/assets/sprites/atlas_ui316.json) | 253 / 17 | INDEXED | — |
| [atlas_ui316.png.import](../../../game/assets/sprites/atlas_ui316.png.import) | 200 / 9 | INDEXED | — |
| [atlas_ui319.json](../../../game/assets/sprites/atlas_ui319.json) | 1048 / 88 | INDEXED | — |
| [atlas_ui319.png.import](../../../game/assets/sprites/atlas_ui319.png.import) | 199 / 9 | INDEXED | — |
| [atlas_ui335.json](../../../game/assets/sprites/atlas_ui335.json) | 305 / 25 | INDEXED | — |
| [atlas_ui335.png.import](../../../game/assets/sprites/atlas_ui335.png.import) | 200 / 9 | INDEXED | — |
| [atlas_ui4.json](../../../game/assets/sprites/atlas_ui4.json) | 1101 / 94 | INDEXED | — |
| [atlas_ui4.png.import](../../../game/assets/sprites/atlas_ui4.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui5.json](../../../game/assets/sprites/atlas_ui5.json) | 814 / 70 | INDEXED | — |
| [atlas_ui5.png.import](../../../game/assets/sprites/atlas_ui5.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui6.json](../../../game/assets/sprites/atlas_ui6.json) | 1037 / 88 | INDEXED | — |
| [atlas_ui6.png.import](../../../game/assets/sprites/atlas_ui6.png.import) | 197 / 9 | INDEXED | — |
| [atlas_ui7.json](../../../game/assets/sprites/atlas_ui7.json) | 1597 / 136 | INDEXED | — |
| [atlas_ui7.png.import](../../../game/assets/sprites/atlas_ui7.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui8.json](../../../game/assets/sprites/atlas_ui8.json) | 668 / 58 | INDEXED | — |
| [atlas_ui8.png.import](../../../game/assets/sprites/atlas_ui8.png.import) | 198 / 9 | INDEXED | — |
| [atlas_ui9.json](../../../game/assets/sprites/atlas_ui9.json) | 5072 / 484 | INDEXED | — |
| [atlas_ui9.png.import](../../../game/assets/sprites/atlas_ui9.png.import) | 198 / 9 | INDEXED | — |
| [atlas_units314.json](../../../game/assets/sprites/atlas_units314.json) | 48164 / 3108 | INDEXED | — |
| [atlas_units314.png.import](../../../game/assets/sprites/atlas_units314.png.import) | 203 / 9 | INDEXED | — |
| [atlas_uran30.json](../../../game/assets/sprites/atlas_uran30.json) | 8282 / 621 | INDEXED | — |
| [atlas_uran30.png.import](../../../game/assets/sprites/atlas_uran30.png.import) | 201 / 9 | INDEXED | — |
| [atlas_uran30ui.json](../../../game/assets/sprites/atlas_uran30ui.json) | 469 / 40 | INDEXED | — |
| [atlas_uran30ui.png.import](../../../game/assets/sprites/atlas_uran30ui.png.import) | 202 / 9 | INDEXED | — |
| [atlas_vfx19.json](../../../game/assets/sprites/atlas_vfx19.json) | 4451 / 360 | INDEXED | — |
| [atlas_vfx19.png.import](../../../game/assets/sprites/atlas_vfx19.png.import) | 200 / 9 | INDEXED | — |
| [atlas_world.json](../../../game/assets/sprites/atlas_world.json) | 11462 / 796 | INDEXED | — |
| [atlas_world.png.import](../../../game/assets/sprites/atlas_world.png.import) | 200 / 9 | INDEXED | — |
| [atlas_world10.json](../../../game/assets/sprites/atlas_world10.json) | 4928 / 295 | INDEXED | — |
| [atlas_world10.png.import](../../../game/assets/sprites/atlas_world10.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world11.json](../../../game/assets/sprites/atlas_world11.json) | 17051 / 1780 | INDEXED | — |
| [atlas_world11.png.import](../../../game/assets/sprites/atlas_world11.png.import) | 202 / 9 | INDEXED | — |
| [atlas_world12.json](../../../game/assets/sprites/atlas_world12.json) | 1218 / 81 | INDEXED | — |
| [atlas_world12.png.import](../../../game/assets/sprites/atlas_world12.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world13.json](../../../game/assets/sprites/atlas_world13.json) | 707 / 47 | INDEXED | — |
| [atlas_world13.png.import](../../../game/assets/sprites/atlas_world13.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world2.json](../../../game/assets/sprites/atlas_world2.json) | 5454 / 370 | INDEXED | — |
| [atlas_world2.png.import](../../../game/assets/sprites/atlas_world2.png.import) | 200 / 9 | INDEXED | — |
| [atlas_world3.json](../../../game/assets/sprites/atlas_world3.json) | 6739 / 455 | INDEXED | — |
| [atlas_world3.png.import](../../../game/assets/sprites/atlas_world3.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world4.json](../../../game/assets/sprites/atlas_world4.json) | 1948 / 115 | INDEXED | — |
| [atlas_world4.png.import](../../../game/assets/sprites/atlas_world4.png.import) | 200 / 9 | INDEXED | — |
| [atlas_world5.json](../../../game/assets/sprites/atlas_world5.json) | 3536 / 193 | INDEXED | — |
| [atlas_world5.png.import](../../../game/assets/sprites/atlas_world5.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world6.json](../../../game/assets/sprites/atlas_world6.json) | 9267 / 564 | INDEXED | — |
| [atlas_world6.png.import](../../../game/assets/sprites/atlas_world6.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world7.json](../../../game/assets/sprites/atlas_world7.json) | 5439 / 323 | INDEXED | — |
| [atlas_world7.png.import](../../../game/assets/sprites/atlas_world7.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world8.json](../../../game/assets/sprites/atlas_world8.json) | 2901 / 186 | INDEXED | — |
| [atlas_world8.png.import](../../../game/assets/sprites/atlas_world8.png.import) | 201 / 9 | INDEXED | — |
| [atlas_world9.json](../../../game/assets/sprites/atlas_world9.json) | 9670 / 666 | INDEXED | — |
| [atlas_world9.png.import](../../../game/assets/sprites/atlas_world9.png.import) | 200 / 9 | INDEXED | — |
| [det28_navyfx.json](../../../game/assets/sprites/det28_navyfx.json) | 870 / 73 | INDEXED | — |
| [det28_navyfx.png.import](../../../game/assets/sprites/det28_navyfx.png.import) | 201 / 9 | INDEXED | — |
| [det30_fx.json](../../../game/assets/sprites/det30_fx.json) | 1421 / 109 | INDEXED | — |
| [det30_fx.png.import](../../../game/assets/sprites/det30_fx.png.import) | 196 / 9 | INDEXED | — |
| [lang_bg340.png.import](../../../game/assets/sprites/lang_bg340.png.import) | 199 / 9 | INDEXED | — |
| [style_cards29.png.import](../../../game/assets/sprites/style_cards29.png.import) | 201 / 9 | INDEXED | — |
| [style_cards31.png.import](../../../game/assets/sprites/style_cards31.png.import) | 202 / 9 | INDEXED | — |
| [vfx19_clouds.png.import](../../../game/assets/sprites/vfx19_clouds.png.import) | 201 / 9 | INDEXED | — |

### game/assets/video/tutorial

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [tutorial_clips.json](../../../game/assets/video/tutorial/tutorial_clips.json) | 16733 / 654 | INDEXED | — |

### game/core

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [air_sfx.gd](../../../game/core/air_sfx.gd) | 3777 / 129 | INDEXED | — |
| [flag_maker.gd](../../../game/core/flag_maker.gd) | 33144 / 718 | INDEXED | — |
| [hash32.gd](../../../game/core/hash32.gd) | 345 / 19 | INDEXED | — |
| [loc.gd](../../../game/core/loc.gd) | 14470 / 554 | PARTIAL | 1–130 |
| [name_gen.gd](../../../game/core/name_gen.gd) | 20241 / 357 | INDEXED | — |
| [navy_sfx.gd](../../../game/core/navy_sfx.gd) | 8748 / 295 | INDEXED | — |
| [palette.gd](../../../game/core/palette.gd) | 447 / 19 | INDEXED | — |
| [rng.gd](../../../game/core/rng.gd) | 1144 / 60 | FULL | 1–60 |
| [sfx.gd](../../../game/core/sfx.gd) | 36142 / 1182 | INDEXED | — |
| [soundscape.gd](../../../game/core/soundscape.gd) | 9608 / 306 | INDEXED | — |
| [sprite_atlas.gd](../../../game/core/sprite_atlas.gd) | 1891 / 57 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ad_relocate.gd](../../../game/game/ad_relocate.gd) | 12701 / 398 | INDEXED | — |
| [ad_trip.gd](../../../game/game/ad_trip.gd) | 6642 / 225 | INDEXED | — |
| [aftermath.gd](../../../game/game/aftermath.gd) | 20452 / 775 | INDEXED | — |
| [ai.gd](../../../game/game/ai.gd) | 93752 / 2837 | PARTIAL | 366–401, 435–481, 572–637 |
| [ai_persona.gd](../../../game/game/ai_persona.gd) | 2134 / 57 | INDEXED | — |
| [air.gd](../../../game/game/air.gd) | 96325 / 2874 | INDEXED | — |
| [air_duel.gd](../../../game/game/air_duel.gd) | 5747 / 197 | INDEXED | — |
| [air_wreck.gd](../../../game/game/air_wreck.gd) | 8032 / 235 | INDEXED | — |
| [aircraft.gd](../../../game/game/aircraft.gd) | 2158 / 92 | INDEXED | — |
| [alliances.gd](../../../game/game/alliances.gd) | 27308 / 831 | INDEXED | — |
| [ally_care.gd](../../../game/game/ally_care.gd) | 14976 / 422 | INDEXED | — |
| [ally_rift.gd](../../../game/game/ally_rift.gd) | 13525 / 425 | INDEXED | — |
| [arch_style.gd](../../../game/game/arch_style.gd) | 11774 / 379 | INDEXED | — |
| [army.gd](../../../game/game/army.gd) | 88100 / 2695 | INDEXED | — |
| [army_fire.gd](../../../game/game/army_fire.gd) | 24537 / 810 | INDEXED | — |
| [army_groups.gd](../../../game/game/army_groups.gd) | 23281 / 724 | INDEXED | — |
| [army_reinf.gd](../../../game/game/army_reinf.gd) | 9067 / 354 | INDEXED | — |
| [army_tac.gd](../../../game/game/army_tac.gd) | 29262 / 972 | INDEXED | — |
| [auto_cmd.gd](../../../game/game/auto_cmd.gd) | 21548 / 591 | INDEXED | — |
| [battle_watch.gd](../../../game/game/battle_watch.gd) | 15164 / 493 | INDEXED | — |
| [border_fill.gd](../../../game/game/border_fill.gd) | 27972 / 1074 | INDEXED | — |
| [border_gap.gd](../../../game/game/border_gap.gd) | 7563 / 316 | INDEXED | — |
| [border_posts.gd](../../../game/game/border_posts.gd) | 17441 / 584 | INDEXED | — |
| [bridge.gd](../../../game/game/bridge.gd) | 3266 / 150 | INDEXED | — |
| [bridge_guard.gd](../../../game/game/bridge_guard.gd) | 15497 / 552 | INDEXED | — |
| [cad344.gd](../../../game/game/cad344.gd) | 1841 / 125 | FULL | 1–125 |
| [chronicle.gd](../../../game/game/chronicle.gd) | 8321 / 293 | FULL | 1–293 |
| [city.gd](../../../game/game/city.gd) | 1126 / 54 | FULL | 1–54 |
| [colony_look.gd](../../../game/game/colony_look.gd) | 3117 / 95 | INDEXED | — |
| [country.gd](../../../game/game/country.gd) | 3368 / 150 | FULL | 1–150 |
| [defense.gd](../../../game/game/defense.gd) | 33916 / 1008 | INDEXED | — |
| [depot.gd](../../../game/game/depot.gd) | 17422 / 472 | INDEXED | — |
| [dip_react.gd](../../../game/game/dip_react.gd) | 40745 / 1186 | INDEXED | — |
| [dip_requests.gd](../../../game/game/dip_requests.gd) | 61259 / 1699 | INDEXED | — |
| [diplomacy.gd](../../../game/game/diplomacy.gd) | 65624 / 1648 | PARTIAL | 619–690 |

### game/game/diplomacy

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [dip_allies.gd](../../../game/game/diplomacy/dip_allies.gd) | 53445 / 1524 | INDEXED | — |
| [dip_base.gd](../../../game/game/diplomacy/dip_base.gd) | 16373 / 574 | INDEXED | — |
| [dip_rules.gd](../../../game/game/diplomacy/dip_rules.gd) | 55495 / 1494 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [drone.gd](../../../game/game/drone.gd) | 1455 / 63 | INDEXED | — |
| [drone_brain.gd](../../../game/game/drone_brain.gd) | 20087 / 693 | INDEXED | — |
| [econ_guide.gd](../../../game/game/econ_guide.gd) | 75804 / 1792 | INDEXED | — |
| [econ_rates.gd](../../../game/game/econ_rates.gd) | 21310 / 493 | INDEXED | — |
| [economy.gd](../../../game/game/economy.gd) | 18272 / 530 | FULL | 1–530 |

### game/game/economy

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [eco_base.gd](../../../game/game/economy/eco_base.gd) | 16697 / 393 | INDEXED | — |
| [eco_core.gd](../../../game/game/economy/eco_core.gd) | 60360 / 1937 | INDEXED | — |
| [eco_trade.gd](../../../game/game/economy/eco_trade.gd) | 61243 / 1661 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [facility.gd](../../../game/game/facility.gd) | 3663 / 153 | INDEXED | — |
| [front_plan.gd](../../../game/game/front_plan.gd) | 127843 / 3876 | INDEXED | — |
| [game_config.gd](../../../game/game/game_config.gd) | 5936 / 235 | INDEXED | — |
| [game_world.gd](../../../game/game/game_world.gd) | 19874 / 613 | FULL | 1–613 |

### game/game/game_world

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [gw_base.gd](../../../game/game/game_world/gw_base.gd) | 10223 / 376 | FULL | 1–376 |
| [gw_infra.gd](../../../game/game/game_world/gw_infra.gd) | 43100 / 1277 | INDEXED | — |
| [gw_map.gd](../../../game/game/game_world/gw_map.gd) | 27203 / 931 | PARTIAL | 889–931 |
| [gw_states.gd](../../../game/game/game_world/gw_states.gd) | 31939 / 1033 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ideology.gd](../../../game/game/ideology.gd) | 5018 / 198 | FULL | 1–198 |
| [land_trade.gd](../../../game/game/land_trade.gd) | 19020 / 429 | FULL | 1–429 |
| [main.gd](../../../game/game/main.gd) | 78370 / 1913 | PARTIAL | 1–271, 617–642, 1609–1645 |
| [main.tscn.remap](../../../game/game/main.tscn.remap) | 97 / 3 | FULL | 1–3 |

### game/game/main

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [main_base.gd](../../../game/game/main/main_base.gd) | 8044 / 207 | FULL | 1–207 |
| [main_core.gd](../../../game/game/main/main_core.gd) | 40085 / 1028 | PARTIAL | 1–105, 1002–1028 |
| [main_input.gd](../../../game/game/main/main_input.gd) | 38146 / 1082 | PARTIAL | 1–130, 190–250 |
| [main_strike.gd](../../../game/game/main/main_strike.gd) | 26170 / 791 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [match.gd](../../../game/game/match.gd) | 8816 / 325 | INDEXED | — |
| [military.gd](../../../game/game/military.gd) | 37881 / 1140 | PARTIAL | 1–117, 1119–1140 |

### game/game/military

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [mil_base.gd](../../../game/game/military/mil_base.gd) | 22490 / 432 | INDEXED | — |
| [mil_build.gd](../../../game/game/military/mil_build.gd) | 62076 / 1852 | PARTIAL | 278–442 |
| [mil_strike.gd](../../../game/game/military/mil_strike.gd) | 40686 / 1185 | INDEXED | — |

### game/game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [missile.gd](../../../game/game/missile.gd) | 1411 / 73 | INDEXED | — |
| [nature.gd](../../../game/game/nature.gd) | 8526 / 368 | INDEXED | — |
| [naval.gd](../../../game/game/naval.gd) | 58101 / 1759 | INDEXED | — |
| [navy.gd](../../../game/game/navy.gd) | 102946 / 3219 | PARTIAL | 3178–3219 |
| [navy_art.gd](../../../game/game/navy_art.gd) | 25709 / 859 | INDEXED | — |
| [navy_fleets.gd](../../../game/game/navy_fleets.gd) | 29888 / 977 | INDEXED | — |
| [navy_strike.gd](../../../game/game/navy_strike.gd) | 12693 / 393 | INDEXED | — |
| [nuclear.gd](../../../game/game/nuclear.gd) | 29959 / 836 | PARTIAL | 1–65, 258–466 |
| [operations.gd](../../../game/game/operations.gd) | 115408 / 3353 | INDEXED | — |
| [peace_conf.gd](../../../game/game/peace_conf.gd) | 44596 / 1369 | INDEXED | — |
| [port.gd](../../../game/game/port.gd) | 26402 / 857 | INDEXED | — |
| [power_status.gd](../../../game/game/power_status.gd) | 24342 / 744 | INDEXED | — |
| [protect.gd](../../../game/game/protect.gd) | 33521 / 961 | INDEXED | — |
| [rail.gd](../../../game/game/rail.gd) | 74897 / 2382 | INDEXED | — |
| [rail_troops.gd](../../../game/game/rail_troops.gd) | 22832 / 828 | INDEXED | — |
| [ranked_rules.gd](../../../game/game/ranked_rules.gd) | 5422 / 176 | INDEXED | — |
| [recon.gd](../../../game/game/recon.gd) | 26022 / 873 | INDEXED | — |
| [road_detour.gd](../../../game/game/road_detour.gd) | 6640 / 221 | INDEXED | — |
| [save.gd](../../../game/game/save.gd) | 43632 / 1383 | FULL | 1–1383 |
| [save_slots.gd](../../../game/game/save_slots.gd) | 12853 / 466 | FULL | 1–466 |
| [seasons.gd](../../../game/game/seasons.gd) | 4426 / 143 | FULL | 1–143 |
| [ship.gd](../../../game/game/ship.gd) | 2350 / 103 | FULL | 1–103 |
| [sky_cover.gd](../../../game/game/sky_cover.gd) | 31024 / 1000 | INDEXED | — |
| [strike_hub.gd](../../../game/game/strike_hub.gd) | 15070 / 450 | INDEXED | — |
| [strike_sense.gd](../../../game/game/strike_sense.gd) | 6701 / 217 | INDEXED | — |
| [supply.gd](../../../game/game/supply.gd) | 67094 / 2062 | INDEXED | — |
| [trade331.gd](../../../game/game/trade331.gd) | 35947 / 1023 | INDEXED | — |
| [unit.gd](../../../game/game/unit.gd) | 2089 / 89 | INDEXED | — |
| [upkeep335.gd](../../../game/game/upkeep335.gd) | 34179 / 1129 | PARTIAL | 409–445 |
| [urban.gd](../../../game/game/urban.gd) | 12658 / 422 | INDEXED | — |
| [urban_hold.gd](../../../game/game/urban_hold.gd) | 31338 / 1032 | INDEXED | — |
| [vision.gd](../../../game/game/vision.gd) | 18575 / 731 | INDEXED | — |
| [world_drama.gd](../../../game/game/world_drama.gd) | 76983 / 2409 | INDEXED | — |

### game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [icon.svg](../../../game/icon.svg) | 995 / 1 | INDEXED | — |
| [icon.svg.import](../../../game/icon.svg.import) | 193 / 9 | INDEXED | — |
| [icon_ios.png.import](../../../game/icon_ios.png.import) | 197 / 9 | INDEXED | — |

### game/net

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [account.gd](../../../game/net/account.gd) | 16595 / 418 | INDEXED | — |
| [api.gd](../../../game/net/api.gd) | 7397 / 164 | INDEXED | — |
| [device_check.gd](../../../game/net/device_check.gd) | 4428 / 143 | INDEXED | — |
| [dip_chat.gd](../../../game/net/dip_chat.gd) | 9884 / 374 | INDEXED | — |
| [ed25519.gd](../../../game/net/ed25519.gd) | 10847 / 414 | INDEXED | — |
| [lan_discovery.gd](../../../game/net/lan_discovery.gd) | 4102 / 164 | FULL | 1–164 |
| [net.cfg](../../../game/net/net.cfg) | 476 / 8 | INDEXED | — |
| [net_codec.gd](../../../game/net/net_codec.gd) | 2667 / 113 | FULL | 1–113 |
| [net_config.gd](../../../game/net/net_config.gd) | 5602 / 202 | FULL | 1–202 |
| [net_hash.gd](../../../game/net/net_hash.gd) | 10550 / 273 | FULL | 1–273 |
| [net_session.gd](../../../game/net/net_session.gd) | 136607 / 3177 | PARTIAL | 1–403, 484–572, 1017–1230, 1378–1540, 1606–1714, 1751–1848, 1949–2150, 2255–2337, 2737–2822, 3012–3177 |
| [net_tls.gd](../../../game/net/net_tls.gd) | 777 / 32 | INDEXED | — |
| [ranked.gd](../../../game/net/ranked.gd) | 4387 / 118 | INDEXED | — |
| [reports.gd](../../../game/net/reports.gd) | 3020 / 61 | INDEXED | — |
| [room_browser.gd](../../../game/net/room_browser.gd) | 3517 / 158 | INDEXED | — |
| [rtc_link.gd](../../../game/net/rtc_link.gd) | 14308 / 538 | INDEXED | — |

### game/net/tls

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [backend_roots.crt](../../../game/net/tls/backend_roots.crt) | 16548 / 272 | INDEXED | — |

### game/net

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ws_tunnel_peer.gd](../../../game/net/ws_tunnel_peer.gd) | 3335 / 175 | INDEXED | — |

### game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [override.cfg](../../../game/override.cfg) | 248 / 14 | FULL | 1–14 |

### game/pc

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [army_select.gd](../../../game/pc/army_select.gd) | 22769 / 708 | INDEXED | — |
| [boot.tscn](../../../game/pc/boot.tscn) | 157 / 6 | FULL | 1–6 |
| [pc_port.gd](../../../game/pc/pc_port.gd) | 5496 / 179 | FULL | 1–179 |
| [steam_mock.gd](../../../game/pc/steam_mock.gd) | 7152 / 245 | INDEXED | — |
| [steam_net.gd](../../../game/pc/steam_net.gd) | 7442 / 255 | FULL | 1–255 |
| [steam_peer.gd](../../../game/pc/steam_peer.gd) | 10017 / 338 | FULL | 1–338 |
| [updater.gd](../../../game/pc/updater.gd) | 18736 / 469 | FULL | 1–469 |
| [version.cfg](../../../game/pc/version.cfg) | 199 / 7 | FULL | 1–7 |

### game

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [splash.png.import](../../../game/splash.png.import) | 194 / 9 | INDEXED | — |

### game/translations

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [en.po](../../../game/translations/en.po) | 966649 / 34419 | INDEXED | — |
| [es.po](../../../game/translations/es.po) | 514451 / 22570 | INDEXED | — |
| [ru.po](../../../game/translations/ru.po) | 5356 / 170 | INDEXED | — |
| [uk.po](../../../game/translations/uk.po) | 1129981 / 34799 | INDEXED | — |

### game/ui

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [chronicle_viewer.gd](../../../game/ui/chronicle_viewer.gd) | 18332 / 481 | INDEXED | — |
| [cosmetics.gd](../../../game/ui/cosmetics.gd) | 3418 / 106 | INDEXED | — |
| [cosmetics.json](../../../game/ui/cosmetics.json) | 19051 / 1085 | INDEXED | — |
| [custom_bots.gd](../../../game/ui/custom_bots.gd) | 23652 / 631 | INDEXED | — |
| [flag_editor.gd](../../../game/ui/flag_editor.gd) | 40681 / 1241 | INDEXED | — |
| [hud.gd](../../../game/ui/hud.gd) | 30392 / 752 | INDEXED | — |

### game/ui/hud

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [hud_army.gd](../../../game/ui/hud/hud_army.gd) | 8639 / 237 | INDEXED | — |
| [hud_base.gd](../../../game/ui/hud/hud_base.gd) | 23725 / 483 | INDEXED | — |
| [hud_cards.gd](../../../game/ui/hud/hud_cards.gd) | 61720 / 941 | INDEXED | — |
| [hud_dip.gd](../../../game/ui/hud/hud_dip.gd) | 33363 / 744 | INDEXED | — |
| [hud_dock.gd](../../../game/ui/hud/hud_dock.gd) | 8487 / 218 | INDEXED | — |
| [hud_econ.gd](../../../game/ui/hud/hud_econ.gd) | 13415 / 314 | INDEXED | — |
| [hud_keys.gd](../../../game/ui/hud/hud_keys.gd) | 36630 / 906 | INDEXED | — |
| [hud_kit.gd](../../../game/ui/hud/hud_kit.gd) | 16775 / 504 | INDEXED | — |
| [hud_lane.gd](../../../game/ui/hud/hud_lane.gd) | 11694 / 334 | INDEXED | — |
| [hud_ops.gd](../../../game/ui/hud/hud_ops.gd) | 11337 / 301 | INDEXED | — |
| [hud_stack.gd](../../../game/ui/hud/hud_stack.gd) | 39137 / 1034 | INDEXED | — |

### game/ui

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [lang_picker.gd](../../../game/ui/lang_picker.gd) | 16235 / 506 | INDEXED | — |
| [loading.gd](../../../game/ui/loading.gd) | 11348 / 316 | INDEXED | — |
| [map_preview.gd](../../../game/ui/map_preview.gd) | 4359 / 156 | INDEXED | — |
| [menus.gd](../../../game/ui/menus.gd) | 173719 / 4404 | PARTIAL | 1–115, 1678–1725 |
| [mp_kit.gd](../../../game/ui/mp_kit.gd) | 31556 / 905 | INDEXED | — |
| [opening.gd](../../../game/ui/opening.gd) | 6734 / 239 | INDEXED | — |
| [perf_probe.gd](../../../game/ui/perf_probe.gd) | 12431 / 331 | INDEXED | — |
| [report_screen.gd](../../../game/ui/report_screen.gd) | 10112 / 308 | INDEXED | — |
| [route_overlay.gd](../../../game/ui/route_overlay.gd) | 24674 / 663 | INDEXED | — |
| [saves_ui.gd](../../../game/ui/saves_ui.gd) | 33716 / 875 | INDEXED | — |
| [tutorial.gd](../../../game/ui/tutorial.gd) | 24002 / 545 | INDEXED | — |

### game/ui/ui24

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ad_rules_sheet.gd](../../../game/ui/ui24/ad_rules_sheet.gd) | 19807 / 511 | INDEXED | — |
| [ally_sheet.gd](../../../game/ui/ui24/ally_sheet.gd) | 9357 / 252 | INDEXED | — |
| [arm_kit.gd](../../../game/ui/ui24/arm_kit.gd) | 8217 / 195 | INDEXED | — |
| [army_budget.gd](../../../game/ui/ui24/army_budget.gd) | 18596 / 447 | INDEXED | — |
| [army_dock.gd](../../../game/ui/ui24/army_dock.gd) | 81682 / 2377 | INDEXED | — |
| [army_row.gd](../../../game/ui/ui24/army_row.gd) | 10447 / 298 | INDEXED | — |
| [army_sheet.gd](../../../game/ui/ui24/army_sheet.gd) | 157 / 10 | INDEXED | — |
| [army_state.gd](../../../game/ui/ui24/army_state.gd) | 6679 / 190 | INDEXED | — |
| [army_store.gd](../../../game/ui/ui24/army_store.gd) | 5998 / 197 | INDEXED | — |
| [army_ux.gd](../../../game/ui/ui24/army_ux.gd) | 81729 / 2155 | INDEXED | — |
| [bar_track.gd](../../../game/ui/ui24/bar_track.gd) | 1232 / 44 | INDEXED | — |
| [build_panel.gd](../../../game/ui/ui24/build_panel.gd) | 3665 / 102 | INDEXED | — |
| [cmd_sheet.gd](../../../game/ui/ui24/cmd_sheet.gd) | 29315 / 825 | INDEXED | — |
| [conf_declutter.gd](../../../game/ui/ui24/conf_declutter.gd) | 1824 / 77 | INDEXED | — |
| [conference_sheet.gd](../../../game/ui/ui24/conference_sheet.gd) | 48568 / 1470 | INDEXED | — |
| [dip_api.gd](../../../game/ui/ui24/dip_api.gd) | 9933 / 377 | INDEXED | — |
| [dip_chat_view.gd](../../../game/ui/ui24/dip_chat_view.gd) | 11322 / 354 | INDEXED | — |
| [dip_page.gd](../../../game/ui/ui24/dip_page.gd) | 124113 / 3035 | INDEXED | — |
| [dip_sheet.gd](../../../game/ui/ui24/dip_sheet.gd) | 97030 / 2630 | INDEXED | — |
| [econ_hub.gd](../../../game/ui/ui24/econ_hub.gd) | 54126 / 1514 | INDEXED | — |
| [econ_kit.gd](../../../game/ui/ui24/econ_kit.gd) | 3322 / 103 | INDEXED | — |
| [front_overlay.gd](../../../game/ui/ui24/front_overlay.gd) | 35050 / 1029 | INDEXED | — |
| [help_tips.gd](../../../game/ui/ui24/help_tips.gd) | 16832 / 430 | INDEXED | — |
| [hold_card.gd](../../../game/ui/ui24/hold_card.gd) | 7114 / 219 | INDEXED | — |
| [hold_tip.gd](../../../game/ui/ui24/hold_tip.gd) | 20562 / 325 | INDEXED | — |
| [inbox_sheet.gd](../../../game/ui/ui24/inbox_sheet.gd) | 14796 / 434 | INDEXED | — |
| [jet316_marks.gd](../../../game/ui/ui24/jet316_marks.gd) | 2729 / 82 | INDEXED | — |
| [map_declutter.gd](../../../game/ui/ui24/map_declutter.gd) | 2912 / 137 | INDEXED | — |
| [map_pennants.gd](../../../game/ui/ui24/map_pennants.gd) | 31539 / 876 | INDEXED | — |
| [my_state.gd](../../../game/ui/ui24/my_state.gd) | 72340 / 1959 | INDEXED | — |
| [navy_dock.gd](../../../game/ui/ui24/navy_dock.gd) | 79953 / 2172 | INDEXED | — |
| [navy_map.gd](../../../game/ui/ui24/navy_map.gd) | 16504 / 441 | INDEXED | — |
| [navy_yard.gd](../../../game/ui/ui24/navy_yard.gd) | 35212 / 975 | INDEXED | — |
| [notif_calm.gd](../../../game/ui/ui24/notif_calm.gd) | 5438 / 109 | INDEXED | — |
| [notif_lane.gd](../../../game/ui/ui24/notif_lane.gd) | 49385 / 1569 | INDEXED | — |
| [path_kit.gd](../../../game/ui/ui24/path_kit.gd) | 11965 / 372 | INDEXED | — |
| [price_spark.gd](../../../game/ui/ui24/price_spark.gd) | 3086 / 90 | INDEXED | — |
| [rail_back.gd](../../../game/ui/ui24/rail_back.gd) | 2918 / 90 | INDEXED | — |
| [rail_build.gd](../../../game/ui/ui24/rail_build.gd) | 10028 / 289 | INDEXED | — |
| [res_sheet.gd](../../../game/ui/ui24/res_sheet.gd) | 34954 / 904 | INDEXED | — |
| [speed_pick.gd](../../../game/ui/ui24/speed_pick.gd) | 14485 / 408 | INDEXED | — |
| [status_watch.gd](../../../game/ui/ui24/status_watch.gd) | 7447 / 229 | INDEXED | — |
| [strike_marks.gd](../../../game/ui/ui24/strike_marks.gd) | 4802 / 133 | INDEXED | — |
| [strike_sheet.gd](../../../game/ui/ui24/strike_sheet.gd) | 18383 / 514 | INDEXED | — |
| [tap_guard.gd](../../../game/ui/ui24/tap_guard.gd) | 6130 / 254 | INDEXED | — |
| [trade_sheet.gd](../../../game/ui/ui24/trade_sheet.gd) | 67877 / 1771 | INDEXED | — |
| [tutorial_feed.gd](../../../game/ui/ui24/tutorial_feed.gd) | 31059 / 944 | INDEXED | — |
| [width_guard.gd](../../../game/ui/ui24/width_guard.gd) | 4026 / 132 | INDEXED | — |

### game/ui

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ui_kit.gd](../../../game/ui/ui_kit.gd) | 31342 / 806 | INDEXED | — |

### game/world

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [ad_cover_layer.gd](../../../game/world/ad_cover_layer.gd) | 5882 / 207 | INDEXED | — |
| [aftermath_draw.gd](../../../game/world/aftermath_draw.gd) | 25335 / 709 | INDEXED | — |
| [air_duel_layer.gd](../../../game/world/air_duel_layer.gd) | 2433 / 73 | INDEXED | — |
| [air_wreck_draw.gd](../../../game/world/air_wreck_draw.gd) | 14830 / 369 | INDEXED | — |
| [biome.gd](../../../game/world/biome.gd) | 1314 / 62 | INDEXED | — |
| [border_flash.gdshader](../../../game/world/border_flash.gdshader) | 1023 / 36 | INDEXED | — |
| [capture_layer.gd](../../../game/world/capture_layer.gd) | 23923 / 774 | INDEXED | — |
| [city_gen.gd](../../../game/world/city_gen.gd) | 17420 / 482 | INDEXED | — |
| [city_power_layer.gd](../../../game/world/city_power_layer.gd) | 3570 / 139 | INDEXED | — |
| [color_grade.gd](../../../game/world/color_grade.gd) | 880 / 37 | INDEXED | — |
| [conf_map.gdshader](../../../game/world/conf_map.gdshader) | 3734 / 124 | INDEXED | — |
| [conf_map_layer.gd](../../../game/world/conf_map_layer.gd) | 11188 / 379 | INDEXED | — |
| [cover_draw.gd](../../../game/world/cover_draw.gd) | 2782 / 107 | INDEXED | — |
| [decal_layer.gd](../../../game/world/decal_layer.gd) | 8856 / 301 | INDEXED | — |
| [dmg_stages.gd](../../../game/world/dmg_stages.gd) | 4886 / 193 | INDEXED | — |
| [eco_layer.gd](../../../game/world/eco_layer.gd) | 17658 / 479 | INDEXED | — |
| [econ_fx_layer.gd](../../../game/world/econ_fx_layer.gd) | 9961 / 294 | INDEXED | — |
| [fauna_layer.gd](../../../game/world/fauna_layer.gd) | 24925 / 835 | INDEXED | — |
| [flora.gd](../../../game/world/flora.gd) | 4269 / 132 | INDEXED | — |
| [fog_layer.gd](../../../game/world/fog_layer.gd) | 10037 / 297 | INDEXED | — |
| [fort_layer.gd](../../../game/world/fort_layer.gd) | 6679 / 183 | INDEXED | — |
| [fx_layer.gd](../../../game/world/fx_layer.gd) | 11348 / 345 | INDEXED | — |
| [ground_layer.gd](../../../game/world/ground_layer.gd) | 968 / 31 | INDEXED | — |
| [hold_layer.gd](../../../game/world/hold_layer.gd) | 7350 / 238 | INDEXED | — |
| [labels_layer.gd](../../../game/world/labels_layer.gd) | 41686 / 1394 | INDEXED | — |
| [life_layer.gd](../../../game/world/life_layer.gd) | 17104 / 578 | INDEXED | — |
| [map_camera.gd](../../../game/world/map_camera.gd) | 10951 / 409 | PARTIAL | 1–140 |
| [map_icons.gd](../../../game/world/map_icons.gd) | 11227 / 303 | INDEXED | — |
| [map_mode.gdshader](../../../game/world/map_mode.gdshader) | 4623 / 129 | INDEXED | — |
| [map_mode_layer.gd](../../../game/world/map_mode_layer.gd) | 23469 / 732 | INDEXED | — |
| [nature_layer.gd](../../../game/world/nature_layer.gd) | 8459 / 305 | INDEXED | — |
| [naval_layer.gd](../../../game/world/naval_layer.gd) | 8446 / 250 | INDEXED | — |
| [navy_layer.gd](../../../game/world/navy_layer.gd) | 45824 / 1110 | INDEXED | — |
| [night_layer.gd](../../../game/world/night_layer.gd) | 28959 / 881 | INDEXED | — |
| [obj_chunk.gd](../../../game/world/obj_chunk.gd) | 7092 / 311 | INDEXED | — |
| [objects_layer.gd](../../../game/world/objects_layer.gd) | 6189 / 231 | INDEXED | — |
| [ops_layer.gd](../../../game/world/ops_layer.gd) | 21159 / 579 | INDEXED | — |
| [protect_layer.gd](../../../game/world/protect_layer.gd) | 11894 / 384 | INDEXED | — |
| [rail_layer.gd](../../../game/world/rail_layer.gd) | 11464 / 414 | INDEXED | — |
| [rail_view332.gd](../../../game/world/rail_view332.gd) | 14935 / 429 | INDEXED | — |
| [recon_layer.gd](../../../game/world/recon_layer.gd) | 4919 / 129 | INDEXED | — |
| [season_terrain.gdshader](../../../game/world/season_terrain.gdshader) | 3566 / 95 | INDEXED | — |
| [sky_cover.gdshader](../../../game/world/sky_cover.gdshader) | 4897 / 123 | INDEXED | — |
| [sky_cover_layer.gd](../../../game/world/sky_cover_layer.gd) | 10208 / 338 | INDEXED | — |
| [status_mark.gd](../../../game/world/status_mark.gd) | 1771 / 66 | INDEXED | — |
| [strat_layer.gd](../../../game/world/strat_layer.gd) | 9342 / 316 | INDEXED | — |
| [strat_map.gdshader](../../../game/world/strat_map.gdshader) | 6730 / 166 | INDEXED | — |
| [strat_modes.gd](../../../game/world/strat_modes.gd) | 21151 / 618 | INDEXED | — |
| [strat_terrain.gd](../../../game/world/strat_terrain.gd) | 6218 / 229 | INDEXED | — |
| [terrain_view.gd](../../../game/world/terrain_view.gd) | 19768 / 692 | INDEXED | — |
| [territory.gdshader](../../../game/world/territory.gdshader) | 6964 / 173 | INDEXED | — |
| [territory_dist.gdshader](../../../game/world/territory_dist.gdshader) | 2256 / 78 | INDEXED | — |
| [top_layer.gd](../../../game/world/top_layer.gd) | 3882 / 127 | INDEXED | — |
| [trade_layer.gd](../../../game/world/trade_layer.gd) | 10136 / 274 | INDEXED | — |
| [train_layer.gd](../../../game/world/train_layer.gd) | 2954 / 90 | INDEXED | — |
| [units_layer.gd](../../../game/world/units_layer.gd) | 48105 / 1354 | INDEXED | — |
| [vfx.gd](../../../game/world/vfx.gd) | 11808 / 439 | INDEXED | — |
| [vfx_air.gd](../../../game/world/vfx_air.gd) | 29939 / 917 | INDEXED | — |
| [vfx_blast.gd](../../../game/world/vfx_blast.gd) | 28524 / 917 | INDEXED | — |
| [vfx_clouds.gd](../../../game/world/vfx_clouds.gd) | 7114 / 226 | INDEXED | — |
| [vfx_clouds.gdshader](../../../game/world/vfx_clouds.gdshader) | 3556 / 90 | INDEXED | — |
| [vfx_glow.gd](../../../game/world/vfx_glow.gd) | 2467 / 75 | INDEXED | — |
| [vfx_ground.gd](../../../game/world/vfx_ground.gd) | 15458 / 475 | INDEXED | — |
| [vfx_turret.gd](../../../game/world/vfx_turret.gd) | 23218 / 688 | INDEXED | — |
| [war_life.gd](../../../game/world/war_life.gd) | 3122 / 118 | INDEXED | — |
| [weather_fx.gd](../../../game/world/weather_fx.gd) | 3243 / 105 | INDEXED | — |
| [world_data.gd](../../../game/world/world_data.gd) | 1843 / 84 | FULL | 1–84 |
| [world_gen.gd](../../../game/world/world_gen.gd) | 20443 / 584 | PARTIAL | 1–165 |
| [world_gen2.gd](../../../game/world/world_gen2.gd) | 19817 / 617 | INDEXED | — |
| [world_settings.gd](../../../game/world/world_settings.gd) | 643 / 27 | FULL | 1–27 |

### tests

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [benchmark_upkeep_fallback.gd](../../../tests/benchmark_upkeep_fallback.gd) | 2722 / 67 | INDEXED | — |
| [run_updater_cleanup.gd](../../../tests/run_updater_cleanup.gd) | 612 / 12 | FULL | 1–12 |
| [test_ci_policy.py](../../../tests/test_ci_policy.py) | 2849 / 55 | FULL | 1–55 |
| [test_godot.py](../../../tests/test_godot.py) | 3459 / 85 | FULL | 1–85 |
| [test_godot_suite.gd](../../../tests/test_godot_suite.gd) | 50187 / 1122 | INDEXED | — |
| [test_network_admission.gd](../../../tests/test_network_admission.gd) | 2069 / 62 | FULL | 1–62 |
| [test_phase5b2.py](../../../tests/test_phase5b2.py) | 2933 / 57 | FULL | 1–57 |
| [test_phase5b2_gameplay.gd](../../../tests/test_phase5b2_gameplay.gd) | 17711 / 361 | INDEXED | — |
| [test_pr10_critical.gd](../../../tests/test_pr10_critical.gd) | 15074 / 389 | INDEXED | — |
| [test_pr10_critical.py](../../../tests/test_pr10_critical.py) | 2113 / 48 | FULL | 1–48 |
| [test_pr10_save_continue.gd](../../../tests/test_pr10_save_continue.gd) | 8200 / 193 | INDEXED | — |
| [test_release.py](../../../tests/test_release.py) | 9170 / 197 | FULL | 1–197 |
| [test_sim_revision.gd](../../../tests/test_sim_revision.gd) | 2623 / 53 | FULL | 1–53 |
| [test_sim_revision.py](../../../tests/test_sim_revision.py) | 2147 / 41 | FULL | 1–41 |
| [test_snapshot_restore.gd](../../../tests/test_snapshot_restore.gd) | 10452 / 278 | FULL | 1–278 |
| [test_snapshot_restore.py](../../../tests/test_snapshot_restore.py) | 3992 / 70 | FULL | 1–70 |
| [test_snapshot_restore_integration.gd](../../../tests/test_snapshot_restore_integration.gd) | 8129 / 185 | FULL | 1–185 |
| [test_updater_cleanup.gd](../../../tests/test_updater_cleanup.gd) | 7190 / 134 | FULL | 1–134 |
| [test_updater_cleanup.py](../../../tests/test_updater_cleanup.py) | 2342 / 43 | FULL | 1–43 |
| [test_upkeep_fallback.gd](../../../tests/test_upkeep_fallback.gd) | 3389 / 113 | FULL | 1–113 |

### tools

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [build.py](../../../tools/build.py) | 3518 / 80 | FULL | 1–80 |
| [check_performance.py](../../../tools/check_performance.py) | 5399 / 113 | FULL | 1–113 |
| [fetch_godot.py](../../../tools/fetch_godot.py) | 1284 / 24 | FULL | 1–24 |
| [gdc2gd.py](../../../tools/gdc2gd.py) | 6922 / 172 | FULL | 1–172 |

### tools/packproj

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [pack.gd](../../../tools/packproj/pack.gd) | 681 / 26 | FULL | 1–26 |
| [project.godot](../../../tools/packproj/project.godot) | 52 / 3 | FULL | 1–3 |

### tools

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [performance_benchmark.gd](../../../tools/performance_benchmark.gd) | 3856 / 114 | INDEXED | — |
| [performance_regression.gd](../../../tools/performance_regression.gd) | 10669 / 245 | INDEXED | — |

### tools/qa

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [Run-DroneFlames.ps1](../../../tools/qa/Run-DroneFlames.ps1) | 3302 / 75 | FULL | 1–75 |
| [Run-MultiplayerQA.ps1](../../../tools/qa/Run-MultiplayerQA.ps1) | 3825 / 83 | FULL | 1–83 |

### tools

| Файл | Bytes / lines | Статус | Прочитані діапазони |
|---|---:|---|---|
| [release.py](../../../tools/release.py) | 6038 / 139 | FULL | 1–139 |
| [remote_unzip.py](../../../tools/remote_unzip.py) | 2328 / 62 | FULL | 1–62 |

## Усі tracked binary ресурси

Розміри baseline; контрольні суми збережені у ignored source-index, DLL hashes — у Windows plan. Для медіа/імпортованих ресурсів dependencies встановлюються відповідними .import/.remap і code refs, не вигадуються за basename.

| Шлях | Bytes | Тип / межа аналізу |
|---|---:|---|
| [game/.godot/exported/133200997/export-178df499c26bcd3357cc4c21fb1eaa2e-main.scn](../../../game/.godot/exported/133200997/export-178df499c26bcd3357cc4c21fb1eaa2e-main.scn) | 672 | BINARY — RSRC PackedScene; Main/script refs, instantiate NOT RUN |
| [game/.godot/imported/DFSymbols-Bold.ttf-91b47a1d5d67d6b57987018016496dc6.fontdata](../../../game/.godot/imported/DFSymbols-Bold.ttf-91b47a1d5d67d6b57987018016496dc6.fontdata) | 3455 | BINARY — Godot font resource; rendering NOT RUN |
| [game/.godot/imported/PressStart2P-Regular.ttf-e20d5ff307f5ecfa1e9984f5c6184197.fontdata](../../../game/.godot/imported/PressStart2P-Regular.ttf-e20d5ff307f5ecfa1e9984f5c6184197.fontdata) | 56281 | BINARY — Godot font resource; rendering NOT RUN |
| [game/.godot/imported/Rubik-Variable.ttf-0d6caa2cebc29bdfa43eba92e1157738.fontdata](../../../game/.godot/imported/Rubik-Variable.ttf-0d6caa2cebc29bdfa43eba92e1157738.fontdata) | 179617 | BINARY — Godot font resource; rendering NOT RUN |
| [game/.godot/imported/RussoOne-Regular.ttf-6dfa1e4f3354d5ba40d0775191309a1f.fontdata](../../../game/.godot/imported/RussoOne-Regular.ttf-6dfa1e4f3354d5ba40d0775191309a1f.fontdata) | 23695 | BINARY — Godot font resource; rendering NOT RUN |
| [game/.godot/imported/aa_gun.ogg-979ec9bb496ed18ab5ef7f5ebe5c4961.oggvorbisstr](../../../game/.godot/imported/aa_gun.ogg-979ec9bb496ed18ab5ef7f5ebe5c4961.oggvorbisstr) | 15396 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/aid_sent.ogg-d9ba057004adcf43afd86a8e5da36ec0.oggvorbisstr](../../../game/.godot/imported/aid_sent.ogg-d9ba057004adcf43afd86a8e5da36ec0.oggvorbisstr) | 17480 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/air_rumble_loop.ogg-424951264ea12b9db46317a6e14508b5.oggvorbisstr](../../../game/.godot/imported/air_rumble_loop.ogg-424951264ea12b9db46317a6e14508b5.oggvorbisstr) | 53563 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/alarm_general_quarters.ogg-53b2059bee6576e63f5eb19ebbf3718b.oggvorbisstr](../../../game/.godot/imported/alarm_general_quarters.ogg-53b2059bee6576e63f5eb19ebbf3718b.oggvorbisstr) | 29696 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ambient_battle_loop.ogg-7335a36194a955a3b75be872ab496ce2.oggvorbisstr](../../../game/.godot/imported/ambient_battle_loop.ogg-7335a36194a955a3b75be872ab496ce2.oggvorbisstr) | 116252 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ambient_wind_loop.ogg-d6901d9168d3218ffa9033ddcd576db8.oggvorbisstr](../../../game/.godot/imported/ambient_wind_loop.ogg-d6901d9168d3218ffa9033ddcd576db8.oggvorbisstr) | 147512 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/artillery_far.ogg-f008ecb3f228a83ebf174e7dfbcf8e76.oggvorbisstr](../../../game/.godot/imported/artillery_far.ogg-f008ecb3f228a83ebf174e7dfbcf8e76.oggvorbisstr) | 17896 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/artillery_fire.ogg-3677631adfe723b2485907b4110e30c5.oggvorbisstr](../../../game/.godot/imported/artillery_fire.ogg-3677631adfe723b2485907b4110e30c5.oggvorbisstr) | 16448 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/asm_flyby.ogg-e0b9f619732fe836826b844c4c75012a.oggvorbisstr](../../../game/.godot/imported/asm_flyby.ogg-e0b9f619732fe836826b844c4c75012a.oggvorbisstr) | 20992 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/asm_launch.ogg-7c474f46f3f9d139f30b0c952a9cfef5.oggvorbisstr](../../../game/.godot/imported/asm_launch.ogg-7c474f46f3f9d139f30b0c952a9cfef5.oggvorbisstr) | 23404 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/atgm_hit.ogg-29aaf7b284fb5a9495cf316f9832efad.oggvorbisstr](../../../game/.godot/imported/atgm_hit.ogg-29aaf7b284fb5a9495cf316f9832efad.oggvorbisstr) | 15820 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/atgm_launch.ogg-8175950692153ad889cc74f6cccb737c.oggvorbisstr](../../../game/.godot/imported/atgm_launch.ogg-8175950692153ad889cc74f6cccb737c.oggvorbisstr) | 19104 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/atlas_acc1.png-ede1a6e1514174cf3a539e23beac8337.ctex](../../../game/.godot/imported/atlas_acc1.png-ede1a6e1514174cf3a539e23beac8337.ctex) | 854 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_air316.png-9ed98be72566bfeacc129b339146c9bf.ctex](../../../game/.godot/imported/atlas_air316.png-9ed98be72566bfeacc129b339146c9bf.ctex) | 8144 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ally320.png-1302d6f1b182d815603c10e78835140a.ctex](../../../game/.godot/imported/atlas_ally320.png-1302d6f1b182d815603c10e78835140a.ctex) | 782 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_cm28.png-47c7dfa39cb4018e44a323d0064ce223.ctex](../../../game/.godot/imported/atlas_cm28.png-47c7dfa39cb4018e44a323d0064ce223.ctex) | 1128 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_cosm_bn.png-5f154ec8c621b4cfa884e694b3adcc62.ctex](../../../game/.godot/imported/atlas_cosm_bn.png-5f154ec8c621b4cfa884e694b3adcc62.ctex) | 10942 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_cosm_bn_anim.png-aaa87720d4cf11525a45aa49cdd33dc0.ctex](../../../game/.godot/imported/atlas_cosm_bn_anim.png-aaa87720d4cf11525a45aa49cdd33dc0.ctex) | 24112 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_cosm_fr.png-909914ebc0d3e03a417075cf262b74cb.ctex](../../../game/.godot/imported/atlas_cosm_fr.png-909914ebc0d3e03a417075cf262b74cb.ctex) | 5170 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_cosm_tt.png-918ebb0cdb0d9e506f42a9ab0254f7b1.ctex](../../../game/.godot/imported/atlas_cosm_tt.png-918ebb0cdb0d9e506f42a9ab0254f7b1.ctex) | 1514 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_debris314.png-f77a8b1c182f302bfbc4d10d0974db83.ctex](../../../game/.godot/imported/atlas_debris314.png-f77a8b1c182f302bfbc4d10d0974db83.ctex) | 1158 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dip26.png-a50fac87e56b311ff246146fea79998a.ctex](../../../game/.godot/imported/atlas_dip26.png-a50fac87e56b311ff246146fea79998a.ctex) | 2452 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dip331.png-e705254f6db27ef8aad57bb08f67e44d.ctex](../../../game/.godot/imported/atlas_dip331.png-e705254f6db27ef8aad57bb08f67e44d.ctex) | 3590 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dmg314_asia.png-cbef536cc657ebad2babef8eea330771.ctex](../../../game/.godot/imported/atlas_dmg314_asia.png-cbef536cc657ebad2babef8eea330771.ctex) | 39060 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dmg314_clad.png-646bb4b36d84acafa907caf711e8561a.ctex](../../../game/.godot/imported/atlas_dmg314_clad.png-646bb4b36d84acafa907caf711e8561a.ctex) | 105652 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dmg314_east.png-5d04a7084a5c5990c01e3fcb7a285627.ctex](../../../game/.godot/imported/atlas_dmg314_east.png-5d04a7084a5c5990c01e3fcb7a285627.ctex) | 37012 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dmg314_usa.png-1990bd0a32400b4464936aacbe76c8cc.ctex](../../../game/.godot/imported/atlas_dmg314_usa.png-1990bd0a32400b4464936aacbe76c8cc.ctex) | 36742 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_dmg314_west.png-ddeee37a6591ca874179766961f62d8e.ctex](../../../game/.godot/imported/atlas_dmg314_west.png-ddeee37a6591ca874179766961f62d8e.ctex) | 38450 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fauna319.png-6ab845f9f3e93634fc962092c4169ce8.ctex](../../../game/.godot/imported/atlas_fauna319.png-6ab845f9f3e93634fc962092c4169ce8.ctex) | 2464 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_flora.png-44590681b9f06708df2ebb963db27864.ctex](../../../game/.godot/imported/atlas_flora.png-44590681b9f06708df2ebb963db27864.ctex) | 2104 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fui_crane.png-d8a3e033bb0201c45adcac9913776cb3.ctex](../../../game/.godot/imported/atlas_fui_crane.png-d8a3e033bb0201c45adcac9913776cb3.ctex) | 6888 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx.png-819514f57dd8259668e1c932f9b9f402.ctex](../../../game/.godot/imported/atlas_fx.png-819514f57dd8259668e1c932f9b9f402.ctex) | 3270 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx2.png-030e7c49319a8ebfef772854c86894e1.ctex](../../../game/.godot/imported/atlas_fx2.png-030e7c49319a8ebfef772854c86894e1.ctex) | 17338 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx3.png-8209f2dc7c5cd7d77177c23d4d41b9ee.ctex](../../../game/.godot/imported/atlas_fx3.png-8209f2dc7c5cd7d77177c23d4d41b9ee.ctex) | 6412 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx314.png-0850251a5d61a31bc066169340952de6.ctex](../../../game/.godot/imported/atlas_fx314.png-0850251a5d61a31bc066169340952de6.ctex) | 36434 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx4.png-56dcbbb6162c2f4691e330303633d547.ctex](../../../game/.godot/imported/atlas_fx4.png-56dcbbb6162c2f4691e330303633d547.ctex) | 5692 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx5.png-ab80c3c54867cbcdca59a1f459942d70.ctex](../../../game/.godot/imported/atlas_fx5.png-ab80c3c54867cbcdca59a1f459942d70.ctex) | 2064 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx6.png-af9a6d63df27444126b5bed79265fc42.ctex](../../../game/.godot/imported/atlas_fx6.png-af9a6d63df27444126b5bed79265fc42.ctex) | 3068 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx8.png-ea3a88f9e0e4a229c44b0ddf072c5897.ctex](../../../game/.godot/imported/atlas_fx8.png-ea3a88f9e0e4a229c44b0ddf072c5897.ctex) | 2270 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_fx_navy.png-b69661dc71906a4b5e22d5e7481c7ef0.ctex](../../../game/.godot/imported/atlas_fx_navy.png-b69661dc71906a4b5e22d5e7481c7ef0.ctex) | 11322 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_kpp30.png-a93ed7adf22bcc765977a49664884bf6.ctex](../../../game/.godot/imported/atlas_kpp30.png-a93ed7adf22bcc765977a49664884bf6.ctex) | 20470 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_life.png-be1c8179f2407e74a591079374e5691b.ctex](../../../game/.godot/imported/atlas_life.png-be1c8179f2407e74a591079374e5691b.ctex) | 1802 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_mines27.png-3c3f7220e0081082e2bf4bbd6db34525.ctex](../../../game/.godot/imported/atlas_mines27.png-3c3f7220e0081082e2bf4bbd6db34525.ctex) | 5082 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_navy1.png-6942b2ea2bca67263a49c1f9673dd50f.ctex](../../../game/.godot/imported/atlas_navy1.png-6942b2ea2bca67263a49c1f9673dd50f.ctex) | 67422 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_navy30.png-5a6d379c4a2fa44adb2b34636c06839d.ctex](../../../game/.godot/imported/atlas_navy30.png-5a6d379c4a2fa44adb2b34636c06839d.ctex) | 1398 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_net29.png-602e13593f844eefb89fb81a07874089.ctex](../../../game/.godot/imported/atlas_net29.png-602e13593f844eefb89fb81a07874089.ctex) | 1902 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_rail332.png-8133da3a4a152066997669b30f7f2d57.ctex](../../../game/.godot/imported/atlas_rail332.png-8133da3a4a152066997669b30f7f2d57.ctex) | 6904 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_style_asia.png-f071150dda9cb8a67e55eb3ccdd70c16.ctex](../../../game/.godot/imported/atlas_style_asia.png-f071150dda9cb8a67e55eb3ccdd70c16.ctex) | 10884 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_style_clad.png-02d262fb88c03c404f684a2add209125.ctex](../../../game/.godot/imported/atlas_style_clad.png-02d262fb88c03c404f684a2add209125.ctex) | 18266 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_style_usa.png-53ea159b1f195745e32466eaece00aae.ctex](../../../game/.godot/imported/atlas_style_usa.png-53ea159b1f195745e32466eaece00aae.ctex) | 10984 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_style_west.png-0271c47ef0872c4e1df670a7764f0ccd.ctex](../../../game/.godot/imported/atlas_style_west.png-0271c47ef0872c4e1df670a7764f0ccd.ctex) | 11070 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui.png-6dfca041ca9271bd9d995742ef8a3e13.ctex](../../../game/.godot/imported/atlas_ui.png-6dfca041ca9271bd9d995742ef8a3e13.ctex) | 2288 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui10.png-438b2dcdca153becb54d5ed67090043c.ctex](../../../game/.godot/imported/atlas_ui10.png-438b2dcdca153becb54d5ed67090043c.ctex) | 1914 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui11.png-ac8b586f6644547daeaf098fbef049f4.ctex](../../../game/.godot/imported/atlas_ui11.png-ac8b586f6644547daeaf098fbef049f4.ctex) | 1224 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui12.png-c41e95a98ce3701c123404f8143d9afa.ctex](../../../game/.godot/imported/atlas_ui12.png-c41e95a98ce3701c123404f8143d9afa.ctex) | 270 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui13.png-f0c1a88d637fbe501391c31b0a963dfe.ctex](../../../game/.godot/imported/atlas_ui13.png-f0c1a88d637fbe501391c31b0a963dfe.ctex) | 508 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui14.png-42c9942c7f020926c23898d5a765e042.ctex](../../../game/.godot/imported/atlas_ui14.png-42c9942c7f020926c23898d5a765e042.ctex) | 894 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui15.png-de359818c26a3c651dbb34706cf12844.ctex](../../../game/.godot/imported/atlas_ui15.png-de359818c26a3c651dbb34706cf12844.ctex) | 2008 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui16.png-c4541e381ec13232832ff6a0920c595a.ctex](../../../game/.godot/imported/atlas_ui16.png-c4541e381ec13232832ff6a0920c595a.ctex) | 1192 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui17.png-ef7fce5f352ee7fbccc263bc7e25dcf4.ctex](../../../game/.godot/imported/atlas_ui17.png-ef7fce5f352ee7fbccc263bc7e25dcf4.ctex) | 500 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui18.png-8acd448677491a3c7b8599a4bd3e6bf2.ctex](../../../game/.godot/imported/atlas_ui18.png-8acd448677491a3c7b8599a4bd3e6bf2.ctex) | 352 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui19.png-f3a82508edccf8befa4178179e276dbf.ctex](../../../game/.godot/imported/atlas_ui19.png-f3a82508edccf8befa4178179e276dbf.ctex) | 4246 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui2.png-3318ef99b1a78d5e4912043e779d1091.ctex](../../../game/.godot/imported/atlas_ui2.png-3318ef99b1a78d5e4912043e779d1091.ctex) | 1694 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui20.png-0e129bba3f42611415b8ff57b882c402.ctex](../../../game/.godot/imported/atlas_ui20.png-0e129bba3f42611415b8ff57b882c402.ctex) | 4972 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui3.png-0136db1f3d6a82fbdc8ad97d7aa250dc.ctex](../../../game/.godot/imported/atlas_ui3.png-0136db1f3d6a82fbdc8ad97d7aa250dc.ctex) | 1060 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui316.png-80e52c1a7adc3812bacbfdfcc6a97a35.ctex](../../../game/.godot/imported/atlas_ui316.png-80e52c1a7adc3812bacbfdfcc6a97a35.ctex) | 330 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui319.png-e0344b8f726930049abecac7998c2f5a.ctex](../../../game/.godot/imported/atlas_ui319.png-e0344b8f726930049abecac7998c2f5a.ctex) | 1488 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui335.png-59ed26dde6b7a373e9bda86e7a9e61f8.ctex](../../../game/.godot/imported/atlas_ui335.png-59ed26dde6b7a373e9bda86e7a9e61f8.ctex) | 536 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui4.png-bd82b030d49c933fe08f8361440bd304.ctex](../../../game/.godot/imported/atlas_ui4.png-bd82b030d49c933fe08f8361440bd304.ctex) | 1770 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui5.png-10cfa6f1414004b408ef3d508c470055.ctex](../../../game/.godot/imported/atlas_ui5.png-10cfa6f1414004b408ef3d508c470055.ctex) | 1534 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui6.png-ebb15e02d2ec9f496c6d168d83f77945.ctex](../../../game/.godot/imported/atlas_ui6.png-ebb15e02d2ec9f496c6d168d83f77945.ctex) | 1872 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui7.png-8168a5fc546ff29bf309688754a9e1f9.ctex](../../../game/.godot/imported/atlas_ui7.png-8168a5fc546ff29bf309688754a9e1f9.ctex) | 2378 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui8.png-02f75c90c544446b9c1b23b9f4913137.ctex](../../../game/.godot/imported/atlas_ui8.png-02f75c90c544446b9c1b23b9f4913137.ctex) | 814 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_ui9.png-29f955d552b93202a22ca2deb3dd1c37.ctex](../../../game/.godot/imported/atlas_ui9.png-29f955d552b93202a22ca2deb3dd1c37.ctex) | 7008 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_units314.png-b4b70d33422c73a8511839a8ada97dca.ctex](../../../game/.godot/imported/atlas_units314.png-b4b70d33422c73a8511839a8ada97dca.ctex) | 53362 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_uran30.png-ddc5b4b00c12199cc0116efeb462e75d.ctex](../../../game/.godot/imported/atlas_uran30.png-ddc5b4b00c12199cc0116efeb462e75d.ctex) | 10782 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_uran30ui.png-2ed0b9d32612d87a58db8368e78a7e76.ctex](../../../game/.godot/imported/atlas_uran30ui.png-2ed0b9d32612d87a58db8368e78a7e76.ctex) | 548 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_vfx19.png-35840159397420d1919457ae12903f15.ctex](../../../game/.godot/imported/atlas_vfx19.png-35840159397420d1919457ae12903f15.ctex) | 2420 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world.png-8985d8936bd17bce3a76f5ae7d597742.ctex](../../../game/.godot/imported/atlas_world.png-8985d8936bd17bce3a76f5ae7d597742.ctex) | 6562 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world10.png-f39cd13b2414a7b3a56f94fce0507e24.ctex](../../../game/.godot/imported/atlas_world10.png-f39cd13b2414a7b3a56f94fce0507e24.ctex) | 5732 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world11.png-b43c3255ccbdcc6f040c191d3ad2c010.ctex](../../../game/.godot/imported/atlas_world11.png-b43c3255ccbdcc6f040c191d3ad2c010.ctex) | 7932 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world12.png-6699771229e9ae1985fc2f4f65023d57.ctex](../../../game/.godot/imported/atlas_world12.png-6699771229e9ae1985fc2f4f65023d57.ctex) | 1380 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world13.png-fc9826388ee258af378e411e214ad9dd.ctex](../../../game/.godot/imported/atlas_world13.png-fc9826388ee258af378e411e214ad9dd.ctex) | 1528 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world2.png-c57956e995856b9309b6ccf3f0f59c6e.ctex](../../../game/.godot/imported/atlas_world2.png-c57956e995856b9309b6ccf3f0f59c6e.ctex) | 6404 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world3.png-4593f983832e51bda3576cf00fede955.ctex](../../../game/.godot/imported/atlas_world3.png-4593f983832e51bda3576cf00fede955.ctex) | 5346 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world4.png-4b4292fcba303dfbad7f1d41276737b5.ctex](../../../game/.godot/imported/atlas_world4.png-4b4292fcba303dfbad7f1d41276737b5.ctex) | 1400 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world5.png-c20c86f9f6a66e5d789bbde5976c7292.ctex](../../../game/.godot/imported/atlas_world5.png-c20c86f9f6a66e5d789bbde5976c7292.ctex) | 12248 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world6.png-fa97eccff5d849534f1bd0489f0fe192.ctex](../../../game/.godot/imported/atlas_world6.png-fa97eccff5d849534f1bd0489f0fe192.ctex) | 6698 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world7.png-6622e18981486e9da3204372015703bd.ctex](../../../game/.godot/imported/atlas_world7.png-6622e18981486e9da3204372015703bd.ctex) | 5508 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world8.png-d6ecf50c54cccb75174aeeed2e56bbec.ctex](../../../game/.godot/imported/atlas_world8.png-d6ecf50c54cccb75174aeeed2e56bbec.ctex) | 1974 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/atlas_world9.png-23a93f80f98e625fbe54ca84dcd2ad56.ctex](../../../game/.godot/imported/atlas_world9.png-23a93f80f98e625fbe54ca84dcd2ad56.ctex) | 9902 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/attack_jet_loop.ogg-30c46f7db2e9f84681ae06dbf4ddfda1.oggvorbisstr](../../../game/.godot/imported/attack_jet_loop.ogg-30c46f7db2e9f84681ae06dbf4ddfda1.oggvorbisstr) | 52499 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/battle_close_loop.ogg-bd7537cc2d28f3a6a84ae786d873882f.oggvorbisstr](../../../game/.godot/imported/battle_close_loop.ogg-bd7537cc2d28f3a6a84ae786d873882f.oggvorbisstr) | 203124 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/birds_day_loop.ogg-2096460e32809c63edbf5a8b6398c7d1.oggvorbisstr](../../../game/.godot/imported/birds_day_loop.ogg-2096460e32809c63edbf5a8b6398c7d1.oggvorbisstr) | 191380 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/bomber_loop.ogg-dde7ffc5c88527479408d0015203e101.oggvorbisstr](../../../game/.godot/imported/bomber_loop.ogg-dde7ffc5c88527479408d0015203e101.oggvorbisstr) | 40503 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/bomber_pass.ogg-608c1ab740402e170fa00bbb08bd934a.oggvorbisstr](../../../game/.godot/imported/bomber_pass.ogg-608c1ab740402e170fa00bbb08bd934a.oggvorbisstr) | 43639 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/bow_wash_loop.ogg-88b4de4d15f02bc1ebcbf220f4881e94.oggvorbisstr](../../../game/.godot/imported/bow_wash_loop.ogg-88b4de4d15f02bc1ebcbf220f4881e94.oggvorbisstr) | 54040 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/building_collapse.ogg-6374e77fcc6127713610ce06d17adce1.oggvorbisstr](../../../game/.godot/imported/building_collapse.ogg-6374e77fcc6127713610ce06d17adce1.oggvorbisstr) | 34840 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/call_to_arms.ogg-3a1411196c47a845e2f7f9ee5e7fa03f.oggvorbisstr](../../../game/.godot/imported/call_to_arms.ogg-3a1411196c47a845e2f7f9ee5e7fa03f.oggvorbisstr) | 24068 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/cannonade_loop.ogg-110a7c26c76ae9fbd49931d53da3324d.oggvorbisstr](../../../game/.godot/imported/cannonade_loop.ogg-110a7c26c76ae9fbd49931d53da3324d.oggvorbisstr) | 233612 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/chaff_burst.ogg-52cd1a58d519e29df0abedb1297a330d.oggvorbisstr](../../../game/.godot/imported/chaff_burst.ogg-52cd1a58d519e29df0abedb1297a330d.oggvorbisstr) | 10592 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ciws_burst.ogg-fd7ca7f3ab9c6f3ec32e054dee20b790.oggvorbisstr](../../../game/.godot/imported/ciws_burst.ogg-fd7ca7f3ab9c6f3ec32e054dee20b790.oggvorbisstr) | 13256 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/concrete_thud.ogg-2e020a9659a616b329745549811b1ff0.oggvorbisstr](../../../game/.godot/imported/concrete_thud.ogg-2e020a9659a616b329745549811b1ff0.oggvorbisstr) | 16944 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/conference_gong.ogg-95468d0e96ada9496cbb7106bbe7a0d7.oggvorbisstr](../../../game/.godot/imported/conference_gong.ogg-95468d0e96ada9496cbb7106bbe7a0d7.oggvorbisstr) | 32596 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/container_clank.ogg-1bdaba9a2b84478b9f8d3329491210ba.oggvorbisstr](../../../game/.godot/imported/container_clank.ogg-1bdaba9a2b84478b9f8d3329491210ba.oggvorbisstr) | 14624 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/convoy_horn.ogg-e19a913a325621350faa1ebdbe1cf319.oggvorbisstr](../../../game/.godot/imported/convoy_horn.ogg-e19a913a325621350faa1ebdbe1cf319.oggvorbisstr) | 23436 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/crickets_night_loop.ogg-758c3a5322ac46595752b39ced92ba2d.oggvorbisstr](../../../game/.godot/imported/crickets_night_loop.ogg-758c3a5322ac46595752b39ced92ba2d.oggvorbisstr) | 196572 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/cruise_launch_vls.ogg-c463b9127c69ebdd75c40ab40dc9f25f.oggvorbisstr](../../../game/.godot/imported/cruise_launch_vls.ogg-c463b9127c69ebdd75c40ab40dc9f25f.oggvorbisstr) | 25728 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/cruise_missile_loop.ogg-6855a1d8b1d1a22ef863eecb12846734.oggvorbisstr](../../../game/.godot/imported/cruise_missile_loop.ogg-6855a1d8b1d1a22ef863eecb12846734.oggvorbisstr) | 44043 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/cruise_missile_pass.ogg-6851c44bc2fd92b075344abd9042acfa.oggvorbisstr](../../../game/.godot/imported/cruise_missile_pass.ogg-6851c44bc2fd92b075344abd9042acfa.oggvorbisstr) | 24891 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/decoy_flares.ogg-f8a2bded91d9a9db2891c3fbeb3086e9.oggvorbisstr](../../../game/.godot/imported/decoy_flares.ogg-f8a2bded91d9a9db2891c3fbeb3086e9.oggvorbisstr) | 18780 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/det28_navyfx.png-edb9768bcbec9c36d8e51467f140177a.ctex](../../../game/.godot/imported/det28_navyfx.png-edb9768bcbec9c36d8e51467f140177a.ctex) | 2130 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/det30_fx.png-48ca5c21bc8cc1c9b701e130a52f4bcc.ctex](../../../game/.godot/imported/det30_fx.png-48ca5c21bc8cc1c9b701e130a52f4bcc.ctex) | 4090 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/dig_trench.ogg-7e4695f16009d2b4a4227ddb266ead95.oggvorbisstr](../../../game/.godot/imported/dig_trench.ogg-7e4695f16009d2b4a4227ddb266ead95.oggvorbisstr) | 22864 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/dock_crane.ogg-f2b0e01db6272af472e9ac322cfed15c.oggvorbisstr](../../../game/.godot/imported/dock_crane.ogg-f2b0e01db6272af472e9ac322cfed15c.oggvorbisstr) | 25020 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/drone_buzz_loop.ogg-25125dd10bcb335f9aaf784d9aae2379.oggvorbisstr](../../../game/.godot/imported/drone_buzz_loop.ogg-25125dd10bcb335f9aaf784d9aae2379.oggvorbisstr) | 36292 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/drone_launch.ogg-8841ac61f74cce4dc9c2de23b6b0e480.oggvorbisstr](../../../game/.godot/imported/drone_launch.ogg-8841ac61f74cce4dc9c2de23b6b0e480.oggvorbisstr) | 22228 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ew_hum.ogg-29b202c4de2d543c9d1c6369dc8dc25d.oggvorbisstr](../../../game/.godot/imported/ew_hum.ogg-29b202c4de2d543c9d1c6369dc8dc25d.oggvorbisstr) | 36220 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/expl_big_1.ogg-506f5b8797ba49cbed34ece3aa7ce853.oggvorbisstr](../../../game/.godot/imported/expl_big_1.ogg-506f5b8797ba49cbed34ece3aa7ce853.oggvorbisstr) | 20004 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/expl_big_2.ogg-e4df3dc25545fe89661de721f8170cc3.oggvorbisstr](../../../game/.godot/imported/expl_big_2.ogg-e4df3dc25545fe89661de721f8170cc3.oggvorbisstr) | 21852 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/expl_far.ogg-1de376c01090977e81b467c638d4e95a.oggvorbisstr](../../../game/.godot/imported/expl_far.ogg-1de376c01090977e81b467c638d4e95a.oggvorbisstr) | 20768 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/expl_small_1.ogg-181d8e64eeef2ed6018cc8c0ec1a4dfe.oggvorbisstr](../../../game/.godot/imported/expl_small_1.ogg-181d8e64eeef2ed6018cc8c0ec1a4dfe.oggvorbisstr) | 14728 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/expl_small_2.ogg-c584048f718bf20af34decfbc9ff3869.oggvorbisstr](../../../game/.godot/imported/expl_small_2.ogg-c584048f718bf20af34decfbc9ff3869.oggvorbisstr) | 14480 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/far_boom_1.ogg-4e7289cbbd8f6a78edd2cbd747f071bf.oggvorbisstr](../../../game/.godot/imported/far_boom_1.ogg-4e7289cbbd8f6a78edd2cbd747f071bf.oggvorbisstr) | 51612 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/far_boom_2.ogg-958338f2829bb5bd4dc83c354030b450.oggvorbisstr](../../../game/.godot/imported/far_boom_2.ogg-958338f2829bb5bd4dc83c354030b450.oggvorbisstr) | 49012 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/far_boom_3.ogg-3449ea9280586763f56068831edf76e9.oggvorbisstr](../../../game/.godot/imported/far_boom_3.ogg-3449ea9280586763f56068831edf76e9.oggvorbisstr) | 55248 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/fire_loop.ogg-5a28f6709770d664b075b089cf668824.oggvorbisstr](../../../game/.godot/imported/fire_loop.ogg-5a28f6709770d664b075b089cf668824.oggvorbisstr) | 46592 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/fpv_buzz.ogg-296b802a4a89af4dd8b05ea887265330.oggvorbisstr](../../../game/.godot/imported/fpv_buzz.ogg-296b802a4a89af4dd8b05ea887265330.oggvorbisstr) | 19796 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/game.mp3-e615eede3e79fe2ec9ad254dc83d4aff.mp3str](../../../game/.godot/imported/game.mp3-e615eede3e79fe2ec9ad254dc83d4aff.mp3str) | 1840655 | BINARY — Godot imported MP3 stream; audio NOT REVIEWED |
| [game/.godot/imported/grenade.ogg-207b5d1b33d4d23636ddbf1759bdead8.oggvorbisstr](../../../game/.godot/imported/grenade.ogg-207b5d1b33d4d23636ddbf1759bdead8.oggvorbisstr) | 13888 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/heli_loop.ogg-882cba32d028882e752ee2d97aef07da.oggvorbisstr](../../../game/.godot/imported/heli_loop.ogg-882cba32d028882e752ee2d97aef07da.oggvorbisstr) | 52844 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/hyper_launch.ogg-8c16c5abe1aa4dc6782d6823e9f2d1de.oggvorbisstr](../../../game/.godot/imported/hyper_launch.ogg-8c16c5abe1aa4dc6782d6823e9f2d1de.oggvorbisstr) | 26956 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex](../../../game/.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex) | 3426 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/icon_ios.png-b700ae5f5836fae99942ab596dc691de.ctex](../../../game/.godot/imported/icon_ios.png-b700ae5f5836fae99942ab596dc691de.ctex) | 588 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/industry_hum_loop.ogg-acf6814acc0016bf29f989e7cc31f55f.oggvorbisstr](../../../game/.godot/imported/industry_hum_loop.ogg-acf6814acc0016bf29f989e7cc31f55f.oggvorbisstr) | 140616 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/intercept_pop.ogg-bd914e86a61935f83a50b0dffb42891d.oggvorbisstr](../../../game/.godot/imported/intercept_pop.ogg-bd914e86a61935f83a50b0dffb42891d.oggvorbisstr) | 13892 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/jet_flyby.ogg-73854ea0fd6aebf95f18bcd7e0e59a15.oggvorbisstr](../../../game/.godot/imported/jet_flyby.ogg-73854ea0fd6aebf95f18bcd7e0e59a15.oggvorbisstr) | 25884 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/jet_pass.ogg-0fb59c48a0521ef52cf679666425ed61.oggvorbisstr](../../../game/.godot/imported/jet_pass.ogg-0fb59c48a0521ef52cf679666425ed61.oggvorbisstr) | 30551 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/jet_uav_loop.ogg-818a281f9474c16cfb081c88b52eff72.oggvorbisstr](../../../game/.godot/imported/jet_uav_loop.ogg-818a281f9474c16cfb081c88b52eff72.oggvorbisstr) | 46447 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/jet_uav_pass.ogg-339a6587725c7c78e8d9aa44c8229726.oggvorbisstr](../../../game/.godot/imported/jet_uav_pass.ogg-339a6587725c7c78e8d9aa44c8229726.oggvorbisstr) | 29147 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/kab_fall.ogg-0fc0b08b735271128350a95180358f0c.oggvorbisstr](../../../game/.godot/imported/kab_fall.ogg-0fc0b08b735271128350a95180358f0c.oggvorbisstr) | 36251 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/lang_bg340.png-5032b2af7ba8e503f37680e1ef9ff915.ctex](../../../game/.godot/imported/lang_bg340.png-5032b2af7ba8e503f37680e1ef9ff915.ctex) | 11616 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/main.png-244485f4a09cc87d5a1da387c430dbd5.ctex](../../../game/.godot/imported/main.png-244485f4a09cc87d5a1da387c430dbd5.ctex) | 376 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/menu.mp3-82b3ae3235abf149375461aff2aa964b.mp3str](../../../game/.godot/imported/menu.mp3-82b3ae3235abf149375461aff2aa964b.mp3str) | 1441087 | BINARY — Godot imported MP3 stream; audio NOT REVIEWED |
| [game/.godot/imported/mg_burst.ogg-8a742f8b18d4c508d521ee99b9b7187b.oggvorbisstr](../../../game/.godot/imported/mg_burst.ogg-8a742f8b18d4c508d521ee99b9b7187b.oggvorbisstr) | 15348 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/missile_cruise_launch.ogg-5afd008269d1b10b7b27d7a69c0cf2a0.oggvorbisstr](../../../game/.godot/imported/missile_cruise_launch.ogg-5afd008269d1b10b7b27d7a69c0cf2a0.oggvorbisstr) | 24600 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/missile_launch.ogg-e7407a95b949cf1a6d73f5ff083c0196.oggvorbisstr](../../../game/.godot/imported/missile_launch.ogg-e7407a95b949cf1a6d73f5ff083c0196.oggvorbisstr) | 29044 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/missile_whistle.ogg-47659192617c64fc3496f485f5347c42.oggvorbisstr](../../../game/.godot/imported/missile_whistle.ogg-47659192617c64fc3496f485f5347c42.oggvorbisstr) | 22048 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/mlrs_salvo.ogg-f86c185e40a2afe77346634c269d0e20.oggvorbisstr](../../../game/.godot/imported/mlrs_salvo.ogg-f86c185e40a2afe77346634c269d0e20.oggvorbisstr) | 36540 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/mortar_fire.ogg-6600f5da6376304e7d60b9d7442e7d6b.oggvorbisstr](../../../game/.godot/imported/mortar_fire.ogg-6600f5da6376304e7d60b9d7442e7d6b.oggvorbisstr) | 13232 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/naval_gun.ogg-b800734c48add1b21b5ca49de6cf8dc2.oggvorbisstr](../../../game/.godot/imported/naval_gun.ogg-b800734c48add1b21b5ca49de6cf8dc2.oggvorbisstr) | 11596 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/navbase_ambient_loop.ogg-67829f4fd160a1d14b9dc284f73073d0.oggvorbisstr](../../../game/.godot/imported/navbase_ambient_loop.ogg-67829f4fd160a1d14b9dc284f73073d0.oggvorbisstr) | 91316 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/net_catch.ogg-9f7625a989fefe4537c17ab7a3ceeca5.oggvorbisstr](../../../game/.godot/imported/net_catch.ogg-9f7625a989fefe4537c17ab7a3ceeca5.oggvorbisstr) | 16580 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/opening.ogg-0d4f30de440568441166d6f5079d4cb3.oggvorbisstr](../../../game/.godot/imported/opening.ogg-0d4f30de440568441166d6f5079d4cb3.oggvorbisstr) | 694348 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/protest_note.ogg-2e1cc101e76b4225ac215158f3122d3e.oggvorbisstr](../../../game/.godot/imported/protest_note.ogg-2e1cc101e76b4225ac215158f3122d3e.oggvorbisstr) | 6560 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/pumpjack_loop.ogg-e59f016eae33fc4ab2ec48926c416bee.oggvorbisstr](../../../game/.godot/imported/pumpjack_loop.ogg-e59f016eae33fc4ab2ec48926c416bee.oggvorbisstr) | 33468 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/radar_ping.ogg-69f2991b2de22007e3360c6c3468062e.oggvorbisstr](../../../game/.godot/imported/radar_ping.ogg-69f2991b2de22007e3360c6c3468062e.oggvorbisstr) | 12284 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/recon_drone_buzz.ogg-445653856940a0c8a86dd009f4a3a359.oggvorbisstr](../../../game/.godot/imported/recon_drone_buzz.ogg-445653856940a0c8a86dd009f4a3a359.oggvorbisstr) | 38164 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/repair_work.ogg-592c8e8cce74738408da52eb33d0db3c.oggvorbisstr](../../../game/.godot/imported/repair_work.ogg-592c8e8cce74738408da52eb33d0db3c.oggvorbisstr) | 26612 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/rifle_burst_1.ogg-a68c7b3ec61e0d54021bbee33ee46bae.oggvorbisstr](../../../game/.godot/imported/rifle_burst_1.ogg-a68c7b3ec61e0d54021bbee33ee46bae.oggvorbisstr) | 11084 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/rifle_burst_2.ogg-554731b34a244f8d050506c3f5cdc20b.oggvorbisstr](../../../game/.godot/imported/rifle_burst_2.ogg-554731b34a244f8d050506c3f5cdc20b.oggvorbisstr) | 11488 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/river_loop.ogg-0dcaca4a1297d2aa0f2b7f538f100d18.oggvorbisstr](../../../game/.godot/imported/river_loop.ogg-0dcaca4a1297d2aa0f2b7f538f100d18.oggvorbisstr) | 151364 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/rpg_fire.ogg-f50809fe045ca343ac241f539d24415f.oggvorbisstr](../../../game/.godot/imported/rpg_fire.ogg-f50809fe045ca343ac241f539d24415f.oggvorbisstr) | 16252 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/sam_launch.ogg-66989b10dff5b1503e73ae59e8429558.oggvorbisstr](../../../game/.godot/imported/sam_launch.ogg-66989b10dff5b1503e73ae59e8429558.oggvorbisstr) | 20056 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/sawmill_saw.ogg-5c418b06ad47521e606dbf66b2cffdf5.oggvorbisstr](../../../game/.godot/imported/sawmill_saw.ogg-5c418b06ad47521e606dbf66b2cffdf5.oggvorbisstr) | 18064 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/sea_explosion.ogg-98998c4fe92cdaecac249331f02be94a.oggvorbisstr](../../../game/.godot/imported/sea_explosion.ogg-98998c4fe92cdaecac249331f02be94a.oggvorbisstr) | 20128 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/shell_whistle_in.ogg-e392d75b3e59c4896349baded7190be8.oggvorbisstr](../../../game/.godot/imported/shell_whistle_in.ogg-e392d75b3e59c4896349baded7190be8.oggvorbisstr) | 13032 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_engine_loop.ogg-f10b096e32c6e358229b1a547bff7c70.oggvorbisstr](../../../game/.godot/imported/ship_engine_loop.ogg-f10b096e32c6e358229b1a547bff7c70.oggvorbisstr) | 45784 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_fire_loop.ogg-e52506af5bb2262cab5419e91e14563f.oggvorbisstr](../../../game/.godot/imported/ship_fire_loop.ogg-e52506af5bb2262cab5419e91e14563f.oggvorbisstr) | 54640 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_hit.ogg-e683327208a699bae24e2823a4e6ef76.oggvorbisstr](../../../game/.godot/imported/ship_hit.ogg-e683327208a699bae24e2823a4e6ef76.oggvorbisstr) | 21944 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_horn.ogg-11643bd30d78b765f0f0011e31db97fd.oggvorbisstr](../../../game/.godot/imported/ship_horn.ogg-11643bd30d78b765f0f0011e31db97fd.oggvorbisstr) | 19240 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_sam_launch.ogg-38833717ef7da8bc06593c730a9a0e54.oggvorbisstr](../../../game/.godot/imported/ship_sam_launch.ogg-38833717ef7da8bc06593c730a9a0e54.oggvorbisstr) | 20064 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ship_sinking.ogg-0bd139b2c30d929d68059d17c9fdc387.oggvorbisstr](../../../game/.godot/imported/ship_sinking.ogg-0bd139b2c30d929d68059d17c9fdc387.oggvorbisstr) | 31268 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/siren_loop.ogg-2da5333374c632b98410140fa6d6a190.oggvorbisstr](../../../game/.godot/imported/siren_loop.ogg-2da5333374c632b98410140fa6d6a190.oggvorbisstr) | 65208 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/splash.png-929ed8a00b89ba36c51789452f874c77.ctex](../../../game/.godot/imported/splash.png-929ed8a00b89ba36c51789452f874c77.ctex) | 4262 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/splash_big.ogg-cfbb65c0955c7c48616400c6c4b619b1.oggvorbisstr](../../../game/.godot/imported/splash_big.ogg-cfbb65c0955c7c48616400c6c4b619b1.oggvorbisstr) | 16976 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/style_cards29.png-3cfc1451ff607d36dca9a120ab007a3f.ctex](../../../game/.godot/imported/style_cards29.png-3cfc1451ff607d36dca9a120ab007a3f.ctex) | 3210 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/style_cards31.png-33610680990bbf5d3eea35e7c656867b.ctex](../../../game/.godot/imported/style_cards31.png-33610680990bbf5d3eea35e7c656867b.ctex) | 3438 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/surf_loop.ogg-29691a3c557121bb4704b4d1d3f0ce73.oggvorbisstr](../../../game/.godot/imported/surf_loop.ogg-29691a3c557121bb4704b4d1d3f0ce73.oggvorbisstr) | 180476 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/tank_cannon.ogg-7a56c999cad8e59cf9594934739b6ea3.oggvorbisstr](../../../game/.godot/imported/tank_cannon.ogg-7a56c999cad8e59cf9594934739b6ea3.oggvorbisstr) | 15412 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/territory_claim.ogg-b7b1326e9c1044414d8f6910bb3b9807.oggvorbisstr](../../../game/.godot/imported/territory_claim.ogg-b7b1326e9c1044414d8f6910bb3b9807.oggvorbisstr) | 7148 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/town_hum_loop.ogg-27676b20ca29da8f023b17191adcb069.oggvorbisstr](../../../game/.godot/imported/town_hum_loop.ogg-27676b20ca29da8f023b17191adcb069.oggvorbisstr) | 182116 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/train_horn.ogg-371bc297f529bae2c89ed6ec661859a7.oggvorbisstr](../../../game/.godot/imported/train_horn.ogg-371bc297f529bae2c89ed6ec661859a7.oggvorbisstr) | 17664 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/train_roll_loop.ogg-56dc0cb6006f70c86b3b380804037dfe.oggvorbisstr](../../../game/.godot/imported/train_roll_loop.ogg-56dc0cb6006f70c86b3b380804037dfe.oggvorbisstr) | 35864 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/treaty_signed.ogg-387bee68e6e3bab461044519617e622f.oggvorbisstr](../../../game/.godot/imported/treaty_signed.ogg-387bee68e6e3bab461044519617e622f.oggvorbisstr) | 10684 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/truck_pass.ogg-479475eb81cefe6f12ce36fbe9c9fe1c.oggvorbisstr](../../../game/.godot/imported/truck_pass.ogg-479475eb81cefe6f12ce36fbe9c9fe1c.oggvorbisstr) | 31672 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_alert.ogg-988fe82ff9e82dcb87c0db3d68263f59.oggvorbisstr](../../../game/.godot/imported/ui_alert.ogg-988fe82ff9e82dcb87c0db3d68263f59.oggvorbisstr) | 11724 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_build.ogg-ee2bcec096456cf0b3e9366c5ea0263f.oggvorbisstr](../../../game/.godot/imported/ui_build.ogg-ee2bcec096456cf0b3e9366c5ea0263f.oggvorbisstr) | 14956 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_cancel.ogg-0af9dcc49b9476885fe30cf5ed96f6c9.oggvorbisstr](../../../game/.godot/imported/ui_cancel.ogg-0af9dcc49b9476885fe30cf5ed96f6c9.oggvorbisstr) | 7732 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_capture.ogg-d14c9b752706d96e874fec7fdeec1d12.oggvorbisstr](../../../game/.godot/imported/ui_capture.ogg-d14c9b752706d96e874fec7fdeec1d12.oggvorbisstr) | 26188 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_city_lost.ogg-f5dfd9b5068cd7372e2d08211db82ab6.oggvorbisstr](../../../game/.godot/imported/ui_city_lost.ogg-f5dfd9b5068cd7372e2d08211db82ab6.oggvorbisstr) | 29680 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_click.ogg-a0115987ce9b356fbf9f508472b8fe54.oggvorbisstr](../../../game/.godot/imported/ui_click.ogg-a0115987ce9b356fbf9f508472b8fe54.oggvorbisstr) | 8152 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_close.ogg-e0e0d6f14b0bc5421f789fe116759ffe.oggvorbisstr](../../../game/.godot/imported/ui_close.ogg-e0e0d6f14b0bc5421f789fe116759ffe.oggvorbisstr) | 7956 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_defeat.ogg-56fb8cb220b77730a06ed5b3cf1ae717.oggvorbisstr](../../../game/.godot/imported/ui_defeat.ogg-56fb8cb220b77730a06ed5b3cf1ae717.oggvorbisstr) | 44448 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_error.ogg-daea22c0b55cf2f8b80c96b97cf1c4fa.oggvorbisstr](../../../game/.godot/imported/ui_error.ogg-daea22c0b55cf2f8b80c96b97cf1c4fa.oggvorbisstr) | 8276 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_money.ogg-74fde25d72381782c2ea7251623b2de2.oggvorbisstr](../../../game/.godot/imported/ui_money.ogg-74fde25d72381782c2ea7251623b2de2.oggvorbisstr) | 13500 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_open.ogg-47d1a9beff873fb2fb97d6208b7dc831.oggvorbisstr](../../../game/.godot/imported/ui_open.ogg-47d1a9beff873fb2fb97d6208b7dc831.oggvorbisstr) | 9616 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_select.ogg-4a72474f3198c2c271fd2fb015a5c59e.oggvorbisstr](../../../game/.godot/imported/ui_select.ogg-4a72474f3198c2c271fd2fb015a5c59e.oggvorbisstr) | 8140 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_tab.ogg-d0ca93f47c85caf91d669fe07bea419e.oggvorbisstr](../../../game/.godot/imported/ui_tab.ogg-d0ca93f47c85caf91d669fe07bea419e.oggvorbisstr) | 9036 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_victory.ogg-57f1f32a21b706eed9dffd4d45c8ab53.oggvorbisstr](../../../game/.godot/imported/ui_victory.ogg-57f1f32a21b706eed9dffd4d45c8ab53.oggvorbisstr) | 47256 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/ui_war.ogg-282400b05b50d910ad95dede15f0b42a.oggvorbisstr](../../../game/.godot/imported/ui_war.ogg-282400b05b50d910ad95dede15f0b42a.oggvorbisstr) | 29024 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/vassal_sworn.ogg-257648476fa09c53de622f6b08345a26.oggvorbisstr](../../../game/.godot/imported/vassal_sworn.ogg-257648476fa09c53de622f6b08345a26.oggvorbisstr) | 21824 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/vfx19_clouds.png-35c8dee564abb601cac1f026b17da43c.ctex](../../../game/.godot/imported/vfx19_clouds.png-35c8dee564abb601cac1f026b17da43c.ctex) | 11032 | BINARY — Godot imported texture; pixels NOT REVIEWED |
| [game/.godot/imported/vls_hatch_open.ogg-ed2bed6703f008978ff10d42f57e5d64.oggvorbisstr](../../../game/.godot/imported/vls_hatch_open.ogg-ed2bed6703f008978ff10d42f57e5d64.oggvorbisstr) | 12972 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/imported/warship_horn.ogg-17e6f5c28b23faffb1859445edff0dad.oggvorbisstr](../../../game/.godot/imported/warship_horn.ogg-17e6f5c28b23faffb1859445edff0dad.oggvorbisstr) | 21860 | BINARY — Godot imported Vorbis stream; audio NOT REVIEWED |
| [game/.godot/uid_cache.bin](../../../game/.godot/uid_cache.bin) | 23697 | BINARY — binary metadata; semantics UNVERIFIED |
| [game/assets/sprites/atlas_carrier3.png](../../../game/assets/sprites/atlas_carrier3.png) | 72268 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_carrier3ui.png](../../../game/assets/sprites/atlas_carrier3ui.png) | 1442 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_nuke2.png](../../../game/assets/sprites/atlas_nuke2.png) | 17828 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_nuke2ui.png](../../../game/assets/sprites/atlas_nuke2ui.png) | 1222 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_step4.png](../../../game/assets/sprites/atlas_step4.png) | 1149 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_step4ui.png](../../../game/assets/sprites/atlas_step4ui.png) | 3970 | BINARY — PNG image; metadata only |
| [game/assets/sprites/atlas_step5ui.png](../../../game/assets/sprites/atlas_step5ui.png) | 1227 | BINARY — PNG image; metadata only |
| [game/assets/video/opening.ogv](../../../game/assets/video/opening.ogv) | 7584379 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/01_econ_basics.ogv](../../../game/assets/video/tutorial/01_econ_basics.ogv) | 1387668 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/02_econ_cities.ogv](../../../game/assets/video/tutorial/02_econ_cities.ogv) | 1265494 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/03_econ_ores.ogv](../../../game/assets/video/tutorial/03_econ_ores.ogv) | 1320776 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/04_econ_chains.ogv](../../../game/assets/video/tutorial/04_econ_chains.ogv) | 1007735 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/05_trade_port.ogv](../../../game/assets/video/tutorial/05_trade_port.ogv) | 1149591 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/06_rail_build.ogv](../../../game/assets/video/tutorial/06_rail_build.ogv) | 1062379 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/07_supply.ogv](../../../game/assets/video/tutorial/07_supply.ogv) | 716272 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/08_army_barracks.ogv](../../../game/assets/video/tutorial/08_army_barracks.ogv) | 864548 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/09_army_orders.ogv](../../../game/assets/video/tutorial/09_army_orders.ogv) | 1351713 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/10_army_rail.ogv](../../../game/assets/video/tutorial/10_army_rail.ogv) | 1471643 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/11_army_groups.ogv](../../../game/assets/video/tutorial/11_army_groups.ogv) | 1416048 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/12_army_upkeep.ogv](../../../game/assets/video/tutorial/12_army_upkeep.ogv) | 971867 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/13_ad_who.ogv](../../../game/assets/video/tutorial/13_ad_who.ogv) | 1946173 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/14_ad_radar_rules.ogv](../../../game/assets/video/tutorial/14_ad_radar_rules.ogv) | 1438541 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/15_strike_drones.ogv](../../../game/assets/video/tutorial/15_strike_drones.ogv) | 1404247 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/16_strike_missiles.ogv](../../../game/assets/video/tutorial/16_strike_missiles.ogv) | 1083595 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/17_strike_air.ogv](../../../game/assets/video/tutorial/17_strike_air.ogv) | 1009801 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/18_navy_basics.ogv](../../../game/assets/video/tutorial/18_navy_basics.ogv) | 1254081 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/19_dip_treaties.ogv](../../../game/assets/video/tutorial/19_dip_treaties.ogv) | 1121038 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/20_dip_requests.ogv](../../../game/assets/video/tutorial/20_dip_requests.ogv) | 1172802 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/21_dip_war_peace.ogv](../../../game/assets/video/tutorial/21_dip_war_peace.ogv) | 1117286 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/22_game_saves.ogv](../../../game/assets/video/tutorial/22_game_saves.ogv) | 969320 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/01_econ_basics.ogv](../../../game/assets/video/tutorial/en/01_econ_basics.ogv) | 1363644 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/02_econ_cities.ogv](../../../game/assets/video/tutorial/en/02_econ_cities.ogv) | 1272715 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/03_econ_ores.ogv](../../../game/assets/video/tutorial/en/03_econ_ores.ogv) | 1271079 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/04_econ_chains.ogv](../../../game/assets/video/tutorial/en/04_econ_chains.ogv) | 965554 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/05_trade_port.ogv](../../../game/assets/video/tutorial/en/05_trade_port.ogv) | 1089466 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/06_rail_build.ogv](../../../game/assets/video/tutorial/en/06_rail_build.ogv) | 1037213 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/07_supply.ogv](../../../game/assets/video/tutorial/en/07_supply.ogv) | 687677 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/08_army_barracks.ogv](../../../game/assets/video/tutorial/en/08_army_barracks.ogv) | 847958 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/09_army_orders.ogv](../../../game/assets/video/tutorial/en/09_army_orders.ogv) | 1249711 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/10_army_rail.ogv](../../../game/assets/video/tutorial/en/10_army_rail.ogv) | 1470578 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/11_army_groups.ogv](../../../game/assets/video/tutorial/en/11_army_groups.ogv) | 1397169 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/12_army_upkeep.ogv](../../../game/assets/video/tutorial/en/12_army_upkeep.ogv) | 971546 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/13_ad_who.ogv](../../../game/assets/video/tutorial/en/13_ad_who.ogv) | 1924043 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/14_ad_radar_rules.ogv](../../../game/assets/video/tutorial/en/14_ad_radar_rules.ogv) | 1445255 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/15_strike_drones.ogv](../../../game/assets/video/tutorial/en/15_strike_drones.ogv) | 1365533 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/16_strike_missiles.ogv](../../../game/assets/video/tutorial/en/16_strike_missiles.ogv) | 1090377 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/17_strike_air.ogv](../../../game/assets/video/tutorial/en/17_strike_air.ogv) | 1034120 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/18_navy_basics.ogv](../../../game/assets/video/tutorial/en/18_navy_basics.ogv) | 1236639 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/19_dip_treaties.ogv](../../../game/assets/video/tutorial/en/19_dip_treaties.ogv) | 1122535 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/20_dip_requests.ogv](../../../game/assets/video/tutorial/en/20_dip_requests.ogv) | 1099395 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/21_dip_war_peace.ogv](../../../game/assets/video/tutorial/en/21_dip_war_peace.ogv) | 1066486 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/en/22_game_saves.ogv](../../../game/assets/video/tutorial/en/22_game_saves.ogv) | 843989 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/01_econ_basics.ogv](../../../game/assets/video/tutorial/uk/01_econ_basics.ogv) | 1402194 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/02_econ_cities.ogv](../../../game/assets/video/tutorial/uk/02_econ_cities.ogv) | 1274009 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/03_econ_ores.ogv](../../../game/assets/video/tutorial/uk/03_econ_ores.ogv) | 1333742 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/04_econ_chains.ogv](../../../game/assets/video/tutorial/uk/04_econ_chains.ogv) | 1009069 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/05_trade_port.ogv](../../../game/assets/video/tutorial/uk/05_trade_port.ogv) | 1141015 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/06_rail_build.ogv](../../../game/assets/video/tutorial/uk/06_rail_build.ogv) | 1065136 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/07_supply.ogv](../../../game/assets/video/tutorial/uk/07_supply.ogv) | 734672 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/08_army_barracks.ogv](../../../game/assets/video/tutorial/uk/08_army_barracks.ogv) | 848273 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/09_army_orders.ogv](../../../game/assets/video/tutorial/uk/09_army_orders.ogv) | 1318954 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/10_army_rail.ogv](../../../game/assets/video/tutorial/uk/10_army_rail.ogv) | 1464318 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/11_army_groups.ogv](../../../game/assets/video/tutorial/uk/11_army_groups.ogv) | 1386963 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/12_army_upkeep.ogv](../../../game/assets/video/tutorial/uk/12_army_upkeep.ogv) | 979811 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/13_ad_who.ogv](../../../game/assets/video/tutorial/uk/13_ad_who.ogv) | 1904090 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/14_ad_radar_rules.ogv](../../../game/assets/video/tutorial/uk/14_ad_radar_rules.ogv) | 1430461 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/15_strike_drones.ogv](../../../game/assets/video/tutorial/uk/15_strike_drones.ogv) | 1398734 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/16_strike_missiles.ogv](../../../game/assets/video/tutorial/uk/16_strike_missiles.ogv) | 1063254 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/17_strike_air.ogv](../../../game/assets/video/tutorial/uk/17_strike_air.ogv) | 1007271 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/18_navy_basics.ogv](../../../game/assets/video/tutorial/uk/18_navy_basics.ogv) | 1224345 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/19_dip_treaties.ogv](../../../game/assets/video/tutorial/uk/19_dip_treaties.ogv) | 1123190 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/20_dip_requests.ogv](../../../game/assets/video/tutorial/uk/20_dip_requests.ogv) | 1156195 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/21_dip_war_peace.ogv](../../../game/assets/video/tutorial/uk/21_dip_war_peace.ogv) | 1090826 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/assets/video/tutorial/uk/22_game_saves.ogv](../../../game/assets/video/tutorial/uk/22_game_saves.ogv) | 978379 | BINARY — Ogg video container; clip UX NOT RUN |
| [game/project.binary](../../../game/project.binary) | 1632 | BINARY — ECFG;26 config entries metadata |
| [game/splash.png](../../../game/splash.png) | 20678 | BINARY — PNG image; metadata only |
| [libs/libgodotsteam.windows.template_release.x86_64.dll](../../../libs/libgodotsteam.windows.template_release.x86_64.dll) | 3980800 | BINARY — PE AMD64; build sidecar, actual load NOT RUN |
| [libs/libwebrtc_native.windows.template_release.x86_64.dll](../../../libs/libwebrtc_native.windows.template_release.x86_64.dll) | 4058112 | BINARY — PE AMD64; build sidecar, actual load NOT RUN |
| [libs/steam_api64.dll](../../../libs/steam_api64.dll) | 319128 | BINARY — PE AMD64; build sidecar, actual load NOT RUN |
