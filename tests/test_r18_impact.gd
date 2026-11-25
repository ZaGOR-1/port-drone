extends SceneTree

const TRACE_PATH: String = "res://game/r18_trace.gd"


class CallbackWatch extends BattleWatch:
	var hook: Callable

	func note(p: Vector2, heat: float, label: String = "", cid: int = -1) -> void:
		super.note(p, heat, label, cid)
		if hook.is_valid():
			hook.call(p)

var checks: int = 0
var failures: Array[String] = []
var cases: Dictionary = {}
var counters: Dictionary = {}
var trace: Script


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures.append(label)


func _world() -> GameWorld:
	seed(20261016)
	var gw := GameWorld.new()
	gw.game_time = 10.0
	gw.data = WorldData.new(64, 64, 123)
	gw.data.biome.fill(Biome.GRASS)
	gw.rng = Rng.new(123)
	gw.army = Army.new(gw)
	gw.mil = Military.new(gw)
	gw.econ = Economy.new(gw)
	gw.battle_watch = BattleWatch.new(gw)
	gw.ground = GroundLayer.new()
	gw.add_child(gw.ground)
	gw.fx = FxLayer.new()
	gw.fx.gw = gw
	gw.add_child(gw.fx)
	gw.objects = ObjectsLayer.new()
	gw.add_child(gw.objects)
	gw.objects.setup(gw)
	for id: int in range(1, 4):
		var country := Country.new()
		country.id = id
		gw.countries.append(country)
	gw.countries[0].at_war[2] = true
	return gw


func _unit(gw: GameWorld, id: int, p: Vector2, cid: int = 2) -> Unit:
	var u := Unit.new()
	u.id = id
	u.type = Unit.Type.INFANTRY
	u.country_id = cid
	u.pos = p
	gw.army.units.append(u)
	return u


func _shell(p: Vector2, radius: float = 13.0, damage: float = 40.0) -> Dictionary:
	return {"to": p, "k": 1, "r": radius, "dmg": damage, "c": 1, "t": 0.0,
		"dur": 0.01, "whistle": true}


func _batch(gw: GameWorld, in_order: Array[Dictionary]) -> void:
	gw.army.fire.shells.assign(in_order)
	gw.army.fire.shells.reverse()
	gw.army.fire._update_shells(1.0 / 30.0)
	check(gw.army.fire.shells.is_empty(), "batch completed")
	if "_impact_units" in gw.army.fire:
		check(gw.army.fire.get("_impact_units") == null, "batch released its lookup")
	else:
		check(true, "batch released its lookup")


func _begin_case() -> void:
	if trace != null:
		trace.call("reset")
		trace.set("active", true)


func _finish_case(label: String, gw: GameWorld) -> void:
	var units: Array = []
	Save._reset_codec()
	for u: Unit in gw.army.units:
		units.append(Save._ent_fields(u))
	Save._reset_codec()
	var state: Dictionary = gw.army.save_state()
	check(not state["f"].has("_impact_units"), "transient lookup omitted from save")
	var world_state: Array = [units, gw.army.pin_until, gw.army.tac.craters, gw.battle_watch.cells,
		gw.ground.decals, gw.army.fire._shots, gw.rng.state, gw.army.fire.rng_state,
		gw.countries[0].destroyed, gw.data.biome]
	cases[label] = {"state": var_to_bytes(world_state).hex_encode().sha256_text(),
		"global_rng": str(randi()), "effects": trace.get("effects") if trace != null else []}
	if trace != null:
		counters[label] = trace.get("counts")
		trace.set("active", false)
		trace.set("callback", Callable())
	if gw.rail != null:
		gw.rail.troops = null
	gw.army.fire = null
	gw.army.tac = null
	gw.free()


func _empty() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(-64, 64)
	_batch(gw, [_shell(p), _shell(p), _shell(p)])
	check(gw.army.units.is_empty(), "empty index result")
	_finish_case("empty", gw)


func _geometry() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(128, 128)
	var old := _unit(gw, 90, p + Vector2(180, 0))
	var edge := _unit(gw, 2, p + Vector2(16, 0))
	var pin_edge := _unit(gw, 88, p - Vector2(26, 0))
	pin_edge.cover = 0.9
	var sup_edge := _unit(gw, 4, p + Vector2(32.5, 0))
	var outside := _unit(gw, 5, p - Vector2(32.515625, 0))
	var half := _unit(gw, 11, p + Vector2(0, -6.5))
	var ally := _unit(gw, 12, p, 1)
	var air := _unit(gw, 13, p)
	air.type = Unit.Type.FPV
	var dead := _unit(gw, 14, p)
	dead.state = Unit.State.DEAD
	for i: int in 40:
		_unit(gw, 200 - i, p + Vector2(-7 + i % 15, -3 + i % 6))
	gw.army._build_grid()
	old.pos = p + Vector2(-2, 0)
	_batch(gw, [_shell(Vector2(-64, 64)), _shell(p)])
	check(old.hp == 60.0, "live position crossed stale Army grid")
	check(edge.hp == 80.0 and half.hp == 80.0, "inclusive damage and strict half-radius")
	check(pin_edge.supp == 0.3 and gw.army.pin_until.has(pin_edge.id), "inclusive pin")
	check(sup_edge.supp == 0.3 and outside.supp == 0.0, "inclusive suppression")
	check(ally.hp == 100.0 and air.hp == 100.0 and dead.hp == 100.0, "state and hostility checks")
	if trace != null:
		var order: Array = []
		for value: Array in trace.get("effects"):
			if value[0] == "damage":
				order.append(value[1])
		check(order.slice(0, 3) == [90, 2, 11], "registry order across buckets and IDs")
	_finish_case("geometry", gw)


func _signed_extent() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(-1048320, 1048320)
	var repeated := _unit(gw, 9, p + Vector2(0, 6.5))
	var edge := _unit(gw, 1, p - Vector2(32.5, 0))
	var outside := _unit(gw, 4, p + Vector2(32.625, 0))
	gw.army.units.append(repeated)
	_batch(gw, [_shell(Vector2.ZERO), _shell(p)])
	check(repeated.hp == 60.0, "two registry offsets for one object both apply damage")
	check(edge.supp == 0.3 and outside.supp == 0.0, "signed high-coordinate exact boundary")
	if trace != null:
		check(int(trace.get("counts").get("damage", 0)) == 2, "duplicate offsets preserved")
	_finish_case("signed_extent", gw)


func _reuse_after_death() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(128, 128)
	var killed := _unit(gw, 70, p)
	killed.hp = 10.0
	var next := _unit(gw, 20, p)
	_batch(gw, [_shell(Vector2(-80, -80)), _shell(p), _shell(p)])
	check(killed.state == Unit.State.DEAD and killed.hp == -30.0, "dead unit is skipped on lookup reuse")
	check(next.hp == 20.0, "second rank receives both hits")
	_finish_case("reuse_after_death", gw)


func _unverified_callback() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(128, 128)
	var defender := _unit(gw, 30, Vector2(-500, -500))
	var watch := CallbackWatch.new(gw)
	watch.hook = func(at: Vector2) -> void:
		if at == p:
			defender.pos = p
	gw.battle_watch = watch
	_batch(gw, [_shell(Vector2(-80, -80)), _shell(Vector2(-100, -100)), _shell(p)])
	check(defender.hp == 60.0, "custom prefix callback sees baseline live-position behavior")
	if trace != null:
		check(int(trace.get("counts").get("builds", 0)) == 0, "custom callback uses full scans")
	_finish_case("unverified_callback", gw)


func _nonfinite() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(-65536, 65536)
	var hit := _unit(gw, 1, p)
	_unit(gw, 2, Vector2.INF)
	_batch(gw, [_shell(Vector2(128, 128)), _shell(p, 0.0), _shell(p, 0.0)])
	check(hit.hp == 60.0, "non-finite registry position falls back to precise checks")
	_finish_case("nonfinite", gw)


func _fort_mutation() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var strike := Vector2(34, 34)
	var next := Vector2(170, 130)
	var moved := _unit(gw, 80, Vector2(-500, -500))
	var removed := _unit(gw, 81, next)
	var fort := Facility.new()
	fort.kind = Facility.Kind.TRENCH_H
	fort.country_id = 2
	var tile := Vector2i(8, 8)
	fort.cells.append(tile)
	gw.mil.fort_cells[tile] = fort
	var home := Facility.new()
	home.country_id = 2
	home.cell = Vector2i(42, 30)
	home.size = Vector2i(1, 1)
	var born: Array[Unit] = []
	gw.mil.forts_changed.connect(func() -> void:
		moved.pos = next
		gw.army._kill(removed, 1)
		gw.army.units.erase(removed)
		var fresh: Unit = gw.army._spawn(home, Unit.Type.INFANTRY)
		fresh.pos = next
		born.append(fresh)
	, CONNECT_ONE_SHOT)
	gw.army.fire.rng_state = 3
	_batch(gw, [_shell(Vector2(-80, -80)), _shell(strike), _shell(next)])
	check(born.size() == 1 and born[0].hp == born[0].max_hp - 40.0, "spawn from synchronous callback")
	check(moved.hp == 60.0 and removed.hp == 100.0 and removed.state == Unit.State.DEAD,
		"moved and destroyed ranks read from the new registry")
	_finish_case("fort_mutation", gw)


func _reentry() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	var p := Vector2(128, 128)
	var first := _unit(gw, 51, p)
	var later := _unit(gw, 10, Vector2(-400, -400))
	trace.set("callback", func() -> void:
		trace.set("callback", Callable())
		later.pos = p
		gw.army.fire._impact(_shell(Vector2(-500, -500)))
	)
	_batch(gw, [_shell(Vector2(-80, -80)), _shell(p)])
	check(first.hp == 60.0 and later.hp == 60.0, "nested impact resumes live suffix once")
	_finish_case("reentry", gw)


func _city_strike() -> void:
	var gw: GameWorld = _world()
	_begin_case()
	gw.units_ground = UnitsLayer.new()
	gw.add_child(gw.units_ground)
	gw.rail = Rail.new(gw)
	var town := City.new()
	town.id = 0
	town.country_id = 2
	town.center = Vector2i(16, 16)
	town.radius = 1
	town.garrison = 100.0
	gw.cities.append(town)
	var p := Vector2(town.center * GameWorld.CELL + Vector2i(2, 2))
	var wagon := p + Vector2(Rail.CAR_GAP, 0)
	var pts := PackedVector2Array()
	for offset: int in range(int(Rail.CAR_GAP) + 1):
		pts.append(wagon - Vector2(offset, 0))
	var bar := Facility.new()
	bar.id = 99
	bar.country_id = 2
	var soldier := Unit.new()
	soldier.id = 99
	soldier.type = Unit.Type.INFANTRY
	soldier.country_id = 2
	soldier.home = bar
	gw.rail.trains.append({"ride": 1, "s": Rail.CAR_GAP, "pts": pts,
		"cars": PackedStringArray(["rail_loco", "rail_wagon_troop"]), "cosmetic": false, "country": 2,
		"on_lost": Callable()})
	gw.rail.troops.rides.append({"id": 1, "home": bar, "c": 2, "units": [soldier],
		"car": [1], "lost": 0, "stop": true})
	_unit(gw, 20, Vector2(220, 220))
	gw.army.fire.rng_state = 5
	_batch(gw, [_shell(Vector2(-80, -80)), _shell(p), _shell(wagon + Vector2(-3, 6))])
	check(gw.rail.trains.is_empty() and gw.rail.troops.rides.is_empty(), "real city strike hit the troop train")
	check(gw.army.units.size() == 2 and gw.army.units[1] == soldier, "rail unload appended to the registry")
	check(soldier.hp == 10.0, "next shell hits the unit unloaded by the previous impact")
	check(town.garrison == 88.0, "city strike applied once")
	_finish_case("city_strike", gw)


func _run() -> void:
	if ResourceLoader.exists(TRACE_PATH):
		trace = load(TRACE_PATH)
	var args: Dictionary = {}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--") and arg.contains("="):
			args[arg.get_slice("=", 0).trim_prefix("--")] = arg.substr(arg.find("=") + 1)
	if args.get("case", "") == "city":
		_city_strike()
	else:
		_empty()
		_geometry()
		_signed_extent()
		_reuse_after_death()
		_unverified_callback()
		_nonfinite()
		_fort_mutation()
		if trace != null:
			_reentry()
	var report := {"checks": checks, "failures": failures, "cases": cases, "counts": counters}
	if args.has("out"):
		FileAccess.open(args["out"], FileAccess.WRITE).store_string(JSON.stringify(report))
	print("R18 impact fixture ", checks, " checks, failures: ", failures)
	quit(0 if failures.is_empty() else 1)
