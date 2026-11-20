# Phase 5B.2 — фактичні regression results

2026-11-20. **READY FOR NEXT STAGE** у локальному scope FIX05–08. Не READY FOR BETA: compatibility revision gate, Windows GUI/full multiplayer та інші HIGH risks відкриті. No commit/push/merge/PR/release/CI dispatch.

Артефакти/точні argv/cwd/exit/elapsed/stdout/stderr: [final_results.json](/home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631/final_results.json), `/home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631/logs/`, `*_result.json`. Current source candidate: **candidate_review.pck**, SHA256 `b113844ea3f41635e0fa2fc6df6ffd8c39d2f257ebb86f43cc061ac7047e5bbc`. Immutable candidate.pck — раніший пакет для FIX08 benchmark, до додаткової command validation, не фінальний review package. Source manifest: pack_manifest_review.json. Godot4.7.2.stable.official.ed1daf0bf, copied synthetic legacy checkpoint, ізольовані XDG/APPDATA/TMPDIR, updater off/Steam init bypassed; реальні saves/accounts не використовувалися. Усі нові артефакти всередині цього worktree.

## RED / GREEN

| Finding / fixture | До відповідного fix | Після, exact current candidate |
|---|---|---|
| FIX05 actual Button→handler | fix05_red:4checks/2fail, SP/MP не входять у airport mode | final_fix05:21checks/0fail (включно validation) |
| FIX05 malformed/free commands | fix05_red_extended:21/4fail на уже виправленому button, до validation | final_fix05:21/0fail; free=true не будує, invalid types/kind/arity без script errors |
| FIX06 persistence | fix06_red_disk_fixture:23/10fail | фінальний legacy suite41/0fail |
| FIX06 expanded persistence/hash/schema/replay | fix06_red_extended:41/21fail на fix05.pck | final_fix06:41/0fail |
| FIX07 REBASE Esc/RMB | fix07R_red_verified:27/4fail | final_fix07R:33/0fail (додатково schema) |
| FIX07 AIRDROP Esc/RMB | fix07A_red_verified:27/4fail | final_fix07A:33/0fail |
| FIX07 invalid command schemas | red_extended:REBASE33/2fail;AIRDROP33/1fail на пакеті з cancel fix, до validator | final suites33/0fail кожен |
| FIX08 eager fallback | fix08_red:26/5fail, outputs уже рівні, але зайві calls | fix08_green:26/0fail, missing-key fallback не видалено |

Це різні snapshots test/source у конкретних точках, не сума незалежних bugs. Старі GREEN17checks FIX05 та23checks FIX06 перевіряли вужчий fixture; фінальні counts вище. Fresh-world Python fixtures мають20/38/32/32checks для05/06/07R/07A: немає legacy initial assertion і legacy-specific cases. Обидва input modes справді виконані.

## Нові test sources

- [test_phase5b2_gameplay.gd](../../../tests/test_phase5b2_gameplay.gd): case05/06/07R/07A; actual Main/HUD Button/Signal/input events, command queue/NetCodec/_exec, ownership/invalid args/free flag, disk+network save/load, cooldown boundary, hash/RNG/render cadence, cancellation/issued action, one-shot troops, legacy reader diagnostic.
- [test_phase5b2.py](../../../tests/test_phase5b2.py): два unittest methods, packs fresh source, запускає усі4cases та upkeep, ізолює user data, вимагає positive reports/zero script errors; stdout/logs не приховані.
- [test_upkeep_fallback.gd](../../../tests/test_upkeep_fallback.gd): spy count, one-pass vs reference values, money/materials/stats/RNG, ownership/inactive/new-facility/load-state mutations, genuine missing-key fallback.
- [benchmark_upkeep_fallback.gd](../../../tests/benchmark_upkeep_fallback.gd): real checkpoint/500upkeep intervals. Full simulation benchmark у ignored artifacts. Результати/методика — [performance](PHASE5B2_PERFORMANCE.md).

## Остаточна обов'язкова матриця

| Перевірка | Статус | Доказ / межа |
|---|---|---|
| Python discovery | PASS |20tests,0skips,190.224s; logs/python_all_release.log. FakeGitHub “Published” — offline mock stdout |
| Godot regression | PASS |2476/0; regression_release/regression.json та regression.log |
| Existing mechanics | PASS |309/0; mechanics_release.json/log |
| Phase5 critical | PASS |81/0; critical_release.json/log |
| R02 failure injection | PASS |111/0; restore_unit_release.json/log; один intentional post-load error очікуваний |
| R02 real loader integration | PASS |41/0; restore_integration_isolated.json/log; exact injected runtime error marker очікуваний |
| GDScript load / PCK integrity | PASS |269scripts/Main load/883 hashes; compile_release.json/log |
| Phase5 legacy Save→Load→Continue | PASS |23+23 normal/extra-render; hash9c88c42bb828b5fc/RNG1905021893/time170.666666667 збігаються. Hash відрізняється від Phase5 через нове hashed cooldown state; це очікувана compatibility boundary |
| FIX05 UI→command→simulation | PASS |21checks legacy +20fresh; owned airport building/cost/UI, foreign build/buy rejected, invalid/free commands |
| FIX06 save/cooldown/deterministic replay | PASS у fixture scope |41legacy +38fresh; repeated disk load, real snapshot restore,0/89.9/90s, malformed optional field before mutation,30ticks two render cadences |
| FIX07 REBASE/AIRDROP | PASS у fixture scope |33+33 legacy та32+32fresh; Esc/RMB SP/MP, queued action boundary, save/load, one-shot delivery; не повна flight lifetime matrix |
| Windows x64 build | PASS |windows_build_release_result.json; pinned template, existing0.34.0 build argument/repo empty. Source identifiers не змінені |
| Windows native headless | PASS functional |240frames/exit0/102.591s, запуск через UNC без staging поза worktree; windows_native_result.json та windows-release/test-logs/; actual isolated settings directory exists |
| Windows embedded PCK / DLL integrity | PASS |883hashes/269scripts/Main load під Linux editor з EXE як main-pack; windows_embedded.json.3DLL bytes match original libs (windows_integrity.json) |
| Direct Windows loaded-module polling | NOT CAPTURED |Launcher список modules порожній під UNC; не називаємо3DLL runtime loads доведеними цим poll. Native stderr не має extension-load/script errors |
| Two-process ENet admission | PASS лише admission |same build accepts; originalPR10 rejects; R02 same SIM_REV accepts. admission_release/*/result.json. Останнє — підтверджена межа identity, не gameplay compatibility |
| Старий reader нового snapshot | READ PASS / SEMANTIC DOWNGRADE UNSUPPORTED |old_reader_compat.json: реальний R02 PCK loader відкриває new snapshot, але cooldown_lost=true |
| FIX08 module benefit | PASS у профільному scope |3before+3after×500intervals;2500→0fallback; identical digest/hash/RNG |
| Whole simulation p99 | OPEN / MEASURED |3pairedbefore/after×300ticks, lab waits; не доказ глобальної оптимізації чи відсутності tail regression; performance report |
| Clean shutdown | FAIL / OPEN R18 |Windows11CanvasItemRIDs/226ObjectDB/44resources; Linux DummyTexture/resource leaks окремо. Functional PASS не підміняє cleanup |
| Windows GUI/Steam/LAN/full two-peer match/restore | NOT RUN |Немає реального end-to-end command/hash/reconnect/resync/host migration. Headless+hello не підміняють ці gates |
| Linux native extensions | BLOCKED |Matching Steam/WebRTC .so відсутні; source descriptors/native DLL не змінені |
| Full arbitrary-corrupt save/durability/refund policy | NOT RUN |R05/flight lifecycle та gameplay review окремо; не використовували private historical saves |

## Чесний облік harness corrections

Перший FIX05 GREEN мав невдалу synthetic placement site: flat rectangle задавався від center замість northwest. Виправлено fixture, потім17PASS та остаточні21PASS. Перший FIX06 RED не вимкнув net_driven для disk save; виправлено harness, справжній persistence RED — fix06_red_disk_fixture. Перший destroyed-destination case задавав тільки hp=0, а Military.alive читає obj_state; виправлено fixture до фактичного destroyed state. Assertions не послаблено.

Перший standalone R02 integration мав exit2: старий test guard не визнав новий namespace. Runner отримав дозволений ізольований df_snapshot_test_ segment; test/production не змінені; новий standalone41PASS і Python wrapper також PASS. Збережені старі logs/results; exit2 не названо product failure або PASS.

Known Linux extension/shutdown errors відділені вузькою existing allowlist плюс exact DummyTexture exit signature у новому wrapper. Нові errors не приховувалися; усі final gameplay fixtures мають0SCRIPTERROR. Intentional R02 errors рахуються окремим незміненим wrapper.

## Preservation і наступні gates

Початковий backup60files реально відновлено/hash-verified. Чотири patches відтворюють7productionfiles byte-identical у disposable copy. Попередні Phase5/R02 tests не редагувалися;16ключових restore/hot functions byte-preserved. Main/beta/OKREDU existing refs не пересувалися; read-only remote heads записані. У спільному Git з'явилася стороння локальна fix/updater-cleanup-isolation та worktree port-drone-gemini-updater; ми їх не створювали/не змінювали, не переносили звідти код. Існуючі refs незмінні, але твердження “весь список heads identical” більше неправильне.

Перед beta потрібні revision gate, code/gameplay review, Windows GUI/full real peers та закриття/явне рішення щодо інших HIGH updater/network risks. Наступні незалежні задачі: [PHASE5B3_PLAN](PHASE5B3_PLAN.md). Поточний результат ще uncommitted, не існує у HEAD96053 сам по собі.
