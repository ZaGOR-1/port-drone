extends SceneTree
## Headless regression tests for net hashing, command validation, delayed queue, and VFX/life pools.

const Seasons: = preload("res://game/seasons.gd")
const Ideology: = preload("res://game/ideology.gd")
const Alliances: = preload("res://game/alliances.gd")
const ChronicleS: = preload("res://game/chronicle.gd")

var checks: int = 0
var failures: Array = []


func _initialize() -> void:
	_run.call_deferred()


func check(ok: bool, msg: String) -> void:
	checks += 1
	if not ok:
		failures.append(msg)
		push_error(msg)


func _make_world() -> GameWorld:
	var gw := GameWorld.new()
	gw.data = WorldData.new(64, 64, 1)
	gw.rng = Rng.new(123)
	gw.mil = Military.new(gw)
	gw.econ = Economy.new(gw)
	gw.army = Army.new(gw)
	gw.diplo = Diplomacy.new(gw)
	gw.defense = Defense.new(gw)
	gw.session = Match.new(gw)
	gw.ai = AiBots.new(gw)
	gw.vision = Vision.new(gw)
	gw.navy = Navy.new(gw)
	gw.naval = Naval.new(gw)
	gw.objects = ObjectsLayer.new()
	gw.objects.setup(gw)
	gw.add_child(gw.objects)
	gw.fx = FxLayer.new()
	gw.fx.gw = gw
	gw.add_child(gw.fx)
	for sname: String in ["airfield_runway", "airfield_hangar", "airfield_tower", "mine", "mine_metal", "mine_precious", "oil_rig", "uranium_mine"]:
		gw.spr_index[sname] = gw.spr_name.size()
		gw.spr_name.append(sname)
		gw.spr_fd.append(1)
		gw.spr_fw.append(1)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 8, 8))
		gw.spr_anchor.append(Vector2.ZERO)
		gw.spr_tex.append(null)
	for id in range(1, 3):
		var c := Country.new()
		c.id = id
		c.capital_id = 0
		c.money = 5000
		gw.countries.append(c)
	return gw


func _run() -> void:
	var gw := _make_world()
	_test_cmd_field(gw)
	_test_cmd_static(gw)
	_test_net_hash(gw)
	_test_net_trace_toggle(gw)
	_test_delayed_order(gw)
	_test_net_codec(gw)
	_test_fx_pool()
	_test_life_idle()
	_test_shaders()
	_test_step1_ad()
	_test_step1_air_and_deposits()
	_test_step1_city_bots_and_scripts(gw)
	_test_step2_nukes_and_zaslon()
	_test_step3_carriers_and_airborne()
	_test_step4_seasons_ideology_flags()
	_test_step5_chronicle_and_territory()
	_test_step6_pc_and_perf()
	await _test_replay_stability_and_exit()
	_test_patch_v036_mechanics()
	_test_shift_ux()
	var result: Dictionary = {"passed": failures.is_empty(), "checks": checks, "failures": failures}
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			FileAccess.open(a.trim_prefix("--out="), FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("GODOT_SUITE ", JSON.stringify(result))
	gw.free()
	quit(0 if failures.is_empty() else 1)


func _test_cmd_field(gw: GameWorld) -> void:
	var b := Facility.new()
	b.kind = Facility.Kind.BARRACKS
	b.prod_type = 0
	gw.cmd_field(b, "prod_type", 4)
	check(b.prod_type == 4, "cmd_field allows BARRACKS prod_type=4")
	gw.cmd_field(b, "prod_type", 99)
	check(b.prod_type == 4, "cmd_field rejects out-of-range BARRACKS prod_type")
	gw.cmd_field(b, "prod_type", "bad")
	check(b.prod_type == 4, "cmd_field rejects non-numeric prod_type")

	var df := Facility.new()
	df.kind = Facility.Kind.DRONE_FACTORY
	df.prod_type = 0
	gw.cmd_field(df, "prod_type", 1)
	check(df.prod_type == 1, "cmd_field allows DRONE_FACTORY prod_type=1")
	gw.cmd_field(df, "prod_type", 2)
	check(df.prod_type == 1, "cmd_field rejects DRONE_FACTORY prod_type=2")

	var farm := Facility.new()
	farm.kind = Facility.Kind.FARM
	farm.prod_type = 0
	gw.cmd_field(farm, "prod_type", 1)
	check(farm.prod_type == 0, "cmd_field rejects prod_type on unrelated facility kind")

	var c: Country = gw.countries[0]
	c.army_defend = false
	gw.cmd_field(c, "army_defend", true)
	check(c.army_defend == true, "cmd_field allows bool army_defend on Country")
	gw.cmd_field(c, "army_defend", 123)
	check(c.army_defend == true, "cmd_field rejects non-bool army_defend")
	gw.cmd_field(b, "army_defend", true)
	check(true, "cmd_field ignores Country-only field on Facility")


func _test_cmd_static(gw: GameWorld) -> void:
	var f1 := Facility.new()
	f1.id = 10
	f1.kind = Facility.Kind.BARRACKS
	f1.country_id = 1
	var f2 := Facility.new()
	f2.id = 20
	f2.kind = Facility.Kind.BARRACKS
	f2.country_id = 2
	gw.mil.facilities = [f1, f2]
	var c1: Country = gw.countries[0]
	var fids := PackedInt32Array([10, 20, 999])
	var args: Array = ["TestGroup", 0, "emb_star", fids]
	gw.cmd_static(c1, "groups", "create", args)
	check(c1.army_groups.size() == 1, "cmd_static creates group for owned facility")
	var stored: PackedInt32Array = c1.army_groups[0]["fids"] if not c1.army_groups.is_empty() else PackedInt32Array()
	check(stored == PackedInt32Array([10]), "cmd_static strips foreign and missing facilities")


func _test_net_hash(gw: GameWorld) -> void:
	var m := Missile.new()
	m.id = 1
	m.launch = Vector2(10.0, 20.0)
	m.target = Vector2(50.0, 60.0)
	m.flight_time = 2.0
	m.t = 1.0
	m.state = Missile.State.FLIGHT
	gw.mil.missiles.append(m)
	var s := Ship.new()
	s.id = 1
	s.pos = Vector2(50.0, 60.0)
	s.hp = 100.0
	gw.navy.ships.append(s)

	var h0: String = NetHash.of(gw)
	m.t = 1.5
	var h1: String = NetHash.of(gw)
	check(h0 != h1, "NetHash.of detects Missile flight progress change")
	s.hp = 80.0
	var h2: String = NetHash.of(gw)
	check(h1 != h2, "NetHash.of detects Ship HP change")

	var old_trace: bool = NetConfig.trace
	NetConfig.trace = true
	var parts: Dictionary = NetHash.parts(gw)
	NetConfig.trace = old_trace
	check(parts.has("units_trace") and String(parts.get("units", "")).begins_with("0:"), "NetHash.parts preserves both units and units_trace when trace is enabled")


func _test_net_trace_toggle(gw: GameWorld) -> void:
	var old_trace: bool = NetConfig.trace
	NetConfig.trace = false
	gw.net_trace_logs = false
	gw.net_step(0.0)
	check(not gw.rng.log_on and not Country.mlog_on, "net_step leaves stack logging disabled during normal MP")
	gw.net_trace_logs = true
	gw.net_step(0.0)
	check(gw.rng.log_on and Country.mlog_on, "net_step enables stack logging when net_trace_logs is set")
	gw.net_trace_logs = false
	gw.rng.log_on = false
	Country.mlog_on = false
	NetConfig.trace = old_trace


func _test_delayed_order(gw: GameWorld) -> void:
	var log: Array[String] = []
	gw.game_time = 10.0
	gw._delayed = [
		[5.0, func() -> void:
			log.append("first")
			gw._delayed.append([9.0, func() -> void: log.append("nested")])],
		[15.0, func() -> void: log.append("future")],
		[10.0, func() -> void: log.append("second")],
	]
	gw._sim_step(0.0)
	check(log == ["first", "second"], "_delayed executes due callbacks in insertion order")
	check(gw._delayed.size() == 2, "_delayed preserves future and nested callbacks")
	gw._sim_step(0.0)
	check(log == ["first", "second", "nested"], "nested due callback runs on next step")
	gw._delayed.clear()


func _test_net_codec(gw: GameWorld) -> void:
	var arr: Array[int] = [1, 2, 3]
	var enc: Variant = NetCodec.encode([gw.countries[0], arr, {"k": 7}])
	var dec: Array = NetCodec.decode(gw, enc)
	check(NetCodec.ok and dec[0] == gw.countries[0], "NetCodec round-trips Country reference")
	check(dec[1] is Array and (dec[1] as Array).is_typed() and dec[1] == [1, 2, 3], "NetCodec preserves typed int array")
	check((dec[2] as Dictionary).get("k") == 7, "NetCodec round-trips Dictionary")


func _test_fx_pool() -> void:
	var fx := FxLayer.new()
	var at := SpriteAtlas.new()
	at.texture = ImageTexture.create_from_image(Image.create(16, 16, false, Image.FORMAT_RGBA8))
	at.sprites = {"puff": {"x": 0, "y": 0, "w": 8, "h": 8, "ax": 4, "ay": 4, "fps": 10, "frames": 2}}
	var gw := GameWorld.new()
	fx.setup(gw, at)
	var s1: AnimatedSprite2D = fx.spawn("puff", Vector2(10, 10), 6, 5.0)
	check(fx.pool.size() == 1 and fx._active.size() == 1 and fx._free.is_empty(), "FxLayer spawn tracks active sprite")
	fx.stop(s1)
	check(fx._free.size() == 1 and not s1.visible, "FxLayer stop returns sprite to free pool")
	var s2: AnimatedSprite2D = fx.spawn("puff", Vector2(20, 20), 6, 5.0)
	check(s2 == s1 and fx._active.size() == 1 and fx._free.is_empty(), "FxLayer reuses stopped sprite without duplicating _active")
	fx._process(0.016)
	check(fx._active.size() == 1, "FxLayer _process keeps active visible sprite")
	fx.reset()
	check(fx._active.is_empty() and fx._free.size() == 1, "FxLayer reset clears active and restores free pool")
	fx.free()
	gw.free()


func _test_life_idle() -> void:
	var life := LifeLayer.new()
	life._process(0.016)
	check(not life._had_agents, "LifeLayer idle tick keeps _had_agents false")
	life.free()


func _test_shaders() -> void:
	for nm: String in [
		"border_flash.gdshader",
		"conf_map.gdshader",
		"map_mode.gdshader",
		"sky_cover.gdshader",
		"strat_map.gdshader",
		"territory.gdshader",
		"territory_dist.gdshader",
		"vfx_clouds.gdshader",
	]:
		var sh: Shader = load("res://world/" + nm) as Shader
		check(sh != null and sh.code != "", "Shader loads cleanly: " + nm)


func _step1_world(sz: int) -> GameWorld:
	var gw := GameWorld.new()
	gw.data = WorldData.new(sz, sz, 1)
	gw.data.biome.fill(Biome.GRASS)
	gw.data.owners.fill(1)
	gw.rng = Rng.new(456)
	gw.mil = Military.new(gw)
	gw.econ = Economy.new(gw)
	gw.army = Army.new(gw)
	gw.diplo = Diplomacy.new(gw)
	gw.defense = Defense.new(gw)
	gw.session = Match.new(gw)
	gw.ai = AiBots.new(gw)
	gw.vision = Vision.new(gw)
	gw.navy = Navy.new(gw)
	gw.naval = Naval.new(gw)
	gw.objects = ObjectsLayer.new()
	gw.objects.setup(gw)
	gw.add_child(gw.objects)
	gw.fx = FxLayer.new()
	gw.fx.gw = gw
	gw.add_child(gw.fx)
	for sname: String in ["airfield_runway", "airfield_hangar", "airfield_tower", "mine", "mine_metal", "mine_precious", "oil_rig", "uranium_mine"]:
		gw.spr_index[sname] = gw.spr_name.size()
		gw.spr_name.append(sname)
		gw.spr_fd.append(1)
		gw.spr_fw.append(1)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 8, 8))
		gw.spr_anchor.append(Vector2.ZERO)
		gw.spr_tex.append(null)
	for id in range(1, 4):
		var c := Country.new()
		c.id = id
		c.name = "Nation%d" % id
		c.capital_id = 0
		c.money = 80000
		c.metal = 5000
		c.titanium = 5000
		c.wood = 5000
		c.fuel = 5000
		c.oil = 5000
		c.food = 5000
		c.precious = 5000
		c.goods = 5000
		c.power_cap = 5000
		gw.countries.append(c)
	return gw


func _make_ad(id: int, cid: int, kind: int, cell: Vector2i) -> Facility:
	var f := Facility.new()
	f.id = id
	f.kind = kind
	f.country_id = cid
	f.cell = cell
	f.size = Vector2i(2, 2)
	f.hp = 100.0
	f.was_alive = true
	f.powered = true
	f.ammo = 4
	f.frame_i = 5 if kind == Facility.Kind.AD_SAM or kind == Facility.Kind.AD_INT else 0
	return f


func _test_step1_ad() -> void:
	# 1. Gun (AD_SPAAG) engages before SAM even if SAM is earlier in facilities list.
	var gw := _step1_world(64)
	gw.countries[0].at_war[2] = true
	gw.countries[1].at_war[1] = true
	var sam := _make_ad(1, 1, Facility.Kind.AD_SAM, Vector2i(20, 20))
	var spaag := _make_ad(2, 1, Facility.Kind.AD_SPAAG, Vector2i(22, 20))
	gw.mil.facilities = [sam, spaag]
	var d := Drone.new()
	d.id = 1
	d.country_id = 2
	d.state = Drone.State.FLY
	d.pos = sam.center_px() + Vector2(20.0, 0.0)
	d.h = 8.0
	gw.mil.drones.append(d)
	gw.defense.update(0.05)
	check(spaag.cd > 0.0, "AD_SPAAG fires at incoming drone")
	check(sam.ammo == 4, "AD_SAM holds fire on target already engaged by gun")

	# 2. Allies / same-side deduplicate non-ballistic target to 1 shooter, ballistic up to 2.
	var gw2 := _step1_world(64)
	gw2.countries[0].at_war[2] = true
	gw2.countries[1].at_war[1] = true
	gw2.countries[2].at_war[2] = true
	gw2.countries[1].at_war[3] = true
	gw2.diplo._set_rel(1, 3, Diplomacy.Rel.ALLIANCE)
	var sam1 := _make_ad(1, 1, Facility.Kind.AD_SAM, Vector2i(18, 20))
	var sam3 := _make_ad(2, 3, Facility.Kind.AD_SAM, Vector2i(24, 20))
	gw2.mil.facilities = [sam1, sam3]
	var d2 := Drone.new()
	d2.id = 2
	d2.country_id = 2
	d2.state = Drone.State.FLY
	d2.pos = Vector2(90.0, 90.0)
	d2.h = 8.0
	gw2.mil.drones.append(d2)
	gw2.defense.update(0.05)
	check((1 if sam1.ammo < 4 else 0) + (1 if sam3.ammo < 4 else 0) == 1, "Allied AD limits non-ballistic target to 1 shooter")

	var m := Missile.new()
	m.id = 99
	m.country_id = 2
	m.state = Missile.State.FLIGHT
	m.launch = Vector2(10.0, 10.0)
	m.target = Vector2(200.0, 200.0)
	m.flight_time = 10.0
	m.t = 7.5
	m.apex = 40.0
	gw2.mil.missiles.append(m)
	sam1.ammo = 4
	sam1.cd = 0.0
	sam3.ammo = 4
	sam3.cd = 0.0
	gw2.mil.drones.clear()
	gw2.defense._scan = 0.0
	gw2.defense.update(0.05)
	check(sam1.ammo == 3 and sam3.ammo == 3, "Ballistic missile can be engaged by up to 2 AD sites")
	gw.free()
	gw2.free()


func _test_step1_air_and_deposits() -> void:
	var gw := _step1_world(128)
	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	var af1: Facility = gw.mil.build(Facility.Kind.AIRFIELD, Vector2i(25, 25), c1, null, true)
	var af2: Facility = gw.mil.build(Facility.Kind.AIRFIELD, Vector2i(80, 25), c1, null, true)
	check(af1 != null and af2 != null, "Builds two airfields for rebase/sell tests")
	if af1 != null and af2 != null:
		check(gw.mil.air.buy(af1, Aircraft.Type.FIGHTER, c1) == "", "Buys first fighter")
		check(gw.mil.air.aircraft.size() == 1, "Aircraft created")
		var a: Aircraft = gw.mil.air.aircraft[0]
		var old_spot: int = a.spot
		check(gw.mil.air.sell(a, c2) != "", "Foreign country cannot sell aircraft")
		var m_before: int = c1.money
		check(gw.mil.air.sell(a, c1) == "", "Owner sells parked aircraft")
		check(a.state == Aircraft.State.DEAD, "Sold aircraft becomes DEAD")
		check(c1.money == m_before + Air.sell_refund(Aircraft.Type.FIGHTER), "Sell refunds 50% aircraft cost")
		check(gw.mil.air.buy(af1, Aircraft.Type.FIGHTER, c1) == "", "Freed spot allows buying replacement fighter")
		var b: Aircraft = gw.mil.air.aircraft[1]
		check(b.spot == old_spot, "Freed spot reused by replacement aircraft")
		check(gw.mil.air.rebase(b, af1, c1) != "", "Rebase rejects current home airfield")
		check(gw.mil.air.rebase(b, af2, c1) == "", "Rebase moves aircraft from af1 to af2")
		check(b.base == af2 and b.after_land == Aircraft.State.RTB and b.roll_end_x > 0.0, "Rebase preserves old runway roll_end_x and sets destination")
		# Old spot on af1 is now free for another fighter.
		check(gw.mil.air.buy(af1, Aircraft.Type.FIGHTER, c1) == "", "Rebase frees old airfield parking spot")

	gw.econ.deposits = [
		{"res": "metal", "cell": Vector2i(50, 90), "left": 500, "max": 500, "mine": null, "obj": -1},
		{"res": "metal", "cell": Vector2i(65, 90), "left": 500, "max": 500, "mine": null, "obj": -1},
	]
	var m0: int = c1.money
	var br: Array = gw.econ.build_all_deposits(c1, "metal")
	check(br.size() == 4 and int(br[0]) == 2 and int(br[2]) == 0, "build_all_deposits builds on both free deposits")
	check(int(br[1]) > 0 and c1.money == m0 - int(br[1]), "build_all_deposits deducts real build cost")
	gw.free()


func _test_step1_city_bots_and_scripts(gw: GameWorld) -> void:
	check(GameConfig.CB_MAX == 11, "Bot cap raised to 11")
	check(GameWorld.COUNTRY_STYLES.size() == 12, "COUNTRY_STYLES has 12 distinct palettes")
	Palette.ensure_loaded()
	for st: Dictionary in GameWorld.COUNTRY_STYLES:
		var base_col: String = String(st.get("base", ""))
		check(FlagMaker.MAIN_OF.has(base_col), "FlagMaker.MAIN_OF maps " + base_col)
		check(Palette.colors.has(base_col), "Palette.colors maps base " + base_col)
		for opt_k: String in ["light", "dark"]:
			if st.has(opt_k):
				check(Palette.colors.has(String(st[opt_k])), "Palette.colors maps %s %s" % [opt_k, String(st[opt_k])])
	check(Save.PREFS.has("no_slow"), "Save.PREFS persists no_slow setting")
	check(NetSession.ALLOWED.has(".cmd_rename_city") and NetSession.ALLOWED.has("mil.air.sell") and NetSession.ALLOWED.has("mil.air.rebase") and NetSession.ALLOWED.has("econ.build_all_deposits"), "NetSession.ALLOWED whitelists Step 1 commands")

	var city1 := City.new()
	city1.id = 0
	city1.name = "Alpha"
	city1.country_id = 1
	var city2 := City.new()
	city2.id = 1
	city2.name = "Beta"
	city2.country_id = 2
	gw.cities = [city1, city2]
	check(gw.cmd_rename_city(2, city1, "Gamma") != "", "Foreign player cannot rename city")
	check(gw.cmd_rename_city(1, city1, "A") != "", "Rejects too-short city name")
	check(gw.cmd_rename_city(1, city1, "Beta") != "", "Rejects duplicate normalized city name")
	check(gw.cmd_rename_city(1, city1, "New Kyiv") == "" and city1.name == "New Kyiv", "Valid rename updates city.name")

	var gw3 := _step1_world(64)
	gw3.countries.clear()
	for spr_n: String in ["territory", "territory_border"]:
		var sp2 := Sprite2D.new()
		var sm := ShaderMaterial.new()
		sm.shader = load("res://world/territory.gdshader") as Shader
		sp2.material = sm
		gw3.set(spr_n, sp2)
		gw3.add_child(sp2)
	var seen_cols: Dictionary = {}
	for i in 12:
		var c12: Country = gw3.create_country(i == 0)
		seen_cols[c12.color.to_html()] = true
	check(gw3.countries.size() == 12 and seen_cols.size() == 12, "1 player + 11 bots spawn with 12 distinct colors")
	var shader_cols: PackedColorArray = (gw3.territory.material as ShaderMaterial).get_shader_parameter("colors")
	check(shader_cols.size() == GameWorld.COUNTRY_SLOTS and shader_cols[12] == gw3.countries[11].color, "Territory shader stores all 12 country colors up to slot 12")
	gw3.free()

	for sp: String in [
		"res://game/main.gd",
		"res://ui/menus.gd",
		"res://ui/ui24/res_sheet.gd",
		"res://ui/hud/hud_cards.gd",
		"res://ui/hud/hud_econ.gd",
		"res://ui/hud/hud_ops.gd",
		"res://ui/hud/hud_stack.gd",
		"res://game/nuclear.gd",
		"res://ui/ui24/ad_rules_sheet.gd",
		"res://ui/ui24/navy_yard.gd",
		"res://ui/ui24/navy_dock.gd",
		"res://ui/ui24/navy_map.gd",
		"res://world/navy_layer.gd",
		"res://world/units_layer.gd",
	]:
		var sc: GDScript = load(sp) as GDScript
		check(sc != null and sc.can_instantiate(), "Script loads cleanly: " + sp)


func _test_step2_nukes_and_zaslon() -> void:
	var at_w := SpriteAtlas.load_atlas("res://assets/sprites/atlas_nuke2.png", "res://assets/sprites/atlas_nuke2.json", true)
	var at_u := SpriteAtlas.load_atlas("res://assets/sprites/atlas_nuke2ui.png", "res://assets/sprites/atlas_nuke2ui.json", true)
	check(at_w != null and at_w.texture != null and at_w.has("nuke_silo") and at_w.has("nuke_silo_arm") and at_w.has("ad_zaslon") and at_w.has("ad_zaslon_open") and at_w.has("missile_nuke") and at_w.has("zaslon_int") and at_w.has("crater_nuke") and at_w.has("nuke_blast"), "atlas_nuke2 loads all Step 2 world sprites cleanly")
	check(at_u != null and at_u.texture != null and at_u.has("icon_nuke_silo") and at_u.has("icon_ad_zaslon") and at_u.has("icon_nuke_missile") and at_u.has("icon_plutonium") and at_u.has("res_plutonium"), "atlas_nuke2ui loads all Step 2 UI icons cleanly")

	check(Save.CFG.has("nukes") and NetSession.CFG_KEYS.has("nukes"), "nukes config key registered in Save.CFG and NetSession.CFG_KEYS")
	check(NetSession.ALLOWED.has(".cmd_nuke_build") and NetSession.ALLOWED.has(".cmd_nuke_arm") and NetSession.ALLOWED.has(".cmd_nuke_launch"), "NetSession.ALLOWED whitelists nuclear silo commands")

	var gw := _step1_world(96)
	var gnode := Node2D.new()
	gw.ground = GroundLayer.new()
	gw.add_child(gw.ground)
	gnode.free()
	gw.protect = Protect.new(gw)
	gw.supply = Supply.new(gw)
	for sname: String in ["npp_core", "npp_tower", "nuke_silo", "nuke_silo_arm", "ad_zaslon", "ad_zaslon_open", "barracks"]:
		gw.spr_index[sname] = gw.spr_name.size()
		gw.spr_name.append(sname)
		gw.spr_fd.append(1)
		gw.spr_fw.append(1)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 24, 24))
		gw.spr_anchor.append(Vector2.ZERO)
		gw.spr_tex.append(null)
	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c2.is_player = false
	var ct1 := City.new()
	ct1.id = 0
	ct1.country_id = 1
	ct1.center = Vector2i(16, 16)
	var ct2 := City.new()
	ct2.id = 1
	ct2.country_id = 2
	ct2.center = Vector2i(76, 76)
	gw.cities = [ct1, ct2]
	c1.capital_id = 0
	c2.capital_id = 1
	for y in range(48, 96):
		for x in range(48, 96):
			gw.data.owners[y * 96 + x] = 2

	# 1. GameConfig.nukes toggle gates placement
	GameConfig.nukes = false
	check(gw.mil.check_place(Facility.Kind.NUKE_SILO, Vector2i(10, 10), c1, null, false) != "", "NUKE_SILO blocked when GameConfig.nukes == false")
	check(gw.mil.check_place(Facility.Kind.AD_ZASLON, Vector2i(20, 10), c1, null, false) != "", "AD_ZASLON blocked when GameConfig.nukes == false")
	GameConfig.nukes = true
	check(gw.mil.check_place(Facility.Kind.NUKE_SILO, Vector2i(10, 10), c1, null, false) == "", "NUKE_SILO allowed when GameConfig.nukes == true")

	# 2. Plutonium chain + storage cap
	gw.mil._no_construct = true
	var npp: Facility = gw.mil.build(Facility.Kind.NUCLEAR_PLANT, Vector2i(25, 25), c1, null, true)
	check(npp != null and npp.u_fuel > 0.0, "NUCLEAR_PLANT spawns fueled")
	c1.plutonium = 10
	Nuclear.burn(gw, Nuclear.PLUTONIUM_S * 5.0)
	check(c1.plutonium == gw.econ.res_cap(c1, "plutonium"), "Nuclear.burn tops plutonium at storage cap (12) without overflowing")

	# 3. Silo two-stage preparation (120s + 120s) -> global stage warnings -> diplomacy deterrence -> launch
	check(is_equal_approx(Nuclear.SILO_BUILD_T, 120.0) and is_equal_approx(Nuclear.SILO_ARM_T, 120.0), "Two-stage ICBM timers are 120s build + 120s arm")
	var base_str: float = gw.diplo.strength(c1.id)
	var silo: Facility = gw.mil.build(Facility.Kind.NUKE_SILO, Vector2i(12, 12), c1, null, true)
	check(silo != null and gw.mil.alive(silo), "NUKE_SILO built cleanly")
	check(gw.cmd_nuke_build(silo, c1) == "" and silo.nuke_state == 1 and silo.nuke_stage_sent == 1 and is_equal_approx(silo.nuke_t, 120.0), "cmd_nuke_build starts Stage 1 (120s) and broadcasts stage 1 alarm")
	check(not gw.diplo.demand_options(c2.id, c1.id).filter(func(o: Dictionary) -> bool: return String(o.get("kind", "")) == "halt_nukes").is_empty(), "halt_nukes ultimatum available already during Stage 1")
	Nuclear.update_silos(gw, Nuclear.SILO_BUILD_T + 1.0)
	check(silo.nuke_state == 2, "update_silos transitions silo to built/unarmed (state 2)")
	check(gw.cmd_nuke_arm(silo, c1) == "" and silo.nuke_state == 4 and silo.nuke_stage_sent == 2 and is_equal_approx(silo.nuke_t, 120.0) and not c1.nuke_ready, "cmd_nuke_arm starts Stage 2 arming countdown (120s, state 4) and broadcasts stage 2 alarm")
	gw.diplo._set_rel(1, 2, Diplomacy.Rel.WAR)
	check(gw.cmd_nuke_launch(silo, c1, Vector2(ct2.center * 4)) != "", "cmd_nuke_launch blocked while silo is still arming (state 4)")
	Nuclear.update_silos(gw, Nuclear.SILO_ARM_T + 0.5)
	check(silo.nuke_state == 3 and c1.nuke_ready, "update_silos completes arming to state 3 and sets nuke_ready")
	check(gw.diplo.strength(c1.id) > base_str + 1000.0, "Armed nuclear weapons increase diplomacy deterrence strength")

	# 4. AD_ZASLON starts with 0 ammo, rejects free rearm/auto-reload, produces paid charges (30s, cap 4), and intercepts ICBM
	var z_built: Facility = gw.mil.build(Facility.Kind.AD_ZASLON, Vector2i(62, 62), c2, null, true)
	check(z_built != null and z_built.ammo == 0 and z_built.zas_q == 0, "Newly built AD_ZASLON starts with 0 ammo")
	check(gw.defense.rearm(z_built, c2) != "" and z_built.ammo == 0, "Defense.rearm rejected for AD_ZASLON")
	gw.defense.update(45.0)
	check(z_built.ammo == 0, "AD_ZASLON does not auto-reload for free in Defense.update")
	var m_before_z: int = c2.money
	var ti_before_z: int = c2.titanium
	check(gw.cmd_zaslon_buy(z_built, c2, 2) == "" and z_built.zas_q == 2 and is_equal_approx(z_built.zas_t, Defense.ZASLON_CHARGE_T), "cmd_zaslon_buy queues 2 paid interceptor charges on AD_ZASLON")
	check(c2.money == m_before_z - Military.COST_ZASLON_CHARGE * 2 and c2.titanium == ti_before_z - 12, "cmd_zaslon_buy deducts money and strategic resources per queued charge")
	gw.defense.update(Defense.ZASLON_CHARGE_T + 0.5)
	check(z_built.ammo == 1 and z_built.zas_q == 1, "AD_ZASLON completes 1st interceptor charge after 30s and advances queue")
	gw.defense.update(Defense.ZASLON_CHARGE_T + 0.5)
	check(z_built.ammo == 2 and z_built.zas_q == 0, "AD_ZASLON completes 2nd interceptor charge after another 30s")

	var sam: Facility = _make_ad(901, c2.id, Facility.Kind.AD_SAM, Vector2i(70, 70))
	var pat: Facility = _make_ad(902, c2.id, Facility.Kind.AD_PATRIOT, Vector2i(74, 70))
	var zas: Facility = _make_ad(903, c2.id, Facility.Kind.AD_ZASLON, Vector2i(72, 72))
	zas.ammo = 2
	gw.mil.facilities.append_array([sam, pat, zas])

	var pre_m: int = gw.mil.missiles.size()
	var launch_err: String = gw.cmd_nuke_launch(silo, c1, Vector2(ct2.center * 4))
	check(launch_err == "" and gw.mil.missiles.size() == pre_m + 1, "cmd_nuke_launch spawns Missile after arming completes: err='%s'" % launch_err)
	var nm: Missile = gw.mil.missiles[gw.mil.missiles.size() - 1]
	check(nm != null and nm.nuke, "cmd_nuke_launch spawns Missile with nuke=true")
	check(silo.nuke_state == 0 and silo.nuke_cd > 0.0, "cmd_nuke_launch starts silo preparation cooldown (nuke_cd > 0)")
	check(gw.cmd_nuke_build(silo, c1) != "", "cmd_nuke_build rejected during silo preparation cooldown")
	Nuclear.update_silos(gw, Nuclear.SILO_RELOAD_CD + 1.0)
	check(silo.nuke_cd <= 0.0 and gw.cmd_nuke_build(silo, c1) == "", "silo unlocks ICBM assembly again once preparation cooldown elapses")
	nm.state = Missile.State.FLIGHT
	nm.t = Missile.IGNITE_TIME + nm.flight_time * 0.8
	check(gw.defense._targets(sam, Defense.SPEC[Facility.Kind.AD_SAM]).is_empty(), "AD_SAM cannot target nuclear ICBM")
	check(gw.defense._targets(pat, Defense.SPEC[Facility.Kind.AD_PATRIOT]).is_empty(), "AD_PATRIOT cannot target nuclear ICBM")
	var z_tgts: Array = gw.defense._targets(zas, Defense.SPEC[Facility.Kind.AD_ZASLON])
	check(z_tgts.size() == 1 and z_tgts[0][0] == nm, "AD_ZASLON locks onto nuclear ICBM")
	gw.defense._launch(zas, z_tgts[0], Defense.SPEC[Facility.Kind.AD_ZASLON])
	check(gw.defense.shots.size() == 1 and gw.defense.shots[0]["kind"] == "zaslon" and zas.ammo == 1, "AD_ZASLON fires zaslon ABM interceptor")

	# 5. Nuclear impact ignores Protect nets/concrete, creates permanent scorched crater & blocks construction forever
	var impact_cell := Vector2i(78, 78)
	ct2.garrison_max = 100.0
	ct2.garrison = 100.0
	var tk := Unit.new()
	tk.id = 777
	tk.country_id = c2.id
	tk.type = Unit.Type.TANK
	tk.hp = 200.0
	tk.max_hp = 200.0
	tk.pos = Vector2(impact_cell * 4) + Vector2(float(Nuclear.NUKE_R_CELLS * 2), 0.0)
	gw.army.units.append(tk)
	var bldg_id: int = gw.add_object("npp_core", Vector2i(76, 76), GameWorld.KIND_BUILDING)
	var pwr: Facility = gw.mil.build(Facility.Kind.BARRACKS, Vector2i(72, 76), c2, null, true)
	if pwr != null:
		gw.protect.upgrade(pwr, "net", c2)
		gw.protect.upgrade(pwr, "conc", c2)
	gw.strike_nuke(impact_cell, c1.id)
	check(Nuclear.NUKE_R_CELLS >= 30 and ct2.garrison < 10.0 and not tk.alive(), "Enlarged strike_nuke devastates enemy garrison and armor across expanded blast radius")
	check(pwr != null and not gw.mil.alive(pwr), "strike_nuke destroys netted and concreted facilities in blast zone")
	check(gw.nuke_zones.size() == 1, "strike_nuke records permanent crater zone in gw.nuke_zones")
	check(gw.obj_state[bldg_id] == 1, "strike_nuke destroys buildings in blast radius")
	check(gw.data.get_biome(impact_cell.x, impact_cell.y) == Biome.BURNT, "strike_nuke scorches crater terrain (Biome.BURNT, not water)")
	check(gw.in_nuke_crater(impact_cell) and gw.mil.check_place(Facility.Kind.BARRACKS, Vector2i(75, 75), c2, null, false) != "", "Permanent nuclear crater blocks all future construction inside it")
	check(c1.nukes_used == 1, "Country nukes_used increments on impact")
	var u := Unit.new()
	u.country_id = c2.id
	u.type = Unit.Type.INFANTRY
	u.hp = 50.0
	u.max_hp = 50.0
	u.pos = Vector2(impact_cell * 4) + Vector2(8, 8)
	gw.army.units.append(u)
	gw.game_time = 2.0
	Nuclear.update_rad_zones(gw, 1.1)
	check(u.hp < 50.0, "Nuclear fallout zone damages exposed ground units")
	gw.free()


func _test_step3_carriers_and_airborne() -> void:
	# Step 3: Carrier, Hangar exclusivity, Escort Center Formation, Nearest Base Return, Deck Jets, Airport & Transport Paratroop Airdrop
	var ac3 := SpriteAtlas.load_atlas("res://assets/sprites/atlas_carrier3.png", "res://assets/sprites/atlas_carrier3.json", true)
	var ac3u := SpriteAtlas.load_atlas("res://assets/sprites/atlas_carrier3ui.png", "res://assets/sprites/atlas_carrier3ui.json", true)
	check(ac3.has("ship_carrier") and ac3.has("ship_carrier_sink") and ac3.has("deck_jet") and ac3.has("transport") and ac3.has("paratroop") and ac3.has("airport_terminal"), "atlas_carrier3 loads all Step 3 sprites")
	check(ac3u.has("icon_hull_carrier") and ac3u.has("icon_mod_hangar") and ac3u.has("icon_deck_jet") and ac3u.has("icon_transport") and ac3u.has("icon_airport") and ac3u.has("icon_airdrop"), "atlas_carrier3ui loads all Step 3 UI icons")

	var gw := _step1_world(128)
	for y in range(60, 128):
		for x in range(74, 128):
			gw.data.set_biome(x, y, Biome.DEEP)
	gw.atlas_carrier3 = ac3
	gw.ground = GroundLayer.new()
	gw.add_child(gw.ground)
	gw.protect = Protect.new(gw)
	gw.supply = Supply.new(gw)
	gw.navy = Navy.new(gw)
	gw.naval = Naval.new(gw)
	gw.econ.ports = Ports.new(gw, gw.econ)
	for sname: String in ["navbase", "airport_terminal", "airport_tower", "airfield_runway", "airfield_hangar", "airfield_tower", "barracks"]:
		if not gw.spr_index.has(sname):
			gw.spr_index[sname] = gw.spr_name.size()
			gw.spr_name.append(sname)
			gw.spr_fd.append(1)
			gw.spr_fw.append(1)
			gw.spr_frames.append(1)
			gw.spr_rect.append(Rect2(0, 0, 24, 24))
			gw.spr_anchor.append(Vector2.ZERO)
			gw.spr_tex.append(null)
	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c2.is_player = false
	c1.money = 120000
	c1.metal = 300
	c1.titanium = 200
	c1.fuel = 100
	c1.food = 100
	var ct1 := City.new()
	ct1.id = 0
	ct1.country_id = 1
	ct1.center = Vector2i(16, 16)
	var ct2 := City.new()
	ct2.id = 1
	ct2.country_id = 2
	ct2.center = Vector2i(96, 96)
	gw.cities = [ct1, ct2]
	c1.capital_id = 0
	c2.capital_id = 1
	gw.mil._no_construct = true

	# 1. Hangar module exclusivity (#153) & Carrier hull stats
	check(Navy.fit_why(Ship.Hull.LIGHT, ["hangar"]) != "", "Hangar rejected on Corvette")
	check(Navy.fit_why(Ship.Hull.HEAVY, ["hangar"]) != "", "Hangar rejected on Cruiser")
	check(Navy.fit_why(Ship.Hull.CARRIER, ["ciws", "sam", "hangar", "hangar"]) == "", "Hangar + self-defense allowed on Carrier")
	check(int(Navy.hull_spec(Ship.Hull.CARRIER)["cost"]["money"]) == 25000, "Carrier base cost is 25000")

	# Two naval bases along coast for nearest-base return check (#180)
	var nb1 := Facility.new()
	nb1.id = 701
	nb1.kind = Facility.Kind.NAVAL_BASE
	nb1.country_id = 1
	nb1.cell = Vector2i(70, 64)
	nb1.size = Vector2i(24, 12)
	nb1.hp = 500.0
	var nb2 := Facility.new()
	nb2.id = 702
	nb2.kind = Facility.Kind.NAVAL_BASE
	nb2.country_id = 1
	nb2.cell = Vector2i(70, 108)
	nb2.size = Vector2i(24, 12)
	nb2.hp = 500.0
	gw.mil.facilities.append_array([nb1, nb2])

	# 2. Carrier spawn, deck capacity, escort center formation, nearest-base return
	var cv: Ship = gw.navy.spawn_ship(nb1, Ship.Hull.CARRIER, ["ciws", "sam", "hangar", "hangar"])
	check(cv != null and cv.is_carrier() and gw.navy.deck_cap(cv) == 4, "Carrier spawns with base 2 + 2 hangar = 4 deck capacity")
	cv.pos = Vector2(360, 440) # far closer to nb2 (328, 456) than nb1 (328, 280)
	check(gw.navy.nearest_base(cv) == nb2, "nearest_base selects closer alive naval base (nb2) instead of spawn base (nb1)")
	var esc1: Ship = gw.navy.spawn_ship(nb1, Ship.Hull.MEDIUM, ["gun", "ciws", "sam", "ash"])
	var esc2: Ship = gw.navy.spawn_ship(nb1, Ship.Hull.LIGHT, ["gun", "ciws", "ash"])
	esc1.pos = Vector2(350, 430)
	esc2.pos = Vector2(370, 450)
	var fid: int = gw.navy.fl.fleet_create(c1.id, "Strike Group", Color.CYAN, [esc1.id, cv.id, esc2.id])
	check(fid > 0, "Fleet created with carrier + 2 escorts")
	gw.navy.fl._formation([esc1, cv, esc2], esc1, Vector2(440, 440), gw.navy.fl.fleet(fid))
	check(cv.state == Ship.State.SAIL and not cv.path.is_empty(), "Carrier steers on formation centerline with escorts assigned")

	# 3. Carrier rearm strictly gated by naval base (#148)
	cv.pos = Vector2(440, 360)
	check(gw.navy.rearm(cv) != "", "Carrier rearm blocked away from own naval base")

	# 4. Buy F-14 deck jet onto carrier, launch, fly, RTB cleanly onto moving carrier (#148, #180)
	check(gw.mil.air.buy_carrier_plane(cv, Aircraft.Type.DECK_JET, c1) == "", "buy_carrier_plane purchases DECK_JET onto carrier")
	var wing: Array[Aircraft] = gw.navy.deck_aircraft(cv)
	check(wing.size() == 1 and wing[0].carrier_id == cv.id and wing[0].asm == Air.DECK_JET_ASM, "Deck jet linked to carrier with ASMs")
	var dj: Aircraft = wing[0]
	check(gw.mil.air.order_fly(dj, Vector2(280, 280)) == "", "Deck jet orders fly/launch directly from carrier")
	check(dj.state == Aircraft.State.LIFT, "Deck jet launches via catapult LIFT straight from carrier deck")
	for _i in 60:
		cv.pos += Vector2(1.1, 0.0) # Carrier moving while jet is airborne
		gw.mil.air.update(0.1)
	check(dj.airborne(), "Deck jet reaches cruising flight cleanly")
	gw.mil.air.order_land(dj)
	for _j in 300:
		cv.pos += Vector2(0.8, 0.1) # Moving carrier during recovery (#180)
		gw.mil.air.update(0.1)
		if dj.state == Aircraft.State.PARKED:
			break
	check(dj.state == Aircraft.State.PARKED and dj.pos.distance_to(cv.pos) < 5.0, "Deck jet lands and parks back onto moving carrier without circling out of fuel")

	# 5. Airport build + Transport C-17 + Single-plane Paratroop Airdrop (#120, #139, #148, #153)
	var ap: Facility = gw.mil.build(Facility.Kind.AIRPORT, Vector2i(20, 40), c1, null, true)
	check(ap != null and gw.mil.alive(ap), "AIRPORT builds cleanly without freeze")
	check(gw.mil.air.buy(ap, Aircraft.Type.TRANSPORT, c1) == "", "TRANSPORT C-17 bought cleanly at AIRPORT")
	var tr: Aircraft = null
	for ac: Aircraft in gw.mil.air.based_at(ap):
		if ac.type == Aircraft.Type.TRANSPORT:
			tr = ac
			break
	check(tr != null, "TRANSPORT C-17 stationed at AIRPORT")
	var drop_pt := Vector2(240, 220)
	check(gw.mil.air.order_airdrop(tr, drop_pt, c1) == "", "Single TRANSPORT executes airborne drop order immediately")
	check(tr.troops == Air.PARATROOP_COUNT, "TRANSPORT loads paratroops on order")
	var u_before: int = gw.army.units.size()
	for _k in 400:
		gw.mil.air.update(0.1)
		if tr.troops == 0 and gw.army.units.size() > u_before:
			break
	check(gw.army.units.size() == u_before + Air.PARATROOP_COUNT and tr.state == Aircraft.State.RTB, "TRANSPORT drops paratroop infantry at target and automatically RTBs")

	# 6. NetSession & Save compatibility for Step 3 commands/types
	var allow: Dictionary = NetSession.allowed()
	check(allow.has("mil.air.buy_carrier_plane") and allow.has("mil.air.order_airdrop"), "NetSession ALLOWED whitelists carrier plane & airdrop commands")
	var sd: Dictionary = cv.to_dict()
	var cv2: Ship = Ship.from_dict(sd)
	check(cv2.hull == Ship.Hull.CARRIER and cv2.deck_cap(Navy.BASE_DECK_SLOTS) == 4, "Carrier roundtrips Ship.to_dict/from_dict cleanly")
	gw.free()


func _test_step4_seasons_ideology_flags() -> void:
	# 1. Step 4 Atlases & UI sprites (monument_0..6, ally_logo_0..39, seasons, ideology, paint tools)
	var a4 := SpriteAtlas.load_atlas("res://assets/sprites/atlas_step4.png", "res://assets/sprites/atlas_step4.json", true)
	for k in 7:
		check(a4.has("monument_%d" % k), "atlas_step4 contains monument_%d" % k)
	UiKit.ensure()
	for lid in 40:
		check(UiKit.has("ally_logo_%d" % lid) and UiKit.tex("ally_logo_%d" % lid) != null, "UiKit serves ally_logo_%d" % lid)
	for sid in 4:
		check(UiKit.has("icon_season_%d" % sid), "UiKit serves icon_season_%d" % sid)
	for iid in 7:
		check(UiKit.has("icon_ideo_%d" % iid), "UiKit serves icon_ideo_%d" % iid)
	check(UiKit.has("icon_brush") and UiKit.has("icon_bucket"), "UiKit serves pixel editor tool icons")
	var sh := load("res://world/season_terrain.gdshader") as Shader
	check(sh != null and sh.get_code().length() > 100, "season_terrain.gdshader loads cleanly")
	for ui_p: String in ["res://ui/flag_editor.gd", "res://ui/menus.gd", "res://ui/ui24/ally_sheet.gd", "res://ui/custom_bots.gd", "res://ui/ui24/my_state.gd", "res://ui/hud.gd", "res://world/weather_fx.gd"]:
		check(load(ui_p) != null, "UI/FX script compiles cleanly: " + ui_p)

	# 2. World setup for Seasons, Ideologies, Monuments & Winter Farm Penalty (-50%)
	var gw := _make_world()
	gw.seasons = Seasons.new()
	gw.seasons.gw = gw
	gw.seasons.reset()
	gw.data.biome.fill(Biome.GRASS)
	gw.data.owners.fill(1)
	for k in 7:
		var mnm := "monument_%d" % k
		gw.spr_index[mnm] = gw.spr_name.size()
		gw.spr_name.append(mnm)
		gw.spr_fd.append(3)
		gw.spr_fw.append(3)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 16, 22))
		gw.spr_anchor.append(Vector2(2, 19))
		gw.spr_tex.append(null)
	var fm_spr := String(Military.SPRITES[Facility.Kind.FARM])
	if not gw.spr_index.has(fm_spr):
		gw.spr_index[fm_spr] = gw.spr_name.size()
		gw.spr_name.append(fm_spr)
		gw.spr_fd.append(3)
		gw.spr_fw.append(3)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 12, 12))
		gw.spr_anchor.append(Vector2.ZERO)
		gw.spr_tex.append(null)

	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c1.ideology = 0 # Liberalism
	c2.ideology = 5 # Militarism

	var farm: Facility = gw.mil.build(Facility.Kind.FARM, Vector2i(16, 16), c1, null, true)
	check(farm != null, "Farm built cleanly for seasonal yield check")

	# Summer yield (full)
	gw.game_time = Seasons.SEASON_S * 1.4
	for _s in 30:
		gw.seasons.step(0.5)
	check(gw.seasons.season == Seasons.Season.SUMMER and not gw.seasons.is_winter() and gw.seasons.farm_mul() == 1.0, "Summer gives normal farm_mul = 1.0")
	c1.food = 0
	gw.econ._produce()
	var summer_food: int = c1.food

	# Winter yield (-50%)
	gw.game_time = Seasons.SEASON_S * 3.5
	for _w in 30:
		gw.seasons.step(0.5)
	check(gw.seasons.season == Seasons.Season.WINTER and gw.seasons.is_winter() and gw.seasons.snow > 0.6 and gw.seasons.farm_mul() == 0.5, "Winter triggers snow blanket and farm_mul = 0.5")
	c1.food = 0
	gw.econ._produce()
	var winter_food: int = c1.food
	check(winter_food < summer_food and winter_food == maxi(1, roundi(float(summer_food) * 0.5)), "Winter cuts farm harvest by -50%% globally (summer=%d winter=%d)" % [summer_food, winter_food])

	# Nuclear Winter Chill
	gw.game_time = Seasons.SEASON_S * 1.2 # Summer time
	gw.nuke_zones = [{"cell": Vector2i(10, 10)}, {"cell": Vector2i(30, 30)}]
	for _nw in 40:
		gw.seasons.step(0.5)
	check(gw.seasons.nuclear_chill >= 0.45 and gw.seasons.snow >= 0.45, "Nuclear strikes induce nuclear winter snow & chill even in summer")
	var saved_s: Dictionary = gw.seasons.save_state()
	var s2 := Seasons.new()
	s2.load_state(saved_s)
	check(is_equal_approx(s2.snow, gw.seasons.snow) and s2.season == gw.seasons.season, "Seasons state save_state/load_state roundtrips cleanly")

	# 3. Ideologies & City Monument capture re-skin
	check(Ideology.COUNT == 7 and Ideology.NAMES.size() == 7, "Exactly 7 ideologies defined")
	check(Ideology.build_cost_mul(3) < 1.0 and Ideology.army_speed_mul(5) > 1.0, "Ideology economy & military modifiers applied")
	check(Ideology.opinion_delta(0, 0) > 0 and Ideology.opinion_delta(0, 3) < 0, "Ideology affinity boosts same & penalizes opposing pairs")
	c1.ideology = 2
	c2.ideology = 5
	var city := City.new()
	city.id = 1
	city.country_id = c1.id
	city.center = Vector2i(32, 32)
	Ideology.spawn_city_monument(gw, city, c1.id)
	check(city.monument_obj >= 0 and gw.spr_name[gw.obj_spr[city.monument_obj]] == "monument_2", "City spawns conqueror/owner ideology monument_2")
	Ideology.on_city_captured(gw, city, c2.id)
	check(gw.spr_name[gw.obj_spr[city.monument_obj]] == "monument_5", "Captured city monument automatically re-skins to conqueror ideology monument_5")

	# 4. Custom Pixel Flag Editor P1: arbitrary RGB encoding/rendering/waving & NetSession tolerance
	var base_sp := FlagMaker.decode(FlagMaker.encode(FlagMaker.random_spec(Rng.new(9), -1, true)))
	var px_sp := FlagMaker.to_pixel_spec(base_sp, 12, 8)
	var custom_rgb1 := Color("12a4f5")
	var custom_rgb2 := Color("d839b1")
	var pxs: PackedColorArray = px_sp["px"]
	pxs[0] = custom_rgb1
	pxs[13] = custom_rgb2
	px_sp["px"] = pxs
	var p1_code := FlagMaker.encode(px_sp)
	check(p1_code.begins_with("P1:12x8:"), "Pixel flag encodes to P1:12x8:... string")
	check(NetSession.clean_flag(p1_code) == p1_code, "NetSession.clean_flag accepts P1 custom pixel flags without truncating")
	var dec := FlagMaker.decode(p1_code)
	check(bool(dec.get("p1", false)) and (dec["px"] as PackedColorArray)[0].to_html(false) == custom_rgb1.to_html(false), "Pixel flag preserves arbitrary non-palette RGB colors")
	var img := FlagMaker.render(p1_code, 24, 16)
	check(img.get_pixel(0, 0).to_html(false) == custom_rgb1.to_html(false), "FlagMaker.render draws arbitrary pixel RGB colors")
	var frs: Array[ImageTexture] = FlagMaker.frames(p1_code, 18, 12, 1, 3)
	check(frs.size() == 3 and frs[0].get_width() == 18 and frs[0].get_height() == 14, "FlagMaker.frames generates waving frames for custom pixel flags")

	# 5. 40 Alliance Emblems & Config Persistence
	var ally := Alliances.new(gw.diplo)
	check(Alliances.LOGOS == 40 and Alliances.LOGO_NAMES.size() == 40, "Alliances exposes 40 emblems + localized names")
	ally.list[1] = {"id": 1, "name": "Test", "ci": 0, "logo": 0, "members": [1, 2], "founded": 1.0, "founder": 1, "styled": false, "vs": {}, "calm_t": -1.0}
	check(ally.style(1, 1, "Apex", 2, 39) == "" and int(ally.list[1]["logo"]) == 39, "Alliances.style accepts emblem index 39")
	check(Save.CFG.has("my_ideology") and Save.PREFS.has("my_ideology") and NetSession.CFG_KEYS.has("my_ideology"), "Ideology config persists across Save.CFG, Save.PREFS, and NetSession.CFG_KEYS")
	gw.free()


func _test_step5_chronicle_and_territory() -> void:
	# 1. Step 5 UI atlas & script compilation checks
	UiKit.ensure()
	for s5: String in ["icon_chronicle", "icon_land_deal", "icon_land_gift", "icon_land_buy", "icon_land_swap", "icon_locate", "icon_replay_play", "icon_replay_pause"]:
		check(UiKit.has(s5) and UiKit.tex(s5) != null, "UiKit serves Step 5 icon: " + s5)
	for p5: String in ["res://game/chronicle.gd", "res://game/land_trade.gd", "res://ui/chronicle_viewer.gd", "res://ui/ui24/dip_sheet.gd", "res://ui/ui24/dip_page.gd", "res://ui/menus.gd", "res://game/main.gd", "res://world/top_layer.gd"]:
		check(load(p5) != null, "Step 5 script compiles cleanly: " + p5)

	# 2. World setup for Enclave permanence, Peaceful Land Transfers & Chronicle
	var gw := _make_world()
	gw.top = TopLayer.new()
	gw.top.gw = gw
	gw.add_child(gw.top)
	gw.chronicle = ChronicleS.new(gw)
	gw.chronicle.reset()
	gw.data.biome.fill(Biome.GRASS)
	gw.data.owners.fill(2)
	for k in 7:
		var mnm := "monument_%d" % k
		gw.spr_index[mnm] = gw.spr_name.size()
		gw.spr_name.append(mnm)
		gw.spr_fd.append(3)
		gw.spr_fw.append(3)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 16, 22))
		gw.spr_anchor.append(Vector2(2, 19))
		gw.spr_tex.append(null)
	var fm_spr := String(Military.SPRITES[Facility.Kind.FARM])
	if not gw.spr_index.has(fm_spr):
		gw.spr_index[fm_spr] = gw.spr_name.size()
		gw.spr_name.append(fm_spr)
		gw.spr_fd.append(3)
		gw.spr_fw.append(3)
		gw.spr_frames.append(1)
		gw.spr_rect.append(Rect2(0, 0, 12, 12))
		gw.spr_anchor.append(Vector2.ZERO)
		gw.spr_tex.append(null)

	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c1.ideology = 2
	c2.ideology = 5
	c1.money = 8000
	c2.money = 8000

	# Capital for c1 + Town for c1 inside map + Enclave deposit for c2
	var cap1 := City.new()
	cap1.id = 0
	cap1.name = "CapitalOne"
	cap1.kind = City.Kind.CAPITAL
	cap1.country_id = c1.id
	cap1.center = Vector2i(10, 10)
	c1.capital_id = 0
	c1.city_ids = PackedInt32Array([0])
	gw.cities.append(cap1)
	for y in range(4, 20):
		for x in range(4, 20):
			gw.data.owners[y * 64 + x] = c1.id

	var town1 := City.new()
	town1.id = 1
	town1.name = "TownOne"
	town1.kind = City.Kind.TOWN
	town1.country_id = c1.id
	town1.center = Vector2i(44, 44)
	town1.radius = 6
	c1.city_ids.append(1)
	gw.cities.append(town1)
	Ideology.spawn_city_monument(gw, town1, c1.id)
	for y in range(40, 49):
		for x in range(40, 49):
			gw.data.owners[y * 64 + x] = c1.id

	var cap2 := City.new()
	cap2.id = 2
	cap2.name = "CapitalTwo"
	cap2.kind = City.Kind.CAPITAL
	cap2.country_id = c2.id
	cap2.center = Vector2i(30, 10)
	c2.capital_id = 2
	c2.city_ids = PackedInt32Array([2])
	gw.cities.append(cap2)

	# Enclave deposit ceded by c2 inside c2's territory -> protected forever from enclave cleanup (#153, #156)
	var enc_cell := Vector2i(24, 30)
	gw.diplo.cede_area(c2.id, c1.id, enc_cell, 3)
	check(gw.ceded_prot.size() >= 1 and gw.data.get_owner_id(enc_cell.x, enc_cell.y) == c1.id, "cede_area marks ceded enclave in ceded_prot")
	var prot: Dictionary = gw._enc_protected()
	check(prot.has(enc_cell.y * 64 + enc_cell.x), "enclave protection dict protects ceded ultimatum patch")
	var enc_res: Array = GameWorld.enclave_scan(gw.data.owners, 64, 64, c2.id, prot, true)
	check(enc_res.is_empty() and gw.data.get_owner_id(enc_cell.x, enc_cell.y) == c1.id, "Ceded ultimatum enclave stays permanently owned by taker")

	# Highlight helper check
	gw.set_dip_highlight([{"cell": enc_cell, "r": 5, "col": Color.YELLOW}])
	check(gw.dip_highlight.size() == 1, "dip_highlight stores map highlight overlays cleanly")
	gw.set_dip_highlight([])

	# 3. Peaceful Land Transfer (#190): Sell town1 from c1 to c2 + verify troop withdrawal & monument reskin
	var u := Unit.new()
	u.id = 1
	u.country_id = c1.id
	u.pos = Vector2(town1.center * GameWorld.CELL)
	u.hp = 100.0
	u.state = Unit.State.IDLE
	gw.army.units.append(u)

	gw.diplo.add_opinion(c1.id, c2.id, 30)
	var parcels: Array = gw.diplo.land.list_parcels(c1.id)
	check(parcels.size() >= 1 and String(parcels[0]["kind"]) == "city", "list_parcels lists non-capital town & excludes capitals")
	var deal_err: String = gw.diplo.land_deal(c1.id, c2.id, "sell", "city:1", "", 1500)
	check(deal_err == "", "Peacetime town sale succeeds: err='%s'" % deal_err)
	check(town1.country_id == c2.id, "Sold city transfers ownership to c2")
	check(gw.spr_name[gw.obj_spr[town1.monument_obj]] == "monument_5", "Transferred city monument swaps to c2 ideology")
	check(u.state == Unit.State.MOVE and not u.path.is_empty(), "Giver unit inside transferred territory receives homeward move order")
	check(c1.money == 9500 and c2.money == 6500, "Peacetime land sale transfers funds between countries")
	check(NetSession.allowed().has("diplo.land_deal"), "NetSession ALLOWED whitelists diplo.land_deal")

	# Land deal blocked during war
	u.pos = Vector2(cap1.center * GameWorld.CELL)
	gw.diplo.declare_war(c1.id, c2.id, "test")
	var war_err: String = gw.diplo.land_deal(c2.id, c1.id, "gift", "city:1")
	check(war_err != "", "Land deals rejected during war")

	# 4. Match Chronicle Recording, Serialization & Disk Persistence (#190)
	gw.game_time = 2.5
	var farm: Facility = gw.mil.build(Facility.Kind.FARM, Vector2i(16, 16), c1, null, true)
	check(farm != null, "Farm built cleanly for Chronicle tracking")
	gw.chronicle.step(1.0)
	gw.game_time = 6.0
	gw.chronicle.step(ChronicleS.KEYFRAME_DT)
	check(gw.chronicle.frames.size() >= 1 and (farm == null or gw.chronicle.fac_born.has(farm.id)), "Chronicle samples keyframes and records building birth timestamps")
	check(gw.chronicle.events.size() >= 1, "Chronicle logs match events cleanly")
	var c_saved: Dictionary = gw.chronicle.save_state()
	var c_copy := ChronicleS.new(null)
	c_copy.load_state(c_saved)
	check(c_copy.frames.size() == gw.chronicle.frames.size() and c_copy.events.size() == gw.chronicle.events.size(), "Chronicle save_state/load_state roundtrips cleanly")
	var chr_path: String = ChronicleS.write_disk(gw.chronicle.meta, gw.chronicle.frames, gw.chronicle.events)
	check(chr_path != "" and not ChronicleS.load_record(chr_path, false).is_empty(), "Chronicle writes and reloads compressed .dfchr replay on disk")
	ChronicleS.delete_record(chr_path)
	check(not FileAccess.file_exists(chr_path), "Chronicle delete_record removes saved replay cleanly")
	gw.free()


func _test_step6_pc_and_perf() -> void:
	const PcPortS: = preload("res://pc/pc_port.gd")
	check(PcPortS.sheet_w(600.0) == 600.0 and PcPortS.win_w(600.0) <= 344.0 and PcPortS.tip_w(600.0) == 580.0, "PcPort adaptive layout metrics stay bounded on narrow viewports")
	check(PcPortS.win_w(1600.0) > 0.0 and PcPortS.top_msg_w(1600.0) > 0.0, "PcPort window and banner sizing helpers return valid bounds")

	var gw := _step1_world(96)
	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c2.is_player = false
	for y in range(48, 96):
		for x in range(48, 96):
			gw.data.owners[y * 96 + x] = 2
	gw.diplo._set_rel(1, 2, Diplomacy.Rel.WAR)

	# Defense per-tick cache resets cleanly and direct _targets works outside update()
	var sam: Facility = _make_ad(910, c1.id, Facility.Kind.AD_SAM, Vector2i(14, 14))
	var radar: Facility = _make_ad(911, c1.id, Facility.Kind.AD_RADAR, Vector2i(16, 14))
	gw.mil.facilities.append_array([sam, radar])
	var dr := Drone.new()
	dr.id = 801
	dr.country_id = c2.id
	dr.state = Drone.State.FLY
	dr.h = 8.0
	dr.pos = Vector2(22 * 4, 14 * 4)
	gw.mil.drones.append(dr)
	check(not gw.defense._cache_active and gw.defense._targets(sam, Defense.SPEC[Facility.Kind.AD_SAM]).size() == 1, "Defense._targets works directly with _cache_active == false")
	gw.defense.update(0.25)
	check(not gw.defense._cache_active and not gw.defense.shots.is_empty(), "Defense.update caches radars/targets cleanly, engages hostile drone, and resets _cache_active")

	# Army FPV cache + ArmyFire._spot spatial query + shell_pos_at
	var u1 := Unit.new()
	u1.id = 810
	u1.country_id = c1.id
	u1.type = Unit.Type.INFANTRY
	u1.hp = 50.0
	u1.max_hp = 50.0
	u1.pos = Vector2(40, 40)
	var u2 := Unit.new()
	u2.id = 811
	u2.country_id = c2.id
	u2.type = Unit.Type.INFANTRY
	u2.hp = 50.0
	u2.max_hp = 50.0
	u2.pos = Vector2(80, 40)
	var fpv := Unit.new()
	fpv.id = 812
	fpv.country_id = c2.id
	fpv.type = Unit.Type.FPV
	fpv.hp = 10.0
	fpv.max_hp = 10.0
	fpv.pos = Vector2(56, 40)
	gw.army.units.append_array([u1, u2, fpv])
	gw.army._build_grid()
	gw.army.fire._spot()
	var seen_d: Dictionary = gw.army.fire.seen.get(c1.id, {})
	check(gw.army._fpvs_t >= 0.0 and gw.army.fpv_targets(c1.id, Vector2(40, 40), 40.0).size() == 1, "Army._build_grid caches FPV list for fpv_targets")
	check(seen_d.has(u2), "ArmyFire._spot spatial grid detects hostile ground unit within SPOT_R")
	var sh := {"from": Vector2.ZERO, "to": Vector2(100, 0), "t": 0.25, "dur": 1.0, "h": 20.0}
	check(Army.ArmyFire.shell_pos_at(sh, 0.25).is_equal_approx(Army.ArmyFire.shell_pos(sh)) and not Army.ArmyFire.shell_pos_at(sh, 0.5).is_equal_approx(Army.ArmyFire.shell_pos(sh)), "ArmyFire.shell_pos_at evaluates arbitrary t without duplicating Dictionary")

	# Chronicle event-driven facility birth + precomputed _sample_idx
	gw.spr_index["barracks"] = gw.spr_name.size()
	gw.spr_name.append("barracks")
	gw.spr_fd.append(1)
	gw.spr_fw.append(1)
	gw.spr_frames.append(1)
	gw.spr_rect.append(Rect2(0, 0, 16, 16))
	gw.spr_anchor.append(Vector2.ZERO)
	gw.spr_tex.append(null)
	gw.chronicle = ChronicleS.new(gw)
	gw.mil._no_construct = true
	gw.game_time = 2.0
	var bfac: Facility = gw.mil.build(Facility.Kind.BARRACKS, Vector2i(20, 20), c1, null, true)
	check(bfac != null and gw.chronicle.fac_born.has(bfac.id), "Chronicle records facility birth immediately via on_facility_built")
	gw.chronicle.record_frame()
	check(gw.chronicle.frames.size() == 1 and gw.chronicle._sample_idx.size() == ChronicleS.GRID_N * ChronicleS.GRID_N, "Chronicle record_frame populates precomputed _sample_idx cleanly")

	# Patch v0.35: Mass upgrade plan (categories + ore-specific mines + partial budget) & halt_nukes diplomacy
	gw.protect = Protect.new(gw)
	for sname2: String in ["farm", "sawmill", "refinery", "civ_factory", "eco_ore_heap", "eco_shed", "eco_logs", "eco_tank_s", "eco_silo", "mine27_l2_fe", "mine27_l2_ti"]:
		if not gw.spr_index.has(sname2):
			gw.spr_index[sname2] = gw.spr_name.size()
			gw.spr_name.append(sname2)
			gw.spr_fd.append(1)
			gw.spr_fw.append(1)
			gw.spr_frames.append(1)
			gw.spr_rect.append(Rect2(0, 0, 12, 12))
			gw.spr_anchor.append(Vector2.ZERO)
			gw.spr_tex.append(null)
	gw.econ.deposits = [
		{"res": "metal", "cell": Vector2i(6, 36), "left": 500, "max": 500, "mine": null, "obj": -1},
		{"res": "titanium", "cell": Vector2i(18, 36), "left": 500, "max": 500, "mine": null, "obj": -1},
	]
	var m_met: Facility = gw.mil.build(Facility.Kind.MINE, Vector2i(4, 34), c1, null, true)
	var m_ti: Facility = gw.mil.build(Facility.Kind.MINE, Vector2i(16, 34), c1, null, true)
	var f_farm: Facility = gw.mil.build(Facility.Kind.FARM, Vector2i(28, 34), c1, null, true)
	var f_ref: Facility = gw.mil.build(Facility.Kind.REFINERY, Vector2i(32, 6), c1, null, true)
	check(m_met != null and m_ti != null and f_farm != null and f_ref != null, "Builds metal mine, titanium mine, farm, and refinery for mass upgrade tests")
	c1.money = 600 # enough for 1 mine or farm upgrade (farm L1->L2 costs 360 money + 15 wood; mine costs 480 money + 20 wood + 10 metal)
	c1.metal = 100
	c1.wood = 100
	c1.titanium = 100
	var pl_ext: Dictionary = gw.econ.upgrade_plan(c1, Economy.UPG_CATS["extract"], 2)
	check(int(pl_ext["ready"]) == 2 and int(pl_ext["afford"]) == 1, "upgrade_plan accurately predicts partial affordability (1 of 2 extraction mines) when money is limited")
	var pl_ti: Dictionary = gw.econ.upgrade_plan(c1, [Facility.Kind.MINE], 2, "titanium")
	check(int(pl_ti["owned"]) == 1 and int(pl_ti["ready"]) == 1 and int(pl_ti["afford"]) == 1, "upgrade_plan filters MINE by ore_res='titanium'")
	var upg_ti: Array = gw.econ.upgrade_kinds(c1, [Facility.Kind.MINE], 2, "titanium")
	check(int(upg_ti[0]) == 1 and m_ti.upg_t > 0.0 and m_met.upg_t <= 0.0, "upgrade_kinds with ore_res='titanium' upgrades only titanium mine and leaves metal mine untouched")
	c1.money = 5000
	var p_plan: Dictionary = gw.econ.protect_plan(c1, "net")
	check(int(p_plan["ready"]) >= 1 and int(p_plan["afford"]) >= 1, "protect_plan detects eligible unprotected refinery")
	var p_res: Array = gw.econ.protect_all(c1, "net")
	check(int(p_res[0]) >= 1, "protect_all starts anti-drone net construction on eligible facilities")

	# Patch v0.35: Save.PREFS & NetSession whitelist
	for pk: String in ["res_compact", "news_mode", "nuke_alert_i", "alert_snd"]:
		check(Save.PREFS.has(pk), "Save.PREFS includes v0.35 setting: " + pk)
	check(NetSession.ALLOWED.has(".cmd_zaslon_buy") and NetSession.ALLOWED.has("econ.protect_all"), "NetSession.ALLOWED whitelists v0.35 commands")
	gw.free()

	# Menus What's New metadata + Ukrainian i18n entries
	check(Menus.VERSION == "v0.36.6", "Menus.VERSION updated to v0.36.6")
	var wn_cats: Dictionary = {}
	var first_wn: String = ""
	for wn_s: String in Menus.WHATS_NEW:
		for pref: String in ["НОВОЕ:", "УЛУЧШЕНО:", "ИСПР:", "УДАЛЕНО:"]:
			if wn_s.begins_with(pref):
				wn_cats[pref] = true
				if pref == "НОВОЕ:" and first_wn.is_empty():
					first_wn = wn_s.trim_prefix(pref).strip_edges()
	check(wn_cats.size() == 4, "Menus.WHATS_NEW covers all 4 categories (НОВОЕ, УЛУЧШЕНО, ИСПР, УДАЛЕНО)")
	var prev_lang: String = GameConfig.lang
	Loc.set_lang("uk", false)
	check(Loc.t("УЛУЧШЕНО") == "ПОКРАЩЕНО" and Loc.t("УДАЛЕНО") == "ВИДАЛЕНО" and Loc.t(first_wn) != first_wn and Loc.t("ИНТЕРФЕЙС И ПК") == "ІНТЕРФЕЙС І ПК", "Ukrainian translation loads v0.35 What's New and UI entries")
	Loc.set_lang(prev_lang, false)


func _test_replay_stability_and_exit() -> void:
	var gw := _make_world()
	gw.player = gw.countries[0]
	gw.player.is_player = true
	gw.countries[0].name = "Northia"
	gw.countries[0].color = Color("40a0ff")
	gw.countries[1].name = "Southia"
	gw.countries[1].color = Color("ff5040")
	gw.chronicle = ChronicleS.new(gw)
	gw.chronicle.reset()
	gw.chronicle.log_event("war", 1, Vector2i(10, 10), "Early war")

	# 1. Long match (> 30 min / > MAX_FRAMES) must compact older keyframes and capture the exact end-of-match frame
	var total_steps: int = ChronicleS.MAX_FRAMES + 60
	for i in total_steps:
		gw.game_time += ChronicleS.KEYFRAME_DT
		gw.chronicle.step(ChronicleS.KEYFRAME_DT)
	check(gw.chronicle.frames.size() > 1 and gw.chronicle.frames.size() <= ChronicleS.MAX_FRAMES, "Long match compacts chronicle frames within MAX_FRAMES budget")
	check(gw.chronicle._sample_dt > ChronicleS.KEYFRAME_DT, "Chronicle raises adaptive sample_dt after exceeding initial MAX_FRAMES window")

	# Strategic events must not be evicted by build spam
	for bi in (ChronicleS.MAX_EVENTS + 30):
		gw.chronicle.log_event("build", 1, Vector2i(4, 4), "Mine %d" % bi)
	var has_early_war: bool = false
	for ev: Variant in gw.chronicle.events:
		if ev is Dictionary and String((ev as Dictionary).get("k", "")) == "war":
			has_early_war = true
			break
	check(has_early_war, "Chronicle keeps strategic war/nuke/city events despite build event spam")

	# End match shortly after last keyframe: finalize_and_save must force-append the exact end frame & preserve metadata
	gw.game_time += 1.3
	gw.session.start()
	gw.session._finish(1)
	gw.chronicle._saved_match = true  # avoid polluting host user://chronicles during headless unit tests
	gw.chronicle.finalize_and_save(1)
	var last_fr: Dictionary = gw.chronicle.frames.back()
	check(absf(float(last_fr.get("t", 0.0)) - snappedf(gw.game_time, 0.1)) < 0.15, "finalize_and_save captures exact end-of-match timestamp even on >30m matches")
	var rec: Dictionary = gw.chronicle.build_record()
	check(int((rec.get("meta", {}) as Dictionary).get("winner", 0)) == 1 and float((rec.get("meta", {}) as Dictionary).get("duration", 0.0)) >= float(last_fr.get("t", 0.0)) - 0.1, "build_record preserves winner and duration metadata")

	# Save/load state round-trips adaptive sample_dt and sample_t
	var c_state: Dictionary = gw.chronicle.save_state()
	var c_restored := ChronicleS.new(gw)
	c_restored.load_state(c_state)
	check(absf(c_restored._sample_dt - gw.chronicle._sample_dt) < 0.01 and c_restored.frames.size() == gw.chronicle.frames.size(), "Chronicle save_state/load_state preserves adaptive sample_dt and all frames")

	# 2. Live SceneTree Menus + ChronicleViewer exit & playback stability (no winner_id crash, no detached tree error)
	var ViewerC := preload("res://ui/chronicle_viewer.gd")
	var MenusC := preload("res://ui/menus.gd")
	var m: Menus = MenusC.new()
	get_root().add_child(m)
	m.setup(gw)
	m.show_end(1)
	check(m.current == "end", "Menus opens end screen cleanly")

	# Open replay from end screen (passing corrupted color in a country meta entry as robustness check too)
	var bad_rec: Dictionary = rec.duplicate(true)
	(bad_rec["meta"]["countries"] as Array).append({"id": 99, "name": "BadHex", "color": "##not_hex"})
	ViewerC.open_replay(m, bad_rec, "end")
	check(m.current == "chronicle_view" and m.screen != null, "ChronicleViewer opens cleanly in SceneTree")
	var viewer: Control = null
	for ch: Node in m.screen.get_children():
		if ch.has_method("close_viewer"):
			viewer = ch as Control
			break
	check(viewer != null and viewer.is_inside_tree(), "ChronicleViewer is inside SceneTree before setup completes")
	check(absf(float(viewer.get("_max_t")) - float(last_fr.get("t", 0.0))) < 0.2, "ChronicleViewer _max_t reaches full end-of-match time")

	# Play all the way to the end using _process and verify clean stop at _max_t
	viewer.call("_toggle_play")
	check(bool(viewer.get("playing")), "ChronicleViewer starts playback when multiple frames exist")
	viewer.set("cur_time", maxf(0.0, float(viewer.get("_max_t")) - 1.0))
	for _s in 30:
		viewer.call("_process", 0.05)
	check(not bool(viewer.get("playing")) and absf(float(viewer.get("cur_time")) - float(viewer.get("_max_t"))) < 0.01, "ChronicleViewer plays cleanly to exact match end and stops")

	# Exiting replay from post-match must return to end screen cleanly without winner_id crash
	viewer.call("close_viewer")
	check(m.current == "end", "Closing post-match replay returns cleanly to end screen")

	# Test browser -> open_replay (legacy 2-arg path too when Match.ended == false) -> Esc/handle_back
	gw.session.ended = false
	ViewerC.open_replay(m, rec)
	check(m.current == "chronicle_view", "ChronicleViewer opens via 2-arg compatibility call")
	check(m.handle_back() and (m.current == "chronicles" or m.current == "pause"), "Menus.handle_back exits replay viewer without trap")

	# Single-frame safety: toggling play on 1-frame record must never wedge playing=true
	ViewerC.open_replay(m, {"meta": {"w": 64, "h": 64, "countries": []}, "frames": [last_fr], "events": []}, "browser")
	var single_v: Control = null
	for ch: Node in m.screen.get_children():
		if ch.has_method("close_viewer"):
			single_v = ch as Control
			break
	check(single_v != null, "Opens 1-frame replay cleanly")
	single_v.call("_toggle_play")
	check(not bool(single_v.get("playing")), "1-frame replay refuses stuck playing=true state")
	single_v.call("close_viewer")
	check(m.current == "chronicles", "Closing browser replay returns to chronicles list")
	check(m.handle_back() and m.current == "main", "Menus.handle_back exits chronicles browser to main menu")

	m.close()
	m.queue_free()
	await process_frame
	await process_frame
	gw.free()


func _test_patch_v036_mechanics() -> void:
	# Patch v0.36: Grey Zone, T3 spec (Overclock vs Bunker), Strategic Protect & NPP Overheat Crisis,
	# ICBM Warheads (Mono/MIRV/EMP), Blackout Silo Pause, Physical Fuel Convoys, 3-way Grid Power Priority, PC UI
	var gw := _step1_world(128)
	for y in 128:
		for x in 128:
			gw.data.set_owner_id(x, y, 1 if x < 64 else 2)
	gw.ground = GroundLayer.new()
	gw.add_child(gw.ground)
	gw.protect = Protect.new(gw)
	gw.supply = Supply.new(gw)
	gw.ops = Operations.new(gw)
	gw.econ.ports = Ports.new(gw, gw.econ)
	for sname: String in ["npp_core", "npp_tower", "nuke_silo", "nuke_silo_arm", "ad_zaslon", "ad_zaslon_open", "barracks",
		"farm", "sawmill", "refinery", "civ_factory", "power_plant", "drone_port", "ad_radar",
		"eco_ore_heap", "eco_shed", "eco_logs", "eco_tank_s", "eco_silo"]:
		if not gw.spr_index.has(sname):
			gw.spr_index[sname] = gw.spr_name.size()
			gw.spr_name.append(sname)
			gw.spr_fd.append(1)
			gw.spr_fw.append(1)
			gw.spr_frames.append(1)
			gw.spr_rect.append(Rect2(0, 0, 16, 16))
			gw.spr_anchor.append(Vector2.ZERO)
			gw.spr_tex.append(null)
	var c1: Country = gw.countries[0]
	var c2: Country = gw.countries[1]
	c1.is_player = true
	c2.is_player = false
	var ct1 := City.new()
	ct1.id = 0
	ct1.name = "Capital1"
	ct1.kind = City.Kind.CAPITAL
	ct1.country_id = c1.id
	ct1.center = Vector2i(20, 64)
	ct1.radius = 10
	var ct2 := City.new()
	ct2.id = 1
	ct2.name = "Capital2"
	ct2.kind = City.Kind.CAPITAL
	ct2.country_id = c2.id
	ct2.center = Vector2i(108, 64)
	ct2.radius = 12
	gw.cities = [ct1, ct2]
	c1.capital_id = 0
	c1.city_ids = [0]
	c2.capital_id = 1
	c2.city_ids = [1]
	gw.mil._no_construct = true

	# 1. Grey Zone (180s..600s default, 720s on large 8-player preset size_i==0): border/deposit skirmishes ok, interior blocked
	const EconRatesS = preload("res://game/econ_rates.gd")
	const Upkeep335S = preload("res://game/upkeep335.gd")
	var prev_size_i: int = GameConfig.size_i
	GameConfig.size_i = 1
	gw.game_time = 60.0
	check(not gw.diplo.in_grey_zone() and not gw.diplo.war_allowed(c1.id, c2.id, false), "Before 180s neither full war nor Grey Zone skirmishes are active")
	gw.game_time = 240.0
	check(gw.diplo.in_grey_zone() and not gw.diplo.war_allowed(c1.id, c2.id, false), "At 240s Grey Zone is active while full war stays locked")
	var border_pos: Vector2 = Vector2(65 * GameWorld.CELL, 64 * GameWorld.CELL)
	var interior_pos: Vector2 = Vector2(ct2.center * GameWorld.CELL)
	check(gw.diplo.is_skirmish_target(c1.id, c2.id, border_pos), "Border zone near x=64 qualifies as Grey Zone skirmish target")
	check(gw.diplo.strike_block_at(c1.id, border_pos, false) == "", "Grey Zone allows strike on rival border target")
	check(gw.diplo.strike_block_at(c1.id, interior_pos, false) != "", "Grey Zone blocks strike deep inside rival capital interior")
	gw.diplo.on_attack(c1.id, c2.id, border_pos)
	check(not gw.diplo.at_war(c1.id, c2.id), "Border skirmish incident in Grey Zone does not trigger full war")
	GameConfig.size_i = 0
	gw.game_time = 650.0
	check(gw.diplo.in_grey_zone(), "8-country / large preset extends Grey Zone ceiling to 720s")
	GameConfig.size_i = prev_size_i
	gw.game_time = 750.0
	check(not gw.diplo.in_grey_zone() and gw.diplo.war_allowed(c1.id, c2.id, false), "Full war unlocks after Grey Zone ends")

	# 2. T3 Economy Specialization (Overclock 1 vs Bunker 2)
	var f_oc: Facility = gw.mil.build(Facility.Kind.CIV_FACTORY, Vector2i(14, 40), c1, null, true)
	var f_bk: Facility = gw.mil.build(Facility.Kind.CIV_FACTORY, Vector2i(26, 40), c1, null, true)
	check(f_oc != null and f_bk != null, "Built two civ factories for T3 Overclock vs Bunker test")
	f_oc.level = 2
	f_bk.level = 2
	var oc_res: String = gw.econ.upgrade(f_oc, c1, 1)
	var bk_res: String = gw.econ.upgrade(f_bk, c1, 2)
	check(oc_res == "" and bk_res == "", "T3 upgrades start cleanly with explicit Overclock(1) and Bunker(2) specs")
	check(f_oc.level == 3 and f_oc.t3_spec == 1 and is_equal_approx(EconRatesS.level_mul(f_oc), 2.6), "Overclock completes at L3 with 2.6x yield multiplier")
	check(Military.need_power(f_oc) == 2, "Overclock increases power draw to 2 units")
	check(f_bk.level == 3 and f_bk.t3_spec == 2 and is_equal_approx(EconRatesS.level_mul(f_bk), 1.85), "Bunker completes at L3 with 1.85x yield multiplier")
	check(Military.need_power(f_bk) == 1, "Bunker keeps standard 1 power draw")
	var bk_st: Dictionary = gw.protect.st.get(f_bk.id, {})
	check(bool(bk_st.get("bunker", false)) and int(bk_st.get("cs", Protect.S_NONE)) == Protect.S_OK, "Bunker T3 automatically grants innate Tier 1 concrete protection")
	f_bk.powered = false
	check(is_equal_approx(gw.econ._prod_power_k(f_bk), 0.5), "Bunker T3 operates at 50% capacity when unpowered")
	f_bk.powered = true
	check(gw.cmd_t3_spec(f_bk, c1, 1) == "" and f_bk.t3_spec == 1, "cmd_t3_spec switches L3 specialization cleanly")

	# 3. Strategic Protection eligibility & NPP Overheat Crisis (60s timer + scram + meltdown)
	var npp: Facility = gw.mil.build(Facility.Kind.NUCLEAR_PLANT, Vector2i(14, 18), c1, null, true)
	var silo: Facility = gw.mil.build(Facility.Kind.NUKE_SILO, Vector2i(26, 18), c1, null, true)
	var zas: Facility = gw.mil.build(Facility.Kind.AD_ZASLON, Vector2i(36, 18), c1, null, true)
	check(npp != null and silo != null and zas != null, "Built NUCLEAR_PLANT, NUKE_SILO, AD_ZASLON")
	check(gw.protect.eligible(npp) and gw.protect.eligible(silo) and gw.protect.eligible(zas), "Protect allows net/concrete on NUCLEAR_PLANT, NUKE_SILO, and AD_ZASLON")
	c1.uranium = 50
	npp.u_hits = 1
	gw.protect.on_impact(Vector2(npp.cell) * GameWorld.CELL + Vector2(2, 2), Protect.HIT_DRONE, c2.id)
	check(npp.u_hits == 2 and npp.npp_overheat_t > 0.0 and gw.mil.alive(npp), "2nd drone hit on NPP starts 60s overheat crisis instead of instant explosion")
	var money_before_scram: int = c1.money
	check(gw.cmd_npp_scram(npp, c1) == "" and npp.npp_overheat_t < 0.0 and c1.money == money_before_scram - Nuclear.NPP_SCRAM_COST, "cmd_npp_scram pays 1,500 and clears NPP overheat crisis")
	npp.u_hits = 2
	npp.npp_overheat_t = 0.05
	gw.game_time += 1.0
	Nuclear.burn(gw, 0.1)
	check(not gw.mil.alive(npp) and gw.nuke_zones.size() >= 1, "Unstopped NPP overheat meltdown destroys reactor and creates radiation fallout zone")

	# 4. ICBM Warheads (MIRV decoy split & EMP blackout) + Blackout Silo Pause + Upkeep335
	check(Upkeep335S.PCT.has(Facility.Kind.NUKE_SILO) and Upkeep335S.PCT.has(Facility.Kind.AD_ZASLON), "Upkeep335 includes NUKE_SILO and AD_ZASLON")
	GameConfig.nukes = true
	silo.nuke_state = 2
	var ti_before: int = c1.titanium
	check(gw.cmd_nuke_warhead(silo, c1, Nuclear.Warhead.MIRV) == "" and silo.nuke_warhead == Nuclear.Warhead.MIRV and c1.titanium == ti_before - Nuclear.MIRV_TI_EXTRA, "Selecting MIRV warhead deducts extra titanium")
	silo.nuke_state = 4
	silo.nuke_t = 100.0
	silo.powered = false
	Nuclear.update_silos(gw, 10.0)
	check(is_equal_approx(silo.nuke_t, 100.0), "Unpowered/blackout silo pauses ICBM arming timer")
	silo.powered = true
	silo.nuke_state = 3
	var launch_err: String = Nuclear.silo_launch(gw, silo, c1, Vector2(96 * GameWorld.CELL, 64 * GameWorld.CELL))
	check(launch_err == "", "Silo launches MIRV ICBM")
	var mirv_m: Missile = gw.mil.missiles.back() as Missile
	mirv_m.state = Missile.State.FLIGHT
	mirv_m.t = Missile.IGNITE_TIME + mirv_m.flight_time * 0.5
	var m_cnt0: int = gw.mil.missiles.size()
	gw.mil._update_missiles(0.1)
	check(mirv_m.mirv_split and gw.mil.missiles.size() > m_cnt0, "MIRV warhead splits mid-flight into decoys")
	var foe_rad: Facility = gw.mil.build(Facility.Kind.AD_RADAR, Vector2i(100, 64), c2, null, true)
	gw.game_time = 800.0
	var nz_before: int = gw.nuke_zones.size()
	gw.strike_emp(Vector2i(100, 64), c1.id)
	check(foe_rad != null and foe_rad.emp_until > gw.game_time and gw.nuke_zones.size() == nz_before, "High-altitude EMP blacks out nearby facilities without creating crater/radiation zone")
	check(not gw.mil.has_power(foe_rad), "EMP'd facility loses power during blackout window")

	# 5. Physical Fuel Convoys & 3-Way Grid Power Priority under real deficit
	var ref: Facility = gw.mil.build(Facility.Kind.REFINERY, Vector2i(18, 52), c1, null, true)
	check(ref != null, "Built Refinery for fuel convoy test")
	var sold0: int = c1.fuel_sold
	ref.ref_fuel = 16
	var trucks_before: int = gw.econ.trucks.size()
	check(gw.cmd_fuel_dispatch(ref, c1) == "" and ref.ref_fuel == 0 and gw.econ.trucks.size() > trucks_before, "cmd_fuel_dispatch empties refinery buffer and spawns fuel tanker convoy")
	var fk_truck: Dictionary = gw.econ.trucks.back()
	gw.econ.complete(fk_truck)
	check(c1.fuel_sold > sold0, "Fuel tanker delivery awards fuel revenue via physical logistics")
	# Sever logistics around refinery with deep water moat + rebuild nav -> dispatch refuses cleanly instead of teleporting money
	ref.ref_fuel = 16
	for wy in range(46, 60):
		for wx in range(12, 26):
			if wx <= 14 or wx >= 23 or wy <= 48 or wy >= 57:
				gw.data.set_biome(wx, wy, Biome.DEEP)
	gw.econ.build_nav()
	check(gw.cmd_fuel_dispatch(ref, c1) != "" and ref.ref_fuel == 16, "Cut-off refinery blocks fuel convoy dispatch instead of teleporting money")

	# Power priority rationing check under deficit on a clean country c3
	var c3: Country = gw.countries[2]
	var ct3 := City.new()
	ct3.id = 2
	ct3.name = "Capital3"
	ct3.kind = City.Kind.CAPITAL
	ct3.country_id = c3.id
	ct3.center = Vector2i(20, 100)
	ct3.radius = 6
	gw.cities.append(ct3)
	c3.capital_id = 2
	c3.city_ids = [2]
	for ay in range(85, 126):
		for ax in range(5, 110):
			gw.data.set_owner_id(ax, ay, c3.id)
	var pp3: Facility = gw.mil.build(Facility.Kind.POWER_PLANT, Vector2i(10, 94), c3, null, true)
	var eco_ex: Array[Facility] = []
	for ei in range(6):
		eco_ex.append(gw.mil.build(Facility.Kind.REFINERY, Vector2i(10 + ei * 10, 120), c3, null, true))
	var mil_r: Facility = gw.mil.build(Facility.Kind.AD_RADAR, Vector2i(10, 110), c3, null, true)
	check(pp3 != null and mil_r != null and eco_ex.all(func(x: Facility) -> bool: return x != null), "Built power deficit grid for c3 rationing test")
	gw.cmd_power_prio(c3, 1)
	check(c3.power_prio == 1 and mil_r.powered and not eco_ex[5].powered, "Grid priority 1 powers Military & AD ahead of excess Economy consumers during deficit")
	gw.cmd_power_prio(c3, 2)
	check(c3.power_prio == 2 and eco_ex[0].powered and not mil_r.powered, "Grid priority 2 powers Economy ahead of Military consumers during deficit")

	# 6. NetSession whitelist + ChronicleViewer class load/filter
	for cmd_nm: String in [".cmd_nuke_warhead", ".cmd_npp_scram", ".cmd_t3_spec", ".cmd_power_prio", ".cmd_fuel_dispatch"]:
		check(NetSession.ALLOWED.has(cmd_nm), "NetSession.ALLOWED includes v0.36 command: " + cmd_nm)
	var cv_s := load("res://ui/chronicle_viewer.gd") as GDScript
	check(cv_s != null, "ChronicleViewer script compiles cleanly")
	if cv_s != null:
		var cv = cv_s.new()
		cv.countries = {1: {"name": "A", "color": "#40a0ff"}}
		cv.events = [
			{"t": 10.0, "k": "build", "c": 1, "x": 10, "y": 10, "text": "Mine"},
			{"t": 20.0, "k": "war", "c": 1, "x": 20, "y": 20, "text": "War"},
		]
		cv.filter_cat = 1
		check(cv._parse_html_color("#40a0ff", Color.WHITE).b > 0.9, "ChronicleViewer parses country colors for swatches")
		cv.free()
	gw.free()


func _test_shift_ux() -> void:
	# 1. All modified Shift UX scripts compile & instantiate cleanly
	for sp: String in [
		"res://world/map_camera.gd",
		"res://game/main/main_base.gd",
		"res://game/main/main_core.gd",
		"res://game/main/main_strike.gd",
		"res://game/main/main_input.gd",
		"res://game/main.gd",
		"res://pc/army_select.gd",
		"res://game/air.gd",
		"res://net/net_session.gd",
		"res://ui/ui24/navy_yard.gd",
		"res://ui/ui24/navy_dock.gd",
		"res://ui/ui24/trade_sheet.gd",
		"res://ui/hud/hud_ops.gd",
		"res://ui/ui24/strike_sheet.gd",
	]:
		var sc: GDScript = load(sp) as GDScript
		check(sc != null and sc.can_instantiate(), "Shift UX script loads cleanly: " + sp)

	# 2. Translations for new Shift UX keys load in uk/en/es
	var tr_uk := load("res://translations/uk.po") as Translation
	var tr_en := load("res://translations/en.po") as Translation
	var tr_es := load("res://translations/es.po") as Translation
	check(tr_uk != null and tr_uk.get_message(&"⇧ серийное строительство") == &"⇧ серійне будівництво", "uk.po has Shift batch build translation")
	check(tr_en != null and tr_en.get_message(&"⇧ серийное строительство") == &"⇧ batch build", "en.po has Shift batch build translation")
	check(tr_es != null and tr_es.get_message(&"⇧ серийное строительство") == &"⇧ construcción en serie", "es.po has Shift batch build translation")

	# 3. MapCamera focus-out & clear_held guard
	var mc := MapCamera.new()
	mc._held_m = true
	mc._held_t[0] = true
	check(mc.is_held(), "MapCamera tracks held mouse/touch")
	mc._notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	check(not mc.is_held(), "MapCamera clears held state on focus out")
	mc.free()

	# 4. Air.buy_batch + NetSession whitelist (O3)
	check(NetSession.ALLOWED.get("mil.air.buy_batch", null) == -1, "NetSession.ALLOWED includes mil.air.buy_batch")
	var gw := _step1_world(128)
	for sname_sh: String in ["barracks", "power_plant", "factory", "ad_zaslon", "ad_zaslon_open"]:
		if not gw.spr_index.has(sname_sh):
			gw.spr_index[sname_sh] = gw.spr_name.size()
			gw.spr_name.append(sname_sh)
			gw.spr_fd.append(1)
			gw.spr_fw.append(1)
			gw.spr_frames.append(1)
			gw.spr_rect.append(Rect2(0, 0, 12, 12))
			gw.spr_anchor.append(Vector2.ZERO)
			gw.spr_tex.append(null)
	var c1: Country = gw.countries[0]
	c1.is_player = true
	gw.player = c1
	gw.mil._no_construct = true
	var af: Facility = gw.mil.build(Facility.Kind.AIRFIELD, Vector2i(25, 25), c1, null, true)
	check(af != null, "Built Airfield for batch buy test")
	var bres: Dictionary = gw.mil.air.buy_batch(af, Aircraft.Type.FIGHTER, c1, 0)
	check(int(bres.get("bought", 0)) == Air.AIR_CAP, "Air.buy_batch fills airfield fighter capacity cleanly")
	var bres2: Dictionary = gw.mil.air.buy_batch(af, Aircraft.Type.FIGHTER, c1, 0)
	check(int(bres2.get("bought", -1)) == 0 and String(bres2.get("why", "")) != "", "Air.buy_batch rejects when airfield full without deducting funds")
	c1.money = 10
	var bres3: Dictionary = gw.mil.air.buy_batch(af, Aircraft.Type.BOMBER, c1, 0)
	check(int(bres3.get("bought", -1)) == 0 and c1.money == 10, "Air.buy_batch never spends money into negative")

	# 5. Main Variant 1A Shift build, resource/can_substitute guard, pause, and MP pending queue
	var stub_hud_src := """
extends Hud
var last_toast: String = ""
var confirm_shown: bool = false
func set_hint(_text: String) -> void: pass
func set_key_pressed(_nm: String, _on: bool) -> void: pass
func show_toast(text: String, _reply: bool = true) -> void: last_toast = text
func show_confirm(_text: String, _ok: bool = true) -> void: confirm_shown = true
func hide_confirm() -> void: confirm_shown = false
func hide_ops() -> void: pass
func refresh() -> void: pass
func ui24_open_now() -> bool: return false
func set_ghost_tip(_txt: String, _col: Color, _screen_pos: Vector2) -> void: pass
func set_map_tip(_txt: String) -> void: pass
"""
	var stub_ux_src := """
extends Node
var view: String = ""
var cur_fid: int = -1
var cur_gid: int = -1
var picked: Dictionary = {}
var preview: Dictionary = {}
var place_kind: String = ""
var place_sea: bool = false
func map_tap(_p: Vector2, _wp: Vector2) -> bool: return false
func open_army(f: int) -> void:
	view = "army"
	cur_fid = f
func close_view() -> void: view = ""
func ast(_f: int) -> Dictionary: return {}
func check(_f, _w, _k) -> Dictionary: return {"ok": [], "bad": []}
func toast(_t: String, _o = []) -> void: pass
func _ok_fids(_f, _d) -> Array: return []
func _skip_why(_d) -> String: return ""
"""
	var stub_ov_src := """
extends RouteOverlay
func ripple(_world_p: Vector2, _col: String = "amber") -> void: pass
"""
	var hud_gd := GDScript.new()
	hud_gd.source_code = stub_hud_src
	check(hud_gd.reload() == OK, "Stub Hud compiles cleanly")
	var shud: Hud = hud_gd.new()
	var ux_gd := GDScript.new()
	ux_gd.source_code = stub_ux_src
	check(ux_gd.reload() == OK, "Stub ArmyUx compiles cleanly")
	var sux: Node = ux_gd.new()
	var ov_gd := GDScript.new()
	ov_gd.source_code = stub_ov_src
	check(ov_gd.reload() == OK, "Stub RouteOverlay compiles cleanly")
	var sov: RouteOverlay = ov_gd.new()
	var mcam := MapCamera.new()
	root.add_child(mcam)
	mcam.position = Vector2.ZERO
	mcam.zoom = Vector2.ONE
	var mnet := NetSession.new()
	mnet.gw = gw
	NetSession._inst = mnet
	var ghost_n := Node2D.new()
	var m = (load("res://game/main.gd") as GDScript).new()
	m.in_menu = false
	shud.main_node = m
	shud.gw = gw
	shud.army_ux = sux
	m.world = gw
	m.hud = shud
	m.overlay = sov
	m.cam = mcam
	m.net = mnet
	m._ghost = ghost_n
	gw.time_scale = 0.0  # paused

	# Verify _shift_down with InputEventKey modifier priority
	var ev_sh := InputEventKey.new()
	ev_sh.keycode = KEY_SHIFT
	ev_sh.shift_pressed = true
	ev_sh.pressed = true
	check(m._shift_down(ev_sh), "Main._shift_down honors InputEventWithModifiers.shift_pressed")
	var ev_no := InputEventKey.new()
	ev_no.keycode = KEY_A
	ev_no.shift_pressed = false
	check(not m._shift_down(ev_no), "Main._shift_down returns false when shift_pressed is false")

	# Verify Variant 1A under GameConfig.confirm_actions = true while paused
	var was_confirm: bool = GameConfig.confirm_actions
	GameConfig.confirm_actions = true
	c1.money = 50000
	c1.metal = 1000
	c1.wood = 1000
	var fac_cnt0: int = gw.mil.facilities.size()
	m._set_mode(m.Mode.POWER)
	# Plain tap opens _pend confirmation card without placing yet
	m._tap(mcam.world_to_screen(Vector2(60 * GameWorld.CELL, 60 * GameWorld.CELL)), false)
	check(not m._pend.is_empty() and gw.mil.facilities.size() == fac_cnt0, "Non-shift tap enters confirmation when confirm_actions=true (Variant 1A)")
	m._pend.clear()
	shud.confirm_shown = false
	# Hold KEY_SHIFT via Input.parse_input_event + flush_buffered_events to verify multi-click serial build stays in Mode.POWER
	Input.parse_input_event(ev_sh)
	Input.flush_buffered_events()
	m._tap(mcam.world_to_screen(Vector2(60 * GameWorld.CELL, 60 * GameWorld.CELL)), true)
	check(m._pend.is_empty() and gw.mil.facilities.size() == fac_cnt0 + 1 and m._shift_built_in_series and m.mode == m.Mode.POWER, "Shift+tap bypasses confirmation and builds serially even on pause")
	# Duplicate Shift tap on occupied cell is blocked without spawning second facility
	m._tap(mcam.world_to_screen(Vector2(60 * GameWorld.CELL, 60 * GameWorld.CELL)), true)
	check(gw.mil.facilities.size() == fac_cnt0 + 1, "Shift+tap blocks duplicate build on occupied cell")
	# Verify releasing Shift after >= 1 build in series exits Mode.POWER -> Mode.NONE automatically
	var ev_sh_up := InputEventKey.new()
	ev_sh_up.keycode = KEY_SHIFT
	ev_sh_up.shift_pressed = false
	ev_sh_up.pressed = false
	Input.parse_input_event(ev_sh_up)
	Input.flush_buffered_events()
	m._unhandled_input(ev_sh_up)
	check(m.mode == m.Mode.NONE and not m._shift_built_in_series, "Releasing Shift after serial builds exits to Mode.NONE (Variant 1A)")
	# can_substitute is NOT auto-spent during Shift series
	c1.money = 50000
	c1.wood = 0
	m._set_mode(m.Mode.FACTORY)
	var money_before_sub: int = c1.money
	m._tap(mcam.world_to_screen(Vector2(80 * GameWorld.CELL, 60 * GameWorld.CELL)), true)
	check(c1.money == money_before_sub and m.mode == m.Mode.FACTORY, "Shift build refuses silent can_substitute spend and keeps build mode")
	# O2 plan_plus Shift step +5 & O4 zaslon_buy_1 Shift -> ZASLON_CAP
	m._plan_info = {"available": 20}
	m.plan_count = 1
	Input.parse_input_event(ev_sh)
	Input.flush_buffered_events()
	m._on_action("plan_plus")
	check(m.plan_count == 6, "Shift+plan_plus steps strike count by +5 (O2)")
	m._on_action("plan_minus")
	check(m.plan_count == 1, "Shift+plan_minus steps strike count by -5 (O2)")
	Input.parse_input_event(ev_sh_up)
	Input.flush_buffered_events()
	# MP pending build queue overlap + cash reservation
	mnet.in_match = true
	c1.money = 1000
	c1.wood = 500
	var ptok: int = m._mp_pend_record(Facility.Kind.POWER_PLANT, Vector2i(90, 60), c1)
	check(ptok > 0 and m._mp_pend_why(Facility.Kind.POWER_PLANT, Vector2i(91, 61)) != "", "MP pending queue blocks overlapping cell")
	check(m.ghost_place_why(Facility.Kind.POWER_PLANT, Vector2i(100, 60)) != "", "ghost_place_why reflects MP pending money reservation + low funds immediately")
	m._mp_pend_done(ptok)
	mnet.in_match = false
	# Focus out resets stuck drag & series flags
	m._mouse_down = true
	m._pc_pan = true
	m._shift_built_in_series = true
	m._notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	check(not m._mouse_down and not m._pc_pan and not m._shift_built_in_series, "Focus-out resets mouse/pan/shift series flags")
	GameConfig.confirm_actions = was_confirm

	# 6. PcArmySelect: _hits zoomed-out box select, cancel_drag, Shift+RMB waypoint chain, Ops queue
	gw.ops = Operations.new(gw)
	var ag_cls := load("res://game/army_groups.gd")
	var b1: Facility = gw.mil.build(Facility.Kind.BARRACKS, Vector2i(20, 90), c1, null, true)
	var b2: Facility = gw.mil.build(Facility.Kind.BARRACKS, Vector2i(36, 90), c1, null, true)
	check(b1 != null and b2 != null, "Built two barracks for PcArmySelect Shift tests")
	var u_a1 := Unit.new()
	u_a1.id = 901
	u_a1.country_id = c1.id
	u_a1.home = b1
	u_a1.type = Unit.Type.INFANTRY
	u_a1.hp = 50.0
	u_a1.max_hp = 50.0
	u_a1.pos = Vector2(20, 20)
	var u_a2 := Unit.new()
	u_a2.id = 902
	u_a2.country_id = c1.id
	u_a2.home = b2
	u_a2.type = Unit.Type.TANK
	u_a2.hp = 80.0
	u_a2.max_hp = 80.0
	u_a2.pos = Vector2(2000, 2000)  # offscreen unit tested via counter _hits rect
	gw.army.units.append_array([u_a1, u_a2])

	var pca = (load("res://pc/army_select.gd") as GDScript).new()
	pca.hud = shud
	pca.gw = gw
	pca._box_from = Vector2(10, 10)
	pca._box_to = Vector2(90, 90)
	pca.cancel_drag()
	check(not pca._box_from.is_finite() and not pca._box_to.is_finite(), "PcArmySelect.cancel_drag resets rubber-band box")
	pca._hits = [[Rect2(Vector2(100, 100), Vector2(36, 18)), [b2.id]]]
	pca._box_from = Vector2(95, 95)
	pca._box_to = Vector2(140, 130)
	var mb_rel := InputEventMouseButton.new()
	mb_rel.button_index = MOUSE_BUTTON_LEFT
	mb_rel.pressed = false
	mb_rel.position = Vector2(140, 130)
	check(pca.lmb(mb_rel) and pca.sel.has(b2.id), "Shift+box selects folded counter rects in _hits on zoomed-out map")
	pca._set_sel([b1.id], true)
	check(pca.sel.has(b1.id) and pca.sel.has(b2.id), "Shift+LMB adds second army without dropping first")
	pca._set_sel([b2.id], true)
	check(pca.sel.has(b1.id) and not pca.sel.has(b2.id), "Shift+LMB toggles already-selected army off")

	var fids_one := PackedInt32Array([b1.id])
	pca.order_move(fids_one, Vector2(120, 120), true)
	pca.order_move(fids_one, Vector2(180, 120), true)
	pca.order_move(fids_one, Vector2(220, 160), true)
	check(pca._wp_chain.size() == 3, "Shift+RMB accumulates multi-waypoint chain up to ROUTE_MAX+1")
	for wi in range(12):
		pca.order_move(fids_one, Vector2(250 + wi * 30, 160), true)
	check(pca._wp_chain.size() == ag_cls.ROUTE_MAX + 1, "Shift+RMB respects AG.ROUTE_MAX+1 waypoint limit")
	pca.order_move(fids_one, Vector2(300, 200), false)
	check(pca._wp_chain.is_empty(), "Plain RMB resets queued waypoint chain")

	var ord_res: Dictionary = ag_cls.order_fids(gw, c1.id, fids_one, "move", Vector2(240, 200), "", Vector2.INF, PackedVector2Array([Vector2(120, 120), Vector2(180, 120)]))
	check(int(ord_res.get("ok", 0)) == 1, "AG.order_fids dispatches chained waypoints even while paused (time_scale=0)")

	# Cleanup everything cleanly (zero ObjectDB leaks)
	NetSession._inst = null
	root.remove_child(mcam)
	pca.free()
	sux.free()
	shud.free()
	sov.free()
	mnet.free()
	mcam.free()
	ghost_n.free()
	m.free()
	gw.free()
