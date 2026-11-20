# R02 — failure injection і фактичні перевірки

2026-11-20, Godot 4.7.2.stable.official.ed1daf0bf, Ubuntu WSL2; native Windows 11 headless окремо. Повні argv/cwd/exit/час: `/home/zagor/projects/port-drone/dist/phase5b1_r02_20261120-170307/*_result.json`, stdout/stderr: `/home/zagor/projects/port-drone/dist/phase5b1_r02_20261120-170307/logs/`. Ізольовані XDG/APPDATA, updater disabled, Steam initialization bypassed, тільки synthetic/копія baseline checkpoint. Реальні saves не використовувалися.

## Нові файли тестів

- [test_snapshot_restore.gd](../../../tests/test_snapshot_restore.gd): InjectNet seam, deferred loader, MainStub, state/clock/RNG/hash/queue/flags/toast snapshots; 111 перевірок.
- [test_snapshot_restore_integration.gd](../../../tests/test_snapshot_restore_integration.gd): справжні Main/Save/NetSession, malformed compressed containers, runtime error після staged world load, menu cleanup/retry, 60 fixed ticks і різна кількість render updates, command execution order; 41 перевірка.
- [test_snapshot_restore.py](../../../tests/test_snapshot_restore.py): unittest wrapper пакує поточний source, ізолює user data, вимагає точні error markers, зберігає logs через DF_TEST_LOG_DIR.
- [test_network_admission.gd](../../../tests/test_network_admission.gd): два процеси, loopback ENet, production hello/version/rejection path. Це admission test, не повний multiplayer матч.

## RED зафіксовано до відповідних виправлень

| Артефакт | Assertions / failures | Висновок |
|---|---:|---|
| restore_red.json | 57 / 52 | Початковий defect: loader=false, а clocks/flags/resync/toast success продовжуються; seam лише делегує до Save |
| restore_red_expanded.json | 83 / 74 | Розширені duplicates/chunks/partial/cancel/failure-policy випадки на старому шляху |
| saved_resume_red_fixed_fixture.json | 100 / 13 | Пошкоджений resume metadata проходить до typed-call/default-turn success |
| ownership_race_red.json | 104 / 3 | Reconnect не інвалідовував active restore; promotion активував partial world |
| overflow_red.json | 111 / 7 | int64 turn переповнює tick і все одно дає success |

Ці RED не можна підсумовувати як незалежні дефекти. saved_resume_red.log містив parse error самого harness (назва локальної змінної); виправлено fixture, доказ — лише `saved_resume_red_fixed_fixture`. Перші два integration прогони помилялися через недостатнє очікування async menu cleanup; harness тепер чекає завершення Main.net_match_closed. Старі логи збережені, їх не видаємо за product regression.

## Failure matrix

| Сценарій | Реально виконаний шлях | Результат після fix |
|---|---|---|
| Валідний snapshot | real Save + real NetSession, legacy і fresh snapshots | PASS, commit turn/tick після finish, queues збережені |
| Invalid/truncated/wrong wrapper/ZSTD-Variant | real decoder + unit false injection | PASS, false без world mutation; NetSession fail closed |
| Відсутні core/sys/owners, format2/float1, bad ref/entity, NaN clock | real preflight | PASS; 13 malformed subcases |
| Помилка десеріалізації | real valid ZSTD with invalid Variant + injected false | PASS; stderr зберігає engine діагностику |
| Проміжний partial restore | unit mutates world перед false | PASS, frozen/discarded local session, без success |
| Реальний runtime error наприкінці `_finish` | real Main `_on_zoom` динамічний Nil call | PASS, observer ловить error і не commit; menu rebuild та explicit retry працюють |
| Помилка post-load cleanup | unit Main push_error | PASS, не commit до net_after_restore |
| Повторна спроба / duplicate begin/part/completed snapshot | unit + real valid restore | PASS, explicit retry; idempotency; contradictory chunk rejection |
| Concurrent snapshots | deferred loader + newest queue | PASS, serialized restore; старі не активуються |
| Leave/new session/reconnect/host promotion під час await | deferred lifecycle injection | PASS, epoch guard; немає stale success або partial host |
| Missing local country / invalid resume / overflow turn / invalid part index | unit entry validation | PASS, fail closed |
| Timeout | виклик production timeout handler з актуальною epoch | PASS; 180 s wall-clock очікування NOT RUN |
| Next turn / command order / 60 ticks render cadence | real restored world | PASS, commands виконуються одноразово у заданому порядку; hash/RNG збігаються |

Unit snapshots перевіряють turn/tick/net_tick/time/RNG/NetHash, flags, commands/turns/pending, resync count, UI callbacks/toasts. При failure не вимагаємо збереження активної command queue: session завершена, queue має бути відкинута. Повний світ після partial load не заявлено rollback-нутим.

## Остаточний source candidate

Результати exact candidate_release.pck і source manifest — у [checkpoint](PHASE5B_PROGRESS.md). Автогенерований підсумок: [final_results.json](/home/zagor/projects/port-drone/dist/phase5b1_r02_20261120-170307/final_results.json).

- Python discover: 18 tests, включно release/mechanics/critical/R02 wrappers.
- Godot deterministic regression: 2476 checks.
- Mechanic assertions: 309; Phase5 critical: 81.
- Phase5 synthetic Save → Load → Continue: 23 normal + 23 extra-render, однаковий hash/RNG.
- R02 unit: 111; integration: 41.
- GDScript load/compile: 269 scripts; Main scene load; PCK/source hashes: 883 files.
- Windows x64 build, embedded PCK/source hashes та native DLL hashes; native Windows headless startup — окремі result/log artifacts.

Конкретні PASS/FAIL фінального запуску див. final_results.json; перевірки попередніх candidate_complete/verified не підміняють фінальний source.

## Admission

`admission_release/*/result.json`: same build прийнято; original PR10 (0.34.0/7 без SIM_REV) відхилено; попередній Phase5 з тим самим SIM_REV прийнято. Останнє прямо показує обмеження build identity. Ніяких тверджень про full mixed-build gameplay compatibility.

## Діагностика і обмеження

Один intentional post-load ERROR у unit і один intentional SCRIPT ERROR `r02_injected_ui_failure` у integration очікуються і рахуються точно. Неочікувані script errors заборонені. Malformed Variant parser діагностика не пригнічується. Відомі Linux missing .so та shutdown ObjectDB/resources/DummyTexture RID diagnostics виділено окремо: functional PASS не означає clean shutdown; R18 OPEN/FAIL. Новий Logger також не прибирає stderr.

Ранній integration menu запускав штатний LAN discovery; остаточний fixture вимикає LAN processing. Steam accounts, production backend sessions або реальні матчі не використовувались. Loopback admission — двоє незалежних процесів, але НЕ full-match peers. Windows GUI, реальні LAN/Steam reconnect/resync, host migration — NOT RUN; native Windows failure-injection matrix — NOT RUN (виконана Linux Godot).

Performance: звичайні simulation/command функції не змінені R02. Cold restore validation додає роботу на resync, не кожен tick; paired timing у checkpoint — лише latency 3 restore calls, не p99 simulation. Попередній p99 regression лишається OPEN.


## Підсумок exact release candidate

Усі наведені functional suites фактично PASS, exit0; final_results.json звіряє counts/reports, compile/PCK hashes та admission. Windows: headless240frames,0 script errors,3nativeDLLhashesmatch;11CanvasItemRID/226ObjectDB/44resource cleanup diagnostics лишаються FAIL R18. Launcher expected_user_data спочатку помилково перевіряв custom namespace; фактичний isolated шлях `test-user/Roaming/Godot/app_userdata/DroneFlames/settings.cfg` підтверджений, observation збережено. Metadata launcher виправлено для наступного використання; старі logs/results не переписані.

Cold restore latency (3послідовні виклики, same legacy checkpoint/seed91234/engine/hardware, без паралельного Godot): до avg2197.069ms/p502273.238/max2338.161; після avg2011.204ms/p501888.195/max2276.919. Hash/RNG/clock збігаються. p99 НЕ обчислюємо із3samples, memory NOT MEASURED. Це не доказ оптимізації; normal simulation benchmark не повторювали, бо R02 не змінює hotpath. Старий p99 defect OPEN.

Python release tests друкують “Published owner/game” у mocked fixtures: це unit-test stdout, реальних GitHub публікацій не було.
