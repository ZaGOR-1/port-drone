# Phase 5 — PR10 critical fixes

2026-11-20. Реалізація локальна, **uncommitted**, у `/home/zagor/projects/port-drone-pr10-critical`, гілка `codex/fix-pr10-critical`, base/HEAD `96053d66eb984cc24e3acce647a55a195136abd2`. Жодного merge/push/commit/PR/release/CI dispatch. Main/beta/migration і гілки OKREDU не пересувалися. Точна перевірка та рішення: [PR10_REGRESSION_RESULTS](PR10_REGRESSION_RESULTS.md).

Незалежна DroneFlames — прийнятий напрям; 0.41 DEFERRED. PR1–9 уже включені у PR10; функції й авторство OKREDU збережені. Це цільові fixes п’яти HIGH findings PA01/02/03/04/06 у чотирьох сімействах, не повторний повний аудит гри.

## FIX-01 / PA01 — seasons determinism

**Root cause:** `GameWorld._process` у net-driven режимі додатково викликав `Seasons.step(delta)`, тоді як fixed `_sim_step(dt)` уже виконує цей step. Snow smoothing залежав від FPS і переходив через поріг0.45, який змінює `farm_mul` із1.0 на0.5. NetHash не включав snow. Однакові simulation time/hash могли приховувати різний economy output.

**Зміна:** [game_world.gd](../../../game/game/game_world.gd), `_process`:390–401 лише публікує season uniforms; `_sim_step`:522–527 лишається джерелом gameplay seasons. [net_hash.gd](../../../game/net/net_hash.gd):9–20 включає season/year/phase/snow/rain/wind/nuclear_chill. RNG, tick order і формули економіки не змінені. Shader parameters — presentation; weather particles використовують окремий visual state.

**Доказ:** `tests/test_pr10_critical.gd::_test_render_and_hash` викликає реальний render method за різного cadence, fixed season ticks і реальне `Economy._produce` на фермі свого власника; перевіряє позитивний output, ресурси/гроші, RNG та hash і незалежну мутацію лише snow. У RED відтворюється різний farm output. Два окремі Main/save/load/320-tick runs із додатковими render updates мають однакові hash/RNG/time/snow, переходять через farm threshold. Це локальний deterministic scenario, не сертифікація повного MP-транспорту.

## FIX-02 / PA02 — авторизована територіальна угода

**Root cause:** `LandTrade.propose_deal` одразу виконував buy/sell/swap навіть коли контрагент — людина. Ownership issuer у command validation не є згодою іншого власника. UI не міг компенсувати відсутню authoritative перевірку.

**Зміна:** [land_trade.gd](../../../game/game/land_trade.gd):105–326 розділяє offer і execution. Для human recipient buy/sell/gift/swap лише створюють `kind=land` у чинному `Diplomacy.t_offers`; не переміщують грошей/землі. Використані чинні `diplo.land_deal` та `diplo.answer_as` — нових RPC/packet types немає. [net_session.gd](../../../game/net/net_session.gd):2007–2040 перевіряє schema/arity/types/ranges до ownership casts і typed call.

Фіксовані terms: mode, parcel keys, normalized price, signatures, recipient, expiry. `_signature`:241–264 включає geometry, owners/flags, parcel value/deposit remainder, склад facilities; локалізовані назви виключені з digest. Перед acceptance повторно перевіряються власність/склад/мир/живі країни/кошти/cooldown. Лише адресат відповідає через existing `answer_as`; proposer/третя країна/forged actor не можуть погодити угоду. Proposal споживається один раз, зокрема після stale або недостатніх коштів; повторне acceptance не має ефекту.

Одна pending land offer на неупорядковану пару, TTL90 simulation seconds. Відмова не виконує угоду. Ініціатор скасовує через existing command із mode=cancel; чужий cancel відхилено. Expired record може лишатися до чинного prune, але не виконується й не показується у inbox. AI зберігає immediate transactions та старі valuation rules.

[Diplomacy](../../../game/game/diplomacy.gd):822–837/915–923 маршрутизує inbox/answer. [DipSheet](../../../game/ui/ui24/dip_sheet.gd):605–698 показує parcel/price і прийняття/відмову. [DipPage](../../../game/ui/ui24/dip_page.gd):2874+ показує cancel і чесний «пропозицію відправлено». UI не є місцем авторизації.

**Save/compatibility:** terms проходять уже наявний t_offers save/load без зміни FORMAT1 envelope/entity schema. Pending пропозиція реально зберігається на диск і приймається через справжню inbox button після штатного Main load. NetHash охоплює land terms/recipient/expiry. Старий→новий synthetic baseline пройдено; довільні corrupt internal dictionaries і new→old downgrade не сертифіковані. Новий тип вмісту словника не означає сумісності старого коду з новим save.

**Правила для gameplay review ZaGOR-1/OKREDU:** згода також для gift; TTL90s/одна угода на пару; stale acceptance споживає offer без автоматичного перерахунку ціни. Чинний AI offer scheduling спільно використовує t_offers і може чекати до завершення pending land offer. `_last_deal` persistence (PA07) свідомо відкладено у Phase5B, не оголошено виправленим.

## FIX-03 / PA03 та PA04 — Ship.c

**Root causes:** NetSession ownership намагався читати неіснуючий `Ship.country_id`, що давало invalid int(null)/відхилення own purchase; Chronicle також читав це неіснуюче поле, зриваючи запис кадру.

**Зміна:** [net_session.gd](../../../game/net/net_session.gd):2083–2100 має окрему Ship-гілку з `Ship.c`; [chronicle.gd](../../../game/game/chronicle.gd):158–163 записує `sh.c`. Alias country_id не додано, модель Ship/FIELDS/codec незмінні.

**Два окремі regressions:** `_test_ship_purchase_command` — реальний NavyDock → NetCodec/queue → _exec → aircraft, foreign ownership відхилено, Ship dict roundtrip; `_test_chronicle_ship` — mixed fleet → frame з обома owners → compressed Chronicle disk roundtrip. Main/HUD E2E додатково перевіряє purchase/save/load/canonical owner та зв’язок літака з carrier.

## FIX-04 / PA06 — carrier lifecycle

**Root cause:** `_sink_carrier_wing` призначав RTB із null або несумісною/повною базою; подальший Air._step звертався до відсутньої base. Колишній пошук не враховував сумісність типу й вільні spots окремо для кожного літака.

**Зміна:** [navy.gd](../../../game/game/navy.gd):3178–3207 обирає для кожного airborne aircraft свою живу, нерухому, справну, сумісну базу з вільним місцем; наявний порядок facilities/aircraft детермінований і вже призначений spot резервується для наступного літака. Country не змінюється; старий carrier link очищається.

Без доступної бази aircraft стає DEAD через чинний cleanup lifecycle, а не null-base RTB. Parked wing губиться разом із кораблем, як раніше. За чинним `Air.can_base_at` DECK_JET не сідає на land airfield, тому контрольовано губиться; HELI може divert. Нову rescue/landing механіку не вводили. Це консервативне правило потребує gameplay review власника/OKREDU.

**Доказ:** тести deck/parked/heli/full/foreign/crater/no-base/building/moving/destroyed, реальний subsequent Air._step для valid diversion; двоє helis і одне місце — лише перший резервує spot. Main E2E викликає реальний Navy._sink, зберігає loss state, штатно завантажує й продовжує симуляцію без null-base error та owner change.

## Compatibility boundary та межі

[net_config.gd](../../../game/net/net_config.gd):8–10/86–87 додає opaque `SIM_REV=pr10-critical-1` до наявного build identity. PROTO=7, FORMAT=1, RPC signatures/packet layout, Menus.VERSION/source version.cfg і native DLL не змінені. Старі equality guards для LAN/Steam/rejoin використовують цей identity; actual two-peer mixed-build test ще NOT RUN. Це свідома зміна build admission semantics, не приховане підвищення protocol чи product version.

Інші відтворені проблеми лишаються: [PHASE5B_PLAN](PHASE5B_PLAN.md), зокрема HIGH R02. Частковий state hash не є криптографічним захистом і не сертифікує всі authoritative поля всіх систем. Формати/transport не переписували; недовірені command validation перевірено лише в описаному scope.

Додані regression sources: `tests/test_pr10_critical.gd`, `tests/test_pr10_critical.py`, `tests/test_pr10_save_continue.gd`. Python wrapper автоматизує critical suite; Main E2E запускається окремо з ізольованими paths і має окремі functional/shutdown результати. Результати ранніх спроб і невдалого E2E harness setup збережені, не підмінені PASS.
