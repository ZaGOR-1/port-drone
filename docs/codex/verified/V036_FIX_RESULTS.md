# v0.36 — integration fixes, 2026-11-21

Поточна задача: виправлення findings [PR #3](https://github.com/ZaGOR-1/port-drone/pull/3), окремий integration PR → beta, **без merge**. Початковий [review](V036_REVIEW.md) зберігається як історичний доказ RED. Це цільові виправлення, не повний повторний аудит. Compiler/load coverage не означає повне ручне читання всіх sources.

## Git та дозвіл

- Repository: https://github.com/ZaGOR-1/port-drone.
- Незмінна beta/base: `145f23418a9a07420a15d6c350ac62c7633e2765`.
- Main: `172df65e3bd004efed9a5444e90a284d9d69db10`; не змінювався.
- Original feature: `151264b38c335b55df4e62bdaff346f27ed92970`, 8 commits OKREDU/CAFAIML; усі є предками integration HEAD. Немає squash/cherry-pick/rebase чи переписування авторства.
- Власна гілка: `fix/v036-review-integration`, worktree `/home/zagor/projects/port-drone-v036-review`; вже містила feature і beta на початку цієї задачі. Новий merge feature не потрібен, ancestry збережено.
- Primary beta checkout та detached baseline збережені. Додатковий detached feature worktree — лише для порівнянь. PR #1 і гілку OKREDU не змінювати; PR #3 лишити відкритим. Власник заборонив merge beta навіть після зеленого CI.

## Виправлення та поведінкові тести

| Finding | Root cause / реалізація | Regression (RED → GREEN) |
|---|---|---|
| HIGH-01 identity | CI примусово переписував source v0.36 у v0.34; старий SIM_REV. `NetConfig.SIM_REV=v036-integration-1`; UI/updater `0.36.0`; `build.py --print-version` перевіряє їхню згоду, `--version` лише assertion. CI бере source version; `verify_build.py` читає identity з actual embedded EXE. PROTO7 і FORMAT1 не підвищені: структуру пакета/формат не замінено, simulation cohort несумісний. | `test_build_identity.py`, `test_network_identity.py`: реальні два незалежні ENet processes (loopback), same/current admission; current/old SIM_REV, current/beta, beta/current rejection. `test_sim_revision.gd`: saved-match mismatch відхиляється перед mutation. |
| HIGH-02 autosave | `_queue_write` робив shallow body copy і копіював тільки відомі core buffers; entity PackedArrays з `inst_to_dict` залишалися aliases. Повний `duplicate(true)` encoded graph/header/thumbnail виконується один раз синхронно перед worker. На simulation ticks копій немає. `_snapshot` — синхронний builder; freeze boundary — перед передачею worker. | `test_v036_regressions.gd::_autosave`: 10→99, кілька entities, nested Dictionary/Array/typed PackedArray, ref identity, два disk write/read та entity restore. |
| HIGH-03 Navy | Threat TTL1.5s / route TTL15s залежали від незбереженої історії queries. Прибрано ці два кеші; геометричний кеш, fast weights/LOS збережено. Повторний load також обнуляє generation marks/counts разом із `_tw_seq` — інакше warmed AStar не застосовував загрози після restore. | `_navy`: переміщення threat, system serializer/loader, кілька restore на warmed runtime, threat-present повторення, маршрути/NetHash/RNG та однаковий наступний input. Обидві причини окремо відтворено RED. |
| HIGH-04 UrbanHold | `_far_fail` впливав на dispatch, але був пропущений у save; reused runtime залишав stale values. Optional `far_fail` у FORMAT1, overwrite/clear на load, scratch очищується. `Save._sound` перевіряє shape/finite timestamps до mutation. | `_hold`: save/load через system codec, fresh і repeated restore, legacy omission→empty, справжній `_auto_city` блокує path search до cooldown; malformed optional state відхиляється. |
| HIGH-05 power | whitelist очікував integer country ID, Main надсилає Country entity → `int(Country)`. Entity ownership (-1), exact country/priority schema, wire precheck до загального codec, строгі entity ID types. `_cmd_rq` як і раніше визначає slot за sender і видаляє client-selected `c`. | `_power`: owner/foreign peer/foreign country, invalid ID/types/arity/priority, malformed wire containers, replay на restored Country. Жодного обходу authorization. |

Файли реалізації: [save.gd](../../../game/game/save.gd), [navy.gd](../../../game/game/navy.gd), [urban_hold.gd](../../../game/game/urban_hold.gd), [net_session.gd](../../../game/net/net_session.gd), [net_codec.gd](../../../game/net/net_codec.gd), [net_config.gd](../../../game/net/net_config.gd), [build.py](../../../tools/build.py), [CI verifier](../../../tools/ci/verify_build.py).

## Додаткові findings

- [NetHash.v036_state](../../../game/net/net_hash.gd): nuclear timers/warhead/stages, Zaslon queue, T3, EMP/NPP/refinery state, country power/pledge, city EMP, missile warhead/decoy/split, fuel convoy authoritative fields, Navy route/index, UrbanHold state. Dictionary keys canonicalized recursively; simulation array order збережено. Convoy heading/frame не хешуються. Save codec globals не чіпаються. `_hash_state` змінює поля окремо; тестує canonical insertion order, convoy route/payload і Navy path до розходження координат. Це розширення hash coverage, не доказ exhaustive hashing усієї історичної симуляції.
- [Hud.open_kind_mass](../../../game/ui/hud/hud_keys.gd): skip недоступної категорії/type/protection до створення рядка; спільний VBox не ховається, empty hint видимий. `_upgrades` запускає actual row builder у відповідній Scroll/VBox topology і actual economy preview/application: affordable farm + unavailable mine, ресурси/ціна, maxed/busy, empty/all modes. Це headless UI tree check, не Windows GUI QA.
- [HoldTip](../../../game/ui/ui24/hold_tip.gd), silo card, changelog і en/uk/es PO узгоджені: EMP75s, MIRV2decoys. Gameplay constants не змінені заради текстів; `_tooltips` перевіряє actual Translation resources.
- `test_snapshot_restore_integration.gd`: actual Main loader тепер відновлює нові country/facility/cooldown поля, повторює snapshot, порівнює hash/RNG continuation за різних render schedules; optional fields omission перевіряє defaults на legacy FORMAT1. Існуючі fault injection tests збережено.

## Сумісність і межі

Identity `v0.36.0/7/v036-integration-1` відділяє стару beta та початкову feature. Same identity не fingerprint; для QA використовувати exact same EXE/DLL SHA256. Старі FORMAT1 saves без нових полів читаються з defaults; повернення new saves у старий код не підтримується (cooldown губиться). Повної міграції довільних приватних saves не перевіряли.

Наявність правильних маршрутів/hash у fixtures не сертифікує повний multiplayer. General network schemas інших whitelist methods залишаються окремим backlog: цей patch захищає power command і entity reference envelope, не переписує весь codec. Updater integrity/atomicity, save durability при OS interruption та inherited shutdown leaks не закриті. DLL, game resources/project.binary/.godot не змінені; Editor import не запускався, project.godot не створювався.

## Перевірки цієї задачі

- Перший identity batch: PASS15, actual packaged identity PASS.
- Повний fresh baseline beta: PASS32 / 287.870s.
- Final integration batch: PASS43 / 203.811s, новий v0.36 behavioral fixture містить108 assertions, включно з edge regressions Navy scratch/wire containers, entity cycles та packed buffer types. Попередній batch PASS43/320.502s також збережений.
- Actual Main snapshot/failure/replay/legacy suite: PASS, включно з очікуваними intentional injection diagnostics.
- Source validation: initial PASS90 scripts/3 translations; final PASS93 (явно додані NetConfig/NetCodec/NetHash)/3 translations; початковий паралельний validation timeout90s зафіксовано, повторний run PASS. Це compile/load, не ручний аудит.
- Semgrep GDScript: unsupported (попередній review); Serena init використано, G07/LSP launcher не змінювався. Основні інструменти: Git/gh, Python, Godot4.7.2 CLI; без Playwright замість native GUI.
- Windows GUI / independent LAN / real Steam / GPU FPS: NOT RUN.

Команди:

```sh
DF_GODOT=/home/zagor/projects/port-drone/godot_dl/godot \
  DF_TEST_LOG_DIR=dist/v036-fixes/logs DF_NO_UPDATE=1 DF_NO_OPENING=1 DF_STEAM_MOCK=0 \
  python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --godot /home/zagor/projects/port-drone/godot_dl/godot \
  --mode regression --out dist/v036-fixes/regression
python3 tools/build.py --godot /home/zagor/projects/port-drone/godot_dl/godot \
  --template /home/zagor/projects/port-drone/godot_dl/windows_release_x86_64.exe \
  --version "$(python3 tools/build.py --print-version)" --repo '' --out dist/v036-fixes/windows-x64
cp libs/*.dll tools/qa/Run-*.ps1 dist/v036-fixes/windows-x64/
python3 tools/ci/verify_build.py --godot-dir /home/zagor/projects/port-drone/godot_dl \
  --package dist/v036-fixes/windows-x64 --out dist/v036-fixes/build-verification.json
```

Local evidence: ignored `dist/v036-fixes/` (RED/GREEN logs, fixtures JSON, performance comparison, artifacts). Старий `dist/v036-review/` не видавати за поточний PASS. Якщо локальні логи відсутні, повторювати checks; не вважати історичний звіт новим запуском.

## Performance comparison

Один pinned engine/host, той самий beta checkpoint, size512/bots2/seed20261016, warmup0, seconds180, dt1/30, 5400 samples/run. Одна external timing script (із median поза timed loop) виконувалась проти трьох окремих PCK, порядок beta→feature→fixed→fixed→feature→beta. Жодного іншого Godot test/build під час вимірювань не було.

| Source | Mean ms (run1 / run2) | Median ms | p95 ms | p99 ms |
|---|---:|---:|---:|---:|
| Beta | 0.2410 / 0.1968 | 0.1390 / 0.1155 | 0.704 / 0.567 | 1.810 / 1.614 |
| Original feature | 0.2373 / 0.2602 | 0.1310 / 0.1370 | 0.678 / 0.771 | 1.761 / 2.100 |
| Fixed | 0.3130 / 0.2644 | 0.1730 / 0.1390 | 0.913 / 0.768 | 2.396 / 2.084 |

**Загального performance gain не підтверджено; fixed у цих runs повільніша за beta.** Це early-world CPU, 0 units, не FPS/GPU/late-war acceptance. SP async road completion дає 19/20 facilities після replay навіть на тому самому source/checkpoint; це обмежує equivalence workload. Причину всього розкиду не встановлено. Correct freeze коштує більше за небезпечний shallow save: fixed autosave main7.06–15.49ms проти original5.90–11.89ms і beta9.20–14.08ms. Це не підстава повертати alias/desync дефекти.

Вузький grid test:4000 units,130 rebuilds,4800 queries, той самий six-run order; candidate_count1039642 в усіх. Beta query mean8.46/7.74µs, p99=30/20; feature7.14/7.15µs,p99=20/18; fixed13.25/7.15µs,p99=65/19. Grid implementation feature/fixed однакова — великий міжпрогоновий шум. Rebuild beta3.86/3.04ms, feature4.13/4.28ms, fixed4.68/3.77ms. Є tradeoff query/rebuild; доказу, що всі flat/mask оптимізації безкорисні, немає, їх не відкидали глобально. Прибрано саме два небезпечні Navy TTL caches і unsafe shallow autosave optimization; інші зміни автора збережено.

Mean/median/p95/p99/max і system totals, autosave costs: `dist/v036-fixes/performance/comparison.json`; grid — `grid-comparison.json`. Потрібний наступний controlled late-war Windows CPU/GPU profile.

## Final build та integration PR

Windows x64 local build + PE AMD64 / embedded PCK / pinned template / ZIP / original DLL / SHA256 / runtime identity verification: PASS. Godot4.7.2.stable.official.ed1daf0bf. Local development artifact provenance чесно містить source_dirty=true через незакомічені звіти/тести; для QA брати фінальний чистий CI artifact одного exact commit.

Godot regression suite: PASS2476; Python AST/YAML/events/diff/local Markdown links: PASS. Native Windows headless Smoke: PASS exit0 / 54.691s, isolated test-user, updater off, усі3 DLL зафіксовані module poll. Clean shutdown FAIL/inherited:10 CanvasItem RID,224 ObjectDB,44 resources-at-exit, як у початкової feature; diagnostics не приглушені. Final local test batch: PASS43. Remote PR/CI ще не підтверджений на момент цього документа; actual GitHub run є джерелом його статусу. Остаточний статус дивитися у PR та фінальному звіті задачі; merge заборонений поточним завданням незалежно від результатів.
