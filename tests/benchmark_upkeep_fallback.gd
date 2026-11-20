extends SceneTree
## Measures only real Upkeep._step CPU on a fixed checkpoint, not rendering or full simulation.
class Spy:
	extends "res://game/upkeep335.gd"
	var fallback_calls: int = 0
	func tally(cid: int) -> Dictionary:
		fallback_calls += 1
		return super.tally(cid)
class Host:
	extends Node
	var world: GameWorld
	var cam: MapCamera
	var _speed_i: int = 0
	var _paused: bool = false
	var in_menu: bool = false
var args: Dictionary = {}
func _initialize() -> void:
	for a: String in OS.get_cmdline_user_args():
		args[a.get_slice("=",0).trim_prefix("--")] = a.substr(a.find("=")+1)
	_run.call_deferred()
func _run() -> void:
	seed(91234)
	Engine.max_fps = 0
	var host := Host.new()
	root.add_child(host)
	var w := GameWorld.new()
	host.world = w
	host.add_child(w)
	w.set_process(false)
	GameWorld.lab_tick = 0
	host.cam = MapCamera.new()
	host.add_child(host.cam)
	w.camera = host.cam
	var packed: Array = bytes_to_var(FileAccess.get_file_as_bytes(args["checkpoint"]))
	var body: Dictionary = bytes_to_var((packed[1] as PackedByteArray).decompress(int(packed[0]),FileAccess.COMPRESSION_ZSTD))
	var settings := WorldSettings.new()
	Save.fill(settings,body["core"]["settings"])
	Save._set_cfg(body["core"]["cfg"])
	w.new_world(settings)
	Save._load_core(w,body)
	Save._load_systems(w,body["sys"])
	Save._finish(w,body["core"])
	var original: Dictionary = w.econ.upk.save_state()
	var upk := Spy.new(w.econ)
	upk.load_state(original,true)
	w.econ.upk = upk
	var n: int = int(args.get("samples",500))
	var samples: Array = []
	var total: int = 0
	for i in n:
		var started: int = Time.get_ticks_usec()
		upk._step()
		var us: int = Time.get_ticks_usec()-started
		samples.append(us/1000.0)
		total += us
		w.game_time += 10.0
	samples.sort()
	var countries: Array = []
	for c: Country in w.countries:
		countries.append([c.id,c.money,c.fuel,c.metal,c.oil,c.earned])
	var digest := HashingContext.new()
	digest.start(HashingContext.HASH_SHA256)
	digest.update(var_to_bytes([countries,upk.save_state(),w.econ._stats]))
	var result := {"scope":"Upkeep._step only;500 successive upkeep intervals;no rendering/no whole simulation", "samples":n,"seed":91234,"checkpoint":args["checkpoint"],"world_size":w.data.w,"countries":w.countries.size(),"facilities":w.mil.facilities.size(),"p50_ms":samples[n/2],"p99_ms":samples[mini(n-1,ceili(n*0.99)-1)],"average_ms":float(total)/n/1000.0,"max_ms":samples.back(),"fallback_calls":upk.fallback_calls,"economy_digest":digest.finish().hex_encode(),"hash":NetHash.of(w),"rng":w.rng.state,"memory":"NOT MEASURED","raw_sorted_ms":samples}
	FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("UPKEEP_BENCHMARK ",JSON.stringify(result))
	quit()
