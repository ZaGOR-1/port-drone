extends RefCounted










static var _x0: int = 0
static var _tops: PackedInt32Array = PackedInt32Array()



static func begin(gw: GameWorld, x0: int, w: int, foot: int) -> void:
	_x0 = x0
	_tops = gw.objects.cover_span(x0, w, foot) if gw != null and gw.objects != null else PackedInt32Array()


static func _top(x: int) -> int:
	var i: int = x - _x0
	return _tops[i] if i >= 0 and i < _tops.size() else 1 << 30




static func blit_spans(ci: CanvasItem, tex: Texture2D, x0: int, y0: int, w: int, h: int, src: Rect2, flip: bool, mod: Color, cut: PackedInt32Array) -> void:
	var k: int = 0
	while k < w:
		var vh: int = cut[k]
		if vh <= 0:
			k += 1
			continue
		var k0: int = k
		k += 1
		while k < w and cut[k] == vh:
			k += 1
		var run: int = k - k0
		if not flip:
			ci.draw_texture_rect_region(tex, Rect2(x0 + k0, y0, run, vh), Rect2(src.position.x + float(k0), src.position.y, run, vh), mod)
		elif run == 1:
			ci.draw_texture_rect_region(tex, Rect2(x0 + k0, y0, 1, vh), Rect2(src.position.x + float(w - 1 - k0), src.position.y, 1, vh), mod)
		else:
			ci.draw_texture_rect_region(tex, Rect2(x0 + k0 + run, y0, -run, vh), Rect2(src.position.x + float(w - k), src.position.y, run, vh), mod)


static func blit(ci: CanvasItem, tex: Texture2D, dst: Rect2, src: Rect2, mod: Color = Color.WHITE) -> void:
	if _tops.is_empty():
		ci.draw_texture_rect_region(tex, dst, src, mod)
		return
	var flip: bool = dst.size.x < 0.0
	var w: int = int(absf(dst.size.x))
	var h: int = int(dst.size.y)
	var lx: int = int(dst.position.x + (dst.size.x if flip else 0.0))
	var y0: int = int(dst.position.y)
	var cut: = PackedInt32Array()
	cut.resize(w)
	var all_full: bool = true
	var any_vis: bool = false
	for k in w:
		var vh: int = clampi(_top(lx + k) - y0, 0, h)
		cut[k] = vh
		if vh < h:
			all_full = false
		if vh > 0:
			any_vis = true
	if not any_vis:
		return
	if all_full:
		ci.draw_texture_rect_region(tex, dst, src, mod)
		return
	blit_spans(ci, tex, lx, y0, w, h, src, flip, mod, cut)



static func blit_tex(ci: CanvasItem, tex: Texture2D, dst: Rect2, mod: Color = Color.WHITE) -> void:
	blit(ci, tex, dst, Rect2(Vector2.ZERO, Vector2(tex.get_size())), mod)



static func rect(ci: CanvasItem, r: Rect2, col: Color) -> void:
	if _tops.is_empty():
		ci.draw_rect(r, col)
		return
	var x0: int = int(floorf(r.position.x))
	var w: int = int(ceilf(r.size.x))
	var y0: int = int(floorf(r.position.y))
	var h: int = int(ceilf(r.size.y))
	var k: int = 0
	while k < w:
		var vh: int = clampi(_top(x0 + k) - y0, 0, h)
		if vh <= 0:
			k += 1
			continue
		var k0: int = k
		k += 1
		while k < w and clampi(_top(x0 + k) - y0, 0, h) == vh:
			k += 1
		ci.draw_rect(Rect2(x0 + k0, y0, k - k0, vh), col)



static func end() -> void:
	if not _tops.is_empty():
		_tops = PackedInt32Array()
