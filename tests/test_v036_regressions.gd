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
		_: check(false, "Unknown case: " + name)
	var result: Dictionary = {"passed": failures.is_empty(), "checks": checks, "failures": failures}
	FileAccess.open(out, FileAccess.WRITE).store_string(JSON.stringify(result))
	print("V036_RESULT ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)

func _autosave() -> void:
	var a := Facility.new()
	var b := Facility.new()
	a.obj_ids = PackedInt32Array([10, 11])
	b.obj_ids = PackedInt32Array([20, 21])
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
	var nested: Dictionary = {"array": [{"packed": packed}], "typed": typed}
	var padding := PackedByteArray()
	padding.resize(32 * 1024 * 1024) # Hold the worker before it reaches entity fields.
	var body: Dictionary = {"padding": padding, "core": {}, "ents": ents, "refs": refs, "nested": nested}
	for round_i in 2:
		var expected: PackedByteArray = var_to_bytes(body)
		var h: Dictionary = {"format": 1, "slot": 1, "seq": round_i + 1, "t_ms": round_i + 1}
		var task: int = Save._queue_write(h, body)
		a.obj_ids[0] = 99 + round_i
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
		Save._dec.clear()

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
	host.free()
	peer.free()

