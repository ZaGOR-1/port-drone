extends SceneTree
## Run against each exact benchmark PCK. The shell runner compares the two reports byte for byte.

var failures: Array[String] = []
var checks: int = 0
var traces: Dictionary = {}


func _initialize() -> void:
	run.call_deferred()


func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures.append(label)
		push_error(label)


func unit(id: int, cid: int, p: Vector2, kind: int = Unit.Type.INFANTRY) -> Unit:
	var u := Unit.new()
	u.id = id
	u.country_id = cid
	u.pos = p
	u.type = kind
	return u


func sample(label: String, gw: GameWorld, eye: Unit, expected: Array, nearest_id: int) -> void:
	var fire = gw.army.fire
	var before: int = fire.rng_state
	var entities: PackedByteArray = unit_state(gw.army.units)
	fire._spot()
	check(fire.rng_state == before, label + " spotting draws zero fire RNG")
	check(entities == unit_state(gw.army.units), label + " spotting preserves unit state")
	var trace: Array = []
	var ids: Array = []
	for cid: int in fire.spotted:
		var records: Array = []
		for entry: Array in fire.spotted[cid]:
			var obj: Object = entry[1]
			var pos: Vector2 = entry[0]
			records.append([obj.id, pos.x, pos.y, entry[2], obj is Unit])
			check(fire.sees(cid, obj), label + " spotted object in seen")
			if cid == eye.country_id:
				ids.append([obj.id, entry[2]])
		check(fire.seen[cid].size() == records.size(), label + " unique visibility per faction")
		trace.append([cid, records])
	check(ids == expected, label + " ordered visibility " + str(ids).left(350))
	for u: Unit in gw.army.units:
		var listed: bool = ids.any(func(row: Array) -> bool: return row[0] == u.id)
		check(fire.sees(eye.country_id, u) == listed, label + " membership for unit %d" % u.id)
	var nearest: Array = fire.nearest_spotted(eye.country_id, eye.pos, 500.0)
	var selected: int = -1 if nearest.is_empty() else nearest[1].id
	check(selected == nearest_id, label + " nearest tie order")
	fire.rf()
	var one_draw: int = fire.rng_state
	fire.rng_state = before
	var pick: Array = fire._pick(eye, 0.0, 500.0)
	if not pick.is_empty():
		var at: Vector2 = pick[0]
		pick = [at.x, at.y, pick[1]]
	check(fire.rng_state == (one_draw if eye.type == Unit.Type.MORTAR else before), label + " _pick RNG calls")
	traces[label] = {"spotted": trace, "nearest": selected, "pick": pick, "rng": fire.rng_state}


func unit_state(units: Array[Unit]) -> PackedByteArray:
	var fields: Array = []
	for u: Unit in units:
		fields.append([u.id, u.country_id, u.pos, u.hp, u.state, u.fire_cd, u.entrenched])
	return var_to_bytes(fields)


func run() -> void:
	var gw := GameWorld.new()
	gw.mil = Military.new(gw)
	gw.army = Army.new(gw)
	gw.diplo = Diplomacy.new(gw)
	var origin := Vector2(256, 256)
	for i in range(1, 5):
		var c := Country.new()
		c.id = i
		gw.countries.append(c)
	gw.diplo.rel[gw.diplo.key(1, 3)] = Diplomacy.Rel.ALLIANCE
	check(gw.diplo.allied(1, 3), "fixture allied factions")
	gw.countries[0].at_war[2] = true
	gw.countries[0].at_war[4] = true
	gw.countries[1].at_war[1] = true
	gw.countries[3].at_war[1] = true
	var eye := unit(1, 1, origin)
	var right := unit(2, 2, origin + Vector2(1, 0))
	var left := unit(9, 2, origin - Vector2(1, 0))
	var ally := unit(3, 3, origin + Vector2(4, 0))
	var foe := unit(4, 4, origin + Vector2(30, 0))
	var far := unit(5, 2, origin + Vector2(120, 120))
	gw.army.fire.rng_state = 91234
	sample("empty", gw, eye, [], -1)
	gw.army.units.assign([eye, right])
	gw.army._build_grid()
	sample("one", gw, eye, [[2, false]], 2)
	gw.army.units.assign([eye, right, left, ally, foe, far])
	gw.army._build_grid()
	sample("mixed-factions-equal-distance-outside-circle", gw, eye, [[9, false], [2, false], [4, false]], 9)
	sample("same-input-repeat", gw, eye, [[9, false], [2, false], [4, false]], 9)
	check(traces["same-input-repeat"] == traces["mixed-factions-equal-distance-outside-circle"], "identical repeated invocation")
	right.pos = origin + Vector2(260, 0)
	sample("moving-stale-grid", gw, eye, [[9, false], [4, false]], 9)
	gw.army._build_grid()
	sample("moving-refreshed-grid", gw, eye, [[9, false], [4, false]], 9)
	left.state = Unit.State.DEAD
	sample("destroyed-in-stale-grid", gw, eye, [[4, false]], 4)
	foe.country_id = 1
	sample("changed-owner-stale-mask", gw, eye, [], -1)
	gw.army._build_grid()
	sample("changed-owner-refreshed-mask", gw, eye, [], -1)

	var trench := unit(6, 2, origin + Vector2(70, 0))
	trench.entrenched = true
	var hidden := unit(7, 2, origin + Vector2(30, 40))
	var drone := unit(8, 1, origin + Vector2(135, 0), Unit.Type.RECON)
	eye.type = Unit.Type.MORTAR
	gw.army.units.assign([eye, hidden, trench])
	gw.army.fire.recon.assign([drone])
	gw.army._has_smoke = true
	gw.army.smokes.append([hidden.pos])
	gw.army._build_grid()
	sample("trench-retried-by-recon-smoke", gw, eye, [[6, true]], 6)
	check(traces["trench-retried-by-recon-smoke"]["pick"] == [326.0, 256.0, true], "real mortar selection propagates recon")
	drone.jam_t = 1.0
	sample("jammed-recon", gw, eye, [], -1)
	eye.dug = true
	far.pos = origin + Vector2(148, 0)
	gw.army.units.append(far)
	gw.army._build_grid()
	sample("dug-observer-extended-radius", gw, eye, [[5, false]], 5)

	eye.type = Unit.Type.INFANTRY
	gw.army._has_smoke = false
	gw.army.units.assign([eye])
	var expected: Array = []
	for i in 160:
		gw.army.units.append(unit(2000 + i, 1, origin))
		gw.army.units.append(unit(1000 + i, 2, origin + Vector2(20, 5)))
		expected.append([1000 + i, false])
	gw.army._build_grid()
	sample("dense-battle-321-units", gw, eye, expected, 1000)
	check(traces["dense-battle-321-units"]["pick"] == [276.0, 261.0, false], "real tie pick position")
	# Two eyes sharing buckets. First eye misses the boundary target, second eye hits.
	var second := unit(3001, 1, origin + Vector2(8, 0))
	var boundary := unit(3002, 2, second.pos + Vector2(gw.army.fire.SPOT_R, 0))
	var outside := unit(3003, 2, boundary.pos + Vector2(0.0625, 0))
	var twin := unit(3004, 2, boundary.pos)
	var neutral := unit(3005, 3, origin + Vector2(1, 0))
	gw.army.fire.recon.clear()
	eye.dug = false
	gw.army.units.assign([eye, second, twin, boundary, outside, neutral])
	gw.army._build_grid()
	sample("same-buckets-boundary-and-tie", gw, eye, [[3004, false], [3002, false]], 3004)
	# Dictionary membership, including false, is the existing hostility rule.
	gw.countries[0].at_war[2] = false
	sample("false-membership", gw, eye, [[3004, false], [3002, false]], 3004)
	gw.countries[0].at_war.erase(2)
	sample("changed-diplomacy-same-grid", gw, eye, [], -1)
	gw.countries[0].at_war[2] = true
	boundary.country_id = 1
	sample("live-ownership-same-grid", gw, eye, [[3004, false], [3003, false]], 3004)
	# A duplicate reference in a bucket preserves the first occurrence.
	boundary.country_id = 2
	gw.army.units.assign([eye, second, twin, boundary, twin])
	gw.army._build_grid()
	sample("duplicate-bucket-reference", gw, eye, [[3004, false], [3002, false]], 3004)

	var building := Facility.new()
	building.id = 4000
	building.kind = Facility.Kind.DUGOUT
	building.country_id = 2
	building.cell = Vector2i(64, 64)
	gw.mil.facilities.append(building)
	gw.army.units.assign([eye])
	var front: Array = []
	for i in 60:
		gw.army.units.append(unit(4100 + i, 2, origin + Vector2(20, 0)))
		front.append([4100 + i, false])
	gw.army._fgrid_t = -2.0
	gw.army._build_grid()
	sample("facility-at-sixty-visible-units", gw, eye, front + [[4000, false]], 4000)
	building.moving = true
	sample("moving-facility-at-sixty", gw, eye, front, 4100)
	building.moving = false
	gw.army.units.append(unit(4160, 2, origin + Vector2(20, 0)))
	gw.army._build_grid()
	sample("skip-facilities-at-sixty-one", gw, eye, front + [[4160, false]], 4100)

	# A circle which overlaps the first column from a negative eye position.
	eye.pos = Vector2(-3, 256)
	var edge := unit(5000, 2, Vector2(2, 256))
	gw.mil.facilities.clear()
	gw.army.units.assign([eye, edge])
	gw.army._fgrid_t = -2.0
	gw.army._build_grid()
	sample("clipped-left-grid-edge", gw, eye, [[5000, false]], 5000)
	var report := {"passed": failures.is_empty(), "checks": checks, "failures": failures, "traces": traces}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			var out := FileAccess.open(arg.trim_prefix("--out="), FileAccess.WRITE)
			out.store_string(JSON.stringify(report))
			out.close()
			break
	gw.free()
	quit(0 if failures.is_empty() else 1)
