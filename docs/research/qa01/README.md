# QA-01 · Native page fault після INT-08

> Історичний матеріал з `toolchain/qa01.BF2QJ4IH/README.md`. [Реєстр досліджень](../INDEX.md)

**NOT_REPRODUCED.** Збережено оригінальний intermittent crash. Десять чергованих пар Wine дали 10/10 PASS на 0.36.6 і 10/10 PASS на 0.36.7. Ознак причинного зв’язку з R15 у цій серії немає. Рідкісний збій і його можливий зв’язок із R15 залишаються відкритими.

## Первинний збій

| Поле | Доказ |
| --- | --- |
| Версія і SHA | `0.36.7`, `d6a38e8db58361430df69ffe0a98e628acac6d8b` |
| ZIP SHA256 | `3141a26f32a332b27e647ee661d2064e97b9dece5ebf145619c76cb0a324b799` |
| EXE SHA256 | `67b2841566dd2a368578e59cb9a4ea7dbb0b8694b4911eeeca1adfe7490a796d` |
| Embedded PCK SHA256 | `c984f1dafdee622da6d206b9427003571244f78e4d8c99a74fc365ac3a6dafb6` |
| Godot | `4.7.2.stable.official.ed1daf0bf`, official Windows x64. Template SHA256 `d34d36f3be1a6c49c56525ae86469b92e4f417ddf0b43cf00dd80c385c4b0562`. A і B використовують той самий template і побайтово однакові три DLL. |
| Wine | QA-01 зафіксував `wine-10.0 (Ubuntu 10.0~repack-12ubuntu1)`. Журнал пакетів показує цю версію встановленою ще до INT-08, без наступного оновлення. Рядок версії у первинному логу відсутній. |
| Команда | `timeout 120 wine ./DroneFlames.exe --headless --quit-after 240` після `timeout 120 wineboot -u`. Новий win64 prefix, `WINEDEBUG=-all`, default debugger, `DF_NO_UPDATE=1 DF_NO_OPENING=1 DF_STEAM_MOCK=0 DF_LANG=ru`. |
| Exit | Обгортка `timeout` повернула **124** під час очікування debugger. Код виходу самого EXE не отримано. |
| Fault | Виконання за `0x0000000000000000`, instruction address теж `0x0000000000000000`. Wine thread `0x017c`. Роль потоку, faulting module і стек невідомі. Журнал обривається на запуску debugger. У первинному prefix та локальному каталозі apport відповідного dump не знайдено. |
| Фаза | Startup фонового світу меню після `[WorldGen]` з картою 512×512, seed `23391791`, sea 68. Немає маркера завершення startup або ознак shutdown. Останні рядки містять завантаження atlas, локаль `ru`, `[WorldGen2]`, `[WorldGen]` і page fault. |
| Ресурси | У первинному журналі відсутні повідомлення про помилки завантаження ресурсів або GDExtension, `SCRIPT ERROR`, DummyTexture, `mesh is null` і teardown. `mock: bad id` виходить зі Steam mock для ID 0 і спостерігається в успішних запусках. |

`WorldGen` друкує рядок до повернення карти. Далі `new_world` готує terrain та інші системи. `ArmyFire._spot` викликається через simulation step → `Army.update` → `fire.update`, а її каденція допускає виклик уже на першому simulation step. Між останнім рядком і збоєм немає трасування тика або `_spot`. Тому невідомо, чи виклик відбувся, і чи дійшов він до зміненого наземного скану. Зв’язок із відомою гонкою Godot також невстановлений.

Оригінальний журнал (`original/archive-wine-smoke.log`) · Команда INT-08 (`original/INT08-post-verify.sh`) · Атрибуція збою (`manifests/original-attribution.txt`) · Binary identity (`manifests/binary-identity.json`)

## Контроль

Wine на одному хості Ubuntu 26.04.1 LTS, однаковий win64 runtime, headless/Dummy, 120 с timeout, 240 ітерацій, окремий новий prefix для кожного запуску. Порядок A→B повторено 10 разів. Packaging і важкі benchmarks не запускалися. QA-01 виконав smoke послідовно. Початковий скрипт INT-08 запускав Linux smoke окремим паралельним процесом. Готові пакети випадково вибирають seed фонового меню через `randi()`. Підтримуваного параметра запуску для фіксації цього seed немає. Фактичні seeds записані для всіх запусків, первинний `23391791` у серії не випав.

Усі 20 результатів із кодами виходу й seeds (`results.tsv`) · Журнали та команди (`logs/`) · Wine і хост (`manifests/wine-host.txt`) · Версії й DLL (`manifests/runtime-parity.txt`)

Три native Linux smoke з 0.36.7 пройшли з кодом 0, тим самим PCK, аргументами й сценарієм меню. Порівняння перевіряє цей сценарій поза Wine. Фізичні Windows GUI/FPS, LAN і Steam — NOT RUN. Linux results (`linux-results.tsv`)

У всіх 23 прогонах були ті самі teardown повідомлення: 14 CanvasItem RID, 232 ObjectDB instances і 44 ресурси. DummyTexture та `mesh is null` у серії не відтворилися, обидва лишаються відкритими. Фіксацій помилок завантаження або script error не було. Зведення попереджень (`warnings.tsv`)

## Відтворення й наступний крок

`bash /home/zagor/projects/droneflames-toolchain/qa01.BF2QJ4IH/reproduce.sh` перевіряє наявні архіви та повторює обмежену матрицю в новому каталозі toolchain з окремими префіксами. Команди кожного фактичного запуску збережено в `logs/*/command.txt`. Якщо fault повториться, вузький наступний крок — зняти WineDbg backtrace або minidump з точного EXE та зафіксувати faulting thread, список модулів і фазу startup. Діагностичний прогін під debugger у QA-01 — NOT RUN, оскільки серія не дала нового fault для трасування.

R16 можна планувати як окреме завдання. QA-01 залишає відкритими рідкісний startup crash і фізичний Windows QA. Повний regression suite та R16 profiling — NOT RUN.

## Git і докази

Основний checkout чистий на beta `d6a38e8db58361430df69ffe0a98e628acac6d8b`. Main `172df65e3bd004efed9a5444e90a284d9d69db10`, stash `40a9f64` та історичні worktrees збережено. Хеші diff і незакомічених файлів R13 збігаються. Запис у PROJECT_STATE та Windows QA зроблено локальним docs-комітом `ca713a4` у гілці `docs/qa01-native-crash`. Для архіву handoff включено журнали, manifests та скрипти. Створені для серії Wine prefixes видалено після завершення запусків. Git verification (`manifests/git-verification.txt`) · SHA256 (`SHA256SUMS.txt`)
