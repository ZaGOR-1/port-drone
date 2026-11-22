extends SceneTree

class ProbeMain:
	extends "res://game/main.gd"
	var reticles: Array[Vector2] = []
	func _draw_reticle(_mode: int, point: Vector2) -> void:
		reticles.append(point)

var samples: Dictionary = {}
var failures: Array[String] = []
var checks: int = 0
var opts: Dictionary = {}

func _initialize() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--") and arg.contains("="):
			opts[arg.get_slice("=", 0).trim_prefix("--")] = arg.substr(arg.find("=") + 1)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)

func frames(n: int) -> void:
	for i in n:
		await process_frame

func mouse_button(at: Vector2, button: int, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = button
	event.pressed = pressed
	event.position = at
	root.push_input(event, true)

func mouse_motion(at: Vector2, delta: Vector2, buttons: int = 0) -> void:
	var event := InputEventMouseMotion.new()
	event.position = at
	event.relative = delta
	event.button_mask = buttons
	root.push_input(event, true)

func nested_scroll(m: ProbeMain) -> void:
	var outer := ScrollContainer.new()
	outer.position = Vector2(45, 75)
	outer.size = Vector2(250, 175)
	outer.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	m.hud.root.add_child(outer)
	var outer_body := Control.new()
	outer_body.custom_minimum_size = Vector2(215, 340)
	outer.add_child(outer_body)
	var inner := ScrollContainer.new()
	inner.position = Vector2(8, 8)
	inner.size = Vector2(125, 100)
	inner.scale = Vector2(0.75, 0.75)
	inner.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_body.add_child(inner)
	var inner_body := Control.new()
	inner_body.custom_minimum_size.y = 230
	inner.add_child(inner_body)
	await frames(4)
	var point: Vector2 = inner.get_global_transform_with_canvas() * Vector2(25, 65)
	var bar: VScrollBar = inner.get_v_scroll_bar()
	var on_bar: Vector2 = bar.get_global_transform_with_canvas() * (bar.size * 0.5)
	check(m.hud._scroll_under(point) == inner, "UI-01 nested viewport selects the inner scrolling content")
	check(m.hud._scroll_under(on_bar) == null, "UI-01 nested scrollbar cannot start an outer content drag")
	var press := InputEventScreenTouch.new()
	press.pressed = true
	press.position = point
	m.hud._input(press)
	var drag := InputEventScreenDrag.new()
	drag.position = point - Vector2(0, 30)
	m.hud._input(drag)
	check(inner.scroll_vertical == 40 and outer.scroll_vertical == 0, "UI-01 content drag uses local delta under scale")
	press.pressed = false
	m.hud._input(press)
	outer.queue_free()
	await frames(2)


func _run() -> void:
	if not OS.get_user_data_dir().contains("df_ui_qa"):
		push_error("Use an isolated df_ui_qa profile")
		quit(2)
		return
	seed(91234)
	root.size = Vector2i(1600, 900)
	var m := ProbeMain.new()
	root.add_child(m)
	current_scene = m
	for i in 120:
		await process_frame
		if m.loading != null and not m.loading.visible and m.world.data != null:
			break
	m.set_process(false)
	m.world.set_process(false)
	m.net.set_process(false)
	root.size = Vector2i(960, 540)
	root.content_scale_factor = 1.3
	await frames(6)
	m.menus.show_settings_sub("ui")
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 1200
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.menus._inner.add_child(spacer)
	await create_timer(0.35).timeout
	await frames(3)
	var sc: ScrollContainer = m.menus._scroll
	var bar: VScrollBar = sc.get_v_scroll_bar()
	check(bar.visible and bar.max_value - bar.page > 200.0, "UI-01 fixture has a scrollable menu")
	var up_icon: Texture2D = bar.get_theme_icon("decrement")
	var track: StyleBox = bar.get_theme_stylebox("scroll")
	var thumb: StyleBox = bar.get_theme_stylebox("grabber")
	var thumb_start: float = up_icon.get_height() + track.get_margin(SIDE_TOP)
	var target: Vector2 = bar.get_global_transform_with_canvas() * Vector2(bar.size.x * 0.5, thumb_start + thumb.get_minimum_size().y * 0.5 + 1.0)
	mouse_motion(target, Vector2.ZERO)
	mouse_button(target, MOUSE_BUTTON_LEFT, true)
	check(not m.menus._sd_on, "UI-01 native scrollbar owns a real mouse press")
	var drag: Vector2 = Vector2(0, 30)
	mouse_motion(target + drag, drag, MOUSE_BUTTON_MASK_LEFT)
	var dragged: int = sc.scroll_vertical
	check(dragged > 0, "UI-01 thumb moves down when dragged down")
	mouse_motion(target + Vector2(0, bar.size.y + 80.0), Vector2(0, bar.size.y + 50.0), MOUSE_BUTTON_MASK_LEFT)
	check(absf(bar.value - (bar.max_value - bar.page)) <= 1.0, "UI-01 thumb reaches the effective maximum")
	mouse_motion(target - Vector2(0, 80), Vector2(0, -bar.size.y - 160.0), MOUSE_BUTTON_MASK_LEFT)
	check(absf(bar.value - bar.min_value) <= 1.0, "UI-01 thumb returns to the minimum")
	mouse_button(target - Vector2(0, 80), MOUSE_BUTTON_LEFT, false)
	var wheel_target: Vector2 = bar.get_global_transform_with_canvas() * (bar.size * 0.5)
	mouse_motion(wheel_target, Vector2.ZERO)
	mouse_button(wheel_target, MOUSE_BUTTON_WHEEL_DOWN, true)
	await create_timer(0.22).timeout
	var after_wheel: int = sc.scroll_vertical
	check(after_wheel > 0 and not m.menus._sd_on, "UI-01 wheel reaches native scrollbar")
	mouse_button(wheel_target, MOUSE_BUTTON_WHEEL_UP, true)
	await create_timer(0.22).timeout
	check(sc.scroll_vertical < after_wheel, "UI-01 wheel up reverses the scroll")
	samples["scroll"] = {"dragged": dragged, "wheel_down": after_wheel, "wheel_up": sc.scroll_vertical, "effective_max": bar.max_value - bar.page}
	root.size = Vector2i(1600, 900)
	root.content_scale_factor = 0.7
	await frames(6)
	m.menus.show_main()
	m.menus._show_whats_new()
	await create_timer(0.55).timeout
	var wn: ScrollContainer = m.menus._wn_scroll
	var footer: Button = wn.get_parent().get_child(1)
	for setting: Array in [[0.7, Vector2i(1600,900)], [1.0, Vector2i(1280,720)], [1.3, Vector2i(960,540)]]:
		root.size = setting[1]
		root.content_scale_factor = setting[0]
		await frames(6)
		var viewport: Rect2 = root.get_visible_rect()
		var footer_rect: Rect2 = footer.get_global_rect()
		var key := str(setting[0])
		samples["layout_" + key] = {"viewport":str(viewport), "footer":str(footer_rect)}
		check(viewport.grow(1.0).encloses(footer_rect), "UI-02 What's New footer fits at " + key)
	m.menus.close()
	m.hud.visible = true
	await nested_scroll(m)
	var long_tip := "Будівництво неможливе біля чужого кордону. ".repeat(6)
	m.hud.set_ghost_tip(long_tip, Color.WHITE, root.get_visible_rect().end - Vector2(5, 5))
	await frames(3)
	var tip_rect: Rect2 = m.hud.ghost_tip.get_global_rect()
	samples["ghost_tip"] = str(tip_rect)
	check(root.get_visible_rect().grow(1.0).encloses(tip_rect), "UI-02 long ghost tooltip fits in viewport")
	m.hud.set_ghost_tip("", Color.WHITE, Vector2.ZERO)
	m.in_menu = false
	var settings := WorldSettings.new()
	settings.size = 512
	settings.world_seed = 20261016
	await m.start_world(settings)
	m.world.set_process(false)
	GameConfig.confirm_actions = true
	var points: Array[Vector2i] = []
	for y in range(65, 448, 17):
		for x in range(65, 448, 17):
			var cell := Vector2i(x,y)
			if m.world.can_found_city(cell, City.Kind.CAPITAL, true).ok:
				points.append(cell)
				if points.size() == 2:
					break
		if points.size() == 2:
			break
	check(points.size() == 2 and m.world.player == null, "UI-03 new SP world has valid sites and no player yet")
	var before: String = NetHash.of(m.world)
	for cell: Vector2i in points:
		m.cam.position = (Vector2(cell) + Vector2(0.5,0.5)) * GameWorld.CELL
		var click: Vector2 = m.cam.world_to_screen(m.cam.position)
		m._tap(click)
		m.reticles.clear()
		m._draw_ghost()
		samples["capital_" + str(cell)] = {"pending":str(m._pend.get("wp")), "reticles":str(m.reticles)}
		check(m.reticles.size() == 1 and m.reticles[0] == m._pend.get("wp"), "UI-03 pending capital renders at selected point")
		check(m.world.player == null and NetHash.of(m.world) == before, "UI-03 selection does not mutate authoritative state")
	m._pend_cancel()
	m.reticles.clear()
	m._draw_ghost()
	check(m._pend.is_empty() and m.reticles.is_empty(), "UI-03 cancel clears selected marker")
	var result := {"checks": checks, "passed": failures.is_empty(), "failures": failures, "samples": samples}
	if opts.has("out"):
		FileAccess.open(opts["out"], FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("UI_QA ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)
