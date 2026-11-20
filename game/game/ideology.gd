extends RefCounted

const COUNT: int = 7
const NAMES: Array = [
	"Либерализм",
	"Консерватизм",
	"Социализм",
	"Коммунизм",
	"Национализм",
	"Милитаризм",
	"Прогрессизм",
]
const SHORT: Array = [
	"ЛИБЕРАЛИЗМ",
	"КОНСЕРВАТ.",
	"СОЦИАЛИЗМ",
	"КОММУНИЗМ",
	"НАЦИОНАЛ.",
	"МИЛИТАРИЗМ",
	"ПРОГРЕССИЗМ",
]
const DESCS: Array = [
	"Доход с рынков и заводов +8%",
	"Стоимость постройки −6%, доход +5%",
	"Урожай ферм +12%, товары заводов +8%",
	"Стоимость постройки −10%, фермы/заводы +4%",
	"Оборона +8%, марш армии +5%",
	"Скорость армии +10%, найм войск −8%",
	"Товары заводов +10%, доход +5%",
]

# Symmetric ideological affinity (-14 .. +14 initial diplomacy modifier)
const OP_PAIRS: Dictionary = {
	"0:6": 8, "1:4": 6, "2:3": 8, "4:5": 8,
	"0:3": -14, "0:5": -10, "2:4": -10, "3:4": -14, "1:6": -6,
}


static func clamp_id(id: int) -> int:
	return clampi(id, 0, COUNT - 1)


static func label(id: int) -> String:
	return Loc.t(String(NAMES[clamp_id(id)]))


static func desc(id: int) -> String:
	return Loc.t(String(DESCS[clamp_id(id)]))


static func icon(id: int) -> String:
	return "icon_ideo_%d" % clamp_id(id)


static func monument_sprite(id: int) -> String:
	return "monument_%d" % clamp_id(id)


static func farm_mul(id: int) -> float:
	match clamp_id(id):
		2:
			return 1.12
		3:
			return 1.04
	return 1.0


static func civ_mul(id: int) -> float:
	match clamp_id(id):
		2:
			return 1.08
		3:
			return 1.04
		6:
			return 1.10
	return 1.0


static func money_mul(id: int) -> float:
	match clamp_id(id):
		0:
			return 1.08
		1, 6:
			return 1.05
	return 1.0


static func build_cost_mul(id: int) -> float:
	match clamp_id(id):
		1:
			return 0.94
		3:
			return 0.90
	return 1.0


static func army_speed_mul(id: int) -> float:
	match clamp_id(id):
		4:
			return 1.05
		5:
			return 1.10
	return 1.0


static func unit_cost_mul(id: int) -> float:
	return 0.92 if clamp_id(id) == 5 else 1.0


static func opinion_delta(a: int, b: int) -> int:
	var ia: int = clamp_id(a)
	var ib: int = clamp_id(b)
	if ia == ib:
		return 14
	var k: String = "%d:%d" % [mini(ia, ib), maxi(ia, ib)]
	return int(OP_PAIRS.get(k, -4))


static func seeded(gw: GameWorld, cid: int) -> int:
	if gw == null or gw.data == null:
		return absi(cid) % COUNT
	return absi(Hash32.h2(gw.data.world_seed, cid * 97 + 19, 431)) % COUNT


static func spawn_city_monument(gw: GameWorld, city: City, cid: int) -> void:
	if gw == null or gw.data == null or city == null:
		return
	var sname: String = monument_sprite(0)
	var co: Country = gw.country_by_id(cid)
	if co != null:
		sname = monument_sprite(co.ideology)
	if not gw.spr_index.has(sname):
		return
	var sid: int = int(gw.spr_index[sname])
	var fw: int = gw.spr_fw[sid]
	var fd: int = gw.spr_fd[sid]
	var cell: Vector2i = _pick_monument_cell(gw, city, fw, fd)
	if cell.x < 0:
		return
	var oid: int = gw.add_object(sname, cell, GameWorld.KIND_BUILDING)
	if oid < 0:
		return
	city.monument_obj = oid
	city.monument_cell = cell
	city.buildings += 1
	var r: Rect2i = gw.object_rect(oid)
	for yy in range(r.position.y, r.end.y):
		for xx in range(r.position.x, r.end.x):
			if gw.data.inside(xx, yy):
				gw.data.add_flag(xx, yy, WorldData.F_OCCUPIED)


static func _pick_monument_cell(gw: GameWorld, city: City, fw: int, fd: int) -> Vector2i:
	var c0: Vector2i = city.center
	for rad in range(1, 7):
		for dy in range(-rad, rad + 1):
			for dx in range(-rad, rad + 1):
				if maxi(absi(dx), absi(dy)) != rad:
					continue
				var tx: int = c0.x + dx
				var ty: int = c0.y + dy
				var ok: bool = true
				for oy in fd:
					for ox in fw:
						var cx: int = tx + ox
						var cy: int = ty + oy
						if not gw.data.inside(cx, cy):
							ok = false
							break
						var bio: int = gw.data.get_biome(cx, cy)
						if Biome.is_water(bio) or gw.data.has_flag(cx, cy, WorldData.F_OCCUPIED | WorldData.F_ROAD | WorldData.F_BRIDGE):
							ok = false
							break
					if not ok:
						break
				if ok:
					return Vector2i(tx, ty)
	return Vector2i(-1, -1)


static func on_city_captured(gw: GameWorld, city: City, new_cid: int) -> void:
	if gw == null or city == null or city.monument_obj < 0 or city.monument_obj >= gw.obj_spr.size():
		return
	var nc: Country = gw.country_by_id(new_cid)
	if nc == null:
		return
	var sname: String = monument_sprite(nc.ideology)
	if not gw.spr_index.has(sname):
		return
	var sid: int = int(gw.spr_index[sname])
	if gw.obj_spr[city.monument_obj] == sid and gw.obj_state[city.monument_obj] == 0:
		return
	gw.obj_spr[city.monument_obj] = sid
	gw.obj_state[city.monument_obj] = 0
	if gw.has_method("_mark_obj_chunk"):
		gw.call("_mark_obj_chunk", city.monument_obj)
	if gw.fx != null:
		gw.fx.spawn("capture_burst", gw.obj_origin(city.monument_obj).round(), 5)
