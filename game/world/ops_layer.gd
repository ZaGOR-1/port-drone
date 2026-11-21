class_name OpsLayer
extends Node2D







const PK = preload("res://ui/ui24/path_kit.gd")
const MD = preload("res://ui/ui24/map_declutter.gd")
const AGroups = preload("res://game/army_groups.gd")
const AKit = preload("res://ui/ui24/arm_kit.gd")

var gw: GameWorld
var _t: float = 0.0


static var pennant_fids: Dictionary = {}


static func make(world: GameWorld) -> OpsLayer:
	var l: = OpsLayer.new()
	l.name = "Ops"
	l.gw = world
	l.z_index = 7
	return l


func _process(delta: float) -> void:
	_t += delta
	if gw == null or gw.ops == null:
		return
	var o: Operations = gw.ops
	if not o.list.is_empty() or not o.zones.is_empty() or not o.preview_arrow.is_empty() or not o.preview_order.is_empty() or _had:
		queue_redraw()
	_had = not o.list.is_empty() or not o.zones.is_empty() or not o.preview_arrow.is_empty() or not o.preview_order.is_empty()


var _had: bool = false


func _k() -> float:
	return 1.0 / maxf(0.05, gw.camera.zoom.x) if gw.camera != null else 1.0


var _pending_labels: Array = []
var _q_chevs: Array = []
var _q_polys: Array = []
var _t_pts: PackedVector2Array = PackedVector2Array()
var _t_cols: PackedColorArray = PackedColorArray()
var _t_idx: PackedInt32Array = PackedInt32Array()


func _push_poly(poly: PackedVector2Array, col: Color) -> void:
	var n: int = poly.size()
	if n < 3 or col.a <= 0.001:
		return
	var b: int = _t_pts.size()
	_t_pts.append_array(poly)
	for _i in n:
		_t_cols.append(col)
	for k2 in range(1, n - 1):
		_t_idx.append(b)
		_t_idx.append(b + k2)
		_t_idx.append(b + k2 + 1)


func _push_strip(pts: PackedVector2Array, w: float, col: Color, closed: bool = false) -> void:
	if pts.size() < 2 or w <= 0.0 or col.a <= 0.001:
		return
	var clean := PackedVector2Array()
	clean.append(pts[0])
	for i in range(1, pts.size()):
		if pts[i].distance_squared_to(clean[clean.size() - 1]) > 0.0001:
			clean.append(pts[i])
	if closed and clean.size() >= 3 and clean[clean.size() - 1].distance_squared_to(clean[0]) <= 0.0001:
		clean.remove_at(clean.size() - 1)
	var m: int = clean.size()
	if m < 2:
		return
	var hw: float = w * 0.5
	var b: int = _t_pts.size()
	for i in m:
		var has_prev: bool = i > 0 or closed
		var has_next: bool = i < m - 1 or closed
		var d0 := Vector2.ZERO
		var d1 := Vector2.ZERO
		if has_prev:
			var p_prev: Vector2 = clean[m - 1 if i == 0 else i - 1]
			d0 = (clean[i] - p_prev).normalized()
		if has_next:
			var p_next: Vector2 = clean[0 if i == m - 1 else i + 1]
			d1 = (p_next - clean[i]).normalized()
		var n: Vector2
		if not has_prev:
			n = Vector2(-d1.y, d1.x) * hw
		elif not has_next:
			n = Vector2(-d0.y, d0.x) * hw
		else:
			var avg: Vector2 = d0 + d1
			if avg.length_squared() < 0.001:
				n = Vector2(-d0.y, d0.x) * hw
			else:
				var dn: Vector2 = Vector2(-avg.y, avg.x).normalized()
				var dv: float = dn.dot(Vector2(-d0.y, d0.x))
				var miter: float = minf(1.8, 1.0 / maxf(0.25, dv))
				n = dn * (hw * miter)
		_t_pts.append(clean[i] - n)
		_t_pts.append(clean[i] + n)
		_t_cols.append(col)
		_t_cols.append(col)
	var segs: int = m if closed else m - 1
	for i2 in segs:
		var j2: int = (i2 + 1) % m
		var a0: int = b + i2 * 2
		var b0: int = b + j2 * 2
		_t_idx.append(a0); _t_idx.append(b0); _t_idx.append(a0 + 1)
		_t_idx.append(b0); _t_idx.append(b0 + 1); _t_idx.append(a0 + 1)


func _push_grad_seg(a: Vector2, b: Vector2, w: float, c0: Color, c1: Color) -> void:
	var d: Vector2 = b - a
	var ln: float = d.length()
	if ln < 0.001:
		return
	var n: Vector2 = Vector2(-d.y, d.x) * (w * 0.5 / ln)
	var base: int = _t_pts.size()
	_t_pts.append(a - n); _t_pts.append(b - n); _t_pts.append(b + n); _t_pts.append(a + n)
	_t_cols.append(c0); _t_cols.append(c1); _t_cols.append(c1); _t_cols.append(c0)
	_t_idx.append(base); _t_idx.append(base + 1); _t_idx.append(base + 2)
	_t_idx.append(base); _t_idx.append(base + 2); _t_idx.append(base + 3)


func _flush_flow_q(pts: PackedVector2Array, col: Color, t: float, k: float, stop: float) -> void:
	if pts.size() < 2:
		return
	var cum: PackedFloat32Array = PK.lengths(pts)
	var L: float = cum[cum.size() - 1]
	if L < 30.0 * k:
		return
	var gap: float = clampf(L * 0.5, 70.0 * k, 160.0 * k)
	var tail: float = 26.0 * k
	var hd: float = fmod(t * 55.0 * k, gap)
	var lc: Color = col.lightened(0.7)
	var wl: float = maxf(1.0 * k, 4.0 * k * 0.75)
	var c0 := Color(lc, 0.0)
	var c1 := Color(lc, 0.9 * 0.75)
	while hd < L - stop:
		var d0: float = maxf(0.0, hd - tail)
		if hd - d0 >= 1.0:
			_push_grad_seg(PK._at(pts, cum, d0), PK._at(pts, cum, hd), wl, c0, c1)
		hd += gap


func _flush_pass() -> void:
	for ch: Array in _q_chevs:
		_flush_flow_q(ch[0] as PackedVector2Array, ch[1] as Color, float(ch[2]), float(ch[3]), float(ch[4]))
	_q_chevs.clear()
	for po: Array in _q_polys:
		_push_poly(po[0] as PackedVector2Array, po[1] as Color)
	_q_polys.clear()


func _emit_seg(a: Vector2, b: Vector2, w: float, col: Color) -> void:
	var d: Vector2 = b - a
	var ln: float = d.length()
	if ln < 0.001:
		return
	var n: Vector2 = Vector2(-d.y, d.x) * (w * 0.5 / ln)
	_q_polys.append([PackedVector2Array([a - n, b - n, b + n, a + n]), col])


func _emit_disc(p: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	pts.resize(12)
	for i in 12:
		var a: float = TAU * float(i) / 12.0
		pts[i] = p + Vector2(cos(a), sin(a)) * r
	_q_polys.append([pts, col])


func _op_visible(op: Dictionary, rest: PackedVector2Array, vr: Rect2, k: float) -> bool:
	if gw.selected_facility() == op.get("f"):
		return true
	var pad: float = 90.0 * k
	var front: Vector2 = op["front"]
	var target: Vector2 = op["target"]
	var lo := Vector2(minf(front.x, target.x), minf(front.y, target.y))
	var hi := Vector2(maxf(front.x, target.x), maxf(front.y, target.y))
	if not rest.is_empty():
		var step: int = maxi(1, rest.size() / 6)
		for i in range(0, rest.size(), step):
			var q: Vector2 = rest[i]
			lo.x = minf(lo.x, q.x)
			lo.y = minf(lo.y, q.y)
			hi.x = maxf(hi.x, q.x)
			hi.y = maxf(hi.y, q.y)
	else:
		var path: PackedVector2Array = op["path"]
		if not path.is_empty():
			var step2: int = maxi(1, path.size() / 6)
			for i2 in range(0, path.size(), step2):
				var q2: Vector2 = path[i2]
				lo.x = minf(lo.x, q2.x)
				lo.y = minf(lo.y, q2.y)
				hi.x = maxf(hi.x, q2.x)
				hi.y = maxf(hi.y, q2.y)
	return Rect2(lo - Vector2(pad, pad), (hi - lo) + Vector2(pad * 2.0, pad * 2.0)).intersects(vr)


func _draw() -> void:
	MD.begin("ops")
	if gw == null or gw.ops == null or gw.camera == null:
		return
	var cam: MapCamera = gw.camera
	var half: Vector2 = cam.view_size() * 0.5 / cam.zoom.x
	var vr: Rect2 = Rect2(cam.position - half, half * 2.0).grow(80.0)
	_pending_labels.clear()
	_t_pts.clear()
	_t_cols.clear()
	_t_idx.clear()
	_q_chevs.clear()
	_q_polys.clear()
	var o: Operations = gw.ops
	var k: float = _k()
	var pid: int = gw.player.id if gw.player != null else -1
	for z: Dictionary in o.zones:
		var zp: Vector2 = z["pos"]
		var zr: float = float(z["r"]) + 24.0
		if Rect2(zp - Vector2(zr, zr), Vector2(zr * 2.0, zr * 2.0)).intersects(vr):
			_zone(z, k)
	var bun: Dictionary = _bundles(o, pid)
	for pass_i in 2:
		for f: Facility in o.list:
			var op: Dictionary = o.list[f]
			var c: Country = gw.country_by_id(int(op["c"]))
			if c == null:
				continue
			var own: bool = int(op["c"]) == pid or (gw.vision != null and gw.vision.friend(int(op["c"])))
			if op.has("fp") and int(op["kind"]) != Operations.Kind.RETREAT and (own or int(op["kind"]) == Operations.Kind.DEFEND):
				continue
			var bf: Array = bun.get(f, [])
			var follower: bool = not bf.is_empty() and (bf[0] as PackedVector2Array).size() >= 2
			if own and not op.has("fp"):
				if follower != (pass_i == 0):
					continue
			elif pass_i == 0:
				continue
			var lr: PackedVector2Array = bf[0] if follower else PackedVector2Array()
			if not _op_visible(op, lr, vr, k):
				continue
			if own and op.has("fp"):
				_fp_retreat(op, c, k)
			elif own:
				_op_arrow(op, c, k, lr, int(bf[1]) if not bf.is_empty() else 1)
			elif gw.vision == null or gw.vision.sees(op["front"]):
				_enemy_arrow(op, c, k)
		_flush_pass()
	if not o.preview_arrow.is_empty():
		_preview_arrow(o, k)
	if not o.preview_order.is_empty():
		_preview_order(o, k)
	if not _t_idx.is_empty():
		RenderingServer.canvas_item_add_triangle_array(get_canvas_item(), _t_idx, _t_pts, _t_cols)
		_t_pts.clear()
		_t_cols.clear()
		_t_idx.clear()
	if not _pending_labels.is_empty():
		var font: Font = UiKit.f_bold if UiKit.f_bold != null else ThemeDB.fallback_font
		for lb: Array in _pending_labels:
			var lp: Vector2 = lb[0]
			var lr2: Rect2 = lb[1]
			var lcol: Color = lb[3]
			var lalpha: float = float(lb[5])
			var lprog: float = float(lb[4])
			var bx := Rect2(lp + lr2.position * k, lr2.size * k)
			draw_rect(bx, Color(0.05, 0.06, 0.05, 0.6 * lalpha))
			var ocol := Color(lcol, 0.7 * lalpha)
			var ow: float = maxf(1.0, k)
			draw_rect(Rect2(bx.position.x, bx.position.y, bx.size.x, ow), ocol)
			draw_rect(Rect2(bx.position.x, bx.end.y - ow, bx.size.x, ow), ocol)
			draw_rect(Rect2(bx.position.x, bx.position.y + ow, ow, maxf(0.0, bx.size.y - ow * 2.0)), ocol)
			draw_rect(Rect2(bx.end.x - ow, bx.position.y + ow, ow, maxf(0.0, bx.size.y - ow * 2.0)), ocol)
			if lprog >= 0.0:
				var bar: = Rect2(lr2.position + Vector2(3.0, lr2.size.y - 4.0), Vector2(lr2.size.x - 6.0, 2.0))
				draw_rect(Rect2(lp + bar.position * k, bar.size * k), Color(0, 0, 0, 0.5 * lalpha))
				draw_rect(Rect2(lp + bar.position * k, Vector2(bar.size.x * clampf(lprog, 0.0, 1.0), 2.0) * k), Color(lcol, lalpha))
		var inv_k: float = 1.0 / k
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(k, k))
		for lb2: Array in _pending_labels:
			draw_string(font, (lb2[0] as Vector2) * inv_k + Vector2(-float(lb2[7]) * 0.5, -4.0), String(lb2[2]), HORIZONTAL_ALIGNMENT_LEFT, -1, int(lb2[6]), Color(Palette.c("white"), 0.95 * float(lb2[5])))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		_pending_labels.clear()
	_t_pts.clear()
	_t_cols.clear()
	_t_idx.clear()
	_q_chevs.clear()
	_q_polys.clear()







func _bundles(o: Operations, pid: int) -> Dictionary:
	var groups: Dictionary = {}
	for f: Facility in o.list:
		var op: Dictionary = o.list[f]
		if int(op["c"]) != pid or op.has("fp") or int(op["kind"]) == Operations.Kind.RETREAT:
			continue
		var tg: Vector2 = op["target"]
		var key: String = "%d:%d:%d" % [int(op["kind"]), floori(tg.x / 160.0), floori(tg.y / 160.0)]
		var g: Array = groups.get(key, [])
		g.append(f)
		groups[key] = g
	var out: Dictionary = {}
	for key2: String in groups:
		var g2: Array = groups[key2]
		if g2.size() < 2:
			continue
		var lead: Facility = null
		var bd: float = INF
		for f2: Facility in g2:
			var op2: Dictionary = o.list[f2]
			var d: float = (op2["front"] as Vector2).distance_to(op2["target"])
			if d < bd:
				bd = d
				lead = f2
		var lr: PackedVector2Array = _rest(o.list[lead])
		for f3: Facility in g2:
			out[f3] = [PackedVector2Array() if f3 == lead else lr, g2.size()]
	return out



static func _rest(op: Dictionary) -> PackedVector2Array:
	var path: PackedVector2Array = op["path"]
	if path.size() < 2:
		path = PackedVector2Array([op["from"], op["target"]])
	var front: Vector2 = op["front"]
	var cut: int = _nearest_idx(path, front)
	var rest: = PackedVector2Array([front])
	for i in range(cut + 1, path.size()):
		rest.append(path[i])
	return rest


static func _closest_on(path: PackedVector2Array, p: Vector2) -> Vector2:
	var best: Vector2 = path[0]
	var bd: float = INF
	for i in range(1, path.size()):
		var q: Vector2 = Geometry2D.get_closest_point_to_segment(p, path[i - 1], path[i])
		var d: float = q.distance_squared_to(p)
		if d < bd:
			bd = d
			best = q
	return best


func _op_arrow(op: Dictionary, c: Country, k: float, lead_rest: PackedVector2Array = PackedVector2Array(), badge: int = 1) -> void:
	var kind: int = int(op["kind"])
	var path: PackedVector2Array = op["path"]
	if path.size() < 2:
		path = PackedVector2Array([op["from"], op["target"]])
	var col: Color = c.color_light


	var quiet: bool = false
	var fq: Variant = op.get("f")
	if fq is Facility and (fq as Facility).group_id >= 0 and gw.player != null and int(op["c"]) == gw.player.id:
		var gq: Dictionary = AGroups.by_id(gw, gw.player.id, (fq as Facility).group_id)
		if not gq.is_empty():
			col = AKit.color(int(gq["color"])).lightened(0.12)
			quiet = MD.sel_gid >= 0 and MD.sel_gid != (fq as Facility).group_id
	if kind == Operations.Kind.RETREAT:
		col = col.lerp(Palette.c("ui_steel_light"), 0.55)


	if (fq is Facility and gw.rail != null and gw.rail.troops != null and gw.rail.troops.busy(fq as Facility)) or int(gw.map_mode) == GameWorld.MapMode.LOGISTICS:
		quiet = true
	if quiet:
		col.a = 0.55
	var front: Vector2 = op["front"]

	var cut: int = _nearest_idx(path, front)
	var done: = PackedVector2Array()
	for i in range(0, cut + 1):
		done.append(path[i])
	done.append(front)
	var rest: = PackedVector2Array([front])
	for i in range(cut + 1, path.size()):
		rest.append(path[i])

	var stub: bool = lead_rest.size() >= 2
	if stub:
		rest = PackedVector2Array([front, _closest_on(lead_rest, front)])


	var on_train: bool = fq is Facility and gw.rail != null and gw.rail.troops != null and gw.rail.troops.riding(fq as Facility)
	if on_train:
		var s2p: Vector2 = gw.rail.troops.alight_pos(fq as Facility)
		if s2p.is_finite():
			rest = PackedVector2Array([s2p])
			for i in range(_nearest_idx(path, s2p) + 1, path.size()):
				rest.append(path[i])
			if rest.size() < 2:
				rest.append(op["target"])
	var w: float = (4.5 if gw.camera.zoom.x >= 1.0 else 3.5) * k * (0.6 if stub else 1.0) * (0.6 if quiet else 1.0)
	var dim: = Color(col.r, col.g, col.b, 0.35)
	var sm: PackedVector2Array = PK.smooth(rest, 9.0 * k)
	if gw.selected_facility() == op.get("f"):
		_poly(done, dim, w * 0.7, k, false)
	_poly_sm(sm, col, w, k, true)
	if not stub:
		_q_chevs.append([sm, col.lightened(0.5), _t * (0.55 if kind == Operations.Kind.RETREAT else 1.0), k, 14.0 * k])
	var end: Vector2 = sm[sm.size() - 1]
	var dir: Vector2 = (end - sm[maxi(0, sm.size() - 2)]).normalized() if sm.size() >= 2 else Vector2.RIGHT
	if dir == Vector2.ZERO:
		dir = (end - front).normalized() if end != front else Vector2.RIGHT
	if stub:
		_emit_disc(end, 3.5 * k, Palette.c("ui_rubber"))
		_emit_disc(end, 2.2 * k, col)
	elif kind == Operations.Kind.DEFEND:
		_defence_line_q(end, dir, col, k)
	else:
		_head_q(end, dir, col, k * 0.75)
		if badge > 1:
			_label(end - dir * 26.0 * k + Vector2(0, -12.0 * k), "×%d" % badge, col, k, -1.0, 1.0, 10)
	if (op.get("wp", Vector2.INF) as Vector2).is_finite():
		var wp: Vector2 = op["wp"]
		_emit_disc(wp, 4.0 * k, Palette.c("ui_rubber"))
		_emit_disc(wp, 2.5 * k, col)
	if not on_train:
		_front_marker_q(front, _dir_at(path, cut), col, k)


	var f: Facility = op["f"]
	var sel: bool = gw.selected_facility() == f
	if not sel and gw.camera.zoom.x < LABEL_MIN_ZOOM:
		return
	if not sel and pennant_fids.has(f.id):
		return
	var txt: String
	if sel:
		txt = "№%d %s · %s" % [f.army_no, Loc.t(String(Operations.KIND_SHORT[kind])), Loc.msg(op["state"])]
		if float(op["losses"]) >= 0.15:
			txt += Loc.t(" · потери %d%%") % roundi(float(op["losses"]) * 100.0)
	else:
		txt = "№%d %s" % [f.army_no, Loc.t(String(Operations.KIND_SHORT[kind]))]
		var tag: String = _short_state(op["state"])
		if tag != "":
			txt += (" " if tag.ends_with("%") else " · ") + tag
	var start: Vector2 = f.center_px()
	var away: Vector2 = start - front
	away = away.normalized() if away.length() > 1.0 else Vector2.DOWN
	_label(start + away * 20.0 * k + Vector2(0, 6.0 * k), txt, col, k, float(op["progress"]), 1.0 if sel else 0.75, 9)




func _fp_retreat(op: Dictionary, c: Country, k: float) -> void:
	var front: Vector2 = op["front"]
	var to: Vector2 = op["target"]
	var path: PackedVector2Array = op["path"]
	if path.size() >= 2:
		to = path[path.size() - 1]
	var dir: Vector2 = (to - front).normalized() if to.distance_to(front) > 1.0 else Vector2.DOWN
	var L: float = minf(40.0 * k, front.distance_to(to))
	var col: Color = c.color_light.lerp(Palette.c("ui_steel_light"), 0.55)
	col.a = 0.7
	var b: Vector2 = front + dir * L
	_emit_seg(front, b, 3.5 * k, Palette.c("ui_rubber"))
	_emit_seg(front, b, 2.0 * k, col)
	var n: = Vector2(-dir.y, dir.x)
	_q_polys.append([PackedVector2Array([b + dir * 5.0 * k, b - dir * 2.0 * k + n * 4.0 * k, b - dir * 2.0 * k - n * 4.0 * k]), col])


func _enemy_arrow(op: Dictionary, c: Country, k: float) -> void:
	var path: PackedVector2Array = op["path"]
	var front: Vector2 = op["front"]
	var dir: Vector2 = _dir_at(path, _nearest_idx(path, front)) if path.size() >= 2 else Vector2.RIGHT
	if int(op["kind"]) == Operations.Kind.RETREAT:
		dir = ((op["target"] as Vector2) - front).normalized()
	var col: Color = c.color_light
	var a: Vector2 = front - dir * 50.0 * k
	var b: Vector2 = front + dir * 45.0 * k
	_poly(PackedVector2Array([a, b]), col, 5.0 * k, k, true)
	_head_q(b, dir, col, k)
	_front_marker_q(front, dir, col, k)


func _defence_line_q(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var side: = Vector2(-dir.y, dir.x)
	var half: float = 34.0
	var a: Vector2 = p - side * half
	var b: Vector2 = p + side * half
	_emit_seg(a, b, 6.0 * k, Palette.c("ui_rubber"))
	_emit_seg(a, b, 3.5 * k, col)
	var n: int = 6
	for i in n:
		var q: Vector2 = a.lerp(b, (float(i) + 0.5) / float(n))
		_q_polys.append([PackedVector2Array([q - side * 3.0 * k, q + side * 3.0 * k, q + dir * 5.0 * k]), col])


func _head_q(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var n: = Vector2(-dir.y, dir.x)
	var tip: Vector2 = p + dir * 6.0 * k
	_q_polys.append([PackedVector2Array([tip + dir * 2.0 * k, tip - dir * 16.5 * k + n * 11.0 * k, tip - dir * 16.5 * k - n * 11.0 * k]), Palette.c("ui_rubber")])
	_q_polys.append([PackedVector2Array([tip, tip - dir * 15.0 * k + n * 9.0 * k, tip - dir * 15.0 * k - n * 9.0 * k]), col])


func _front_marker_q(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var side: = Vector2(-dir.y, dir.x)
	var pulse: float = 1.0 + 0.15 * sin(_t * 5.0)
	_emit_seg(p - side * 9.0 * k * pulse, p + side * 9.0 * k * pulse, 5.0 * k, Palette.c("ui_rubber"))
	_emit_seg(p - side * 8.0 * k * pulse, p + side * 8.0 * k * pulse, 2.5 * k, col.lightened(0.3))


func _defence_line(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var side: = Vector2(-dir.y, dir.x)
	var half: float = 34.0
	var a: Vector2 = p - side * half
	var b: Vector2 = p + side * half
	draw_line(a, b, Palette.c("ui_rubber"), 6.0 * k)
	draw_line(a, b, col, 3.5 * k)

	var n: int = 6
	for i in n:
		var q: Vector2 = a.lerp(b, (float(i) + 0.5) / float(n))
		var tri: = PackedVector2Array([q - side * 3.0 * k, q + side * 3.0 * k, q + dir * 5.0 * k])
		draw_colored_polygon(tri, col)


func _head(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var n: = Vector2(-dir.y, dir.x)
	var tip: Vector2 = p + dir * 6.0 * k
	var tri: = PackedVector2Array([tip, tip - dir * 15.0 * k + n * 9.0 * k, tip - dir * 15.0 * k - n * 9.0 * k])
	var out: = PackedVector2Array([tip + dir * 2.0 * k, tip - dir * 16.5 * k + n * 11.0 * k, tip - dir * 16.5 * k - n * 11.0 * k])
	draw_colored_polygon(out, Palette.c("ui_rubber"))
	draw_colored_polygon(tri, col)


func _front_marker(p: Vector2, dir: Vector2, col: Color, k: float) -> void:
	var side: = Vector2(-dir.y, dir.x)
	var pulse: float = 1.0 + 0.15 * sin(_t * 5.0)
	draw_line(p - side * 9.0 * k * pulse, p + side * 9.0 * k * pulse, Palette.c("ui_rubber"), 5.0 * k)
	draw_line(p - side * 8.0 * k * pulse, p + side * 8.0 * k * pulse, col.lightened(0.3), 2.5 * k)




func _chevrons(path: PackedVector2Array, col: Color, k: float, slow: bool) -> void:

	PK.flow(self, PK.smooth(path, 9.0 * k), col, 4.0, _t * (0.55 if slow else 1.0), k, 0.9, 14.0 * k)


func _poly(pts: PackedVector2Array, col: Color, w: float, k: float, outline: bool) -> void:
	if pts.size() < 2:
		return
	_poly_sm(PK.smooth(pts, 9.0 * k), col, w, k, outline)


func _poly_sm(sp: PackedVector2Array, col: Color, w: float, k: float, outline: bool) -> void:
	if sp.size() < 2:
		return
	if outline:
		_push_strip(sp, w + 2.5 * k, Color(Palette.c("ui_rubber"), col.a), false)
	_push_strip(sp, w, col, false)
	if w >= 3.0 * k:
		_push_strip(sp, w * 0.34, Color(col.lightened(0.45), 0.5 * col.a), false)


const LABEL_MIN_ZOOM: float = 0.6




static func _short_state(st: Variant) -> String:
	if not Loc.is_msg(st):
		return _short_legacy(String(st))
	var pc: int = Operations.state_pct(st)
	match Operations.state_kind(st):
		"refill":
			return ("%d%%" % pc) if pc >= 0 else ""
		"assault":
			return Loc.t("штурм")
		"fight", "fight_line":
			return Loc.t("бой")
		"fire":
			return Loc.t("огонь")
		"wait_fire":
			return Loc.t("ждём огня")
		"gather":
			return Loc.t("сбор")
		"dug":
			return Loc.t("закрепились")
		"hold":
			return Loc.t("рубеж")
		"march":
			return Loc.t("марш")
		"losses":
			return (Loc.t("потери %d%%") % pc) if pc >= 0 else ""
	return ""


static func _short_legacy(st: String) -> String:
	var pct: int = st.find("%")
	if st.begins_with("у казарм"):
		var sp: int = st.rfind(" ", pct)
		return st.substr(sp + 1, pct - sp) if pct > 0 and sp >= 0 else ""
	if st.begins_with("штурм"):
		return Loc.t("штурм")
	if st.begins_with("бой"):
		return Loc.t("бой")
	if st.begins_with("огонь"):
		return Loc.t("огонь")
	if st.find("ждём огня") >= 0:
		return Loc.t("ждём огня")
	if st.begins_with("сбор"):
		return Loc.t("сбор")
	if st.begins_with("закреп"):
		return Loc.t("закрепились")
	if st.begins_with("держим"):
		return Loc.t("рубеж")
	if st.begins_with("выдвиж") or st.begins_with("перебеж"):
		return Loc.t("марш")
	if st.begins_with("потери") and pct > 0:
		return Loc.t("потери %s") % st.substr(7, pct - 6)
	return ""


func _label(p: Vector2, txt: String, col: Color, k: float, progress: float = -1.0, alpha: float = 1.0, fs: int = 9) -> void:
	var font: Font = UiKit.f_bold if UiKit.f_bold != null else ThemeDB.fallback_font
	var sz: Vector2 = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var r: = Rect2(Vector2(-sz.x * 0.5 - 3.0, -sz.y - 2.0), Vector2(sz.x + 6.0, sz.y + (6.0 if progress >= 0.0 else 3.0)))

	if gw.camera != null:
		var cam: MapCamera = gw.camera
		var vs: Vector2 = cam.view_size()
		var mt: float = float(cam.get("margin_top_px")) if cam.get("margin_top_px") != null else 0.0
		var mb: float = float(cam.get("margin_bottom_px")) if cam.get("margin_bottom_px") != null else 0.0
		var sp: Vector2 = cam.world_to_screen(p)
		var lo: = Vector2(4.0 - r.position.x, mt + 4.0 - r.position.y)
		var hi: = Vector2(vs.x - 4.0 - r.end.x, vs.y - mb - 4.0 - r.end.y)
		if hi.x >= lo.x:
			sp.x = clampf(sp.x, lo.x, hi.x)
		if hi.y >= lo.y:
			sp.y = clampf(sp.y, lo.y, hi.y)
		p = cam.screen_to_world(sp)
	if MD.rec and gw.camera != null:
		MD.note("ops", Rect2(gw.camera.world_to_screen(p) + r.position * k * gw.camera.zoom.x, r.size * k * gw.camera.zoom.x))
	_pending_labels.append([p, r, txt, col, progress, alpha, fs, sz.x])


static func _nearest_idx(path: PackedVector2Array, p: Vector2) -> int:
	var best: int = 0
	var bd: float = INF
	for i in path.size():
		var d: float = path[i].distance_squared_to(p)
		if d < bd:
			bd = d
			best = i
	return best


static func _dir_at(path: PackedVector2Array, i: int) -> Vector2:
	if path.size() < 2:
		return Vector2.RIGHT
	var a: int = clampi(i, 0, path.size() - 2)
	var d: Vector2 = path[a + 1] - path[a]
	return d.normalized() if d.length() > 0.001 else Vector2.RIGHT




func _zone(z: Dictionary, k: float) -> void:
	var p: Vector2 = z["pos"]
	var c: int = int(z["c"])
	if gw.player != null and c != gw.player.id and gw.vision != null and not gw.vision.shows(c, p):
		return
	var r: float = float(z["r"])
	var now: float = gw.game_time
	match int(z["k"]):
		Operations.Order.SMOKE:
			var life: float = clampf((float(z["until"]) - now) / 3.0, 0.0, 1.0)
			_ellipse(p, r, Color(Palette.c("smoke_light"), 0.12 * life), true, k)
			_ellipse(p, r, Color(Palette.c("smoke"), 0.35 * life), false, k)
		Operations.Order.EW:
			var life2: float = clampf((float(z["until"]) - now) / 3.0, 0.0, 1.0) * clampf((now - float(z["t0"])) / 0.6, 0.0, 1.0)
			var cy: Color = Palette.c("intercept_cyan")
			_ellipse(p, r, Color(cy, 0.07 * life2), true, k)

			_ellipse(p, r, Color(Palette.c("ui_rubber"), 0.5 * life2), false, k, 3.5)
			_ellipse(p, r, Color(cy, 0.9 * life2), false, k, 2.0)
			_ellipse(p + Vector2(0, -r * 0.18), r * 0.78, Color(cy, 0.35 * life2), false, k)
			_ellipse(p + Vector2(0, -r * 0.34), r * 0.48, Color(cy, 0.3 * life2), false, k)
			for j in 3:
				var a0: float = _t * 1.3 + float(j) * TAU / 3.0
				_arc_e(p, r, a0, 0.5, Color(Palette.c("white"), 0.7 * life2), k)
			if fmod(_t * 3.0, 1.0) < 0.5:
				var q: Vector2 = p + Vector2.from_angle(_t * 7.3) * Vector2(1.0, 0.72) * r * 0.9
				_disc_t(q, 1.5 * k, Color(Palette.c("white"), 0.8 * life2))
		Operations.Order.ARTY:
			var red: Color = Palette.c("alert_red")
			var warn: bool = now < float(z["t0"]) + Operations.WARN_T
			var a1: float = (0.65 + 0.35 * sin(_t * 10.0)) if warn else 0.9
			_ellipse(p, r, Color(red, 0.07 * a1), true, k)
			_target_ring(p, r, k, Palette.c("fire_yellow") if warn else red, a1)


func _disc_t(p: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	pts.resize(12)
	for i in 12:
		var a: float = TAU * float(i) / 12.0
		pts[i] = p + Vector2(cos(a), sin(a)) * r
	_push_poly(pts, col)


func _seg_t(a: Vector2, b: Vector2, w: float, col: Color) -> void:
	var d: Vector2 = b - a
	var ln: float = d.length()
	if ln < 0.001:
		return
	var n: Vector2 = Vector2(-d.y, d.x) * (w * 0.5 / ln)
	_push_poly(PackedVector2Array([a - n, b - n, b + n, a + n]), col)


func _target_ring(p: Vector2, r: float, k: float, accent: Color, a: float) -> void:
	var dark: = Color(Palette.c("outline"), 0.85 * a)
	var white: = Color(Palette.c("white"), a)
	_ellipse(p, r, dark, false, k, 5.0)
	_ellipse(p, r, Color(accent, a), false, k, 2.0)
	_dashed_ellipse(p, r, white, k, 2.0)
	var ri: float = maxf(r - 7.0 * k, r * 0.6)
	_ellipse(p, ri, Color(Palette.c("outline"), 0.6 * a), false, k, 3.0)
	_ellipse(p, ri, Color(white, 0.8 * a), false, k, 1.0)
	for d: Vector2 in [Vector2(1, 0), Vector2(0, 1)]:
		_seg_t(p - d * 10.0 * k, p + d * 10.0 * k, 4.0 * k, dark)
	for d2: Vector2 in [Vector2(1, 0), Vector2(0, 1)]:
		_seg_t(p - d2 * 9.0 * k, p - d2 * 2.5 * k, 2.0 * k, white)
		_seg_t(p + d2 * 2.5 * k, p + d2 * 9.0 * k, 2.0 * k, white)
	_seg_t(p - Vector2(k, 0), p + Vector2(k, 0), 2.0 * k, Color(accent, a))


const _ELLIPSE_SEGS: int = 36
static var _u_ell: PackedVector2Array = PackedVector2Array()

static func _get_u_ell() -> PackedVector2Array:
	if _u_ell.is_empty():
		_u_ell.resize(_ELLIPSE_SEGS)
		for i in _ELLIPSE_SEGS:
			var a: float = TAU * float(i) / float(_ELLIPSE_SEGS)
			_u_ell[i] = Vector2(cos(a), sin(a) * 0.72)
	return _u_ell


func _ellipse(p: Vector2, r: float, col: Color, fill: bool, k: float, w: float = 1.0) -> void:
	var u: PackedVector2Array = _get_u_ell()
	var n: int = _ELLIPSE_SEGS
	var pts := PackedVector2Array()
	pts.resize(n)
	for i in n:
		pts[i] = p + u[i] * r
	if fill:
		_push_poly(pts, col)
	else:
		_push_strip(pts, w * k / 0.86, col, true)


func _arc_e(p: Vector2, r: float, a0: float, span: float, col: Color, k: float) -> void:
	var segs: int = 8
	var pts := PackedVector2Array()
	pts.resize(segs + 1)
	for i in segs + 1:
		var a: float = a0 + span * float(i) / float(segs)
		pts[i] = p + Vector2(cos(a) * r, sin(a) * r * 0.72)
	_push_strip(pts, 2.0 * k, col, false)


func _dashed_ellipse(p: Vector2, r: float, col: Color, k: float, w: float = 1.5) -> void:
	var n: int = 24
	var rot: float = _t * 0.6
	var step: float = TAU / float(n)
	var span: float = step * 0.55
	var sw: float = w * k
	for i in n:
		var a: float = rot + step * float(i)
		var am: float = a + span * 0.5
		var a1: float = a + span
		var p0 := Vector2(p.x + cos(a) * r, p.y + sin(a) * r * 0.72)
		var pm := Vector2(p.x + cos(am) * r, p.y + sin(am) * r * 0.72)
		var p1 := Vector2(p.x + cos(a1) * r, p.y + sin(a1) * r * 0.72)
		_push_strip(PackedVector2Array([p0, pm, p1]), sw, col, false)




func _preview_arrow(o: Operations, k: float) -> void:
	var pa: Dictionary = o.preview_arrow
	var f: Facility = pa.get("f")
	if f == null:
		return
	var to: Vector2 = pa.get("to", Vector2.INF)
	if not to.is_finite():
		return
	var res: Dictionary = o.preview(f, to, int(pa.get("kind", -1)), pa.get("wp", Vector2.INF))
	var col: Color = Palette.c(String(res["colour"]))
	var path: PackedVector2Array = res["path"]
	var ok: bool = bool(res["ok"])
	col.a = 0.9 if ok else 0.7
	var sm_p: PackedVector2Array = PK.smooth(path, 9.0 * k)
	_poly_sm(sm_p, col, 4.0 * k, k, true)
	if ok:
		_flush_flow_q(sm_p, col.lightened(0.5), _t, k, 14.0 * k)
	var end: Vector2 = sm_p[sm_p.size() - 1] if not sm_p.is_empty() else to
	var dir: Vector2 = (end - sm_p[maxi(0, sm_p.size() - 2)]).normalized() if sm_p.size() >= 2 else _dir_at(path, path.size() - 2)
	if ok and int(res["kind"]) == Operations.Kind.DEFEND:
		_defence_line_q(end, dir, col, k)
		_flush_pass()
	elif ok:
		_head_q(end, dir, col, k)
		_flush_pass()
	else:
		var x: float = 5.0 * k
		_seg_t(to - Vector2(x, x), to + Vector2(x, x), 2.0 * k, Palette.c("alert_red"))
		_seg_t(to - Vector2(x, -x), to + Vector2(x, -x), 2.0 * k, Palette.c("alert_red"))
	_label(to + Vector2(0, -18.0 * k), Loc.t(String(res["text"])),
			col if ok else Palette.c("alert_red"), k)


func _preview_order(o: Operations, k: float) -> void:
	var po: Dictionary = o.preview_order
	var kind: int = int(po.get("kind", 0))
	var p: Vector2 = po.get("pos", Vector2.INF)
	if not p.is_finite() or gw.player == null:
		return
	var chk: Dictionary = o.order_check(gw.player.id, kind, p)
	var r: float = float(Operations.ORDERS[kind]["r"])
	var col: Color = Palette.c(["alert_red", "smoke_light", "intercept_cyan"][kind]) if bool(chk["ok"]) else Palette.c("ui_steel_mid")
	_ellipse(p, r, Color(col, 0.12), true, k)
	if kind == Operations.Order.ARTY and bool(chk["ok"]):
		_target_ring(p, r, k, col, 0.95)
	else:
		_ellipse(p, r, Color(Palette.c("ui_rubber"), 0.5), false, k, 3.5)
		_dashed_ellipse(p, r, Color(col, 0.95), k, 2.0)
	if kind == Operations.Order.ARTY and o.has_method("arty_anchor"):


		var an: Vector2 = o.arty_anchor(gw.player.id, p)
		var far: bool = bool(chk.get("too_far", false))
		var rc: Color = Palette.c("alert_red") if far else Color(Palette.c("intercept_cyan"), 0.55)
		if an.is_finite():
			var r_step: float = TAU / 48.0
			var r_span: float = r_step * 0.55
			var r_col := Color(rc, 0.75 if far else 0.45)
			for i9 in 48:
				var a9: float = _t * 0.2 + r_step * float(i9)
				_seg_t(an + Vector2(cos(a9), sin(a9)) * Operations.ARTY_REACH, an + Vector2(cos(a9 + r_span), sin(a9 + r_span)) * Operations.ARTY_REACH, 2.0 * k, r_col)
			if far:
				_seg_t(an, an + (p - an).limit_length(Operations.ARTY_REACH), 1.5 * k, Color(rc, 0.6))
		if far:
			_ellipse(p, r, Color(Palette.c("alert_red"), 0.22), true, k)
	var txt: String = Loc.t(String(Operations.ORDERS[kind]["name"])) if bool(chk["ok"]) else Loc.t(String(chk["why"]))
	_label(p + Vector2(0, -r * 0.72 - 6.0 * k), txt, col if bool(chk["ok"]) else Palette.c("alert_red"), k)
