extends SceneTree
const SaveSlots = preload("res://game/save_slots.gd")

var checks: int = 0
var failures: Array = []

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures.append(label)
	print("V036_CHECK ", label, " ", "PASS" if ok else "FAIL")

func _initialize() -> void:
	_run.call_deferred()

func _run() -> void:
	var name: String = ""
	var out: String = ""
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--case="):
			name = a.trim_prefix("--case=")
		if a.begins_with("--out="):
			out = a.trim_prefix("--out=")
	match name:
		"autosave": _autosave()
		"navy": _navy()
		"hold": _hold()
		"power": _power()
		"hash": _hash_state()
		"upgrades": _upgrades()
		"tooltips": _tooltips()
		"land-point": _land_point()
		_: check(false, "Unknown case: " + name)
	var result: Dictionary = {"passed": failures.is_empty(), "checks": checks, "failures": failures}
	FileAccess.open(out, FileAccess.WRITE).store_string(JSON.stringify(result))
	print("V036_RESULT ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)

func _reference_land_point(d: WorldData, p: Vector2, radius: int) -> Vector2:
	var c := Vector2i(floori(p.x / GameWorld.CELL), floori(p.y / GameWorld.CELL))
	if not d.inside(c.x, c.y) or not Biome.is_water(d.get_biome(c.x, c.y)) or d.has_flag(c.x, c.y, WorldData.F_BRIDGE):
		return p
	for r in range(1, radius + 1):
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				if maxi(absi(dx), absi(dy)) != r:
					continue
				var q := c + Vector2i(dx, dy)
				if d.inside(q.x, q.y) and not Biome.is_water(d.get_biome(q.x, q.y)):
					return Vector2(q * GameWorld.CELL) + Vector2(2, 2)
	return p


func _land_point() -> void:
	var gw := GameWorld.new()
	gw.econ = Economy.new(gw)
	for size: Vector2i in [Vector2i(7, 5), Vector2i(1, 5), Vector2i(5, 1), Vector2i.ONE]:
		var d := WorldData.new(size.x, size.y, 1)
		gw.data = d
		var matched: bool = true
		for land in range(-1, d.w * d.h):
			d.biome.fill(Biome.RIVER)
			d.flags.fill(0)
			if land >= 0:
				d.biome[land] = Biome.ROAD
			for y in range(-1, d.h + 1):
				for x in range(-1, d.w + 1):
					var p := Vector2(x, y) * GameWorld.CELL + Vector2(0.25, 0.75)
					for radius in range(-1, 7):
						if gw.econ.land_point(p, radius) != _reference_land_point(d, p, radius):
							matched = false
		check(matched, "land_point preserves every radius and origin with one or no land cell on %s" % size)
	var d := WorldData.new(7, 5, 1)
	gw.data = d
	d.biome.fill(Biome.OCEAN)
	var p := Vector2(14.25, 9.75)
	d.set_biome(2, 2, Biome.GRASS)
	d.set_biome(4, 2, Biome.SAND)
	check(gw.econ.land_point(p, 1) == Vector2(10, 10), "land_point visits left side first on the same row")
	d.set_biome(4, 1, Biome.GRASS)
	check(gw.econ.land_point(p, 1) == Vector2(18, 6), "land_point visits top row before side cells")
	d.add_flag(3, 2, WorldData.F_BRIDGE)
	check(gw.econ.land_point(p, 6) == p, "land_point preserves a bridge origin")
	d.clear_flag(3, 2, WorldData.F_BRIDGE)
	d.set_biome(4, 1, Biome.OCEAN)
	d.add_flag(4, 1, WorldData.F_BRIDGE)
	check(gw.econ.land_point(p, 1) == Vector2(10, 10), "land_point skips a water candidate even when it has a bridge flag")
	gw.free()


func _autosave() -> void:
	var a := Facility.new()
	var b := Facility.new()
	a.obj_ids = PackedInt32Array([10, 11])
	b.obj_ids = PackedInt32Array([20, 21])
	a.spots = PackedVector2Array([Vector2(10, 10)])
	a.modules = [b]
	b.parent = a
	# Exercise the real entity codec, including references and typed packed arrays.
	var c := Country.new()
	c.city_ids = PackedInt32Array([10])
	Save._reset_codec()
	var refs: Variant = Save.enc([c, a, b, c])
	var ents: Array = []
	for entity: Object in Save._ents:
		ents.append([String((entity.get_script() as Script).get_global_name()), Save._ent_fields(entity)])
	var packed := PackedInt32Array([10])
	var typed: Array[PackedInt32Array] = [packed]
	var nested: Dictionary = {"array": [{"packed": packed}], "typed": typed, "bytes": PackedByteArray([10]), "floats": PackedFloat64Array([10.0]), "vectors": PackedVector3Array([Vector3(10, 10, 10)])}
	var padding := PackedByteArray()
	padding.resize(32 * 1024 * 1024) # Hold the worker before it reaches entity fields.
	var body: Dictionary = {"padding": padding, "core": {}, "ents": ents, "refs": refs, "nested": nested}
	for round_i in 2:
		var expected: PackedByteArray = var_to_bytes(body)
		var h: Dictionary = {"format": 1, "slot": 1, "seq": round_i + 1, "t_ms": round_i + 1}
		var task: int = Save._queue_write(h, body)
		a.obj_ids[0] = 99 + round_i
		a.spots[0] = Vector2(99, 99)
		nested["bytes"][0] = 99
		nested["floats"][0] = 99.0
		nested["vectors"][0] = Vector3(99, 99, 99)
		b.obj_ids[1] = 99 + round_i
		c.city_ids[0] = 99 + round_i
		packed[0] = 99 + round_i
		typed.append(PackedInt32Array([99]))
		nested["array"][0]["extra"] = 99 + round_i
		WorkerThreadPool.wait_for_task_completion(task)
		var saved: Dictionary = Save._read(SaveSlots.path(1, "a0"))
		check(not saved.is_empty(), "autosave read round %d" % round_i)
		if saved.is_empty():
			continue
		check(var_to_bytes(saved["body"]) == expected, "all nested buffers frozen round %d" % round_i)
		if round_i == 0:
			check(saved["body"]["ents"][1][1]["obj_ids"][0] == 10, "entity retains 10 after live mutation to 99")
		Save._dec = [Country.new(), Facility.new(), Facility.new()]
		for i in ents.size():
			Save.fill(Save._dec[i], saved["body"]["ents"][i][1])
		var decoded: Array = Save.dec(saved["body"]["refs"])
		check(decoded[0] == decoded[3], "entity reference identity restored round %d" % round_i)
		check(decoded[1].obj_ids[0] == (10 if round_i == 0 else 99), "entity loaded from frozen save round %d" % round_i)
		check(decoded[2].parent == decoded[1] and decoded[1].modules[0] == decoded[2], "entity cycle restored round %d" % round_i)
		decoded[1].modules.clear()
		decoded[2].parent = null
		Save._dec.clear()
	a.modules.clear()
	b.parent = null

func _make_world(size: int = 64) -> GameWorld:
	var gw := GameWorld.new()
	gw.data = WorldData.new(size, size, 1)
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



func _navy() -> void:
	var host := _make_world(512)
	host.data.biome.fill(Biome.DEEP)
	host.diplo = null
	host.countries[0].at_war = {2: true}
	host.countries[1].at_war = {1: true}
	var enemy := Ship.new()
	enemy.id = 1
	enemy.c = 2
	enemy.hp = 100.0
	enemy.pos = Vector2(1024, 1024)
	host.navy.ships.append(enemy)
	host.game_time = 100.0
	var a := Vector2i(4, 64)
	var b := Vector2i(120, 64)
	var first: PackedVector2Array = host.navy.sea_path(a, b, 1)
	enemy.pos = Vector2(1024, 1750)
	host.game_time = 101.0
	# Both disk and network snapshots use this system serializer/loader.
	var snapshot: Dictionary = bytes_to_var(var_to_bytes(Save.enc(host.navy.save_state())))
	var peer := _make_world(512)
	peer.data.biome.fill(Biome.DEEP)
	peer.diplo = null
	peer.countries[0].at_war = {2: true}
	peer.countries[1].at_war = {1: true}
	peer.game_time = host.game_time
	for round_i in 3:
		Save._load_systems(peer, {"navy": snapshot})
		var hp: PackedVector2Array = host.navy.sea_path(a, b, 1)
		var pp: PackedVector2Array = peer.navy.sea_path(a, b, 1)
		check(hp == pp, "navy routes agree after restore round %d" % round_i)
		check(NetHash.of(host) == NetHash.of(peer), "navy world hashes agree round %d" % round_i)
		check(host.rng.state == peer.rng.state, "routing does not consume RNG round %d" % round_i)
		check(first != hp, "moving threat invalidates old route round %d" % round_i)
	# Same new input after restore must produce identical commands/routes.
	enemy.pos = Vector2(1024, 1024)
	peer.navy.ships[0].pos = enemy.pos
	host.game_time += 1.0
	peer.game_time = host.game_time
	check(host.navy.sea_path(a, b, 1) == peer.navy.sea_path(a, b, 1), "navy replay routes agree")
	snapshot = bytes_to_var(var_to_bytes(Save.enc(host.navy.save_state())))
	for round_i in 3:
		Save._load_systems(peer, {"navy": snapshot})
		check(host.navy.sea_path(a, b, 1) == peer.navy.sea_path(a, b, 1), "repeated restore resets threat-weight scratch generation %d" % round_i)

	host.free()
	peer.free()

class CountingEconomy:
	extends Economy
	var paths: int = 0
	func nav_path(_a: Vector2, _b: Vector2) -> PackedVector2Array:
		paths += 1
		nav_last_ok = false
		return PackedVector2Array()

func _hold() -> void:
	var gw := _make_world()
	gw.econ = CountingEconomy.new(gw)
	var source = load("res://game/urban_hold.gd").new(gw)
	gw.hold = source
	gw.game_time = 100.0
	var city := City.new()
	city.id = 2
	city.center = Vector2i(1, 1)
	var home := Facility.new()
	home.id = 1
	home.country_id = 1
	for i in 2:
		var u := Unit.new()
		u.id = i
		u.country_id = 1
		u.type = Unit.Type.INFANTRY
		u.home = home
		u.pos = Vector2(800 + i, 0)
		gw.army.units.append(u)
	source._far_fail = {"1:2": 120.0}
	var saved: Dictionary = bytes_to_var(var_to_bytes(Save.enc(source.save_state())))
	var restored = load("res://game/urban_hold.gd").new(gw)
	gw.hold = restored
	for round_i in 2:
		restored._far_fail = {"99:99": 999.0}
		Save._load_systems(gw, {"hold": saved})
		check(restored._far_fail == source._far_fail, "hold replaces stale cooldown round %d" % round_i)
		var calls: int = gw.econ.paths
		restored._auto_city(gw.countries[0], city)
		check(gw.econ.paths == calls, "restored cooldown prevents dispatch path search round %d" % round_i)
	var legacy: Dictionary = saved.duplicate(true)
	legacy.erase("far_fail")
	Save._load_systems(gw, {"hold": legacy})
	check(restored._far_fail.is_empty(), "legacy save clears old local cooldown")
	restored._auto_city(gw.countries[0], city)
	check(gw.econ.paths > 0, "legacy default permits a fresh dispatch attempt")
	check(restored._far_fail.get("1:2") == 130.0, "failed dispatch creates deterministic cooldown")
	var body: Dictionary = {"core": {"countries": [], "cities": [], "bridges": [], "game_time": 100.0}, "ents": [], "sys": {"hold": saved}}
	check(Save._sound(body), "valid optional hold cooldown accepted")
	for bad: Variant in [{"1:2": NAN}, {"1:2": "bad"}, {"bad": 120.0}, {"-1:2": 120.0}, []]:
		body["sys"]["hold"]["far_fail"] = bad
		check(not Save._sound(body), "malformed hold cooldown rejected before mutation: " + str(bad))
	gw.free()

func _power_cmd(n: NetSession, slot: int, args: Variant) -> void:
	n._exec({"k": "call", "s": slot, "q": 0, "o": "", "m": "cmd_power_prio", "a": args})

func _power() -> void:
	var gw := _make_world()
	for c: Country in gw.countries:
		c.is_player = true
	gw.player = gw.countries[0]
	var n := NetSession.new()
	n.gw = gw
	var owner: Country = gw.countries[0]
	var other: Country = gw.countries[1]
	_power_cmd(n, 0, NetCodec.encode([owner, 1]))
	check(owner.power_prio == 1, "owner command executes")
	_power_cmd(n, 1, NetCodec.encode([owner, 2]))
	check(owner.power_prio == 1, "foreign peer cannot modify owner")
	_power_cmd(n, 0, NetCodec.encode([other, 2]))
	check(other.power_prio == 0, "owner cannot modify foreign country")
	for args: Variant in [[], [owner], [owner, 1, 2], [1, 1], [null, 1], [owner, -1], [owner, 3], [owner, true], [owner, 1.0], [owner, "1"], [owner, Vector2.ZERO]]:
		_power_cmd(n, 0, NetCodec.encode(args))
		check(owner.power_prio == 1 and other.power_prio == 0, "malformed power arguments rejected: " + str(args))
	for invalid: Variant in [-1, 999, "1", null, owner]:
		_power_cmd(n, 0, [{"$e": "C", "i": invalid}, 2])
		check(owner.power_prio == 1, "invalid country reference rejected: " + str(invalid))
	_power_cmd(n, 0, [{"$e": "C"}, 2])
	_power_cmd(n, 0, {"unexpected": 1})
	for malformed: Variant in [[{"$a": 1}, 2], [{"$d": []}, 2], {"$a": 1}, [{"$e": [], "i": 1}, 2]]:
		_power_cmd(n, 0, malformed)
	check(owner.power_prio == 1, "malformed wire containers rejected without decoding errors")

	check(owner.power_prio == 1, "missing reference ID and non-array command rejected")
	_power_cmd(n, 1, NetCodec.encode([other, 2]))
	check(other.power_prio == 2, "second owner command executes")
	var peer := _make_world()
	peer.countries[0].is_player = true
	Save.fill(peer.countries[0], Save._ent_fields(owner))
	var pn := NetSession.new()
	pn.gw = peer
	var command: Variant = NetCodec.encode([owner, 2])
	_power_cmd(n, 0, command)
	_power_cmd(pn, 0, command)
	check(owner.power_prio == peer.countries[0].power_prio and owner.power_prio == 2, "command replays using restored country identity")
	n.free()
	pn.free()
	gw.free()
	peer.free()

func _hash_state() -> void:
	var gw := _make_world()
	gw.hold = load("res://game/urban_hold.gd").new(gw)
	var f := Facility.new()
	gw.mil.facilities.append(f)
	var city := City.new()
	gw.cities.append(city)
	var missile := Missile.new()
	gw.mil.missiles.append(missile)
	for obj: Object in [gw.countries[0], f, city, missile]:
		var fields: Array = []
		if obj is Country:
			fields = ["power_prio", "nuke_pledge_until"]
		elif obj is Facility:
			fields = ["nuke_state", "nuke_t", "nuke_tt", "nuke_prog", "nuke_cd", "nuke_stage_sent", "nuke_warhead", "zas_q", "zas_t", "zas_tt", "t3_spec", "npp_overheat_t", "emp_until", "ref_fuel"]
		elif obj is City:
			fields = ["emp_until"]
		else:
			fields = ["warhead", "decoy", "mirv_split"]
		for field: String in fields:
			var before: String = NetHash.of(gw)
			var old: Variant = obj.get(field)
			obj.set(field, not old if old is bool else old + 1)
			check(NetHash.of(gw) != before, "hash detects " + String(obj.get_script().get_global_name()) + "." + field)
			obj.set(field, old)
	var before: String = NetHash.of(gw)
	gw.hold._far_fail = {"1:2": 120.0, "3:4": 130.0}
	check(NetHash.of(gw) != before, "hash detects hold cooldown")
	var canonical: String = NetHash.of(gw)
	gw.hold._far_fail = {"3:4": 130.0, "1:2": 120.0}
	check(NetHash.of(gw) == canonical, "cooldown dictionary insertion order does not affect hash")
	gw.econ.trucks = [{"id": 1, "from": 1, "to": 1, "fuel_sale": true, "n": 10, "price": 100, "path": PackedVector2Array([Vector2.ZERO, Vector2.ONE]), "i": 0, "pos": Vector2.ZERO}]
	for field: String in ["n", "price", "i", "pos", "path"]:
		before = NetHash.of(gw)
		var old: Variant = gw.econ.trucks[0][field]
		gw.econ.trucks[0][field] = PackedVector2Array([Vector2.ONE]) if field == "path" else (Vector2.ONE if field == "pos" else old + 1)
		check(NetHash.of(gw) != before, "hash detects convoy " + field)
		gw.econ.trucks[0][field] = old
	var sh := Ship.new()
	gw.navy.ships.append(sh)
	before = NetHash.of(gw)
	sh.path = PackedVector2Array([Vector2.ONE])
	check(NetHash.of(gw) != before, "hash detects navy route before positions diverge")
	gw.free()

class SheetHud:
	extends "res://ui/hud/hud_keys.gd"
	var inner: VBoxContainer
	func _window(_title: String, _kind: String = "") -> VBoxContainer:
		# Same inner-VBox-in-ScrollContainer topology as Hud._window.
		if inner != null:
			inner.get_parent().free()
		var scroll := ScrollContainer.new()
		add_child(scroll)
		inner = VBoxContainer.new()
		scroll.add_child(inner)
		return inner

func _labels(node: Node) -> PackedStringArray:
	var out := PackedStringArray()
	if node is Label and (node as Label).is_visible_in_tree():
		out.append((node as Label).text)
	for child: Node in node.get_children():
		out.append_array(_labels(child))
	return out

func _upgrades() -> void:
	var gw := _make_world()
	gw.player = gw.countries[0]
	var c: Country = gw.player
	c.money = 100000
	c.wood = 100
	c.metal = 0
	var farm := Facility.new()
	farm.id = 1
	farm.country_id = c.id
	farm.kind = Facility.Kind.FARM
	var mine := Facility.new()
	mine.id = 2
	mine.country_id = c.id
	mine.kind = Facility.Kind.MINE
	mine.deposit = {"res": "metal"}
	gw.mil.facilities.assign([farm, mine])
	var hud := SheetHud.new()
	hud.gw = gw
	root.add_child(hud)
	hud.set_process(false)
	hud._upg_only_aff = true
	hud.open_kind_mass("upgrade")
	var labels: String = "\n".join(_labels(hud.inner))
	check(hud.inner.is_visible_in_tree(), "unaffordable category never hides entire list")
	check(labels.contains(Loc.t(Military.title_of(Facility.Kind.FARM))), "affordable farm row remains visible")
	check(not labels.contains(Loc.t("Металлический рудник")), "unaffordable mine row filtered")
	var plan: Dictionary = gw.econ.upgrade_plan(c, [farm.kind], 2)
	check(plan["afford"] == 1 and plan["ready"] == 1, "eligible affordable upgrade planned")
	var money: int = c.money
	var applied: Array = gw.econ.upgrade_kinds(c, [farm.kind], 2)
	check(applied[0] == plan["afford"] and money - c.money == plan["cost_afford"]["money"], "application matches preview and charges exact cost")
	farm.level = Economy.MAX_LEVEL
	var blocked: Dictionary = gw.econ.upgrade_plan(c, [farm.kind], 3)
	check(blocked["ready"] == 0 and blocked["afford"] == 0, "purchased max level cannot be purchased again")
	mine.upg_t = 10.0
	blocked = gw.econ.upgrade_plan(c, [mine.kind], 2)
	check(blocked["busy"] == 1 and blocked["afford"] == 0, "in-progress upgrade unavailable")
	c.money = 0
	hud.open_kind_mass("upgrade")
	labels = "\n".join(_labels(hud.inner))
	check(labels.contains(Loc.t("Улучшаемых объектов нет")), "empty filter displays a visible empty-state hint")
	hud._upg_only_aff = false
	hud.open_kind_mass("upgrade")
	labels = "\n".join(_labels(hud.inner))
	check(labels.contains(Loc.t("Металлический рудник")), "all-types mode retains unavailable owned upgrades")
	hud.free()
	gw.free()

func _tooltips() -> void:
	var tips = load("res://ui/ui24/hold_tip.gd")
	check(tips.line("nuke_warhead_1").contains(str(Nuclear.MIRV_DECOYS) + " "), "MIRV tooltip matches actual decoy count")
	check(tips.line("nuke_warhead_2").contains(str(int(Nuclear.EMP_DUR)) + " "), "EMP tooltip matches actual duration")
	for code: String in ["en", "uk", "es"]:
		var translation: Translation = load("res://translations/" + code + ".po")
		var emp: String = translation.get_message(tips.line("nuke_warhead_2"))
		check(emp.contains(str(int(Nuclear.EMP_DUR))), code + " EMP translation matches duration")
		var decoys: String = translation.get_message(tips.line("nuke_warhead_1"))
		check(decoys.contains(str(Nuclear.MIRV_DECOYS)), code + " MIRV translation matches decoys")
