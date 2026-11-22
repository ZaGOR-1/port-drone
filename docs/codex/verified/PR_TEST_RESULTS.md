> Архівні докази зазначено як шляхи до файлів. [Розташування архівів](../../DOCUMENTATION_AUDIT.md#архівні-посилання).

# Фактичні тести Phase4

2026-11-20. Detached worktree `/home/zagor/projects/port-drone-pr-audit-96053d66`, HEAD `96053d66eb984cc24e3acce647a55a195136abd2`. Primary `af1b4c975564bac916db079d8470c2394d4920e5` не переключали. Godot **4.7.2.stable.official.ed1daf0bf**, той самий pinned editor/template, що в Phase2. Ubuntu WSL2 / Windows11 Pro x64; engine та DLL не оновлювали. Історичні baseline2458 не видаються за тести latest.

## Результати

| Перевірка | Статус | Відтворений результат | Доказ |
|---|---|---|---|
| Python unittest, detached latest | PASS | 16 tests /26.831s;15 release і1 Godot wrapper | tests/python_units.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/tests/python_units.log`), tests/python_units_result.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/tests/python_units_result.json`) |
| Godot regression suite | PASS |2476 checks,0 failures /13.818s | tests/regression/regression.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/tests/regression/regression.json`) |
| Persistent latest mechanic suite | PASS |309 assertions,0 failures /15.424s | mechanics_suite.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/mechanics_suite.json`), logs/mechanics_suite.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/mechanics_suite.log`) |
| Runtime GDScript load/can_instantiate | PASS |269 runtime scripts,0 load failures; main scene instantiate | compile_pack.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/compile_pack.json`) |
| PCK inventory/hash | PASS |883/883 packaged files match worktree manifest; latest.pck105713244 bytes | pack_manifest.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/pack_manifest.json`), compile_pack.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/compile_pack.json`) |
| Нові atlas JSON/PNG | PASS metadata |7 pairs,97 named sprites, frame rectangles у bounds, PNG dimensions=metadata | atlas_validation.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/atlas_validation.json`) |
| Normal Linux headless startup240frames | PASS startup |exit0 /26.536s; відомі missing Linux native extensions | headless_startup_result.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/headless_startup_result.json`), logs/headless_startup.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/headless_startup.log`) |
| Clean shutdown Linux/Windows | FAIL |RID/ObjectDB/resources-at-exit, Windows11/226/44 | windows_logs/smoke-stderr.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/windows_logs/smoke-stderr.log`) |
| Legacy synthetic + new-field disk/codec save/load | PASS у межі fixture |17 checks /16.533s; country, silo, carrier, planes, zones, seasons, Chronicle event | save_roundtrip.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/save_roundtrip.json`), logs/save_roundtrip.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/save_roundtrip.log`) |
| Land deal cooldown after restore | FAIL product |TRADE_COOLDOWN_RETAINED=false, окремо від17 positive assertions | logs/save_roundtrip.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/save_roundtrip.log`) |
| Seasons/frame schedule determinism | FAIL product |farm0.5 vs1.0, equal NetHash/time, PA01 | audit_probes.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/audit_probes.json`) |
| Human land trade consent | FAIL product |owner2→1 без accept, PA02 | audit_probes.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/audit_probes.json`) |
| Carrier command ownership | FAIL product |int(null) SCRIPT ERROR, allowed=false, PA03 | logs/audit_probes.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/audit_probes.log`) |
| Chronicle + live Ship | FAIL product |country_id missing, frames0, PA04 | logs/audit_probes.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/audit_probes.log`) |
| Airport action dispatch | FAIL product |mode0 замість64, positive airfield control, PA05 | airport_probe.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/airport_probe.json`) |
| Carrier sink + airborne/no-base | FAIL product |origin_px on Nil, PA06 | logs/carrier_sink_probe.log (`port-drone.tar.gz` → `dist/phase4_pr_audit/logs/carrier_sink_probe.log`) |
| Upkeep eager fallback | FAIL performance contract |fallback викликається і з наявним key, PA08 | audit_probes.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/audit_probes.json`) |
| REBASE/AIRDROP cancellation | FAIL product |обидва false, PA09 | cancel_probe.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/cancel_probe.json`) |
| Windows x64 local build | PASS |214981736-byte EXE, version0.34.0/repo="" у build copy | windows_build_result.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/windows_build_result.json`) |
| Windows11 isolated headless startup | PASS startup |exit0 /22.616s,3 DLL реально завантажені, test user dir exists | windows_logs/smoke-result.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/windows_logs/smoke-result.json`) |
| Same-checkpoint1024 CPU simulation benchmark | PASS execution / mixed performance |4 measured runs по300 ticks; p99 у latest гірший | таблиця нижче |
| GPU shader compilation/visual output/audio/DPI/mouse/keyboard | NOT RUN |Headless renderer не перевіряє GUI/GPU, helpers не замінюють input tests | Windows checklist нижче |
| Real Steam / invite /2-peer/reconnect/resync | NOT RUN |Реальні акаунти не використовували; component PA01/03 вже блокують готовність | PA01/03, baseline R02/R17 |
| Native Steam/WebRTC Linux | BLOCKED |Matching .so відсутні у source package; Windows DLL доступні | startup logs |
| Повний пошкоджений entity graph / OS power-loss / Windows GUI saves | NOT RUN |Є corrupted compressed payload та invalid wrapper, немає повної fault matrix | save fixture scope |
| Windows valid-ID SteamMock | NOT RUN |Hardcoded /tmp проблема R17 не виправлена; bypassID0 не є mock multiplayer | inherited risk |
| Окремі PR1–9 runtime binaries / author benchmarks | NOT RUN |Тестовано cumulative10, що містить усі heads; старі авторські artifacts не надані | ancestry evidence |

Рядки `Published https://github.com/owner/game/...` у unittest log походять із FakeGitHub у release unit fixtures: реальних release API/publish не викликали.

Номери2476 і309 не складаються в число унікальних сценаріїв. Python wrapper уже запускає Godot suite; persistent повтор зроблено для збереження suite.json і журналу, оскільки wrapper використовує TemporaryDirectory. Regression script незмінний:2458→2476 пояснюється трьома appended Facility kinds,3 countries×2 inventory passes=18 додаткових ітерацій, а не18 новими regression cases. Додатковий tests/test_godot_suite.gd має окремі механічні сценарії.

Діагностичні probes завершуються exit0 навмисно, щоб записати фактичний результат усіх сценаріїв. Це **не PASS продукту**: журнали містять вказані SCRIPT ERROR і невиконані очікувані інваріанти. Positive save checks не включають втрачений cooldown; він окремий FAIL. Наявний wrapper допускає resources-at-exit errors; у цьому звіті shutdown FAIL не прихований.

## Точні команди та ізоляція

Аргументи/cwd/exit/time кожного запуску — у `*_result.json`. Базові команди з detached worktree:

```bash
DF_GODOT=/home/zagor/projects/port-drone/godot_dl/godot python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --godot /home/zagor/projects/port-drone/godot_dl/godot --mode regression --out /home/zagor/projects/port-drone/dist/phase4_pr_audit/tests/regression
/home/zagor/projects/port-drone/godot_dl/godot --headless --main-pack /home/zagor/projects/port-drone/dist/phase4_pr_audit/latest.pck --script tests/test_godot_suite.gd -- --out=/home/zagor/projects/port-drone/dist/phase4_pr_audit/mechanics_suite.json
```

Ці команди запускалися harness із окремими XDG_DATA_HOME/CONFIG/CACHE, DF_NO_UPDATE=1. Перший Python driver мав DF_STEAM_MOCK=1 (локальний mock, без real Steam); подальші direct probes/smokes — DF_STEAM_MOCK=0, invalid-ID bypass до filesystem/network init. Для відтворення використовувати збережений run_local_checks.py (`port-drone.tar.gz` → `dist/phase4_pr_audit/run_local_checks.py`) та fixture argv у reports; не запускати на реальних user saves.

Додаткові fixtures (усі ignored, production source не змінено): probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/probe.gd`), carrier_sink_probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/carrier_sink_probe.gd`), airport_probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/airport_probe.gd`), cancel_probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/cancel_probe.gd`), compile_probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/compile_probe.gd`), save_probe.gd (`port-drone.tar.gz` → `dist/phase4_pr_audit/save_probe.gd`). Save test читає копію синтетичного Phase2 checkpoint, пише тільки isolated user://. Invalid compressed payload відхиляється; invalid net wrapper не змінює sampled world. Це не Main.load_slot GUI та не proof transactional _restore_from.

## Порівняння продуктивності

Один Godot процес за раз. Base PCK із збереженого Phase2, latest PCK з pinned worktree. Однаковий1024×1024 checkpoint, seed20261016,4 bots, dt0.2; baseline world прогрітий1200 simulation seconds. Checkpoint623220 bytes, SHA256 `e3e0018353af083d83b6f5ecbc83490fd3d3505b985e99ae18f7b5e49d68f704`. Кожен measured run має warmup0,seconds60,300 samples; порядок baseA→latestA→baseB→latestB. Приблизно20–21 game minutes,60 ground units,179 початкових facilities; не thousands-unit stress і не GPU/FPS benchmark.

| Run | Mean ms | P50 ms | P95 ms | P99 ms | Max ms | Samples | >50ms |
|---|---:|---:|---:|---:|---:|---:|---:|
| late_base_a | 11.988 | 10.530 | 23.276 | 36.125 | 86.844 | 300 | 2 |
| late_latest_a | 11.603 | 10.274 | 24.268 | 39.752 | 56.594 | 300 | 2 |
| late_base_b | 13.073 | 11.479 | 24.650 | 38.353 | 101.499 | 300 | 2 |
| late_latest_b | 12.321 | 11.251 | 27.142 | 47.515 | 61.883 | 300 | 2 |

Latest mean поліпшився приблизно3.2%/5.8%, median2.4%/2.0%; p99 **погіршився10.0%/23.9%**. Два повтори не дають статистичної гарантії. Кінцеві facilities185 у base та183 у latest показують змінену симуляційну поведінку; однаковий input не означає однакову роботу після balance/AI/seasons changes. Autosave main-thread snapshot у latest≈70–94ms, у base≈54–75ms. Це окремі pauses поза timed `_sim_step`; пропускати їх у full-frame оцінці не можна. Global late-game improvement не підтверджений.

Ignored benchmark_samples.gd — копія незмінного trusted benchmark; p50/raw samples додані тільки до result після timed loop. Production benchmark script не редагували. Дані й повні system totals: late_base_a.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/late_base_a.json`), late_latest_a.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/late_latest_a.json`), late_base_b.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/late_base_b.json`), late_latest_b.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/late_latest_b.json`). Seed/argv — late_seed_baseline_result.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/late_seed_baseline_result.json`). В усіх чотирьох timed logs SCRIPT ERROR не знайдено. Авторські PR3 mean3.35→2.62 і PR10 mean5.265→4.800 мають інші/ненадані checkpoint/conditions; їх не зараховано як наші результати.

## Windows build і ручний наступний тест

Build command: `python3 tools/build.py --godot <pinned editor> --template <pinned Windows template> --version 0.34.0 --repo "" --out <audit>/windows-x64`. Скрипт прочитаний до виконання; pack/build локальні, publishing commands не викликає. Він змінює version лише у власній тимчасовій копії й прибирає власний temporary build directory. Існуючі builds/backups не видаляв.

Primary EXE SHA256 `65bc699a3b414e2014def9722a33e7f8852abddc0f783739628a0e5bbbc4a533`, standalone inspection PCK SHA256 `a5781a83cd832eb1f5a50c4299b2dd33d57ab5538c3f2a7af2abec8f86ec6d7d`. Build PCK відрізняється version.cfg patch; original latest.pck є source-matching pack. Native DLL скопійовані без модифікації.

Окрема Windows копія: `C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase4-96053d66-20261120`. Launcher задає process-local APPDATA/LOCALAPPDATA, custom user namespace `DroneFlames-Phase4-96053d66`, updater disabled, mockID0. Native GodotSteam/WebRTC/steam_api64 DLL справді завантажилися; Steam init обходиться. Headless smoke не є Windows playtest PASS.

Для майбутнього ручного SP GUI тесту без реальних saves:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase4-96053d66-20261120\Run-DroneFlames.ps1"
```

Це поточна невиправлена candidate із відомими bugs. Спочатку пріоритетні fixes; тоді перевіряти меню/старт/камеру/zoom/keyboard/focus/RMB/Esc, scale100–200% і16:9/іншу роздільність; airport, carrier wing/sinking, human land consent, winter economy, mixed naval Chronicle, save/load, великий бій. Real Steam2+peer/reconnect — окрема погоджена перевірка, launcher зараз її не виконує.

## Збереження робочого стану та інструменти

preservation.json (`port-drone.tar.gz` → `dist/phase4_pr_audit/preservation.json`):881/881 source hashes і123/123 Phase2 artifacts збігаються; primary HEAD/main/migration незмінні, tracked diff порожній; detached head також clean. Rollback bundle/tars залишаються на місці. GitHub final head check:10/10 SHA/base незмінні.

Використані Git/gh API (read-only metadata/history/fetch), Python standard library, pinned Godot, PowerShell/WSL interop; Context7 official Godot4.7 docs для `_process` та eager Dictionary.get. Діаграма — drawio skill, native XML і Mermaid source. Playwright/Chrome/Figma/Semgrep не викликали, бо web UI/дизайн/зміна production code не були предметом перевірки. GitHub comments/CI/publishing tools не запускали.

Офіційне пояснення API: [Node._process](https://github.com/godotengine/godot-docs/blob/4.7/classes/class_node.rst), [Dictionary.get eager fallback](https://github.com/godotengine/godot-docs/blob/4.7/classes/class_dictionary.rst). Висновки PA01/PA08 підкріплені також власними виконаними probes.
