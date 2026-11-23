extends SceneTree

const ArmyGroups = preload("res://game/army_groups.gd")

var checks := 0
var failures: Array[String] = []
var last_pointer := Vector2.ZERO


func _initialize() -> void:
	_run.call_deferred()


func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)


func frames(count: int = 4) -> void:
	for i in count:
		await process_frame


func motion(at: Vector2, mask: int = 0, shift: bool = false) -> void:
	var event := InputEventMouseMotion.new()
	event.position = at
	event.relative = at - last_pointer
	event.button_mask = mask
	event.shift_pressed = shift
	last_pointer = at
	root.push_input(event, true)


func button(at: Vector2, index: MouseButton, down: bool, double: bool = false, shift: bool = false) -> void:
	var event := InputEventMouseButton.new()
	event.position = at
	event.button_index = index
	event.pressed = down
	event.double_click = double
	event.shift_pressed = shift
	root.push_input(event, true)


func wheel(at: Vector2, index: MouseButton) -> void:
	motion(at)
	button(at, index, true)


func center_of(control: Control) -> Vector2:
	return control.get_global_transform_with_canvas() * (control.size * 0.5)


func within(control: Control) -> bool:
	var box := Rect2(control.get_global_transform_with_canvas().origin, control.size)
	return root.get_visible_rect().grow(1.0).encloses(box)


func camera_state(main: Node) -> Vector3:
	return Vector3(main.cam.position.x, main.cam.position.y, main.cam.zoom.x)


func capture(name: String) -> void:
	var out := OS.get_environment("DF_GUI_OUT")
	if out.is_empty() or DisplayServer.get_name() == "headless":
		return
	await create_timer(0.24).timeout
	await RenderingServer.frame_post_draw
	check(root.get_texture().get_image().save_png(out.path_join(name + ".png")) == OK, "capture " + name)


func finish() -> void:
	var result := {"checks": checks, "passed": failures.is_empty(), "failures": failures}
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="), FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("HUD_INPUT_QA ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)


func _run() -> void:
	if not OS.get_user_data_dir().contains("df_input_qa"):
		check(false, "fixture needs isolated df_input_qa profile")
		finish()
		return
	root.mode = Window.MODE_WINDOWED
	root.size = Vector2i(1280, 720)
	var pc := root.get_node_or_null("PcPort")
	if pc == null:
		pc = preload("res://pc/pc_port.gd").new()
		pc.name = "PcPort"
		root.add_child(pc)
	pc.set_scale_i(3)
	var main := preload("res://game/main.gd").new()
	root.add_child(main)
	current_scene = main
	for i in 120:
		await process_frame
		if main.loading != null and not main.loading.visible and main.world.data != null:
			break
	main.set_process(false)
	main.net.set_process(false)
	main.menus.close()
	main.in_menu = false
	main.hud.visible = true
	var settings := WorldSettings.new()
	settings.size = 512
	settings.world_seed = 20261016
	await main.start_world(settings)
	main.world.set_process(false)
	main.cam.set_process(false)
	while main.loading.visible:
		await process_frame
	var site := Vector2i(-1, -1)
	for y in range(65, 448, 17):
		for x in range(65, 448, 17):
			if main.world.can_found_city(Vector2i(x, y), City.Kind.CAPITAL, true).ok:
				site = Vector2i(x, y)
				break
		if site.x >= 0:
			break
	if site.x < 0 or main.world.place_player_capital(site) == null:
		check(false, "fixture could not found capital")
		finish()
		return
	main._set_mode(main.Mode.NONE)
	main.hud.refresh()
	await frames()
	var camera = main.cam
	camera.zoom = Vector2(2, 2)
	camera.position = Vector2(1000, 1000)
	camera.force_update_scroll()
	var point := root.get_visible_rect().size * Vector2(0.48, 0.36)
	motion(point)
	var before := camera_state(main)
	for mode in [0, 1]:
		for i in 20:
			button(point, MOUSE_BUTTON_LEFT, true, i == 1)
			if mode == 1:
				motion(point + Vector2(2, 2), MOUSE_BUTTON_MASK_LEFT)
			button(last_pointer, MOUSE_BUTTON_LEFT, false)
			motion(point)
		check(camera_state(main).is_equal_approx(before), "rapid clicks, double click and jitter keep camera still (case %d)" % mode)
		main.hud.close_panel()
		main._set_mode(main.Mode.NONE)

	button(point, MOUSE_BUTTON_LEFT, true)
	motion(point + Vector2(30, 12), MOUSE_BUTTON_MASK_LEFT)
	button(last_pointer, MOUSE_BUTTON_LEFT, false)
	check(not camera_state(main).is_equal_approx(before), "deliberate map LMB drag pans")
	before = camera_state(main)
	motion(point)
	button(point, MOUSE_BUTTON_RIGHT, true)
	motion(point + Vector2(32, 12), MOUSE_BUTTON_MASK_RIGHT)
	button(last_pointer, MOUSE_BUTTON_RIGHT, false)
	check(not camera_state(main).is_equal_approx(before), "deliberate map RMB drag pans")
	before = camera_state(main)
	wheel(point, MOUSE_BUTTON_WHEEL_DOWN)
	check(not is_equal_approx(camera.zoom.x, before.z), "wheel zooms on bare map")

	main.menus.show_settings_sub("ui")
	await create_timer(0.32).timeout
	await capture("settings-before-wheel")
	var sc: ScrollContainer = main.menus._scroll
	var scroll_point := center_of(sc)
	before = camera_state(main)
	for i in 24:
		wheel(scroll_point, MOUSE_BUTTON_WHEEL_DOWN)
	check(sc.scroll_vertical > 0, "Settings actually scrolls")
	check(camera_state(main).is_equal_approx(before), "Settings scroll and bottom boundary never zoom")
	wheel(Vector2(10, 60), MOUSE_BUTTON_WHEEL_UP)
	check(camera_state(main).is_equal_approx(before), "wheel over Settings backdrop never zooms")
	Loc.set_lang("en", false)
	await frames()
	wheel(center_of(main.menus._scroll), MOUSE_BUTTON_WHEEL_DOWN)
	check(camera_state(main).is_equal_approx(before), "wheel after language switch with Settings open never zooms")
	main.menus.close()
	await frames()
	wheel(point, MOUSE_BUTTON_WHEEL_UP)
	check(not is_equal_approx(camera.zoom.x, before.z), "map zoom returns after Settings closes")

	var overlay := Button.new()
	overlay.position = point + Vector2(60, 0)
	overlay.size = Vector2(90, 48)
	main.hud.root.add_child(overlay)
	await frames()
	before = camera_state(main)
	button(point, MOUSE_BUTTON_LEFT, true)
	motion(center_of(overlay), MOUSE_BUTTON_MASK_LEFT)
	button(last_pointer, MOUSE_BUTTON_LEFT, false)
	await frames()
	motion(point + Vector2(34, 38))
	button(point + Vector2(34, 38), MOUSE_BUTTON_LEFT, false)
	check(camera_state(main).is_equal_approx(before), "GUI-owned release cannot leave a map drag armed")
	motion(center_of(overlay))
	button(last_pointer, MOUSE_BUTTON_LEFT, true)
	button(last_pointer, MOUSE_BUTTON_LEFT, false)
	check(camera_state(main).is_equal_approx(before), "GUI click does not move camera")
	overlay.queue_free()
	await frames()

	motion(point)
	button(point, MOUSE_BUTTON_LEFT, true)
	main.notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT)
	motion(point + Vector2(48, 29), MOUSE_BUTTON_MASK_LEFT)
	button(last_pointer, MOUSE_BUTTON_LEFT, false)
	check(camera_state(main).is_equal_approx(before), "focus loss cancels held camera drag")
	main.notification(Node.NOTIFICATION_WM_WINDOW_FOCUS_IN)

	var barracks: Facility = null
	for dy in range(-36, 37, 3):
		for dx in range(-36, 37, 3):
			barracks = main.world.mil.build(Facility.Kind.BARRACKS, site + Vector2i(dx, dy), main.world.player, null, true)
			if barracks != null:
				break
		if barracks != null:
			break
	check(barracks != null, "created test barracks")
	if barracks != null:
		var unit: Unit = main.world.army._spawn(barracks, Unit.Type.INFANTRY)
		camera.position = unit.pos - Vector2(0, -25)
		camera.force_update_scroll()
		await frames()
		var army = main._pc_army()
		var unit_point: Vector2 = camera.world_to_screen(unit.pos)
		before = camera_state(main)
		motion(unit_point)
		button(unit_point, MOUSE_BUTTON_LEFT, true, false, true)
		button(unit_point, MOUSE_BUTTON_LEFT, false, false, true)
		check(army.alive_fids().has(barracks.id), "Shift+click selects an actual unit")
		army.clear()
		var start := unit_point - Vector2(34, 28)
		var end := unit_point + Vector2(34, 28)
		motion(start)
		button(start, MOUSE_BUTTON_LEFT, true, false, true)
		motion(end, MOUSE_BUTTON_MASK_LEFT, true)
		button(end, MOUSE_BUTTON_LEFT, false, false, true)
		check(army.alive_fids().has(barracks.id), "Shift+drag selects an actual unit")
		check(camera_state(main).is_equal_approx(before), "production army selection does not pan")
		var target := Vector2.INF
		var accepted_target := Vector2.INF
		for offset: Vector2 in [Vector2(210, -110), Vector2(-210, -110), Vector2(240, 30),
				Vector2(-240, 30), Vector2(175, 105), Vector2(-175, 105)]:
			var candidate := unit_point + offset
			motion(candidate)
			if root.gui_get_hovered_control() != null:
				continue
			var preview: Dictionary = ArmyGroups.preview(main.world, main.world.player.id, army.alive_fids(), "move", camera.screen_to_world(candidate))
			if not preview["ends"].is_empty():
				target = candidate
				accepted_target = preview["ends"][0][1]
				break
		check(target.is_finite(), "fixture has a legal movement order")
		if target.is_finite():
			button(target, MOUSE_BUTTON_RIGHT, true, false, true)
			button(target, MOUSE_BUTTON_RIGHT, false, false, true)
			check(army._wp_chain.size() == 1 and army._wp_chain[0].is_equal_approx(camera.screen_to_world(target)), "Shift+RMB preserves a single waypoint")
			var order: Dictionary = main.world.ops.of(barracks)
			check(not order.is_empty() and (order["target"] as Vector2).is_equal_approx(accepted_target), "production dispatcher applies the movement order")
			main.hud.army_ux.toast_x.pressed.emit()
		army.clear()

	var dock = main.hud.army_dock
	var ux = main.hud.army_ux
	for sample in [[Vector2i(1280, 720), 5, "uk"], [Vector2i(1366, 768), 3, "ru"],
			[Vector2i(1600, 900), 0, "en"], [Vector2i(1920, 1080), 5, "en"]]:
		root.size = sample[0]
		pc.set_scale_i(sample[1])
		Loc.set_lang(sample[2], false)
		await frames()
		ux.open_list()
		await frames()
		check(within(ux.sheet), "army list fits %s" % str(sample))
		ux.close_view()
		dock.internal = true
		dock.open_dock()
		dock.open_sheet("new", -1, PackedInt32Array([1]))
		await frames(8)
		check(dock.sheet.is_visible_in_tree() and within(dock.sheet), "group editor fits %s" % str(sample))
		await capture("group-" + str(sample[2]) + "-" + str(sample[0].x))
		if dock.sheet.get_child(0) is ScrollContainer:
			var group_scroll := dock.sheet.get_child(0) as ScrollContainer
			var create: Button = dock.sheet_refs["ok"]
			if group_scroll.get_v_scroll_bar().visible:
				var group_before := camera_state(main)
				for i in 40:
					wheel(center_of(group_scroll), MOUSE_BUTTON_WHEEL_DOWN)
				var scroll_rect := group_scroll.get_global_rect()
				check(group_scroll.scroll_vertical > 0 and scroll_rect.has_point(create.get_global_rect().get_center()), "group editor scroll reaches the create action")
				check(camera_state(main).is_equal_approx(group_before), "group editor scroll keeps map still")
				if sample[2] == "uk":
					await capture("group-uk-1280-actions")
		if sample[2] == "uk":
			root.size = Vector2i(960, 540)
			await frames(8)
			check(dock.sheet.is_visible_in_tree() and within(dock.sheet), "open group editor fits after resize to 960x540 at 130%")
		dock.close()
		await frames()

	var anchor := Button.new()
	anchor.position = root.get_visible_rect().size - Vector2(48, 60)
	anchor.size = Vector2(40, 40)
	main.hud.root.add_child(anchor)
	await frames()
	var entries: Array = []
	for i in 28:
		entries.append(["Action %d" % i, "A long tooltip-sized description for action %d" % i, func() -> void: pass])
	ux._popover(anchor, "Army context", entries)
	await frames()
	var pop := ux._pop.get_child(0) as PanelContainer
	check(within(pop), "tall context popup at right edge fits")
	await capture("army-context-right-edge")
	if pop.get_child(0) is ScrollContainer:
		var pop_scroll := pop.get_child(0) as ScrollContainer
		before = camera_state(main)
		for i in 80:
			wheel(center_of(pop_scroll), MOUSE_BUTTON_WHEEL_DOWN)
		check(pop_scroll.scroll_vertical > 0, "tall context popup scrolls to its lower actions")
		check(camera_state(main).is_equal_approx(before), "scrollable army context does not zoom map")
	else:
		check(false, "army context supports vertical scrolling")
	ux._close_pop()
	finish()
