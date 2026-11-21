extends Control

const ChronicleS = preload("res://game/chronicle.gd")
const _PcPortC = preload("res://pc/pc_port.gd")

var menus: Menus
var data: Dictionary = {}
var frames: Array = []
var events: Array = []
var meta: Dictionary = {}
var countries: Dictionary = {}

var playing: bool = false
var speed_i: int = 1
const SPEEDS: Array = [1.0, 2.0, 4.0, 8.0]
var cur_idx: float = 0.0
var cur_time: float = 0.0
var _min_t: float = 0.0
var _max_t: float = 0.0
var filter_cid: int = 0
var filter_cat: int = 0
var _return_to: String = ""
var _closed: bool = false
var _country_cols: Dictionary = {}
var _land_tint: Dictionary = {}
var _water_tint: Dictionary = {}

var cam_center := Vector2(0.5, 0.5)
var cam_zoom: float = 1.0
var _dragging: bool = false
var _drag_moved: bool = false
var _drag_last := Vector2.ZERO
var _sel_fac: Dictionary = {}

var _canvas: Control
var _fp: PanelContainer
var _wide_on: bool = false
var _time_lbl: Label
var _scrubber: HSlider
var _play_btn: Button
var _spd_btn: Button
var _info_lbl: Label
var _ev_scroll: ScrollContainer
var _ev_list: Control
var _ev_filtered: Array = []
var _ev_pool: Array = []
var _ev_sb_norm: StyleBox = null
var _ev_sb_hov: StyleBox = null
var _cat_row: HBoxContainer
var _filter_row: HBoxContainer
var _syncing_slider: bool = false
var _map_img: Image = null
var _map_tex: ImageTexture = null
var _map_fi: int = -1
var _map_gn: int = -1
const EV_ROW_H: float = 31.0


static func open_replay(m: Menus, rec: Dictionary, return_to: String = "") -> void:
	if m == null or m.root == null:
		return
	m.close()
	m.current = "chronicle_view"
	var bg := Control.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	m.root.add_child(bg)
	m.screen = bg
	var viewer: Control = (load("res://ui/chronicle_viewer.gd") as GDScript).new()
	viewer.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.add_child(viewer)
	viewer.call("_setup", m, rec, return_to)


static func show_browser(m: Menus) -> void:
	var vb: VBoxContainer = m._screen("Хроники партий", 0.55)
	m.current = "chronicles"
	var recs: Array = ChronicleS.list_records()
	if recs.is_empty():
		var empty_l: Label = UiKit.lbl("Завершённые матчи автоматически сохраняются сюда для пересмотра.", 11, UiKit.MUTED, 1)
		empty_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vb.add_child(empty_l)
	else:
		for rec: Dictionary in recs:
			var mt: Dictionary = rec.get("meta", {})
			var p: = PanelContainer.new()
			p.add_theme_stylebox_override("panel", UiKit.sb("wb_card", 8, 6))
			vb.add_child(p)
			var row: = HBoxContainer.new()
			row.add_theme_constant_override("separation", 6)
			p.add_child(row)
			row.add_child(UiKit.icon_rect("icon_chronicle", 24.0))
			var col: = VBoxContainer.new()
			col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			col.add_theme_constant_override("separation", 1)
			row.add_child(col)
			var win_nm: String = String(mt.get("winner_name", ""))
			var title_t: String = (Loc.t("ПОБЕДА: %s") % Loc.name(win_nm).to_upper()) if win_nm != "" else Loc.t("ХРОНИКА ПАРТИИ")
			var tl: Label = UiKit.lbl(title_t, 12, UiKit.TITLE, 2, 3)
			tl.clip_text = true
			col.add_child(tl)
			var dur: int = roundi(float(mt.get("duration", 0.0)))
			var sub_t: String = "%s · %d:%02d · %d кадр." % [String(mt.get("date", "")), dur / 60, dur % 60, int(rec.get("n_frames", 0))]
			col.add_child(UiKit.lbl(sub_t, 9, UiKit.MUTED, 1, 1))
			var rpath: String = String(rec.get("path", ""))
			var watch_b: Button = UiKit.big("СМОТРЕТЬ", "green", "", 40.0, 10)
			watch_b.custom_minimum_size.x = 84
			watch_b.pressed.connect(func() -> void:
				var full: Dictionary = ChronicleS.load_record(rpath, false)
				if not full.is_empty():
					open_replay(m, full, "browser"))
			row.add_child(watch_b)
			var del_b: Button = UiKit.big("×", "red", "", 40.0, 12)
			del_b.custom_minimum_size.x = 36
			del_b.pressed.connect(func() -> void:
				ChronicleS.delete_record(rpath)
				show_browser(m))
			row.add_child(del_b)
	var bot: HBoxContainer = m._bottom_row()
	var par: Node = m.get_parent()
	var in_main: bool = par == null or par.get("in_menu") != false
	var bk: Button = m._button(bot, "НАЗАД", "stone", "main" if in_main else "pause")
	bk.size_flags_horizontal = Control.SIZE_EXPAND_FILL


static func _parse_html_color(col_s: String, fallback: Color) -> Color:
	var s: String = col_s.strip_edges()
	if s.begins_with("#"):
		s = s.substr(1)
	if s.is_valid_html_color():
		return Color.html("#" + s)
	return fallback


func _color_of(cid: int, fallback: Color = Color.WHITE) -> Color:
	if _country_cols.has(cid):
		return _country_cols[cid] as Color
	return fallback


func _setup(m: Menus, rec: Dictionary, return_to: String = "") -> void:
	menus = m
	_return_to = return_to
	_closed = false
	data = rec
	frames = []
	var f_raw: Variant = rec.get("frames", [])
	if f_raw is Array:
		for f_item: Variant in (f_raw as Array):
			if f_item is Dictionary:
				frames.append(f_item)
	events = []
	var e_raw: Variant = rec.get("events", [])
	if e_raw is Array:
		for e_item: Variant in (e_raw as Array):
			if e_item is Dictionary:
				events.append(e_item)
	var m_raw: Variant = rec.get("meta", {})
	meta = (m_raw as Dictionary) if m_raw is Dictionary else {}
	countries.clear()
	_country_cols.clear()
	_land_tint.clear()
	_water_tint.clear()
	var c_raw: Variant = meta.get("countries", [])
	if c_raw is Array:
		for c: Variant in (c_raw as Array):
			if c is Dictionary:
				var d: Dictionary = c
				var cid: int = int(d.get("id", 0))
				countries[cid] = d
				var cc: Color = _parse_html_color(String(d.get("color", "ffffff")), Color.WHITE)
				_country_cols[cid] = cc
				_land_tint[cid] = Color(cc.r, cc.g, cc.b, 0.78)
				_water_tint[cid] = Color(cc.r, cc.g, cc.b, 0.45)
	_min_t = float((frames[0] as Dictionary).get("t", 0.0)) if not frames.is_empty() else 0.0
	_max_t = maxf(_min_t, float((frames.back() as Dictionary).get("t", _min_t))) if not frames.is_empty() else 0.0
	cur_time = _min_t
	cur_idx = 0.0
	_map_img = null
	_map_tex = null
	_map_fi = -1
	_map_gn = -1
	resized.connect(_update_layout)
	_build_ui()


func close_viewer() -> void:
	if _closed or menus == null or not is_instance_valid(menus):
		return
	_closed = true
	playing = false
	set_process(false)
	var par: Node = menus.get_parent()
	var in_main: bool = par == null or par.get("in_menu") != false
	var sess: Variant = menus.gw.session if menus.gw != null else null
	var can_show_end: bool = menus.gw != null and not menus.gw.countries.is_empty() and sess != null
	if _return_to == "end" and can_show_end:
		menus.show_end(int(sess.winner))
	elif _return_to == "browser":
		show_browser(menus)
	elif not in_main and can_show_end and sess.ended:
		menus.show_end(int(sess.winner))
	elif not in_main and menus.gw != null and not menus.gw.countries.is_empty():
		menus.show_pause()
	else:
		show_browser(menus)


func _input(event: InputEvent) -> void:
	if _closed or not is_inside_tree() or not visible:
		return
	if event is InputEventKey:
		var ek := event as InputEventKey
		if ek.pressed and not ek.echo:
			if ek.keycode == KEY_ESCAPE or ek.keycode == KEY_BACK:
				get_viewport().set_input_as_handled()
				close_viewer()
			elif ek.keycode == KEY_SPACE:
				get_viewport().set_input_as_handled()
				_toggle_play()
			elif ek.keycode == KEY_LEFT or ek.keycode == KEY_RIGHT:
				var step_t: float = 60.0 if ek.shift_pressed else 15.0
				cur_time = clampf(cur_time + (-step_t if ek.keycode == KEY_LEFT else step_t), _min_t, _max_t)
				cur_idx = float(_frame_index_for_time(cur_time))
				_sync_time_ui()
				if _canvas != null and is_instance_valid(_canvas):
					_canvas.queue_redraw()
				get_viewport().set_input_as_handled()
			elif ek.keycode == KEY_HOME or ek.keycode == KEY_END:
				cur_time = _min_t if ek.keycode == KEY_HOME else _max_t
				cur_idx = float(_frame_index_for_time(cur_time))
				_sync_time_ui()
				if _canvas != null and is_instance_valid(_canvas):
					_canvas.queue_redraw()
				get_viewport().set_input_as_handled()
			elif ek.keycode >= KEY_1 and ek.keycode <= KEY_4:
				speed_i = clampi(ek.keycode - KEY_1, 0, SPEEDS.size() - 1)
				if _spd_btn != null and is_instance_valid(_spd_btn):
					_spd_btn.text = "x%d" % int(SPEEDS[speed_i])
				get_viewport().set_input_as_handled()


func _frame_index_for_time(t: float) -> int:
	if frames.is_empty():
		return 0
	if frames.size() == 1 or t <= _min_t:
		return 0
	if t >= _max_t - 0.02:
		return frames.size() - 1
	var lo: int = 0
	var hi: int = frames.size() - 1
	while lo < hi:
		var mid: int = (lo + hi + 1) >> 1
		var mt: float = float((frames[mid] as Dictionary).get("t", 0.0))
		if mt <= t + 0.001:
			lo = mid
		else:
			hi = mid - 1
	return lo


func _toggle_play() -> void:
	if frames.size() <= 1 or _max_t <= _min_t:
		playing = false
		_sync_play_icon()
		return
	playing = not playing
	if playing and cur_time >= _max_t - 0.05:
		cur_time = _min_t
		cur_idx = 0.0
		_sync_time_ui()
		if _canvas != null and is_instance_valid(_canvas):
			_canvas.queue_redraw()
	_sync_play_icon()


func _update_layout() -> void:
	if _fp != null and is_instance_valid(_fp) and _wide_on and is_inside_tree():
		_fp.custom_minimum_size.x = clampf(get_viewport_rect().size.x * 0.28, 280.0, 400.0)


func _process(delta: float) -> void:
	if playing:
		if frames.size() <= 1 or _max_t <= _min_t:
			playing = false
			_sync_play_icon()
			return
		cur_time += minf(delta, 0.1) * float(SPEEDS[speed_i]) * 3.0
		if cur_time >= _max_t:
			cur_time = _max_t
			playing = false
			_sync_play_icon()
		cur_idx = float(_frame_index_for_time(cur_time))
		_sync_time_ui()
		if _canvas != null and is_instance_valid(_canvas):
			_canvas.queue_redraw()


func _build_ui() -> void:
	var root_box := VBoxContainer.new()
	root_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_box.add_theme_constant_override("separation", 4)
	add_child(root_box)

	# Header
	var top := PanelContainer.new()
	top.add_theme_stylebox_override("panel", UiKit.sb("wb_topbar", 8, 5))
	root_box.add_child(top)
	var hb := HBoxContainer.new()
	hb.add_theme_constant_override("separation", 6)
	top.add_child(hb)
	hb.add_child(UiKit.icon_rect("icon_chronicle", 20.0))
	var title := UiKit.lbl("ХРОНИКА ПАРТИИ", 13, UiKit.TITLE, 2, 3)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(title)
	_time_lbl = UiKit.lbl("0:00 / 0:00", 11, UiKit.TEXT, 2, 2)
	hb.add_child(_time_lbl)
	var back := UiKit.big("ЗАКРЫТЬ", "stone", "", 36.0, 10)
	back.custom_minimum_size.x = 76
	back.focus_mode = Control.FOCUS_NONE
	back.pressed.connect(close_viewer)
	hb.add_child(back)

	# Main split: Replay Canvas + Event Feed (side-by-side on wide PC screens, stacked on mobile)
	_wide_on = _PcPortC.wide()
	var mid: BoxContainer = HBoxContainer.new() if _wide_on else VBoxContainer.new()
	mid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override("separation", 6 if _wide_on else 4)
	root_box.add_child(mid)

	var cframe := PanelContainer.new()
	cframe.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cframe.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cframe.size_flags_stretch_ratio = 2.4
	cframe.custom_minimum_size = Vector2(200, 180)
	cframe.clip_contents = true
	cframe.add_theme_stylebox_override("panel", UiKit.sb("wb_panel_dark", 4, 4))
	mid.add_child(cframe)

	_canvas = Control.new()
	_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_canvas.mouse_filter = Control.MOUSE_FILTER_STOP
	_canvas.draw.connect(_draw_canvas)
	_canvas.gui_input.connect(_on_canvas_input)
	cframe.add_child(_canvas)

	# Building tap inspection banner + controls
	var info_p := PanelContainer.new()
	info_p.add_theme_stylebox_override("panel", UiKit.sb("wb_pill", 8, 4))
	root_box.add_child(info_p)
	var ib := HBoxContainer.new()
	ib.add_theme_constant_override("separation", 6)
	info_p.add_child(ib)
	_info_lbl = UiKit.lbl("Тап по зданию на карте покажет владельца и время постройки · Щипок/колёсико — масштаб", 10, UiKit.MUTED, 1)
	_info_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_info_lbl.clip_text = true
	ib.add_child(_info_lbl)
	var z_reset := UiKit.big("100%", "stone", "", 30.0, 9)
	z_reset.custom_minimum_size.x = 46
	z_reset.focus_mode = Control.FOCUS_NONE
	z_reset.pressed.connect(func() -> void:
		cam_zoom = 1.0
		cam_center = Vector2(0.5, 0.5)
		if _canvas != null and is_instance_valid(_canvas):
			_canvas.queue_redraw())
	ib.add_child(z_reset)

	# Timeline transport row
	var tr := PanelContainer.new()
	tr.add_theme_stylebox_override("panel", UiKit.sb("wb_panel", 8, 5))
	root_box.add_child(tr)
	var thb := HBoxContainer.new()
	thb.add_theme_constant_override("separation", 6)
	tr.add_child(thb)
	_play_btn = UiKit.slot("icon_replay_play", false, 36.0)
	_play_btn.focus_mode = Control.FOCUS_NONE
	_play_btn.pressed.connect(_toggle_play)
	thb.add_child(_play_btn)
	_spd_btn = UiKit.big("x2", "gold", "", 36.0, 11)
	_spd_btn.custom_minimum_size.x = 44
	_spd_btn.focus_mode = Control.FOCUS_NONE
	_spd_btn.pressed.connect(func() -> void:
		speed_i = (speed_i + 1) % SPEEDS.size()
		_spd_btn.text = "x%d" % int(SPEEDS[speed_i]))
	thb.add_child(_spd_btn)
	_scrubber = HSlider.new()
	_scrubber.focus_mode = Control.FOCUS_NONE
	_scrubber.min_value = 0.0
	_scrubber.max_value = maxf(1.0, _max_t - _min_t)
	_scrubber.step = 0.2 if _max_t > _min_t else 1.0
	_scrubber.editable = frames.size() > 1 and _max_t > _min_t
	_scrubber.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scrubber.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_scrubber.value_changed.connect(func(v: float) -> void:
		if _syncing_slider:
			return
		cur_time = clampf(_min_t + v, _min_t, _max_t)
		cur_idx = float(_frame_index_for_time(cur_time))
		_sync_time_ui()
		if _canvas != null and is_instance_valid(_canvas):
			_canvas.queue_redraw())
	thb.add_child(_scrubber)

	# Country Filter & Event Feed
	_fp = PanelContainer.new()
	_fp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_fp.size_flags_stretch_ratio = 1.0
	_update_layout()
	_fp.add_theme_stylebox_override("panel", UiKit.sb("wb_panel_dark", 6, 4))
	mid.add_child(_fp)
	var fvb := VBoxContainer.new()
	fvb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fvb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	fvb.add_theme_constant_override("separation", 4)
	_fp.add_child(fvb)
	_cat_row = HBoxContainer.new()
	_cat_row.add_theme_constant_override("separation", 4)
	fvb.add_child(_cat_row)
	var fsc := ScrollContainer.new()
	fsc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fsc.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	fsc.custom_minimum_size.y = 32
	fvb.add_child(fsc)
	_filter_row = HBoxContainer.new()
	_filter_row.add_theme_constant_override("separation", 4)
	fsc.add_child(_filter_row)
	_build_filter_chips()

	_ev_scroll = ScrollContainer.new()
	_ev_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_ev_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_ev_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	fvb.add_child(_ev_scroll)
	_ev_list = Control.new()
	_ev_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_ev_scroll.add_child(_ev_list)
	_ev_pool.clear()
	_ev_scroll.get_v_scroll_bar().value_changed.connect(func(_v: float) -> void: _render_visible_events())
	_ev_scroll.resized.connect(_render_visible_events)
	_rebuild_events()
	_sync_time_ui()


func _sync_play_icon() -> void:
	if _play_btn != null and is_instance_valid(_play_btn):
		var ic: TextureRect = UiKit.slot_icon(_play_btn)
		if ic != null:
			ic.texture = UiKit.tex("icon_replay_pause" if playing else "icon_replay_play")


func _sync_time_ui() -> void:
	var shown_t: float = cur_time if not frames.is_empty() else 0.0
	var max_t: float = _max_t if not frames.is_empty() else 0.0
	if _time_lbl != null and is_instance_valid(_time_lbl):
		_time_lbl.text = "%d:%02d / %d:%02d" % [int(shown_t) / 60, int(shown_t) % 60, int(max_t) / 60, int(max_t) % 60]
	if _scrubber != null and is_instance_valid(_scrubber):
		_syncing_slider = true
		_scrubber.value = clampf(shown_t - _min_t, 0.0, _scrubber.max_value)
		_syncing_slider = false


func _build_filter_chips() -> void:
	if _cat_row != null and is_instance_valid(_cat_row):
		for cc_n: Node in _cat_row.get_children():
			cc_n.queue_free()
		var cats: Array = [[0, Loc.t("ВСЕ")], [1, Loc.t("ВОЙНЫ И ЯО")], [2, Loc.t("СТРОЙКА")]]
		for cp: Array in cats:
			var ci: int = int(cp[0])
			var cb: Button = UiKit.big(String(cp[1]), "gold" if filter_cat == ci else "stone", "", 26.0, 9)
			cb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cb.focus_mode = Control.FOCUS_NONE
			cb.pressed.connect(func() -> void:
				filter_cat = ci
				_build_filter_chips()
				_rebuild_events())
			_cat_row.add_child(cb)
	if _filter_row == null or not is_instance_valid(_filter_row):
		return
	for ch: Node in _filter_row.get_children():
		ch.queue_free()
	var ids: Array = [0]
	for k: Variant in countries.keys():
		ids.append(int(k))
	ids.sort()
	for cid: int in ids:
		var cname: String = Loc.t("ВСЕ") if cid == 0 else ("   " + String((countries[cid] as Dictionary).get("name", "?")).left(10))
		var b: Button = UiKit.big(cname, "gold" if filter_cid == cid else "stone", "", 28.0, 9)
		b.focus_mode = Control.FOCUS_NONE
		if cid > 0:
			var sw_o: = ColorRect.new()
			sw_o.color = UiKit.OUTLINE
			sw_o.position = Vector2(5, 9)
			sw_o.size = Vector2(10, 10)
			sw_o.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var sw_i: = ColorRect.new()
			sw_i.color = _color_of(cid, Color.WHITE)
			sw_i.position = Vector2(1, 1)
			sw_i.size = Vector2(8, 8)
			sw_i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			sw_o.add_child(sw_i)
			b.add_child(sw_o)
		b.pressed.connect(func() -> void:
			filter_cid = cid
			_build_filter_chips()
			_rebuild_events())
		_filter_row.add_child(b)


func _rebuild_events() -> void:
	if _ev_list == null or not is_instance_valid(_ev_list):
		return
	_ev_filtered.clear()
	for ev: Dictionary in events:
		var ecid: int = int(ev.get("c", 0))
		if filter_cid != 0 and ecid != filter_cid:
			continue
		var ekind: String = String(ev.get("k", ""))
		if filter_cat == 1 and not (ekind in ["war", "nuke", "ultimatum", "city"]):
			continue
		if filter_cat == 2 and not (ekind in ["build", "land"]):
			continue
		_ev_filtered.append(ev)
	_ev_list.custom_minimum_size = Vector2(0.0, float(_ev_filtered.size()) * EV_ROW_H)
	if _ev_scroll != null and is_instance_valid(_ev_scroll):
		_ev_scroll.scroll_vertical = 0
	_render_visible_events()


func _ensure_ev_pool(count: int) -> void:
	if _ev_sb_norm == null:
		_ev_sb_norm = UiKit.sb("wb_slot", 4)
		_ev_sb_hov = UiKit.sb("wb_slot_active", 4)
	while _ev_pool.size() < count:
		var row_b := Button.new()
		row_b.focus_mode = Control.FOCUS_NONE
		row_b.custom_minimum_size.y = 28
		row_b.add_theme_stylebox_override("normal", _ev_sb_norm)
		row_b.add_theme_stylebox_override("hover", _ev_sb_hov)
		var hb := HBoxContainer.new()
		hb.set_anchors_preset(Control.PRESET_FULL_RECT)
		hb.offset_left = 6
		hb.offset_right = -6
		hb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hb.add_theme_constant_override("separation", 6)
		row_b.add_child(hb)
		var sw_bg := ColorRect.new()
		sw_bg.color = UiKit.OUTLINE
		sw_bg.custom_minimum_size = Vector2(10, 10)
		sw_bg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		sw_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var sw_in := ColorRect.new()
		sw_in.color = Color.WHITE
		sw_in.position = Vector2(1, 1)
		sw_in.size = Vector2(8, 8)
		sw_in.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sw_bg.add_child(sw_in)
		hb.add_child(sw_bg)
		var time_l: Label = UiKit.lbl("0:00", 9, Color("cfc6a8"), 1)
		hb.add_child(time_l)
		var text_l: Label = UiKit.lbl("", 10, UiKit.TEXT, 1)
		text_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text_l.clip_text = true
		hb.add_child(text_l)
		hb.add_child(UiKit.icon_rect("icon_locate", 14.0))
		var st := {"ev": {}}
		row_b.pressed.connect(func() -> void:
			var ev_d: Variant = st.get("ev")
			if ev_d is Dictionary and not (ev_d as Dictionary).is_empty():
				_jump_to_event(ev_d as Dictionary))
		_ev_list.add_child(row_b)
		_ev_pool.append({"btn": row_b, "sw_bg": sw_bg, "sw_in": sw_in, "time": time_l, "text": text_l, "st": st})


func _render_visible_events() -> void:
	if _ev_list == null or not is_instance_valid(_ev_list) or _ev_scroll == null or not is_instance_valid(_ev_scroll):
		return
	var vis_h: float = _ev_scroll.size.y if _ev_scroll.size.y > 4.0 else 360.0
	var sv: float = float(_ev_scroll.scroll_vertical)
	var first_i: int = clampi(int(floorf(sv / EV_ROW_H)), 0, maxi(0, _ev_filtered.size() - 1))
	var need: int = mini(_ev_filtered.size(), clampi(ceili(vis_h / EV_ROW_H) + 2, 12, 28))
	_ensure_ev_pool(need)
	var rw: float = maxf(140.0, _ev_scroll.size.x - 10.0)
	for k in _ev_pool.size():
		var slot: Dictionary = _ev_pool[k]
		var btn: Button = slot["btn"]
		var idx: int = first_i + k
		if idx >= _ev_filtered.size() or k >= need:
			btn.visible = false
			continue
		var ev: Dictionary = _ev_filtered[idx]
		var ecid: int = int(ev.get("c", 0))
		var et: float = float(ev.get("t", 0.0))
		btn.visible = true
		btn.position = Vector2(0.0, float(idx) * EV_ROW_H)
		btn.size = Vector2(rw, 28.0)
		var sw_bg: ColorRect = slot["sw_bg"]
		sw_bg.visible = ecid > 0
		if ecid > 0:
			(slot["sw_in"] as ColorRect).color = _color_of(ecid, Color.WHITE)
		var tl: Label = slot["time"]
		tl.text = "%d:%02d" % [int(et) / 60, int(et) % 60]
		tl.add_theme_color_override("font_color", _color_of(ecid, Color("cfc6a8")))
		(slot["text"] as Label).text = String(ev.get("text", ""))
		(slot["st"] as Dictionary)["ev"] = ev


func _jump_to_event(ev: Dictionary) -> void:
	if frames.is_empty():
		return
	var t_tgt: float = clampf(float(ev.get("t", _min_t)), _min_t, _max_t)
	cur_time = t_tgt
	cur_idx = float(_frame_index_for_time(cur_time))
	var mw: float = maxf(1.0, float(meta.get("w", 256)))
	var mh: float = maxf(1.0, float(meta.get("h", 256)))
	var ex: float = float(ev.get("x", 0))
	var ey: float = float(ev.get("y", 0))
	if ex > 0.0 or ey > 0.0:
		cam_center = Vector2(clampf(ex / mw, 0.05, 0.95), clampf(ey / mh, 0.05, 0.95))
		cam_zoom = maxf(cam_zoom, 2.0)
	_sync_time_ui()
	if _canvas != null and is_instance_valid(_canvas):
		_canvas.queue_redraw()


func _map_rect() -> Rect2:
	var sz: Vector2 = _canvas.size
	var mw: float = maxf(1.0, float(meta.get("w", 256)))
	var mh: float = maxf(1.0, float(meta.get("h", 256)))
	var aspect: float = mw / mh
	var base_h: float = minf(sz.y, sz.x / aspect) * cam_zoom
	var base_w: float = base_h * aspect
	var pos: Vector2 = sz * 0.5 - Vector2(cam_center.x * base_w, cam_center.y * base_h)
	return Rect2(pos, Vector2(base_w, base_h))


func _draw_canvas() -> void:
	if _canvas == null or not is_instance_valid(_canvas) or frames.is_empty():
		return
	if _canvas.size.x < 4.0 or _canvas.size.y < 4.0:
		return
	var fi: int = clampi(int(roundf(cur_idx)), 0, frames.size() - 1)
	var fr: Dictionary = frames[fi]
	var r: Rect2 = _map_rect()
	if r.size.x < 4.0 or r.size.y < 4.0:
		return
	var gn: int = maxi(1, int(meta.get("grid", 64)))
	if _map_tex == null or _map_fi != fi or _map_gn != gn:
		_map_fi = fi
		_map_gn = gn
		if _map_img == null or _map_img.get_width() != gn or _map_img.get_height() != gn:
			_map_img = Image.create(gn, gn, false, Image.FORMAT_RGBA8)
			_map_tex = null
		var wat_raw: Variant = meta.get("water", PackedByteArray())
		var wat: PackedByteArray = (wat_raw as PackedByteArray) if wat_raw is PackedByteArray else PackedByteArray()
		var own_raw: Variant = fr.get("own", PackedByteArray())
		var own: PackedByteArray = (own_raw as PackedByteArray) if own_raw is PackedByteArray else PackedByteArray()
		var land_col := Color("3b4c28")
		var water_col := Color("193664")
		for gy in gn:
			for gx in gn:
				var i: int = gy * gn + gx
				var is_w: bool = i < wat.size() and wat[i] != 0
				var colv: Color = water_col if is_w else land_col
				var cid: int = own[i] if i < own.size() else 0
				if cid > 0 and _country_cols.has(cid):
					colv = (_water_tint[cid] if is_w else _land_tint[cid]) as Color
				_map_img.set_pixel(gx, gy, colv)
		if _map_tex == null:
			_map_tex = ImageTexture.create_from_image(_map_img)
		else:
			_map_tex.update(_map_img)
	# 1. Base territory & ocean grid (cached pixel ImageTexture)
	_canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_canvas.draw_texture_rect(_map_tex, r, false)

	var mw: float = maxf(1.0, float(meta.get("w", 256)))
	var mh: float = maxf(1.0, float(meta.get("h", 256)))
	var sx: float = r.size.x / mw
	var sy: float = r.size.y / mh

	# 2. Cities
	var cities_raw: Variant = fr.get("cities", [])
	if cities_raw is Array:
		for ct_v: Variant in (cities_raw as Array):
			if not (ct_v is Array):
				continue
			var ct := ct_v as Array
			if ct.size() < 6:
				continue
			var cid2: int = int(ct[1])
			var px := Vector2(r.position.x + float(ct[2]) * sx, r.position.y + float(ct[3]) * sy)
			var cc2: Color = _color_of(cid2, Color.WHITE)
			_canvas.draw_circle(px, 3.0 if int(ct[5]) == 1 else 2.0, Color.BLACK)
			_canvas.draw_circle(px, 2.2 if int(ct[5]) == 1 else 1.4, cc2)

	# 3. Facilities (tappable!)
	var facs_raw: Variant = fr.get("facs", [])
	if facs_raw is Array:
		for fac_v: Variant in (facs_raw as Array):
			if not (fac_v is Array):
				continue
			var fac := fac_v as Array
			if fac.size() < 6:
				continue
			var cid3: int = int(fac[2])
			var px3 := Vector2(r.position.x + float(fac[3]) * sx, r.position.y + float(fac[4]) * sy)
			var cc3: Color = _color_of(cid3, Color("cccccc"))
			_canvas.draw_rect(Rect2(px3 - Vector2(2, 2), Vector2(4, 4)), cc3.lightened(0.25))
			if not _sel_fac.is_empty() and int(_sel_fac.get("id", -1)) == int(fac[0]):
				_canvas.draw_rect(Rect2(px3 - Vector2(4, 4), Vector2(8, 8)), UiKit.GOLD, false, 1.5)

	# 4. Units, Ships, Aircraft & Missiles
	var units_raw: Variant = fr.get("units", [])
	if units_raw is Array:
		for u_v: Variant in (units_raw as Array):
			if not (u_v is Array):
				continue
			var u := u_v as Array
			if u.size() < 4:
				continue
			var ux := Vector2(r.position.x + float(u[2]) * sx, r.position.y + float(u[3]) * sy)
			var uc: Color = _color_of(int(u[0]), Color.WHITE)
			_canvas.draw_rect(Rect2(ux - Vector2(1.5, 1.5), Vector2(3, 3)), uc.lightened(0.4))
	var ships_raw: Variant = fr.get("ships", [])
	if ships_raw is Array:
		for sh_v: Variant in (ships_raw as Array):
			if not (sh_v is Array):
				continue
			var sh := sh_v as Array
			if sh.size() < 4:
				continue
			var spx := Vector2(r.position.x + float(sh[2]) * sx, r.position.y + float(sh[3]) * sy)
			_canvas.draw_rect(Rect2(spx - Vector2(2, 1.5), Vector2(4, 3)), Color("9be3ff"))
	var airs_raw: Variant = fr.get("airs", [])
	if airs_raw is Array:
		for a_v: Variant in (airs_raw as Array):
			if not (a_v is Array):
				continue
			var a := a_v as Array
			if a.size() < 5:
				continue
			var apx := Vector2(r.position.x + float(a[2]) * sx, r.position.y + float(a[3]) * sy)
			_canvas.draw_circle(apx, 2.0 if int(a[4]) == 1 else 1.3, Color("ffe070"))
	var mis_raw: Variant = fr.get("mis", [])
	if mis_raw is Array:
		for ms_v: Variant in (mis_raw as Array):
			if not (ms_v is Array):
				continue
			var ms := ms_v as Array
			if ms.size() < 4:
				continue
			var mpx := Vector2(r.position.x + float(ms[1]) * sx, r.position.y + float(ms[2]) * sy)
			_canvas.draw_circle(mpx, 3.2 if int(ms[3]) == 1 else 2.0, Color("ff5040"))


func _on_canvas_input(ev: InputEvent) -> void:
	if _canvas == null or not is_instance_valid(_canvas):
		return
	if ev is InputEventMagnifyGesture:
		var mg := ev as InputEventMagnifyGesture
		cam_zoom = clampf(cam_zoom * mg.factor, 0.8, 6.0)
		_canvas.queue_redraw()
	elif ev is InputEventMouseButton:
		var mb := ev as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP and mb.pressed:
			cam_zoom = clampf(cam_zoom * 1.15, 0.8, 6.0)
			_canvas.queue_redraw()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN and mb.pressed:
			cam_zoom = clampf(cam_zoom / 1.15, 0.8, 6.0)
			_canvas.queue_redraw()
		elif mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_dragging = true
				_drag_moved = false
				_drag_last = mb.position
			else:
				if _dragging and not _drag_moved:
					_inspect_at(mb.position)
				_dragging = false
	elif ev is InputEventMouseMotion and _dragging:
		var mm := ev as InputEventMouseMotion
		if (mm.button_mask & MOUSE_BUTTON_MASK_LEFT) == 0:
			_dragging = false
			return
		if (mm.position - _drag_last).length() > 2.0:
			_drag_moved = true
		var r: Rect2 = _map_rect()
		cam_center.x = clampf(cam_center.x - mm.relative.x / maxf(1.0, r.size.x), 0.0, 1.0)
		cam_center.y = clampf(cam_center.y - mm.relative.y / maxf(1.0, r.size.y), 0.0, 1.0)
		_canvas.queue_redraw()
	elif ev is InputEventScreenDrag:
		var sd := ev as InputEventScreenDrag
		if sd.index == 0:
			_drag_moved = true
			var r2: Rect2 = _map_rect()
			cam_center.x = clampf(cam_center.x - sd.relative.x / maxf(1.0, r2.size.x), 0.0, 1.0)
			cam_center.y = clampf(cam_center.y - sd.relative.y / maxf(1.0, r2.size.y), 0.0, 1.0)
			_canvas.queue_redraw()


func _inspect_at(pos: Vector2) -> void:
	if frames.is_empty():
		return
	var fi: int = clampi(int(roundf(cur_idx)), 0, frames.size() - 1)
	var fr: Dictionary = frames[fi]
	var r: Rect2 = _map_rect()
	var mw: float = maxf(1.0, float(meta.get("w", 256)))
	var mh: float = maxf(1.0, float(meta.get("h", 256)))
	var sx: float = r.size.x / mw
	var sy: float = r.size.y / mh
	var best: Array = []
	var bd: float = 16.0 * 16.0
	var facs_raw: Variant = fr.get("facs", [])
	if facs_raw is Array:
		for fac_v: Variant in (facs_raw as Array):
			if not (fac_v is Array):
				continue
			var fac := fac_v as Array
			if fac.size() < 6:
				continue
			var fp := Vector2(r.position.x + float(fac[3]) * sx, r.position.y + float(fac[4]) * sy)
			var d2: float = fp.distance_squared_to(pos)
			if d2 < bd:
				bd = d2
				best = fac
	if not best.is_empty():
		_sel_fac = {"id": int(best[0])}
		var cid: int = int(best[2])
		var cname: String = String((countries.get(cid, {}) as Dictionary).get("name", "?"))
		var bt: float = float(best[5])
		var fname: String = Military.title_of(int(best[1]))
		if _info_lbl != null and is_instance_valid(_info_lbl):
			_info_lbl.text = "%s · %s · построено на %d:%02d" % [Loc.t(fname).to_upper(), Loc.name(cname), int(bt) / 60, int(bt) % 60]
		if _canvas != null and is_instance_valid(_canvas):
			_canvas.queue_redraw()
