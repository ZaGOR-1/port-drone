extends SceneTree

const PcPortScript = preload("res://pc/pc_port.gd")

var checks := 0
var failures: Array[String] = []


func _initialize() -> void:
	_run.call_deferred()


func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)


func scale_row(node: Node) -> HBoxContainer:
	if node is HBoxContainer and node.get_child_count() == 4:
		var value := node.get_child(2) as Label
		if value != null and value.text in PcPortScript.SCALE_NAMES:
			return node
	for child in node.get_children():
		var row := scale_row(child)
		if row != null:
			return row
	return null


func press_scale(key: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = key
	event.pressed = true
	event.ctrl_pressed = true
	root.push_input(event, true)


func finish() -> void:
	var result := {"checks": checks, "passed": failures.is_empty(), "failures": failures}
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="), FileAccess.WRITE).store_string(JSON.stringify(result, "\t"))
	print("SCALE_QA ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)


func _run() -> void:
	if not OS.get_user_data_dir().contains("df_scale_qa"):
		check(false, "fixture requires an isolated df_scale_qa profile")
		finish()
		return
	var pc := root.get_node("PcPort") as PcPortScript
	var main := preload("res://game/main.gd").new()
	root.add_child(main)
	current_scene = main
	for i in 120:
		await process_frame
		if main.loading != null and not main.loading.visible and main.world.data != null:
			break
	main.set_process(false)
	main.world.set_process(false)
	main.cam.set_process(false)
	main.net.set_process(false)
	root.size = Vector2i(1280, 720)
	for section: String in ["ui", "gfx"]:
		pc.set_scale_i(2)
		main.menus.show_settings_sub(section)
		var row := scale_row(main.menus._inner)
		check(row != null, section + " exposes desktop UI scale")
		if row == null:
			continue
		var left := row.get_child(1) as Button
		var value := row.get_child(2) as Label
		var right := row.get_child(3) as Button
		for target in [1, 0, 0]:
			left.pressed.emit()
			check(pc.scale_i == target and value.text == pc.SCALE_NAMES[target], section + " mouse minus -> " + pc.SCALE_NAMES[target])
		pc.set_scale_i(4)
		for target in [5, 5, 4]:
			(right if target == 5 else left).pressed.emit()
			check(pc.scale_i == target and value.text == pc.SCALE_NAMES[target], section + " reaches/stays/leaves maximum")
		pc.set_scale_i(0)
		right.pressed.emit()
		check(pc.scale_i == 1 and value.text == "80%", section + " mouse plus leaves minimum")
		press_scale(KEY_MINUS)
		press_scale(KEY_MINUS)
		check(pc.scale_i == 0 and value.text == "70%", section + " keyboard saturates at minimum and updates visible value")
		pc.set_scale_i(5)
		press_scale(KEY_EQUAL)
		check(pc.scale_i == 5 and value.text == "130%", section + " keyboard saturates at maximum and updates visible value")
		press_scale(KEY_MINUS)
		check(pc.scale_i == 4 and value.text == "115%", section + " keyboard leaves maximum")
		await process_frame
	var cfg := ConfigFile.new()
	check(cfg.load(pc.CFG_PATH) == OK and cfg.get_value("pc", "scale_i", -1) == 4, "selected index persisted")
	pc.scale_i = 0
	pc._load()
	check(pc.scale_i == 4 and is_equal_approx(root.content_scale_factor, 1.15), "saved index reloads and content scale matches")
	root.size = Vector2i(960, 540)
	await process_frame
	check(pc.scale_i == 4 and is_equal_approx(root.content_scale_factor, 1.15), "resize preserves UI scale")
	main.menus.close()
	await process_frame
	pc.set_scale_i(3)
	check(is_equal_approx(root.content_scale_factor, 1.0), "scale update after closing selectors")
	finish()
