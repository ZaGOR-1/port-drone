# DroneFlames v0.36.0 — Windows build і two-peer QA

Це лише план наступної окремої задачі. Документаційний merge PR #1 не змінює production tree цього code checkpoint; actual beta HEAD перевіряти Git. CI package нижче є конкретним приймальним cohort, не рухомим branch label. Windows GUI, LAN/Steam two-peer QA та ручний replay/restore у цій задачі НЕ запускались.

## Зафіксований комплект

- Beta / merge commit: `0f26040994043827a7c14913d945a3df02e00fdd`.
- CI push run: https://github.com/ZaGOR-1/port-drone/actions/runs/44937756401.
- CI після merge: PASS. Використовувати один artifact `DroneFlames-windows-x64-0f26040994043827a7c14913d945a3df02e00fdd` цього run на двох Windows ПК.
- Identity: `v0.36.0/7/v036-integration-1`; PROTO7 / FORMAT1. Native DLL не оновлювати.
- Не змішувати комплект із попередніми local/PR builds. Перевірити BUILD_PROVENANCE.json, SHA256SUMS.txt та QA-SHA256SUMS.txt; записати SHA256 EXE і всіх3 DLL на обох ПК.
- Updater source empty у CI; launchers задають `DF_NO_UPDATE=1`. Особисті saves не використовувати.

## Послідовність — усі сценарії NOT RUN

1. **Package verification.** На обох ПК звірити `Get-FileHash -Algorithm SHA256 -Path .\DroneFlames.exe, .\*.dll` із одним manifest. Записати ОС/CPU/GPU/RAM/driver/resolution/UI scale, build ID і seed/config.
2. **Singleplayer.** `& .\Run-DroneFlames.ps1 -Mode Gui`: меню, новий світ, камера, Shift/RMB/hotkeys, UI scaling, економіка/паливні конвої/Т3/power priority, авіація/флот/ядерна програма. Використати 18 TC-WIN сценаріїв як основу, а актуальні v0.36 очікування — з [V036_FIX_RESULTS](V036_FIX_RESULTS.md) та коду. Старі version/SIM_REV/build commands у Phase5–8 документах історичні; їх не застосовувати до цього комплекту.
3. **Save/Load.** Manual save, autosave під активною симуляцією, load/Continue, повторний restore. Перевірити стан на зафіксований tick, navy routes, UrbanHold cooldown, нові country/facility поля. SP launcher ізолює saves під `test-user`. Копії старих FORMAT1 перевірити окремо; new→old downgrade не підтримується.
4. **LAN.** На першому ПК `& .\Run-MultiplayerQA.ps1 -Mode Gui -Transport LAN -Peer host`, на другому — `-Peer guest`. Host/client обираються у штатному UI, параметр Peer лише відокремлює user/log paths. Create/join/start, команди обох людей і ownership/power priority. MP saves/logs: `mpqa-user/<peer>`, `mpqa-logs/<peer>`.
5. **Steam.** Окремий запуск з `-Transport Steam` на двох ПК, дозволені тестові accounts та підтримуване оточення. Перевірити create/join/invite/commands/disconnect. AppID480 — тестовий Spacewar, не комерційна інтеграція. Недоступне оточення позначати BLOCKED/NOT RUN, не PASS.
6. **Synchronization.** Порівняти turn/tick, RNG і state hashes на однакових ticks; різні render FPS не повинні змінювати simulation. Перевірити команди, navy, power grid, nuclear/fuel/cooldown state; потім disconnect/reconnect/resync і повторний snapshot restore.
7. **Replay/restore.** Chronicle viewer: scrub/вихід/повернення до live match; не називати його deterministic command replay. Окремо перевірити continuation після snapshot restore, hashes/RNG і маршрути на host/peer.
8. **Evidence/long run.** Архівувати engine/stdout/stderr/result JSON обох peers перед повторним запуском; screenshots/video, тільки test-save copies, seed/config, кроки відтворення та N/M. CPU mean/median/p95/p99 вимірювати окремо від FPS/GPU. Для кожного case — PASS/FAIL/BLOCKED/NOT RUN з причиною.

## Відомі ризики

CPU regression у попередніх early-world measurements; inherited shutdown leaks10 CanvasItem/224 ObjectDB/44 resources; GUI/real two-peer ще NOT RUN; downgrade unsupported. Updater integrity/atomicity та general network schemas поза targeted fixes залишаються окремим backlog. Exit0 не закриває leaks. Виявлені дефекти виправляти через окремі fix/* від актуальної beta і перевірений PR; без прямих неперевірених commits у beta.

Main, releases, tags, updater та production installations не змінювати.

## Зафіксовані SHA256 beta CI package (code checkpoint PR #4)

Source SHA/provenance перевірено: `0f26040994043827a7c14913d945a3df02e00fdd`, source_dirty=false, game_tree=`7ecbefa68a073e5064a3f11a8d61f5b4a57e6293`. Artifact: https://github.com/ZaGOR-1/port-drone/actions/runs/44937756401/artifacts/14720471938.

| File | SHA256 |
|---|---|
| DroneFlames.exe | `ffc771ff0d09689f48315b11a159784b9925e4759df274534ad26eb77accae4e` |
| libgodotsteam.windows.template_release.x86_64.dll | `6535af56d325af0fff52dbb5de3703d110bb430fdef4e3026d7ece617270e530` |
| libwebrtc_native.windows.template_release.x86_64.dll | `3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd` |
| steam_api64.dll | `8de54d32508e216c9135b8bf025749243d44e404c1c22a8e5fe35acecabe7a9c` |

## Підтримувана локальна підготовка (не виконувати автоматично)

За окремим scope, у чистому checkout exact source commit, без Editor import у game/:

```bash
# Cache необов’язковий і не tracked; отримувати лише за потреби.
GODOT_VERSION=4.7.2-stable python3 tools/fetch_godot.py godot_dl
python3 tools/ci/verify_build.py --godot-dir godot_dl --out dist/windows-qa/engine.json
DF_GODOT="$PWD/godot_dl/godot" python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 tools/check_performance.py --godot godot_dl/godot --mode regression --out dist/windows-qa/regression
python3 tools/build.py --godot godot_dl/godot \
  --template godot_dl/windows_release_x86_64.exe \
  --version "$(python3 tools/build.py --print-version)" --repo "" --out dist/windows-qa/package
cp libs/*.dll tools/qa/Run-*.ps1 dist/windows-qa/package/
python3 tools/ci/verify_build.py --godot-dir godot_dl --package dist/windows-qa/package --out dist/windows-qa/build.json
(cd dist/windows-qa/package && sha256sum -c SHA256SUMS.txt && sha256sum -c QA-SHA256SUMS.txt)
```

`--print-version` нині повертає0.36.0, explicit --version має збігатися. Непогодженого version bump не робити. Build пакує PCK у EXE (окремий PCK не потрібний), створює DLL ZIP і базовий SHA256SUMS; CI verifier додає provenance та QA-SHA256SUMS для sidecars/launchers. Engine/template мають відповідати tools/ci/godot-4.7.2.json. Для іншого worktree використати перевірені абсолютні engine/template шляхи. Немає engine — залежні tests SKIP, не PASS.

Місцеве складання не замінює зафіксований CI cohort на другому ПК: обом передати один пакет із єдиними hashes. Packer обходить game/ без сортування; bit-for-bit reproducibility окремих builds не встановлено. Не створювати game/project.godot, не видаляти tracked game/.godot. ZIP містить рівно3 початкові DLL; їх не оновлювати.

Якщо artifact із7-day retention уже недоступний, вибрати один новий успішний beta CI run з перевіреним exact source/provenance, зафіксувати новий manifest і повторити package acceptance; не змішувати його з цим cohort. Старі Phase8 commands0.34.0 та SIM_REV pr10-phase5b2-1 — історичні й не проходять current build assertion.

[18 ручних сценаріїв](WINDOWS_BETA_QA_CHECKLIST.md), [поточний стан](CURRENT_STATE.md), [flows](ARCHITECTURE_AND_FLOWS.md). Windows GUI/audio/GPU, physical LAN/Steam і тривалий матч не вважаються PASS через CI/Linux fixtures або native headless startup.
