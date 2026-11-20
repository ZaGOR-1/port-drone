# Phase 5B.2 — робочий checkpoint

2026-11-20. **READY FOR NEXT STAGE** у локальному scope; beta integration ще не готова. Початковий checkpoint: codex/fix-pr10-critical, HEAD96053d66eb984cc24e3acce647a55a195136abd2, існуючі Phase5/R02 uncommitted зміни збережені. Pre-edit backup: `/home/zagor/projects/port-drone-pr10-critical/dist/phase5b2_20261120-181631/backup/`;60 files, повний tracked.patch, inventory SHA256, heads/status/worktrees. Backup реально розпаковано у тимчасову ізольовану теку і всі60 SHA256 збіглися. Попередні backups не перезаписані. main/beta/OKREDU refs зафіксовані для фінальної звірки. Початкова Phase5B.1 точна збірка b52be533b369a18c57d70e869567da06f984a2ca8974638a696179aeeb2e8388. Усі нові артефакти — лише всередині поточного worktree.


## FIX-05 — Airport dispatch

PA05 стосується кнопки **будівництва airport**, а не нової команди відправлення рейсу. Hud.PAGE_DEFS/BUILD_KIND_OF/keys мають airport; Main.BUILD_KEYS/BUILD_KIND і map placement уже підтримували AIRPORT, але Main._on_action match-list пропускав airport. Signal був підключений. Мінімальний fix — один ключ у dispatcher. Actual Button.pressed → Hud.action → Main handler → _tap → NetSession.call_sim/issue/NetCodec → _exec → Military.build → owner/cost/UI перевірено в SP/MP component scope. Foreign issuer/airport ownership та invalid position перевірено. Network argument hardening описано нижче після остаточної перевірки. FIX05.patch зберігає незалежний delta.

## FIX-06 — Territory cooldown persistence

LandTrade._last_deal — вкладений RefCounted object, не Save ENTITY/World system; generic dump пропускає його, Diplomacy.save_state/load_state не переносили таблицю. Після new_world історія губилася, а direct repeated load_state міг залишити чужу стару історію. Виправлення: optional `sys.diplo.land_cooldowns: Dictionary[String, float|int]`, directional key `from:to`, значення — timestamp успішної угоди в `gw.game_time`; load копіює таблицю, відсутнє поле дає новий порожній Dictionary. Wall-clock/RNG/simulation ordering не змінюються. NetHash включає canonical sorted keys/timestamps; empty history не додає bytes до старого hash stream.

Shared Save._sound перевіряє optional field до disk/network mutation: Dictionary, canonical positive country IDs1..255, різні учасники, finite/nonnegative timestamp <= saved simulation clock. Неприпустиме поле відхиляє candidate, не мовчки скидає cooldown. Загальна arbitrary-corrupt-save/R05 матриця лишається окремою задачею.

FORMAT лишається1, container/entity/reference layout незмінний. Це **явне backward-compatible optional schema extension**, дозволене scope FIX-06, а не твердження, що serialized state не змінився. Old→new: відсутні історичні дані неможливо реконструювати, тому empty history; після наступної угоди новий код зберігає timestamp. New→old: старий reader може відкрити save, але ігнорує cooldown і втрачає restriction; downgrade нового save у старий код **не підтримується**. Зберігати копії; перевірка старого reader має окремий diagnostic result.

Правила НЕ змінені: згода адресата також на gift; pending TTL90 simulation seconds; одна active pending land offer на unordered pair; cooldown90s застосовується за existing directional key та human initiator. Це різні правила — не перетворювати cooldown на symmetric/AI embargo мовчки. Gift consent, TTL90s, one pending/pair та stale acceptance policy залишаються для review ZaGOR-1/OKREDU.

Новий authoritative state/hash і виправлена persistence змінюють mixed-build поведінку. PROTO7/FORMAT1/SIM_REVpr10-critical-1/product version НЕ змінені за прямим обмеженням власника. До network розповсюдження потрібен погоджений окремий revision/build gate; запропонований новий opaque SIM_REV (назву затверджує власник) і actual mixed-build rejection. Поки gate не додано — тільки точний same candidate SHA на обох test peers, не auto-update/release. Це integration blocker, не прихована сумісність.

## FIX-07 — REBASE / AIRDROP cancellation

Обидва режими мали _set_mode cleanup (rebase_air/airdrop_air) та _tap→Air command, але були відсутні у pc_cancel_mode allowlist. Додано тільки два enum entries, існуюче очищення використовується повторно. Esc/RMB проходять справжній _unhandled_input. Спочатку штатно закриваються відкриті UI panels/docks; наступний Esc може скасувати placement — ця existing hierarchy не переписана.

До map target: локальний transient mode/ref, ресурси не резервуються, authoritative command відсутня. Cancel/повторний cancel не змінюють world/RNG/hash/resources. Save/load скидає local mode до NONE і не зберігає stale pointers.

Після target submission: MP command уже у canonical queue; локальний cancel **не відкликає** її. Rebase змінює base/spot і стан TAXI/LIFT/RTB під час execution; AIRDROP завантажує troops і списує existing cost/resources під час order_airdrop, не при арming UI. Чинний order_land/RTB — окрема команда повернення; нової refund/abort механіки не вводили. Після issued action Save/load зберігає refs/transit/payload/drop_target; _drop_paratroops споживає payload один раз. Strike planners не додані до cancel list.

Missing/dead/foreign aircraft/destination мають проходити authoritative validation; перевірено foreign issuer та знищену destination (сам hp=0 не є ознакою знищення Facility: alive читає obj_state). Ціль AIRDROP — координати, не object ownership; validity визначають land/owner/transport/resource rules. Повний lifetime/retarget/airbase capture matrix не оголошено вичерпно перевіреним. UI-only cancel не дає нових AI commands, AI behavior code незмінний. Чинний loaded troops/no-refund policy та після-submit boundary передати на gameplay review.

## FIX-08 — Expensive upkeep fallback

Root cause: arguments to Dictionary.get обчислюються eagerly. `_step` робив один `_tally_all`, потім для кожної eligible country ще повний `tally(c.id)`, хоча default result не використовувався. Один _tally_all: O(countries + facilities + aircraft + ships + units) плюс existing nested parked drone scans; fallback на кожну країну повторював traversals. Розрахунок `_react_done` до читання готового tallies збережено: old get повертав саме попередній tally, а не заново обчислений default.

Один рядок замінено lazy conditional `tallies[c.id] if tallies.has(c.id) else tally(c.id)`. Не додано cache/invalidation, не змінено formulas, сумування, порядок countries/classes або RNG. _tally_all свіжий для кожного _step; missing key досі викликає справжній fallback. Unit differential порівнює значення/гроші/materials/stats/RNG з genuine fallback path при ownership/inactive/new-facility/load-state mutations. Before/after profile та full simulation вимірюються окремо: PHASE5B2_PERFORMANCE.md.


## Додаткова validation у FIX05/FIX07

Негативний тест підтвердив HIGH cost bypass у network mil.build: caller міг передати п'ятий аргумент free=true і створити власний airport без оплати. Це не натискання штатної UI кнопки, а forged allowed command; ownership само по собі не захищало economy. У тому ж шляху invalid kind/types/arity викликали script errors у callv. У рамках acceptance про invalid commands додано вузькі NetSession guards: build args3..5, valid enum/Vector2i/Country/optional parent, free лише false; internal AI/spawn free construction іде напряму в Military і не змінена. REBASE/AIRDROP перевіряють arity/entity/Country і finite target перед _owns/callv. Після цього існуючі methods перевіряють alive/owner/terrain/resources. Forged actor/same pending consent правила не послаблені.

FIX05.patch містить Main dispatch + build guard; FIX07.patch — MainCore cancel + air-order guard. Обидва чіпають net_session.gd різними незалежними hunks, порядок05→07 явно зафіксований. Чотири patches реально застосовано в ізольованій копії початкових файлів; отримані7productionfiles byte-identical до current source (patch_reconstruction.json). Інші ALLOWED commands не оголошено повністю hardened; R07 окремо у Phase5B3.


## Фінальний статус

Targeted FIX05–08 локально виконані; exact candidate і фактичні PASS/FAIL/NOTRUN — PHASE5B2_REGRESSION_RESULTS.md. Ready for next stage, не beta integration. Офіційний Godot4.7 описує eager Dictionary.get default і lazy workaround: [class_dictionary.rst](https://github.com/godotengine/godot-docs/blob/4.7/classes/class_dictionary.rst), звірено Context7. Serena LSP недоступний; навігація/edits — rg/files, перевірки — Git/Python/Godot/native PowerShell/ENet.


Пропозиція мінімального admission gate для окремого погодження: `SIM_REV=pr10-phase5b2-1` замість поточного `pr10-critical-1`, без зміни PROTO7/product version. Після дозволу — actual old/new rejection та saved-match resume mismatch tests. У цій сесії ця зміна **не виконана**. Це не робить old executable безпечним reader нового save: unsupported downgrade/backup policy лишається окремою умовою.
