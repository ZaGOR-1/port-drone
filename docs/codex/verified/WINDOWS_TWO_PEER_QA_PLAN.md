# Windows: QA LAN/Steam на двох ПК

Фізичні peer-сценарії ще не підтверджено. Вибери точний [локальний QA sidecar](../../WINDOWS_QA.md) або один [офіційний комплект](BUILD_RELEASE.md) за вимогами сценарію. PowerShell-команди нижче призначені для прямого EXE із трьома DLL поруч. Для SFX з Explorer використовуй його окремий чекліст. На обох ПК зафіксуй source SHA і SHA256 EXE та DLL, ізолюй тестові профілі й вимкни updater. Схожі version/PROTO/SIM_REV самі по собі не підтверджують ідентичність файлів.

## Послідовність двох ПК

1. **Package verification.** На обох ПК звірити `Get-FileHash -Algorithm SHA256 -Path .\DroneFlames.exe, .\*.dll` із одним manifest. Записати ОС/CPU/GPU/RAM/driver/resolution/UI scale, build ID і seed/config.
2. **Singleplayer.** `& .\Run-DroneFlames.ps1 -Mode Gui`: меню, новий світ, камера, Shift/RMB/hotkeys, UI scaling, економіка/паливні конвої/Т3/power priority, авіація/флот/ядерна програма. Обрати відповідні [TC-WIN сценарії](WINDOWS_BETA_QA_CHECKLIST.md#tc-win-01--запуск) і звірити очікування з кодом та MANUAL_QA точного пакета, якщо він є.
3. **Save/Load.** Manual save, autosave під активною симуляцією, load/Continue, повторний restore. Перевірити стан на зафіксований tick, navy routes, UrbanHold cooldown, нові country/facility поля. SP launcher ізолює saves під `test-user`. Копії старих FORMAT1 перевірити окремо; new→old downgrade не підтримується.
4. **LAN.** На першому ПК `& .\Run-MultiplayerQA.ps1 -Mode Gui -Transport LAN -Peer host`, на другому — та сама команда з `-Peer guest`. Host/client обираються у штатному UI, параметр Peer лише відокремлює user/log paths. Create/join/start, команди обох людей і ownership/power priority. MP saves/logs: `mpqa-user/<peer>`, `mpqa-logs/<peer>`.
5. **Steam.** Окремий запуск з `-Transport Steam` на двох ПК, дозволені тестові accounts та підтримуване оточення. Перевірити create/join/invite/commands/disconnect. AppID480 — тестовий Spacewar, не комерційна інтеграція. Недоступне оточення позначати BLOCKED/NOT RUN, не PASS.
6. **Synchronization.** Порівняти turn/tick, RNG і state hashes на однакових ticks; різні render FPS не повинні змінювати simulation. Перевірити команди, navy, power grid, nuclear/fuel/cooldown state; потім disconnect/reconnect/resync і повторний snapshot restore.
7. **Replay/restore.** Chronicle viewer: scrub/вихід/повернення до live match; не називати його deterministic command replay. Окремо перевірити continuation після snapshot restore, hashes/RNG і маршрути на host/peer.
8. **Evidence/long run.** Архівувати engine/stdout/stderr/result JSON обох peers перед повторним запуском; screenshots/video, тільки test-save copies, seed/config, кроки відтворення та N/M. CPU mean/median/p95/p99 вимірювати окремо від FPS/GPU. Для кожного case — PASS/FAIL/BLOCKED/NOT RUN з причиною.

## Архів: SHA256 beta CI package PR #4

Source SHA/provenance перевірено: `0f26040994043827a7c14913d945a3df02e00fdd`, source_dirty=false, game_tree=`7ecbefa68a073e5064a3f11a8d61f5b4a57e6293`. Artifact: https://github.com/ZaGOR-1/port-drone/actions/runs/44937756401/artifacts/14720471938.

| File | SHA256 |
|---|---|
| DroneFlames.exe | `ffc771ff0d09689f48315b11a159784b9925e4759df274534ad26eb77accae4e` |
| libgodotsteam.windows.template_release.x86_64.dll | `6535af56d325af0fff52dbb5de3703d110bb430fdef4e3026d7ece617270e530` |
| libwebrtc_native.windows.template_release.x86_64.dll | `3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd` |
| steam_api64.dll | `8de54d32508e216c9135b8bf025749243d44e404c1c22a8e5fe35acecabe7a9c` |
