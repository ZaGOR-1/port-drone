extends SceneTree
## Real Main/HUD, UI action, command execution, disk save/load and fixed-tick continuation.

const DipSheetS = preload("res://ui/ui24/dip_sheet.gd")
var checks: int = 0
var failures: Array = []
var args: Dictionary = {}


func _initialize() -> void:
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--") and a.contains("="):
			args[a.get_slice("=",0).trim_prefix("--")] = a.substr(a.find("=")+1)
	_run.call_deferred()


func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)


func frozen(main: Node) -> void:
	main.set_process(false)
	main.net.set_process(false)
	main.world.set_process(false)
	main.world.time_scale = 0.0
	main._paused = true


func execute_pending(net: NetSession) -> void:
	var commands: Array = net._pending
	net._pending = []
	for cmd: Dictionary in commands:
		net._exec(cmd)


func _run() -> void:
	# Never write an existing player's save directory when invoked outside the test runner.
	var user: String = OS.get_user_data_dir()
	if not (user.contains("df_pr10_critical_") or user.contains("phase5_stabilization")):
		push_error("Run this save test through its isolated Python runner")
		quit(2)
		return
	seed(91234)
	var main: Node = (load("res://game/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	current_scene = main
	for i in 120:
		await process_frame
		if main.loading != null and not main.loading.visible and main.world.countries.size() >= 2:
			break
	check(main.world.countries.size() >= 2,"E2E actual Main/HUD/menu startup completes")
	frozen(main)
	if args.has("checkpoint"):
		check(await Save.net_restore(main,FileAccess.get_file_as_bytes(args["checkpoint"])),"E2E legacy baseline FORMAT1 snapshot loads through actual Main loader")
		frozen(main)
	var w: GameWorld = main.world
	var buyer: Country = w.countries[0]
	var seller: Country = w.countries[1]
	for c: Country in [buyer,seller]:
		c.is_player = true
		c.money = 80000
		c.metal = 1000
		c.titanium = 1000
		c.precious = 1000
	w.player = buyer
	w.net_driven = false
	main.in_menu = false
	main.menus.close()
	main.hud.visible = true
	GameConfig.no_save = false
	GameConfig.tutorial = false
	w.game_time = 160.0
	w.nuke_zones = [{"cell":Vector2i(5,5),"r_rad":0.1,"until":1000.0},{"cell":Vector2i(8,8),"r_rad":0.1,"until":1000.0}]
	w.seasons.snow = 0.44
	w.seasons.step(0.0)
	w.diplo._set_rel(buyer.id,seller.id,Diplomacy.Rel.PEACE)
	var carrier := Ship.new()
	carrier.id = 500002
	carrier.c = buyer.id
	carrier.hull = Ship.Hull.CARRIER
	carrier.pos = Vector2(100,100)
	w.navy.ships.append(carrier)
	var net: NetSession = main.net
	net.in_match = true
	net.is_host = true
	net.local_slot = buyer.id - 1
	main.hud.open_navy_dock(carrier)
	main.hud.navy_dock.sel_sid = carrier.id
	main.hud.navy_dock._buy_carrier_ac(Aircraft.Type.DECK_JET)
	check(net._pending.size() == 1,"E2E real HUD carrier action queues encoded command")
	execute_pending(net)
	var wing: Array[Aircraft] = w.navy.deck_aircraft(carrier)
	check(wing.size() == 1,"E2E authoritative purchase creates carrier aircraft")
	if wing.is_empty():
		quit(1)
		return
	var plane_id: int = wing[0].id
	var parcels: Array = w.diplo.land.list_parcels(seller.id).filter(func(p:Dictionary)->bool:return p["kind"] == "deposit")
	check(not parcels.is_empty(),"E2E fixture has a real foreign deposit to negotiate")
	if parcels.is_empty():
		quit(1)
		return
	var parcel: Dictionary = parcels[0]
	var cell: Vector2i = parcel["cell"]
	NetSession.sim("diplo","land_deal",[buyer.id,seller.id,"buy",parcel["key"],"",100000])
	# Insufficient funds must not create an executable proposal.
	execute_pending(net)
	check(w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land").is_empty(),"E2E insufficient funds rejected through command queue")
	NetSession.sim("diplo","land_deal",[buyer.id,seller.id,"buy",parcel["key"],"",2000])
	execute_pending(net)
	var offers: Array = w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land")
	check(offers.size() == 1 and w.data.get_owner_id(cell.x,cell.y) == seller.id,"E2E human land remains unchanged pending consent")
	if offers.is_empty():
		quit(1)
		return
	var offer_id: String = "t%d" % int(offers[0]["id"])
	var terms: Dictionary = offers[0]["land"].duplicate(true)
	var snow: float = w.seasons.snow
	net.in_match = false
	Save.use_slot(1)
	Save.begin_new()
	check(Save.save_game(main),"E2E actual Main disk save with carrier and pending consent succeeds")
	check(await Save.load_slot(main,1),"E2E actual Main disk load succeeds")
	frozen(main)
	check(w.navy.ship(carrier.id) != null and w.navy.ship(carrier.id).c == buyer.id,"E2E Ship.c survives disk serialization")
	var restored_plane: Aircraft = null
	for a: Aircraft in w.mil.air.aircraft:
		if a.id == plane_id:
			restored_plane = a
	check(restored_plane != null and restored_plane.carrier_id == carrier.id and restored_plane.country_id == buyer.id,"E2E UI-purchased plane links survive disk load")
	var restored: Array = w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land")
	check(restored.size() == 1 and restored[0]["land"] == terms,"E2E consent terms persist in existing FORMAT1 diplomacy envelope")
	check(is_equal_approx(w.seasons.snow,snow),"E2E seasonal state survives disk load")
	w.player = w.country_by_id(seller.id)
	var sheet = DipSheetS.new()
	main.hud.add_child(sheet)
	sheet.setup(main)
	var pending: Array = w.diplo.pending_for_player()
	var item: Dictionary = {}
	for p: Dictionary in pending:
		if p["id"] == offer_id:
			item = p
	check(not item.is_empty(),"E2E loaded proposal appears in actual recipient inbox")
	if item.is_empty():
		quit(1)
		return
	var card: Control = sheet._offer_card(item)
	sheet.add_child(card)
	net.in_match = true
	net.local_slot = seller.id - 1
	var row: Node = card.get_child(0)
	var accept: Button = row.get_child(row.get_child_count()-2) as Button
	accept.pressed.emit()
	check(net._pending.size() == 1,"E2E actual inbox accept button queues answer_as")
	execute_pending(net)
	check(w.data.get_owner_id(cell.x,cell.y) == buyer.id and w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land").is_empty(),"E2E accepted loaded proposal transfers land once")
	sheet.queue_free()
	net.in_match = false
	w.player = w.country_by_id(buyer.id)
	if restored_plane != null:
		restored_plane.state = Aircraft.State.FLY
		restored_plane.h = 8.0
	w.navy._sink(w.navy.ship(carrier.id),seller.id)
	check(restored_plane != null and restored_plane.state == Aircraft.State.DEAD and restored_plane.carrier_id == 0,"E2E real carrier sink handles incompatible airborne deck jet")
	check(Save.save_game(main),"E2E save after loss succeeds")
	check(await Save.load_slot(main,1),"E2E load after loss succeeds")
	frozen(main)
	var dead_found: bool = false
	for a: Aircraft in w.mil.air.aircraft:
		if a.id == plane_id:
			dead_found = a.state == Aircraft.State.DEAD and a.carrier_id == 0 and a.base == null and a.country_id == buyer.id
	check(dead_found,"E2E loss state and unchanged owner survive save/load")
	w.net_driven = true
	var start: float = w.game_time
	for tick in 320:
		w.net_step(NetConfig.SIM_DT)
		w._poll_roads()
		if args.get("renders","normal") == "extra":
			w._process(1.0/144.0)
			w._process(1.0/30.0)
		elif tick % 3 == 0:
			w._process(0.1)
	check(w.game_time > start and w.net_tick >= 320,"E2E simulation continues for 320 actual fixed ticks after load")
	check(w.seasons.snow >= 0.45 and w.seasons.farm_mul() == 0.5,"E2E real fixed ticks advance authoritative nuclear winter across farm threshold")
	check(not w.mil.air.aircraft.any(func(a:Aircraft)->bool:return a.id == plane_id),"E2E dead wing is cleaned by existing lifecycle")
	var result: Dictionary = {"checks":checks,"passed":failures.is_empty(),"failures":failures,"hash":NetHash.of(w),"rng":w.rng.state,"game_time":w.game_time,"snow":w.seasons.snow,"renders":args.get("renders","normal"),"user_data_dir":user}
	if args.has("out"):
		FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("PR10_SAVE_CONTINUE ",JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)
