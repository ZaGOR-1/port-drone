# Phase 5C — актуальна тестова матриця

[Повна таблиця статусів і логів](PHASE5C_INTEGRATION_RESULTS.md). PASS: 26 Python (включно 4 CI policy methods, real cleanup та revision wrappers); 2476 Godot regression; 309 mechanics; 81 critical; R02 111+41; FIX05–08 21/41/33/33/26; save/continue 23+23. Source та Windows embedded: 269 scripts / 883 hashes; Windows x64 build/native headless exit 0, три DLL loaded/hash-identical.

Actual cleanup: Linux 35 PASS без skip; native Windows 36 PASS, 3 skip/N/A. Actual admission 5/5 PASS; saved identity 30 checks PASS. YAML offline parse і два launcher AST checks PASS; GitHub Actions NOT RUN.

Shutdown FAIL/OPEN; Linux native Steam/WebRTC BLOCKED; 18 GUI cases / full two-peer gameplay / real Steam/LAN NOT RUN. Loopback hello не є full multiplayer. R02 intentional injected failure/decode errors збережені та очікувані. Whole-game benchmark не повторювали: simulation hot path у 5C незмінний, p99 OPEN. Wrong-path old-reader command exit 1 збережено; corrected R02 reader PASS2 показує cooldown loss, а не downgrade compatibility.

---

## Історичний checkpoint до Phase5C (збережено)

# Phase 5B.2 — актуальні фактичні перевірки

[Повна матриця/логи](PHASE5B2_REGRESSION_RESULTS.md), [performance conditions](PHASE5B2_PERFORMANCE.md). Exact candidate_review.pck, не ранній benchmark candidate.pck.

PASS:20Python/2476Godot/309mechanics/81critical/R02111+41/new21airport+41cooldown+33REBASE+33AIRDROP+26upkeep;23+23legacy save/continue;269scripts/883PCK&embeddedEXEhashes; Windowsx64build/nativeheadlessexit0;3loopback admission cases. Native DLL hash match, direct loaded-module poll NOT CAPTURED. Real GUI/full2-peer/Steam/LAN NOTRUN; clean shutdown FAIL/OPEN.

Cooldown tests: repeated disk load, snapshot restore,0/89.9/90s, canonical hash,6malformed optional fields rejected before mutation,30ticks two cadences. Actual old reader loads new snapshot but loses cooldown: semantic downgrade UNSUPPORTED, не compatibility PASS. Targeted build command schema rejects free=true, invalid kind/types/arity; REBASE/AIRDROP schema rejects malformed args/nonfinite target. Загальний network adversarial matrix не закритий.

Нові tests/test_phase5b2_gameplay.gd, test_phase5b2.py, test_upkeep_fallback.gd, benchmark_upkeep_fallback.gd. Попередні tests не змінені. Первинний standalone R02 exit2 був namespace guard, повтор41PASS після виправлення runner ізоляції без зміни тесту. Profile3×500before/after та lab-controlled whole-sim3×300before/after виконано; p99 acceptance OPEN.

---

## Історичний checkpoint (збережено)

# Phase 5B.1 — актуальний мережевий додаток

[Повні R02 результати/argv/логи](R02_FAILURE_INJECTION_TESTS.md), [checkpoint](PHASE5B_PROGRESS.md). Нові suites: tests/test_snapshot_restore.gd (111), test_snapshot_restore_integration.gd (41), Python wrapper, двопроцесний test_network_admission.gd. Full Python discover тепер18tests. Godot regression2476, mechanic309, Phase5critical81, save/continue23+23, load/compile269scripts/PCK883files перевірені на current candidate. Остаточні exit/results зведені в final_results.json.

Обов'язкові acceptance: failed decoder/intermediate/cleanup → no success/turn commit/active session; retained diagnostic/manual retry; cancellation epoch/queued duplicates; restored command ordering/hash/RNG. Timeout handler перевірено без реального180s очікування. Після partial failure світ відкидається, не rollback-иться.

Native Windows build/headless і PCK/DLL integrity перевіряються окремо від Linux fault injection. Windows GUI, реальні Steam/LAN two-peer lockstep+restore та host rotation — NOT RUN. Loopback two-process admission PASS не підміняє їх. Shutdown ObjectDB/resource/RID errors лишаються FAIL/OPEN. p99 regression OPEN; cold restore timing не є simulation benchmark.

---

## Історичний checkpoint (збережено)

# Phase 5 — поточна матриця, 2026-11-20

Exact uncommitted candidate у codex/fix-pr10-critical від96053d66, не main/beta.17Python/2476regression/309mechanics/81critical PASS;269scripts/883candidate+Windows embedded hashes PASS; Main/HUD→command→disk save/load→continue23×2legacy+22fresh PASS functional. Два different-render runs мають однакові hash/RNG/snow після320ticks. Windows x64/native headless smoke PASS,3-way repeated benchmark MEASURED без p99 success.

**FAIL:** clean shutdown, inherited R02 failed restore advance, PA05airport, PA07cooldown, PA09cancel. **BLOCKED:** Linux Steam/WebRTC .so. **NOT RUN:** actual2-peer/version admission/reconnect, WindowsGUI/input/DPI/GPU/audio, довга late-war/full save fault matrix. Ні component PASS, ні diagnostic exit0 не перекривають failures. Рішення NOT READY для integration. Exact argv/logs/counts/benchmark/Windowschecklist — [PR10_REGRESSION_RESULTS](PR10_REGRESSION_RESULTS.md). Старі таблиці нижче зберігають їхню дату й scope.


---

## Історичний документ / попередній scope (збережено)

# Матриця перевірок — оновлено 2026-11-20

HEAD `af1b4c975564bac916db079d8470c2394d4920e5`. Позначки PASS стосуються лише фактично виконаного обсягу; static PASS не доводить runtime behavior.

## Phase4 — PR10 cumulative candidate, 2026-11-20

Повний новий звіт: [PR_TEST_RESULTS](PR_TEST_RESULTS.md), head96053d66 у detached worktree. Primary HEAD незмінний. PASS16 Python/2476 regression/309 mechanics/269 runtime loads/883 packaged hashes/17 synthetic legacy+new-field save assertions, Linux/Windows headless startup і3 Windows DLL loaded. Metadata-only7 atlas bounds PASS. Paired1024/4bot benchmark виконано: latest p99 гірший в обох повторах. Product failures PA01–PA09 і clean-shutdown FAIL мають окремі logs; positive suite не перекриває їх. Live2-peer/Steam/Windows GUI/GPU/audio NOT RUN; Linux native .so BLOCKED.0.41 runtime не тестувався. Нижчі Phase3/2 results зберігають свій історичний scope.

## Продовження Phase3 — 2026-11-20

Branch `codex/migrate-0.41.4.1`; зміни цього етапу — лише verified-документація й окремі ignored evidence files. Нижче нові результати; наступні секції зберігають історичні запуски 19 листопада.

| Перевірка | Статус | Фактичний scope / evidence |
|---|---|---|
| Git branch/HEAD/main і baseline preservation | PASS | HEAD/main af1b4c9, tracked diff empty, 881/881 SHA256; `continuation_20261120/preflight.json`, `integrity.json` |
| Phase2 artifacts і extracted release preservation | PASS | 123/123 і 25/25 SHA256; локальні release ZIP/manifest hash unchanged. Не повторювали ZIP CRC або binary analysis |
| Rollback | PASS | `git bundle verify dist/phase3_041/rollback/repository-main.bundle`, exit0; tar catalog 881 tracked/18 documents. Restore/destructive reset NOT RUN |
| Publisher refs/releases/history discovery | PASS (inspection) | 10 unchanged branch heads, 12 tags/12 releases, 28 main commits present/path-scanned; dev package не знайдений. Старі unchanged branch trees reused |
| Власний fork і credited port | PASS (inspection) | 12 fork manifests 0.33.2.3; 10 нових trees; credited master/test upstream 0.33.4, 74 releases без 0.41. Це не functional tests цих branches |
| Локальні archive candidates | PASS (inspection) | 6 ZIP: два source-labelled по 881/881 old files; два documentation pack по 29 files; два byte-identical runtime release ZIP. `local_materials.json` |
| Full editable 0.41 / Windows source build / logic changes | BLOCKED | Matching game/net/resource/engine/bridge inputs не отримано; шість capability gates — MIGRATION_041 |
| Permission scope, Save FORMAT/PROTO 0.41 | UNKNOWN | Користувач/власник ще не надав підтвердження або schemas; pc34-v1 не є FORMAT number |
| Runtime/GUI/benchmark/save/network suite | NOT RUN сьогодні | Documentation/source discovery scope; немає code changes. 0.33 PASS нижче — історичні. Новий release runtime не виконували |
| Encryption bypass / production / publishing | NOT RUN | Заборонені scope; жодних таких дій |

Шляхи в таблиці відносні до `dist/phase3_041/`. Raw GitHub responses — `continuation_20261120/github/`, coverage — `continuation_20261120/source_search_summary.json`; перевірка docs/preservation наприкінці — `continuation_20261120/final_validation.json`. Після restart використані вцілілі JSON responses, aggregate transport log одного batch не встиг записатися (`continuation_20261120/recovered_responses.json`). Web fetch для tags/profile мав обмеження; ці дані отримано успішним штатним public REST read, без доступу до приватних матеріалів.

## Phase3 — release0.41.4.1 analysis

Branch codex/migrate-0.41.4.1; current game source залишається0.33. Inputs/commands/logs під dist/phase3_041, деталі VERSION_041_ANALYSIS/MIGRATION_041. Старі18/2458 PASS не зараховуються як0.41 tests.

| Перевірка | Статус | Фактичний scope |
|---|---|---|
| API asset SHA256 + publisher SHA256SUMS | PASS |ZIP227958581 bytes, c23c413b…d162b0; manifest digest також збігається |
| ZIP CRC і safe paths | PASS |Усі25 files;477634394 unpacked bytes; duplicates/traversal/symlinks відсутні |
| PCK header/static structure | PASS |Format4/producer4.7.2,flags3, encrypted index,693 declared entries; це не internal file inventory |
| Trusted stock Godot read-only mount | FAIL |Exit2: encrypted directory/MD5 mismatch; release code/native не load/instantiate |
| GDScript/GDC/scenes/resource catalog extraction | BLOCKED |Немає release key/nonencrypted dev export; внутрішні file types UNKNOWN |
| PE/ELF/version/import/export metadata | PASS |Static only; engine custom_build, game core self-label0.41.4, exact files/digests/entrypoints |
| Bridge→images hash references | PASS |Bridge містить SHA256 усіх3 supplied ELF images; runtime execution NOT RUN |
| Old/new WebRTC identity | PASS |Byte-identical4058112-byte DLL |
| Tag/main source comparison | PASS |881/881 Git blob SHA збігаються з0.33 checkout; це не нові0.41 sources |
| Public branch source availability | PASS (inspection) |10 untruncated trees; native C++/Lua/build-source package/license files не знайдені; не доказ відсутності private source |
| Git rollback bundle | PASS |Complete main history, git bundle verify; tar881 tracked files + Phase2 doc snapshot |
| Game/main/Phase2 preservation | PASS |Перевіряється фінальним validator:881 tracked hashes і123 Phase2 artifact hashes, main ref |
| License/permission gate | UNKNOWN / не підтверджено |Умова користувача перед adaptation; source gates незалежно BLOCKED |
| Власна source-built0.41 / port transplant | BLOCKED |Редагований game/net/resource/engine/bridge package не отриманий |
| New release runtime/GUI/audio/gameplay/save/net comparison | NOT RUN |EXE/DLL/SO/PLAY/uninstaller не запускали; немає власної еквівалентної source build |

Уточнення 20 листопада: `dist/phase3_041/validation.json` і `logs/validation.log`, раніше наведені тут як фінальні assertions, **відсутні**; їхній успішний запуск не підтверджено. Первинні release/tag/branch/mount evidence збережені; фактична нова звірка preservation — `continuation_20261120/integrity.json`. PCK mount FAIL збережений, не замінений випадковою зміною engine/template. Save/protocol0.41 values UNKNOWN; жодних cross-version saves/peers не запускали.

## Збережена Phase2 baseline0.33

Повні commands/digests/scopes/benchmark: [RUNTIME_BASELINE](RUNTIME_BASELINE.md). Setup: [ENVIRONMENT_SETUP](ENVIRONMENT_SETUP.md); manual steps: [WINDOWS_TESTING](WINDOWS_TESTING.md).

| Перевірка | Поточний статус | Evidence |
|---|---|---|
| Pinned engine/template, full archives/member hash | PASS |4.7.2.ed1daf0bf; `dist/phase2_baseline/engine_integrity.json` |
| Python unit tests | PASS |18 tests; `logs/python_units.log` |
| Godot regression | PASS |2458 checks/0 failures; `regression/regression.json` |
| Runtime GDScript compile/load | PASS |264 game scripts;3 tool scripts також реально виконані |
| PCK/scene integrity | PASS |863/863 hashes, main scene loaded/instantiated, cfg.repo empty |
| Windows x64 build/native load | PASS |214642580-byte EXE,3 tracked DLL loaded; `build_integrity.json`, `logs/winlocal-smoke-result.json` |
| Normal Linux/Windows headless boot | PASS |exit0, generation/terrain/nav/roads;26.734s/23.617s |
| Synthetic manual save/core-system restore | PASS |7 checks; corrupt bytes/invalid wrapper rejected; `save_probe.json`; не GUI/migration/OS failures |
| Short benchmark, same checkpoint | PASS |601 samples/run, p50/p99/max/raw samples у audit copy; RUNTIME_BASELINE table |
| Clean shutdown без leaks | FAIL |ObjectDB/RID/resources-at-exit diagnostics лишилися |
| Initial Windows --script fixture harness | FAIL |Release CLI option відсутній;180s timeout, місцева спроба невалідна; виправлено лише harness |
| Valid-ID Windows SteamMock | FAIL |Hardcoded/tmp directory; R17. Final SP launcher ID0 обходить init |
| Linux native Steam/WebRTC | BLOCKED |Відсутні .so, descriptor/native не змінені |
| GUI/audio/GPU/FPS/Windows save-load UX | NOT RUN |Ручний checklist готовий |
|2-peer lockstep/reconnect, real Steam/ranked | NOT RUN |Production/account не використовували |
| Updater negative matrix / legacy save migration | NOT RUN |Updater disabled; лише synthetic save/core scope перевірений |

Логи Phase2 під `dist/phase2_baseline/`; точні argv/environment/time/exit — `*_result.json`. Functional PASS не приховує stderr: для clean-shutdown є окремий FAIL. Нові fixture scripts у ignored dist, код гри/формати/CI не змінені.

## Архів результатів Phase1

Наступна таблиця зберігає стан **до** встановленого Phase2 baseline; її NOT RUN не є поточним статусом engine/build/regression. Поточні результати наведені вище.

| Перевірка | Команда / спосіб | Статус | Результат / лог |
|---|---|---|---|
| Release/version/publication logic | `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_release.py'` | **PASS** | 15 tests, 0.139 s; `dist/codex_audit/logs/release.log` |
| Локальний documentation pack | `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_pack_scripts.py'` | **PASS** | 3 tests, 0.035 s; `dist/codex_audit/logs/pack.log`; цей test file спочатку untracked |
| Базовий інвентар | `python3 tools/codex/repository_audit.py --repo . --out dist/codex_audit` | **PASS** | 881 files, 7858 symbol rows, 863 deduplicated res tokens; `inventory.*`, `symbols.csv`, `resource_references.csv` |
| Уточнена класифікація/аналіз | `python3 dist/codex_audit/analyze_sources.py` | **PASS** | 598 text + 283 binary; `source_analysis.json`; лексичний аналіз GDScript не є compiler parse |
| Resource/config/native metadata | `python3 dist/codex_audit/inspect_resources.py` | **PASS** | ECFG 26 entries; 210/210 import/remap targets; PE AMD64 для трьох DLL |
| JSON/PO/atlas/video metadata | `python3 dist/codex_audit/validate_data.py` | **PASS** | 86 JSON; 4 PO structural parse без duplicate keys; 3651 sprite rectangles у межах заявленого size; 66/66 clip refs; `data_validation.json` |
| Assertions статичних доказів і незмінності source | `python3 dist/codex_audit/verify_evidence.py` | **PASS** | 22 checks,0 failures; `dist/codex_audit/logs/static_checks.log`, `evidence_validation.json`;881 SHA256 unchanged |
| Editable architecture diagram | XML repair/parse, draw.io Desktop CLI PNG export, preview inspection | **PASS** |15 nodes/16 edges; `droneflames-architecture.drawio`; preview/logs у dist; це перевірка документації, не гри |
| Python syntax | `ast.parse` усіх 7 tracked `.py` | **PASS** | `source_analysis.json`; залежності або API Python при цьому не виконуються |
| Godot regression | `python3 tools/check_performance.py` | **NOT RUN** | Немає `godot_dl/godot`, executable Godot у PATH не знайдено |
| Short simulation benchmark | `python3 tools/check_performance.py --mode benchmark --size 512 --bots 2 --warmup 60 --seconds 20 --dt 0.0333333333333333 --out dist/codex_audit/benchmark` | **NOT RUN** | Немає engine; p50/p99/max/samples відсутні |
| PCK/build/scene startup | build command у BUILD_RELEASE | **NOT RUN** | Немає pinned editor/template; немає Godot instantiate binary scene |
| Windows GUI / responsiveness / audio | 960×540, 1280×720, 1600×900, 2560×1440, ultrawide | **NOT RUN** | Гру не запускали; WSL наявність не засвідчує Windows game smoke |
| Steam mock 2+ peers | `DF_STEAM_MOCK`, isolated users і різні modulo-1000 IDs | **NOT RUN** | Немає Godot; mock не забезпечує реальну Steam reliability/packet limits |
| Реальний Steam / LAN / WebRTC / ranked | Два клієнти, одна build version | **NOT RUN** | Немає runtime; production endpoint і чужі дані не чіпали |
| Updater failure matrix | Fake API/EXE/DLL, окрема тека | **NOT RUN** | Не виконували updater біля реальної інсталяції |
| Save migration / старі saves / full round-trip | Тільки synthetic/copied saves в isolated user:// | **NOT RUN** | Приватні збереження не читали; без Godot не можна підтвердити format round-trip |

`Published https://github.com/owner/game/...` у release.log виводить tested function із **FakeGitHub**. Реальних release/network mutations не було. `usage/error --out must not be inside game/` у pack.log — очікуваний тест `assertRaises(SystemExit)`, suite PASS.

## Що реально тестує наявний код

`tests/test_release.py`: numeric versions, event selection, PR isolation, rerun order, checksums і склад assets, draft-before-publish, resume після failure, заборона overwrite і cross-commit draft, API failure. Це offline модель GitHub CLI, не інтеграційний CI-run.

`tools/performance_regression.gd`: facility inventory до/після capture/build, spatial query order, water/bridge differential, ownership edge samples, colony fairness/cancellation, entity encoding/reference order/cycles, pending colony round-trip, snapshot/thumbnail isolation while live arrays mutate. Phase2 фактично отримав **2458 PASS**,0 failures. Немає повного world replay hash між двома peers у цьому suite.

`performance_benchmark.gd`: seed global RNG 91234, world seed default 20261016, прямий `_sim_step(dt)`, optional checkpoint у форматі `Save.net_snapshot`, warmup, відсортовані timings. Звіт має mean/p95/p99/max, >50/>100ms, три autosave calls, system totals/peaks. **p50 не записує.** Метод не вимірює rendering/GPU/full-frame FPS; `_poll_roads` виконується поза виміряним `_sim_step`, а без `lab_tick` залежить від completion time workers. Paired checkpoint і повтори потрібні для порівняння.

`check_performance.py` пакує тимчасовий PCK, задає ізольовані XDG_DATA/CONFIG/CACHE та `DF_NO_UPDATE=1`, видаляє старий report перед запуском, відхиляє nonzero/SCRIPT ERROR/unexpected ERROR/missing or empty report. Allowlist охоплює конкретні WebRTC/GodotSteam та resource-in-use-at-exit errors, не всі Linux-помилки. Це слід зберігати.

## Історична baseline — не поточний PASS

`docs/performance.md`: 2422 regression і 11 integration checks, 2048 map/seed20261016/four bots, 1500 samples при dt0.2, max 279.83→82.88 ms від baseline `03ea866`. Ці ignored логи/checkpoint у поточному workspace не були надані як наявні результати цього аудиту. Відтворення на цьому HEAD **NOT RUN**.

## Стан колишнього environment blocker

Godot4.7.2/editor/template integrity і isolated runner тепер перевірені. Далі Windows GUI, portable mock2 peers, потім погоджений real Steam smoke. Для network/save changes потрібні negative/failure cases; короткий7-check save probe не закриває всю матрицю BACKLOG.
