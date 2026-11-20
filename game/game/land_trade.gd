extends RefCounted

const DEAL_GAP_S: float = 90.0
const PARCEL_R_DEF: int = 7
const CELL_PX: int = 4

var dp
var gw
var _last_deal: Dictionary = {}


func _init(diplomacy) -> void:
	dp = diplomacy
	gw = diplomacy.gw if diplomacy != null else null


func list_parcels(owner_id: int) -> Array:
	var out: Array = []
	if gw == null or gw.data == null or owner_id <= 0:
		return out
	# 1. Non-capital cities owned by owner_id
	for city: City in gw.cities:
		if city.country_id != owner_id or city.kind == City.Kind.CAPITAL:
			continue
		var val: int = parcel_value({"kind": "city", "id": city.id, "level": city.level, "buildings": city.buildings})
		out.append({
			"key": "city:%d" % city.id,
			"kind": "city",
			"id": city.id,
			"name": Loc.name(city.name),
			"sub": Loc.t("Город ур.%d") % city.level,
			"cell": city.center,
			"r": clampi(city.radius, 7, 13),
			"value": val,
			"risky": true,
		})
	# 2. Ports / Naval Bases owned by owner_id
	if gw.mil != null:
		for f: Facility in gw.mil.facilities:
			if f.country_id != owner_id or not gw.mil.alive(f):
				continue
			if f.kind != Facility.Kind.PORT and f.kind != Facility.Kind.NAVAL_BASE:
				continue
			var pcell: Vector2i = f.cell + f.size / 2
			var nm: String = Loc.t("Порт") if f.kind == Facility.Kind.PORT else Loc.t("Морбаза")
			out.append({
				"key": "port:%d" % f.id,
				"kind": "port",
				"id": f.id,
				"name": nm,
				"sub": "%d,%d" % [pcell.x, pcell.y],
				"cell": pcell,
				"r": PARCEL_R_DEF,
				"value": parcel_value({"kind": "port", "fac_kind": f.kind}),
				"risky": false,
			})
	# 3. Resource deposits on owner_id land (outside city centers)
	if gw.econ != null:
		for dep: Dictionary in gw.econ.deposits:
			var dcell: Vector2i = dep.get("cell", Vector2i(-1, -1))
			if not gw.data.inside(dcell.x, dcell.y) or gw.data.get_owner_id(dcell.x, dcell.y) != owner_id:
				continue
			if int(dep.get("left", 0)) <= 0:
				continue
			var res: String = String(dep.get("res", "metal"))
			var rname: String = String(Economy.RES_NAMES.get(res, res))
			var mined: bool = dep.get("mine", null) != null
			out.append({
				"key": "dep:%d:%d" % [dcell.x, dcell.y],
				"kind": "deposit",
				"res": res,
				"left": int(dep.get("left", 0)),
				"cell": dcell,
				"r": PARCEL_R_DEF,
				"name": "%s (%s)" % [Loc.t("Залежь"), Loc.t(rname).to_lower()],
				"sub": Loc.t("осталось %d%s") % [int(dep.get("left", 0)), Loc.t(" · шахта") if mined else ""],
				"value": parcel_value({"kind": "deposit", "res": res, "left": int(dep.get("left", 0)), "mined": mined}),
				"risky": mined,
			})
	return out


func find_parcel(owner_id: int, key: String) -> Dictionary:
	for p: Dictionary in list_parcels(owner_id):
		if String(p["key"]) == key:
			return p
	return {}


func parcel_value(p: Dictionary) -> int:
	match String(p.get("kind", "")):
		"city":
			return 1400 + int(p.get("level", 1)) * 550 + int(p.get("buildings", 0)) * 80
		"port":
			return 1600 if int(p.get("fac_kind", Facility.Kind.PORT)) == Facility.Kind.NAVAL_BASE else 1100
		"deposit":
			var res: String = String(p.get("res", "metal"))
			var base: int = {"uranium": 1350, "precious": 1200, "titanium": 1000, "oil": 950}.get(res, 750)
			if bool(p.get("mined", false)):
				base += 400
			return base + mini(800, int(p.get("left", 0)) / 3)
	return 600


func propose_deal(from_id: int, to_id: int, mode: String, parcel_key: String, opt_key: String = "", price: int = 0) -> String:
	if gw == null or dp == null:
		return Loc.t("Дипломатия недоступна")
	if not valid_args([from_id, to_id, mode, parcel_key, opt_key, price]):
		return Loc.t("Некорректная сделка")
	if mode == "cancel":
		for i in dp.t_offers.size():
			var offer: Dictionary = dp.t_offers[i]
			if String(offer.get("kind", "")) == "land" and parcel_key == "t%d" % int(offer["id"]) and int(offer["from"]) == from_id and int(offer["to"]) == to_id:
				dp.t_offers.remove_at(i)
				dp.pending_changed.emit()
				return ""
		return Loc.t("Предложение устарело")
	return _execute_deal(from_id, to_id, mode, parcel_key, opt_key, price, false)


## Same existing command arguments; reject malformed values before NetSession ownership casts.
static func valid_args(args: Array) -> bool:
	if args.size() < 4 or args.size() > 6:
		return false
	if not (args[0] is int) or not (args[1] is int) or not (args[2] is String) or not (args[3] is String):
		return false
	if args[0] <= 0 or args[1] <= 0 or args[0] == args[1] or not args[2] in ["gift", "buy", "sell", "swap", "cancel"] or args[3].length() > 128:
		return false
	if args.size() > 4 and (not (args[4] is String) or args[4].length() > 128):
		return false
	return args.size() < 6 or (args[5] is int and args[5] >= 0 and args[5] <= 1000000000)


func _execute_deal(from_id: int, to_id: int, mode: String, parcel_key: String, opt_key: String, price: int, confirmed: bool) -> String:
	if gw == null or dp == null:
		return Loc.t("Дипломатия недоступна")
	var cf: Country = gw.country_by_id(from_id)
	var ct: Country = gw.country_by_id(to_id)
	if cf == null or ct == null or cf.eliminated or ct.eliminated or from_id == to_id:
		return Loc.t("Страны нет")
	if dp.at_war(from_id, to_id) or dp.truce_on(from_id, to_id):
		return Loc.t("Сделки с землёй возможны только в мирное время")
	var dk: String = "%d:%d" % [from_id, to_id]
	var left_s: float = float(_last_deal.get(dk, -999.0)) + DEAL_GAP_S - gw.game_time
	if left_s > 0.0 and cf.is_player:
		return Loc.t("Подождите ещё %d с перед новой сделкой") % ceili(left_s)

	match mode:
		"gift":
			var p: Dictionary = find_parcel(from_id, parcel_key)
			if p.is_empty():
				return Loc.t("Участок не найден")
			if not ct.is_player and dp.relation(to_id, from_id) < -55:
				return Loc.t("%s отказывается принимать дар") % Loc.name(ct.name)
			if ct.is_player and not confirmed:
				return _offer(from_id, to_id, mode, parcel_key, opt_key, 0)
			_execute_transfer(from_id, to_id, p)
			var gain: int = clampi(parcel_value(p) / 90, 8, 28)
			dp.add_opinion(from_id, to_id, gain)
			_last_deal[dk] = gw.game_time
			gw.news_m(Loc.mk("ДАР ЗЕМЛИ: %s → %s (%s)", [Loc.name(cf.name).to_upper(), Loc.name(ct.name).to_upper(), String(p["name"]).to_upper()]), "grass_light")
			_log_deal(from_id, Vector2i(p["cell"]), "%s передаёт %s стране %s" % [cf.name, String(p["name"]), ct.name])
			return ""
		"buy":
			var p2: Dictionary = find_parcel(to_id, parcel_key)
			if p2.is_empty():
				return Loc.t("Участок больше не принадлежит %s") % Loc.name(ct.name)
			var val: int = parcel_value(p2)
			var offer: int = maxi(val, price) if price > 0 else val
			if cf.money < offer:
				return Loc.t("Нужно %d денег") % offer
			if not ct.is_player:
				var rel_f: float = float(dp.relation(to_id, from_id)) * 0.0025
				var need: int = roundi(float(val) * clampf(1.22 - rel_f, 0.85, 1.55))
				if dp.relation(to_id, from_id) < -15 or offer < need:
					return Loc.t("%s отказывается: просит от %d") % [Loc.name(ct.name), maxi(need, offer)]
			if ct.is_player and not confirmed:
				return _offer(from_id, to_id, mode, parcel_key, opt_key, offer)
			cf.money -= offer
			ct.add_money(offer)
			if gw.econ != null:
				gw.econ.stat_add(cf, "spend", "trade", offer)
				gw.econ.stat_add(ct, "income", "trade", offer)
			_execute_transfer(to_id, from_id, p2)
			dp.add_opinion(from_id, to_id, 6)
			_last_deal[dk] = gw.game_time
			gw.news_m(Loc.mk("ПОКУПКА ЗЕМЛИ: %s КУПИЛА %s ЗА %d", [Loc.name(cf.name).to_upper(), String(p2["name"]).to_upper(), offer]), "grass_light")
			_log_deal(from_id, Vector2i(p2["cell"]), "%s купила %s за %d" % [cf.name, String(p2["name"]), offer])
			return ""
		"sell":
			var p3: Dictionary = find_parcel(from_id, parcel_key)
			if p3.is_empty():
				return Loc.t("Участок не найден")
			var val3: int = parcel_value(p3)
			var ask: int = price if price > 0 else roundi(float(val3) * 0.9)
			if not ct.is_player:
				var rel_f3: float = float(dp.relation(to_id, from_id)) * 0.002
				var max_pay: int = roundi(float(val3) * clampf(1.12 + rel_f3, 0.75, 1.45))
				if ct.money < ask:
					return Loc.t("У %s недостаточно денег (%d)") % [Loc.name(ct.name), ct.money]
				if ask > max_pay:
					return Loc.t("%s согласна максимум на %d") % [Loc.name(ct.name), mini(ct.money, max_pay)]
			elif ct.money < ask:
				return Loc.t("У покупателя нет %d денег") % ask
			if ct.is_player and not confirmed:
				return _offer(from_id, to_id, mode, parcel_key, opt_key, ask)
			ct.money -= ask
			cf.add_money(ask)
			if gw.econ != null:
				gw.econ.stat_add(ct, "spend", "trade", ask)
				gw.econ.stat_add(cf, "income", "trade", ask)
			_execute_transfer(from_id, to_id, p3)
			dp.add_opinion(from_id, to_id, 5)
			_last_deal[dk] = gw.game_time
			gw.news_m(Loc.mk("ПРОДАЖА ЗЕМЛИ: %s → %s (%s за %d)", [Loc.name(cf.name).to_upper(), Loc.name(ct.name).to_upper(), String(p3["name"]).to_upper(), ask]), "amber")
			_log_deal(from_id, Vector2i(p3["cell"]), "%s продала %s за %d" % [cf.name, String(p3["name"]), ask])
			return ""
		"swap":
			var p_give: Dictionary = find_parcel(from_id, parcel_key)
			var p_take: Dictionary = find_parcel(to_id, opt_key)
			if p_give.is_empty() or p_take.is_empty():
				return Loc.t("Выберите оба участка для обмена")
			var vg: int = parcel_value(p_give)
			var vt: int = parcel_value(p_take)
			if not ct.is_player:
				var need_v: int = roundi(float(vt) * (0.98 - float(dp.relation(to_id, from_id)) * 0.0015))
				if vg < need_v:
					return Loc.t("%s считает обмен неравноценным (%d < %d)") % [Loc.name(ct.name), vg, need_v]
			if ct.is_player and not confirmed:
				return _offer(from_id, to_id, mode, parcel_key, opt_key, 0)
			_execute_transfer(from_id, to_id, p_give)
			_execute_transfer(to_id, from_id, p_take)
			dp.add_opinion(from_id, to_id, 8)
			_last_deal[dk] = gw.game_time
			gw.news_m(Loc.mk("ОБМЕН ЗЕМЛЁЙ: %s (%s) ⇄ %s (%s)", [Loc.name(cf.name).to_upper(), String(p_give["name"]), Loc.name(ct.name).to_upper(), String(p_take["name"])]), "intercept_cyan")
			_log_deal(from_id, Vector2i(p_take["cell"]), "Обмен: %s ⇄ %s" % [String(p_give["name"]), String(p_take["name"])])
			return ""
	return Loc.t("Неизвестная сделка")


func _signature(owner: int, key: String) -> String:
	var p: Dictionary = find_parcel(owner, key)
	if p.is_empty():
		return ""
	var cell: Vector2i = p["cell"]
	var radius: int = int(p["r"])
	var cells := PackedByteArray()
	for y in range(maxi(1, cell.y - radius), mini(gw.data.h - 1, cell.y + radius + 1)):
		for x in range(maxi(1, cell.x - radius), mini(gw.data.w - 1, cell.x + radius + 1)):
			cells.append(gw.data.get_owner_id(x, y))
			cells.append(gw.data.flags[y * gw.data.w + x])
	var facilities: Array = []
	if gw.mil != null:
		for f: Facility in gw.mil.facilities:
			var host: Facility = f.parent if f.parent != null else f
			var center: Vector2i = host.cell + host.size / 2
			if f.country_id == owner and absi(center.x - cell.x) <= radius and absi(center.y - cell.y) <= radius:
				facilities.append([f.id, f.kind, center])
	var h := HashingContext.new()
	h.start(HashingContext.HASH_SHA256)
	# Do not hash localized names: clients may use different UI languages.
	h.update(var_to_bytes([key, cell, radius, int(p["value"]), int(p.get("left", 0)), facilities]))
	h.update(cells)
	return h.finish().hex_encode()


func _offer(from_id: int, to_id: int, mode: String, key: String, opt: String, price: int) -> String:
	for old: Dictionary in dp.t_offers:
		if String(old.get("kind", "")) == "land" and gw.game_time <= float(old["until"]) and Diplomacy.key(int(old["from"]), int(old["to"])) == Diplomacy.key(from_id, to_id):
			return Loc.t("Предложение уже ожидает ответа")
	var owner: int = to_id if mode == "buy" else from_id
	var terms: Dictionary = {"mode":mode, "key":key, "opt":opt, "price":price,
		"sig":_signature(owner, key), "opt_sig":_signature(to_id, opt) if mode == "swap" else ""}
	dp.t_offers.append({"id":dp._dem_id, "from":from_id, "to":to_id, "kind":"land", "until":gw.game_time + DEAL_GAP_S, "land":terms})
	dp._dem_id += 1
	dp.pending_changed.emit()
	if gw.player != null and gw.player.id == to_id:
		gw.offer_received.emit()
	return ""


func offer_text(offer: Dictionary) -> String:
	var terms: Dictionary = offer["land"]
	var mode: String = String(terms["mode"])
	var owner: int = int(offer["to"]) if mode == "buy" else int(offer["from"])
	var parcel: Dictionary = find_parcel(owner, String(terms["key"]))
	var description: String = String(parcel.get("name", Loc.t("Участок недоступен")))
	if not parcel.is_empty():
		var cell: Vector2i = parcel["cell"]
		description += " (%d,%d)" % [cell.x, cell.y]
	if mode == "swap":
		var other: Dictionary = find_parcel(int(offer["to"]), String(terms["opt"]))
		description += " ⇄ " + String(other.get("name", Loc.t("Участок недоступен")))
		if not other.is_empty():
			var cell: Vector2i = other["cell"]
			description += " (%d,%d)" % [cell.x, cell.y]
	elif mode in ["buy", "sell"]:
		description += " · %d" % int(terms["price"])
	return "%s: %s" % [Loc.t({"gift":"ДАР ЗЕМЛИ", "buy":"ПОКУПКА ЗЕМЛИ", "sell":"ПРОДАЖА ЗЕМЛИ", "swap":"ОБМЕН ЗЕМЛЁЙ"}.get(mode, "ЗЕМЛЯ")), description]


## Only the recipient's existing answer_as command may exercise this one-shot consent.
func answer(who: int, id: int, act: String) -> String:
	if act not in ["accept", "refuse"]:
		return Loc.t("Неизвестный ответ")
	for i in dp.t_offers.size():
		var offer: Dictionary = dp.t_offers[i]
		if String(offer.get("kind", "")) != "land" or int(offer["id"]) != id:
			continue
		if int(offer["to"]) != who:
			return Loc.t("Нет такого")
		dp.t_offers.remove_at(i)
		dp.pending_changed.emit()
		if act == "refuse":
			return ""
		if gw.game_time > float(offer["until"]):
			return Loc.t("Предложение устарело")
		var terms: Dictionary = offer["land"]
		var from_id: int = int(offer["from"])
		var owner: int = who if String(terms["mode"]) == "buy" else from_id
		if String(terms["sig"]) == "" or _signature(owner, String(terms["key"])) != String(terms["sig"]) or (String(terms["mode"]) == "swap" and _signature(who, String(terms["opt"])) != String(terms["opt_sig"])):
			return Loc.t("Условия сделки изменились")
		return _execute_deal(from_id, who, String(terms["mode"]), String(terms["key"]), String(terms["opt"]), int(terms["price"]), true)
	return Loc.t("Предложение устарело")


func _execute_transfer(giver: int, taker: int, parcel: Dictionary) -> void:
	if gw == null or gw.data == null:
		return
	var cell: Vector2i = parcel["cell"]
	var r: int = int(parcel.get("r", PARCEL_R_DEF))
	var kind: String = String(parcel.get("kind", "deposit"))
	if kind == "city":
		var city_id: int = int(parcel.get("id", -1))
		if city_id >= 0 and city_id < gw.cities.size():
			var prev_q: bool = gw.capture_quiet
			gw.capture_quiet = true
			gw.capture_city(gw.cities[city_id], taker)
			gw.capture_quiet = prev_q
		gw.mark_ceded_land(cell, taker)
	else:
		# Transfer owned cells around deposit/port cleanly without touching city tiles
		var d: WorldData = gw.data
		var moved: Array[Vector2i] = []
		for y in range(maxi(1, cell.y - r), mini(d.h - 1, cell.y + r + 1)):
			for x in range(maxi(1, cell.x - r), mini(d.w - 1, cell.x + r + 1)):
				var idx: int = y * d.w + x
				if d.owners[idx] != giver or d.has_flag(x, y, WorldData.F_CITY):
					continue
				d.owners[idx] = taker
				if (x + y) % 3 == 0:
					moved.append(Vector2i(x, y))
		d.owners_dirty = true
		gw.mark_ceded_land(cell, taker)
		if gw.top != null and gw.top.has_method("flash_cells") and not moved.is_empty():
			gw.top.flash_cells(moved)
		gw._checkpoints_dirty = true
		if gw.mil != null:
			for f: Facility in gw.mil.facilities:
				if f.country_id != giver:
					continue
				var host: Facility = f.parent if f.parent != null else f
				var hc: Vector2i = host.cell + host.size / 2
				if d.inside(hc.x, hc.y) and d.get_owner_id(hc.x, hc.y) == taker:
					f.country_id = taker
					f.queued.clear()
		if gw.econ != null:
			gw.econ.draw_ver += 1
		if gw.navy != null and gw.navy.has_method("_ensure_nav"):
			gw.navy._ensure_nav()

	_withdraw_forces(giver, cell, r + 4)
	gw.changed.emit()


func _withdraw_forces(giver: int, center_cell: Vector2i, rad_cells: int) -> void:
	if gw == null or gw.data == null:
		return
	var cw: float = float(CELL_PX)
	var center_px: Vector2 = Vector2(center_cell) * cw
	var rad_px: float = float(rad_cells) * cw

	# 1. Return ground units in transferred parcel home toward giver's capital/city
	var home_px: Vector2 = Vector2(-1, -1)
	var gc: Country = gw.country_by_id(giver)
	if gc != null and gc.capital_id >= 0 and gc.capital_id < gw.cities.size():
		home_px = Vector2(gw.cities[gc.capital_id].center) * cw
	elif gc != null and not gc.city_ids.is_empty():
		home_px = Vector2(gw.cities[int(gc.city_ids[0])].center) * cw

	if home_px.x >= 0.0 and gw.army != null:
		var home_cell := Vector2i(int(home_px.x / cw), int(home_px.y / cw))
		for u: Unit in gw.army.units:
			if u.country_id != giver or u.hp <= 0.0:
				continue
			if u.pos.distance_to(center_px) <= rad_px:
				if u.home != null and gw.mil != null and gw.mil.alive(u.home) and u.home.country_id == giver:
					u.path = PackedVector2Array([u.home.center_px()])
				else:
					u.path = PackedVector2Array([Vector2(home_cell) * cw])
				u.pi = 0
				u.state = Unit.State.MOVE

	# 2. Relocate aircraft parked at transferred facilities safely to another friendly airfield/airport
	if gw.mil != null and gw.mil.air != null:
		var alt_base: Facility = null
		for af: Facility in gw.mil.facilities:
			if af.country_id == giver and gw.mil.alive(af) and (af.kind == Facility.Kind.AIRFIELD or af.kind == Facility.Kind.AIRPORT):
				alt_base = af
				break
		for ac: Aircraft in gw.mil.air.aircraft:
			if ac.country_id != giver or ac.state == Aircraft.State.DEAD:
				continue
			if ac.pos.distance_to(center_px) <= rad_px or (ac.base != null and ac.base.country_id != giver):
				if alt_base != null:
					ac.base = alt_base
					ac.spot = gw.mil.air._free_spot(alt_base, ac.type == Aircraft.Type.BOMBER)
					if not ac.airborne():
						ac.pos = alt_base.center_px()
				else:
					# Safe evacuation refund if no home airfield remains
					if gc != null:
						gc.add_money(Air.sell_refund(ac.type))
					ac.state = Aircraft.State.DEAD


func _log_deal(cid: int, cell: Vector2i, desc: String) -> void:
	if gw != null and gw.get("chronicle") != null and gw.chronicle != null:
		gw.chronicle.log_event("land", cid, cell, desc)
