extends Node

class FixtureMain:
	extends "res://game/main.gd"

	func _main_menu() -> void:
		# The fixture starts its fixed-seed match directly.
		loading.hide()
const Probe = preload("res://perf01_scopes.gd")
const CHECKPOINTS = [10, 50, 100, 150, 199, 200, 201, 250, 300, 500]
const SIZE = Vector2i(1480, 950)

var root: Window
var out: String
var limit: int = 500
var setup_tels: int = 250
var verify_ui: bool = false
var verify_mp: bool = false
var collect_frames: bool = true
var main: FixtureMain
var samples: Dictionary = {}
var failures: Array[String] = []
var before_nodes: int
var mouse: Vector2


func _ready() -> void:
	root = get_tree().root
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			out = arg.trim_prefix("--out=")
		elif arg.begins_with("--limit="):
			limit = int(arg.trim_prefix("--limit="))
		elif arg.begins_with("--tels="):
			setup_tels = int(arg.trim_prefix("--tels="))
		elif arg == "--verify-ui":
			verify_ui = true
		elif arg == "--verify-mp":
			verify_mp = true
			collect_frames = false
	_run.call_deferred()


func check(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)
		printerr("PERF01 CHECK FAILED: ", label)


func frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func button(at: Vector2, index: int, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = index
	event.pressed = pressed
	event.position = at
	root.push_input(event, true)


func motion(at: Vector2) -> void:
	var event := InputEventMouseMotion.new()
	event.position = at
	event.relative = at - mouse
	mouse = at
	root.push_input(event, true)


func click(at: Vector2) -> int:
	var stamp: int = Time.get_ticks_usec()
	motion(at)
	button(at, MOUSE_BUTTON_LEFT, true)
	button(at, MOUSE_BUTTON_LEFT, false)
	return Time.get_ticks_usec() - stamp


func click_control(control: Control) -> int:
	return click(control.get_global_rect().get_center())


func begin_sample() -> void:
	Probe.values = {}
	Probe.enabled = true


func end_sample() -> Dictionary:
	Probe.enabled = false
	return Probe.values


func counts() -> Dictionary:
	var world: GameWorld = main.world
	return {
		"nodes": get_tree().get_node_count(),
		"controls": count_controls(root),
		"objects": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"world_objects": world.obj_spr.size() - world._free_ids.size(),
		"units": world.army.units.size(),
		"facilities": world.mil.facilities.size(),
	}


func count_controls(node: Node) -> int:
	var total: int = int(node is Control)
	for child: Node in node.get_children():
		total += count_controls(child)
	return total


func observe(points: Array[Vector2], hover: bool) -> Dictionary:
	var frame_us: Array[int] = []
	var draw_calls: Array[int] = []
	var motion_us: Array[int] = []
	begin_sample()
	var stamp: int = Time.get_ticks_usec()
	for i in 26:
		if hover:
			var at: Vector2 = points[(i * 19) % points.size()]
			root.warp_mouse(at)
			var start: int = Time.get_ticks_usec()
			motion(at)
			motion_us.append(Time.get_ticks_usec() - start)
		await get_tree().process_frame
		var now: int = Time.get_ticks_usec()
		frame_us.append(now - stamp)
		stamp = now
		draw_calls.append(int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	var scopes: Dictionary = end_sample()
	return {"frame_us": frame_us, "draw_calls": draw_calls, "motion_us": motion_us, "scopes_us": scopes}


func positions() -> Array[Vector2]:
	var points: Array[Vector2] = []
	# Visit widely separated points to keep successive clicks clear of double-tap zoom.
	const COLS = 49
	const ROWS = 18
	for i in COLS * ROWS:
		var index: int = (i * 137) % (COLS * ROWS)
		var at := Vector2(148 + (index % COLS) * 24, 146 + floori(float(index) / COLS) * 24)
		# The strike card expands into this area during layout.
		if at.y >= 266 and at.x < 820:
			continue
		points.append(at)
	return points


func build_tels() -> int:
	var ready: int = 0
	var mil: Military = main.world.mil
	# Keep the full launch pool south of the visible targets and beyond MISSILE_MIN.
	for y in range(375, 503, 3):
		for x in range(30, 482, 7):
			var tel: Facility = mil.build(Facility.Kind.TEL, Vector2i(x, y), main.world.player, null, true)
			if tel != null:
				ready += 1
				if ready == setup_tels:
					return ready
	return ready


func plan_digest() -> Dictionary:
	var targets: Array = main._plan_targets()
	var plan: Dictionary = main.world.mil.missile_multi_plan(main.world.player, targets)
	var wire: Variant = NetCodec.encode([main.world.player, {"tel": targets}, main.StrikeHubScript.sync_arrive])
	var restored: Array = NetCodec.decode(main.world, wire)
	check(restored[0] == main.world.player and restored[1]["tel"] == targets, "wire round-trip preserves ordered targets")
	var allocation: Array = []
	for e: Array in plan["plan"]:
		allocation.append([e[0].id, e[1]])
	return {
		"command": JSON.stringify(wire).sha256_text(),
		"ordered_allocation": JSON.stringify(allocation).sha256_text(),
		"assigned": plan["assigned"], "total": plan["total"], "available": plan["available"],
		"net_hash_before": NetHash.of(main.world),
	}


func _finish() -> void:
	var result := {"passed": failures.is_empty(), "failures": failures, "samples": samples}
	FileAccess.open(out, FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("PERF01 completed ", failures.size(), " failures")
	get_tree().quit(0 if failures.is_empty() else 1)


func _run() -> void:
	if out.is_empty() or not OS.get_user_data_dir().contains("perf01"):
		printerr("PERF01 requires --out= and an isolated perf01 user-data directory")
		get_tree().quit(2)
		return
	seed(91234)
	root.size = SIZE
	root.content_scale_factor = 1.0
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.vsync_mode = DisplayServer.VSYNC_DISABLED
	Engine.max_fps = 0
	Loc.set_lang("ru", false)
	main = FixtureMain.new()
	root.add_child(main)
	for i in 240:
		await get_tree().process_frame
		if main.loading != null and not main.loading.visible:
			break
	main.net.set_process(false)
	main.world.set_process(false)
	main.menus.close()
	main.in_menu = false
	main.hud.visible = true
	var settings := WorldSettings.new()
	settings.size = 512
	settings.world_seed = 20261016
	await main.start_world(settings)
	main.world.set_process(false)
	while main.loading.visible:
		await get_tree().process_frame
	main.menus.close()
	GameConfig.confirm_actions = false
	printerr("PERF01 world ready")
	var site := Vector2i(-1, -1)
	for y in range(170, 340, 7):
		for x in range(170, 340, 7):
			if main.world.can_found_city(Vector2i(x, y), City.Kind.CAPITAL, true).ok:
				site = Vector2i(x, y)
				break
		if site.x >= 0:
			break
	if site.x < 0 or main.world.place_player_capital(site) == null:
		check(false, "valid capital site and real capital")
		_finish()
		return
	main.world.data.owners.fill(main.world.player.id)
	var tels: int = build_tels()
	var magazine: int = main.world.mil.missiles_ready(main.world.player.id)
	printerr("PERF01 launchers=", tels, " ready=", magazine)
	samples["workload"] = {"tels": tels, "magazine": magazine, "size": str(root.size), "seed": settings.world_seed}
	check(limit <= magazine, "enough ready missiles for requested count, actual %d" % magazine)
	if not failures.is_empty():
		_finish()
		return
	main._set_mode(main.Mode.NONE)
	main.hud.refresh()
	main.cam.zoom = Vector2.ONE
	main.cam.center_on(Vector2(256, 256) * GameWorld.CELL)
	await frames(8)
	Engine.max_fps = 0
	samples["workload"]["zoom"] = main.cam.zoom.x
	samples["workload"]["camera"] = str(main.cam.position)
	samples["workload"]["game_time"] = main.world.game_time
	samples["workload"]["net_hash_initial"] = NetHash.of(main.world)
	check(main.world.game_time == 0.0, "world was frozen before the first adaptive step")
	var points: Array[Vector2] = positions()
	check(root.get_visible_rect().size == Vector2(SIZE), "physical and logical viewport sizes match")
	check(points.size() > limit and root.get_visible_rect().has_point(points[limit]), "viewport has enough legal click coordinates")
	samples["before_open"] = counts()
	begin_sample()
	main._on_action("missile")
	await frames(3)
	samples["open_scopes_us"] = end_sample()
	check(main.strike.active and main.strike.cur == "tel", "OTRK UI opens through the normal action")
	if not failures.is_empty():
		_finish()
		return
	await frames(9)
	samples["after_open"] = counts()
	samples["workload"]["viewport"] = str(root.get_visible_rect().size)
	samples["workload"]["ops_card"] = str(main.hud.ops_panel.get_global_rect())
	var add: Array[int] = []
	var input_scopes: Dictionary = {}
	for i in limit:
		begin_sample()
		add.append(click(points[i]))
		var measured: Dictionary = end_sample()
		if (i + 1) in CHECKPOINTS:
			input_scopes[str(i + 1)] = measured
		var selected: int = main.plan_list.size() + int(main.plan_has_target)
		if selected != i + 1:
			check(false, "map click %d at %s, selected=%d, ops=%s hovered=%s" % [i + 1, points[i], selected, main.hud.ops_panel.get_global_rect(), root.gui_get_hovered_control()])
			break
		if i < 10 or (i + 1) % 8 == 0:
			await get_tree().process_frame
		if (i + 1) in CHECKPOINTS:
			var n: String = str(i + 1)
			await frames(3)
			samples[n] = {}
			if collect_frames:
				samples[n]["idle"] = await observe(points.slice(0, i + 1), false)
				samples[n]["hover"] = await observe(points.slice(0, i + 1), true)
			samples[n]["counts"] = counts()
			samples[n]["display"] = {"info": main.strike_ui._info.text, "fire": main.strike_ui._fire.text}
			if i + 1 in [50, 200, 300, 500] or i + 1 == limit:
				samples[n]["plan"] = plan_digest()
			printerr("PERF01 targets=", n, " input_us=", add[i])
	samples["add_us"] = add
	samples["add_scopes_us"] = input_scopes
	if not failures.is_empty():
		_finish()
		return
	await frames(2)
	if limit == magazine:
		click(points[limit])
		check(main._plan_targets().size() == limit, "extra dot rejected by the live ammo limit")
	if verify_ui:
		await verify_controls(points, limit)
	var before: String = NetHash.of(main.world)
	check(before == samples["workload"]["net_hash_initial"], "selection and HUD interaction preserve the initial NetHash")
	if verify_mp:
		main.net.in_match = true
		main.net.is_host = true
		main.net.local_slot = main.world.player.id - 1
	check(main.strike_ui._fire.is_visible_in_tree() and not main.strike_ui._fire.disabled, "enabled fire button")
	begin_sample()
	var confirm_us: int = click_control(main.strike_ui._fire)
	var scopes: Dictionary = end_sample()
	if verify_mp:
		verify_host_command(before)
	var queue: Array = []
	for tel: Facility in main.world.mil.facs_of_kind(Facility.Kind.TEL):
		if not tel.queued.is_empty():
			queue.append([tel.id, tel.queued.duplicate()])
	var queued: int = 0
	for entry: Array in queue:
		queued += entry[1].size()
	check(queued == limit, "one queued missile per target through UI, actual %d" % queued)
	var after_order: String = NetHash.of(main.world)
	begin_sample()
	var tick: Array[int] = []
	for i in 105:
		var stamp: int = Time.get_ticks_usec()
		if verify_mp:
			main.world.net_step(NetConfig.SIM_DT)
		else:
			main.world._sim_step(NetConfig.SIM_DT)
		tick.append(Time.get_ticks_usec() - stamp)
	samples["execution"] = {
		"confirm_us": confirm_us, "confirm_scopes_us": scopes,
		"queues": JSON.stringify(queue).sha256_text(), "queued": queued, "sim_step_us": tick,
		"sim_scopes_us": end_sample(), "live_missiles": main.world.mil.missiles.size(),
		"net_hash_before_order": before, "net_hash_after_order": after_order, "net_hash_after_ticks": NetHash.of(main.world),
	}
	if collect_frames:
		await frames(3)
		samples["post_launch"] = await observe(points, false)
	_finish()


func verify_host_command(before: String) -> void:
	click_control(main.strike_ui._fire)
	check(main.net._pending.size() == 1, "host queues one strike after duplicate confirmation")
	if main.net._pending.size() != 1:
		return
	var cmd: Dictionary = main.net._pending.pop_front()
	check(cmd["m"] == "cmd_strike" and cmd["o"] == "", "production UI dispatches cmd_strike")
	var digest: String = JSON.stringify(cmd["a"]).sha256_text()
	check(samples[str(limit)]["plan"]["command"] == digest, "actual wire command matches ordered preview targets")
	var denied: Dictionary = cmd.duplicate(true)
	denied["s"] = -1
	main.net._exec(denied)
	check(main.world.mil.missiles_ready(main.world.player.id) == samples["workload"]["magazine"] and NetHash.of(main.world) == before, "strike without a valid issuer leaves ready stock and NetHash intact")
	begin_sample()
	main.net._exec(cmd)
	var scopes: Dictionary = end_sample()
	samples["host"] = {"wire": digest, "scopes_us": scopes}


func verify_controls(points: Array[Vector2], n: int) -> void:
	var expected: Array = main._plan_targets()
	begin_sample()
	main._on_action("plan_back")
	samples["remove_scopes_us"] = end_sample()
	check(main._plan_targets().size() == n - 1, "back removes one target")
	click(points[n - 1])
	check(main._plan_targets() == expected, "reselect appends target in the original order")
	for lang: String in ["uk", "en", "ru"]:
		Loc.set_lang(lang, false)
		await frames(2)
		check(Loc.cur() == lang and not main.strike_ui._info.text.is_empty() and not main.strike_ui._fire.disabled, "usable strike UI for " + lang)
	begin_sample()
	main.strike_close()
	samples["close_scopes_us"] = end_sample()
	check(not main.strike.active and main._plan_targets().is_empty(), "close cancels current selection")
	main._on_action("missile")
	await frames(3)
	check(main._plan_targets() == expected, "reopen restores ordered draft")
	main.strike_pick("hyper", true)
	main.strike_pick("tel", true)
	await frames(3)
	check(main._plan_targets() == expected, "weapon switching restores ordered TEL targets")
	var old: Vector2 = main.cam.position
	var z: float = main.cam.zoom.x
	button(points[0], MOUSE_BUTTON_WHEEL_UP, true)
	await frames(5)
	check(main.cam.zoom.x != z, "zoom works while planning")
	main.cam.pan_screen(Vector2(65, 40))
	await frames(2)
	check(main.cam.position != old and main._plan_targets() == expected, "pan keeps world-space selection")
	main.cam.zoom = Vector2(z, z)
	main.cam.center_on(old)
	await frames(3)
