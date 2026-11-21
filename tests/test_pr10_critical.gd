extends SceneTree
## Integration regressions: execute real render, UI command, consent and carrier transitions.

const SeasonsS = preload("res://game/seasons.gd")
const ChronicleS = preload("res://game/chronicle.gd")
const DockS = preload("res://ui/ui24/navy_dock.gd")
var checks: int = 0
var failures: Array = []

class RenderWorld:
	extends GameWorld
	func _flush_territory(_force: bool = true, _dt: float = 0.0) -> void:
		pass


func _initialize() -> void:
	_run.call_deferred()


func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)


func world() -> GameWorld:
	var w := RenderWorld.new()
	w.data = WorldData.new(64, 64, 456)
	w.data.biome.fill(Biome.GRASS)
	w.data.owners.fill(2)
	w.rng = Rng.new(456)
	w.mil = Military.new(w)
	w.econ = Economy.new(w)
	w.army = Army.new(w)
	w.diplo = Diplomacy.new(w)
	w.defense = Defense.new(w)
	w.navy = Navy.new(w)
	w.naval = Naval.new(w)
	w.fx = FxLayer.new()
	w.fx.gw = w
	w.add_child(w.fx)
	w.terrain = TerrainView.new()
	w.add_child(w.terrain)
	w.seasons = SeasonsS.new()
	w.seasons.gw = w
	for id in range(1, 4):
		var c := Country.new()
		c.id = id
		c.name = "Player%d" % id
		c.is_player = true
		c.money = 80000
		c.metal = 1000
		c.titanium = 1000
		c.precious = 1000
		c.food = 1000
		c.fuel = 1000
		w.countries.append(c)
	w.player = w.countries[0]
	w.econ.deposits = [{"res":"metal", "cell":Vector2i(20,20), "left":500, "max":500, "mine":null, "obj":-1}]
	return w


func command(w: GameWorld, actor: int, method: String, args: Array, path: String = "diplo") -> void:
	var net := NetSession.new()
	net.gw = w
	net.local_slot = -1
	net._exec({"k":"call", "s":actor-1, "o":path, "m":method, "a":NetCodec.encode(args)})
	net.free()


func _run() -> void:
	_test_render_and_hash()
	_test_human_consent()
	_test_land_rejection_and_cancel()
	_test_land_modes_and_validation()
	_test_ship_purchase_command()
	_test_chronicle_ship()
	_test_carrier_loss()
	check(NetConfig.PROTO == 7 and Save.FORMAT == 1, "Protocol and save format stay pinned")
	check(NetConfig.version() != "%s/7" % Menus.VERSION, "Mixed pre-fix builds have a different compatibility identity")
	var result := {"checks":checks, "failures":failures, "passed":failures.is_empty()}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="),FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("PR10_CRITICAL ",JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)


func _test_render_and_hash() -> void:
	var a := world()
	var b := world()
	for w: GameWorld in [a,b]:
		w.net_driven = true
		w.game_time = 160.0
		w.nuke_zones = [{"cell":Vector2i(5,5)},{"cell":Vector2i(50,50)}]
		w.seasons.snow = 0.44
		w.player.food = 0
		w.player.money = 100
		for y in range(4,9):
			for x in range(4,9):
				w.data.owners[y * 64 + x] = 1
	var rng_before: int = a.rng.state
	var frozen: Dictionary = a.seasons.save_state().duplicate(true)
	for dt: float in [0.1, 1.0/30.0, 1.0/144.0, 0.2]:
		a._process(dt)
	check(a.seasons.save_state() == frozen, "FIX01 render does not mutate seasonal simulation state")
	check(a.rng.state == rng_before, "FIX01 render does not consume gameplay RNG")
	var fa := Facility.new()
	fa.id = 1
	fa.kind = Facility.Kind.FARM
	fa.country_id = 1
	fa.hp = 100.0
	fa.was_alive = true
	fa.cell = Vector2i(5,5)
	fa.size = Vector2i(2,2)
	a.mil.facilities.append(fa)
	var fb := Facility.new()
	fb.id = 1
	fb.kind = Facility.Kind.FARM
	fb.country_id = 1
	fb.hp = 100.0
	fb.was_alive = true
	fb.cell = fa.cell
	fb.size = fa.size
	b.mil.facilities.append(fb)
	for tick in 40:
		for w: GameWorld in [a,b]:
			w.game_time += NetConfig.SIM_DT
			w.seasons.step(NetConfig.SIM_DT)
		a._process(1.0/144.0)
		if tick % 10 == 0:
			a.econ._produce()
			b.econ._produce()
		if tick % 3 == 0:
			b._process(0.1)
	check(a.seasons.save_state() == b.seasons.save_state(), "FIX01 same ticks with different frame schedules have equal seasons")
	check(a.player.food == b.player.food and a.player.money == b.player.money, "FIX01 real farm production is frame-independent")
	check(a.player.food > 0 and a.player.money > 100, "FIX01 fixture actually produces food and farm income for compared player")
	check(NetHash.of(a) == NetHash.of(b), "FIX01 equal scheduled simulation has equal hash")
	var before_hash: String = NetHash.of(b)
	b.seasons.snow += 0.001
	check(NetHash.of(b) != before_hash, "FIX01 hash detects different authoritative snow")
	a.free()
	b.free()


func _test_human_consent() -> void:
	var w := world()
	command(w,1,"land_deal",[1,2,"buy","dep:20:20","",1000])
	check(w.data.get_owner_id(20,20) == 2 and w.player.money == 80000 and w.countries[1].money == 80000, "FIX02 human offer cannot move land or money without consent")
	check(w.diplo.t_offers.size() == 1, "FIX02 human transaction creates one pending proposal")
	if w.diplo.t_offers.is_empty():
		w.free()
		return
	var id: String = "t%d" % int(w.diplo.t_offers[0]["id"])
	var before_hash: String = NetHash.of(w)
	w.diplo.t_offers[0]["land"]["price"] = 1001
	check(NetHash.of(w) != before_hash, "FIX02 hash covers pending consent terms")
	w.diplo.t_offers[0]["land"]["price"] = 1000
	command(w,1,"land_deal",[1,2,"buy","dep:20:20","",1000])
	check(w.diplo.t_offers.size() == 1, "FIX02 duplicate proposal is bounded")
	command(w,3,"answer_as",[3,id,"accept"])
	command(w,1,"answer_as",[1,id,"accept"])
	check(w.data.get_owner_id(20,20) == 2 and w.diplo.t_offers.size() == 1, "FIX02 unrelated player and proposer cannot accept for recipient")
	command(w,2,"answer_as",[1,id,"accept"])
	check(w.data.get_owner_id(20,20) == 2, "FIX02 command cannot forge actor country")
	w.player = w.countries[1]
	var pending: Array = w.diplo.pending_for_player()
	check(pending.any(func(it:Dictionary)->bool:return it["id"] == id and it["kind"] == "land"), "FIX02 existing inbox exposes land proposal to recipient")
	command(w,2,"answer_as",[2,id,"accept"])
	check(w.data.get_owner_id(20,20) == 1 and w.countries[0].money == 79000 and w.countries[1].money == 81000, "FIX02 recipient acceptance executes agreed transaction")
	command(w,2,"answer_as",[2,id,"accept"])
	check(w.countries[0].money == 79000 and w.countries[1].money == 81000 and w.diplo.t_offers.is_empty(), "FIX02 replayed acceptance has no side effects")
	w.free()


func _test_land_rejection_and_cancel() -> void:
	for scenario: String in ["refuse","cancel","expire","owner","funds","war","invalid","boundary","construction","deposit"]:
		var w := world()
		command(w,1,"land_deal",[1,2,"buy","dep:20:20","",1000])
		if w.diplo.t_offers.is_empty():
			check(false,"FIX02 pending offer required for "+scenario)
			w.free()
			continue
		var id: String = "t%d" % int(w.diplo.t_offers[0]["id"])
		match scenario:
			"cancel":
				command(w,3,"land_deal",[3,2,"cancel",id,"",0])
				check(w.diplo.t_offers.size() == 1,"FIX02 foreign cancellation rejected")
				command(w,1,"land_deal",[1,2,"cancel",id,"",0])
			"expire":
				w.game_time = float(w.diplo.t_offers[0]["until"]) + 0.1
			"owner":
				w.data.owners[20*64+20] = 3
			"funds":
				w.countries[0].money = 0
			"war":
				w.diplo._set_rel(1,2,Diplomacy.Rel.WAR)
			"invalid":
				command(w,2,"answer_as",[2,id,"bogus"])
				check(w.diplo.t_offers.size() == 1,"FIX02 unknown action does not consume proposal")
			"boundary":
				w.data.owners[19*64+20] = 3
			"construction":
				w.data.add_flag(19,20,WorldData.F_OCCUPIED)
			"deposit":
				w.econ.deposits[0]["left"] = 499
		var money: Array = [w.countries[0].money,w.countries[1].money]
		var owner: int = w.data.get_owner_id(20,20)
		command(w,2,"answer_as",[2,id,"refuse" if scenario in ["refuse","invalid"] else "accept"])
		check(w.data.get_owner_id(20,20) == owner and money == [w.countries[0].money,w.countries[1].money],"FIX02 "+scenario+" prevents execution")
		w.free()


func _test_land_modes_and_validation() -> void:
	for mode: String in ["gift","sell","swap"]:
		var w := world()
		w.data.owners[20*64+20] = 1
		w.econ.deposits.append({"res":"metal", "cell":Vector2i(45,45), "left":500, "max":500, "mine":null, "obj":-1})
		command(w,1,"land_deal",[1,2,mode,"dep:20:20","dep:45:45",1000])
		check(w.data.get_owner_id(20,20) == 1 and w.player.money == 80000 and w.countries[1].money == 80000,"FIX02 "+mode+" requires recipient consent")
		if w.diplo.t_offers.is_empty():
			check(false,"FIX02 "+mode+" creates pending offer")
			w.free()
			continue
		var id: String = "t%d" % int(w.diplo.t_offers[0]["id"])
		var label: String = w.diplo.land.offer_text(w.diplo.t_offers[0])
		check(not label.contains("dep:") and label.contains("20,20"),"FIX02 inbox describes parcel without internal identifiers")
		command(w,2,"answer_as",[2,id,"accept"])
		check(w.data.get_owner_id(20,20) == 2 and (mode != "swap" or w.data.get_owner_id(45,45) == 1),"FIX02 accepted "+mode+" transfers agreed parcels")
		check(w.countries[0].money == (81000 if mode == "sell" else 80000) and w.countries[1].money == (79000 if mode == "sell" else 80000),"FIX02 "+mode+" moves only agreed money")
		w.free()
	var ai := world()
	ai.countries[1].is_player = false
	command(ai,1,"land_deal",[1,2,"buy","dep:20:20","",2000])
	check(ai.data.get_owner_id(20,20) == 1 and ai.diplo.t_offers.is_empty(),"FIX02 AI keeps immediate purchase with original valuation rules")
	ai.free()
	for args: Array in [[1,2,"buy"],["1",2,"buy","dep:20:20"],[1,2,"unknown","dep:20:20"],[1,2,"buy","dep:20:20","",-1],[1,2,"buy","dep:20:20","",1.5],[1,2,"buy","x".repeat(129)],[1,2,"buy","dep:20:20","",1000,"extra"]]:
		var w := world()
		command(w,1,"land_deal",args)
		check(w.data.get_owner_id(20,20) == 2 and w.diplo.t_offers.is_empty() and w.player.money == 80000,"FIX02 malformed command rejected before typed call")
		w.free()
	var roundtrip := world()
	command(roundtrip,1,"land_deal",[1,2,"buy","dep:20:20","",1000])
	var state: Dictionary = bytes_to_var(var_to_bytes(roundtrip.diplo.save_state()))
	roundtrip.diplo = Diplomacy.new(roundtrip)
	roundtrip.diplo.load_state(state)
	check(roundtrip.diplo.t_offers.size() == 1,"FIX02 pending proposal survives existing diplomacy serialization")
	if not roundtrip.diplo.t_offers.is_empty():
		var id: String = "t%d" % int(roundtrip.diplo.t_offers[0]["id"])
		command(roundtrip,2,"answer_as",[2,id,"accept"])
		check(roundtrip.data.get_owner_id(20,20) == 1,"FIX02 restored pending proposal executes through authorized command")
	roundtrip.free()


func _test_ship_purchase_command() -> void:
	var w := world()
	var ship := Ship.new()
	ship.id = 100
	ship.c = 1
	ship.hull = Ship.Hull.CARRIER
	w.navy.ships.append(ship)
	var ns := NetSession.new()
	ns.gw = w
	ns.local_slot = 0
	ns.is_host = true
	ns.in_match = true
	ns._enter_tree()
	var dock = DockS.new()
	dock.gw = w
	dock.sel_sid = ship.id
	dock._buy_carrier_ac(Aircraft.Type.DECK_JET)
	check(ns._pending.size() == 1,"FIX03 real NavyDock action queues a network command")
	dock.free() # Closing the UI before execution must be safe as well.
	for cmd: Dictionary in ns._pending:
		ns._exec(cmd)
	check(w.mil.air.aircraft.size() == 1,"FIX03 UI→encoded command→simulation purchases own deck jet")
	if not w.mil.air.aircraft.is_empty():
		check(w.mil.air.aircraft[0].carrier_id == ship.id and w.mil.air.aircraft[0].country_id == 1,"FIX03 purchase preserves carrier and owner links")
	var money: int = w.player.money
	ship.c = 2
	ns._exec({"k":"call","s":0,"o":"mil.air","m":"buy_carrier_plane","a":NetCodec.encode([ship,Aircraft.Type.HELI,w.player])})
	check(w.player.money == money,"FIX03 foreign carrier command cannot debit issuer")
	check(Ship.from_dict(ship.to_dict()).c == 2,"FIX03 Ship owner codec remains c")
	ns._exit_tree()
	ns.free()
	w.free()


func _test_chronicle_ship() -> void:
	var w := world()
	for cid in [1,2]:
		var s := Ship.new()
		s.id = cid
		s.c = cid
		s.pos = Vector2(cid*20,40)
		w.navy.ships.append(s)
	var ch = ChronicleS.new(w)
	ch.record_frame()
	check(ch.frames.size() == 1,"FIX03 Chronicle records frame with live mixed fleet")
	if not ch.frames.is_empty():
		check(ch.frames[0]["ships"][0][0] == 1 and ch.frames[0]["ships"][1][0] == 2,"FIX03 Chronicle uses each Ship.c")
		var path: String = ChronicleS.write_disk(ch.meta,ch.frames,ch.events)
		var restored: Dictionary = ChronicleS.load_record(path)
		check(not restored.is_empty() and restored["frames"][0]["ships"].size() == 2,"FIX03 fleet Chronicle survives compressed disk roundtrip")
	w.free()


func _test_carrier_loss() -> void:
	for scenario: String in ["deck","parked","heli","full","foreign","damaged","none","building","moving","destroyed"]:
		var w := world()
		var s := Ship.new()
		s.id = 100
		s.c = 1
		s.hull = Ship.Hull.CARRIER
		w.navy.ships.append(s)
		var base := Facility.new()
		base.id = 101
		base.kind = Facility.Kind.AIRFIELD
		base.country_id = 2 if scenario == "foreign" else 1
		base.hp = 100.0
		base.was_alive = true
		if scenario == "damaged":
			base.craters.append(Vector2.ZERO)
		elif scenario == "building":
			base.restore_t = 5.0
		elif scenario == "moving":
			base.moving = true
		elif scenario == "destroyed":
			base.obj_ids.append(0)
			w.obj_kind.append(GameWorld.KIND_BUILDING)
			w.obj_state.append(2)
		if scenario != "none":
			w.mil.facilities.append(base)
		if scenario == "full":
			for spot in Air.AIR_CAP:
				var parked := Aircraft.new()
				parked.id = spot+200
				parked.country_id = 1
				parked.base = base
				parked.spot = spot
				w.mil.air.aircraft.append(parked)
		var a := Aircraft.new()
		a.id = 300
		a.type = Aircraft.Type.DECK_JET if scenario == "deck" else Aircraft.Type.HELI
		a.carrier_id = s.id
		a.country_id = s.c
		a.h = 0.0 if scenario == "parked" else 8.0
		a.fuel = 500.0
		a.state = Aircraft.State.PARKED if scenario == "parked" else Aircraft.State.FLY
		w.mil.air.aircraft.append(a)
		w.navy._sink_carrier_wing(s)
		var divert: bool = scenario == "heli"
		check((a.state == Aircraft.State.RTB and a.base == base and a.spot >= 0) if divert else a.state == Aircraft.State.DEAD,"FIX04 safe carrier loss transition: "+scenario)
		check(a.country_id == 1 and a.carrier_id == 0,"FIX04 loss never changes owner or keeps dead carrier link: "+scenario)
		if a.state != Aircraft.State.DEAD:
			w.mil.air._step(a,0.1)
		w.free()
	var w := world()
	var s := Ship.new()
	s.id = 100
	s.c = 1
	s.hull = Ship.Hull.CARRIER
	w.navy.ships.append(s)
	var base := Facility.new()
	base.id = 101
	base.kind = Facility.Kind.AIRFIELD
	base.country_id = 1
	w.mil.facilities.append(base)
	for spot in range(Air.AIR_CAP-1):
		var parked := Aircraft.new()
		parked.base = base
		parked.spot = spot
		w.mil.air.aircraft.append(parked)
	var wing: Array[Aircraft] = []
	for id in [300,301]:
		var a := Aircraft.new()
		a.id = id
		a.type = Aircraft.Type.HELI
		a.carrier_id = s.id
		a.country_id = 1
		a.h = 8.0
		a.state = Aircraft.State.FLY
		w.mil.air.aircraft.append(a)
		wing.append(a)
	w.navy._sink_carrier_wing(s)
	check(wing[0].state == Aircraft.State.RTB and wing[0].spot == Air.AIR_CAP-1 and wing[1].state == Aircraft.State.DEAD,"FIX04 one remaining spot is reserved once in deterministic aircraft order")
	w.free()
