extends SceneTree

class TracedWorld extends GameWorld:
	var visible_hit: bool = true

	func _on_screen(_p: Vector2, _margin: float = 0.0) -> bool:
		return visible_hit


class TracedFx extends FxLayer:
	var events: Array = []

	func spawn(sname: String, pos: Vector2, z: int = 6, until: float = 0.0, random_start: bool = false) -> AnimatedSprite2D:
		events.append([sname, pos, z, until, random_start])
		return null

	func debris_burst(p: Vector2, n: int, big: bool = false, dirt: bool = false) -> void:
		events.append(["debris", p, n, big, dirt])


# The playback mixer uses wall-clock throttling and cosmetic RNG.
class TracedSfx extends Sfx:
	var events: Array = []

	func _play(id: String, at: Vector2, vol_db: float, is_ui: bool, seen: bool = false) -> void:
		events.append([id, at, vol_db, is_ui, seen])


class TracedArmy extends Army:
	var events: Array = []

	func _damage(t: Object, dmg: float, by: int, at: = Vector2.INF, clear: bool = false, src: int = 0) -> void:
		events.append(["unit" if t is Unit else "facility", t.id, dmg, by, at, clear, src])
		super._damage(t, dmg, by, at, clear, src)

	func pin(u: Unit) -> void:
		events.append(["pin", u.id])
		super.pin(u)


var checks: int = 0
var failures: Array = []
var trace: Array = []
var sfx: TracedSfx


func _initialize() -> void:
	_run.call_deferred()


func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures.append(label)


func _world() -> TracedWorld:
	var gw := TracedWorld.new()
	gw.game_time = 10.0
	gw.data = WorldData.new(64, 64, 123)
	gw.rng = Rng.new(123)
	gw.army = TracedArmy.new(gw)
	gw.army.fire.rng_state = 835
	gw.mil = Military.new(gw)
	gw.battle_watch = BattleWatch.new(gw)
	gw.ground = GroundLayer.new()
	gw.add_child(gw.ground)
	gw.fx = TracedFx.new()
	gw.fx.gw = gw
	gw.add_child(gw.fx)
	for id in range(1, 4):
		var c := Country.new()
		c.id = id
		gw.countries.append(c)
	gw.countries[0].at_war[2] = true
	return gw


func _unit(gw: GameWorld, p: Vector2, cid: int = 2) -> Unit:
	var u := Unit.new()
	u.id = gw.army.units.size() + 1
	u.type = Unit.Type.INFANTRY
	u.country_id = cid
	u.pos = p
	gw.army.units.append(u)
	return u


func _facility(gw: GameWorld, id: int, cell: Vector2i, hp: float) -> Facility:
	var f := Facility.new()
	f.id = id
	f.country_id = 2
	f.cell = cell
	f.hp = hp
	gw.mil.facilities.append(f)
	return f


func _state(gw: GameWorld) -> Dictionary:
	var units: Array = []
	var facilities: Array = []
	Save._reset_codec()
	for u: Unit in gw.army.units:
		units.append(Save._ent_fields(u))
	for f: Facility in gw.mil.facilities:
		facilities.append(Save._ent_fields(f))
	var delays: Array = []
	for delayed: Array in gw._delayed:
		var method: Callable = delayed[1]
		delays.append([delayed[0], String(method.get_method()), method.get_bound_arguments()])
	return {"units": units, "facilities": facilities, "pins": gw.army.pin_until,
		"army_events": (gw.army as TracedArmy).events, "fx_events": (gw.fx as TracedFx).events,
		"delays": delays, "battle": gw.battle_watch.cells, "craters": gw.army.tac.craters,
		"sfx_events": sfx.events,
		"decals": gw.ground.decals, "shots": gw.army.fire._shots, "lost_value": gw.countries[0].destroyed,
		"rng": [gw.rng.state, gw.army.fire.rng_state]}


func _impact(gw: GameWorld, name: String, p: Vector2, kind: int, r: float, by: int = 1) -> void:
	var before: PackedByteArray = var_to_bytes(_state(gw))
	gw.army.fire._impact({"to": p, "k": kind, "r": r, "dmg": 40.0, "c": by})
	trace.append({"case": name, "before": before.hex_encode().sha256_text(),
		"after": var_to_bytes(_state(gw)).hex_encode().sha256_text(),
		"army_events": (gw.army as TracedArmy).events.duplicate(true),
		"game_rng": str(gw.rng.state), "fire_rng": str(gw.army.fire.rng_state), "next_global_rng": str(randi())})


func _boundaries(kind: int, r: float, p: Vector2) -> void:
	var gw := _world()
	var outer: float = r * 2.5
	var center := _unit(gw, p)
	center.hp = 10.0
	var inside := _unit(gw, p + Vector2(0.25, 0))
	var half := _unit(gw, p + Vector2(r * 0.5, 0))
	var damage_edge := _unit(gw, p + Vector2(r + 3.0, 0))
	var pin_edge := _unit(gw, p + Vector2(r * 2.0, 0))
	pin_edge.cover = 0.9
	var beyond_pin := _unit(gw, p + Vector2(r * 2.0 + 0.015625, 0))
	beyond_pin.cover = 0.9
	var no_cover := _unit(gw, p + Vector2(0, r * 2.0))
	var suppression_edge := _unit(gw, p - Vector2(outer, 0))
	var beyond := _unit(gw, p - Vector2(outer + 0.015625, 0))
	var friendly := _unit(gw, p, 1)
	var neutral := _unit(gw, p, 3)
	var unowned := _unit(gw, p, 0)
	var airborne := _unit(gw, p)
	airborne.type = Unit.Type.FPV
	var dead := _unit(gw, p)
	dead.state = Unit.State.DEAD
	var nonfinite := _unit(gw, Vector2(NAN, INF))
	var label := "shell-%d" % kind
	_impact(gw, label, p, kind, r)
	check(center.state == Unit.State.DEAD and gw.countries[0].destroyed == int(Army.SPEC[center.type]["cost"]), label + " kill/stat")
	check(inside.hp == 60.0 and half.hp == 80.0 and damage_edge.hp == 80.0, label + " damage boundaries")
	check(inside.supp == 0.25 and damage_edge.supp == 0.25, label + " damage suppression")
	check(pin_edge.hp == 100.0 and pin_edge.supp == 0.3 and gw.army.pin_until.has(pin_edge.id), label + " pin boundary")
	check(beyond_pin.supp == 0.3 and not gw.army.pin_until.has(beyond_pin.id), label + " beyond pin")
	check(no_cover.supp == 0.3 and not gw.army.pin_until.has(no_cover.id), label + " open ground cannot pin")
	check(suppression_edge.supp == 0.3 and beyond.supp == 0.0, label + " suppression boundary")
	for u: Unit in [friendly, neutral, unowned, airborne, dead, nonfinite]:
		check(u.hp == 100.0 and u.supp == 0.0 and not gw.army.pin_until.has(u.id), label + " skipped unit %d" % u.id)
	_check_damage_order(gw, [center.id, inside.id, half.id, damage_edge.id], label)
	_free(gw)


func _check_damage_order(gw: GameWorld, expected: Array, label: String) -> void:
	var ids: Array = []
	for event: Array in (gw.army as TracedArmy).events:
		if event[0] == "unit":
			ids.append(event[1])
	check(ids == expected, label + " unit damage order")


func _successive() -> void:
	var gw := _world()
	var p := Vector2(62, 62)
	var first := _unit(gw, p)
	first.hp = 30.0
	var second := _unit(gw, p + Vector2(8, 0))
	second.entrenched = true
	var suppression := _unit(gw, p + Vector2(17, 0))
	suppression.supp = 0.9
	for i in 2500:
		_unit(gw, p + Vector2(500 + i, -500 - i), 1 + i % 3)
	var building := _facility(gw, 20, Vector2i(15, 15), 18.0)
	var next := _facility(gw, 30, Vector2i(15, 15), 100.0)
	_impact(gw, "mixed-large-first", p, 1, 13.0)
	check(first.state == Unit.State.DEAD and building.hp == 2.0 and next.hp == 100.0, "unit kill and first facility only")
	check(suppression.supp == 1.0 and gw.army.pin_until.has(second.id), "suppression cap and entrenched pin")
	check((gw.army as TracedArmy).events.back()[0] == "facility", "facility processing after units")
	gw.game_time += 0.1
	_impact(gw, "mixed-large-second", p, 1, 13.0)
	_check_damage_order(gw, [first.id, second.id, second.id], "sequential impacts skip killed unit")
	check(building.hp == 100.0 and next.hp == 100.0 and gw._delayed.size() == 1, "lethal facility strike scheduled")
	_free(gw)


func _empty_and_small() -> void:
	var gw := _world()
	var p := Vector2(-512, -512)
	_impact(gw, "empty", p, 0, 9.0)
	var near := _unit(gw, p)
	_impact(gw, "unknown-attacker", p, 0, 9.0, 99)
	check(near.hp == 100.0 and near.supp == 0.0, "unknown attacker has no hostile targets")
	var edge := _unit(gw, p + Vector2(3, 0))
	var outside := _unit(gw, p + Vector2(3.015625, 0))
	_impact(gw, "damage-radius-larger", p, 0, 0.0)
	check(edge.hp == 80.0 and outside.hp == 100.0, "damage radius can exceed suppression radius")
	_free(gw)


func _facility_boundaries() -> void:
	var gw := _world()
	var p := Vector2(51, 62)
	# Dictionary membership is hostile even when the stored value is false.
	gw.countries[0].at_war[2] = false
	gw.countries[0].at_war[1] = true
	var self_owned := _facility(gw, 11, Vector2i(12, 15), 100.0)
	self_owned.country_id = 1
	var neutral := _facility(gw, 12, Vector2i(12, 15), 100.0)
	neutral.country_id = 3
	var child := _facility(gw, 13, Vector2i(12, 15), 100.0)
	child.parent = self_owned
	var line := _facility(gw, 14, Vector2i(12, 15), 100.0)
	line.kind = Facility.Kind.TRENCH_H
	var restoring := _facility(gw, 15, Vector2i(12, 15), 100.0)
	restoring.restore_t = 1.0
	var edge := _facility(gw, 90, Vector2i(15, 15), 100.0)
	edge.size = Vector2i.ONE
	var nearer := _facility(gw, 20, Vector2i(12, 15), 100.0)
	nearer.size = Vector2i.ONE
	_impact(gw, "facility-inclusive-edge", p, 0, 9.0)
	check(edge.hp == 84.0 and nearer.hp == 100.0, "inclusive boundary and first registry entry, not nearest or lowest ID")
	check(self_owned.hp == 100.0 and neutral.hp == 100.0, "self and neutral ignored")
	check(child.hp == 100.0 and line.hp == 100.0 and restoring.hp == 100.0, "child, line and restoring facility excluded")
	_impact(gw, "outside-facility-edge", p - Vector2(0.015625, 0), 0, 9.0)
	check(edge.hp == 84.0 and nearer.hp == 84.0, "just outside boundary selects next candidate")
	_impact(gw, "missing-attacker-facilities", p, 1, 13.0, 99)
	check(edge.hp == 84.0 and nearer.hp == 84.0, "invalid attacker damages no facility")
	gw.countries[0].at_war.clear()
	_impact(gw, "empty-hostility-facilities", p, 1, 13.0)
	check(edge.hp == 84.0 and nearer.hp == 84.0, "no hostile memberships")
	var ids: Array = []
	for event: Array in (gw.army as TracedArmy).events:
		if event[0] == "facility":
			ids.append(event[1])
	check(ids == [90, 20], "facility damage sequence")
	_free(gw)


func _facility_diplomacy_refresh() -> void:
	var gw := _world()
	var first := _facility(gw, 101, Vector2i(15, 15), 100.0)
	var later := _facility(gw, 102, Vector2i(15, 15), 100.0)
	later.country_id = 3
	var p := Vector2(62, 62)
	_impact(gw, "facility-initial-hostility", p, 1, 13.0)
	check(first.hp == 84.0 and later.hp == 100.0, "initial hostile owner")
	gw.countries[0].at_war = {3: true}
	_impact(gw, "facility-new-diplomacy", p, 1, 13.0)
	check(first.hp == 84.0 and later.hp == 84.0, "fresh diplomacy after dictionary replacement")
	first.country_id = 3
	later.country_id = 2
	_impact(gw, "facility-new-ownership", p, 1, 13.0)
	check(first.hp == 68.0 and later.hp == 84.0, "current owner read before selecting first candidate")
	_free(gw)


func _free(gw: GameWorld) -> void:
	Save._reset_codec()
	gw._delayed.clear()
	gw.army.units.clear()
	gw.mil.facilities.clear()
	gw.army.fire = null
	gw.army.tac = null
	gw.free()


func _run() -> void:
	sfx = TracedSfx.new()
	Sfx._inst = sfx
	seed(20261016)
	_boundaries(0, 9.0, Vector2.ZERO)
	_boundaries(1, 13.0, Vector2(-75, -105))
	_boundaries(2, 11.0, Vector2(65536, -65536))
	_successive()
	_empty_and_small()
	_facility_boundaries()
	_facility_diplomacy_refresh()
	var result := {"passed": failures.is_empty(), "checks": checks, "failures": failures, "trace": trace}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="), FileAccess.WRITE).store_string(JSON.stringify(result))
	Sfx._inst = null
	sfx.free()
	print("R10 differential fixture checks: ", checks, " failures: ", failures)
	quit(0 if failures.is_empty() else 1)
