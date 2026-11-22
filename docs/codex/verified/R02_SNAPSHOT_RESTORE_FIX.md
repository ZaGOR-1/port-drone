> Архівні докази зазначено як шляхи до файлів. [Розташування архівів](../../DOCUMENTATION_AUDIT.md#архівні-посилання).

# R02 — Network Snapshot Restore Stabilization

2026-11-20. Локальний набір Phase 5B.1 поверх незакоміченого Phase 5; не merge і не новий реліз. Рішення та фактичні результати: [тести](R02_FAILURE_INJECTION_TESTS.md), [checkpoint](PHASE5B_PROGRESS.md).

## Root cause і перевірені шляхи

Старий `NetSession._restore_from` чекав `Save.net_restore`, але ігнорував false: далі присвоював turn/tick, збільшував resyncs, знімав restoring/rejoining і повідомляв «ВЫ СНОВА В ПАРТИИ». `_resume_restore` також продовжував host/resume/go без перевірки результату. Другий рівень проблеми: GDScript runtime error у вкладеній void-функції load/finish/UI не гарантує false у зовнішньому async-loader. Перевірки лише return value були недостатні.

Переглянуто: disconnect → `_start_reconnect` → saved seat/host checkpoint → `_resume_restore`; `_snap_begin`/`_snap_part`/`_apply_snapshot`; host `_send_snapshot` → локальний `_restore_from`; newest queued snapshot; Save wrapper/decompression/Variant/refs → `_load_pack` → new_world → core → systems → finish → local player/fog/cache/UI → lockstep resume. `Save._load_slot` уже враховує bool, але глибокі disk-load failure не сертифіковані цим мережевим fix. Інші fire-and-forget `_restore_from` call sites не мають окремих success-продовжень: success/failure тепер обробляє сам метод.

Карта: [редагований draw.io](r02-snapshot-restore-lifecycle.drawio), перегляд (`port-drone.tar.gz` → `dist/phase5b1_r02_20261120-170307/r02-snapshot-restore-lifecycle.drawio.png`).

## Межа успіху і failure policy

Успіх дозволений тільки після валідного контейнера/структурних даних, завершення core/systems/finish без зафіксованих engine/script errors, перевірки актуальної session epoch і наявності local country, відновлення fog та `Main.net_after_restore` без errors. Останній hook очищає також authoritative strike/FrontPlan caches — це необхідний етап, а не лише косметичний UI. Лише потім фіксуються `net_tick=(n+1)*TICKS_PER_TURN`, exec_turn/tick, resyncs і success toast/go. Відсутній callback у тестовому мінімальному Main допускається, production Main його має.

Вхідна перевірка без mutation: bounded wrapper/decompression (чинна межа 1 GiB), exact Variant length, FORMAT=integer 1, core/sys arrays та розміри, whitelist entity classes, базові references і finite clock. Це не повна схема кожного вкладеного поля і не захист від усіх memory exhaustion випадків. Індекс chunk перевіряється до арифметики; turn обмежено до безпечного обчислення net_tick, без переповнення int64.

Save.RestoreErrors — тимчасовий потокобезпечний Logger: спостерігає errors лише під час restore, не пригнічує stderr. Guard після await/stages зупиняє продовження за помилки або зміни epoch. Окремий observer охоплює fog/Main cleanup до commit. Незалежний сторонній error у цей короткий інтервал може консервативно завершити restore; краще fail closed, ніж активувати частковий світ.

Повної транзакційності об'єктного GameWorld тут немає. Якщо mutation вже почалася, rollback цього дерева без архітектурного переписування ненадійний. Обрана дозволена безпечна альтернатива: заморозити старий world, завершити локальну сесію через existing `leave(true,true,true,true)`, відкинути lockstep queues/flags, зберегти saved seat/host checkpoint, показати помилку і побудувати свіжий menu world. Processing повертається тільки після завершення Main menu cleanup. Користувач може явно повторити join; автоматичний нескінченний retry не додавався. Значення sampled старого world після preflight rejection не змінюються; після часткового load вони можуть бути змінені, але більше не використовуються як активний матч.

## Асинхронність, повтори і ownership

Session epoch інвалідовується reset/leave і reconnect під час активного restore. Старий coroutine не може commit у нову/закриту сесію. Host promotion під час часткового restore відхиляється із завершенням локальної сесії: неповний світ не стає host authoritative state. Некоректний saved resume metadata завершує сесію до typed-call error/default turn. Один restore виконується одночасно; з черги зберігається лише новіший snapshot. Завершені дублікати/застарілі turn і пізні packets після leave ігноруються; повторний begin не стирає вже отримані chunks; суперечливі duplicates відхиляються.

Timeout 180 s кооперативний: обробляє зависання з поверненням у event loop; не перериває синхронний native hang, crash або OOM. Власник/OKREDU мають переглянути policy «завершити local session і явно повторити join»; нової gameplay-механіки немає.

## Точний production scope

- [save.gd](../../../game/game/save.gd): RestoreErrors, net preflight, guard для `_load_pack`; encoder/disk FORMAT1 не змінений.
- [net_session.gd](../../../game/net/net_session.gd): checked completion/epoch, metadata/chunks, failure policy, queue/idempotency/timeout, resume/reconnect/promotion.
- [main.gd](../../../game/game/main.gd): process відновлюється після побудови menu world при net_match_closed.

10 попередніх Phase 5 production fixes збережено; net_session має обидва логічні набори. Окремий incremental patch у checkpoint дозволяє розглядати тільки R02. Немає змін native DLL, protocol 7, FORMAT1, SIM_REV, RNG алгоритму, NetHash або звичайного simulation hot path.

## Admission і межі сумісності

`SIM_REV=pr10-critical-1` входить у production version identity; реальний loopback ENet handshake відхиляє original PR10 без suffix. Однак Phase5 candidate і R02 candidate мають однаковий SIM_REV і допускають з'єднання, хоча байти різні. Це НЕ content hash, не доказ mixed-build lockstep/resync сумісності. Для приймальних матчів потрібна одна точна збірка на обох peers. Подальше автоматичне content identity/version policy — окрема задача; wire протокол тут не розширювався.

Реальний двопроцесний handshake перевірено, повний двопроцесний command stream/reconnect/resync/host rotation та Steam/Windows LAN — NOT RUN. Windows GUI — NOT RUN. R02 можна передати на наступний етап; готовність beta цим не оголошується.
