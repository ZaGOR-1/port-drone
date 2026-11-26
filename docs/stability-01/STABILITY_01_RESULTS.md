# STABILITY-01 · Надійність збережень і життєвий цикл

Baseline `f15224268ae6f4be06b5372ff5b7c99d5635793b`, 0.36.11. Локальна й серверна `beta` збіглися після PR #26. Усі R30–R33 у дереві, `game/` ідентичний `acd9760`. Це дослідження. Фікстури використовують незмінений PCK в ізольованих профілях Linux, Godot 4.7.2 `ed1daf0bf`. [R30–R33](../research/INDEX.md#після-archive-01) · [Політика збереження](../DEVELOPMENT_WORKFLOW.md#постійне-збереження-доказів)

Severity і порядок роботи: **P1** — втрата придатного checkpoint або блокування штатного продовження, **P2** — підтверджений збій з доступним відновленням файлів або утримання ресурсів без виміряного збою сесії. P1 визначено за наслідками відтворених умов.

## Підтверджені дефекти

### ST01-01 · Невдале збереження хоста знищує або блокує checkpoint · P1

- **Відтворення запису.** Створити придатний штатний формат матчу, turn 10. На Linux обмежити розмір файла процесу до 32 768 байтів і повторити `NetConfig.save_match()` для turn 11 зі штатним snapshot. Попередній `net_match.save` мав 186 356 байтів і читався. Після спроби за його шляхом лишився файл 32 768 байтів, `load_match()` повернув порожній результат, tmp зник.
- **Відтворення retry.** На ізольованому хості зробити `net_match.save.tmp` каталогом. `NetSession.save_match(10)` не пише checkpoint, але фіксує `_saved_turn=10`. Після зняття блокера той самий turn пропущено. Turn 11 зберігається на тому самому сховищі.
- **Причина та вплив.** `NetConfig.save_match` записує tmp без перевірки flush/get_error та придатності, видаляє старий файл і ігнорує результат rename. `NetSession.save_match` позначає turn та логує успіх без сигналу від сховища. При виході хоста `host_exit_saved` покладається на цей виклик перед повідомленням гостям. Втрата локального checkpoint підтверджена, доставка повідомлення та поведінка віддалених peers у цьому fault — NOT RUN. [NetConfig](../../game/net/net_config.gd) · [NetSession](../../game/net/net_session.gd)
- **Мінімальний fix і приймання.** Повернути результат commit з `NetConfig`, перевіряти запис і зберігати читабельну попередню копію при відмові до безпечної заміни. Просувати `_saved_turn` і повідомляти про збереження після підтвердженого commit. Перевірити fault під час open/write/rename, повтор того самого turn, читання останнього придатного checkpoint після перезапуску та успішний host resume з тією самою версією. На фізичному Windows окремо перевірити поведінку заміни файла й повідомлення host/guest.

### ST01-02 · Continue приховує придатні копії SP · P1

- **Відтворення.** Взяти байти справжнього штатного FORMAT1 save і залишити їх лише в `slot_1.save.tmp`, що моделює дисковий стан між підготовкою й публікацією. `Save._read` читає копію. `Save.has_save` і `Save.load_game` повертають false, статус слота `empty`. Другий fixture зробив `main` трьохбайтовим, лишив придатний `bak` і прибрав metadata для її перебудови. Статус `bad` так само сховав Continue. Прямий `Save.load_slot(main, 1)` в обох випадках відновив `game_time=42.0`.
- **Причина та вплив.** `SaveSlots.FILES` і signature/discovery оминають tmp, хоча `load_order` додає його наприкінці. При відбудові індексу `rows` ховає `bak`, якщо є інші записи, навіть коли всі вони `broken`. `continue_slot` відкидає обидва слоти ще до читання. Доступ до цілої копії губиться у штатному Continue. Це змодельована межа запису, фізичний power-loss — NOT RUN. [SaveSlots](../../game/game/save_slots.gd) · [Save](../../game/game/save.gd)
- **Мінімальний fix і приймання.** Узгодити discovery та порядок reader для валідних fallback-файлів, з нормальним пріоритетом придатної основної копії. Для tmp-only Continue має показати й відновити той самий save; обрізаний tmp має бути відхилений. За пошкодженого primary й перебудови metadata Continue відновлює придатний `bak`. Existing main має зберегти пріоритет і метадані.

### ST01-03 · Legacy migration повідомляє успіх без commit · P2

- **Відтворення.** Перенести справжній FORMAT1 save у `user://match.save`. Зайняти призначення `slot_1.save` непорожнім каталогом. `SaveSlots.migrate` перевірив tmp, перейменував оригінал у `match.save.pre332` і повідомив `migrated`. Continue лишився недоступним. SHA256 архівованого оригіналу збігся, tmp читається.
- **Причина та вплив.** `migrate` ігнорує помилку фінального rename й продовжує запис metadata та архівування legacy. Оригінал збережено за запасною назвою, штатний шлях міграції й Continue його вже не знаходять. [SaveSlots](../../game/game/save_slots.gd)
- **Мінімальний fix і приймання.** Перевірити commit і повторно відкрити destination перед архівуванням. За відмови оригінал і його назва лишаються, статус повідомляє помилку. Повтор після усунення блокера успішно відновлює той самий стан, повторна міграція є ідемпотентною.

### ST01-04 · Старі Army утримуються після заміни світу · P2

- **Відтворення.** Три виклики штатного `Main._main_menu` на тому самому World із завершенням loading transition. Слабкі посилання на три попередні Army залишилися живими. Після обнулення трьох backlinks лише в уже від'єднаних об'єктах живих старих Army стало 0. Це причинний контроль fixture.
- **Причина та вплив.** `GameWorld.new_world` замінює `army`. RefCounted `Army` володіє `tac`, `fire`, `reinf`, а кожен helper тримає сильне посилання назад. Об'єкти й доступні їм графи можуть лишатися після нового світу. Точний внесок у RSS, решту ObjectDB/RID diagnostics або безперервний late-game не встановлено. [GameWorld](../../game/game/game_world.gd) · [Army](../../game/game/army.gd) · [ArmyTac](../../game/game/army_tac.gd) · [ArmyFire](../../game/game/army_fire.gd) · [ArmyReinf](../../game/game/army_reinf.gd)
- **Мінімальний fix і приймання.** Звільняти доведені backlinks на межах replacement і teardown після завершення роботи старої системи або зробити їх слабкими з явним ownership. Після серії new game, Continue, reconnect/restore та exit слабкі посилання на старі Army й helpers мають звільнитись. Активний Army і чинна симуляція, RNG та NetHash зберігають поведінку. Відтиск пам’яті та leave/restart перевірити окремо у фізичному Windows.

## Ризики, успадковані докази та статус

- **Multiplayer live.** Перевірено source-шляхи disconnect → reconnect/timeout, slot rejoin, snapshot chunks, epoch і commit; R02 уже покрив власну матрицю помилок restore. `_turn` переприсвоює буфер на повторному індексі, проте реальної доставки суперечливих або запізнілих turns від штатного authority тут не встановлено. Duplicate/out-of-order RPC, timeout із disconnect під час restore, фізичні LAN/Steam reconnect/resync — **NOT RUN**, дефекти desync не підтверджено. [R02](../codex/verified/R02_RELEASE_RECOVERY.md) · [План двох ПК](../codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md) · [NetSession](../../game/net/net_session.gd)
- **Runtime та довгі сесії.** R23 має 4800-тіковий локальний D2100 із ресурсами, RSS і hash на виміряних межах; він лишається історичним доказом власного сценарію. Виявлений цикл стосується замін світу, а не деградації всередині одного безперервного матчу. Новий long-run, physical Windows crashes/freezes і атрибуція решти teardown-попереджень — **NOT RUN**. QA-01 intermittent Wine startup і R08 DummyTexture залишено у відповідних scopes. [R23](../r23/R23_RESULTS.md#довготривала-стабільність) · [QA-01](../WINDOWS_QA.md#qa-01--intermittent-wine-startup) · [R08](../r08/R08_RESULTS.md#детермінізм-та-qa)
- **Неповний запис, сумісність і відсутні ресурси.** Дискові faults ST01-01–03 підтверджені у своїх умовах. Autosave rotation (включно з fresh), metadata concurrency, power-loss durability, додаткові старі FORMAT1 fixtures і відсутні production assets — **NOT RUN**. Headless editor показав відсутні debug-варіанти addons та teardown warnings. Пакетне приймання Windows цим не покрите. [Save Format](../codex/verified/SAVE_FORMAT.md#write-background-і-транзакційність) · [Windows QA](../WINDOWS_QA.md)
- **PASS** — preflight, точна версія `0.36.11`, PCK зі штатного дерева, 7 цільових запусків, 38 assertions для зафіксованих спостережень. **FAIL** — перелічені продуктні очікування на baseline. Вихід fixture 0 означає, що спостереження відтворено. Повний regression suite й нові performance benchmarks — **NOT RUN**.

## Shortlist і наступна задача

1. **FIX-STABILITY-01** — commit і retry збереження хоста. Найвища ціна відмови, бо збережений MP checkpoint може бути замінено непридатним.
2. **FIX-STABILITY-02** — discovery придатних SP fallback у Continue.
3. **FIX-STABILITY-03** — перевірений commit legacy migration.
4. **FIX-STABILITY-04** — lifetime Army під час заміни світу й teardown.

Наступна задача — FIX-STABILITY-01. Вузький patch у `NetConfig.save_match` і `NetSession.save_match` з відтвореним `RLIMIT_FSIZE` і same-turn retry. Перед інтеграцією потрібен контрольований fault test та host resume на точному Windows комплекті.

## Відтворення

Постійний архів `~/projects/droneflames-archive/STABILITY-01/`. Маніфест має 40 записів, SHA256 `5b8b02816cdb38fb9fee0da67175be2d7eb04751a4b8b5e07f0659b4d21c784e`. Точний PCK має SHA256 `6a6ba98baa85c72d5bb1b5d22c2b54f7e39faf41a87330f9b10aad884f4bcb92`. PCK запаковано з `git archive` від точного baseline, без runtime-патчів. Bash runner створює нові ізольовані профілі. `RLIMIT_FSIZE=32768` застосовується тільки до процесу fixture запису. Fixtures створюють власні saves із seed 159331 й працюють без з’єднань з мережевими endpoints. У raw лишилися початкова спроба з `/dev/full` (відмова вже на open, тож не доказ short write) і lifetime-спроба з перевіркою до завершення fade. Підсумок використовує обмеження розміру файла і контроль завершеного fade. Точні PCK, копії синтетичних файлів до й після відмов, сценарії та логи включено в маніфест.

```bash
archive="$HOME/projects/droneflames-archive/STABILITY-01"
(cd "$archive" && sha256sum -c SHA256SUMS && python3 summarize.py | cmp summary.json -)
"$archive/reproduce.sh" /path/to/stability-01-checkout
```
