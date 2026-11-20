# Runtime baseline — Phase2, 2026-11-19

HEAD `af1b4c975564bac916db079d8470c2394d4920e5`, build0.33.2.3, protocol7, Save FORMAT1. Усі результати нижче отримані локально цього запуску. Tracked code/assets/CI/native DLL не змінені. Середовище/digests — [ENVIRONMENT_SETUP](ENVIRONMENT_SETUP.md), Windows checklist — [WINDOWS_TESTING](WINDOWS_TESTING.md).

## Фактично виконані перевірки

| Перевірка | Статус | Вимір / evidence у dist/phase2_baseline/ |
|---|---|---|
| Context freshness | PASS |881 початкових SHA256 незмінні; `logs/preflight_evidence.log`,22 static assertions |
| Fetch/cache | PASS |`python3 tools/fetch_godot.py godot_dl`, exit0; cache reuse, не нова версія |
| Upstream integrity | PASS |Повні ZIP/TPZ digests із release API, ZIP CRC, cached member hashes; `engine_integrity.json` |
| Python units | PASS |`python3 -m unittest discover -s tests -p 'test_*.py' -v`,18 tests,0.150s; `logs/python_units.log` |
| Godot regression | PASS |2458 checks,0 failures,19.498s загальний runner; `regression/regression.{json,log}` |
| Runtime GDScript load/compile | PASS |264 scripts у game/,0 failures; `compile_probe.json`, `logs/compile_probe.log` |
| Tool scripts compile | PASS |pack.gd, performance_regression.gd, performance_benchmark.gd реально виконані; разом із264 runtime це всі267 tracked .gd |
| Windows x64 build | PASS |EXE214642580 bytes, PCK embedded; `logs/windows_build.log`, `build_integrity.json` |
| PCK/resource graph | PASS |863/863 hashes matched; main PackedScene loaded/instantiated as Main із res://game/main.gd; `pack_probe.json` |
| Linux normal startup | PASS |240 iterations, exit0,26.734s; world512/terrain/nav/roads generated; `logs/linux_boot_smoke.log` |
| Synthetic save/core round-trip | PASS |7 checks,15.030s; `save_probe.json`, `logs/save_probe.log`; isolated synthetic data |
| Windows normal headless startup | PASS |240 iterations, exit0,23.617s; generation512, all3 native DLL loaded, isolated data dir exists; `logs/winlocal-smoke-*` |
| Short benchmark + checkpoint replays | PASS |Два штатні replay runs + два runs із raw samples;601 samples кожний,3 successful autosaves/run; див. нижче |
| Clean shutdown без leak diagnostics | FAIL |Linux/Windows звітують ObjectDB/RID/resources at exit; функціональні suites повернули0; diagnostics збережені |
| Initial Windows standalone-script probe | FAIL |UNC attempt timeout180s; local attempt stopped, ExitCode був порожній; fixture report не створено. Старий harness не дає PASS |
| Windows valid-ID SteamMock | FAIL |Hardcoded `/tmp/df_steam_mock`, Windows error creating /tmp; concurrent probe також дав port busy. Mock workaround у SP launcher не виправляє transport |
| Linux native Steam/WebRTC | BLOCKED |Відсутні Linux .so; tracked descriptors/native не змінювали, production services не використовували |
| Windows GUI/audio/GPU/FPS/save-load UX | NOT RUN |Потрібна ручна перевірка за checklist; headless не засвідчує видимість/звук/renderer |
|2-peer lockstep/reconnect/real Steam/ranked | NOT RUN |Цей baseline не запускав peers/accounts/production; dev/net harness у checkout відсутній |
| Updater failure injection / legacy migration | NOT RUN |Updater вимкнений; приватні saves не читали, OS failure matrix не виконували |

PASS означає перевірений scope рядка. Exit0 не приховує stderr. Linux extension-not-found — окреме platform limitation; наявний performance runner allowlist не розширювали. Рядки Published у Python log належать FakeGitHub, а argparse error — очікуваному assertRaises.

## Збірка та комплектація

Команда:

```sh
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version 0.33.2.3 --repo "" --out dist/phase2_baseline/windows-x64
```

EXE SHA256 `47aa45832766b0e4cb804e66016ffbbcf8730a535f139653e8f56be77592ffff`.

Prefix109268480 bytes точно збігається з authenticated Windows template; padding і `<QI` trailer перевірені. PCK offset109268480, length105374088, format4, SHA256 `5f1f79def0503956dbff527ec644dcef5dd57baa9f3598d53993a7db4bc5bc12`. Витягнута inspection-копія `game.pck`. Header/magic доповнено actual engine read усіх863 files і main-scene instantiate. Repo у PCK порожній, version0.33.2.3; оригінальний game/ не редагувався.

Native ZIP має рівно3 очікувані filenames, CRC і byte equality із tracked libs/; extracted DLL AMD64, source SHA256 незмінні. Windows process Modules підтвердив завантаження всіх3 із local test folder. Це перевірка load/основного ABI, не всіх Steam/WebRTC API чи online interoperability. Локальна build→Windows копія звірена хешами.

## Synthetic save scope

Fixture завантажив власний benchmark checkpoint512/2/seed20261016, створив manual slot через Save.save_game, перевірив disk envelope через Save._read, відновив core/systems/finish у новому World. До/після однакові owners/biome/flags SHA256, NetHash `4fb1c7ac778198c4`, clocks/counts; player reference знову вказує на country registry. Corrupt compressed payload відхилений; invalid network wrapper повернув false без зміни sampled state.

Це **не** тест Main._load_pack UI, довільних старих saves, rename/ENOSPC/crash recovery, every field continuity або NetSession._restore_from failure handling (R02). Перед restore було9 cities/11 facilities/0 units, game_time60.0333333333325. Private data не використовували. Benchmark додатково завершив3 autosaves у кожному run, а regression перевірив frozen body/thumbnail під live mutation.

## Порівнюваний CPU benchmark

WSL2, Ryzen5 7640HS,6 logical CPUs. World512,2 bots, seed20261016, dt0.0333333333333333. Спершу warmup60 simulation seconds і checkpoint `checkpoint.bin`,495152 bytes, SHA256 `a69159e71aca98e7d83e992fe689989ff281bd185f1256b8be41827b20ec3c91`. Кожний replay стартував із цих самих bytes, warmup0, requested sample20s, global RNG seed91234, одна engine/PCK/config. Runs послідовні, без іншого запущеного нами game/benchmark.

```sh
python3 tools/check_performance.py --mode benchmark --size 512 --bots 2 \
  --seed 20261016 --warmup 60 --seconds 20 --dt 0.0333333333333333 \
  --checkpoint dist/phase2_baseline/checkpoint.bin \
  --out dist/phase2_baseline/benchmark_seed
python3 tools/check_performance.py --mode benchmark --size 512 --bots 2 \
  --seed 20261016 --warmup 0 --seconds 20 --dt 0.0333333333333333 \
  --load dist/phase2_baseline/checkpoint.bin \
  --out dist/phase2_baseline/benchmark_replay_a
```

Другий штатний replay — та сама команда з out=benchmark_replay_b. Для p50 створена **ignored копія** `benchmark_with_samples.gd` із tools/performance_benchmark.gd; єдина зміна — додавання p50_ms/sorted samples_us у result після timed loop. Оригінальний tool/game не змінювався. Origin/clone SHA у `benchmark_instrumentation.json`, exact commands/environments у `benchmark_samples_{a,b}_result.json`. Це той самий workload; додаткові поля не входять у вимірюваний `_sim_step`.

| Run | Samples | p50 ms | p95 ms | p99 ms | Max ms | Mean ms |
|---|---:|---:|---:|---:|---:|---:|
| Штатний replay A |601|не збирався|3.312|5.174|23.009|0.872|
| Штатний replay B |601|не збирався|3.108|4.598|20.292|0.836|
| Raw-sample replay A |601|0.349|3.099|4.982|23.479|0.828|
| Raw-sample replay B |601|0.382|3.188|4.444|23.136|0.850|

Усі runs: >50ms0, >100ms0,10 cities/12 facilities/0 units у кінці, game_time80.0666666666647. Truncated decimal dt разом із ceil дає1801 warmup steps і601 sample, а не1800/600; зафіксовано фактичний count, параметр не змінювали між runs.

Це early-world CPU `_sim_step`, не бойове навантаження, GPU, FPS або full frame. Poll roads поза timed section, worker completion у SP і OS scheduling можуть впливати на timings/state application; однакові counts не доводять повну детермінованість. Розкид між runs не є improvement від code change: code change немає. Late-game2048 checkpoint та Windows frame-time profile залишаються наступними задачами. Історичні2422/11 і старі max timings — окрема baseline, не порівняння з цими601 samples.

## Діагностика та межі

Initial Windows fixture помилково використовував editor-only/export-with-debug `--script`, відсутній у release `--help`; гра стартувала замість fixture. Виправлений тільки audit launcher: normal startup/quit-after, ProcessStartInfo із реальним exit code, async stdout/stderr, loaded module inspection. UNC/локальна спроби та помилки збережені; timeout не названо game freeze.

Windows valid-ID mock також показав непереносний /tmp path (R17). У фінальному SP launcher mock ID0 повертає bad-id до UDP/filesystem/real Steam; це обхід ініціалізації для baseline, не виправлення mock.

Clean-shutdown критерій FAIL: regression190 ObjectDB/23 resources; Windows smoke204 ObjectDB/43 resources/1 CanvasItem RID; save fixture253 ObjectDB/43 resources і додаткові dummy RID diagnostics. Оцінка long-run leak growth ще NOT RUN. Жодні errors не видалені з логів, allowlist existing runner незмінний.

Усі fixtures/archives/builds/logs у ignored dist; runtime/user data синтетичні. Нові постійні висновки тут і в CURRENT_STATE; helper scripts у dist можуть зникнути при clean. Для наступного запуску source-independent commands build/regression/benchmark наведені вище, audit fixtures слід відновлювати з урахуванням зазначеного scope.
