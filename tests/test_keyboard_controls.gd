extends SceneTree


class ProbeMain:
	extends "res://game/main.gd"

	var actions: Array[String] = []

	func _on_action(nm: String) -> void:
		actions.append(nm)
		# Observe the input dispatch without arming or launching an actual nuke.
		if not nm.begins_with("nuke_"):
			super._on_action(nm)


var checks: int = 0
var failures: Array[String] = []


func _initialize() -> void:
	_run.call_deferred()


func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)


func press(logical: int, physical: int = KEY_NONE, ctrl: bool = false, echo: bool = false, meta: bool = false) -> void:
	var event := InputEventKey.new()
	event.keycode = logical
	event.physical_keycode = physical
	event.pressed = true
	event.ctrl_pressed = ctrl
	event.meta_pressed = meta
	event.echo = echo
	root.push_input(event, true)


func check_gameplay_input_blocked(m: ProbeMain, army: Object, ui: String) -> void:
	var page: int = m.hud._page
	var slot: int = army._recall_k
	press(KEY_F7 if page != 6 else KEY_F2)
	press(KEY_2 if slot != 2 else KEY_3)
	check(m.hud._page == page and army._recall_k == slot, "%s blocks gameplay shortcuts" % ui)


func _finish() -> void:
	var project_actions: Array[String] = []
	for property: Dictionary in ProjectSettings.get_property_list():
		var name: String = property["name"]
		if name.begins_with("input/"):
			project_actions.append(name)
	var result := {"checks": checks, "passed": failures.is_empty(), "failures": failures, "project_input_settings": project_actions}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="), FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("KEYBOARD_QA ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)


func _run() -> void:
	if not OS.get_user_data_dir().contains("df_input_qa"):
		check(false, "fixture requires an isolated df_input_qa profile")
		_finish()
		return
	root.size = Vector2i(1280, 720)
	var m := ProbeMain.new()
	root.add_child(m)
	current_scene = m
	for i in 120:
		await process_frame
		if m.loading != null and not m.loading.visible and m.world.data != null:
			break
	m.set_process(false)
	m.net.set_process(false)
	m.menus.close()
	m.in_menu = false
	m.hud.visible = true
	var settings := WorldSettings.new()
	settings.size = 512
	settings.world_seed = 20261016
	await m.start_world(settings)
	m.world.set_process(false)
	var site := Vector2i(-1, -1)
	for y in range(65, 448, 17):
		for x in range(65, 448, 17):
			if m.world.can_found_city(Vector2i(x, y), City.Kind.CAPITAL, true).ok:
				site = Vector2i(x, y)
				break
		if site.x >= 0:
			break
	check(site.x >= 0 and m.world.place_player_capital(site) != null, "built a player capital")
	if m.world.player == null:
		_finish()
		return
	m._set_mode(m.Mode.NONE)
	var b: Facility = null
	for dy in range(-36, 37, 3):
		for dx in range(-36, 37, 3):
			b = m.world.mil.build(Facility.Kind.BARRACKS, site + Vector2i(dx, dy), m.world.player, null, true)
			if b != null:
				break
		if b != null:
			break
	var army: Object = m._pc_army()
	check(b != null, "built barracks for the group fixture")
	check(army != null and army.ok(), "production army selection is active")
	if b == null or army == null or not army.ok():
		_finish()
		return

	for i in range(7):
		m.actions.clear()
		press(KEY_F1 + i)
		check(m.hud._page == i, "F%d selects HUD page %d" % [i + 1, i])
		var folded: bool = m.hud.keys_collapsed
		press(KEY_F1 + i, KEY_NONE, false, true)
		check(m.hud._page == i and m.hud.keys_collapsed == folded, "F%d echo leaves HUD unchanged" % (i + 1))
	press(KEY_F2)
	var hash_before: String = NetHash.of(m.world)
	var delayed_before: int = m.world._delayed.size()
	for d in range(1, 10):
		press(KEY_0 + d)
		check(m.mode == m.Mode.NONE and m.hud._page == 1, "F2 then empty slot %d leaves mode and page alone" % d)
		m._set_mode(m.Mode.NONE)
	press(KEY_F8)
	press(KEY_F9)
	press(KEY_T)
	press(KEY_NONE, KEY_T)
	check(m.mode == m.Mode.NONE and m.hud._page == 1, "F8, F9 and T leave gameplay unchanged")

	press(KEY_3)
	m._tap(m.cam.world_to_screen(Vector2((site + Vector2i(16, 0)) * GameWorld.CELL)))
	check(m.world._delayed.size() == delayed_before and NetHash.of(m.world) == hash_before and m.mode == m.Mode.NONE, "3 and map click cannot schedule a free strike")
	m._set_mode(m.Mode.NONE)
	m._on_action("strike")
	check(m.mode == m.Mode.NONE, "old UI action cannot enable the test strike")
	m._set_mode(m.Mode.NONE)
	var delays_before_b: int = m.world._delayed.size()
	press(KEY_B)
	check(m.mode == m.Mode.NONE and m.world._delayed.size() == delays_before_b, "B cannot schedule a test strike")
	for d in range(1, 10):
		army.sel[b.id] = true
		press(KEY_0 + d, KEY_0 + d, true)
		army.sel.clear()
		press(KEY_NONE, KEY_0 + d)
		check(army._recall_k == d and army.alive_fids() == PackedInt32Array([b.id]), "Ctrl+%d assigns and physical digit recalls the correct slot" % d)
	var recall_key: int = army._recall_k
	press(KEY_2, KEY_2, false, true)
	check(army._recall_k == recall_key, "digit echo does not recall a different group")
	press(KEY_2, KEY_2, false, false, true)
	check(army._recall_k == recall_key, "Meta combination does not recall a group")
	m._set_mode(m.Mode.TOWN)
	press(KEY_3)
	check(m.mode == m.Mode.TOWN and army._recall_k == recall_key, "placement retains mode when a bound digit is pressed")
	m._set_mode(m.Mode.NONE)

	press(KEY_F2)
	var edit := LineEdit.new()
	m.hud.root.add_child(edit)
	edit.grab_focus()
	check(edit.is_visible_in_tree() and root.gui_get_focus_owner() == edit, "visible text field has focus")
	check_gameplay_input_blocked(m, army, "focused text field")
	edit.free()
	m.menus.show_main()
	check_gameplay_input_blocked(m, army, "open menu")
	m.menus.close()
	m._speed_picker()
	check_gameplay_input_blocked(m, army, "speed picker")
	press(KEY_ESCAPE)
	check(not bool(m._spick.get("is_open")), "Esc dismisses the speed picker")

	var silo := Facility.new()
	silo.kind = Facility.Kind.NUKE_SILO
	silo.country_id = m.world.player.id
	m.selected_fac = silo
	var cam_before: Vector2 = m.cam.position
	for state: Array in [[0, "nuke_build"], [2, "nuke_arm"], [3, "nuke_launch"]]:
		silo.nuke_state = state[0]
		m.actions.clear()
		press(KEY_N if state[0] == 0 else KEY_NONE, KEY_N)
		press(KEY_NONE, KEY_N, false, true)
		check(m.actions == [state[1]] and m.cam.position == cam_before, "physical N dispatches only %s for owned selected silo" % state[1])
	m.selected_fac = null
	m.actions.clear()
	press(KEY_N)
	check(m.actions.is_empty() and m.cam.position == cam_before, "N without an owned selected silo leaves camera unchanged")
	m._on_action("missile")
	check(m.mode == m.Mode.MISSILE and m.strike.active, "normal missile action still opens the TEL planner")
	_finish()
