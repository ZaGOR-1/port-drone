class_name Nuclear
extends RefCounted



























const NPP_CAP: int = 40
const FUEL_S: float = 90.0
const FIRST_LOAD: float = 300.0
const CORE_HITS: int = 3
const U_MINE_RATE: float = 0.5
const U_PRICE: int = 110
const U_DEP: int = 240
const U_WEIGHT: float = 0.045
const U_MIN_DEP: int = 2
const U_RESERVE: int = 8
const PLUTONIUM_S: float = 45.0
const PLUTONIUM_PER_ICBM: int = 5
const SILO_BUILD_T: float = 45.0
const SILO_ARM_T: float = 30.0
const SILO_RELOAD_CD: float = 90.0
const NUKE_R_CELLS: int = 34
const NUKE_CRATER_R: int = 13
const NUKE_RAD_R: float = 168.0
const NUKE_RAD_DUR: float = 300.0
const NUKE_RAD_DPS: float = 9.0
const NUKE_FLIGHT_MIN: float = 12.0
const NUKE_SPEED: float = 95.0
const NUKE_APEX_BASE: float = 180.0
const NUKE_APEX_KM: float = 140.0
const TOWERS: Array = [Vector2i(8, 3), Vector2i(13, 3)]
const STYLE_SUFFIX: Array = ["", "_usa", "_west", "_asia"]
const AI_FROM: float = 540.0
const AI_MINE_FROM: float = 300.0
const AI_AD_R: float = 260.0
const FUND_WAIT: float = 120.0
const FUND_SKIP: float = 900.0





static func build_parts(gw: GameWorld, f: Facility, nw: Vector2i, country: Country) -> void:
	var suf: String = String(STYLE_SUFFIX[clampi(country.arch, 0, 3)]) if country != null else ""
	var core: String = "npp_core" + suf if gw.spr_index.has("npp_core" + suf) else "npp_core"
	var tower: String = "npp_tower" + suf if gw.spr_index.has("npp_tower" + suf) else "npp_tower"
	if not gw.spr_index.has(core):
		core = "power_plant"
	f.main_obj = gw.add_object(core, nw, GameWorld.KIND_BUILDING)
	f.obj_ids.append(f.main_obj)
	if gw.spr_index.has(tower):
		for off: Vector2i in TOWERS:
			var tid: int = gw.add_object(tower, nw + off, GameWorld.KIND_BUILDING)
			if tid >= 0:
				f.obj_ids.append(tid)
	f.u_fuel = FIRST_LOAD
	f.u_hits = 0



static func ambient(_gw: GameWorld, _f: Facility) -> void:
	pass




static func steam_points(gw: GameWorld, f: Facility) -> Array:
	var out: Array = []
	if output(gw, f) <= 0:
		return out
	for id in f.obj_ids:
		if id == f.main_obj or id < 0 or gw.obj_state[id] != 0:
			continue
		for p: Variant in _spr_info(gw, gw.spr_name[gw.obj_spr[id]]).get("steam", []):
			var q: Array = p
			out.append(gw.obj_origin(id) + Vector2(float(q[0]), float(q[1])))
	return out



static func refresh_look(gw: GameWorld, f: Facility) -> void:
	if f.main_obj < 0:
		return
	var nm: String = gw.spr_name[gw.obj_spr[f.main_obj]].trim_suffix("_dmg")
	var want: String = nm + "_dmg" if f.u_hits > 0 else nm
	if gw.spr_index.has(want):
		gw.set_obj_frame(f.main_obj, want, 0)


static func _spr_info(gw: GameWorld, nm: String) -> Dictionary:
	var at: Variant = gw.get("atlas_uran30")
	if at is SpriteAtlas and (at as SpriteAtlas).has(nm):
		return (at as SpriteAtlas).info(nm)
	return {}



static func beacon_px(gw: GameWorld, f: Facility) -> Vector2:
	if f.main_obj < 0:
		return f.center_px()
	var info: Dictionary = _spr_info(gw, gw.spr_name[gw.obj_spr[f.main_obj]])
	var b: Array = info.get("beacon", [])
	if b.is_empty():
		return f.center_px()
	var q: Array = b[0]
	return gw.obj_origin(f.main_obj) + Vector2(float(q[0]), float(q[1]))





static func parts(gw: GameWorld, f: Facility) -> Array:
	var core: bool = f.main_obj >= 0 and gw.obj_state[f.main_obj] == 0
	var towers: int = 0
	for id in f.obj_ids:
		if id != f.main_obj and id >= 0 and gw.obj_kind[id] == GameWorld.KIND_BUILDING and gw.obj_state[id] == 0:
			towers += 1
	return [core, towers]



static func output(gw: GameWorld, f: Facility) -> int:
	if f.restore_t > 0.0 or f.halted or f.u_fuel <= 0.0:
		return 0
	var p: Array = parts(gw, f)
	if not bool(p[0]):
		return 0
	var share: float = float(1 + int(p[1])) / float(1 + TOWERS.size())
	var hurt: float = 1.0 - 0.25 * float(clampi(f.u_hits, 0, CORE_HITS - 1))
	return roundi(float(NPP_CAP) * share * hurt)




static func burn(gw: GameWorld, dt: float) -> void:
	for f: Facility in gw.mil.facilities:
		if f.kind != Facility.Kind.NUCLEAR_PLANT or f.restore_t > 0.0 or f.halted:
			continue
		if f.main_obj < 0 or gw.obj_state[f.main_obj] != 0:
			continue
		var c: Country = gw.country_by_id(f.country_id)
		if c == null:
			continue
		if f.u_fuel > 0.0:
			f.u_fuel = maxf(0.0, f.u_fuel - dt)
		if f.u_fuel <= 0.0 and c.uranium >= 1:
			c.uranium -= 1
			f.u_fuel += FUEL_S
			if gw.econ != null:
				gw.econ.stat_res(c, "uranium", "npp", -1)
		elif f.u_fuel <= 0.0 and c.is_player and not bool(gw.econ._warned.get(f, false)):
			gw.econ._warned[f] = true
			gw.say(c, Loc.mk("АЭС остановлена: нет урана (шахта, рынок или импорт через порт)"))
		elif f.u_fuel > 0.0 and gw.econ._warned.has(f):
			gw.econ._warned.erase(f)
		if GameConfig.nukes and f.u_fuel > 0.0:
			var out: int = output(gw, f)
			if out > 0:
				var rate: float = float(out) / float(NPP_CAP)
				if GameConfig.creative:
					rate *= 4.0
				f.fuel_t += dt * rate
				var cap: int = gw.econ.res_cap(c, "plutonium") if gw.econ != null else 12
				while f.fuel_t >= PLUTONIUM_S:
					f.fuel_t -= PLUTONIUM_S
					if c.plutonium < cap:
						c.plutonium += 1
						if gw.econ != null:
							gw.econ.stat_res(c, "plutonium", "npp", 1)



static func status(gw: GameWorld, f: Facility) -> String:
	if f.restore_t > 0.0:
		return Loc.t("СТРОИТСЯ / РЕМОНТ")
	var p: Array = parts(gw, f)
	if not bool(p[0]):
		return Loc.t("ГЛАВНЫЙ КОРПУС РАЗРУШЕН — 0")
	if f.u_fuel <= 0.0:
		return Loc.t("НЕТ УРАНА — АЭС СТОИТ")
	var out: PackedStringArray = PackedStringArray()
	out.append(Loc.t("+%d ЭНЕРГИИ") % output(gw, f))
	if int(p[1]) < TOWERS.size():
		out.append(Loc.t("ГРАДИРЕН %d/%d") % [int(p[1]), TOWERS.size()])
	if f.u_hits > 0:
		out.append(Loc.t("КОРПУС %d/%d") % [CORE_HITS - f.u_hits, CORE_HITS])
	out.append(Loc.t("ТОПЛИВО %d С") % int(f.u_fuel))
	return " · ".join(out)



static func refresh_silo_look(gw: GameWorld, f: Facility) -> void:
	if f.main_obj < 0:
		return
	var want: String = "nuke_silo_arm" if f.nuke_state == 3 else "nuke_silo"
	if gw.spr_index.has(want):
		gw.set_obj_frame(f.main_obj, want, 0)


static func refresh_country_ready(gw: GameWorld, c: Country) -> void:
	if c == null:
		return
	var armed: bool = false
	for f: Facility in gw.mil.facilities:
		if f.kind == Facility.Kind.NUKE_SILO and f.country_id == c.id and gw.mil.alive(f) and f.nuke_state == 3:
			armed = true
			break
	c.nuke_ready = armed


static func silo_status(gw: GameWorld, f: Facility) -> String:
	if not GameConfig.nukes:
		return Loc.t("ЯДЕРНОЕ ОРУЖИЕ ОТКЛЮЧЕНО")
	if f.restore_t > 0.0:
		return Loc.t("СТРОИТСЯ / РЕМОНТ")
	if not gw.mil.alive(f):
		return Loc.t("ШАХТА РАЗРУШЕНА")
	match f.nuke_state:
		0:
			if f.nuke_cd > 0.0:
				return Loc.t("ПЕРЕЗАРЯДКА ШАХТЫ: %d С") % ceili(f.nuke_cd)
		1:
			var pct: int = clampi(roundi(f.nuke_prog * 100.0), 0, 99)
			return Loc.t("ПОДГОТОВКА МБР: %d %% (%d С)") % [pct, ceili(f.nuke_t)]
		2:
			return Loc.t("МБР СОБРАНА — ГОТОВА К ВЗВОДУ (%d С)") % int(SILO_ARM_T)
		4:
			var apct: int = clampi(roundi(f.nuke_prog * 100.0), 0, 99)
			return Loc.t("ПРИВЕДЕНИЕ В БОЕГОТОВНОСТЬ: %d %% (%d С)") % [apct, ceili(f.nuke_t)]
		3:
			return Loc.t("БОЕГОТОВНОСТЬ — МБР НА ДЕЖУРСТВЕ")
	return Loc.t("ШАХТА ПУСТА")


static func silo_build(gw: GameWorld, f: Facility, c: Country) -> String:
	if not GameConfig.nukes:
		return Loc.t("Ядерное оружие отключено")
	if f == null or c == null or f.kind != Facility.Kind.NUKE_SILO or f.country_id != c.id:
		return Loc.t("Нет шахты")
	if not gw.mil.alive(f):
		return Loc.t("Шахта повреждена")
	if f.nuke_state != 0:
		return Loc.t("В шахте уже идёт работа или есть МБР")
	if f.nuke_cd > 0.0:
		return Loc.t("Шахта на перезарядке: ещё %d с") % ceili(f.nuke_cd)
	var mcost: int = Military.COST_NUKE_MISSILE
	var rcost: Dictionary = Economy.res_cost("nuke_missile")
	if c.money < mcost:
		return Loc.t("Не хватает денег: нужно %d") % mcost
	if not c.has_res(rcost):
		return Loc.t("Не хватает: %s") % c.missing_res(rcost)
	c.money -= mcost
	if not (GameConfig.creative and c.is_player):
		c.pay_res(rcost)
	if gw.econ != null:
		gw.econ.stat_add(c, "spend", "missiles", mcost)
		if not (GameConfig.creative and c.is_player):
			for rk: String in rcost:
				gw.econ.stat_res(c, rk, "missiles", -int(rcost[rk]))
	f.nuke_state = 1
	f.nuke_t = 2.0 if GameConfig.creative and c.is_player else SILO_BUILD_T
	f.nuke_prog = 0.0
	gw.fx.spawn("build_spark", f.center_px(), 6)
	Sfx.play("ui_build", f.center_px())
	if c.is_player:
		gw.say(c, Loc.mk("Сборка МБР начата (%d с)", [ceili(f.nuke_t)]))
	gw.changed.emit()
	return ""


static func silo_arm(gw: GameWorld, f: Facility, c: Country) -> String:
	if not GameConfig.nukes:
		return Loc.t("Ядерное оружие отключено")
	if f == null or c == null or f.kind != Facility.Kind.NUKE_SILO or f.country_id != c.id:
		return Loc.t("Нет шахты")
	if not gw.mil.alive(f):
		return Loc.t("Шахта повреждена")
	if f.nuke_state == 4:
		return Loc.t("МБР уже приводится в боеготовность: %d с") % ceili(f.nuke_t)
	if f.nuke_state != 2:
		return Loc.t("Сначала соберите МБР")
	f.nuke_state = 4
	f.nuke_t = 1.5 if GameConfig.creative and c.is_player else SILO_ARM_T
	f.nuke_prog = 0.0
	gw.fx.spawn("build_spark", f.center_px(), 6)
	Sfx.play("radar_ping", f.center_px())
	if c.is_player:
		gw.say(c, Loc.mk("Приведение МБР в боеготовность: %d с", [ceili(f.nuke_t)]))
	gw.changed.emit()
	return ""


static func _finish_arm(gw: GameWorld, f: Facility, c: Country) -> void:
	f.nuke_state = 3
	f.nuke_t = 0.0
	f.nuke_prog = 1.0
	refresh_silo_look(gw, f)
	gw.fx.spawn("spark_burst", f.center_px(), 6)
	Sfx.ui("ui_alert")
	if c != null:
		var first: bool = not c.nuke_ready
		c.nuke_ready = true
		if first:
			gw.news_m(Loc.mk("ЯДЕРНАЯ ДЕРЖАВА: %s ПРИВЕЛА МБР В БОЕГОТОВНОСТЬ!", [Loc.name(c.name).to_upper()]), "alert_red")
		else:
			gw.news_m(Loc.mk("%s: ЕЩЁ ОДНА МБР НА БОЕВОМ ДЕЖУРСТВЕ", [Loc.name(c.name).to_upper()]), "amber")
		if c.is_player:
			gw.say(c, Loc.mk("МБР на боевом дежурстве! Другие страны получили предупреждение"))
	gw.changed.emit()


static func silo_launch(gw: GameWorld, f: Facility, c: Country, target: Vector2) -> String:
	if not GameConfig.nukes:
		return Loc.t("Ядерное оружие отключено")
	if f == null or c == null or f.kind != Facility.Kind.NUKE_SILO or f.country_id != c.id:
		return Loc.t("Нет шахты")
	if not gw.mil.alive(f):
		return Loc.t("Шахта повреждена")
	if f.nuke_state != 3:
		return Loc.t("МБР не в боеготовности")
	if gw.diplo != null:
		var bw: String = gw.diplo.strike_block_at(c.id, target, false)
		if bw != "":
			return bw
	f.nuke_state = 0
	f.nuke_t = 0.0
	f.nuke_prog = 0.0
	f.nuke_cd = 3.0 if GameConfig.creative and c.is_player else SILO_RELOAD_CD
	refresh_silo_look(gw, f)
	refresh_country_ready(gw, c)
	var m: Missile = gw.mil.launch_nuke(f, target)
	gw.nuke_warn_until = gw.game_time + 8.0
	gw.nuke_warn_target = target
	gw.news_m(Loc.mk("ЗАФИКСИРОВАН ПУСК ЯДЕРНОЙ МБР: %s!", [Loc.name(c.name).to_upper()]), "alert_red")
	Sfx.ui("ui_alert")
	if c.is_player and m != null:
		gw.say(c, Loc.mk("Ядерный пуск: время подлёта %d с", [ceili(m.time_left())]))
	gw.changed.emit()
	return ""


static func update_silos(gw: GameWorld, dt: float) -> void:
	for f: Facility in gw.mil.facilities:
		if f.kind != Facility.Kind.NUKE_SILO:
			continue
		if not gw.mil.alive(f):
			if f.nuke_state == 3 or f.nuke_state == 4:
				f.nuke_state = 0
				f.nuke_t = 0.0
				f.nuke_prog = 0.0
				refresh_silo_look(gw, f)
				refresh_country_ready(gw, gw.country_by_id(f.country_id))
			continue
		if f.nuke_cd > 0.0:
			f.nuke_cd = maxf(0.0, f.nuke_cd - dt)
		var is_cp: bool = GameConfig.creative and gw.player != null and f.country_id == gw.player.id
		if f.nuke_state == 1:
			var spd: float = 1.0 if gw.mil.has_power(f) else 0.4
			f.nuke_t = maxf(0.0, f.nuke_t - dt * spd)
			var total_t: float = 2.0 if is_cp else SILO_BUILD_T
			f.nuke_prog = clampf(1.0 - f.nuke_t / maxf(1.0, total_t), 0.0, 1.0)
			if f.nuke_t <= 0.0:
				f.nuke_state = 2
				f.nuke_prog = 1.0
				var c: Country = gw.country_by_id(f.country_id)
				if c != null and c.is_player:
					gw.say(c, Loc.mk("Ядерная шахта: МБР собрана — приведите в боеготовность"))
		elif f.nuke_state == 4:
			var aspd: float = 1.0 if gw.mil.has_power(f) else 0.5
			f.nuke_t = maxf(0.0, f.nuke_t - dt * aspd)
			var atot: float = 1.5 if is_cp else SILO_ARM_T
			f.nuke_prog = clampf(1.0 - f.nuke_t / maxf(1.0, atot), 0.0, 1.0)
			if f.nuke_t <= 0.0:
				_finish_arm(gw, f, gw.country_by_id(f.country_id))


static func update_rad_zones(gw: GameWorld, dt: float) -> void:
	if gw.nuke_zones.is_empty():
		return
	var prev_s: int = floori(gw.game_time - dt)
	var now_s: int = floori(gw.game_time)
	if prev_s == now_s:
		return
	for z: Dictionary in gw.nuke_zones:
		var until: float = float(z.get("until", -1.0))
		if gw.game_time > until:
			continue
		var c: Vector2i = z["cell"]
		var p: = Vector2(c.x * GameWorld.CELL + 2, c.y * GameWorld.CELL + 2)
		var r: float = float(z.get("r_rad", NUKE_RAD_R))
		var r2: float = r * r
		for u: Unit in gw.army.units:
			if not u.alive():
				continue
			if u.pos.distance_squared_to(p) > r2:
				continue
			var dmg: float = NUKE_RAD_DPS * (0.25 if u.dug else 1.0)
			gw.army._damage(u, dmg, int(z.get("by", 0)), p, true, 0)
		if gw._on_screen(p, r) and now_s % 2 == 0:
			var ox: float = float((Hash32.h2(c.x, now_s, 11) % 36) - 18)
			var oy: float = float((Hash32.h2(c.y, now_s, 29) % 24) - 12)
			gw.fx.spawn("smoke_loop", (p + Vector2(ox, oy)).round(), 5, gw.game_time + 2.5, true)


static func on_nuke_impact(gw: GameWorld, cell: Vector2i, by: int, victim: int, _value: int) -> void:
	var att: Country = gw.country_by_id(by)
	var vic: Country = gw.country_by_id(victim)
	if att != null:
		att.nukes_used += 1
		att.destroyed += 3000
	var anm: String = Loc.name(att.name).to_upper() if att != null else "?"
	var vnm: String = Loc.name(vic.name).to_upper() if vic != null else "?"
	if vic != null and by != victim:
		gw.news_m(Loc.mk("ЯДЕРНЫЙ УДАР: %s ПОРАЗИЛА %s!", [anm, vnm]), "alert_red")
	else:
		gw.news_m(Loc.mk("ЯДЕРНЫЙ ВЗРЫВ В СЕКТОРЕ (%d, %d)", [cell.x, cell.y]), "alert_red")
	if gw.diplo == null or att == null:
		return
	var defensive: bool = false
	if vic != null and gw.diplo.at_war(by, victim):
		defensive = int(gw.diplo.war_by.get(Diplomacy.key(by, victim), by)) != by
	var trd: Variant = gw.econ.get("trd") if gw.econ != null else null
	for c: Country in gw.countries:
		if c.id == by or c.eliminated or c.capital_id < 0:
			continue
		if c.id == victim:
			gw.diplo.add_opinion(c.id, by, -60)
			if not gw.diplo.at_war(by, victim):
				gw.diplo.declare_war(by, victim, "ядерный удар")
			continue
		var is_ally: bool = gw.diplo.allied(c.id, by) or (gw.diplo.ally != null and gw.diplo.ally.same(c.id, by))
		if is_ally and defensive:
			gw.diplo.add_opinion(c.id, by, -8)
		else:
			gw.diplo.add_opinion(c.id, by, -25 if defensive else -38)
			if not c.is_player and trd != null and trd.has_method("impose_sanction") and not gw.diplo.embargo_between(c.id, by):
				trd.impose_sanction(c.id, by, "", 480.0)
			if not c.is_player and not defensive and gw.diplo.get_opinion(c.id, by) < -20:
				gw.diplo.set_embargo(c.id, by, true)
			if not c.is_player and vic != null and not gw.diplo.at_war(c.id, victim) and c.money >= 2500 and (gw.diplo.allied(c.id, victim) or not defensive):
				gw.diplo.give_aid(c.id, victim, 800)


static func fuel_minutes(gw: GameWorld, c: Country) -> float:
	var n: int = 0
	var loaded: float = 0.0
	for f: Facility in gw.mil.facilities:
		if f.kind == Facility.Kind.NUCLEAR_PLANT and f.country_id == c.id and f.restore_t <= 0.0:
			n += 1
			loaded += f.u_fuel
	if n == 0:
		return 0.0
	return (loaded + float(c.uranium) * FUEL_S) / float(n) / 60.0





static func on_impact(gw: GameWorld, pr: Protect, cell: Vector2i, kind: int, r: int) -> void:
	if kind == Protect.HIT_BALLISTIC or kind == Protect.HIT_HYPER:
		return
	for f: Facility in gw.mil.facilities:
		if f.kind != Facility.Kind.NUCLEAR_PLANT or f.main_obj < 0 or gw.obj_state[f.main_obj] != 0 or f.restore_t > 0.0:
			continue
		var rr: Rect2i = gw.object_rect(f.main_obj)
		var qx: int = clampi(cell.x, rr.position.x, rr.end.x - 1)
		var qy: int = clampi(cell.y, rr.position.y, rr.end.y - 1)
		if (qx - cell.x) * (qx - cell.x) + (qy - cell.y) * (qy - cell.y) > r * r:
			continue
		if f.u_hits >= CORE_HITS - 1:
			continue
		f.u_hits += 1
		refresh_look(gw, f)
		pr._spare.append({"c": cell, "ids": PackedInt32Array([f.main_obj]), "t": gw.game_time + Protect.SPARE_TTL})
		gw.say(f.country_id, Loc.mk("АЭС: попадание в корпус (%d/%d), мощность −25 %%. Нужна ПВО", [f.u_hits, CORE_HITS]))





static func ai_tick(gw: GameWorld, ai: AiBots, c: Country) -> bool:
	if c.is_player or c.capital_id < 0 or gw.econ == null:
		return false
	var now: float = gw.game_time
	var P: Dictionary = ai.persona_of(c)
	var reserve: int = ai.treasury_reserve(c, P)
	var npps: Array[Facility] = []
	for f: Facility in gw.mil.facilities:
		if f.country_id == c.id and f.kind == Facility.Kind.NUCLEAR_PLANT:
			npps.append(f)

	for f: Facility in npps:
		var p: Array = parts(gw, f)
		var broken: bool = not bool(p[0]) or int(p[1]) == 0 or f.u_hits >= CORE_HITS - 1
		if broken and gw.mil.can_restore(f) and gw.mil.fire_block_left(f) <= 0.0 and c.money >= Military.restore_cost(f) + gw.mil.restore_buy(f, c) + 300:

			if gw.mil.restore(f, c, true):
				ai._stat(c, "npp_restore")
				return true

	if not npps.is_empty():
		var keep: int = U_RESERVE * npps.size()
		if c.uranium < keep:
			_want(gw, c, keep)

		if _cover(gw, ai, c, npps, reserve):
			return true

	var mk: int = Facility.Kind.URANIUM_MINE
	var mkey: String = "%d:%d" % [c.id, mk]
	var fm: Facility = null
	if now >= AI_MINE_FROM and now >= float(ai._skip.get(mkey, -1.0)) and ai._count(c, mk) < (2 if not npps.is_empty() else 1) and _free_own_deposit(gw, c):
		var mcost: Dictionary = Economy.build_cost(mk)
		var mf: int = _fund_take(gw, c, int(mcost["money"]), reserve)
		if mf < int(mcost["money"]):
			return false
		var mrc: Dictionary = Economy.res_cost("build_%d" % mk)
		if c.has_res(mrc):
			fm = _place_umine(gw, c)
		else:
			gw.econ.ai_blocked(c, mrc)
		if fm == null:
			ai._skip[mkey] = now + 180.0
			ai._stat(c, "umine_skip")
		else:
			c.money += mf
			gw.econ.u_fund.erase(c.id)
	if fm != null:
		c.money -= int(Economy.build_cost(mk)["money"])
		gw.econ.pay_build(c, mk)
		ai._after_build(c, fm, P)
		ai._stat(c, "umine")
		if gw.diplo != null:
			gw.diplo.dlog(c.id, "урановая шахта", "уран %d, АЭС %d" % [c.uranium, npps.size()], 0.0, ["eco_umine"])
		return true

	if GameConfig.nukes and now >= AI_FROM and _ai_nuke_tick(gw, ai, c, P, reserve, npps):
		return true

	var kind: int = Facility.Kind.NUCLEAR_PLANT
	var cost: Dictionary = Economy.build_cost(kind)
	var rc: Dictionary = Economy.res_cost("build_%d" % kind)
	var fund: int = int(gw.econ.u_fund.get(c.id, 0))
	if not ai_wants_npp(gw, ai, c, npps.size()):
		if fund > 0:
			c.money += fund
			gw.econ.u_fund.erase(c.id)
		return false
	fund = _fund_take(gw, c, int(cost["money"]), reserve)
	if fund < int(cost["money"]):
		return false
	var wkey: String = "%d:%d" % [c.id, kind]
	if not c.has_res(rc):


		if not ai._blocked.has(wkey):
			ai._blocked[wkey] = now
		if now - float(ai._blocked[wkey]) > FUND_WAIT:
			c.money += fund
			gw.econ.u_fund.erase(c.id)
			ai._blocked.erase(wkey)
			ai._skip[wkey] = now + FUND_SKIP
			ai._stat(c, "npp_fund_back")
			return false
	else:
		ai._blocked.erase(wkey)
	if not c.has_res(rc):
		gw.econ.ai_blocked(c, rc)
		if c.uranium < int(rc.get("uranium", 0)):
			_want(gw, c, int(rc.get("uranium", 0)) + U_RESERVE / 2)
		ai._stat(c, "npp_wait")
		return false
	c.money += fund
	gw.econ.u_fund.erase(c.id)
	var cap: City = gw.cities[c.capital_id]
	var f2: Facility = gw.mil.auto_place(kind, cap.center, c, cap.radius + 8, cap.radius + 90)
	if f2 == null and c.city_ids.size() > 1:
		var oc: City = gw.cities[c.city_ids[Hash32.h2(c.id, int(now), 302) % c.city_ids.size()]]
		f2 = gw.mil.auto_place(kind, oc.center, c, oc.radius + 8, oc.radius + 70)
	if f2 == null:
		gw.econ.u_fund[c.id] = mini(fund, c.money)
		c.money -= int(gw.econ.u_fund[c.id])
		ai._stat(c, "npp_no_site")
		return false
	c.money -= int(cost["money"])
	gw.econ.pay_build(c, kind)
	ai._after_build(c, f2, P)
	ai._stat(c, "npp")
	if gw.diplo != null:
		gw.diplo.dlog(c.id, "АЭС", "сеть %d/%d, уран %d" % [c.power_use, c.power_cap, c.uranium], float(NPP_CAP), ["eco_npp"])
	return true


static func ai_wants_npp(gw: GameWorld, ai: AiBots, c: Country, have: int) -> bool:
	if gw.game_time < AI_FROM or have >= (1 if c.power_use < 60 else 2):
		return false
	if gw.game_time < float(ai._skip.get("%d:%d" % [c.id, Facility.Kind.NUCLEAR_PLANT], -1.0)):
		return false
	if c.power_use < 18 or c.power_use + 8 <= c.power_cap:
		return false


	var need_u: int = int(Economy.BUILD_COST[Facility.Kind.NUCLEAR_PLANT]["uranium"])
	if c.uranium >= need_u or ai._count(c, Facility.Kind.URANIUM_MINE) > 0 or _free_own_deposit(gw, c):
		return true
	var sel: Country = gw.econ.best_seller(c, "uranium")
	if sel != null and gw.econ.surplus(sel, "uranium") >= need_u - c.uranium:
		return true
	var port: Facility = gw.econ.ports.port_of(c)
	return port != null and gw.econ.ports.ocean(port) and not gw.econ.ports.blocked(c)




static func _fund_take(gw: GameWorld, c: Country, target: int, reserve: int) -> int:
	var fund: int = int(gw.econ.u_fund.get(c.id, 0))
	if fund < target:
		var share: float = [0.2, 0.35, 0.5][GameConfig.diff_of(c)]
		var take: int = clampi(int(float(c.money - reserve / 2) * share), 0, target - fund)
		c.money -= take
		fund += take
		gw.econ.u_fund[c.id] = fund
	return fund




static func _place_umine(gw: GameWorld, c: Country) -> Facility:
	var mk: int = Facility.Kind.URANIUM_MINE
	for dp: Dictionary in gw.econ.deposits:
		if String(dp.get("res", "")) != "uranium" or dp["mine"] != null or int(dp.get("left", 0)) <= 0:
			continue
		var dc: Vector2i = dp["cell"]
		if gw.data.get_owner_id(dc.x, dc.y) != c.id:
			continue
		for r in 4:
			for dy in range(-r, r + 1):
				for dx in range(-r, r + 1):
					if maxi(absi(dx), absi(dy)) != r:
						continue
					var q: Vector2i = dc + Vector2i(dx, dy)
					if gw.mil.check_place(mk, Military.nw_for(mk, q), c, null, false) == "":
						return gw.mil.build(mk, q, c, null, true)
	return null


static func _want(gw: GameWorld, c: Country, n: int) -> void:
	var w: Dictionary = gw.econ.want.get(c.id, {})
	var wt: Dictionary = gw.econ.want_t.get(c.id, {})
	w["uranium"] = maxi(int(w.get("uranium", 0)), n)
	wt["uranium"] = gw.game_time
	gw.econ.want[c.id] = w
	gw.econ.want_t[c.id] = wt


static func _free_own_deposit(gw: GameWorld, c: Country) -> bool:
	for dp: Dictionary in gw.econ.deposits:
		if String(dp.get("res", "")) != "uranium" or dp["mine"] != null or int(dp.get("left", 0)) <= 0:
			continue
		var cell: Vector2i = dp["cell"]
		if gw.data.get_owner_id(cell.x, cell.y) == c.id:
			return true
	return false




static func _cover(gw: GameWorld, ai: AiBots, c: Country, npps: Array[Facility], reserve: int) -> bool:
	for f: Facility in npps:
		if f.restore_t > 0.0:
			continue
		var cp: Vector2 = f.center_px()
		var n: int = 0
		var has_pro: bool = false
		for a: Facility in gw.mil.facilities:
			if a.country_id != c.id or not Defense.is_ad(a.kind) or a.center_px().distance_to(cp) > AI_AD_R:
				continue
			n += 1
			has_pro = has_pro or a.kind == Facility.Kind.AD_PATRIOT
		if n >= 3 or (n >= 2 and (has_pro or GameConfig.diff_of(c) == 0)):
			continue
		var order: Array = [Facility.Kind.AD_SAM, Facility.Kind.AD_SPAAG] if n == 0 else [Facility.Kind.AD_PATRIOT, Facility.Kind.AD_SAM, Facility.Kind.AD_SPAAG]
		for kind: int in order:
			if n > 0 and not ai._ad_room(c, kind):
				continue
			var cost: Dictionary = Economy.build_cost(kind)
			if c.money < int(cost["money"]) + reserve / 2 or not c.has_res(Economy.res_cost("build_%d" % kind)):
				continue
			var nc: Vector2i = f.cell + f.size / 2
			var a2: Facility = gw.mil.auto_place(kind, nc, c, maxi(f.size.x, f.size.y) / 2 + 3, 50)
			if a2 == null:
				continue
			c.money -= int(cost["money"])
			gw.econ.pay_build(c, kind)
			ai._after_build(c, a2, ai.persona_of(c))
			ai._stat(c, "npp_ad")
			return true
	return false


static func _ai_nuke_tick(gw: GameWorld, ai: AiBots, c: Country, P: Dictionary, reserve: int, npps: Array[Facility]) -> bool:
	var now: float = gw.game_time
	var diff: int = GameConfig.diff_of(c)
	var any_foe_nuke: bool = false
	for o: Country in gw.countries:
		if o.id != c.id and not o.eliminated and o.nuke_ready:
			any_foe_nuke = true
			break
	# 1. Strategic ABM «Zaslon» (protect capital/NPPs when wealthy or nuke threat exists).
	var zk: int = Facility.Kind.AD_ZASLON
	var have_z: int = ai._count(c, zk)
	var want_z: int = (1 if diff >= 1 or any_foe_nuke else 0) + (1 if diff == 2 and any_foe_nuke else 0)
	if have_z < want_z and now >= float(ai._skip.get("%d:%d" % [c.id, zk], -1.0)):
		var zcost: Dictionary = Economy.build_cost(zk)
		var zrc: Dictionary = Economy.res_cost("build_%d" % zk)
		if c.money >= int(zcost["money"]) + reserve and c.has_res(zrc):
			var cap_c: Vector2i = gw.cities[c.capital_id].center
			var zf: Facility = gw.mil.auto_place(zk, cap_c, c, gw.cities[c.capital_id].radius + 5, gw.cities[c.capital_id].radius + 70)
			if zf == null:
				ai._skip["%d:%d" % [c.id, zk]] = now + 240.0
			else:
				c.money -= int(zcost["money"])
				gw.econ.pay_build(c, zk)
				ai._after_build(c, zf, P)
				return true

	# 2. Nuclear Silo construction + ICBM assembly + arming.
	var sk: int = Facility.Kind.NUKE_SILO
	var silos: Array[Facility] = []
	for f: Facility in gw.mil.facilities:
		if f.country_id == c.id and f.kind == sk:
			silos.append(f)
			if gw.mil.alive(f) and f.nuke_state == 2:
				if silo_arm(gw, f, c) == "":
					return true
	if not silos.is_empty():
		for sf: Facility in silos:
			if gw.mil.alive(sf) and sf.nuke_state == 0 and sf.nuke_cd <= 0.0 and c.plutonium >= PLUTONIUM_PER_ICBM:
				if c.money >= Military.COST_NUKE_MISSILE + reserve and c.has_res(Economy.res_cost("nuke_missile")):
					if silo_build(gw, sf, c) == "":
						return true
	elif not npps.is_empty() and (diff >= 1 or float(P["aggr"]) > 0.55) and now >= float(ai._skip.get("%d:%d" % [c.id, sk], -1.0)):
		var scost: Dictionary = Economy.build_cost(sk)
		var src: Dictionary = Economy.res_cost("build_%d" % sk)
		if c.money >= int(scost["money"]) + reserve and c.has_res(src):
			var cap_s: Vector2i = gw.cities[c.capital_id].center
			var f_silo: Facility = gw.mil.auto_place(sk, cap_s, c, gw.cities[c.capital_id].radius + 10, gw.cities[c.capital_id].radius + 95)
			if f_silo == null:
				ai._skip["%d:%d" % [c.id, sk]] = now + 240.0
			else:
				c.money -= int(scost["money"])
				gw.econ.pay_build(c, sk)
				ai._after_build(c, f_silo, P)
				return true

	# 3. Diplomatic nuclear halt pressure on weaker non-allied nuclear rivals.
	if gw.diplo != null and diff >= 1 and int(now) % 60 == (c.id * 11) % 60:
		for t: Country in gw.countries:
			if t.id == c.id or t.eliminated or t.capital_id < 0 or not t.nuke_ready:
				continue
			if gw.diplo.at_war(c.id, t.id) or gw.diplo.allied(c.id, t.id) or gw.diplo.is_subject(t.id):
				continue
			if gw.diplo.strength(c.id) > gw.diplo.strength(t.id) * 1.25 and gw.diplo.get_opinion(c.id, t.id) < 15:
				gw.diplo.demand(c.id, t.id, "halt_nukes", {"conseq": "embargo"})
				break

	# 4. Strategic nuclear launch when at war and losing or retaliating.
	if c.nuke_ready and not c.at_war.is_empty() and gw.diplo != null:
		for f2: Facility in silos:
			if not gw.mil.alive(f2) or f2.nuke_state != 3:
				continue
			var best_foe: Country = null
			for eid: int in c.at_war:
				var e: Country = gw.country_by_id(eid)
				if e == null or e.eliminated or e.capital_id < 0:
					continue
				if gw.diplo.allied(c.id, e.id):
					continue
				var losing: bool = gw.diplo.war_power(c.id) < gw.diplo.war_power(e.id) * 0.9 or e.nuke_ready or e.nukes_used > 0 or float(P["aggr"]) > 0.8
				if losing:
					best_foe = e
					break
			if best_foe != null:
				var tp: Vector2 = _ai_nuke_target(gw, best_foe)
				if tp != Vector2.INF and silo_launch(gw, f2, c, tp) == "":
					return true
	return false


static func _ai_nuke_target(gw: GameWorld, foe: Country) -> Vector2:
	var best_p: Vector2 = Vector2.INF
	var best_score: float = -1.0
	for f: Facility in gw.mil.facilities:
		if f.country_id != foe.id or not gw.mil.alive(f):
			continue
		var s: float = 1.0
		match f.kind:
			Facility.Kind.NUKE_SILO:
				s = 12.0
			Facility.Kind.AD_ZASLON, Facility.Kind.AIRFIELD, Facility.Kind.TEL, Facility.Kind.MISSILE_FACTORY:
				s = 7.0
			Facility.Kind.DRONE_PORT, Facility.Kind.BARRACKS, Facility.Kind.NUCLEAR_PLANT, Facility.Kind.AD_PATRIOT, Facility.Kind.AD_SAM:
				s = 5.0
			Facility.Kind.POWER_PLANT, Facility.Kind.REFINERY, Facility.Kind.NAVAL_BASE:
				s = 3.5
		if s > best_score:
			best_score = s
			best_p = f.center_px()
	if best_p != Vector2.INF:
		return best_p
	if foe.capital_id >= 0 and foe.capital_id < gw.cities.size():
		return Vector2(gw.cities[foe.capital_id].center * GameWorld.CELL)
	return Vector2.INF
