extends RefCounted

const KEYFRAME_DT: float = 4.0
const MAX_FRAMES: int = 450
const MAX_EVENTS: int = 400
const GRID_N: int = 64
const CELL_PX: int = 4
const DIR_PATH: String = "user://chronicles"

var gw
var frames: Array = []
var events: Array = []
var meta: Dictionary = {}
var fac_born: Dictionary = {}
var _fac_seen: Dictionary = {}
var _sample_dt: float = KEYFRAME_DT
var _sample_t: float = 0.0
var _initialized: bool = false
var _saved_match: bool = false
var _facs_synced: bool = false
var _sample_idx: PackedInt32Array = PackedInt32Array()
var _sample_w: int = 0
var _sample_h: int = 0


func _init(world = null) -> void:
	gw = world
	reset()


func reset() -> void:
	frames.clear()
	events.clear()
	meta.clear()
	fac_born.clear()
	_fac_seen.clear()
	_sample_dt = KEYFRAME_DT
	_sample_t = KEYFRAME_DT
	_initialized = false
	_saved_match = false
	_facs_synced = false
	_sample_idx = PackedInt32Array()
	_sample_w = 0
	_sample_h = 0


func _ensure_sample_idx() -> void:
	if gw == null or gw.data == null:
		return
	var d: WorldData = gw.data
	if _sample_idx.size() == GRID_N * GRID_N and _sample_w == d.w and _sample_h == d.h:
		return
	_sample_w = d.w
	_sample_h = d.h
	_sample_idx.resize(GRID_N * GRID_N)
	for gy in GRID_N:
		var wy: int = mini(d.h - 1, gy * d.h / GRID_N)
		var row: int = wy * d.w
		var dst: int = gy * GRID_N
		for gx in GRID_N:
			var wx: int = mini(d.w - 1, gx * d.w / GRID_N)
			_sample_idx[dst + gx] = row + wx


func init_meta() -> void:
	if gw == null or gw.data == null:
		return
	_ensure_sample_idx()
	var cs: Array = []
	for c: Country in gw.countries:
		cs.append({"id": c.id, "name": c.name, "color": c.color.to_html(false), "is_player": c.is_player, "ideo": c.ideology})
	var prev_w: int = int(meta.get("winner", 0))
	var prev_wn: String = String(meta.get("winner_name", ""))
	var prev_dur: float = float(meta.get("duration", 0.0))
	var prev_pn: String = String(meta.get("player_name", ""))
	meta = {
		"w": gw.data.w,
		"h": gw.data.h,
		"grid": GRID_N,
		"water": _sample_water(),
		"countries": cs,
		"date": Time.get_datetime_string_from_system(false, true),
		"unix": int(Time.get_unix_time_from_system()),
	}
	if prev_w > 0:
		meta["winner"] = prev_w
	if prev_wn != "":
		meta["winner_name"] = prev_wn
	if prev_dur > 0.0:
		meta["duration"] = prev_dur
	elif gw.game_time > 0.0:
		meta["duration"] = snappedf(gw.game_time, 0.1)
	if prev_pn != "":
		meta["player_name"] = prev_pn
	elif gw.player != null:
		meta["player_name"] = gw.player.name
	_initialized = true


func _sample_water() -> PackedByteArray:
	var out := PackedByteArray()
	if gw == null or gw.data == null:
		return out
	out.resize(GRID_N * GRID_N)
	var d: WorldData = gw.data
	for gy in GRID_N:
		var wy: int = mini(d.h - 1, gy * d.h / GRID_N)
		for gx in GRID_N:
			var wx: int = mini(d.w - 1, gx * d.w / GRID_N)
			out[gy * GRID_N + gx] = 1 if Biome.is_water(d.get_biome(wx, wy)) else 0
	return out


func on_facility_built(f: Facility) -> void:
	if f == null or _fac_seen.has(f.id):
		return
	_fac_seen[f.id] = true
	fac_born[f.id] = gw.game_time if gw != null else 0.0
	if gw != null and gw.game_time > 1.0:
		log_event("build", f.country_id, f.cell + f.size / 2, Military.title_of(f.kind))


func step(dt: float) -> void:
	if gw == null or gw.data == null or gw.net_driven:
		return
	if not _initialized and not gw.countries.is_empty():
		init_meta()
	if not _facs_synced and gw.mil != null:
		_facs_synced = true
		for f: Facility in gw.mil.facilities:
			on_facility_built(f)
	_sample_t += dt
	if _sample_t >= _sample_dt:
		_sample_t = fmod(_sample_t, _sample_dt)
		record_frame(false)


func _compact_frames() -> void:
	if frames.size() < 4:
		return
	var kept: Array = []
	var last_i: int = frames.size() - 1
	for i in frames.size():
		if i == 0 or (i % 2 == 0) or i == last_i:
			kept.append(frames[i])
	frames = kept
	_sample_dt = minf(_sample_dt * 2.0, 64.0)


func record_frame(force: bool = false) -> void:
	if gw == null or gw.data == null:
		return
	if not _initialized:
		init_meta()
	if frames.size() >= MAX_FRAMES:
		_compact_frames()
	_ensure_sample_idx()
	var d: WorldData = gw.data
	var own := PackedByteArray()
	own.resize(GRID_N * GRID_N)
	var owners: PackedByteArray = d.owners
	for idx in GRID_N * GRID_N:
		own[idx] = owners[_sample_idx[idx]]

	var facs: Array = []
	if gw.mil != null:
		for f: Facility in gw.mil.facilities:
			if not gw.mil.alive(f):
				continue
			var fc: Vector2i = f.cell + f.size / 2
			facs.append([f.id, f.kind, f.country_id, fc.x, fc.y, float(fac_born.get(f.id, 0.0))])

	var units: Array = []
	if gw.army != null:
		for u: Unit in gw.army.units:
			if u.hp <= 0.0:
				continue
			units.append([u.country_id, u.type, int(u.pos.x / float(CELL_PX)), int(u.pos.y / float(CELL_PX))])

	var airs: Array = []
	if gw.mil != null and gw.mil.air != null:
		for a: Aircraft in gw.mil.air.aircraft:
			if a.state == Aircraft.State.DEAD:
				continue
			airs.append([a.country_id, a.type, int(a.pos.x / float(CELL_PX)), int(a.pos.y / float(CELL_PX)), 1 if a.airborne() else 0])

	var ships: Array = []
	if gw.navy != null:
		for sh: Ship in gw.navy.ships:
			if sh.hp <= 0.0:
				continue
			ships.append([sh.c, sh.hull, int(sh.pos.x / float(CELL_PX)), int(sh.pos.y / float(CELL_PX))])

	var mis: Array = []
	if gw.mil != null:
		for m_obj: Missile in gw.mil.missiles:
			if m_obj.state == Missile.State.DONE:
				continue
			var mp: Vector2 = m_obj.ground()
			mis.append([m_obj.country_id, int(mp.x / float(CELL_PX)), int(mp.y / float(CELL_PX)), 1 if m_obj.nuke else 0])

	var cities_snap: Array = []
	for city: City in gw.cities:
		cities_snap.append([city.id, city.country_id, city.center.x, city.center.y, city.name, 1 if city.kind == City.Kind.CAPITAL else 0])

	var t_snap: float = snappedf(gw.game_time, 0.1)
	var fr := {
		"t": t_snap,
		"own": own,
		"facs": facs,
		"units": units,
		"airs": airs,
		"ships": ships,
		"mis": mis,
		"cities": cities_snap,
	}
	if force and not frames.is_empty():
		var prev_fr: Variant = frames.back()
		if prev_fr is Dictionary and absf(t_snap - float((prev_fr as Dictionary).get("t", -1.0))) < 0.05:
			frames[frames.size() - 1] = fr
			return
	frames.append(fr)


func log_event(kind: String, cid: int, cell: Vector2i, text: String) -> void:
	if events.size() >= MAX_EVENTS:
		var drop_i: int = -1
		for i in events.size():
			var ev: Variant = events[i]
			if ev is Dictionary and String((ev as Dictionary).get("k", "")) == "build":
				drop_i = i
				break
		if drop_i >= 0:
			events.remove_at(drop_i)
		elif kind == "build":
			return
		else:
			events.pop_front()
	events.append({
		"t": snappedf(gw.game_time if gw != null else 0.0, 0.1),
		"k": kind,
		"c": cid,
		"x": cell.x,
		"y": cell.y,
		"text": text,
	})


func save_state() -> Dictionary:
	return {
		"frames": frames,
		"events": events,
		"meta": meta,
		"fac_born": fac_born,
		"initialized": _initialized,
		"saved_match": _saved_match,
		"sample_dt": _sample_dt,
		"sample_t": _sample_t,
	}


func load_state(d: Dictionary) -> void:
	var f_in: Variant = d.get("frames", [])
	frames = (f_in as Array).duplicate(true) if f_in is Array else []
	var e_in: Variant = d.get("events", [])
	events = (e_in as Array).duplicate(true) if e_in is Array else []
	var m_in: Variant = d.get("meta", {})
	meta = (m_in as Dictionary).duplicate(true) if m_in is Dictionary else {}
	var fb_in: Variant = d.get("fac_born", {})
	fac_born = (fb_in as Dictionary).duplicate(true) if fb_in is Dictionary else {}
	_initialized = bool(d.get("initialized", false))
	_saved_match = bool(d.get("saved_match", false))
	_sample_dt = clampf(float(d.get("sample_dt", KEYFRAME_DT)), KEYFRAME_DT, 64.0)
	_sample_t = clampf(float(d.get("sample_t", _sample_dt)), 0.0, _sample_dt)
	_fac_seen.clear()
	_facs_synced = false
	for k: Variant in fac_born:
		_fac_seen[int(k)] = true


func build_record() -> Dictionary:
	if gw != null and (not _initialized or meta.is_empty()):
		init_meta()
	var m_out: Dictionary = meta.duplicate(true)
	if not frames.is_empty() and frames.back() is Dictionary:
		var last_t: float = float((frames.back() as Dictionary).get("t", 0.0))
		m_out["duration"] = maxf(float(m_out.get("duration", 0.0)), last_t)
	return {"meta": m_out, "frames": frames.duplicate(), "events": events.duplicate()}


func finalize_and_save(winner_id: int) -> String:
	if gw == null:
		return ""
	record_frame(true)
	init_meta()
	var wc: Country = gw.country_by_id(winner_id)
	meta["winner"] = winner_id
	meta["winner_name"] = wc.name if wc != null else ""
	var dur: float = snappedf(gw.game_time, 0.1)
	if not frames.is_empty() and frames.back() is Dictionary:
		dur = maxf(dur, float((frames.back() as Dictionary).get("t", 0.0)))
	meta["duration"] = dur
	meta["player_name"] = gw.player.name if gw.player != null else ""
	if _saved_match:
		return ""
	_saved_match = true
	return write_disk(meta, frames, events)


static func write_disk(m_info: Dictionary, f_arr: Array, e_arr: Array) -> String:
	var dir_global: String = DIR_PATH
	var abs_dir: String = ProjectSettings.globalize_path(dir_global)
	DirAccess.make_dir_recursive_absolute(abs_dir)
	var tag: int = abs(int(Hash32.h2(f_arr.size(), e_arr.size(), int(Time.get_ticks_usec() % 1000000)))) % 100000
	var path: String = "%s/chr_%d_%05d.dfchr" % [dir_global, int(Time.get_unix_time_from_system()), tag]
	var tmp_path: String = path + ".tmp"
	var payload: PackedByteArray = var_to_bytes({"meta": m_info, "frames": f_arr, "events": e_arr}).compress(FileAccess.COMPRESSION_GZIP)
	var f: FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	if f == null:
		return ""
	f.store_buffer(payload)
	f.close()
	var abs_tmp: String = ProjectSettings.globalize_path(tmp_path)
	var abs_dst: String = ProjectSettings.globalize_path(path)
	if DirAccess.rename_absolute(abs_tmp, abs_dst) != OK:
		var f2: FileAccess = FileAccess.open(path, FileAccess.WRITE)
		if f2 == null:
			DirAccess.remove_absolute(abs_tmp)
			return ""
		f2.store_buffer(payload)
		f2.close()
		DirAccess.remove_absolute(abs_tmp)
	return path


static func list_records() -> Array:
	var out: Array = []
	var d := DirAccess.open(DIR_PATH)
	if d == null:
		return out
	d.list_dir_begin()
	var fn: String = d.get_next()
	while fn != "":
		if not d.current_is_dir() and fn.ends_with(".dfchr"):
			var rec: Dictionary = load_record(DIR_PATH + "/" + fn, true)
			if not rec.is_empty():
				out.append(rec)
		fn = d.get_next()
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int((a.get("meta", {}) as Dictionary).get("unix", 0)) > int((b.get("meta", {}) as Dictionary).get("unix", 0)))
	return out


static func load_record(path: String, meta_only: bool = false) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var raw: PackedByteArray = FileAccess.get_file_as_bytes(path)
	if raw.is_empty():
		return {}
	var dec: Variant = raw.decompress_dynamic(32 * 1024 * 1024, FileAccess.COMPRESSION_GZIP)
	if not (dec is PackedByteArray) or (dec as PackedByteArray).is_empty():
		return {}
	var data: Variant = bytes_to_var(dec as PackedByteArray)
	if not (data is Dictionary):
		return {}
	var dict := data as Dictionary
	var m_raw: Variant = dict.get("meta", {})
	var f_raw: Variant = dict.get("frames", [])
	var e_raw: Variant = dict.get("events", [])
	var m_dict: Dictionary = (m_raw as Dictionary) if m_raw is Dictionary else {}
	var f_arr: Array = (f_raw as Array) if f_raw is Array else []
	var e_arr: Array = (e_raw as Array) if e_raw is Array else []
	if meta_only:
		return {"path": path, "meta": m_dict, "n_frames": f_arr.size(), "n_events": e_arr.size()}
	dict["meta"] = m_dict
	dict["frames"] = f_arr
	dict["events"] = e_arr
	dict["path"] = path
	return dict


static func delete_record(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
