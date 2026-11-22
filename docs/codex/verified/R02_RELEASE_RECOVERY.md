# R02 — відновлення snapshot у Godot 4.7.2 release

Кандидат `fix/r02-release-recovery` від `e1e435511e715b3c1216c7f5128090af69818217`. Для Windows використано MinGW patched template SHA256 `975407bd5bb15116928749ae233193d29e4578b1ec40bc1f3d92ee01a6cee141`. Ідентичність `v0.36.0 / PROTO 7 / SIM_REV v036-integration-1 / Save.FORMAT 1`.

## Першопричина

`Save.net_restore()` і `Save._load_pack()` спиралися на logger, щоб помітити помилку всередині `void`-виклику `Main._on_zoom()`. Після заміни core і systems loader вмикав processing, викликав `_on_zoom()` й далі повертав `true`. У GDScript VM 4.7.2 для цього dynamic call перевірка `Callable::CallError` і його діагностика містяться під `DEBUG_ENABLED`. MinGW release probe повторно дав `invalid_call_delivered=false`, `resumed_after_invalid_call=true` й `explicit_error_delivered=true`. У такому режимі відсутність запису logger дозволяла `NetSession._restore_from()` підтвердити частково відновлений стан. Також сам callback `net_after_restore()` виконувався до останньої перевірки logger і до фіксації turn/tick.

**Checkpoint → валідація FORMAT 1 → відновлення замороженого світу → commit turn/tick і processing → callback готової сесії.** [Схема draw.io](r02-release-restore-flow.drawio)

## Реалізація

- `save.gd` залишає preflight до мутації, заморожує світ перед першим `await` і вимагає результату від core, systems і фіналізації. Перевіряє створення сутностей, відновлення player/RNG, доступність залежностей і діапазон sprite index перед використанням. На будь-якому виході зі спроби звільняє таблицю декодування та logger. Guard також відхиляє паралельну спробу використати спільний декодер. Дисковий loader вмикає processing лише після успішної фіналізації.
- `main_core.gd` повертає явний результат оновлення zoom і перевіряє ShaderMaterial та вузли перед застосуванням. `vision.gd` повертає результат повторної прив'язки fog і перевіряє узгодженість його масивів. `main.gd` відокремлює підготовку UI й очищення кешів від callback після commit та відновлює меню, якщо воно було прикрите loading screen.
- `net_session.gd` вимагає валідного local player, успішних fog і Main preparation та актуального epoch до commit. У разі відмови штатний `leave()` закриває сесію, очищає lockstep, callbacks і черги resync/resume та зберігає checkpoint і seat для явної повторної спроби. Свіжий menu world перебудовується зі штатним очищенням world jobs.
- Інтеграційний тест прибирає ShaderMaterial після застосування core і systems, на межі фіналізації. Збережено всі попередні умови recovery й додано перевірки фази ін’єкції, очищення тимчасового стану та commit до callback. `--fault=signal` виконує ті самі перевірки з явним `push_error`. Окремий незмінний VM probe характеризує довільний dynamic call.

Preflight відсіює пошкоджені обгортки, несумісний формат і некоректні посилання до мутації. Відсутні обов’язкові об’єкти, відхилений етап або спостережена помилка під час застосування ведуть до recovery. Epoch і timeout блокують запізніле завершення зі старої сесії. Restore оновлює поточний світ під замороженням. Після відмови безпечний стан відновлюється перебудовою меню. Logger залишається додатковою діагностикою. Охоплення довільних тихих помилок VM і повної схеми всіх вкладених систем виходить за межі цих перевірок.

Формат snapshot, формат дискового save, команди, протокол і детермінований порядок симуляції збережено. Внутрішній контракт `Save.net_restore()` тепер завершується підготовленим замороженим світом. Активація належить виклику `NetSession`.

## Перевірка

| Тест | До | Після | Статус | Доказ |
|---|---:|---:|---|---|
| R02 standard | 43/47 | 49/49 | PASS | `target/df_snapshot_test_integration.json` |
| R02 shared checkpoint | 38/42 | 44/44 | PASS | `target/df_snapshot_test_shared_checkpoint.json` |
| Явний сигнал помилки | 46/46 | 49/49 | PASS | `target/df_snapshot_test_explicit_signal.json` |
| Негативна матриця snapshot | 111/111 | 111/111 | PASS | `target/df_snapshot_test_failure-matrix.json` |
| Save/Load/Continue | 6/6 | 6/6 | PASS | `compat/matrix-results.json` |
| Simulation regression | 2476/2476 | 2476/2476 | PASS | `matrix/performance-regression.json` |
| Godot suite | 439/439 | 439/439 | PASS | `matrix/godot-suite.json` |
| Windows MinGW regression matrix | 23/24 | 24/24 | PASS | `target/`, `compat/` і `matrix/` у `summary.json` |
| Terrain | 36/36 | 36/36 | PASS | 12 MinGW-кейсів × 3 повтори. Hash стану й RGBA збігаються з попередніми MinGW-результатами |
| Operator semantics | 2 × 476 | 2 × 476 | PASS | `controls/mingw-semantics-*.json` |
| Windows export / headless startup | PASS | PASS | PASS | `export-local-verification.json`, `controls/matrix-results.json` |

Перед змінами використано наявні Windows RED та короткий MinGW probe. Після змін спочатку перевірено R02 у Linux Godot editor і нативному Windows MinGW release, потім сумісність і решту 24-кейсової матриці. Counts R02 включають додані assertions. Невдалий timeout меню в старих прогонах додавав assertion лише при відмові. 13 пошкоджених вхідних snapshots у реальному decoder, FORMAT 1 із пропущеними optional fields, retry і повторне відновлення пройшли. Успішний callback бачить уже зафіксований turn і виконується один раз.

Спільний checkpoint відтворив базові restored hash `1924bb2d9103eeb7`, replay hash `63dfdbfa07f72c70` і RNG `3352930908`. У шести Save/Load/Continue процесах із двома render schedules збіглися hash `c2dd7d57a6e0671f` і RNG `3352930908`. Terrain та operator semantics використовували початкові самостійні fixtures. Для шести файлів terrain перевірено побайтовий збіг із кодом кандидата. Linux release tooling unittest пройшов 15/15. Ізольовані snapshots використовувалися без доступу до реальних saves або production sessions.

Компактні докази доступні у `~/projects/droneflames-r02-evidence-20261122/`. SHA256 перевіреного Windows EXE `aaad34f5f5c2f9699d9169e403d7c13a599e87f8160b05b0f6b54f759d166f35`. Updater вимкнено. У headless smoke використано Steam mock. Перевірку packaged identity повторено з локальної копії EXE після тайм-ауту через змонтований Windows-шлях. Перевірка не потребувала зміни пакета.

## Вердикт

**READY FOR WINDOWS GUI QA.** Нативні R02, повна матриця й headless запуск перевіреного EXE пройшли. Windows GUI, Steam/LAN між незалежними комп’ютерами і late-game FPS мають статус **NOT RUN**. Потрібні ручна GUI-сесія, доступний клієнт Steam та окремі фізичні peers для відповідних сценаріїв. Поточний кандидат призначено для QA з однаковими EXE/DLL на обох peers.
