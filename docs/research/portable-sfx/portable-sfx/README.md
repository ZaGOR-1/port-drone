# Portable DroneFlames SFX для Windows x64

> Історичний матеріал з `toolchain/portable-sfx/README.md`. [Реєстр досліджень](../../INDEX.md)

Локальний workflow на Ubuntu 26.04.1 LTS. Джерело — останній успішний patched package від `df-windows`. Кандидат `artifacts/ubuntu-20261123/` використовує гру `v0.36.0`, PROTO 7, SIM_REV `v036-integration-1`, Save Format 1. Вихідний worktree `/home/zagor/projects/port-drone`, `beta` на `c91e0e6a7eef831687e6e63550560bba739a6b87`. Історичний SFX `81eb6969…` використовував локальні `prepare_custom_package.py` і `build_prototype.py`. У доступному checkout та його Git-історії ці файли відсутні. Цей workflow реалізовано заново.

## Створення й оновлення

```bash
df_windows="$HOME/projects/droneflames-toolchain/windows-dev/df-windows"
sfx_root="$HOME/projects/droneflames-toolchain/portable-sfx"
"$df_windows" pack-sfx --out "$sfx_root/artifacts/qa-copy"
python3 "$sfx_root/package_sfx.py" verify "$sfx_root/artifacts/qa-copy"
(cd "$sfx_root/artifacts/qa-copy" && sha256sum -c SHA256SUMS.txt)
```

`--out` має вказувати на новий каталог. Без цього параметра створюється унікальний каталог під `artifacts/`. Після нового `df-windows build <ref> --template patched` повтори `pack-sfx`. Команда читає лише `latest-patched`; профіль official і прямі комплекти зберігаються окремо. Для відтворення старшої збірки можна передати її оригінальний `package/` команді `python3 package_sfx.py build /шлях/до/build/package --out /новий/каталог`. Поряд із `package/` потрібен оригінальний `build-verification.json`.

Пакувальник звіряє обидва вихідні маніфести, provenance зі звітом `df-windows`, усі вхідні хеші, PE-архітектуру, префікс patched template і межі та magic вбудованого PCK. Вихідні `BUILD_PROVENANCE.json` та `SHA256SUMS.txt` зберігають точний набір входів, інструменти, параметри й хеш результату. Для порівняння двох складань використовуй `cmp` для EXE. Побайтовий збіг двох складань із незмінного package на цьому toolchain перевірено. Побайтовий збіг після зміни toolchain або відтворення самого upstream package — NOT RUN.

Потрібні Python ≥ 3.12, GNU coreutils і `x86_64-w64-mingw32-gcc-posix` з Ubuntu. Для кандидата використано Python 3.14.4, пакети `gcc-mingw-w64-x86-64-posix` 13.2.0-6ubuntu1+26.1, `mingw-w64-x86-64-dev` 13.0.0-2ubuntu1 і `binutils-mingw-w64-x86-64` 2.45.90.20260125-1ubuntu1+13.3. Wine 10.0 використовувався для QA. На Windows потрібні лише звичайні системні бібліотеки й Windows x64. Перенось тільки `DroneFlames.exe`, а SHA256 звіряй із маніфестом. На Windows це можна зробити через `Get-FileHash .\DroneFlames.exe -Algorithm SHA256`.

## Формат і виконання

Малий GUI PE32+ лаунчер, за ним сирі байти чотирьох файлів у порядку `DroneFlames.exe`, `libgodotsteam.windows.template_release.x86_64.dll`, `libwebrtc_native.windows.template_release.x86_64.dll`, `steam_api64.dll`. Вбудована таблиця лаунчера містить фіксовані імена, розміри та SHA256. Початок payload обчислюється від кінця EXE за сумою розмірів. Формат без компресії та без імен чи шляхів із payload. Windows CNG обчислює SHA256. SHA256 допомагає виявити пошкоджені файли, а provenance слід отримувати з довіреної копії. Кандидат без Authenticode.

На старті лаунчер перевіряє payload і готує кеш `%LOCALAPPDATA%\DroneFlames-SFX\v1-<digest>`. Перший запуск потребує близько 207 МБ вільного місця, два одночасні перші запуски можуть коротко потребувати вдвічі більше. Файли створюються з `CREATE_NEW` у новій GUID-папці, а цілий каталог публікується атомарним перейменуванням без заміни. Коли інший екземпляр уже опублікував кеш, лаунчер перевіряє й використовує його. Кешовані компоненти перевіряються перед кожним запуском і відкриті для читання на час гри. Лаунчер відкидає reparse points у керованих шляхах і файли з кількома hard links. Якщо кеш пошкоджено, після закриття гри видали лише відповідний `v1-<digest>` та повтори запуск. Окремі GUID-каталоги можуть лишитися після аварійного переривання під час розпакування.

Лаунчер передає аргументи дочірній грі, встановлює робочий каталог на кеш, вимикає updater через `DF_NO_UPDATE=1` і чекає завершення гри. Код гри передається викликачеві. Помилка лаунчера повертає 125. `--sfx-verify` перевіряє та готує кеш без запуску гри, з кодом 0 за успіху. Save/Settings використовують звичайний `user://` цього Wine-prefix або Windows-профілю, поза кешем. Два запущені екземпляри мають спільний профіль гри, як і прямий EXE. Одночасний запис одного save slot окремо не перевірявся.

## Ручна перевірка

Wine GUI нового кандидата — NOT RUN. Запусти один EXE з папки з пробілами у виділеному Wine-prefix, створи save, зміни налаштування, закрий вікно через хрестик і після повторного запуску перевір Continue та налаштування. Для повторення локального оточення передай `DF_STEAM_MOCK=0`. Локально за цього режиму зафіксовано `[Steam] init failed (1): mock: bad id`. Повідомлення Godot про незвільнені ресурси при виході через хрестик відоме зі звіту користувача про попередній Wine GUI. GUI-спостереження не повторювали для нового SFX. Без `DF_STEAM_MOCK` гра ініціалізує штатний Steam API з тестовим AppID 480.

Native Windows QA — NOT RUN. На реальному Windows x64 перевір запуск без admin і сусідніх файлів, чистий та повторний запуск, SmartScreen, GUI/DPI/fullscreen, Save/Continue, два екземпляри, Steam і фізичний LAN на двох ПК з однаковим SFX SHA256, reconnect/resync і late-game FPS. Для двох peers використовуй однаковий SFX або однаковий прямий комплект з `windows-dev/builds/<build>/package/`. Headless у Wine підтверджує запуск і пакування в межах прогнаних сценаріїв. Кандидат залишається локальним QA-артефактом.

## Відновлення

Скопіюй на зовнішнє сховище весь каталог `backups/20261123-EoyiC0/`, включно з основним архівом, доповненням SFX, `RESTORE.md`, `RESTORE-SFX.md` і `SHA256SUMS.txt`. Порядок розпакування описано в цих інструкціях.
