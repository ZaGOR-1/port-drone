## Навігація за чинним кодом

Почни з [`_sim_step` у GameWorld](../../../game/game/game_world.gd) та простеж виклик до підсистеми, яка володіє станом. Для військової логіки початкові точки — [Army](../../../game/game/army.gd), [Military](../../../game/game/military.gd), [Air](../../../game/game/air.gd) і [Navy](../../../game/game/navy.gd). Узгоджені зміни механік перевіряй за scope симуляції, MP, Save/Load і UI. [Архітектура](ARCHITECTURE_AND_FLOWS.md) · [Fixtures](../../DEVELOPMENT_WORKFLOW.md#перевірки-за-scope)

## Історичні checkpoints

Формули, порядок, line references і статус fixtures нижче належать своїм ревізіям. Перед зміною звір реалізацію на чинному HEAD.

# Phase 5B.2 — інтеграційні fixes наявних механік

Airport button доходить до чинного AIRPORT placement/build, ownership/cost перевіряє simulation. REBASE/AIRDROP додані в existing PC cancel allowlist; до target це local mode/ref без resource reservation, після submission команда вже canonical і local cancel її не відкликає. Save/load active action зберігає transit/base/payload, local mode скидається. Refund/abort feature не додано.

Land cooldown90simulation seconds зберігається у Diplomacy optional field; existing directional human eligibility, gift consent/TTL90/one pending pair не змінені, потребують gameplay review. Upkeep формули/баланс/order unchanged: lazy fallback прибирає непотрібні traversals без кешів. Targeted network schemas забороняють forged free build/malformed air orders. Root causes/acceptance/limits: PHASE5B2_FIXES.md, PHASE5B2_REGRESSION_RESULTS.md. Не паритет0.41.

---

## Історичний checkpoint (збережено)

# Phase 5 delta — власна DroneFlames

Candidate codex/fix-pr10-critical від PR10 + uncommitted fixes. Net-driven _process лише показує seasonal uniforms; authoritative Seasons.step лишається _sim_step, snow/hash/farm cadence regressions PASS. Існуючий single-player adaptive frame-dt scheduling не перетворено на нову fixed-tick архітектуру; deterministic твердження стосується однакових commands/dt/ticks.

Human buy/sell/gift/swap потребує recipient accept через чинний inbox/answer_as, TTL90s/одна pending offer на пару; AI original immediate valuation збережений. Ship owner=c для command/Chronicle. Carrier loss: власна жива сумісна база з вільним spot→RTB, інакше controlled DEAD/cleanup; deck jet за старими правилами на land base не сідає. Ці consent/loss правила потребують gameplay review. Докладно PR10_CRITICAL_FIXES/PR10_REGRESSION_RESULTS. Не трактувати це як parity0.41; нижче історична baseline карта.


---

## Історичний документ / попередній scope (збережено)

# Ігрові системи та детермінізм

Підтверджені anchors на `af1b4c9`; без runtime balance/simulation tests. Це карта перевірених entrypoints і формул, не вичерпна специфікація всіх бойових/дипломатичних гілок. Деталі, які пройшли лише автоматичний аналіз, позначені у FILE_COVERAGE.

## Час і порядок симуляції

Single player: `game/game/game_world.gd::_process:360` бере `total=delta*time_scale`, `n=min(8, ceil(total/0.2−0.001))`, `step=min(total/max(1,n),0.3)`. Обриває цикл за elapsed CPU budget `sim_budget_ms=12`. `sim_lag=max(0,total-step*done)` лише записується; у цьому циклі не накопичується назад. **Це адаптивне дроблення frame delta, не гарантований fixed timestep і не строгий replay незалежно від FPS.** `time_scale=0` дає n=0. SPEEDS = `[1,2,5,10,20,0.5]`, pause задає scale=0 (`main_base.gd`, `main_core.gd::_apply_speed:187`).

MP: `net_driven` у World._process робить лише vision/terrain/territory flush. `NetSession::_run` викликає `GameWorld.net_step(1/30)` тричі на turn; CPU budget визначає кількість виконаних ticks у frame, не dt і порядок ticks. `net_step:342` збільшує net_tick, вмикає RNG/money diagnostics, викликає `_sim_step`, strike scheduler, prune groups раз на 30 ticks, roads, trucks і checkpoints. Commands перед першим tick turn. Порядок мережевої симуляції не можна замінювати SP `_process`.

`GameWorld::_sim_step:391`:

1. game_time += dt; Cad344.step.
2. Due delayed Callables у початковому порядку черги (вибір зі зворотного обходу й reverse).
3. За dt>0: territory expansion slices, enclave tick, AI town scheduling, town queue, bridges.
4. `mil` → `diplo` → `econ` → `rail` → `army`.
5. `aftermath` → `nature` → `vfx.sim_tick`.
6. `defense.update` → `defense.update_shots` → `session` → `ai`.
7. `ops` → `guide` → `protect` → `naval` → `navy` → `supply` → `arch` → `kpp` → `hold`.
8. fires/ruins → `pstat` → `drama`.

Зміна цього порядку змінює, наприклад, доступність вироблених ресурсів і стан цілей у тому самому tick.

## RNG і планування

`core/rng.gd`: seed змішується `Hash32.mix(seed ^ 2654435769)`; fallback nonzero 1831565813. Xorshift32 з shifts 13/17/5 і маскою `0xffffffff`; `range_i(n)=next_u32()%n`, `roll=next_u32()/4294967296`. World RNG seed = world_seed+99. Hash32.h2 поєднує x/y і seed. Порядок draws, dictionary/array traversal та entity IDs — частина фактичного multiplayer contract.

`game/cad344.gd`: slots=`clamp(ceil(dt*60−0.001),1,20)`, спільний operation budget для AI/diplomacy/trade/towns. EXP_SLICES=8, EXPAND_DT=0.8. AI_TOWN_DT=38. `phase_offsets` розводить KPP/Rail/power/drama. Це operation-count scheduling. У Cad344 немає `save_state/load_state`; внутрішні фазові черги не зберігаються Save automatic discovery — точне продовження всіх проміжних обчислень після load не гарантоване.

`gw_map.gd::job_ready:889`: у MP job уперше отримує net_tick, чекає JOB_DELAY_TICKS=120, потім за потреби блокується до worker completion; швидкість CPU не повинна визначати tick застосування. У SP readiness залежить від фактичного completion; lab_tick test hook примусово чекає завершення. `_road_job` копіює biome/flags/mask, `_road_apply` перевіряє data instance і перешкоди; на новий world/exit jobs drain-яться. Увесь pipeline ще не перевірений між двома peers.

## Світ, країни, міста

`WorldSettings`: seed 20261016, default size1024, land42%, continents3, islands35, rivers22, mountains40, forests50, gen_version2. `GameConfig.SIZES=[512,1024,2048]`; WorldSettings presets також містить4096, але звичайний setup використовує GameConfig sizes. Різні списки не означають доступність 4096 у UI.

`WorldData`: квадратна grid w×h, CELL=4 world pixels, packed byte arrays height/biome/owners/flags. Owner 0 — не країна; country IDs використовуються в byte/кольорових lookup. Flags: ROAD1/BRIDGE2/OCCUPIED4/CITY8. Biome enum: DEEP…BURNT (22 значення), water <=RIVER, open sea <=OCEAN. Порядок enum має значення для packed saves/shaders.

`WorldGen.generate:10`: шість шумових шарів з вагами `[10,7,5,3,2,1]`, continent/map-type mask, histogram sea threshold за land_percent, висотні й moisture thresholds для біомів; gen_version>=2 → WorldGen2.rivers, інакше legacy `_rivers`. WorldGen2 має integer geometry helpers. Не доведено побітову однаковість Image.resize/engine math між усіма платформами; pinned build і runtime hash tests потрібні.

`Country` — ресурси/гроші, capital_id, city_ids, score, doctrines, player/AI/eliminated, flag/style, army_groups, AI difficulty. `City` — CAPITAL/TOWN/VILLAGE, власник/founder, center/entrance/radius, frontier/visited, garrison, siege/capture. Garrison caps =1200/500/200.

`gw_infra::found_city:5`: перевіряє план, border gaps, enemy occupation; town може стати village; додає city з ID=індекс у cities, buildings/terrain/flags/frontier, початкове зростання, road job, capital identity. `gw_states::capture_city` переводить територію і facilities, очищає queued launches, обробляє казарми/припарковані дрони/літаки/flags; airborne aircraft шукає іншу базу або знищується. Це не проста зміна city.country_id.

## Економіка, ресурси, розвиток

`Economy.update:21`: soft path budget кожен update, production кожні10 s, trade кожні16 s, Cad344.trade_q, trucks/ports/trade331/upkeep335, audio раз0.5 s. Виробництво залежить від alive/halted, supply і power. Базові показники на production tick:

| Об'єкт | Ресурс / гроші |
|---|---|
| Farm | ceil(4×level_mul) food; int(20×AI multiplier×level_mul) money |
| Civil factory з power | ceil(3×level_mul) goods; int(35×AI multiplier×level_mul) money |
| Mine з power | metal4 / titanium2 / precious1 × level_mul; +int(10×AI multiplier) money при видобутку |
| Oil rig | base3 oil × level_mul; окремого mine-money немає |
| Sawmill | min(ceil(min(4,1+trees/15)×level_mul),room); рубання й regrow480 s |
| Uranium mine | fractional Nuclear.U_MINE_RATE, power і deposit перевірки; не прирівнювати до titanium rate |

Extraction: `n=min(rate,room,deposit.left)`; у infinite-res mode left не зменшується. Reserves presets normal/large/infinite; multiplier `[1,3,1]`. Level multipliers1/1.6/2.2, max level3. Deep mine/oil upgrade додає reserve лише для ще не відкритого level, finite deposits; loading має compatibility defaults.

Military `_income:118` кожні10 s: powered CAPITAL80/TOWN30/VILLAGE10; AI money multiplier0.7/1/1.5. Армія споживає `(unit_count+2)/3` food за economic tick, із нестачею викликає starvation. Перевищення storage cap продається; точна ціна враховує Upkeep.

`res_cap=BASE_CAP + PORT_CAP(якщо є порт) + _bonus`. RAW warehouses STORE_S/M/L дають складений bonus за alive+owner; upgraded enterprises дають +40×(level−1) відповідному output resource. _bonus кешується лише поза UI-time; recent HEAD commits змінювали invalidation цього кешу. Не переносити його очищення чи ownership hooks без build/destroy/capture/demolish/load tests.

Market `_update_prices:1308`: target=base_price×clamp(0.75+0.6×(demand+5)/(supply+20),0.6,2.2), smoothing35%. Поточні buy/sell ціни також множаться на Supply/Trade331/Upkeep modifiers. Foreign base multipliers buy1.6/sell0.7. Build money із `Military.COSTS/price_of` + `Economy.BUILD_COST` resources; не покладатися на стару `COST_AIRFIELD=800`, коли актуальний COSTS[AIRFIELD]=2000.

Окремого research/tech-tree класу чи entrypoint за пошуком `research/tech_tree/technology/исследов/дослідж` не знайдено. Наявні facility/air upgrades, rail development levels, power status. `Rail::_dev_tick:510` рахує `earned + ENT_POINTS×enterprise_count`, застосовує DEV_LEVELS і unlocks. Вичерпна специфікація unlock/late economy — NEEDS INSPECTION, не називати її системою research без додаткового факту.

## Військові системи

Military володіє facilities, drones, missiles; Air — aircraft; Army — units. Facility.Kind має43 позиції, включно з air/drone/missile production, AA/EW/radar, fortifications, ports/rail, nuclear, ammo depots та raw warehouses. Не міняти числові ordinal IDs.

Military.update: income/restoration/watch-state/power/fuel → production кожні0.5 s/Depot dispatch → repairs/heal/roam → TEL/drones/missiles/standing orders → Air.update → Recon.update. Drone виробляється20 s, jet UAV34 s за базовими constants; capacity і ресурси перевіряються перед стартом. Місця на портах/depots і runway eligibility також обмежують production.

| Модель | Стани / джерело |
|---|---|
| Unit | IDLE/MOVE/FIGHT/SIEGE/DEAD; 10 types: tank, infantry, FPV, ATGM, assault, IFV, mortar, arty, MLRS, recon (`unit.gd`) |
| Drone | PARKED/WAIT/TAXI/HOLD/ROLL/BOOST/FLY/DIVE/DONE; routing/range/launcher refs (`drone.gd`) |
| Missile | IGNITE/FLIGHT/DONE; ignite0.6 s, ground interpolation smoothstep, alt=4×apex×u×(1−u)+alt0×(1−u) (`missile.gd`) |
| Aircraft | bomber/fighter/heli/attack; parked→taxi→roll→lift→flight/patrol/RTB→land/dead (`aircraft.gd`) |
| Ship | LIGHT/MEDIUM/HEAVY; IDLE/SAIL/SINK; owner у полі **c**, не country_id (`ship.gd`) |

Army.update: train → scan/grid0.25 s → acquire/fight/advance/FPV → shells/rockets/grenades → tactics/reinforcement/fire → posts1 s → siege0.2 s → removal dead. GRID_PX128, BARRACKS_CAP12; base tank HP120/speed13/range75/damage30, infantry HP45/speed8.5/range42/damage6. Це значення SPEC, не повна формула effective damage: cover/entrenchment/suppression/armor/kit у допоміжних модулях.

Air.SPEC містить чотири типи; buy base cost bomber12000/fighter3000/heli1800/attack5000, AIR_CAP6. Pylon, AAM, cruise, KAB, CAS, fuel/service/duel/wreck rules розділені між Air, AirDuel, AirWreck, Defense, SkyCover. Повні hit/damage interactions ще потребують ручного читання.

Navy — бойові кораблі, shipyard, modules gun/CIWS/SAM/ASH/VLS/art, fleets, service, coastal missiles; Naval — експедиції/десант/colonies, Ports — цивільна морська торгівля. Не зводити ці три системи до одного класу. Navy.update відпрацьовує production, queued missiles, рух, combat/refit, missile defense, NavyArt/NavyFleets, effects/cleanup. Базові hull HP320/650/1300, speed22/17/13, base build time50/80/120 плюс modules. Ship зберігається окремо через to_dict/from_dict.

## AI, дипломатія, туман

AiBots.update обходить країни в наявному порядку, пропускає player/eliminated/no-capital; think periods14/9/5 s × ai_pace. Вісім фаз: repair/navy → growth → build → aviation/neutral expansion → naval/spend/missile mix → war/tension → rear/bridge guard → fronts. `_kind_counts` створює inventory на рішення; включає початкову семантику destroyed facilities, не глобальний stale cache. Pending colony probes збережені; усі AI decision branches не пройшли ручний review.

Diplomacy має PEACE/WAR/TRUCE/ALLIANCE, symmetric pair keys, opinion clamp−100…100, treaties trade/visa/NAP/defense/alliance плюс passage/subjects; truce150 s і scheduled AI12 s. Helpers: Alliances/AllyCare/AllyRift, DipRequests/DipReact, SkyCover, PeaceConf; санкції/контракти — Trade331; power/world events — PowerStatus/WorldDrama. Прохання, deadlines і політичні side effects впливають на симуляцію, не лише на текст HUD.

Vision — per-device fog/presentation knowledge: GRID16 px, refresh0.25 s, allies/radar/units/recon/satellite sources. `Vision.save_state:650` виключає generated images/caches; `net_keep/net_rebind` зберігає власну видимість і перевіряє signature facilities після host snapshot. Це UI fog, **не приховування повного world state від клієнта**: lockstep/snapshots містять повну симуляцію. Elimination дає спостереження через SPECTATOR_OK у Main; окремий spectator join protocol не знайдений, нові гравці під час матчу відхиляються.

## AI: характер, час і фази рішення

`game/game/ai_persona.gd` задає trader/militarist/cautious/adventurer з traits aggr/trade/sneaky/caution, build preferences і sub_wait. `AiBots::_assign_personas:52` розподіляє збалансований bag через Hash32 від world seed; human отримує neutral traits. Aggression multiplier `[0.45,1,1.3]` затискає effective aggr у0…1. Це scripted rule-based AI; нейромережевої моделі в цих entrypoints немає.

`AiBots::update:435` пропускає human/eliminated/no-capital. Початковий think time зміщено на country.id×1.7; наступний = game_time + `[14,9,5]` за difficulty × ai_pace. Для малої карти early_damp=clamp((900−t)/300,0,1), ai_pace=1+0.5×early_damp (`GameConfig:197`…`217`). Cad344 розбиває рішення на8 частин із загальним operation budget; без scheduler усі8 виконуються відразу.

Фази `ai.gd::_think_part:572`: repair+navy → grow land → build → aviation+take neutral → naval+spend surplus+missile mix+resume production → war або tension fortify → deferred rear/bridge guard → fronts. Отже CPU scheduling і AI decision order входять у gameplay. `save_state:366` зберігає personas/stats/timers, continuation build/spend/attack, air jobs і BridgeGuard; Cad344.ai_ph окремо не зберігається. Повний target selection, усі military purchases і diplomacy decisions ще NEEDS INSPECTION.

## Навігація, шляхи та worker jobs

`economy/eco_core.gd::build_nav:402` будує три AStarGrid2D: nav/nav_soft/nav_dry, NAV_K4 world cells, тобто16 world pixels на nav cell. Усі використовують octile heuristic та diagonal only-if-no-obstacles. `_nav_eval:441` враховує water/river/road/roughness/intact bridge; road weight1, off-road1.6+0.125×rough, blockage multiplier4. Bridge state і block_rect змінюють version/cache validity; coarse navigability не дорівнює прохідності кожного fine segment.

`nav_path:676` має cache за endpoints+nav version, TTL45 game seconds, cap384; додає bridge deck waypoints і `_dry_segments`. `army_path:731` memo-їзує в одному game_time і за budget витрачає2 route units/tick із distance cost. `_soft_path` — resumable refinement coarse corridor→fine windows, максимум8 jobs, SOFT_TICK4000 operation units, SOFT_BUDGET400000 на job; це не4000µs. `ui_time` у MP виконує окремий synchronous query і уникає запису головних path caches. Усі smoothing/water fine checks не охоплені ручним review.

`Rail::_link:742` копіює biome/flags/owners/mask і city facts у job; worker шукає й згладжує лінію, `_finish_line:813` повторно перевіряє instance/станції/live obstacles. `_poll_job` використовує World.job_ready. `Supply::_lb_step:1415` копіює окремий AStar grid, worker повертає IDs у box, main thread додає bridge/dry legs. MP/lab mode використовує NET_OPS400 замість SP wall-clock LB_BUDGET1200µs (`Supply:131`…`143`); семантична рівність на різних CPU потребує replay.

`Navy::_ensure_nav:1069` будує sea grid від Ports.sea і flat alternative; BFS рахує coast distance та підвищує weight біля берега. `sea_path:1150` обмежує detour відносно flat path, тимчасово зважує hostile facility/ship threat zones і відновлює weights, кешує тільки коли threats порожні. Це окрема навігація від наземної Economy; transport ships у Naval і бойові ships у Navy не можна звести до однієї Unit route.

## Що ще не доведено

Двопірний детермінізм, Windows GUI, ефективний бойовий баланс, усі diplomacy/AI side effects, точна рівність continuation до/після save, відсутність UI writes між ticks і повний dynamic resource graph. Ці межі не закриваються успішним JSON/regex аналізом; план — BACKLOG P0/P2 та TEST_MATRIX.
