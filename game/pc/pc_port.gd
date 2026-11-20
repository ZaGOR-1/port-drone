extends Node
## PC port (autoload "PcPort"): a landscape desktop window, fullscreen, UI scale, a few desktop keys.
## Settings live in user://pc_port.cfg (separate from the game's own prefs).

signal scale_changed(f: float)

const CFG_PATH: String = "user://pc_port.cfg"
const SCALES: Array = [0.7, 0.8, 0.9, 1.0, 1.15, 1.3]
const SCALE_NAMES: Array = ["70%", "80%", "90%", "100%", "115%", "130%"]
const DEFAULT_SCALE_I: int = 2
const MIN_WIN: Vector2i = Vector2i(960, 540)
const TIP_DELAYS: Array = [0.2, 0.45, 0.9]
const TIP_DELAY_NAMES: Array = ["0.2 С", "0.45 С", "0.9 С"]
const CAM_SPEEDS: Array = [0.7, 1.0, 1.45]
const CAM_SPEED_NAMES: Array = ["МЕДЛЕННО", "НОРМА", "БЫСТРО"]

var scale_i: int = DEFAULT_SCALE_I
var fullscreen: bool = false
var hover_tips: bool = true
var tip_delay_i: int = 1
var show_hotkeys: bool = true
var cam_speed_i: int = 1
var edge_pan: bool = false
var wheel_invert: bool = false
var _win_rect: Rect2i = Rect2i()


static func desktop() -> bool:
	return OS.get_name() in ["Windows", "Linux", "macOS", "FreeBSD", "NetBSD", "OpenBSD", "BSD"]


## Landscape viewport (the HUD lays its keys out in one row, sheets keep a phone width).
static func wide() -> bool:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		return false
	var s: Vector2 = tree.root.get_visible_rect().size
	return s.x > s.y * 1.15


## A bottom sheet's width: the phone's full width, or a roomy adaptive column on a wide screen.
static func sheet_w(vw: float) -> float:
	if not wide() or vw < 760.0:
		return vw
	return roundf(clampf(vw * 0.56, 480.0, 860.0))


static func win_w(vw: float) -> float:
	if not wide() or vw < 760.0:
		return minf(344.0, vw - 12.0)
	return roundf(clampf(vw * 0.44, 420.0, 680.0))


static func tip_w(vw: float) -> float:
	if not wide() or vw < 760.0:
		return vw - 20.0
	return roundf(clampf(vw * 0.42, 360.0, 560.0))


static func top_msg_w(vw: float) -> float:
	if not wide() or vw < 760.0:
		return 290.0
	return roundf(clampf(vw * 0.42, 320.0, 560.0))


static func sheet_vp(v: Vector2) -> Vector2:
	return Vector2(sheet_w(v.x), v.y)


static func sheet_x(vw: float) -> float:
	return roundf((vw - sheet_w(vw)) * 0.5)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load()
	if not desktop() or DisplayServer.get_name() == "headless":
		return
	var win: Window = get_window()
	win.min_size = MIN_WIN
	_apply_scale()
	if fullscreen:
		set_fullscreen.call_deferred(true)
	else:
		_place_window.call_deferred()


func _place_window() -> void:
	var win: Window = get_window()
	if win.mode != Window.MODE_WINDOWED:
		return
	var scr: int = DisplayServer.window_get_current_screen()
	var usable: Rect2i = DisplayServer.screen_get_usable_rect(scr)
	if _win_rect.size.x >= MIN_WIN.x and _win_rect.size.y >= MIN_WIN.y and usable.encloses(_win_rect):
		win.size = _win_rect.size
		win.position = _win_rect.position
		return
	# 16:9, about 85% of the usable screen.
	var h: int = int(usable.size.y * 0.85)
	var w: int = int(h * 16.0 / 9.0)
	if w > int(usable.size.x * 0.92):
		w = int(usable.size.x * 0.92)
		h = int(w * 9.0 / 16.0)
	var sz: Vector2i = Vector2i(maxi(w, MIN_WIN.x), maxi(h, MIN_WIN.y))
	win.size = sz
	win.position = usable.position + (usable.size - sz) / 2


func set_fullscreen(on: bool) -> void:
	var win: Window = get_window()
	if on:
		if win.mode == Window.MODE_WINDOWED:
			_win_rect = Rect2i(win.position, win.size)
		win.mode = Window.MODE_FULLSCREEN
	else:
		win.mode = Window.MODE_WINDOWED
		_place_window.call_deferred()
	fullscreen = on
	_save()


func set_scale_i(i: int) -> void:
	scale_i = clampi(i, 0, SCALES.size() - 1)
	_apply_scale()
	_save()


func tip_delay() -> float:
	return float(TIP_DELAYS[clampi(tip_delay_i, 0, TIP_DELAYS.size() - 1)])


func cam_speed_mul() -> float:
	return float(CAM_SPEEDS[clampi(cam_speed_i, 0, CAM_SPEEDS.size() - 1)])


func set_hover_tips(on: bool) -> void:
	hover_tips = on
	_save()


func set_tip_delay_i(i: int) -> void:
	tip_delay_i = clampi(i, 0, TIP_DELAYS.size() - 1)
	_save()


func set_show_hotkeys(on: bool) -> void:
	show_hotkeys = on
	_save()


func set_cam_speed_i(i: int) -> void:
	cam_speed_i = clampi(i, 0, CAM_SPEEDS.size() - 1)
	_save()


func set_edge_pan(on: bool) -> void:
	edge_pan = on
	_save()


func set_wheel_invert(on: bool) -> void:
	wheel_invert = on
	_save()


func _apply_scale() -> void:
	scale_i = clampi(scale_i, 0, SCALES.size() - 1)
	var f: float = float(SCALES[scale_i])
	var win: Window = get_window() if is_inside_tree() else null
	if win != null:
		win.content_scale_factor = f
	var tree: SceneTree = get_tree() if is_inside_tree() else (Engine.get_main_loop() as SceneTree)
	var cam: Camera2D = tree.root.get_camera_2d() if tree != null and tree.root != null else null
	if tree != null and tree.root != null and win == null:
		tree.root.content_scale_factor = f
	MapCamera.set_ui_k(f, cam)
	scale_changed.emit(f)


func _input(event: InputEvent) -> void:
	if not desktop():
		return
	var k: InputEventKey = event as InputEventKey
	if k != null and k.pressed and not k.echo:
		if k.keycode == KEY_F11 or (k.keycode == KEY_ENTER and k.alt_pressed):
			set_fullscreen(get_window().mode == Window.MODE_WINDOWED)
			get_viewport().set_input_as_handled()
			return
		if k.ctrl_pressed and (k.keycode == KEY_EQUAL or k.keycode == KEY_PLUS or k.keycode == KEY_KP_ADD):
			set_scale_i(scale_i + 1)
			get_viewport().set_input_as_handled()
			return
		if k.ctrl_pressed and (k.keycode == KEY_MINUS or k.keycode == KEY_KP_SUBTRACT):
			set_scale_i(scale_i - 1)
			get_viewport().set_input_as_handled()
			return
		if k.ctrl_pressed and (k.keycode == KEY_0 or k.keycode == KEY_KP_0):
			set_scale_i(DEFAULT_SCALE_I)
			get_viewport().set_input_as_handled()
			return


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and desktop() and is_inside_tree():
		var win: Window = get_window()
		if win.mode == Window.MODE_WINDOWED:
			_win_rect = Rect2i(win.position, win.size)
		_save()


func _load() -> void:
	var c: ConfigFile = ConfigFile.new()
	if c.load(CFG_PATH) != OK:
		return
	scale_i = clampi(int(c.get_value("pc", "scale_i", DEFAULT_SCALE_I)), 0, SCALES.size() - 1)
	fullscreen = bool(c.get_value("pc", "fullscreen", false))
	hover_tips = bool(c.get_value("pc", "hover_tips", true))
	tip_delay_i = clampi(int(c.get_value("pc", "tip_delay_i", 1)), 0, TIP_DELAYS.size() - 1)
	show_hotkeys = bool(c.get_value("pc", "show_hotkeys", true))
	cam_speed_i = clampi(int(c.get_value("pc", "cam_speed_i", 1)), 0, CAM_SPEEDS.size() - 1)
	edge_pan = bool(c.get_value("pc", "edge_pan", false))
	wheel_invert = bool(c.get_value("pc", "wheel_invert", false))
	var r: Variant = c.get_value("pc", "window", Rect2i())
	if r is Rect2i:
		_win_rect = r


func _save() -> void:
	var c: ConfigFile = ConfigFile.new()
	c.set_value("pc", "scale_i", scale_i)
	c.set_value("pc", "fullscreen", fullscreen)
	c.set_value("pc", "hover_tips", hover_tips)
	c.set_value("pc", "tip_delay_i", tip_delay_i)
	c.set_value("pc", "show_hotkeys", show_hotkeys)
	c.set_value("pc", "cam_speed_i", cam_speed_i)
	c.set_value("pc", "edge_pan", edge_pan)
	c.set_value("pc", "wheel_invert", wheel_invert)
	c.set_value("pc", "window", _win_rect)
	c.save(CFG_PATH)
