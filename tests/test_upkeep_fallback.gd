extends SceneTree
const UpkeepS = preload("res://game/upkeep335.gd")
class Spy:
	extends "res://game/upkeep335.gd"
	var calls: int = 0
	func tally(cid: int) -> Dictionary:
		calls += 1
		return super.tally(cid)
class Fallback:
	extends Spy
	func _tally_all() -> Dictionary:
		return {}
var checks: int = 0
var failures: Array = []

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)

func _initialize() -> void:
	_run.call_deferred()

func fixture(fallback: bool) -> GameWorld:
	var w := GameWorld.new()
	w.set_process(false)
	w.data = WorldData.new(64,64,456)
	w.data.biome.fill(Biome.GRASS)
	w.rng = Rng.new(456)
	w.mil = Military.new(w)
	w.army = Army.new(w)
	w.econ = Economy.new(w)
	w.diplo = Diplomacy.new(w)
	w.navy = Navy.new(w)
	w.fx = FxLayer.new()
	w.fx.gw = w
	w.add_child(w.fx)
	w.game_time = 1200.0
	for id in range(1,4):
		var c := Country.new()
		c.id = id
		c.capital_id = 0
		c.city_ids = [0,1,2,3,4]
		c.money = 100000
		c.food = 5000
		c.metal = 5000
		c.fuel = 5000
		w.countries.append(c)
		var f := Facility.new()
		f.id = w.mil.facilities.size()
		f.kind = Facility.Kind.AD_SAM
		f.country_id = id
		f.hp = 100.0
		w.mil.facilities.append(f)
		var a := Aircraft.new()
		a.id = id
		a.country_id = id
		a.type = Aircraft.Type.TRANSPORT
		w.mil.air.aircraft.append(a)
		var u := Unit.new()
		u.id = id
		u.country_id = id
		u.type = Unit.Type.TANK
		u.hp = 100.0
		w.army.units.append(u)
	w.econ.upk = Fallback.new(w.econ) if fallback else Spy.new(w.econ)
	return w

func state(w: GameWorld) -> Array:
	var countries: Array = []
	for c: Country in w.countries:
		countries.append([c.id,c.money,c.fuel,c.metal,c.oil])
	return [countries,w.econ.upk.save_state(),w.econ._stats,w.rng.state]

func _run() -> void:
	var w: GameWorld = fixture(false)
	var upk = w.econ.upk
	var reference: GameWorld = fixture(true)
	for mutation in 5:
		var all: Dictionary = upk._tally_all()
		for c: Country in w.countries:
			check(all[c.id] == upk.tally(c.id), "FIX08 one-pass tally matches reference per-country tally, mutation %d country %d"%[mutation,c.id])
		upk.calls = 0
		upk._step()
		reference.econ.upk._step()
		check(upk.calls == 0, "FIX08 existing tally avoids expensive fallback")
		check(state(w) == state(reference), "FIX08 economic outputs/counters/RNG match genuine fallback path")
		for world: GameWorld in [w,reference]:
			match mutation:
				0: # Ownership/capture: both paths must observe the current array immediately.
					world.mil.facilities[0].country_id = 2
				1:
					world.mil.facilities[1].restore_t = 10.0
				2:
					var f := Facility.new()
					f.kind = Facility.Kind.AIRPORT
					f.id = world.mil.facilities.size()
					f.country_id = 1
					f.hp = 100.0
					world.mil.facilities.append(f)
				3:
					world.econ.upk.load_state(world.econ.upk.save_state(),true)
			world.game_time += 10.0
	check(reference.econ.upk.calls == 15, "FIX08 missing tally still executes fallback for every eligible country")
	var result := {"checks":checks,"failures":failures,"passed":failures.is_empty()}
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			FileAccess.open(a.trim_prefix("--out="),FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("UPKEEP_FALLBACK ",JSON.stringify(result))
	w.free()
	reference.free()
	quit(0 if failures.is_empty() else 1)
