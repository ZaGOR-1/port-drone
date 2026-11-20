extends Node2D

const DROP_N: int = 84
const TRACK_N: int = 160

var gw: GameWorld
var _drops: Array[Vector2] = []
var _track_pos: PackedVector2Array = PackedVector2Array()
var _track_age: PackedFloat32Array = PackedFloat32Array()
var _track_head: int = 0
var _track_t: float = 0.0


static func make(world: GameWorld) -> Node2D:
	var n: Node2D = (load("res://world/weather_fx.gd") as GDScript).new()
	n.name = "WeatherFx"
	n.set("gw", world)
	return n


func _ready() -> void:
	z_index = 2
	_drops.resize(DROP_N)
	for i in DROP_N:
		_drops[i] = Vector2(float((i * 73) % 1000) * 0.001, float((i * 197) % 1000) * 0.001)
	_track_pos.resize(TRACK_N)
	_track_age.resize(TRACK_N)
	for i in TRACK_N:
		_track_age[i] = -1.0


func _process(delta: float) -> void:
	if gw == null or gw.seasons == null or gw.camera == null or gw.data == null:
		return
	var winter: bool = gw.seasons.is_winter()
	var active_precip: bool = gw.seasons.rain > 0.22 or winter
	if active_precip:
		var wv: Vector2 = gw.seasons.wind
		var spd_mul: float = 0.14 if winter else 0.55
		for i in DROP_N:
			var p: Vector2 = _drops[i]
			p.x = fposmod(p.x + wv.x * 0.002 * delta, 1.0)
			p.y = fposmod(p.y + (0.28 + float(i % 5) * 0.05) * spd_mul * delta, 1.0)
			_drops[i] = p

	# Update fading unit snow tracks in winter
	var any_tracks: bool = false
	for i in TRACK_N:
		if _track_age[i] > 0.0:
			_track_age[i] -= delta
			any_tracks = true
	if winter and gw.army != null and GameConfig.fx_level >= 1:
		_track_t += delta * gw.time_scale
		if _track_t >= 0.22:
			_track_t = 0.0
			var added: int = 0
			for u: Unit in gw.army.units:
				if u.hp <= 0 or u.state != Unit.State.MOVE:
					continue
				_track_pos[_track_head] = u.pos
				_track_age[_track_head] = 6.0
				_track_head = (_track_head + 1) % TRACK_N
				any_tracks = true
				added += 1
				if added >= 8:
					break

	visible = active_precip or any_tracks
	if visible:
		queue_redraw()


func _draw() -> void:
	if gw == null or gw.seasons == null or gw.camera == null:
		return
	# Draw unit snow tracks first
	var tc: Color = Color(0.76, 0.83, 0.90, 0.55)
	for i in TRACK_N:
		var age: float = _track_age[i]
		if age > 0.0:
			tc.a = clampf(age / 6.0, 0.0, 1.0) * 0.55
			var p: Vector2 = _track_pos[i]
			draw_rect(Rect2(p - Vector2(1.0, 0.5), Vector2(2.0, 1.0)), tc)

	# Draw precipitation droplets/snowflakes around camera view
	if GameConfig.fx_level <= 0:
		return
	var r: float = gw.seasons.rain
	var winter: bool = gw.seasons.is_winter()
	if not winter and r <= 0.22:
		return
	var vp: Vector2 = get_viewport_rect().size
	var zoom: float = maxf(0.15, gw.camera.zoom.x)
	var half: Vector2 = vp * (0.55 / zoom)
	var center: Vector2 = gw.camera.position
	var count: int = mini(DROP_N, int(float(DROP_N) * clampf(r, 0.25, 1.0)))
	var col: Color = Color(0.95, 0.98, 1.0, 0.72) if winter else Color(0.65, 0.82, 0.98, 0.38)
	var dv: Vector2 = Vector2(gw.seasons.wind.x * 0.06, 2.2) if winter else Vector2(gw.seasons.wind.x * 0.14, 5.5)
	for i in count:
		var wp: Vector2 = center + Vector2((_drops[i].x - 0.5) * half.x * 2.0, (_drops[i].y - 0.5) * half.y * 2.0)
		if winter:
			var sz: float = 1.5 if (i % 3 == 0) else 1.0
			draw_rect(Rect2(wp, Vector2(sz, sz)), col)
		else:
			draw_line(wp, wp + dv, col, 1.0)
