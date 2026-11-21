extends SceneTree
## Real FORMAT1 decoder + Main loader. Only the error injection overrides a UI callback.
var checks: int = 0
var failures: Array = []
var cases: Dictionary = {}
var args: Dictionary = {}

class RestoreMain:
	extends "res://game/main.gd"
	var inject_error: bool = false
	var successes: int = 0
	var close_pending: bool = false
	var close_done: bool = false
	func _on_zoom(z: float) -> void:
		if inject_error:
			inject_error = false
			var missing: Variant = null
			missing.r02_injected_ui_failure() # Runtime error also in release builds (asserts may be stripped).
		super._on_zoom(z)
	func net_after_restore() -> void:
		successes += 1
		super.net_after_restore()
	func net_match_closed() -> void:
		close_pending = true
		close_done = false
		await super.net_match_closed()
		close_done = true

func _initialize() -> void:
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--") and a.contains("="):
			args[a.get_slice("=",0).trim_prefix("--")] = a.substr(a.find("=")+1)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)

func pack(body: Dictionary) -> PackedByteArray:
	var raw: PackedByteArray = var_to_bytes(body)
	return var_to_bytes([raw.size(),raw.compress(FileAccess.COMPRESSION_ZSTD)])

func frozen(m: RestoreMain) -> void:
	m.set_process(false)
	m.net.set_process(false)
	m.net.lan.set_process(false) # Failure UI may open MP; never scan the real LAN from this fixture.
	m.world.set_process(false)

func configure(m: RestoreMain) -> void:
	m.net._reset_lockstep()
	m.net.in_match = true
	m.net.mode = NetSession.Mode.LAN
	m.net.is_host = false
	m.net.local_slot = 0
	m.net.rejoining = true
	m.net.go = false
	m.world.net_driven = true
	m.net.turns = {100:[]}
	m.net._pending = [{"k":"town","s":0,"cell":Vector2i(2,2)}]

func menu_done(m: RestoreMain) -> void:
	for i in 180:
		await process_frame
		if m.in_menu and m.loading != null and not m.loading.visible and m.world.data != null and (not m.close_pending or m.close_done):
			await process_frame # The caller awaiting _main_menu must finish its cleanup as well.
			return
	check(false,"Main menu did not recover after failed restore")

func _run() -> void:
	var user: String = OS.get_user_data_dir()
	if not (user.contains("phase5b1") or user.contains("df_snapshot_test_")):
		push_error("Refusing snapshot test outside isolated test user directory")
		quit(2)
		return
	seed(91234)
	var m := RestoreMain.new()
	m.name = "Main"
	root.add_child(m)
	current_scene = m
	await menu_done(m)
	frozen(m)
	var valid: PackedByteArray
	if args.has("checkpoint"):
		valid = FileAccess.get_file_as_bytes(args["checkpoint"])
	else:
		m.world.player = m.world.countries[0]
		m.world.player.is_player = true
		m.world.player.power_prio = 1
		m.world.player.nuke_pledge_until = 77.0
		m.world.hold._far_fail = {"1:2": 120.0}
		var f := Facility.new()
		f.id = 9000
		f.country_id = m.world.player.id
		f.nuke_warhead = 2
		f.nuke_tt = 120.0
		f.emp_until = 75.0
		f.ref_fuel = 10
		f.t3_spec = 1
		m.world.mil.facilities.append(f)
		valid = Save.net_snapshot(m)
	var wrapper: Array = bytes_to_var(valid)
	var original: Dictionary = bytes_to_var(wrapper[1].decompress(wrapper[0],FileAccess.COMPRESSION_ZSTD))
	var bad: Dictionary = {"invalid":var_to_bytes({"bad":true}),"truncated":valid.slice(0,valid.size()-3),
		"wrapper_types":var_to_bytes(["wrong",PackedByteArray([1])]),"oversize":var_to_bytes([(1<<30)+1,PackedByteArray([1])])}
	var raw: PackedByteArray = "not a Variant".to_utf8_buffer()
	bad["deserialize"] = var_to_bytes([raw.size(),raw.compress(FileAccess.COMPRESSION_ZSTD)])
	for name: String in ["missing_core","missing_owners","incompatible","bad_reference","unknown_entity","missing_system","nan_clock","float_format"]:
		var body: Dictionary = original.duplicate(true)
		match name:
			"missing_core":body.erase("core")
			"missing_owners":body["core"].erase("owners")
			"incompatible":body["format"] = 2
			"bad_reference":body["core"]["rng"] = {Save.REF:999999}
			"unknown_entity":body["ents"][0][0] = "Node"
			"missing_system":body["sys"].erase("econ")
			"nan_clock":body["core"]["game_time"] = NAN
			"float_format":body["format"] = 1.0
		bad[name] = pack(body)
	var unchanged: String = NetHash.of(m.world)
	for name: String in bad:
		var accepted: bool = await Save.net_restore(m,bad[name])
		check(not accepted,name+": actual decoder rejects malformed snapshot")
		check(NetHash.of(m.world) == unchanged,name+": preflight rejects before mutation")
		cases[name] = {"accepted":accepted,"hash_unchanged":NetHash.of(m.world) == unchanged}
	configure(m)
	var ok: bool = await m.net._restore_from(valid,99)
	frozen(m)
	check(ok and m.net.exec_turn == 100 and m.net.exec_tick == 0 and m.world.net_tick == 300,"valid: actual loader commits correct clocks")
	check(m.net.go and not m.net.rejoining and m.successes == 1,"valid: actual Main notified exactly once")
	if not args.has("checkpoint"):
		check(m.world.player.power_prio == 1 and m.world.player.nuke_pledge_until == 77.0, "v036: country simulation fields restored")
		check(m.world.hold._far_fail == {"1:2": 120.0}, "v036: dispatch cooldown restored through actual Main")
		var restored: Facility = m.world.mil.facilities[-1]
		check(restored.nuke_warhead == 2 and restored.nuke_tt == 120.0 and restored.emp_until == 75.0 and restored.ref_fuel == 10 and restored.t3_spec == 1, "v036: facility simulation fields restored")
	var hash1: String = NetHash.of(m.world)
	var rng1: int = m.world.rng.state
	check(m.net._pending.size() == 1 and m.net.turns.has(100),"valid: commands and next turn retained")
	await m.net._restore_from(valid,99)
	check(NetHash.of(m.world) == hash1 and m.successes == 1,"duplicate: actual loader is not repeated")
	# Error occurs after core/systems were already replaced. It must not become a success.
	configure(m)
	var successes: int = m.successes
	m.inject_error = true
	ok = await m.net._restore_from(valid,5)
	check(not ok and not m.net.in_match and not m.net.go,"intermediate script error: session ended safely")
	check(m.successes == successes and m.net._pending.is_empty() and m.net.turns.is_empty(),"intermediate script error: no success/queued gameplay")
	check(not m.world.is_processing(),"intermediate script error: partial world frozen until fresh menu")
	await menu_done(m)
	check(m.world.is_processing(),"failure recovery: rebuilt menu world processes again")
	frozen(m)
	configure(m)
	ok = await m.net._restore_from(valid,99)
	frozen(m)
	check(ok and m.net.in_match and m.net.go,"retry: explicit fresh session restores")
	check(NetHash.of(m.world) == hash1 and m.world.rng.state == rng1,"retry: same bytes recover same hash and RNG")
	# Compare continuation after the same snapshot with different rendering schedules.
	for tick in 60:
		m.world.net_step(NetConfig.SIM_DT)
		m.world._process(1.0/144.0)
	var continued: String = NetHash.of(m.world)
	var continued_rng: int = m.world.rng.state
	configure(m)
	await m.net._restore_from(valid,99)
	frozen(m)
	for tick in 60:
		m.world.net_step(NetConfig.SIM_DT)
		if tick % 3 == 0:
			m.world._process(0.1)
	check(NetHash.of(m.world) == continued and m.world.rng.state == continued_rng,"restore replay: identical commands/ticks produce identical hash/RNG")
	configure(m)
	await m.net._restore_from(valid,99)
	frozen(m)
	var owner: Country = m.world.player
	owner.army_defend = false
	var seen: Array = []
	var commands: Array = []
	for i in 2:
		commands.append({"k":"call","s":0,"q":i+1,"o":"","m":"cmd_field","a":NetCodec.encode([owner,"army_defend",i==0])})
		m.net._cbs[i+1] = func(_value:Variant)->void:seen.append(owner.army_defend)
	m.net.turns[100] = commands
	m.net._run(NetConfig.SIM_DT,0.0)
	check(seen == [true,false] and m.net.exec_tick == 1 and m.world.net_tick == 301,"next turn: commands execute once in canonical order at tick zero")
	m.net._run(NetConfig.SIM_DT,0.0)
	check(seen == [true,false] and m.net.exec_tick == 2,"next turn: commands are not repeated on subsequent tick")
	if not args.has("checkpoint"):
		var legacy: Dictionary = original.duplicate(true)
		legacy["sys"]["hold"].erase("far_fail")
		for e: Array in legacy["ents"]:
			if e[0] == "Country":
				e[1].erase("power_prio")
				e[1].erase("nuke_pledge_until")
			if e[0] == "Facility":
				for key: String in ["nuke_tt", "nuke_warhead", "emp_until", "ref_fuel", "t3_spec"]:
					e[1].erase(key)
		check(await Save.net_restore(m, pack(legacy)), "v036: legacy FORMAT1 loads without optional fields")
		frozen(m)
		check(m.world.hold._far_fail.is_empty() and m.world.player.power_prio == 0 and m.world.player.nuke_pledge_until == -1.0, "v036: legacy restore uses defaults, not stale runtime state")
	# Failed resync must close normally; late snapshots must not reopen that session.
	m.net.rejoining = false
	ok = await m.net._restore_from(bad["invalid"],150)
	check(not ok and not m.net.in_match and not m.net.go,"resync: invalid snapshot cannot resume gameplay")
	var turn: int = m.net.exec_turn
	m.net._snap_begin(151,1,1)
	m.net._snap_part(0,PackedByteArray([1]))
	check(not m.net.in_match and m.net.exec_turn == turn,"late snapshot cannot revive ended session")
	await menu_done(m)
	frozen(m)
	var result := {"checks":checks,"passed":failures.is_empty(),"failures":failures,"cases":cases,
		"restored_hash":hash1,"replay_hash":continued,"replay_rng":continued_rng,"expected_injected_script_errors":1,"user_data_dir":user}
	if args.has("out"):
		FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("SNAPSHOT_INTEGRATION ",JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)
