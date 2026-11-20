# Windows11: тестова збірка Phase2

Стан на2026-11-19, HEAD `af1b4c9`, version0.33.2.3. Це локальний тестовий артефакт; GitHub Releases/CI не запускали.

## Розташування й комплект

Основний результат збірки в єдиному Ubuntu checkout:

`~/projects/port-drone/dist/phase2_baseline/windows-x64/`

Готова перевірена копія для запуску з локального Windows filesystem:

`C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase2-af1b4c9-20261119`

Ubuntu бачить її як `/mnt/c/Users/ZaGOR/AppData/Local/Temp/DroneFlames-phase2-af1b4c9-20261119`. Це тільки копія artifacts, не checkout; Temp може бути очищений ОС. Постійне джерело — dist у Ubuntu. Можна скопіювати **всю** тестову теку в інше writable місце та запускати її launcher.

| Файл | Призначення |
|---|---|
| `DroneFlames.exe` |214642580 bytes; release template + embedded PCK |
| `libgodotsteam.windows.template_release.x86_64.dll` |3980800 bytes |
| `libwebrtc_native.windows.template_release.x86_64.dll` |4058112 bytes |
| `steam_api64.dll` |319128 bytes |
| `libs.rev` |1; набір із tracked libs/ |
| `DroneFlames-libs-r1.zip`, `SHA256SUMS.txt` | Оригінальні build artifacts; ZIP CRC, source hashes і checksum manifest перевірені |
| `override.cfg` | Окремий user-data namespace; main scene/graphics не змінює |
| `Run-DroneFlames.ps1` | Ізоляція даних, updater bypass, log capture, фактичний exit code |

Окремий PCK не потрібен біля EXE: він embedded. Inspection-копія: `dist/phase2_baseline/game.pck`,105374088 bytes, format4. Manifest/provenance — RUNTIME_BASELINE.

## Як запустити GUI

Відкрити PowerShell у Windows і виконати:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase2-af1b4c9-20261119\Run-DroneFlames.ps1"
```

ExecutionPolicy обходиться лише для цього процесу; системні налаштування не змінюються. Launcher чекає закриття гри й записує `test-logs/gui-{engine,stdout,stderr}.log` та `gui-result.json`.

Для повторного headless smoke, який уже виконаний:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Users\ZaGOR\AppData\Local\Temp\DroneFlames-phase2-af1b4c9-20261119\Run-DroneFlames.ps1" -Mode Smoke
```

Launcher явно вимикає updater (`DF_NO_UPDATE=1`, у PCK також repo=""), intro (`DF_NO_OPENING=1`), задає uk. Steam init обходиться через `DF_STEAM_MOCK=0`, який повертає bad-id до filesystem/UDP/Steam API. Повідомлення `[Steam] init failed (1): mock: bad id` очікуване. Це **single-player baseline**, не Steam test. Не обирати online/ranked і не вводити account credentials у цій перевірці.

`APPDATA=<тека збірки>\test-user\Roaming`, `LOCALAPPDATA=...\Local`; user:// фактично в `Roaming\DroneFlames-Phase2-af1b4c9`. Save/load перевіряти тільки тут. Не переносити реальні saves. Для збереження ізоляції користуватися повним комплектом і launcher-ом.

## Що вже реально перевірено

**PASS:** Windows release version/hash відповідає editor4.7.2; headless startup exit0,23.617s; generation512/terrain/nav/roads/strategic layer виконані; усі3 DLL завантажені з тестової теки; ізольований user directory створений. GDExtension load errors і SCRIPT ERROR не знайдені.

**FAIL — clean shutdown:**1 CanvasItem RID,204 ObjectDB instances,43 resources still in use at exit. Логи збережені; не доведено зростання витоків у тривалій грі. **GUI/audio/FPS/Steam функціональність NOT RUN.**

Перший `--script` probe не виконав fixture: release CLI не має цього option, запустилася гра без quit-after; UNC attempt досяг180s timeout. Local attempt зупинено, старий launcher повернув порожній ExitCode — результат невалідний. Harness виправлено: ProcessStartInfo/WaitForExit/ExitCode, normal startup із quit-after, перехоплення modules. Game code не змінювали. Valid SteamMock990001 у Windows дав `/tmp` error; відомий R17, не замовчаний.

## Ручний checklist — усі пункти поки NOT RUN

- [ ] GUI startup: вікно з'являється, немає crash/error dialog; записати час і renderer з log.
- [ ] Меню: українські рядки, навігація, settings/back, елементи не обрізані.
- [ ] Нова гра: карта512,2 bots, розміщення столиці; світ, HUD, placement/cancel працюють.
- [ ] Камера/UX: zoom, RMB/middle pan, Esc, F11/Alt+Enter, scale;960×540 і1600×900, далі інші співвідношення.
- [ ] Графіка: terrain, borders, fog, strategic zoom, units/effects; без shader artifacts.
- [ ] Audio: music/SFX, mute/sliders, перемикання focus; headless цього не перевіряє.
- [ ] FPS: записати GPU/renderer/resolution/scale/map/seed/bots/game_time і FPS/frame-time; короткий CPU benchmark нижче не є FPS.
- [ ] Save/load: manual save в тестовий slot, змінити стан, повернутися в menu, load; перевірити country/money/map/units/time, потім restart/continue. Дані тільки test-user.
- [ ] Закрити гру й зберегти gui-result.json + stdout/stderr/engine logs; відрізняти runtime failures від відомих exit leaks.

Для звіту достатньо позначок PASS/FAIL для пунктів, resolution/renderer/FPS та log-файлів. Реальний Steam,2-peer lockstep/reconnect і updater failure tests — наступні окремі перевірки.
