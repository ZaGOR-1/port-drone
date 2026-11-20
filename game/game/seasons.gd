extends RefCounted

enum Season { SPRING = 0, SUMMER = 1, AUTUMN = 2, WINTER = 3 }

const NAMES: Array = ["Весна", "Лето", "Осень", "Зима"]
const SHORT: Array = ["ВЕСНА", "ЛЕТО", "ОСЕНЬ", "ЗИМА"]
const ICONS: Array = ["icon_season_0", "icon_season_1", "icon_season_2", "icon_season_3"]
const SEASON_S: float = 120.0

var gw: GameWorld
var season: int = Season.SPRING
var year: int = 1
var phase: float = 0.0
var snow: float = 0.0
var rain: float = 0.0
var wind: Vector2 = Vector2(12.0, 4.0)
var nuclear_chill: float = 0.0
var _last_season: int = -1


func reset() -> void:
	season = Season.SPRING
	year = 1
	phase = 0.0
	snow = 0.0
	rain = 0.0
	wind = Vector2(12.0, 4.0)
	nuclear_chill = 0.0
	_last_season = Season.SPRING


func step(dt: float) -> void:
	if gw == null:
		return
	var gt: float = maxf(0.0, gw.game_time)
	var yr_s: float = SEASON_S * 4.0
	year = 1 + int(gt / yr_s)
	var yr_t: float = fposmod(gt, yr_s)
	season = clampi(int(yr_t / SEASON_S), 0, 3)
	phase = clampf(fposmod(yr_t, SEASON_S) / SEASON_S, 0.0, 1.0)

	var nz: int = gw.nuke_zones.size()
	nuclear_chill = minf(0.75, float(nz) * 0.25) if nz >= 2 else minf(0.22, float(nz) * 0.11)

	var snow_tgt: float = 0.0
	match season:
		Season.SPRING:
			snow_tgt = 0.0 if year == 1 else lerpf(0.75, 0.0, minf(1.0, phase * 2.8))
		Season.SUMMER:
			snow_tgt = 0.0
		Season.AUTUMN:
			snow_tgt = clampf((phase - 0.72) / 0.28, 0.0, 1.0) * 0.35
		Season.WINTER:
			snow_tgt = 0.35 + minf(1.0, phase * 2.2) * 0.65
	snow_tgt = maxf(snow_tgt, nuclear_chill)
	snow = move_toward(snow, snow_tgt, dt * 0.12)

	var wave: float = 0.5 + 0.5 * sin(gt * 0.055 + 0.7)
	var rain_tgt: float = 0.0
	match season:
		Season.SPRING:
			rain_tgt = lerpf(0.0, 0.55, maxf(0.0, (wave - 0.45) / 0.55))
		Season.SUMMER:
			rain_tgt = lerpf(0.0, 0.35, maxf(0.0, (wave - 0.72) / 0.28))
		Season.AUTUMN:
			rain_tgt = lerpf(0.2, 0.78, wave)
		Season.WINTER:
			rain_tgt = lerpf(0.35, 0.85, wave)
	if nuclear_chill >= 0.4:
		rain_tgt = maxf(rain_tgt, 0.45)
	rain = move_toward(rain, rain_tgt, dt * 0.18)

	wind = Vector2(lerpf(10.0, 26.0, 0.5 + 0.5 * sin(gt * 0.03)), lerpf(3.0, 12.0, rain))

	if _last_season < 0:
		_last_season = season
	elif _last_season != season:
		_last_season = season
		if season == Season.WINTER:
			gw.news_m(Loc.t("ЗИМА: РЕКИ ЗАМЕРЗАЮТ · УРОЖАЙ ФЕРМ −50%"), "intercept_cyan")
		elif season == Season.SPRING:
			gw.news_m(Loc.t("ВЕСНА: СНЕГ ТАЕТ · УРОЖАЙ ФЕРМ ВОССТАНОВЛЕН"), "grass_light")
		elif season == Season.SUMMER:
			gw.news_m(Loc.t("ЛЕТО: ЯСНАЯ ПОГОДА"), "grass_light")
		elif season == Season.AUTUMN:
			gw.news_m(Loc.t("ОСЕНЬ: ПОХОЛОДАНИЕ И ДОЖДИ"), "amber")

	apply_terrain_uniforms()


func is_winter() -> bool:
	return season == Season.WINTER or snow >= 0.45


func farm_mul() -> float:
	return 0.5 if is_winter() else 1.0


func name_text() -> String:
	if nuclear_chill >= 0.5:
		return Loc.t("Яд. зима")
	return Loc.t(String(NAMES[season]))


func icon_name() -> String:
	if nuclear_chill >= 0.5:
		return String(ICONS[Season.WINTER])
	return String(ICONS[season])


func apply_terrain_uniforms() -> void:
	if gw == null or gw.terrain == null:
		return
	var mat := gw.terrain.material as ShaderMaterial
	if mat == null:
		return
	mat.set_shader_parameter("season_f", float(season))
	mat.set_shader_parameter("phase_f", phase)
	mat.set_shader_parameter("snow_f", snow)
	mat.set_shader_parameter("rain_f", rain)
	mat.set_shader_parameter("nuke_chill_f", nuclear_chill)
	if gw.data != null:
		mat.set_shader_parameter("world_size", Vector2(gw.data.w, gw.data.h))


func save_state() -> Dictionary:
	return {
		"season": season, "year": year, "phase": phase,
		"snow": snow, "rain": rain, "wind_x": wind.x, "wind_y": wind.y,
		"nuclear_chill": nuclear_chill, "last_season": _last_season,
	}


func load_state(d: Dictionary) -> void:
	season = clampi(int(d.get("season", Season.SPRING)), 0, 3)
	year = maxi(1, int(d.get("year", 1)))
	phase = clampf(float(d.get("phase", 0.0)), 0.0, 1.0)
	snow = clampf(float(d.get("snow", 0.0)), 0.0, 1.0)
	rain = clampf(float(d.get("rain", 0.0)), 0.0, 1.0)
	wind = Vector2(float(d.get("wind_x", 12.0)), float(d.get("wind_y", 4.0)))
	nuclear_chill = clampf(float(d.get("nuclear_chill", 0.0)), 0.0, 1.0)
	_last_season = int(d.get("last_season", season))
	apply_terrain_uniforms()
