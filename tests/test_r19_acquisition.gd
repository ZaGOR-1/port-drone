extends SceneTree


class ZoneArmy extends Army:
	var eligible: Unit

	func _init(world: GameWorld) -> void:
		super(world)

	func _guard_foe(_u: Unit, o: Unit) -> bool:
		return o == eligible

	func _skirmish_foe(_u: Unit, cid: int, p: Vector2) -> bool:
		return eligible != null and cid == eligible.country_id and p == eligible.pos


var failures: Array[String] = []
var checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures.append(label)


func _world() -> GameWorld:
	var world := GameWorld.new()
	world.data = WorldData.new(96, 96, 12)
	world.mil = Military.new(world)
	for id: int in [1, 2, 3]:
		var country := Country.new()
		country.id = id
		world.countries.append(country)
	return world


func _unit(id: int, owner: int, p: Vector2, kind: int = Unit.Type.INFANTRY) -> Unit:
	var unit := Unit.new()
	unit.id = id
	unit.country_id = owner
	unit.type = kind
	unit.pos = p
	return unit


func _compare(army: Army, seeker: Unit, cache: Army.AcquisitionBuckets, expected: Object, label: String) -> void:
	seeker.target = null
	army._acquire(seeker)
	var reference: Object = seeker.target
	seeker.target = null
	army._acquire(seeker, cache)
	check(reference == expected and seeker.target == reference, label)


func _ordinary() -> void:
	var world := _world()
	var army := Army.new(world)
	world.army = army
	var state := Army.AcquisitionBuckets.new()
	var seeker := _unit(1, 1, Vector2(128, 64))
	var right := _unit(2, 2, Vector2(160, 64))
	var left := _unit(9, 2, Vector2(96, 64))
	var left_second := _unit(3, 2, Vector2(96, 64))
	var neutral := _unit(4, 3, Vector2(129, 64))
	var own: Country = world.countries[0]
	own.at_war[2] = true
	army._build_grid()
	army._refresh_scan_cache()
	_compare(army, seeker, state, null, "empty grid")
	army.units.assign([seeker, right, neutral, left, left_second, left])
	army._build_grid()
	_compare(army, seeker, state, left, "row and column order then insertion order of equal distances")
	var refs: Array = army._near_acquire_foes_into(army._scan_foe_mask[1], seeker.pos, 42.0, [],
		state, army._acquire_foes(1))
	check(refs == [left, left_second, left, right], "ordered duplicates with an initially neutral member removed")
	right.pos = Vector2(127, 64)
	_compare(army, seeker, state, right, "moved member uses its live position with historical membership")
	right.state = Unit.State.DEAD
	_compare(army, seeker, state, left, "cached reference to a dead member is rejected")
	left.type = Unit.Type.FPV
	_compare(army, seeker, state, left_second, "type change remains live")
	var born := _unit(5, 2, Vector2(128, 64))
	army.add_unit(born)
	_compare(army, seeker, state, left_second, "new unit waits for the existing grid rebuild")
	army.remove_unit(right)
	army._build_grid()
	_compare(army, seeker, state, born, "grid revision invalidates cached buckets")
	born.pos = Vector2(200, 64)
	neutral.pos = Vector2(130, 64)
	var change_owner_and_query := func() -> void:
		neutral.country_id = 2
		_compare(army, seeker, state, neutral, "synchronous callback owner mutation invalidates list before nested query")
	world.mil.forts_changed.connect(change_owner_and_query, CONNECT_ONE_SHOT)
	world.mil.forts_changed.emit()
	neutral.country_id = 3
	own.at_war[3] = true
	_compare(army, seeker, state, neutral, "live war set changes after cached lookup")
	own.at_war.erase(3)
	_compare(army, seeker, state, left_second, "live ceasefire drops target without waiting for grid rebuild")
	army._has_smoke = true
	army.smokes.append([left_second.pos, 999.0])
	_compare(army, seeker, state, null, "smoke follows the same original visibility rule")
	army._has_smoke = false
	left_second.pos = seeker.pos + Vector2(42, 0)
	_compare(army, seeker, state, null, "strict acquisition radius boundary")
	left_second.pos = seeker.pos + Vector2(41.875, 0)
	_compare(army, seeker, state, left_second, "fractional in-range position")
	var unusual := _unit(7, 80, seeker.pos)
	army.add_unit(unusual)
	own.at_war[80] = true
	army._build_grid()
	army._refresh_scan_cache()
	check(army._acquire_foes(1) == -1, "overflow owner falls back to exact hostility dictionary")
	_compare(army, seeker, state, unusual, "overflow owner is found through fallback")
	own.at_war.erase(80)
	own.at_war["2"] = true
	check(army._acquire_foes(1) == -1, "noninteger war keys use reference")
	check(not army.save_state()["a"].has("_acquire_grid_revision"), "grid revision excluded from save")
	check(not Save._ent_fields(seeker).has("country_revision"), "static country revision excluded from save")
	check(not army._has_mixed_acquisition_bucket(), "small buckets retain reference path")
	for rank: int in 512:
		army.add_unit(_unit(100 + rank, rank % 2 + 1, seeker.pos))
	army._build_grid()
	check(army._has_mixed_acquisition_bucket(), "large mixed bucket activates cache")
	army.tac = null
	army.fire = null
	world.free()


func _guard_and_grey_zone() -> void:
	var world := _world()
	var army := ZoneArmy.new(world)
	world.army = army
	var seeker := _unit(1, 1, Vector2(100, 100))
	var neutral := _unit(2, 3, Vector2(110, 100))
	army.units.assign([seeker, neutral])
	army.eligible = neutral
	army._build_grid()
	army._refresh_scan_cache()
	army._scan_can_acq[1] = 1
	var state := Army.AcquisitionBuckets.new()
	army._scan_grd[1] = 1
	_compare(army, seeker, state, neutral, "guard can select a non-war country")
	army._scan_grd[1] = 0
	army._scan_gz = true
	_compare(army, seeker, state, neutral, "grey zone can select a non-war country")
	check(state.by_foes.is_empty(), "guard and grey zone bypass acquisition lists")
	army.tac = null
	army.fire = null
	world.free()


func _run() -> void:
	_ordinary()
	_guard_and_grey_zone()
	print("R19 checks ", checks - failures.size(), "/", checks, " failures ", failures)
	quit(0 if failures.is_empty() else 1)
