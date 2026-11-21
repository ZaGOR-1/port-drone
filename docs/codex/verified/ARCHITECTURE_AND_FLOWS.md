# DroneFlames — архітектура та потоки beta v0.36

2026-11-21. Карта початкового onboarding172df65 актуалізована для code checkpoint `0f26040994043827a7c14913d945a3df02e00fdd` (PR #4). Startup/extends лишилися; змінені contracts нижче звірені з v0.36 sources/fixes. Це цільове оновлення, **не повний semantic audit**. [SOURCE_COVERAGE](SOURCE_COVERAGE.md) відділяє старе читання від змінених files. Runtime evidence: beta CI43 tests/2476 checks/build PASS, попередній native Windows headless PASS; GUI/real LAN/Steam NOT RUN. Старий [ARCHITECTURE](ARCHITECTURE.md) — історичний report.

## Запуск і ownership

1. `game/project.binary`: ECFG, 1632 bytes, 26 entries; application DroneFlames, baseline main `res://game/main.tscn`, viewport360×640, canvas_items/expand, renderer mobile, Windows driver d3d12. Це прочитані binary metadata; активний renderer потребує runtime log. У project немає текстового project.godot і немає application/config/version entry.
2. [override.cfg](../../../game/override.cfg) задає main `res://pc/boot.tscn`, window override1600×900 та autoload **PcPort**, **SteamNet**. Autoload ініціалізуються до boot; порядок фіксується конфігом, startup підтверджено попереднім native headless; GUI тут NOT RUN.
3. [PcPort](../../../game/pc/pc_port.gd) створює desktop window policy, minimum960×540, scale/fullscreen/window preferences у `user://pc_port.cfg`; [SteamNet](../../../game/pc/steam_net.gd) ініціалізує GodotSteam або mock. Updater bypass сам по собі не обходить Steam: QA launcher окремо задає `DF_STEAM_MOCK=0`.
4. [boot.tscn](../../../game/pc/boot.tscn) створює PcBoot з [updater.gd](../../../game/pc/updater.gd). `_ready` → `_enabled` → `_load_cfg`; headless/editor/DF_NO_UPDATE або empty repo пропускають update. Далі `_start_game` → `change_scene_to_file("res://game/main.tscn")`.
5. [main.tscn.remap](../../../game/game/main.tscn.remap) веде до 672-byte binary [PackedScene](../../../game/.godot/exported/133200997/export-178df499c26bcd3357cc4c21fb1eaa2e-main.scn). RSRC і рядки Main/Node/script/main.gd підтверджені статично; scene startup пройшов попередній native headless; binary metadata не замінюють GUI QA. Це не missing scene.
6. [Main._ready](../../../game/game/main.gd) створює World, Camera, Hud, PendingGhost, RouteOverlay, **Net**, Menus, Tutorial, Loading; під'єднує input/action/request/news/war/capture/end/offer signals. `Net` має однаковий RPC path на peers. `Menus.setup` → `Save.load_prefs` → `Loc.boot`.
7. First-run LangPicker/Opening можуть await; потім `_main_menu`: випадковий seed, demo512, `world.new_world`, 4 AI, time_scale2, drifting camera. Меню має живу симуляцію.
8. New match: Menus request `start` → `_new_game` → `Save.begin_new` (старий slot залишається до першого запису) → `start_world` → new_world → CAPITAL placement. MP: `_start` → `main.net_begin` → start_world → `mp_setup_humans` → ready barrier → `_begin`.

Редагована схема цих меж: [reonboarding-flows.drawio](reonboarding-flows.drawio). Вона агрегує потоки; порядок simulation нижче точніший за схему.

## Успадкування й спільний стан

У початковому onboarding лексично звірено всі tracked extends; 130 class_name точно відповідають 130 записам global_script_class_cache.

| Верхній модуль | Ланцюг extends до engine class |
|---|---|
| Main | main.gd → main/main_input.gd → main_strike.gd → main_core.gd → main_base.gd → Node |
| GameWorld | game_world.gd → game_world/gw_states.gd → gw_infra.gd → gw_map.gd → gw_base.gd → Node2D |
| Economy | economy.gd → economy/eco_trade.gd → eco_core.gd → eco_base.gd → RefCounted |
| Military | military.gd → military/mil_strike.gd → mil_build.gd → mil_base.gd → RefCounted |
| Diplomacy | diplomacy.gd → diplomacy/dip_allies.gd → dip_rules.gd → dip_base.gd → RefCounted |
| Hud | hud.gd → hud/hud_lane.gd → hud_cards.gd → hud_ops.gd → hud_dock.gd → hud_keys.gd → hud_army.gd → hud_dip.gd → hud_econ.gd → hud_stack.gd → hud_kit.gd → hud_base.gd → CanvasLayer |

[GameWorld.new_world](../../../game/game/game_world.gd) зберігає settings, створює Rng(seed+99), очищає країни/міста/старі jobs/plans; створює Military, Diplomacy, Economy, Army, Defense, Match, AiBots, Vision, Operations, BattleWatch, Recon, EconGuide, Protect, Naval, Navy, Supply, ArchStyle, BorderPosts, UrbanHold, Aftermath, PowerStatus, WorldDrama, Seasons, Chronicle. Потім WorldGen → Nature/border noise → terrain/ownership textures/objects/trees → deposits/nav → Rail → map-scaled ranges → Cad344/phase offsets.

World володіє countries/cities/bridges, packed object/map arrays і system refs; Military — facilities/drones/missiles/Air; Army — units; Air — aircraft; Navy — ships; Economy — production/trade/ports/upkeep. Main/World Node children належать SceneTree; більшість simulation systems — RefCounted із зворотним gw. Entity refs перехресні: aircraft↔base, Facility↔parent/modules, Country↔cities; singleton/static state є в Save, GameConfig, NetSession._inst, Navy.cur, FrontPlan, Sfx, Loc, MapCamera. Це shared mutable graph, не ізольовані pure modules. RefCounted cycles — підозра щодо lifetime; поточний leak cause не доведений.

UI читає caches світу, simulation викликає signals/VFX/audio; `gw.net_sim`, `gw.ui_time`, `ui_mute` та cache invalidation розділяють частину контекстів. Довільно переносити ці об'єкти у worker небезпечно. `Navy.cur` явно скидається перед MP tick, бо placement preview може його змінити.

## Simulation loop і deterministic boundaries

[GameWorld._process/_sim_step/net_step](../../../game/game/game_world.gd), [NetSession._run](../../../game/net/net_session.gd), [NetConfig](../../../game/net/net_config.gd):

- SP: total=frame_delta×time_scale; максимум8 підкроків, nominal0.2, step≤0.3; звичайно budget12ms, `no_slow` обходить budget break. sim_lag записується, не переноситься назад у цьому циклі. FPS/CPU можуть змінити dt і просування SP.
- MP: `_process` лише seasons uniforms/vision/terrain/territory; simulation викликає NetSession. `SIM_DT=1/30`, `TICKS_PER_TURN=3`; commands виконуються лише при exec_tick0. До24 ticks/frame, budget14ms; CPU budget змінює pacing, не dt.
- `_sim_step`: game_time → Cad344 → due Callables у порядку insertion → expansion/enclave/AI-town/bridges → **Military → Diplomacy → Economy → Rail → Army → Aftermath → Nuclear silos/radiation → Nature → VFX sim → Seasons → Chronicle → Defense/update_shots → Match → AiBots → Operations → EconGuide → Protect → Naval → Navy → Supply → ArchStyle → BorderPosts → UrbanHold → fires/ruins → PowerStatus → WorldDrama**.
- `net_step` додатково веде net_tick, RNG/money diagnostics, strike scheduler, group prune кожні30 ticks, road jobs, trucks/checkpoints.
- [Rng](../../../game/core/rng.gd): xorshift32 13/17/5, state mask32, modulo range; World seed+99. Draw order і entity traversal — контракт. Наявність global randi/randf не доводить desync: потрібен data-flow до authoritative state; повний RNG review усіх helpers НЕ завершений.
- [Cad344](../../../game/game/cad344.gd) роздає operation slots `ceil(dt×60)`, clamp1..20; фази AI та queues. save_state/load_state немає, тому scheduler не потрапляє в Save dynamic discovery. Exact continuation всіх внутрішніх фаз через save — UNVERIFIED.
- [gw_map.job_ready](../../../game/game/game_world/gw_map.gd): MP чекає120 net_ticks від першого poll, потім блокує до worker completion; SP використовує actual readiness, lab_tick — спеціальний wait path. Це намір deterministic application, не пройдений two-peer proof.
- Dictionary insertion/order, float math/Image.resize у world generation, static UI caches, async restore та різні executable залишаються зонами перевірки. Змінювати їх без replay/hash/state tests не можна.

## Реальна команда: будівництво Airport

1. HUD action `airport` → [Main._on_action](../../../game/game/main.gd) (case airport) → BUILD_KEYS.AIRPORT і локальний placement mode.
2. Map input → [main_input._tap](../../../game/game/main/main_input.gd) → BUILD_KIND.AIRPORT; звичайний шлях `_sim("mil","build",[kind,cell,world.player],callback)`. Resource substitution має окрему `.cmd_build_sub` route.
3. `_sim` → `NetSession.call_sim`. Offline: прямий target.callv; MP: NetCodec.encode entity refs → dedup400ms → `issue` із seq q.
4. Guest reliable `_cmd_rq` до host; host визначає sender slot, перезаписує s, прибирає чужий c, додає pending. Host cuts canonical `_turn(n,cmds,speed)`; кожен peer виконує той самий список.
5. `_exec`: issuer=slot+1; ALLOWED/target/method → decode → `_valid_build_args` (arity3..5, enum/cell/Country/parent, **free=true forbidden**) → `_owns` → callv. Валідація відбувається на всіх simulation peers; host координує порядок, а не замінює їх simulation.
6. [Military.build](../../../game/game/military/mil_build.gd): check_place/detour → pay_series/pay_build → Facility ID/owner → terrain/flags/object sprites → registry/Chronicle/constructing/signals. Чужа власність, ціна, terrain — simulation checks, не тільки UI.
7. Три fixed ticks; `_end_turn` кожні50 turns рахує [NetHash.of](../../../game/net/net_hash.gd), guest надсилає `_hash_rq`; mismatch → resync. Callback показує результат лише issuer device і перевіряє lifetime UI object.

Targeted checks для build/land/air/power є; більшість ALLOWED methods не має повної per-method schema. `_owns` обходить прямі args, не довільні вкладені контейнери; `_cmd_rq` не має явного command-rate budget. Це підтверджена область hardening, не доказ експлуатації кожного method.

## Multiplayer

| Шар | Поточний контракт | Межа перевірки |
|---|---|---|
| LAN | ENet host24600, до4 players; UDP discovery24601/24602, /24 sweep | Код host/join/discovery прочитаний; actual LAN NOT RUN |
| Steam | SteamNet lobby metadata df_game/name/v/host, invites/+connect_lobby; SteamPeer star, host peer1, channel3 | AppID480; реальні accounts/Steam API NOT RUN |
| Online | RtcLink/WsTunnelPeer/WebRTC, Api/Account/Ranked/TLS source лишився | PC Menus.show_mp має online_ok=false й tabs Steam/LAN. Не оголошувати backend видаленим із source або доступним через normal PC UI |
| Identity | `v0.36.0/7/v036-integration-1`, exact hello до rejoin, Steam v, saved resume early gate | SIM_REV актуальний за кодом; не content fingerprint |
| Ownership | slot→country(slot+1), Ship.c, інші ownable.country_id; City може бути attack target | UI player різний на peers; повний world є на кожному, fog не приховує authoritative simulation |
| Turns | Reliable authority `_turn`, pending arrival order, 900 retained turns | New unknown guest під час матчу rejected; return seat token — інша route |
| Hash | truncated MD5 16 hex, numeric aggregates + obj_state + owners; seasons/land terms/cooldowns +v0.36 nuclear/EMP/T3/power/fuel/UrbanHold/Navy route fields включені | Частковий diagnostic digest, не повний snapshot і не доказ рівності всіх полів |

Steam wire: 7-byte header(kind,nonce,channel,mode), HELLO/WELCOME/BYE/PING/REFUSE; nonce не є cryptographic account auth. HELLO retry1s/give-up25s; ping1s/timeout45s; MAX_SIZE524224. peer_id_of бере low32bit Steam ID modulo2147483000+2: математичні collisions можливі; host admission не звіряє lobby membership у wants_session. Negative runtime cases NOT RUN.

Reconnect guest: зупиняє go, перепід'єднується кожні4s до60s, connected wait150s; seat зберігається20min, host-away metadata3days. Host повертає country через canonical human command і snapshot. Saved host match кожні600 turns, exit/focus hooks; resume_wait до180s. Фактичні disconnect/rejoin/resume тести між незалежними PCs NOT RUN.

Host handover/promotion у code є для **ONLINE casual** з server/epoch; `can_hand_over` відхиляє LAN/Steam і ranked. Steam lobby owner change не доводить підтримку migration simulation host. Для LAN/Steam QA очікувати saved host resume/rejoin; automatic host change — N/A за поточним кодом.

Resync: host Save.net_snapshot → parts16000 → `_snap_begin/_snap_part`; bounded header/indices/lengths/contradictory duplicate guards → join bytes → `_restore_from`. **Усі peers і host** відновлюють однакові bytes, бо caches не всі serialized. Save preflight → staged world/core/systems/finish → local player/fog/Main cleanup → лише тоді commit clocks/turn/success. RestoreErrors спостерігає errors, epoch відсікає stale coroutines; failure freeze/leave/fresh menu/explicit retry з retained seat/checkpoint. Повного object-tree rollback немає; timeout180s кооперативний, не перериває native hang/OOM. Старі твердження «false restore завжди advances» та «chunks unbounded» вже не описують цей код.

## Save/load

[Save](../../../game/game/save.gd) і [SaveSlots](../../../game/game/save_slots.gd) прочитані повністю на172df65; v0.36 зміни мають окремий targeted review/tests. FORMAT1 disk: u32 MAGIC827541060 (DFS1) → Godot Variant header → u64 raw length →16bytes MD5 compressed →u64 compressed length → ZSTD Variant body `{format,core,sys,ents}`. MD5 перевіряє corruption, не authenticity. `_open` raw limit1GiB; disk `_sound` значно вужчий за повну nested schema.

Entity graph whitelist: Country/City/Facility/Unit/Drone/Missile/Aircraft/Bridge/Rng; `\u0001r` index, спочатку allocate усі entities, потім fill. Property names/class_name/enum ordinal — compatibility. Ship не ENTITY: Navy.save_state → Ship.to_dict/FIELDS, owner **c**. Dynamic systems: explicit ORDER mil/econ/rail/army/defense/diplo/ai/session/vision/**seasons/chronicle**, далі non-Node objects із save_state+load_state. Air усередині Military; Ports/Trade331/Upkeep усередині Economy.

Restore: settings/cfg → new_world(regenerate height) → load core arrays/entities/RNG/refs → systems у порядку → terrain/objects/roads/flags → Air.after_load/army groups → camera/HUD/local mode reset. MP додатково rebinding local player/fog і cleanup caches. Disk slot fallback обирається до staged load; deep stage failure не є загальною транзакцією.

Шляхи: `user://saves/slot_1..5.save`, a0/a1/a2, bak/tmp/meta/png; legacy match.save мігрується на копіях; MP окремий `user://net_match.save`; prefs settings.cfg, pc_port.cfg, net.cfg; accounts/private state у account.bin/attest.bin/ranked_pending.bin не читати для QA. Continue: найсвіжіший slot зі state=ok, fallback preferred/seq/date/bak/tmp. Bad candidate не видаляється; bad slot flag після всіх непридатних копій.

Manual save synchronous; autosave60 real seconds (+до20 touch-idle), синхронний snapshot builder на main → _queue_write duplicate(true) всього encoded body/header/thumbnail → worker serialize/compress/write; жодної копії на кожному simulation tick. Fresh before_write видаляє старі copies до final rename; rotation/meta/migration мають unchecked operations. NetConfig.save_match remove-before-rename без backup. Це актуальні durability gaps; power-loss/ENOSPC не тестували.

Optional `sys.diplo.land_cooldowns` явно копіюється й prevalidated; missing→empty. Key canonical positive1..255 from:to, різні IDs, finite timestamp0..saved game_time; hash sorted. Старий reader може втратити поле, тому **semantic downgrade UNSUPPORTED** без зміни FORMAT number.

## Карта механік і verification boundary

Позначення: IMPLEMENTED = наявні state/caller/code route; **це не runtime PASS**. PARTIAL = конкретно обмежений контракт. UNVERIFIED = деталі не підтверджено цим читанням. Початкові suites були SKIP без engine; тепер beta CI43 tests/2476 checks PASS. Назва fixture не означає full coverage системи; ручні cases лишаються NOT RUN. S=`tests/test_godot_suite.gd` (іменовані step cases), C=`test_pr10_critical.gd`, B=`test_phase5b2_gameplay.gd`, P=`tools/performance_regression.gd`.

| Система / статус | Файли/класи і state | Caller → зміна світу | MP / serialization | Наявні тести / обмеження |
|---|---|---|---|---|
| Генерація/території IMPLEMENTED; деталі PARTIAL review | world/world_gen.gd, world_gen2.gd, WorldSettings/WorldData; gw_infra/gw_states | new_world→height/biome/owners, found/capture→flags/cities/facilities | Так; settings + saved arrays/entities, height regenerate | P water/land/colonies; whole cross-platform generation UNVERIFIED |
| Країни/міста IMPLEMENTED | Country, City; gw_states | Main capital / AI towns / capture; resources/owner/elimination | Так; ENTITY refs, city_ids/frontier | S city/bots; full capture side effects не reviewed |
| AI IMPLEMENTED; branches PARTIAL review | ai.gd/AiBots, ai_persona, Cad344, BridgeGuard; personas/timers/continuations | World.ai.update→8 think phases, buy/build/war/fronts | Так; ai.save_state; Cad344 phase queues не saved | P colony fairness; all strategies/11-bot soak NOT RUN |
| Економіка/ресурси IMPLEMENTED | economy.gd + eco_*; Country stocks, deposits, trade, trucks | econ.update→production10s/trade16s, supply/power gates, food/upgrades | Так; sys.econ + nested ports/trd/upk | P inventory; S deposits; balance/full trade UNVERIFIED |
| Енергетика/будівництво IMPLEMENTED | Military/mil_build, Nuclear, Facility/Country power/fuel | mil.update power/fuel/production; build validates/payment/terrain/registry | Так; mil state/entities, nuclear fields | S air/deposits/nukes; B05 actual airport route; full grids NOT RUN |
| Upkeep IMPLEMENTED | upkeep335.gd; account/tally/reactivation/grace state | Economy.upk.update→money/materials/mothball/reactivate | Так; sys.econ.u335 | test_upkeep_fallback.gd; lazy tally confirmed, p99 не certified, виміряна early-world CPU regression |
| Наземні війська IMPLEMENTED | Army, Unit, ArmyFire/Tac/Reinf/Groups, Operations; units/fronts/orders | army/ops.update→train/path/combat/siege/capture | Так; Army/Operations state + Unit ENTITY | S/P command/spatial; повний damage/balance UNVERIFIED |
| Дрони/ракети IMPLEMENTED | Military/DroneBrain, Drone/Missile; launchers/queues/flight | mil.update→production/launch/flight/impact | Так; mil + entities/brain | S codec/hash; ranges/weapon interactions PARTIAL review |
| Авіація/десант IMPLEMENTED | Air/Aircraft, AirDuel/AirWreck; base/state/payload/target | Military.air.update; rebase/order_airdrop/_drop_paratroops | Так; Military air dump + Aircraft refs | S3; B07R/A, C carrier; flight lifetime/foreign/full bases QA |
| ППО/ПРО IMPLEMENTED | Defense/Protect/SkyCover, Facility ammo/rules, shots | Defense.update/update_shots; Zaslon targeting | Так; defense state, Facility fields | S1/S2; finite/damage/late swarm QA |
| Флот/авіаносці IMPLEMENTED | Navy/Ship/NavyFleets/Art; ships/fleet/queues/carrier_id | Navy.update→production/navigation/combat/service; sink wing→compatible own base або DEAD | Так; sys.navy + Ship FIELDS, aircraft у mil | S3, C Ship/Chronicle/loss; AI wing caller UNVERIFIED |
| Морські експедиції IMPLEMENTED | Naval; expeditions/aboard troops/colonies | Naval.update/launch_expedition→sea travel/landing | Так; sys.naval | S3 частково; не плутати з Navy combat або Ports trade |
| Nuclear IMPLEMENTED | nuclear.gd; Country Pu/readiness, Facility silo fields, gw.nuke_zones | mil/Nuclear ticks + cmd_nuke_*→build120/arm120/reload90; MIRV2decoys/EMP75s/NPP crisis, impact/radiation | Так; entities + core.nuke_zones | S2; великий nuclear/ABM матч NOT RUN |
| Дипломатія/альянси IMPLEMENTED; branches PARTIAL review | Diplomacy/dip_*; treaties/relations/offers/AllyCare/Rift/PeaceConf | diplo.update/commands→war/truce/trade/passage/subjects | Так; sys.diplo + nested helpers | S/C land cases; усі political side effects UNVERIFIED |
| Land deals IMPLEMENTED; evacuation PARTIAL | land_trade.gd + Diplomacy; pending terms/_last_deal | human recipient→offer→answer_as→revalidate→transfer, AI valuation direct | Так; t_offers + optional cooldown/hash | C consent/replay; B06 persistence; evacuation full/compatibility needs QA |
| Ідеології PARTIAL | ideology.gd, Country.ideology, monuments | production/cost/speed/recruit/opinion modifiers | Так; Country ENTITY | S4; description nationalism defense+8%, defense hook не знайдений у helper; damage integration UNVERIFIED |
| Сезони IMPLEMENTED; frozen rivers PARTIAL | seasons.gd, weather_fx, season shader; snow/rain/phase | _sim_step→Seasons.step→farm_mul; render uniforms only | Так; sys.seasons + hash | S4/C render farm; biome/nav freeze не встановлений, текст UI не є реалізацією |
| Chronicle PARTIAL; command replay не реалізований цим класом | chronicle.gd / UI viewer; frames/events/meta | step SP починає з4sim-s; при450frames compaction проріджує history й збільшує interval до64s; archive .dfchr GZIP | Code skip net_driven; sys.chronicle + user://chronicles | S5/C ships; viewer/long match NOT RUN; v0.36 має compaction і serialized sample_dt/sample_t |
| Save/Continue IMPLEMENTED, durability PARTIAL | Save/SaveSlots/NetConfig | manual/auto/load/continue/network resume | SP/MP різні envelopes, shared snapshot systems | P/C save_continue/B06/R02; fault/deep malformed/legacy matrix NOT RUN |
| HUD/Menus/камера IMPLEMENTED; visual UNVERIFIED | Hud extends/UI24, Menus, MapCamera, PcPort | signals/input→mode/queue; camera screen↔world/scale | Переважно presentation; previews/shared static потребують guards | B UI routes, S helpers; 18 Windows manual cases NOT RUN |
| Rendering/audio/localization IMPLEMENTED; quality UNVERIFIED | world layers/shaders, Sfx/Loc/PO/atlases | World._ready layers, draw/LOD; Sfx attached world, Loc.bus/i18n refresh | Presentation; не вважати всі side effects isolated | 93JSON/4PO/210maps static; GPU/audio/video/input NOT RUN |

Відсутність повного ручного review допоміжного файла не означає BROKEN. Водночас наявність UI-кнопки, class_name чи старого PASS не підвищує статус до перевіреної поведінки. Наступна зміна конкретної механіки вимагає дочитати її повні залежності й serialization.

## v0.36 — наскрізні зміни

- Identity узгоджено між Menus/version.cfg/build/CI; actual embedded identity перевіряє tools/ci/verify_build.py. Різні old/current identities відхиляються ENet hello/resume; same SIM_REV не fingerprint.
- Power UI → call_sim("", "cmd_power_prio", [Country, priority]) → host sender slot → canonical turn → wire precheck → NetCodec canonical Country → exact owner/int0..2 schema → cmd_power_prio. Host authoritative admission/order, кожен peer виконує ту саму validation/simulation; int(Country) прибрано.
- Navy sea_path рахує загрози з current authoritative state; unsaved TTL caches прибрано. Repeated load_state очищає weight generation marks/counts. Geo cache/fast LOS лишилися; regression порівнює routes/hash/RNG після restore.
- UrbanHold sys.hold.far_fail optional: save/load/default empty/preflight, stale local cooldown замінюється. Транзитний scratch очищується, full state нового cooldown канонічно хешується. FORMAT1 не збільшено; downgrade unsupported.
- Нові T3 profiles, power priority, refinery fuel buffers/convoys, nuclear warheads/timers/Zaslon queue/NPP overheat/EMP/pledges входять у entities або system saves та v036_state hash. [Exact fixes/tests/limits](V036_FIX_RESULTS.md). П’ять HIGH закриті; це не повний simulation equivalence proof.
