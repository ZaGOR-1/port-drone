# Phase 5 — фактичні regression та integration results

2026-11-20. **Рішення: NOT READY для integration/merge.** Цільові FIX-01–04 пройшли перевірки, але inherited HIGH R02 відтворений, actual2-peer compatibility/reconnect не перевірені, Windows GUI й p99 gate лишаються відкритими. Code review локального diff можна починати зараз. Merge/commit/push/PR/release/CI dispatch не виконані.

## Exact candidate та докази

Worktree `/home/zagor/projects/port-drone-pr10-critical`, branch `codex/fix-pr10-critical`, HEAD/base `96053d66eb984cc24e3acce647a55a195136abd2`. Fixes **uncommitted**; HEAD не включає їх. Root checkout лишається migration branch на af1b4c975564bac916db079d8470c2394d4920e5. Усі Phase4 documents/artifacts збережені; повний pre-change docs snapshot — `dist/phase5_stabilization/docs_before.tar.gz`.

- Working tracked diff: `dist/phase5_stabilization/candidate.patch`, SHA256 `7b38c272a9927b4977a069fb9a8b7f4d76a16d59618eb8d0865894e36d2ca277`.
- Source identity включно з трьома новими tests і AGENTS: `changed_source_manifest.json`, SHA256 `4dc512c238e860ba4ccc0564058205addf646078d606438c85d5d2946ff67ad2`. New/untracked files не містяться у звичайному git diff; тому manifest потрібний додатково.
- Candidate PCK: `105722492` bytes, SHA256 `8151308b855c0a2390ac4ccad1c89d94dcd43a539a1a335cc8becce0142beb40`.
- Engine `4.7.2.stable.official.ed1daf0bf`; pinned editor/template з попереднього перевіреного baseline не замінювали.
- Усі наведені evidence files нижче — у `/home/zagor/projects/port-drone/dist/phase5_stabilization/`, якщо явно не зазначено інше. Кожен `*_result.json` зберігає точний argv/cwd/exit/elapsed, `logs/` — stdout/stderr. Artifact pack/manifest стосуються game sources; documentation overlay має окремі hashes.

## RED → GREEN

До production edits новий fixture на untouched Phase4 PCK відтворив20 failures/34 checks (`critical_red.json`, exit1). Розширений **фінальний однаковий** test script: до fixes **39 failures/62 checks**, після **81 PASS/0 failures** (`critical_red_verified.json`, `critical_green_verified.json`). Різні counts пояснюються захисним виходом із dependent tests, коли старий код не створює pending offer або Chronicle frame. Не приховані SCRIPT ERROR старого Ship accessor/невірних команд.

Нові regression sources:

- `tests/test_pr10_critical.gd`: render/RNG/real farm/hash; buy/sell/gift/swap consent; wrong sender/duplicate/replay/refuse/cancel/expiry/changed boundary/construction/deposit/funds/war; malformed args; serialized pending consent; два незалежні Ship ownership і Chronicle tests;10 carrier-loss scenarios і два літаки на одне місце.
- `tests/test_pr10_critical.py`: packs fresh source, isolated user dirs, виконує critical suite, відхиляє SCRIPT ERROR/unexpected ERROR/failed assertions. Використовує чинний вузький Linux extension/resource-exit allowlist, не приховує нові diagnostics. Нових Python dependencies немає.
- `tests/test_pr10_save_continue.gd`: справжні Main/HUD/NavyDock та inbox accept button → encoded command → simulation → disk Save.save_game → штатний Save.load_slot → sink/save/load →320 actual NetConfig.SIM_DT ticks. Запуск окремий, бо full-scene shutdown має власний FAIL. Не виконує Steam login або disposable роботу над реальними saves.

Ранні E2E setup failures збережені в e2e_first/second logs: lazy NavyDock не було створено, fixture не мав precious для F-14. Виправлено fixture через реальний HUD.open_navy_dock і явні ресурси; не змінено gameplay costs або production lifecycle заради тесту.

## Підтверджена матриця

| Перевірка | Статус | Обсяг / доказ |
|---|---|---|
| Python unit discovery | PASS |17 tests:15 offline release tests + existing Godot suite wrapper + новий critical wrapper; `python_unit_verified_result.json`,30.60s, жодного skip. FakeGitHub «Published» у log не є реальною публікацією. |
| Godot regression | PASS |2476 checks/0fail; `regression/regression.json`; старий0.33 baseline2458 збережено. Різниця18 походить від facility-kind inventory, не18 нових end-to-end tests. |
| Existing mechanics | PASS |309 assertions; `mechanics.json`; скрипт unchanged. |
| Critical fixes | PASS |81 assertions на final source; RED/GREEN вище. |
| GDScript + Linux candidate PCK | PASS |269 game scripts instantiate;883 packaged files SHA256 match; binary Main scene instantiate; `compile_third.json`, pack_manifest.json. |
| Windows embedded PCK | PASS |269 scripts, 883 hashes, Main instantiate під Linux editor з Windows EXE як main-pack; `windows_embedded_pack.json`. Окремо footer/layout/DLL validation — windows_pack_validation.json. Це не Windows GUI compilation test. |
| Legacy FORMAT1 → actual Main → disk/load/continue | PASS (functional) |Два runs ×23 assertions; `e2e_normal.json`, `e2e_extra.json`. Чинний Phase2 checkpoint копіюється/читається, не змінюється. Carrier owner/air links, consent terms, snow, loss state зберігаються; controlled DEAD видаляється наступними ticks. |
| Fresh generated world E2E | PASS (functional) |22 assertions, `e2e_fresh.json`; test також працює без зовнішнього checkpoint. |
| Fixed-tick render cadence determinism | PASS у fixture scope |Обидва legacy E2E: hash `a207ef252cd2fc8a`, RNG1905021893, t=170.666666667, snow=0.5; normal cadence vs2extra render calls/tick. Однакові commands/seed/320ticks; не full-state/transport certification. |
| Windows x64 build | PASS |Current tools/build.py, pinned template, product argument0.34.0 — уже наявна PR10 Menus версія; updater repo empty. Source version.cfg/Menus.VERSION не змінено. EXE+3 original DLL; `windows_build_result.json`, SHA256SUMS.txt. |
| Windows headless startup | PASS |Native Windows PowerShell/process, --headless --quit-after240, exit0; три DLL loaded;21.55s child runtime; `windows_logs/smoke-result.json`. Isolated APPDATA/custom namespace, mockID0/init bypass, updater off. |
| Same-checkpoint CPU benchmark | MEASURED |3builds ×3runs ×300ticks=2700 primary samples; окремо3 diagnostic profiles. Нижче всі timings; це не optimization PASS. |
| Clean shutdown | FAIL |Windows11 CanvasItem RIDs,226 ObjectDB,44resources; full-Main E2E11 CanvasItem/371ObjectDB/46resources+4dummy texture RIDs. Кількості залежать від fixture; причина/ownership не виправлені. Linux critical suite теж залишає відомі exit diagnostics. |
| Linux native Steam/WebRTC | BLOCKED |Немає matching .so; descriptors/DLL не змінені. Є конкретні extension errors; compile/functional PASS обмежений SP/component scope. |
| Actual2-peer LAN/Steam, mixed-build admission, reconnect/resync | NOT RUN |Немає перевіреного portable2-peer harness; referenced dev/net_autotest.gd відсутній, Windows valid-ID mock має R17. Steam accounts/production backend не використовували. |
| Windows GUI/input/DPI/GPU/audio, довгий late-war soak | NOT RUN |Headless не доводить UX/rendering/audio; checklist нижче. |
| Arbitrary historical/private/corrupt saves, downgrade, disk-failure matrix | NOT RUN |Нові synthetic scenarios не замінюють цю матрицю. FORMAT1 wire/envelope не змінено. |

## Незакриті дефекти перевірені після fixes

`phase5b_probe.gd`/`phase5b.json` — diagnostic exit0, **не product PASS**:

- **R02 HIGH FAIL:** invalid wrapper для snapshot turn99. Початкові exec_turn4/exec_tick2/net_tick22/go=false перетворилися на100/0/300/go=true; net_after_restore викликаний1раз, rejoining=false, toast «ВЫ СНОВА В ПАРТИИ», хоча Save.net_restore повернув false. Production `_restore_from` не змінено; саме тому NOT READY.
- **PA05 FAIL:** airport action mode0 замість AIRPORT64; airfield control PASS.
- **PA07 FAIL:** land cooldown після Diplomacy save/load не збережено. Це чинний old bug, не виправлення Phase5.
- **PA09 FAIL:** pc_cancel_mode повертає false для REBASE та AIRDROP.
- PA08 eager upkeep fallback і updater R01 cleanup підтверджені unchanged source та попереднім repro; повторно updater не запускали. Shutdown FAIL вище. План кожного окремого fix — [PHASE5B_PLAN](PHASE5B_PLAN.md).

## Повторювана продуктивність

Один checkpoint SHA256 `e3e0018353af083d83b6f5ecbc83490fd3d3505b985e99ae18f7b5e49d68f704`, map1024/4bots/seed20261016, checkpoint t1200, dt0.2, warmup0,60simulation seconds/300ticks/run. Той самий audited benchmark_samples.gd, pinned engine, WSL2/AMD Ryzen5 7640HS,6virtual CPUs. Runs sequential; порядок ротується, інші Godot/Windows tests паралельно не запускалися. Exact PCK/script hashes, CPU/OS і порядок — benchmark/environment.json. Host workload/CPU governor не зафіксовані; можливий системний розкид.

| Build / повтор | p50 ms | p99 ms | average ms | max ms | process peak RSS MiB |
|---|---:|---:|---:|---:|---:|
| 0.33 baseline / 1 | 11.127 | 42.255 | 12.982 | 110.568 | 969.8 |
| 0.33 baseline / 2 | 11.605 | 36.672 | 13.036 | 84.871 | 970.0 |
| 0.33 baseline / 3 | 11.821 | 95.228 | 15.586 | 158.159 | 970.3 |
| PR10 до fixes / 1 | 10.411 | 44.342 | 11.960 | 59.051 | 1001.9 |
| PR10 до fixes / 2 | 11.473 | 56.581 | 13.050 | 60.498 | 1009.6 |
| PR10 до fixes / 3 | 10.626 | 43.088 | 11.914 | 60.309 | 1001.0 |
| PR10 + Phase5 / 1 | 10.479 | 46.771 | 11.964 | 57.082 | 1002.2 |
| PR10 + Phase5 / 2 | 10.417 | 53.767 | 12.036 | 65.884 | 1010.8 |
| PR10 + Phase5 / 3 | 10.683 | 50.711 | 11.960 | 59.953 | 1002.8 |

Кожен рядок має300samples; p50/p99 — sorted sample indices150/297. Process peak RSS виміряно `/usr/bin/time -v` у KiB й перераховано в MiB: весь процес (startup/import/world/sim/autosave), **не** steady-state heap, GPU VRAM чи доказ leaks. Raw samples, memory files і3 autosave main-thread timings на run збережені в benchmark/. Autosaves поза timed simulation loop, _poll_roads також не входить у _sim_step timings.

Медіани per-run p99: baseline42.255ms (діапазон36.672–95.228), PR10до44.342ms (43.088–56.581), fixed50.711ms (46.771–53.767). Median mean приблизно13.036/11.960/11.964ms відповідно. Різниця p99 fixed проти pre не є доведеним причинним regression від fix, але **успішного p99 покращення немає**. Не усереднювати це з попередніми Phase4 runs і не вибирати лише швидкі повтори. Baseline/pr10 після однакового window мають185/183facilities: нові mechanics змінюють evolution; це same-input whole-build comparison, не ідентична робота алгоритмів або доведений GPU speedup.

Окрема діагностика `profile_ticks.gd` додає per-tick attribution і має overhead; її timings **не змішані** з primary comparison. Найповільніші ticks:

0.33 baseline: tick18 92.852ms (ai.update 79.619ms, rail.update 4.988ms, army.update 4.052ms); tick0 75.082ms (guide.update 33.894ms, econ.update 16.895ms, rail.update 8.995ms); tick74 42.158ms (econ.update 12.675ms, pstat.update 11.771ms, mil.update 8.701ms);
PR10 до fixes: tick0 60.960ms (econ.update 16.740ms, guide.update 15.601ms, chronicle.step 7.821ms); tick20 57.250ms (ai.update 26.096ms, delayed:_grow_initial 9.358ms, _expand_tick 6.477ms); tick19 49.599ms (ai.update 38.077ms, army.update 2.740ms, mil.update 1.862ms);
PR10 + Phase5: tick20 56.960ms (ai.update 27.240ms, delayed:_grow_initial 8.612ms, _expand_tick 6.198ms); tick0 54.775ms (econ.update 17.704ms, guide.update 12.168ms, chronicle.step 6.933ms); tick19 47.897ms (ai.update 37.485ms, army.update 2.768ms, econ.update 2.347ms);

У PR10 та fixed p99 tail концентрується на ticks0/19/20: AI batches, delayed growth/expansion, economy/guide і перший Chronicle frame після load. Це пояснює конкретні samples, не доводить, що eager fallback є їхньою єдиною причиною. Warmup0/перші ticks не виключалися з primary звіту. Окремий cache/batching/steady-state profile та PA08 fix — Phase5B; performance-success не заявлений.

## Відтворення без side effects

Працювати з candidate worktree, використати DF_GODOT=/home/zagor/projects/port-drone/godot_dl/godot і окремі XDG_DATA_HOME/XDG_CONFIG_HOME/XDG_CACHE_HOME, DF_NO_UPDATE=1, DF_STEAM_MOCK=0. Exact commands already recorded in *_result.json, driver run_checks.py створює унікальні user dirs. Не запускати standalone save fixture у реальному user://: він перевіряє test namespace і відмовляється поза ним.

1. `python3 -m unittest discover -s tests -p 'test_*.py'` із DF_GODOT.
2. `python3 tools/check_performance.py --godot <pinned> --pack <candidate.pck> --out <fresh-output>`.
3. PCK main-pack + `--script tests/test_pr10_critical.gd -- --out=<fresh-report>`.
4. PCK main-pack + `--script tests/test_pr10_save_continue.gd -- --checkpoint=<Phase2-copy> --renders=normal|extra --out=<fresh-report>`; ізольований directory name має містити phase5_stabilization або df_pr10_critical_. Без checkpoint — fresh world22 checks.
5. Benchmark argv у bench_*_result.json; не запускати паралельно з іншим benchmark/engine.

## Windows GUI та Steam/LAN checklist — ще не виконано

Збірка: windows-x64/Run-DroneFlames.ps1 -Mode Gui, окремий user namespace DroneFlames-Phase5-PR10Critical; Windows path у windows_staging.json. У цьому launcher Steam initialization вимкнена. Не тестувати updater біля робочої інсталяції та не підставляти реальні saves.

- Cold launch/menu/new game/camera/zoom/drag, keyboard/mouse/RMB/Esc, pause/speed, укр./англ. text, звук.
- 960×540/1280×720/1920×1080/2560×1440/ultrawide,125–200%DPI: без clipping, HUD/naval/diplomacy/inbox доступні.
- Carrier purchase/launch/recovery; потопити carrier з parked/airborne wing,0/full/compatible bases; owner/RTB/loss коректні, без script errors.
- Human gift/buy/sell/swap: offer не виконується до accept; reject/cancel/expiry/stale/duplicate/forged sender; save/load pending, продовжити; PA07 окремо лишається FAIL.
- Manual/auto/load/continue на копіях old/new synthetic saves, restart; не робити downgrade на єдиній копії.
- Actual2peers same candidate: commands/hash/full state при різних FPS/stalls, flight/carrier loss/consent, disconnect/rejoin/resync; negative failed restore після R02 fix. Mixed SIM_REV відхиляється ще при admission.
- LAN окремо; real Steam/invite/friends лише погодженим тестом із двома accounts і однаковою build, не через ID0 launcher. AppID480 не commercial readiness.
- Long late-war/full-frame CPU/GPU/memory/audio/exit soak; зафіксувати logs/versions/seed/map/bots/ticks. Known airport/cancel/updater issues не позначати PASS.

## Preservation, review та наступний крок

preservation_after.json:881/881 baseline files,123/123 Phase2 artifacts,250/250 Phase4 artifacts,5/5 rollback files unchanged;883/883 candidate packed source hashes current. Primary tracked diff empty; DLL/tracked .godot не змінені. Остання remote звірка 2026-11-20T16:53:00.728501+00:00: PR10/base unchanged, API clean (не approval). Beta ancestor10; fixes ще не commits.

Наступний крок: code/gameplay review з OKREDU й окремий R02 fix; потім actual2-peer та Windows GUI gates. [INTEGRATION_STRATEGY](INTEGRATION_STRATEGY.md) готує один cumulative result у beta, [PR10_BETA_PR_DRAFT](PR10_BETA_PR_DRAFT.md) — локальний текст. Нічого на GitHub не публікувати без дозволу.

Інструменти: Git/gh read-only API/ref checks, pinned Godot, Python stdlib, native Windows PowerShell; Context7 official Godot4.7 Node docs для frame semantics. Serena initialized/activated, але GDScript LSP127.0.0.1:6008 недоступний; symbol/edit operation failed без змін, тому source navigation/edits виконані rg/ordinary file tools. Browser/Figma/новий draw.io/production services не використовувалися.
