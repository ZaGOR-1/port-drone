# Windows QA — кандидати, runtime і докази

Перший комплект звірено 2026-11-22. На baseline DOCS-02 editor і Windows template збіглися з [CI-піном](../tools/ci/godot-4.7.2.json). Історичні QA-артефакти перевіряй за маніфестом. Windows Downloads і старий `~/port-drone-worktrees-archive` нижче фіксують первісне розташування. Ці шляхи недоступні в середовищі DOCS-02B. Для відновлення шукай точний SHA256 в `~/projects/droneflames-archive/INDEX.md` і cold storage. Частина розпакованих файлів потребує відновлення з локального `droneflames-toolchain/.cold-storage`. Статуси прив’язані до конкретного EXE/PCK і сценарію. Гілки та пріоритети наведено в [PROJECT_STATE.md](PROJECT_STATE.md). Звичайну збірку з `beta` описано в [інструкції збірки](codex/verified/BUILD_RELEASE.md).

**Позначення.** IMPLEMENTED означає наявність коду у вказаному дереві. VERIFIED означає успішну перевірку в зазначеному обсязі. PARTIALLY VERIFIED означає, що частину заявленого обсягу перевірено. NOT TESTED або NOT RUN — перевірка не виконана. PLANNED — запланована робота. BLOCKED — конкретна перешкода. PASS і FAIL належать окремим сценаріям.

## Перевірений SFX-комплект

- Windows x64 `DroneFlames.exe` із Godot 4.7.2 MinGW patched, вбудованим PCK та SFX-лаунчером. SHA256 `81eb696921e9936a2b937376b744d656be2bddb7ef0bdafe8778780ea673c6a1`.
- Каталог QA-комплекту `DroneFlames-CONTEXT-QA-20261122.ZOI3rl` у Windows Downloads. Перевірити `SHA256SUMS.txt` і `BUILD_PROVENANCE.json`. Артефакти локальні та поза Git.
- Base commit `94aedbe36fc5d1abd4da100bed83f803fad53b2f`, candidate tree `bcc9a8fa32ae486c0b3b73a8f7e90c6269b96a76`, game tree `052d3b1047774012be4fbc551cfe36d995845ea8`. Патчі в `review/` застосовують у такому порядку: `R02.patch`, `UI.patch`, `INPUT-GAME.patch`, `FOLLOWUP.patch`, `CONTEXT.patch`. Усі п’ять контрольних сум звірено. Послідовне застосування в окремому Git-індексі відтворило обидва дерева.
- Початкові worktree: `port-drone-r02-recovery`, `port-drone-ui-qa`, `port-drone-input-qa`, `port-drone-input-followup`, `port-drone-context-qa` в одному батьківському каталозі; на момент аудиту вони містили незакомічені зміни. Для відтворення точного комплекту джерело — файли з перевіреними SHA256 `review/` з маніфесту, а не довільний стан worktree.
- Sidecar для діагностики `diagnostics/DroneFlames-sidecar.zip` містить прямий EXE з PCK, три DLL і PowerShell launchers. SHA256 прямого EXE відрізняється від SFX. На обох ПК використати однаковий тип комплекту й однакові хеші. [План двох ПК](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md)

## Перевірки

| Збірка | Результат | Доказ |
| --- | --- | --- |
| Суміщений MinGW PCK від 2026-11-22 | Keyboard 130/130; scale 26/26; UI 20/20; R02 standard 49/49; simulation 2476/2476 PASS. На попередньому PCK BUG-01 відтворено. | Локальні `evidence/windows-summary.json` і `evidence/pck-source.json` в каталозі кандидата. |
| Суміщений MinGW SFX від 2026-11-22 | Cold/warm self-test, версія дочірнього рушія і headless startup PASS. Шість файлів payload звірено у self-test, три DLL ідентичні sidecar. | Локальний `evidence/sfx-smoke.json`. |
| Окремий кандидат R02 MinGW | Windows matrix 24/24, R02 standard 49/49, shared checkpoint 44/44, explicit failure 49/49, negative snapshots 111/111, Godot 439/439, Save/Load/Continue 6/6 процесів PASS. | `~/port-drone-worktrees-archive/droneflames/droneflames-r02-evidence-20261122/`, файли `summary.json`, `target/`, `compat/`, `matrix/`. |
| Попередній INPUT SFX, SHA256 `5fcd17934a11170d53b1c4958e6f633680338415abb703f513ef1163413e4f22` | Користувач повідомив PASS для F1–F7, відсутності тестового удару, штатного TEL, кільця столиці, базової гри, Save/Continue і Steam. FAIL для контекстних цифр і wrap масштабу. | Ручний INPUT QA follow-up власника. Попередня папка Windows Downloads на момент цього аудиту недоступна. |
| Суміщений SFX, ручна перевірка власника | **USER-REPORTED PASS** для F1–F7, контекстних цифр F2, збереження й виклику груп після вибору армії, видалення тестового удару, TEL, масштабу, кільця столиці, попередніх UI fixes, Save/Continue й запуску Steam. | Звіт власника для SHA256 вище. |
| Повне приймання | Фізичний LAN, Steam між двома ПК і late-game FPS — **NOT RUN**. Окремих підтверджень fullscreen/DPI, зміни EN/UA, non-admin, SmartScreen та інших сценаріїв повної матриці немає. | [Двопірний план](codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md). Для цього кандидата власник окремо дозволив інтеграцію в `beta` з відкритими LAN і FPS. |

На початковому PCK без патча R02 release-runtime мав 4 зриви assertions і на Official, і на MinGW/MSVC patched. Окремий R02 виправляє помилковий успіх часткового restore. Кандидат очікує явної успішності застосування стану та фіксує turn перед callback. При невдачі очищає черги й виходить із частково відновленого матчу. Відновлення описано у [звіті R02](codex/verified/R02_RELEASE_RECOVERY.md). [Код Save](../game/game/save.gd)

## Керування в QA-кандидаті

`F1–F7` відкривають панелі. У F2 до столиці `1/2/3` — столиця, місто, ферма. Після столиці — місто, ферма, цивільний завод. Верхні цифри йдуть за видимими кнопками. Видима недоступна кнопка зберігає номер. `Ctrl+1–9` зберігає армійські групи, поза панеллю цифра викликає групу. Згорнути панель можна повторним кліком по вкладці. Модальний UI, текстовий фокус і підтвердження розміщення блокують контекстну дію. У `F8/F9/T` ігрових прив’язок немає. Масштаб обмежений між 70% та 130%. Таблиця всіх панелей є у [довіднику хоткеїв](codex/verified/WINDOWS_CONTEXT_HOTKEYS_QA.md). `Ctrl+1–9` без виділеної армії очищає слот групи.

## Godot MinGW

Локальний `df-godot472-operator-side-cache-v1`, Godot 4.7.2-stable від `ed1daf0bf001b61586d9930840f2f1394092c079`. Виправлено гонку GDScript operator cache, що спричиняла `0xC0000005`. MinGW template SHA256 `975407bd5bb15116928749ae233193d29e4578b1ec40bc1f3d92ee01a6cee141`. Шлях локального звіту `~/port-drone-worktrees-archive/droneflames/droneflames-mingw-parity-20261122/MINGW_RUNTIME_VALIDATION_20261122.md`. Нативні reproducer, startup та зіставлення семантики перевірені. Upstream-проблему і первинний MSVC контроль описано у локальному `GODOT_VM_RACE_FIX.md` у worktree `fix/godot-vm-race`. Офіційний шаблон залишається CI-піном, MinGW використано для локальних кандидатів.

Рання MSVC серія виявила +21,55% mean та +26,41% p99 тривалості тика проти Official. Same-toolchain MSVC patched проти original показав +0,02% mean. Ці вимірювання належать попередній серії.

Пізніший headless benchmark відновлено після Windows restart. Є 20 вимірювань, п’ять на кожен runtime. Зібрано `GetProcessTimes` user+kernel окремо від wall time. MinGW patched проти Official показав −7,68% mean і −7,63% median CPU процесу. Вибірки недостатньо для p95/p99 CPU процесу. Окремо виміряно wall time тиків `net_step()`, що не є FPS чи CPU time. Зіставлення залежить від цього checkpoint і хоста. Один Official прогін після перезапуску має інший прапорець restricted token. MinGW original з тим самим toolchain відсутній, тож окремий внесок патча не встановлено. Сирі зведення збережені в локальному `benchmark-evidence-qa-20261122T170450Z/summary.json`.

## QA-01 · Intermittent Wine startup

У первинному INT-08 smoke official Godot 4.7.2 під Wine зафіксував execute page fault за `0x0` на Wine thread `0x017c` після `WorldGen`. Стек і модуль відсутні. У QA-01 десять пар `0.36.6 → 0.36.7` пройшли з кодом 0. Три native Linux smoke на PCK 0.36.7 також пройшли. Повідомлення про CanvasItem, ObjectDB і ресурси на виході збереглися на обох версіях та Linux. DummyTexture і `mesh is null` у цій серії не відтворилися. Причину первинного збою та зв’язок із R15 або історичною native race не встановлено. Фізичний Windows GUI, LAN і Steam — NOT RUN.

Історичний комплект `QA01-evidence.tar.gz` містить журнали, команди й маніфести. Джерело секції — `ca713a4d3388eff8583924e13517996b35080544`. У разі повторення збою зняти стек і список модулів з точного EXE.

## Підготовка SFX

`tools/portable_sfx` відсутній у `beta`. Для цього EXE використано локальні інструменти з `~/port-drone-worktrees-archive/droneflames/droneflames-vm-fix-20261122/source/tools/portable_sfx/` від `e1e4355`. Звірити SHA256 файлів tooling у маніфесті. `prepare_custom_package.py` приймає прямий runtime package, перевірений MinGW template і engine manifest. `build_prototype.py` збирає SFX із перевіреного package. Payload витягується у versioned cache, профіль і логи ізольовані. Updater вимкнений, Steam за замовчуванням native з тестовим AppID 480. Для діагностики або ізоляції Steam використовувати sidecar і [tracked launchers](../tools/qa/).

### Відтворення MinGW template

У зовнішній копії upstream Godot на revision вище звірити SHA256 локального `godot-4.7.2-operator-side-cache.patch` `da9bb972456180ddcd4ff0dc7a49b54b7384749a8a9739a9e754a2cbdb995982`, перевірити `git apply --check` і застосувати патч. Використати MinGW GCC 13-posix (пакет `13.2.0-6ubuntu1+26.1`), headers `13.0.0-2ubuntu1`, GNU ld `2.45.90.20260125` і SCons `4.10.1`. Встановити ANGLE та AccessKit зі сторонніх артефактів, указаних в engine `BUILD_MANIFEST.json`; той самий manifest задає контрольні суми архівів і WinRT=false. Параметри з локального `build.sh`:

```bash
scons -j2 platform=windows target=template_release arch=x86_64 use_mingw=yes use_llvm=no \
  production=yes optimize=speed lto=none dev_build=no dev_mode=no debug_symbols=yes \
  separate_debug_symbols=yes debug_paths_relative=yes d3d12=no \
  "angle_libs=$ANGLE_DIR" "accesskit_sdk_path=$ACCESSKIT_DIR"
```

Для QA пакувати лише template після звірки SHA256. Вихідний Godot, бібліотеки toolchain і debug symbols зберігаються окремо. Процедура відтворює конфігурацію збірки. Побайтова відтворюваність нового EXE не встановлена.

## Перевірка інтеграційного дерева

Свіжий Windows MinGW PCK із production tip `e174cd0ce6d6804a8f0598d29bfa7b7008c1206f` побайтно збігся з PCK користувацького QA-комплекту. SHA256 PCK `bceade43c5f62bcecfeb60b0a79aaad0eb49a6b6fb7fa7af0711332fbd47650f`. Повторно упакований SFX для автоматичного smoke має окремий SHA256 `64ec476bab6cef7b3eb9bdaf7ddb8cbcb32f2c75fe90ad0a12666074263d5b7f`. Ручний звіт власника стосується попереднього SFX `81eb6969…`.

| Автоматичний тест | Свіжий результат |
| --- | --- |
| Контекстні хоткеї, відсутність debug strike і штатний TEL planner | 130/130 PASS |
| UI scale / UI-01/02/03 | 26/26 / 20/20 PASS |
| R02 standard / shared checkpoint / explicit signal | 49/49 / 44/44 / 49/49 PASS |
| Snapshot validation | 111/111 PASS |
| Simulation | 2476/2476 PASS |
| Save/Continue з normal та extra rendering | По 23/23 PASS. Однакові hash `c2dd7d57a6e0671f` і RNG `3352930908`. |
| SFX cold, warm, version, headless startup | 4/4 PASS, exit 0. Runtime і DLL у кеші звірено. |
| Python CI/artifact policy та release tooling | 10/10 і 15/15 PASS |

Санітизоване машинне зведення збережено поза Git як `evidence/integration-validation.json` у каталозі локального інтеграційного прогону. Перша спроба Save/Continue завершилась на захисній перевірці імені ізольованого профілю. Повтор використав потрібний префікс профілю й ті самі сценарії та assertions.
