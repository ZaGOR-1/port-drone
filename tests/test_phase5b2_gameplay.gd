extends SceneTree
## Actual Main/HUD -> command -> simulation fixtures, always isolated from player saves.
var args: Dictionary = {}
var checks: int = 0
var failures: Array = []
var details: Dictionary = {}
var main: Node

func _initialize() -> void:
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--") and a.contains("="):
			args[a.get_slice("=", 0).trim_prefix("--")] = a.substr(a.find("=") + 1)
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)

func frozen() -> void:
	main.set_process(false)
	main.net.set_process(false)
	main.net.lan.set_process(false)
	main.world.set_process(false)
	main.world.time_scale = 0.0
	main._paused = true

func drain() -> void:
	var commands: Array = main.net._pending
	main.net._pending = []
	for cmd: Dictionary in commands:
		main.net._exec(cmd)

func multiplayer_on() -> void:
	main.net.in_match = true
	main.net.is_host = true
	main.net.local_slot = main.world.player.id - 1
	main.world.net_driven = true

func flat(cell: Vector2i, size: Vector2i, owner: int) -> void:
	var d: WorldData = main.world.data
	for y in range(cell.y, cell.y + size.y):
		for x in range(cell.x, cell.x + size.x):
			d.biome[y*d.w+x] = Biome.GRASS
			d.owners[y*d.w+x] = owner
			d.flags[y*d.w+x] = 0
			if main.world.rail.mask.size() > y*d.w+x:
				main.world.rail.mask[y*d.w+x] = 0

func command(path: String, method: String, arguments: Array, slot: int) -> void:
	main.net._exec({"k":"call", "o":path, "m":method, "a":NetCodec.encode(arguments), "s":slot})

func rejected(path: String, method: String, arguments: Array, actor: int, label: String) -> void:
	var before: String = NetHash.of(main.world)
	var errors := Save.RestoreErrors.new()
	OS.add_logger(errors)
	command(path,method,arguments,actor-1)
	OS.remove_logger(errors)
	check(NetHash.of(main.world) == before and not errors.failed(),label)

func _airport() -> void:
	var w: GameWorld = main.world
	var c: Country = w.player
	var key: Button = main.hud.keys["airport"]
	check(key.pressed.get_connections().size() > 0, "FIX05 actual airport button signal is connected")
	for mp: bool in [false, true]:
		main.net.in_match = mp
		if mp:
			multiplayer_on()
		main._set_mode(main.Mode.NONE)
		key.pressed.emit()
		check(main.mode == main.Mode.AIRPORT, "FIX05 actual button enters AIRPORT placement (mp=%s)" % mp)
		if main.mode != main.Mode.AIRPORT:
			continue
		var cell := Vector2i(24, 24 if not mp else 100)
		flat(Military.nw_for(Facility.Kind.AIRPORT, cell), Military.size_of(Facility.Kind.AIRPORT), c.id)
		check(w.mil.place_why(Facility.Kind.AIRPORT, cell, c) == "", "FIX05 synthetic airport site is valid")
		var count: int = w.mil.facilities.size()
		var money: int = c.money
		var wp := Vector2(cell * GameWorld.CELL) + Vector2(1,1)
		main._tap(main.cam.world_to_screen(wp))
		if mp:
			check(main.net._pending.size() == 1 and w.mil.facilities.size() == count, "FIX05 MP queues before authoritative mutation")
			drain()
		check(w.mil.facilities.size() == count + 1, "FIX05 UI placement produces airport")
		if w.mil.facilities.size() == count:
			continue
		var ap: Facility = w.mil.facilities.back()
		check(ap.kind == Facility.Kind.AIRPORT and ap.country_id == c.id and c.money < money, "FIX05 airport owner/cost correct")
		check(main.mode == main.Mode.NONE and not key.button_pressed, "FIX05 desktop plain placement exits mode cleanly (Variant 1A)")
		var foreign: Country = w.countries[1]
		var count_before: int = w.mil.facilities.size()
		var before: int = c.money
		command("mil", "build", [Facility.Kind.AIRPORT, Vector2i(24,200), c], foreign.id - 1)
		command("mil", "build", [Facility.Kind.AIRPORT, Vector2i(-100,-100), c], c.id - 1)
		check(w.mil.facilities.size() == count_before and c.money == before, "FIX05 foreign issuer/invalid location cannot build airport")
		# Existing buy command ownership is authoritative for an airport card too.
		var air_count: int = w.mil.air.aircraft.size()
		command("mil.air", "buy", [ap, Aircraft.Type.TRANSPORT, foreign], foreign.id-1)
		check(w.mil.air.aircraft.size() == air_count, "FIX05 foreign issuer cannot buy at someone else's airport")
		if mp:
			var free_cell := Vector2i(300,100)
			flat(Military.nw_for(Facility.Kind.AIRPORT,free_cell),Military.size_of(Facility.Kind.AIRPORT),c.id)
			rejected("mil","build",[Facility.Kind.AIRPORT,free_cell,c,null,true],c.id,"FIX05 network caller cannot request a free airport")
			rejected("mil","build",[1000000,free_cell,c],c.id,"FIX05 invalid facility kind rejected without script error")
			rejected("mil","build",[Facility.Kind.AIRPORT,"bad",c],c.id,"FIX05 invalid coordinate type rejected without script error")
			rejected("mil","build",[Facility.Kind.AIRPORT,free_cell],c.id,"FIX05 missing country rejected without script error")
		main.pc_cancel_mode()

func _cooldown() -> void:
	var w: GameWorld = main.world
	var from_id: int = w.player.id
	var to_id: int = w.countries[1].id
	w.game_time = 1000.0
	w.diplo._set_rel(from_id, to_id, Diplomacy.Rel.PEACE)
	w.diplo.truce_until.erase(Diplomacy.key(from_id,to_id))
	for cell: Vector2i in [Vector2i(200,200), Vector2i(250,250)]:
		flat(cell-Vector2i(7,7), Vector2i(15,15), from_id)
		w.econ.deposits.append({"res":"metal", "cell":cell, "left":500, "max":500, "mine":null, "obj":-1})
	multiplayer_on()
	command("diplo", "land_deal", [from_id,to_id,"gift","dep:200:200","",0],from_id-1)
	var offers: Array = w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land")
	check(offers.size() == 1 and w.data.get_owner_id(200,200) == from_id, "FIX06 gift still needs recipient consent")
	if offers.is_empty():
		return
	var id: int = int(offers[0]["id"])
	check(float(offers[0]["until"]) == 1090.0, "FIX06 existing pending offer TTL is 90 simulation seconds")
	command("diplo", "land_deal", [from_id,to_id,"gift","dep:250:250","",0],from_id-1)
	check(w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land").size() == 1, "FIX06 only one pending land offer per pair")
	command("diplo", "answer_as", [to_id,"t%d"%id,"accept"],to_id-1)
	check(w.data.get_owner_id(200,200) == to_id and float(w.diplo.land._last_deal.get("%d:%d"%[from_id,to_id],-1.0)) == 1000.0, "FIX06 accepted command records simulation-time cooldown")
	command("diplo", "answer_as", [to_id,"t%d"%id,"accept"],to_id-1)
	check(w.data.get_owner_id(250,250) == from_id, "FIX06 repeated consent does not transfer another parcel")
	var bytes: PackedByteArray = Save.net_snapshot(main)
	main.net.in_match = false
	w.net_driven = false
	Save.use_slot(2)
	Save.begin_new()
	check(Save.save_game(main), "FIX06 real disk save after agreement")
	for attempt in 2:
		check(await Save.load_slot(main,2), "FIX06 repeated disk load succeeds")
		frozen()
		check(float(w.diplo.land._last_deal.get("%d:%d"%[from_id,to_id],-1.0)) == 1000.0, "FIX06 disk load preserves completed-deal timestamp")
		check(w.diplo.land.propose_deal(from_id,to_id,"gift","dep:250:250") != "", "FIX06 reload cannot bypass cooldown")
	for offset: float in [0.0, 89.9, 90.0]:
		check(await Save.net_restore(main,bytes), "FIX06 actual network snapshot restore")
		frozen()
		w.game_time = 1000.0 + offset
		var why: String = w.diplo.land.propose_deal(from_id,to_id,"gift","dep:250:250")
		check((why == "") == (offset >= 90.0), "FIX06 restored cooldown boundary %.1f"%offset)
		if offset < 90.0:
			command("diplo", "land_deal", [from_id,to_id,"gift","dep:250:250","",0],from_id-1)
			check(w.diplo.t_offers.filter(func(t:Dictionary)->bool:return t.get("kind","") == "land").is_empty(), "FIX06 MP command cannot bypass restored cooldown")
	# Hash must detect different future deal eligibility even with identical clock/RNG/land.
	await Save.net_restore(main,bytes)
	frozen()
	var h: String = NetHash.of(w)
	w.diplo.land._last_deal["%d:%d"%[from_id,to_id]] = 999.0
	check(NetHash.of(w) != h, "FIX06 authoritative cooldown participates in state hash")
	var saved: Dictionary = w.diplo.land._last_deal.duplicate()
	w.diplo.land._last_deal = {"1:2":999.0,"2:1":998.0}
	var ordered_hash: String = NetHash.of(w)
	w.diplo.land._last_deal = {"2:1":998.0,"1:2":999.0}
	check(NetHash.of(w) == ordered_hash, "FIX06 cooldown hash uses canonical pair order")
	w.diplo.land._last_deal = saved
	var packed: Array = bytes_to_var(bytes)
	var body: Dictionary = bytes_to_var((packed[1] as PackedByteArray).decompress(int(packed[0]),FileAccess.COMPRESSION_ZSTD))
	for invalid: Variant in [[], {"1:2":"bad"}, {"1:2":NAN}, {"1:2":1001.0}, {"01:2":1000.0}, {"1:1":1000.0}]:
		var bad: Dictionary = body.duplicate(true)
		bad["sys"]["diplo"]["land_cooldowns"] = invalid
		var before: String = NetHash.of(w)
		check(not Save._sound(bad), "FIX06 invalid optional cooldown rejected by shared disk/snapshot validation")
		var raw: PackedByteArray = var_to_bytes(bad)
		check(not await Save.net_restore(main,var_to_bytes([raw.size(),raw.compress(FileAccess.COMPRESSION_ZSTD)])) and NetHash.of(w) == before, "FIX06 invalid cooldown snapshot rejected before mutation")
	var hashes: Array = []
	var rngs: Array = []
	for render_extra: bool in [false,true]:
		check(await Save.net_restore(main,bytes), "FIX06 deterministic replay restores same checkpoint")
		frozen()
		w.net_driven = true
		w.net_tick = 0
		for tick in 30:
			if tick == 0:
				command("diplo","land_deal",[from_id,to_id,"gift","dep:250:250","",0],from_id-1)
			w.net_step(NetConfig.SIM_DT)
			w._poll_roads()
			if render_extra:
				w._process(1.0/144.0)
		hashes.append(NetHash.of(w))
		rngs.append(w.rng.state)
	check(hashes[0] == hashes[1] and rngs[0] == rngs[1], "FIX06 same commands/ticks preserve cooldown/hash/RNG regardless of extra renders")
	if args.has("export_snapshot"):
		FileAccess.open(args["export_snapshot"],FileAccess.WRITE).store_buffer(bytes)
	# Old FORMAT1 has no historical timestamps: explicitly reset, do not retain previous world's state.
	var old: Dictionary = w.diplo.save_state()
	old.erase("land_cooldowns")
	w.diplo.load_state(old)
	check(w.diplo.land._last_deal.is_empty(), "FIX06 old-save default is empty and clears previous world cooldown")
	if args.has("checkpoint"):
		check(await Save.net_restore(main,FileAccess.get_file_as_bytes(args["checkpoint"])), "FIX06 real legacy snapshot remains readable")
		frozen()
		check(w.diplo.land._last_deal.is_empty(), "FIX06 legacy checkpoint uses defined empty history default")
	details["format"] = Save.FORMAT
	details["protocol"] = NetConfig.PROTO

func cancel_input(kind: String) -> void:
	if kind == "escape":
		var event := InputEventKey.new()
		event.keycode = KEY_ESCAPE
		event.pressed = true
		main._unhandled_input(event)
	else:
		for pressed: bool in [true, false]:
			var event := InputEventMouseButton.new()
			event.button_index = MOUSE_BUTTON_RIGHT
			event.pressed = pressed
			event.position = Vector2(200,200)
			main._unhandled_input(event)

func aircraft(id: int) -> Aircraft:
	for a: Aircraft in main.world.mil.air.aircraft:
		if a.id == id:
			return a
	return null

func _air_cancel(drop: bool) -> void:
	var w: GameWorld = main.world
	var owner: int = w.player.id
	var bases: Array[Facility] = []
	for cell: Vector2i in [Vector2i(50,50), Vector2i(120,120)]:
		flat(Military.nw_for(Facility.Kind.AIRPORT,cell),Military.size_of(Facility.Kind.AIRPORT),owner)
		bases.append(w.mil.build(Facility.Kind.AIRPORT,cell,w.player,null,true))
	check(bases[0] != null and bases[1] != null, "FIX07 valid airport fixtures")
	if bases[0] == null or bases[1] == null:
		return
	check(w.mil.air.buy(bases[0],Aircraft.Type.TRANSPORT,w.player) == "", "FIX07 real transport purchase")
	var a: Aircraft = w.mil.air.aircraft.back()
	var id: int = a.id
	var action: String = "air_airdrop" if drop else "air_rebase"
	var expected_mode: int = main.Mode.AIRDROP if drop else main.Mode.REBASE
	var tag: String = "AIRDROP" if drop else "REBASE"
	for mp: bool in [false,true]:
		main.net.in_match = mp
		if mp:
			multiplayer_on()
		for key: String in ["escape","rmb"]:
			main._set_mode(main.Mode.NONE)
			main.follow = a
			main.hud.action.emit(action)
			check(main.mode == expected_mode, "FIX07 %s actual HUD signal arms placement"%tag)
			var state: String = NetHash.of(w)
			var queued: int = main.net._pending.size()
			cancel_input(key)
			check(main.mode == main.Mode.NONE and main.rebase_air == null and main.airdrop_air == null, "FIX07 %s %s cancels placement (mp=%s)"%[tag,key,mp])
			check(NetHash.of(w) == state and main.net._pending.size() == queued and a.troops == 0, "FIX07 %s cancel preserves resources/RNG/entities/commands"%tag)
			if main.mode == main.Mode.NONE:
				check(not main.pc_cancel_mode(), "FIX07 %s duplicate cancel is harmless"%tag)
			main.menus.close()
	var foreign: Country = w.countries[1]
	if drop:
		rejected("mil.air","order_airdrop",[a,Vector2(NAN,0),w.player],owner,"FIX07 AIRDROP nonfinite target rejected without mutation/errors")
		rejected("mil.air","order_airdrop",[a,"bad",w.player],owner,"FIX07 AIRDROP wrong target type rejected")
	else:
		rejected("mil.air","rebase",[a,"bad",w.player],owner,"FIX07 REBASE wrong base type rejected")
		rejected("mil.air","rebase",[a],owner,"FIX07 REBASE missing arguments rejected")
	var state: String = NetHash.of(w)
	command("mil.air", "order_airdrop" if drop else "rebase", [a,Vector2(800,800),foreign] if drop else [a,bases[1],foreign], foreign.id-1)
	check(NetHash.of(w) == state, "FIX07 %s foreign command rejected"%tag)
	multiplayer_on()
	main._set_mode(main.Mode.NONE)
	main.follow = a
	main.hud.action.emit(action)
	if drop:
		flat(Vector2i(194,194),Vector2i(12,12),owner)
		main._airdrop_tap(Vector2(800,800))
	else:
		main._rebase_tap(main.cam.world_to_screen(bases[1].center_px()),bases[1].center_px(),bases[1].cell+bases[1].size/2)
	check(main.net._pending.size() == 1, "FIX07 %s valid target queues one command"%tag)
	var money: int = w.player.money
	cancel_input("rmb")
	check(main.net._pending.size() == 1 and w.player.money == money, "FIX07 %s cancel after issue preserves queued action, no refund/debit yet"%tag)
	drain()
	check(a.troops == Air.PARATROOP_COUNT if drop else a.base == bases[1], "FIX07 %s accepted command performs existing action"%tag)
	check(w.player.money == money - Air.PARATROOP_COST if drop else w.player.money == money, "FIX07 %s resources charged once by simulation"%tag)
	main.net.in_match = false
	w.net_driven = false
	Save.use_slot(3)
	Save.begin_new()
	check(Save.save_game(main), "FIX07 %s active action disk save"%tag)
	check(await Save.load_slot(main,3), "FIX07 %s active action disk load"%tag)
	frozen()
	a = aircraft(id)
	check(a != null and a.country_id == owner and a.state != Aircraft.State.DEAD, "FIX07 %s aircraft identity/owner survives"%tag)
	check(main.mode == main.Mode.NONE and main.rebase_air == null and main.airdrop_air == null, "FIX07 %s no stale placement refs after load"%tag)
	if a == null:
		return
	if drop:
		check(a.troops == Air.PARATROOP_COUNT and a.drop_target.is_finite(), "FIX07 AIRDROP payload and target survive save/load")
		var before: int = w.army.units.size()
		w.mil.air._drop_paratroops(a)
		var after: int = w.army.units.size()
		w.mil.air._drop_paratroops(a)
		check(after > before and w.army.units.size() == after and a.troops == 0 and not a.drop_target.is_finite(), "FIX07 AIRDROP delivery is one-shot, no duplicate troops")
	else:
		check(a.base != null and a.base.id == bases[1].id and a.after_land == Aircraft.State.RTB, "FIX07 REBASE destination and transit state survive load")
		var target: Facility = w.mil.facilities[bases[0].id]
		target.hp = 0.0
		for oi: int in target.obj_ids:
			w.obj_state[oi] = 2
		var base: Facility = a.base
		check(w.mil.air.rebase(a,target,w.player) != "" and a.base == base, "FIX07 REBASE destroyed destination rejected")
	main._set_mode(main.Mode.TARGET)
	main.plan_has_target = true
	main.plan_target = Vector2(50,50)
	check(not main.pc_cancel_mode() and main.plan_has_target, "FIX07 strike planner cancellation policy unchanged")
	main._set_mode(main.Mode.NONE)

func _run() -> void:
	if not OS.get_user_data_dir().contains("phase5b2"):
		push_error("Use isolated phase5b2 runner")
		quit(2)
		return
	seed(91234)
	main = (load("res://game/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	current_scene = main
	for i in 180:
		await process_frame
		if main.menus != null and main.menus.current == "main" and not main.loading.visible:
			break
	frozen()
	if args.has("checkpoint"):
		check(await Save.net_restore(main, FileAccess.get_file_as_bytes(args["checkpoint"])), "fixture legacy checkpoint loads")
		frozen()
	main.in_menu = false
	main.menus.close()
	main.hud.visible = true
	GameConfig.confirm_actions = false
	GameConfig.no_save = false
	GameConfig.tutorial = false
	main.world.player = main.world.countries[0]
	for c: Country in main.world.countries:
		c.is_player = true
		c.money = 1000000
		for res: String in ["fuel", "metal", "titanium", "precious", "wood", "food", "goods", "oil"]:
			c.set(res, 10000)
	if args.get("case", "05") == "05":
		_airport()
	if args.get("case", "") == "06":
		await _cooldown()
	if args.get("case", "") in ["07R", "07A"]:
		await _air_cancel(args["case"] == "07A")
	if args.get("case", "") == "compat":
		check(main.world.diplo.land._last_deal.is_empty(), "old reader opens new snapshot but loses optional cooldown: downgrade unsupported")
		details["downgrade_supported"] = false
		details["cooldown_lost"] = main.world.diplo.land._last_deal.is_empty()
	var result := {"checks":checks, "failures":failures, "passed":failures.is_empty(), "details":details}
	FileAccess.open(args["out"], FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("PHASE5B2 ", JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)
