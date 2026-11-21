class_name SpriteAtlas
extends RefCounted


var texture: Texture2D
var sprites: Dictionary = {}
var cell_px: int = 4
var outline_tex: Texture2D = null
var _outline_rects: Dictionary = {}
var _outline_tried: bool = false


static func load_atlas(png_path: String, json_path: String, optional: bool = false) -> SpriteAtlas:
	var a: = SpriteAtlas.new()
	var has_tex_res: bool = ResourceLoader.exists(png_path)
	var has_png_file: bool = FileAccess.file_exists(png_path)
	if (not has_tex_res and not has_png_file) or not FileAccess.file_exists(json_path):
		if not optional:
			push_warning("SpriteAtlas: missing %s - empty atlas" % png_path)
		a.texture = PlaceholderTexture2D.new()
		return a
	if has_tex_res:
		a.texture = load(png_path) as Texture2D
	if a.texture == null and has_png_file:
		var fa: FileAccess = FileAccess.open(png_path, FileAccess.READ)
		if fa != null:
			var img: = Image.new()
			if img.load_png_from_buffer(fa.get_buffer(fa.get_length())) == OK:
				a.texture = ImageTexture.create_from_image(img)
	var f: = FileAccess.open(json_path, FileAccess.READ)
	var d: Dictionary = JSON.parse_string(f.get_as_text())
	a.sprites = d["sprites"]

	if d.has("size") and a.texture != null:
		var want: = Vector2(float(d["size"][0]), float(d["size"][1]))
		if a.texture.get_size() != want:
			push_error("SpriteAtlas %s: texture %s != json size %s - reimport the PNG" % [png_path, a.texture.get_size(), want])
	if d.has("cell_px"):
		a.cell_px = int(d["cell_px"])
	return a


func has(sprite_name: String) -> bool:
	return sprites.has(sprite_name)


func info(sprite_name: String) -> Dictionary:
	return sprites[sprite_name]


func rect(sprite_name: String, frame: int = 0) -> Rect2:
	var s: Dictionary = sprites[sprite_name]
	return Rect2(float(s["x"]) + float(s["w"]) * frame, float(s["y"]), float(s["w"]), float(s["h"]))


func region(sprite_name: String, frame: int = 0) -> AtlasTexture:
	var t: = AtlasTexture.new()
	t.atlas = texture
	t.region = rect(sprite_name, frame)
	return t


func outline_rect(sprite_name: String, frame: int = 0) -> Rect2:
	if not _outline_tried:
		_build_outline_sheet()
	if outline_tex == null:
		return Rect2()
	var arr: Variant = _outline_rects.get(sprite_name)
	if arr is Array and frame >= 0 and frame < (arr as Array).size():
		return (arr as Array)[frame] as Rect2
	return Rect2()


func _build_outline_sheet() -> void:
	_outline_tried = true
	if texture == null or sprites.is_empty():
		return
	var src: Image = texture.get_image()
	if src == null or src.is_empty():
		return
	if src.is_compressed():
		src.decompress()
	if src.get_format() != Image.FORMAT_RGBA8:
		src.convert(Image.FORMAT_RGBA8)
	var keys: Array = sprites.keys()
	var max_w: int = 1
	var max_h: int = 1
	for kn: Variant in keys:
		var sp0: Dictionary = sprites[kn]
		max_w = maxi(max_w, int(sp0.get("w", 0)))
		max_h = maxi(max_h, int(sp0.get("h", 0)))
	var row_w: int = maxi(1024, max_w + 4)
	var cur_x: int = 0
	var cur_y: int = 0
	var row_h: int = 0
	var slots: Array = []
	var src_bounds := Rect2i(0, 0, src.get_width(), src.get_height())
	for kn: Variant in keys:
		var sp: Dictionary = sprites[kn]
		var w: int = int(sp.get("w", 0))
		var h: int = int(sp.get("h", 0))
		var nf: int = maxi(1, int(sp.get("frames", 1)))
		if w <= 0 or h <= 0:
			continue
		var pw: int = w + 2
		var ph: int = h + 2
		var rarr: Array = []
		rarr.resize(nf)
		for fr in nf:
			var sr := Rect2i(int(sp["x"]) + fr * w, int(sp["y"]), w, h).intersection(src_bounds)
			if not sr.has_area():
				rarr[fr] = Rect2()
				continue
			if cur_x + pw > row_w:
				cur_x = 0
				cur_y += row_h
				row_h = 0
			var dr := Rect2(float(cur_x), float(cur_y), float(pw), float(ph))
			rarr[fr] = dr
			slots.append([sr, Vector2i(cur_x, cur_y)])
			cur_x += pw
			row_h = maxi(row_h, ph)
		_outline_rects[kn] = rarr
	var total_h: int = maxi(1, cur_y + row_h)
	if slots.is_empty():
		return
	var out_img: Image = Image.create(row_w, total_h, false, Image.FORMAT_RGBA8)
	var white_blk: Image = Image.create(max_w, max_h, false, Image.FORMAT_RGBA8)
	white_blk.fill(Color.WHITE)
	var mask_blk: Image = Image.create(max_w, max_h, false, Image.FORMAT_RGBA8)
	var sil: Image = Image.create(max_w, max_h, false, Image.FORMAT_RGBA8)
	var offs: Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	for sl: Array in slots:
		var sr: Rect2i = sl[0]
		var dst: Vector2i = sl[1]
		var mask_r: Rect2i = Rect2i(0, 0, sr.size.x, sr.size.y)
		mask_blk.blit_rect(src, sr, Vector2i.ZERO)
		sil.fill(Color(0, 0, 0, 0))
		sil.blit_rect_mask(white_blk, mask_blk, mask_r, Vector2i.ZERO)
		for o: Vector2i in offs:
			out_img.blend_rect(sil, mask_r, dst + Vector2i(1, 1) + o)
	outline_tex = ImageTexture.create_from_image(out_img)
