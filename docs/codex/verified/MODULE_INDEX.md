# Індекс усіх GDScript модулів

Лексична карта на `af1b4c9`, 2026-11-19. Кожен tracked `.gd` має рядок. Це navigation, не додаткова заява про ручне читання. Inheritance paths наведені як у source, від `res://`=game/. Підсистеми та межі ownership — ARCHITECTURE/GAMEPLAY_SYSTEMS.

| Шлях | Клас / extends | Рядків / functions | Вхідні точки / state codec |
|---|---|---:|---|
| `game/core/air_sfx.gd` | AirSfx / `RefCounted` | 129 / 5 | `_init:41`, `tick:54` |
| `game/core/flag_maker.gd` | FlagMaker / `RefCounted` | 643 / 21 | `make:19`, `col:296`, `encode:303` |
| `game/core/hash32.gd` | Hash32 / `RefCounted` | 19 / 2 | `mix:8`, `h2:18` |
| `game/core/loc.gd` | Loc / `RefCounted` | 554 / 43 | `boot:57`, `norm:80`, `cur:87` |
| `game/core/name_gen.gd` | NameGen / `RefCounted` | 357 / 17 | `_cap:13`, `city:28`, `_east_fix:37` |
| `game/core/navy_sfx.gd` | NavySfx / `RefCounted` | 295 / 14 | `_init:43`, `tick:61` |
| `game/core/palette.gd` | Palette / `RefCounted` | 19 / 2 | `ensure_loaded:8`, `c:17` |
| `game/core/rng.gd` | Rng / `RefCounted` | 60 / 7 | `_init:14` |
| `game/core/sfx.gd` | Sfx / `Node` | 1182 / 54 | `_ready:966`, `_process:971` |
| `game/core/soundscape.gd` | Soundscape / `RefCounted` | 306 / 8 | `_init:60`, `tick:78` |
| `game/core/sprite_atlas.gd` | SpriteAtlas / `RefCounted` | 48 / 5 | `load_atlas:10`, `has:31`, `info:35` |
| `game/game/ad_relocate.gd` | — / `RefCounted` | 398 / 18 | `movable:32`, `_note:36`, `clear_site:41` |
| `game/game/ad_trip.gd` | — / `RefCounted` | 225 / 13 | `_init:30`, `update:85`, `save:213` |
| `game/game/aftermath.gd` | — / `RefCounted` | 775 / 35 | `_init:64`, `update:69`, `save_state:704`, `load_state:709` |
| `game/game/ai.gd` | AiBots / `RefCounted` | 2833 / 93 | `_init:16`, `save_state:366`, `load_state:374`, `update:435` |
| `game/game/ai_persona.gd` | AiPersona / `RefCounted` | 57 / 4 | `by_id:34`, `shown:42`, `ids:46` |
| `game/game/air.gd` | Air / `RefCounted` | 2609 / 118 | `_init:142`, `update:397` |
| `game/game/air_duel.gd` | AirDuel / `RefCounted` | 197 / 12 | `_init:36` |
| `game/game/air_wreck.gd` | — / `RefCounted` | 235 / 14 | `_init:38`, `update:123`, `save_state:217`, `load_state:221` |
| `game/game/aircraft.gd` | Aircraft / `RefCounted` | 80 / 2 | `airborne:73`, `update_frame:77` |
| `game/game/alliances.gd` | — / `RefCounted` | 826 / 49 | `_init:58`, `tick:504`, `save:782` |
| `game/game/ally_care.gd` | — / `RefCounted` | 422 / 20 | `_init:67`, `update:258`, `save_state:398`, `load_state:407` |
| `game/game/ally_rift.gd` | — / `RefCounted` | 425 / 22 | `_init:44`, `tick:212`, `save_state:396`, `load_state:400` |
| `game/game/arch_style.gd` | ArchStyle / `RefCounted` | 379 / 17 | `_init:57`, `update:241`, `save_state:348`, `load_state:362` |
| `game/game/army.gd` | Army / `RefCounted` | 2604 / 118 | `_init:120`, `update:362`, `save_state:2082`, `load_state:2086` |
| `game/game/army_fire.gd` | — / `RefCounted` | 784 / 37 | `_init:51`, `update:88` |
| `game/game/army_groups.gd` | — / `RefCounted` | 724 / 37 | `_country:20`, `groups:24`, `by_id:29` |
| `game/game/army_reinf.gd` | — / `RefCounted` | 354 / 13 | `_init:30`, `tick:34` |
| `game/game/army_tac.gd` | — / `RefCounted` | 972 / 36 | `_init:29`, `update:368` |
| `game/game/auto_cmd.gd` | — / `RefCounted` | 591 / 17 | `tick:47` |
| `game/game/battle_watch.gd` | BattleWatch / `RefCounted` | 493 / 24 | `_init:28`, `save_state:479`, `load_state:487` |
| `game/game/border_fill.gd` | — / `RefCounted` | 1074 / 14 | `scan:36`, `_box:133`, `_seal:476` |
| `game/game/border_gap.gd` | — / `RefCounted` | 316 / 14 | `reach:14`, `ctx:20`, `may_claim:44` |
| `game/game/border_posts.gd` | BorderPosts / `RefCounted` | 584 / 25 | `_init:62`, `update:128`, `save_state:535`, `load_state:545` |
| `game/game/bridge.gd` | Bridge / `RefCounted` | 150 / 11 | `start_rebuild:41`, `end_t:78`, `rebuild_time:86` |
| `game/game/bridge_guard.gd` | — / `RefCounted` | 552 / 21 | `_init:53`, `save_state:57`, `load_state:73` |
| `game/game/cad344.gd` | — / `RefCounted` | 125 / 8 | `_init:56` |
| `game/game/city.gd` | City / `RefCounted` | 52 / 1 | `garrison_cap:46` |
| `game/game/colony_look.gd` | — / `RefCounted` | 95 / 4 | `is_poor:23`, `poorer:31`, `_fill:63` |
| `game/game/country.gd` | Country / `RefCounted` | 146 / 7 | `_mlog:30`, `has_res:100`, `pay_res:107` |
| `game/game/defense.gd` | Defense / `RefCounted` | 871 / 40 | `_init:131`, `_ready:139`, `update:318` |
| `game/game/depot.gd` | — / `RefCounted` | 472 / 32 | `is_depot:40`, `cap_of:44`, `fits_type:49` |
| `game/game/dip_react.gd` | — / `RefCounted` | 1186 / 58 | `_init:85`, `update:728`, `save_state:1119`, `load_state:1133` |
| `game/game/dip_requests.gd` | — / `RefCounted` | 1699 / 75 | `_init:76`, `update:1578`, `save_state:1605`, `load_state:1613` |
| `game/game/diplomacy.gd` | Diplomacy / `"res://game/diplomacy/dip_allies.gd"` | 1636 / 48 | `update:59`, `save_state:619`, `load_state:636` |
| `game/game/diplomacy/dip_allies.gd` | — / `"res://game/diplomacy/dip_rules.gd"` | 1511 / 87 | `declare_war:6`, `ai_accepts:89`, `on_attack:125` |
| `game/game/diplomacy/dip_base.gd` | — / `RefCounted` | 564 / 44 | `_init:139` |
| `game/game/diplomacy/dip_rules.gd` | — / `"res://game/diplomacy/dip_base.gd"` | 1474 / 84 | `_set_rel:4`, `_offense_ok:39`, `_offense_why:51` |
| `game/game/drone.gd` | Drone / `RefCounted` | 63 / 3 | `update_frame:47`, `airborne:53`, `remaining_len:57` |
| `game/game/drone_brain.gd` | DroneBrain / `RefCounted` | 693 / 37 | `_init:105`, `save_state:687`, `load_state:691` |
| `game/game/econ_guide.gd` | EconGuide / `RefCounted` | 1768 / 74 | `_init:51`, `update:357`, `save_state:1755`, `load_state:1759` |
| `game/game/econ_rates.gd` | — / `RefCounted` | 488 / 19 | `level_mul:47`, `state_of:52`, `state_text:65` |
| `game/game/economy.gd` | Economy / `"res://game/economy/eco_trade.gd"` | 521 / 21 | `_init:12`, `update:21`, `save_state:353`, `load_state:361` |
| `game/game/economy/eco_base.gd` | — / `RefCounted` | 385 / 0 | Поля/константи; без top-level functions |
| `game/game/economy/eco_core.gd` | — / `"res://game/economy/eco_base.gd"` | 1937 / 116 | `site_text:4`, `site_code:9`, `is_enterprise:16` |
| `game/game/economy/eco_trade.gd` | — / `"res://game/economy/eco_core.gd"` | 1605 / 71 | `trading:6`, `set_trade:10`, `req_to:24` |
| `game/game/facility.gd` | Facility / `RefCounted` | 147 / 7 | `is_line:121`, `origin_px:125`, `center_px:129` |
| `game/game/front_plan.gd` | — / `RefCounted` | 3876 / 123 | `tick:1665`, `_run:2912` |
| `game/game/game_config.gd` | GameConfig / `RefCounted` | 232 / 17 | `autodig_on:34`, `infinite_res:45`, `reserve_mul:50` |
| `game/game/game_world.gd` | GameWorld / `"res://game/game_world/gw_states.gd"` | 551 / 14 | `_ready:7`, `_process:360` |
| `game/game/game_world/gw_base.gd` | — / `Node2D` | 339 / 0 | Поля/константи; без top-level functions |
| `game/game/game_world/gw_infra.gd` | — / `"res://game/game_world/gw_map.gd"` | 1100 / 47 | `found_city:5`, `_apply_plan:78`, `road_async:141` |
| `game/game/game_world/gw_map.gd` | — / `"res://game/game_world/gw_base.gd"` | 908 / 41 | `_add_object_id:6`, `add_object:35`, `remove_object:42` |
| `game/game/game_world/gw_states.gd` | — / `"res://game/game_world/gw_infra.gd"` | 960 / 38 | `_as_gw:8`, `create_country:13`, `spawn_ai_countries:37` |
| `game/game/main.gd` | — / `"res://game/main/main_input.gd"` | 1645 / 31 | `_ready:8`, `_process:401`, `_unhandled_input:1189` |
| `game/game/main/main_base.gd` | — / `Node` | 200 / 0 | Поля/константи; без top-level functions |
| `game/game/main/main_core.gd` | — / `"res://game/main/main_base.gd"` | 1010 / 52 | `_snd:5`, `_navy_snap:8`, `_army_back:22` |
| `game/game/main/main_input.gd` | — / `"res://game/main/main_strike.gd"` | 1010 / 29 | `_tap:4`, `_far_zoom:271`, `_dep_pin_hit:276` |
| `game/game/main/main_strike.gd` | — / `"res://game/main/main_core.gd"` | 791 / 37 | `_end_drag:4`, `_missile_multi_card:68`, `_missile_multi_launch:88` |
| `game/game/match.gd` | Match / `RefCounted` | 325 / 18 | `_init:24`, `update:47` |
| `game/game/military.gd` | Military / `"res://game/military/mil_strike.gd"` | 1133 / 47 | `_init:13`, `update:21`, `save_state:1119`, `load_state:1123` |
| `game/game/military/mil_base.gd` | — / `RefCounted` | 416 / 0 | Поля/константи; без top-level functions |
| `game/game/military/mil_build.gd` | — / `"res://game/military/mil_base.gd"` | 1800 / 101 | `cost_of:4`, `size_of:8`, `title_of:14` |
| `game/game/military/mil_strike.gd` | — / `"res://game/military/mil_build.gd"` | 1148 / 59 | `parked_count:6`, `stock_count:14`, `next_drone_in:22` |
| `game/game/missile.gd` | Missile / `RefCounted` | 72 / 7 | `u:33`, `ground:37`, `alt:42` |
| `game/game/nature.gd` | — / `RefCounted` | 368 / 20 | `_init:45`, `update:150`, `save_state:317`, `load_state:338` |
| `game/game/naval.gd` | Naval / `RefCounted` | 1759 / 71 | `_init:78`, `update:583`, `save_state:1748`, `load_state:1752` |
| `game/game/navy.gd` | Navy / `RefCounted` | 3064 / 156 | `_init:174`, `update:1396`, `save_state:3003`, `load_state:3014` |
| `game/game/navy_art.gd` | NavyArt / `RefCounted` | 859 / 34 | `_init:70`, `tick:200`, `save:828`, `load:832` |
| `game/game/navy_fleets.gd` | NavyFleets / `RefCounted` | 940 / 39 | `_init:45`, `tick:271`, `_run:391`, `save:917`, `load:921` |
| `game/game/navy_strike.gd` | — / `RefCounted` | 393 / 16 | `_owner_at:11`, `_cname:17`, `plan:25` |
| `game/game/nuclear.gd` | Nuclear / `RefCounted` | 441 / 19 | `build_parts:52`, `ambient:70`, `steam_points:76` |
| `game/game/operations.gd` | Operations / `RefCounted` | 3352 / 130 | `_init:141`, `update:1680`, `save_state:3256`, `load_state:3290` |
| `game/game/peace_conf.gd` | — / `RefCounted` | 1369 / 57 | `_init:56`, `update:135`, `save_state:1307`, `load_state:1321` |
| `game/game/port.gd` | Ports / `RefCounted` | 857 / 46 | `_init:43`, `update:449` |
| `game/game/power_status.gd` | PowerStatus / `RefCounted` | 744 / 37 | `_init:124`, `update:277`, `save_state:709`, `load_state:715` |
| `game/game/protect.gd` | Protect / `RefCounted` | 961 / 39 | `_init:126`, `update:615`, `save_state:903`, `load_state:925` |
| `game/game/rail.gd` | Rail / `RefCounted` | 2381 / 97 | `_init:98`, `update:483`, `save_state:2040`, `load_state:2061` |
| `game/game/rail_troops.gd` | — / `RefCounted` | 828 / 49 | `_init:44`, `update:461`, `save_state:797`, `load_state:801` |
| `game/game/ranked_rules.gd` | RankedRules / `RefCounted` | 176 / 14 | `active:13`, `save_player_cfg:23`, `clear:31` |
| `game/game/recon.gd` | Recon / `RefCounted` | 873 / 49 | `_init:92`, `update:331`, `save_state:805`, `load_state:834` |
| `game/game/road_detour.gd` | — / `RefCounted` | 221 / 4 | `plan:19`, `_plan:26`, `_astar:144` |
| `game/game/save.gd` | Save / `RefCounted` | 1234 / 53 | `tick:177`, `_snapshot:638` |
| `game/game/save_slots.gd` | — / `RefCounted` | 466 / 23 | `path:33`, `_dir:48`, `peek:57` |
| `game/game/ship.gd` | Ship / `RefCounted` | 95 / 6 | `alive:58`, `has_mod:62`, `count_mod:66` |
| `game/game/sky_cover.gd` | — / `RefCounted` | 1000 / 53 | `_init:71`, `update:704`, `save:945` |
| `game/game/strike_hub.gd` | — / `RefCounted` | 450 / 24 | `_ready:138`, `tick:399` |
| `game/game/strike_sense.gd` | — / `RefCounted` | 217 / 15 | `_init:39` |
| `game/game/supply.gd` | Supply / `RefCounted` | 2062 / 84 | `_init:177`, `update:254`, `save_state:2005`, `load_state:2014` |
| `game/game/trade331.gd` | — / `RefCounted` | 1023 / 54 | `_init:63`, `update:953`, `save_state:965`, `load_state:970` |
| `game/game/unit.gd` | Unit / `RefCounted` | 89 / 7 | `ground:62`, `air:66`, `foot:71` |
| `game/game/upkeep335.gd` | — / `RefCounted` | 1047 / 62 | `_init:153`, `save_state:170`, `load_state:178`, `update:205` |
| `game/game/urban.gd` | Urban / `RefCounted` | 422 / 24 | `_init:29`, `tick:57` |
| `game/game/urban_hold.gd` | — / `RefCounted` | 1032 / 44 | `_init:58`, `update:225`, `save_state:954`, `load_state:978` |
| `game/game/vision.gd` | Vision / `RefCounted` | 731 / 48 | `_init:82`, `update:303`, `save_state:650`, `load_state:697` |
| `game/game/world_drama.gd` | — / `RefCounted` | 2409 / 107 | `_init:68`, `update:454`, `save_state:2359`, `load_state:2365` |
| `game/net/account.gd` | Account / `RefCounted` | 418 / 40 | `load_state:22` |
| `game/net/api.gd` | Api / `Node` | 164 / 10 | `i:23`, `user_agent:32`, `_ua_model:41` |
| `game/net/device_check.gd` | DeviceCheck / `RefCounted` | 143 / 11 | `dev:17`, `available:21`, `headers:30` |
| `game/net/dip_chat.gd` | DipChat / `RefCounted` | 374 / 27 | `_init:46` |
| `game/net/ed25519.gd` | Ed25519 / `RefCounted` | 414 / 26 | `prepare:51`, `verify:62`, `_gf:87` |
| `game/net/lan_discovery.gd` | LanDiscovery / `Node` | 164 / 11 | `_process:87` |
| `game/net/net_codec.gd` | NetCodec / `RefCounted` | 113 / 4 | `encode:15`, `decode:45`, `_dec:50` |
| `game/net/net_config.gd` | NetConfig / `RefCounted` | 200 / 13 | `load_cfg:52`, `clean_code:70`, `version:84` |
| `game/net/net_hash.gd` | NetHash / `RefCounted` | 218 / 4 | `of:9`, `diplo_nums:52`, `parts:93` |
| `game/net/net_session.gd` | NetSession / `Node` | 3045 / 154 | `_process:2089`, `_run:2226` |
| `game/net/net_tls.gd` | NetTls / `RefCounted` | 32 / 1 | `for_url:20` |
| `game/net/ranked.gd` | Ranked / `RefCounted` | 118 / 13 | `fetch_me:18`, `mode_row:27`, `calibration_games:35` |
| `game/net/reports.gd` | Reports / `RefCounted` | 61 / 4 | `key:18`, `send_user:23`, `send_server:34` |
| `game/net/room_browser.gd` | RoomBrowser / `Node` | 158 / 7 | `_process:105` |
| `game/net/rtc_link.gd` | RtcLink / `Node` | 538 / 30 | `_process:214` |
| `game/net/server/signal_server.gd` | — / `SceneTree` | 406 / 14 | `_process:97` |
| `game/net/ws_tunnel_peer.gd` | WsTunnelPeer / `MultiplayerPeerExtension` | 175 / 26 | `_init:24` |
| `game/pc/army_select.gd` | — / `Control` | 681 / 30 | `_process:167` |
| `game/pc/pc_port.gd` | — / `Node` | 152 / 14 | `_ready:46`, `_input:105` |
| `game/pc/steam_mock.gd` | — / `RefCounted` | 245 / 27 | `port_of:26`, `steamInitEx:30`, `_first_lobby:50` |
| `game/pc/steam_net.gd` | — / `Node` | 253 / 20 | `_ready:41`, `_process:84` |
| `game/pc/steam_peer.gd` | — / `MultiplayerPeerExtension` | 336 / 31 | `peer_id_of:41`, `create_host:46`, `create_client:56` |
| `game/pc/updater.gd` | — / `Node` | 436 / 24 | `_ready:55`, `_run:125`, `_process:277` |
| `game/ui/cosmetics.gd` | Cosmetics / `RefCounted` | 106 / 10 | `_load:17`, `item:28`, `known:33` |
| `game/ui/custom_bots.gd` | CustomBots / `RefCounted` | 624 / 24 | `money_text:18`, `money_i:22`, `names_taken:30` |
| `game/ui/flag_editor.gd` | FlagEditor / `RefCounted` | 963 / 41 | `_init:127` |
| `game/ui/hud.gd` | Hud / `"res://ui/hud/hud_lane.gd"` | 687 / 13 | `_process:411`, `_input:626` |
| `game/ui/hud/hud_army.gd` | — / `"res://ui/hud/hud_dip.gd"` | 237 / 9 | `_build_army24:4`, `open_navy_yard:31`, `open_navy_dock:44` |
| `game/ui/hud/hud_base.gd` | — / `CanvasLayer` | 470 / 0 | Поля/константи; без top-level functions |
| `game/ui/hud/hud_cards.gd` | — / `"res://ui/hud/hud_ops.gd"` | 872 / 25 | `_card:5`, `show_plan:40`, `show_strike_multi:89` |
| `game/ui/hud/hud_dip.gd` | — / `"res://ui/hud/hud_econ.gd"` | 744 / 17 | `open_diplomacy:4`, `open_my_state:47`, `my_state_closed:72` |
| `game/ui/hud/hud_dock.gd` | — / `"res://ui/hud/hud_keys.gd"` | 218 / 9 | `_build_confirm:5`, `show_confirm:29`, `hide_confirm:42` |
| `game/ui/hud/hud_econ.gd` | — / `"res://ui/hud/hud_stack.gd"` | 312 / 7 | `open_builds:5`, `open_economy:90`, `_econ_fill:173` |
| `game/ui/hud/hud_keys.gd` | — / `"res://ui/hud/hud_army.gd"` | 906 / 32 | `open_command:6`, `open_kind_mass:17`, `_open_command_old:64` |
| `game/ui/hud/hud_kit.gd` | — / `"res://ui/hud/hud_base.gd"` | 496 / 39 | `_safe_margins:4`, `_tooltip_panel:21`, `key_title:29` |
| `game/ui/hud/hud_lane.gd` | — / `"res://ui/hud/hud_cards.gd"` | 334 / 12 | `push_news:6`, `_news_tick:18`, `war_flash:44` |
| `game/ui/hud/hud_ops.gd` | — / `"res://ui/hud/hud_dock.gd"` | 254 / 8 | `_set_res:4`, `open_new_world:20`, `_build_ops:46` |
| `game/ui/hud/hud_stack.gd` | — / `"res://ui/hud/hud_kit.gd"` | 1001 / 49 | `_select_page:4`, `_pc_apply_cols:34`, `_pc_relayout:52` |
| `game/ui/lang_picker.gd` | LangPicker / `CanvasLayer` | 505 / 21 | `_ready:132`, `_process:432` |
| `game/ui/loading.gd` | Loading / `CanvasLayer` | 316 / 11 | `_ready:69`, `_process:251` |
| `game/ui/map_preview.gd` | MapPreview / `RefCounted` | 156 / 4 | `settings_for:29`, `build:46`, `_c:51` |
| `game/ui/menus.gd` | Menus / `CanvasLayer` | 4307 / 135 | `_process:109`, `_input:689` |
| `game/ui/mp_kit.gd` | MpKit / `RefCounted` | 905 / 29 | `_flat:14`, `card_button:25`, `_hbox:40` |
| `game/ui/opening.gd` | Opening / `CanvasLayer` | 239 / 10 | `_ready:53`, `_process:131`, `_input:154` |
| `game/ui/perf_probe.gd` | — / `CanvasLayer` | 331 / 16 | `_ready:71`, `_process:110` |
| `game/ui/report_screen.gd` | ReportScreen / `RefCounted` | 308 / 12 | `_init:23` |
| `game/ui/route_overlay.gd` | RouteOverlay / `Node2D` | 663 / 24 | `_process:39` |
| `game/ui/saves_ui.gd` | — / `RefCounted` | 875 / 33 | `icon:41`, `icon_tex:65`, `dur:78` |
| `game/ui/tutorial.gd` | Tutorial / `CanvasLayer` | 545 / 21 | `_process:241` |
| `game/ui/ui24/ad_rules_sheet.gd` | — / `PanelContainer` | 510 / 20 | `_process:154` |
| `game/ui/ui24/ally_sheet.gd` | — / `Control` | 246 / 5 | `open:24`, `_build:36`, `_place:196` |
| `game/ui/ui24/arm_kit.gd` | — / `RefCounted` | 195 / 15 | `atlas19:30`, `has19:37`, `native:42` |
| `game/ui/ui24/army_budget.gd` | — / `PanelContainer` | 447 / 13 | `_process:53` |
| `game/ui/ui24/army_dock.gd` | — / `Control` | 2377 / 100 | `_process:1745` |
| `game/ui/ui24/army_row.gd` | — / `Button` | 298 / 9 | `_init:41`, `_process:195` |
| `game/ui/ui24/army_sheet.gd` | — / `PanelContainer` | 10 / 1 | `close:8` |
| `game/ui/ui24/army_state.gd` | — / `RefCounted` | 190 / 9 | `gname:25`, `hp_col:29`, `key_of:34` |
| `game/ui/ui24/army_store.gd` | — / `RefCounted` | 197 / 17 | `_init:28` |
| `game/ui/ui24/army_ux.gd` | — / `Node` | 2155 / 91 | `_input:157`, `_process:297` |
| `game/ui/ui24/bar_track.gd` | — / `Control` | 44 / 3 | `_init:24` |
| `game/ui/ui24/build_panel.gd` | — / `RefCounted` | 102 / 5 | `condensed:24`, `fit:37`, `make_tab:49` |
| `game/ui/ui24/cmd_sheet.gd` | — / `Control` | 825 / 33 | `_process:795` |
| `game/ui/ui24/conf_declutter.gd` | — / `RefCounted` | 77 / 5 | `tag:28`, `_tag1:46`, `hold:53` |
| `game/ui/ui24/conference_sheet.gd` | — / `PanelContainer` | 1470 / 63 | `_process:1350` |
| `game/ui/ui24/dip_api.gd` | — / `RefCounted` | 377 / 38 | `_init:34` |
| `game/ui/ui24/dip_chat_view.gd` | — / `VBoxContainer` | 354 / 13 | `_process:205` |
| `game/ui/ui24/dip_page.gd` | — / `RefCounted` | 2813 / 79 | `_init:75` |
| `game/ui/ui24/dip_sheet.gd` | — / `PanelContainer` | 2601 / 101 | `_process:1307` |
| `game/ui/ui24/econ_hub.gd` | — / `PanelContainer` | 1514 / 50 | `_process:210` |
| `game/ui/ui24/econ_kit.gd` | — / `RefCounted` | 103 / 9 | `tex:17`, `icon:26`, `set_icon:34` |
| `game/ui/ui24/front_overlay.gd` | — / `Control` | 1029 / 30 | `_process:81` |
| `game/ui/ui24/help_tips.gd` | — / `Control` | 430 / 23 | `_process:403` |
| `game/ui/ui24/hold_card.gd` | — / `PanelContainer` | 219 / 10 | `_process:71` |
| `game/ui/ui24/hold_tip.gd` | — / `CanvasLayer` | 317 / 15 | `_init:217`, `_process:306` |
| `game/ui/ui24/inbox_sheet.gd` | — / `Control` | 434 / 18 | `_process:400` |
| `game/ui/ui24/jet316_marks.gd` | — / `Control` | 82 / 5 | `tick:18` |
| `game/ui/ui24/map_declutter.gd` | — / `RefCounted` | 137 / 11 | `begin:12`, `note:20`, `pennant_rect:28` |
| `game/ui/ui24/map_pennants.gd` | — / `Control` | 876 / 14 | `_process:60` |
| `game/ui/ui24/my_state.gd` | — / `PanelContainer` | 1952 / 81 | `_process:1744` |
| `game/ui/ui24/navy_dock.gd` | — / `Control` | 2095 / 94 | `_process:2048` |
| `game/ui/ui24/navy_map.gd` | — / `Control` | 438 / 11 | `_process:44` |
| `game/ui/ui24/navy_yard.gd` | — / `Control` | 958 / 40 | `_process:937` |
| `game/ui/ui24/notif_calm.gd` | — / `RefCounted` | 109 / 4 | `level:54`, `news_level:64`, `important:87` |
| `game/ui/ui24/notif_lane.gd` | — / `Control` | 1569 / 58 | `_ready:150`, `_process:977` |
| `game/ui/ui24/path_kit.gd` | — / `RefCounted` | 372 / 15 | `_bucket:22`, `smooth:27`, `simplify:81` |
| `game/ui/ui24/price_spark.gd` | — / `Control` | 90 / 4 | `_init:19` |
| `game/ui/ui24/rail_back.gd` | — / `Control` | 90 / 4 | `_process:28` |
| `game/ui/ui24/rail_build.gd` | — / `RefCounted` | 289 / 22 | `reset:23`, `_cell:29`, `_mins:33` |
| `game/ui/ui24/res_sheet.gd` | — / `VBoxContainer` | 867 / 22 | `setup:66`, `show_res:121`, `stage_id:137` |
| `game/ui/ui24/speed_pick.gd` | — / `Control` | 408 / 16 | `mount:20`, `_label_col:31`, `speed_text:45` |
| `game/ui/ui24/status_watch.gd` | — / `RefCounted` | 229 / 10 | `_init:32`, `tick:36` |
| `game/ui/ui24/strike_marks.gd` | — / `Control` | 133 / 6 | `tick:20` |
| `game/ui/ui24/strike_sheet.gd` | — / `VBoxContainer` | 514 / 16 | `on_open:42`, `setup:47`, `_build_rail:71` |
| `game/ui/ui24/tap_guard.gd` | — / `Node` | 254 / 14 | `_ready:38`, `_input:43`, `_process:240` |
| `game/ui/ui24/trade_sheet.gd` | — / `PanelContainer` | 1771 / 60 | `_process:185` |
| `game/ui/ui24/tutorial_feed.gd` | TutorialFeed / `CanvasLayer` | 944 / 44 | `_ready:121`, `_process:773`, `_unhandled_input:932` |
| `game/ui/ui24/width_guard.gd` | — / `RefCounted` | 132 / 5 | `watch:17`, `check:28`, `_culprit:55` |
| `game/ui/ui_kit.gd` | UiKit / `RefCounted` | 795 / 35 | `ensure:59`, `tap_begin:147`, `snd:156` |
| `game/world/ad_cover_layer.gd` | AdCoverLayer / `Node2D` | 207 / 9 | `_ready:32`, `_process:51` |
| `game/world/aftermath_draw.gd` | — / `RefCounted` | 709 / 19 | `_wreck_sprite:29`, `draw:61`, `_draw_all:67` |
| `game/world/air_duel_layer.gd` | AirDuelLayer / `RefCounted` | 73 / 3 | `_push:17`, `_prune:30`, `draw:46` |
| `game/world/air_wreck_draw.gd` | — / `RefCounted` | 369 / 10 | `_ac_sprite:18`, `_drone_sprite:29`, `_spr:39` |
| `game/world/biome.gd` | Biome / `RefCounted` | 62 / 6 | `is_water:11`, `is_open_sea:15`, `is_natural_land:19` |
| `game/world/capture_layer.gd` | — / `Node2D` | 774 / 16 | `_process:55` |
| `game/world/city_gen.gd` | CityGen / `RefCounted` | 482 / 11 | `params:31`, `plan:40`, `_run_entry:144` |
| `game/world/city_power_layer.gd` | CityPowerLayer / `Node2D` | 129 / 7 | `_ready:42`, `_process:79` |
| `game/world/color_grade.gd` | ColorGrade / `RefCounted` | 37 / 2 | `tint_at:19`, `tint:33` |
| `game/world/conf_map_layer.gd` | — / `Node2D` | 379 / 13 | `_process:263` |
| `game/world/cover_draw.gd` | — / `RefCounted` | 72 / 6 | `begin:17`, `_top:22`, `blit:29` |
| `game/world/decal_layer.gd` | DecalLayer / `Node2D` | 301 / 10 | `_ready:60`, `_process:84` |
| `game/world/dmg_stages.gd` | DmgStages / `RefCounted` | 193 / 7 | `register:41`, `reset:93`, `_check:100` |
| `game/world/eco_layer.gd` | EcoLayer / `Node2D` | 479 / 13 | `_process:33` |
| `game/world/econ_fx_layer.gd` | EconFxLayer / `Node2D` | 294 / 9 | `_process:50` |
| `game/world/fauna_layer.gd` | FaunaLayer / `Node2D` | 835 / 33 | `_process:90` |
| `game/world/flora.gd` | Flora / `RefCounted` | 132 / 4 | `load_atlas:17`, `register:27`, `ready:68` |
| `game/world/fog_layer.gd` | FogLayer / `Node2D` | 295 / 10 | `_process:76` |
| `game/world/fort_layer.gd` | FortLayer / `Node2D` | 183 / 6 | `_process:17` |
| `game/world/fx_layer.gd` | FxLayer / `Node2D` | 307 / 15 | `_process:198` |
| `game/world/ground_layer.gd` | GroundLayer / `Node2D` | 31 / 1 | `_draw:9` |
| `game/world/hold_layer.gd` | — / `Node2D` | 238 / 6 | `_process:42` |
| `game/world/labels_layer.gd` | LabelsLayer / `Node2D` | 1394 / 44 | `_process:218` |
| `game/world/life_layer.gd` | LifeLayer / `Node2D` | 566 / 22 | `_process:43` |
| `game/world/map_camera.gd` | MapCamera / `Camera2D` | 409 / 34 | `_ready:113`, `_input:156`, `_process:376` |
| `game/world/map_icons.gd` | MapIcons / `Node2D` | 303 / 12 | `_process:94` |
| `game/world/map_mode_layer.gd` | MapModeLayer / `Node2D` | 732 / 23 | `_ready:68`, `_process:167` |
| `game/world/nature_layer.gd` | — / `Node2D` | 305 / 14 | `_ready:75`, `_process:88` |
| `game/world/naval_layer.gd` | NavalLayer / `Node2D` | 250 / 10 | `_ready:56`, `_process:93` |
| `game/world/navy_layer.gd` | NavyLayer / `Node2D` | 1068 / 30 | `_ready:69`, `_process:115` |
| `game/world/night_layer.gd` | NightLayer / `Node2D` | 873 / 37 | `_ready:31`, `_process:87` |
| `game/world/obj_chunk.gd` | ObjChunk / `Node2D` | 295 / 10 | `mark:46`, `_draw:57`, `_depth_sort:96` |
| `game/world/objects_layer.gd` | ObjectsLayer / `Node2D` | 224 / 9 | `_process:66` |
| `game/world/ops_layer.gd` | OpsLayer / `Node2D` | 579 / 27 | `_process:30` |
| `game/world/protect_layer.gd` | ProtectLayer / `Node2D` | 384 / 16 | `_process:67` |
| `game/world/rail_layer.gd` | RailLayer / `Node2D` | 394 / 16 | `tick:128` |
| `game/world/rail_view332.gd` | — / `RefCounted` | 429 / 18 | `atlas:23`, `icon:31`, `icon_screen:42` |
| `game/world/recon_layer.gd` | ReconLayer / `Node2D` | 129 / 6 | `_process:14` |
| `game/world/sky_cover_layer.gd` | — / `Node2D` | 338 / 12 | `_ready:84`, `_process:152` |
| `game/world/status_mark.gd` | — / `RefCounted` | 66 / 6 | `_src:14`, `_pstat:28`, `tier:36` |
| `game/world/strat_layer.gd` | — / `Node2D` | 316 / 13 | `_ready:62`, `_process:91` |
| `game/world/strat_modes.gd` | — / `Node2D` | 609 / 19 | `_ready:45`, `tick:73` |
| `game/world/strat_terrain.gd` | — / `RefCounted` | 229 / 5 | `palette:57`, `build:65`, `_down:122` |
| `game/world/terrain_view.gd` | TerrainView / `Sprite2D` | 692 / 22 | `_init:67`, `_run:239` |
| `game/world/top_layer.gd` | TopLayer / `Node2D` | 109 / 6 | `_ready:11`, `_process:63` |
| `game/world/trade_layer.gd` | TradeLayer / `Node2D` | 274 / 11 | `_process:27` |
| `game/world/train_layer.gd` | TrainLayer / `Node2D` | 90 / 4 | `_process:11` |
| `game/world/units_layer.gd` | UnitsLayer / `Node2D` | 1312 / 47 | `_ready:61`, `_process:77` |
| `game/world/vfx.gd` | Vfx / `RefCounted` | 439 / 24 | `tick:292`, `save_state:415`, `load_state:425` |
| `game/world/vfx_air.gd` | VfxAir / `Node2D` | 917 / 35 | `_ready:80`, `_process:225` |
| `game/world/vfx_blast.gd` | VfxBlast / `Node2D` | 811 / 30 | `_ready:135`, `_process:367` |
| `game/world/vfx_clouds.gd` | VfxClouds / `Node2D` | 226 / 6 | `_ready:35`, `_process:68` |
| `game/world/vfx_glow.gd` | VfxGlow / `Node2D` | 75 / 3 | `_ready:11`, `_process:31` |
| `game/world/vfx_ground.gd` | VfxGround / `Node2D` | 456 / 16 | `_ready:55`, `_process:81` |
| `game/world/vfx_turret.gd` | VfxTurret / `Node2D` | 688 / 31 | `_ready:80`, `_process:343` |
| `game/world/war_life.gd` | — / `RefCounted` | 118 / 4 | `_build:50`, `tex:73`, `beacon:80` |
| `game/world/world_data.gd` | WorldData / `RefCounted` | 84 / 10 | `_init:38` |
| `game/world/world_gen.gd` | WorldGen / `RefCounted` | 584 / 13 | `generate:10` |
| `game/world/world_gen2.gd` | WorldGen2 / `RefCounted` | 617 / 16 | `isqrt:29`, `isin:41`, `icos:52` |
| `game/world/world_settings.gd` | WorldSettings / `Resource` | 27 / 0 | Поля/константи; без top-level functions |
| `tools/packproj/pack.gd` | — / `SceneTree` | 26 / 2 | `_init:14` |
| `tools/performance_benchmark.gd` | — / `SceneTree` | 114 / 2 | `_run:30` |
| `tools/performance_regression.gd` | — / `SceneTree` | 245 / 12 | `_run:28` |
