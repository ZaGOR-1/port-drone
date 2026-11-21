class_name GameWorld
extends "res://game/game_world/gw_states.gd"




func _ready() -> void:
	Sfx.attach_world(self)
	atlas = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world.png", "res://assets/sprites/atlas_world.json")
	fx_atlas = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx.png", "res://assets/sprites/atlas_fx.json")
	atlas2 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world2.png", "res://assets/sprites/atlas_world2.json")
	atlas3 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world3.png", "res://assets/sprites/atlas_world3.json")
	atlas4 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world4.png", "res://assets/sprites/atlas_world4.json")
	atlas5 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world5.png", "res://assets/sprites/atlas_world5.json")
	fx_atlas2 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx2.png", "res://assets/sprites/atlas_fx2.json")
	fx_atlas3 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx3.png", "res://assets/sprites/atlas_fx3.json")
	atlas6 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world6.png", "res://assets/sprites/atlas_world6.json")
	atlas7 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world7.png", "res://assets/sprites/atlas_world7.json")
	fx_atlas4 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx4.png", "res://assets/sprites/atlas_fx4.json")
	life_atlas = SpriteAtlas.load_atlas("res://assets/sprites/atlas_life.png", "res://assets/sprites/atlas_life.json")
	atlas8 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world8.png", "res://assets/sprites/atlas_world8.json")
	fx_atlas5 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx5.png", "res://assets/sprites/atlas_fx5.json")
	atlas9 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world9.png", "res://assets/sprites/atlas_world9.json")
	atlas10 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world10.png", "res://assets/sprites/atlas_world10.json")
	atlas11 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world11.png", "res://assets/sprites/atlas_world11.json")
	atlas12 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world12.png", "res://assets/sprites/atlas_world12.json")
	fx_atlas6 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx6.png", "res://assets/sprites/atlas_fx6.json")
	fx_atlas7 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx7.png", "res://assets/sprites/atlas_fx7.json", true)
	atlas13 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_world13.png", "res://assets/sprites/atlas_world13.json")
	atlas_crane = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fui_crane.png", "res://assets/sprites/atlas_fui_crane.json", true)
	fx_atlas8 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx8.png", "res://assets/sprites/atlas_fx8.json")
	atlas_navy1 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_navy1.png", "res://assets/sprites/atlas_navy1.json", true)
	fx_atlas_navy = SpriteAtlas.load_atlas("res://assets/sprites/atlas_fx_navy.png", "res://assets/sprites/atlas_fx_navy.json", true)
	atlas_cm28 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_cm28.png", "res://assets/sprites/atlas_cm28.json", true)
	atlas_mines27 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_mines27.png", "res://assets/sprites/atlas_mines27.json", true)
	atlas_uran30 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_uran30.png", "res://assets/sprites/atlas_uran30.json", true)
	atlas_nuke2 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_nuke2.png", "res://assets/sprites/atlas_nuke2.json", true)
	atlas_carrier3 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_carrier3.png", "res://assets/sprites/atlas_carrier3.json", true)
	atlas_step4 = SpriteAtlas.load_atlas("res://assets/sprites/atlas_step4.png", "res://assets/sprites/atlas_step4.json", true)
	_build_sprite_table()
	Flora.register(self)
	ArchStyle.register(self)
	DmgStages.register(self)
	BorderPosts.register(self)
	_merge_world_sprites()
	terrain = TerrainView.new()
	terrain.name = "Terrain"
	if ResourceLoader.exists("res://world/season_terrain.gdshader"):
		var tmat := ShaderMaterial.new()
		tmat.shader = load("res://world/season_terrain.gdshader") as Shader
		terrain.material = tmat
	add_child(terrain)
	add_child(DecalLayer.make(self, 1))
	add_child(DecalLayer.make(self, 0))
	ground = GroundLayer.new()
	ground.name = "Ground"
	ground.gw = self
	add_child(ground)
	forts = FortLayer.new()
	forts.name = "Forts"
	forts.gw = self
	add_child(forts)
	add_child((load("res://world/nature_layer.gd") as GDScript).call("make", self))
	add_child(FogLayer.make_cover(self))
	territory = Sprite2D.new()
	territory.name = "Territory"
	territory.centered = false
	territory.scale = Vector2(4, 4)
	territory.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var mat: = ShaderMaterial.new()
	mat.shader = load("res://world/territory.gdshader") as Shader
	territory.material = mat
	add_child(territory)
	objects = ObjectsLayer.new()
	objects.name = "Objects"
	add_child(objects)
	city_power = CityPowerLayer.new()
	city_power.name = "CityPower"
	city_power.gw = self
	add_child(city_power)
	territory_border = Sprite2D.new()
	territory_border.name = "TerritoryBorder"
	territory_border.centered = false
	territory_border.scale = Vector2(4, 4)
	territory_border.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var bmat: = ShaderMaterial.new()
	bmat.shader = mat.shader
	bmat.set_shader_parameter("mode", 1)
	territory_border.material = bmat
	add_child(territory_border)
	life = LifeLayer.new()
	life.name = "Life"
	life.gw = self
	add_child(life)
	add_child(EcoLayer.make(self))
	add_child(NavalLayer.make(self))
	add_child(NavyLayer.make(self))
	add_child(TradeLayer.make(self))
	units_ground = UnitsLayer.new()
	units_ground.name = "UnitsGround"
	units_ground.gw = self
	add_child(units_ground)
	fx = FxLayer.new()
	fx.name = "Fx"
	add_child(fx)
	fx.setup(self, fx_atlas, [fx_atlas2, fx_atlas3, fx_atlas4, fx_atlas5, fx_atlas6, fx_atlas7, fx_atlas8, fx_atlas_navy, atlas_nuke2])
	units_air = UnitsLayer.new()
	units_air.name = "UnitsAir"
	units_air.gw = self
	units_air.air = true
	add_child(units_air)
	add_child(FogLayer.make(self))
	add_child(OpsLayer.make(self))
	add_child((load("res://world/sky_cover_layer.gd") as GDScript).call("make", self))
	add_child((load("res://world/hold_layer.gd") as GDScript).call("make", self))
	add_child((load("res://world/capture_layer.gd") as GDScript).call("make", self))
	top = TopLayer.new()
	top.name = "Top"
	top.gw = self
	add_child(top)
	add_child(WeatherFx.make(self))
	night = NightLayer.new()
	night.name = "Night"
	night.gw = self
	add_child(night)
	map_layer = MapModeLayer.make(self)
	add_child(map_layer)
	add_child(EconFxLayer.make(self))
	vfx = Vfx.make(self)
	labels = LabelsLayer.make(self)
	add_child((load("res://world/strat_layer.gd") as GDScript).call("make", self))


func _build_sprite_table() -> void:
	for at: SpriteAtlas in [atlas, atlas2, atlas3, atlas4, atlas6, atlas7, atlas8, atlas9, atlas10, atlas11, atlas12, atlas13, atlas_navy1, atlas_mines27, atlas_uran30, atlas_nuke2, atlas_carrier3, atlas_step4]:
		_add_sprites(at)
	spr_ruin.resize(spr_rect.size())
	for i in spr_rect.size():
		var sname: String = spr_name[i]
		var ruin: String = sname + "_ruin"
		if spr_index.has(ruin):
			spr_ruin[i] = int(spr_index[ruin])
		elif sname.begins_with("ad_") and spr_index.has(sname.trim_suffix("_hull") + "_hull_ruin"):
			spr_ruin[i] = int(spr_index[sname.trim_suffix("_hull") + "_hull_ruin"])
		elif sname.begins_with("tel") and spr_index.has("tel_ruin"):
			spr_ruin[i] = int(spr_index["tel_ruin"])
		elif sname.begins_with("tree_") or sname == "bush_a":
			spr_ruin[i] = int(spr_index.get("tree_burnt", -1))
		else:
			spr_ruin[i] = -1


func _add_sprites(at: SpriteAtlas) -> void:
	if at == null:
		return
	for sname: String in at.sprites:
		var s: Dictionary = at.sprites[sname]
		var kd: String = String(s.get("kind", ""))
		if kd.begins_with("unit") or kd == "fx":
			continue
		spr_index[sname] = spr_rect.size()
		spr_tex.append(at.texture)
		spr_name.append(sname)
		spr_rect.append(Rect2(float(s["x"]), float(s["y"]), float(s["w"]), float(s["h"])))
		spr_anchor.append(Vector2(float(s.get("ax", 0.0)), float(s.get("ay", 0.0))))
		spr_fw.append(int(s.get("fw", 1)))
		spr_fd.append(int(s.get("fd", 1)))
		spr_frames.append(int(s.get("frames", 1)))


func _merge_world_sprites() -> void:
	# Pack all small world object textures (<=512px wide) into one atlas so ObjChunk draws avoid texture switches.
	var seen_t: Dictionary = {}
	var items: Array = []
	for t: Texture2D in spr_tex:
		if t == null or t is PlaceholderTexture2D:
			continue
		var rid: int = t.get_rid().get_id()
		if seen_t.has(rid):
			continue
		var sz: Vector2i = Vector2i(t.get_size())
		if sz.x <= 0 or sz.y <= 0 or sz.x > 512 or sz.y > 1600:
			continue
		var im: Image = t.get_image()
		if im == null or im.is_empty():
			continue
		if im.is_compressed():
			im.decompress()
		if im.get_format() != Image.FORMAT_RGBA8:
			im.convert(Image.FORMAT_RGBA8)
		seen_t[rid] = true
		items.append([im.get_height(), im.get_width(), t, im])
	if items.size() <= 1:
		return
	items.sort_custom(func(a: Array, b: Array) -> bool: return int(a[0]) > int(b[0]))
	var col_x: Array[int] = [0, 513]
	var col_y: Array[int] = [0, 0]
	var max_w: int = 0
	var max_h: int = 0
	var offs: Dictionary = {}
	for it: Array in items:
		var h: int = int(it[0])
		var w: int = int(it[1])
		var col: int = 0 if col_y[0] <= col_y[1] else 1
		var ox: int = col_x[col]
		var oy: int = col_y[col]
		if oy + h > 4096:
			return
		offs[(it[2] as Texture2D).get_rid().get_id()] = Vector2(ox, oy)
		col_y[col] = oy + h + 1
		max_w = maxi(max_w, ox + w)
		max_h = maxi(max_h, oy + h)
	var merged := Image.create(max_w, max_h, false, Image.FORMAT_RGBA8)
	for it2: Array in items:
		var r_id: int = (it2[2] as Texture2D).get_rid().get_id()
		var off: Vector2 = offs[r_id]
		var im2: Image = it2[3]
		merged.blit_rect(im2, Rect2i(Vector2i.ZERO, im2.get_size()), Vector2i(int(off.x), int(off.y)))
	var mtex := ImageTexture.create_from_image(merged)
	for i in spr_tex.size():
		var tx: Texture2D = spr_tex[i]
		if tx == null:
			continue
		var r_id2: int = tx.get_rid().get_id()
		if offs.has(r_id2):
			spr_tex[i] = mtex
			var rc: Rect2 = spr_rect[i]
			rc.position += offs[r_id2] as Vector2
			spr_rect[i] = rc




func new_world(s: WorldSettings, skip_populate: bool = false) -> void:
	settings = s
	rng = Rng.new(s.world_seed + 99)
	countries.clear()
	(load("res://game/front_plan.gd") as GDScript).call("reset")
	id_style = -1
	cities.clear()
	drain_jobs()
	bridges.clear()
	bridge_cells.clear()
	road_paths.clear()
	checkpoints.clear()
	_delayed.clear()
	_enc_drain()
	_enc_t = 0.0
	enc_moved = 0
	_xb_tries = 0
	_xb_made = 0
	_xb_second = false
	xb_mids.clear()
	player = null
	mil = Military.new(self)
	mil.forts_changed.connect(forts.queue_redraw)
	forts.queue_redraw()
	diplo = Diplomacy.new(self)
	econ = Economy.new(self)
	army = Army.new(self)
	defense = Defense.new(self)
	session = Match.new(self)
	ai = AiBots.new(self)
	vision = Vision.new(self)
	ops = Operations.new(self)
	battle_watch = BattleWatch.new(self)
	recon = Recon.new(self)
	guide = EconGuide.new(self)
	protect = Protect.new(self)
	naval = Naval.new(self)
	navy = Navy.new(self)
	supply = Supply.new(self)
	arch = ArchStyle.new(self)
	kpp = BorderPosts.new(self)
	hold = (load("res://game/urban_hold.gd") as GDScript).new(self)
	aftermath = preload("res://game/aftermath.gd").new(self)
	pstat = PowerStatus.new(self)
	drama = preload("res://game/world_drama.gd").new(self)
	seasons = Seasons.new()
	seasons.gw = self
	seasons.reset()
	chronicle = ChronicleS.new(self)
	chronicle.reset()
	ceded_prot.clear()
	dip_highlight.clear()
	fires.clear()
	ruins.clear()
	nuke_zones.clear()
	nuke_warn_until = -1.0
	nuke_warn_target = Vector2.ZERO
	_ruin_t = 0.0
	_fire_snd_t = 0.0
	_enc_queue.clear()
	strike_net = null
	obj_fix.clear()
	city_power._cells.clear()
	game_time = 0.0
	_expand_t = 0.0
	_ai_t = 0.0
	_checkpoints_dirty = false
	net_trace_logs = false
	fx.reset()
	obj_spr = PackedInt32Array()
	rng.log_on = false
	Country.mlog_on = false
	Country.mlog.clear()
	obj_x = PackedInt32Array()
	obj_y = PackedInt32Array()
	obj_state = PackedByteArray()
	obj_kind = PackedByteArray()
	obj_hidden = PackedByteArray()
	obj_arch = PackedByteArray()
	tree_at.clear()
	_free_ids = PackedInt32Array()
	_job_first.clear()
	ground.decals.clear()
	top.clear_all()
	data = WorldGen.generate(s)
	nature = preload("res://game/nature.gd").new(self)
	border_noise = WorldGen._noise_layer(data.w, data.h, maxi(4, data.w / 40), s.world_seed + 4040)
	terrain.build(data)
	if seasons != null:
		seasons.apply_terrain_uniforms()
	territory_img = Image.create_from_data(data.w, data.h, false, Image.FORMAT_L8, data.owners)
	territory_tex = ImageTexture.create_from_image(territory_img)
	territory.texture = territory_tex
	territory_border.texture = territory_tex
	(territory.material as ShaderMaterial).set_shader_parameter("owner_tex", territory_tex)
	(territory_border.material as ShaderMaterial).set_shader_parameter("owner_tex", territory_tex)
	_update_territory_colors()
	objects.setup(self)
	if not skip_populate:
		_spawn_trees()
	rail = null
	econ.generate_deposits()
	econ.build_nav()
	rail = Rail.new(self)
	Operations.MAX_RANGE = maxf(3200.0, float(data.w * CELL) * 0.7)
	Defense.apply_map(data.w)
	life.reset()
	night.reset()
	ground.queue_redraw()
	if camera != null:
		camera.world_px = Vector2(data.w * CELL, data.h * CELL)
		camera.center_on(camera.world_px * 0.5)
	cad344 = Cad344.new(self)
	cad344.phase_offsets()
	changed.emit()


func _spawn_trees() -> void:
	if settings.gen_version >= 2 and Flora.ready(self):
		Flora.spawn_trees(self)
		return
	var t0: int = Time.get_ticks_msec()
	var dens: = PackedInt32Array()
	dens.resize(32)
	for k: int in TREE_DENSITY:
		dens[k] = int(TREE_DENSITY[k]) * (50 + settings.forests) / 100
	var name_ids: Array = []
	name_ids.resize(32)
	for k: int in TREE_NAMES:
		var ids: = PackedInt32Array()
		for n: String in TREE_NAMES[k]:
			ids.append(int(spr_index[n]))
		name_ids[k] = ids
	var w: int = data.w
	var sd: int = data.world_seed + 5
	for y in data.h:
		for x in w:
			var b: int = data.biome[y * w + x]
			var dn: int = dens[b]
			if dn == 0:
				continue
			var hh: int = Hash32.h2(x, y, sd)
			if (hh & 255) >= dn:
				continue
			var ids: PackedInt32Array = name_ids[b]
			var id: int = _add_object_id(ids[(hh >> 8) % ids.size()], x, y, KIND_TREE)
			tree_at[y * w + x] = id
	print("[GameWorld] trees: %d in %d ms" % [obj_spr.size(), Time.get_ticks_msec() - t0])


func cmd_static(c: Country, mod: String, fn: String, args: Array) -> Variant:
	if c == null or not _NET_STATIC.has(mod) or not (_NET_STATIC[mod] as Array).has(fn):
		return null
	var scr: GDScript = load({"groups": "res://game/army_groups.gd", "front": "res://game/front_plan.gd",
		"ship_cr": "res://game/navy_strike.gd"} [mod]) as GDScript
	var ag: GDScript = null
	for i in args.size():
		if args[i] is PackedInt32Array:
			if ag == null:
				ag = load("res://game/army_groups.gd") as GDScript
			var own: = PackedInt32Array()
			for fid: int in args[i]:
				var f: Facility = ag.call("fac", self, fid)
				if f != null and f.country_id == c.id:
					own.append(fid)
			args[i] = own
	return scr.callv(fn, [self, c.id] + args)


func cmd_strike(c: Country, all: Dictionary, together: bool) -> Dictionary:
	if strike_net == null:
		strike_net = (load("res://game/strike_hub.gd") as GDScript).new()
	var hub: GDScript = strike_net.get_script()
	hub.set("actor", c)
	var r: Dictionary = strike_net.call("fire", self, all, together)
	hub.set("actor", null)
	return r



func _net_prune() -> void:
	var ag: GDScript = load("res://game/army_groups.gd") as GDScript
	for c: Country in countries:
		if c.is_player:
			ag.call("prune", self, c.id)



func cmd_refill_all(c: Country, on: bool) -> int:
	var n: int = 0
	for f: Facility in mil.facilities:
		if f.kind == Facility.Kind.BARRACKS and f.country_id == c.id and mil.alive(f):
			f.auto_refill = on
			if on and f.prod_type == 3:
				f.prod_type = 0
			n += 1
	return n



func net_step(dt: float) -> void:
	net_tick += 1
	var trace_on: bool = NetConfig.trace or net_trace_logs
	rng.log_on = trace_on
	rng.log_tick = net_tick
	Country.mlog_on = trace_on
	Country.mlog_tick = net_tick
	_sim_step(dt)
	if strike_net != null:
		strike_net.call("tick", self)
	if net_tick % 30 == 0:
		_net_prune()
	_poll_roads()
	if life != null:
		life.sim_trucks(dt)
	if _checkpoints_dirty:
		_update_checkpoints()


func _process(delta: float) -> void:
	if data == null:
		return
	if net_driven:
		if seasons != null:
			# Gameplay seasons advance in _sim_step; rendering only publishes their uniforms.
			seasons.apply_terrain_uniforms()
		if vision != null:
			vision.update(delta)
		terrain.flush()
		_flush_territory()
		return
	var total: float = delta * time_scale
	var n: int = mini(SIM_MAX_STEPS, ceili(total / SIM_STEP - 0.001)) if total > 0.0 else 0
	var us: int = Time.get_ticks_usec()
	var step: float = minf(total / float(maxi(1, n)), SIM_STEP * 1.5)
	var done: int = 0
	for i in n:
		_sim_step(step)
		done += 1
		if not GameConfig.no_slow and Time.get_ticks_usec() - us > int(sim_budget_ms * 1000.0):
			break
	sim_lag = maxf(0.0, total - step * float(done))
	sim_steps = done
	sim_ms = lerpf(sim_ms, float(Time.get_ticks_usec() - us) / 1000.0, 0.2)
	_poll_roads()
	if vision != null:
		vision.update(delta)
	terrain.flush()
	_flush_territory(false, delta)
	if _checkpoints_dirty:
		_update_checkpoints()


func _sim_step(dt: float) -> void:
	if perf_prof:
		_pu = Time.get_ticks_usec()
	game_time += dt
	if cad344 != null:
		cad344.step(dt)
	if not _delayed.is_empty():
		var any_due: bool = false
		for d_chk: Array in _delayed:
			if game_time >= float(d_chk[0]):
				any_due = true
				break
		if any_due:
			var due: Array = []
			var rem: Array = []
			for d_item: Array in _delayed:
				if game_time >= float(d_item[0]):
					due.append(d_item)
				else:
					rem.append(d_item)
			_delayed = rem
			if perf_prof:
				_pf("due.reverse")
			for d: Array in due:
				(d[1] as Callable).call()
				if perf_prof:
					_pf("delayed:" + str((d[1] as Callable).get_method()))
	if dt > 0.0:



		var pe: float = _expand_t
		_expand_t += dt
		var nsl: int = Cad344.EXP_SLICES if cad344 != null else EXP_SLICES
		for ph in nsl:
			var th: float = EXPAND_DT * float(ph + 1) / float(nsl)
			if pe < th and _expand_t >= th:
				if cad344 != null:
					_expand_tick(ph, nsl)
				else:
					_expand_tick(ph)
				if perf_prof:
					_pf("_expand_tick")
		if _expand_t >= EXPAND_DT:
			_expand_t = 0.0
		_enclave_tick(dt)
		if perf_prof:
			_pf("_enclave_tick")
		_ai_t += dt
		if _ai_t >= AI_TOWN_DT:
			_ai_t = 0.0
			for c: Country in countries:
				if not c.is_player and c.city_ids.size() < 6:
					if cad344 != null:
						cad344.town_q.append(c.id)
						continue
					_ai_try_town(c)
					if perf_prof:
						_pf("_ai_try_town")
		while cad344 != null and not cad344.town_q.is_empty() and cad344.take_ai_slot():
			var tc: Country = country_by_id(int(cad344.town_q.pop_front()))
			if tc != null and not tc.is_player and not tc.eliminated and tc.city_ids.size() < 6:
				_ai_try_town(tc)
				if perf_prof:
					_pf("_ai_try_town")
		_update_bridges(dt)
		if perf_prof:
			_pf("_update_bridges")
		mil.update(dt)
		if perf_prof:
			_pf("mil.update")
		diplo.update(dt)
		if perf_prof:
			_pf("diplo.update")
		econ.update(dt)
		if perf_prof:
			_pf("econ.update")
		rail.update(dt)
		if perf_prof:
			_pf("rail.update")
		army.update(dt)
		if perf_prof:
			_pf("army.update")
		if aftermath != null:
			aftermath.update(dt)
			if perf_prof:
				_pf("aftermath.update")
		Nuclear.update_silos(self, dt)
		Nuclear.update_rad_zones(self, dt)
		if perf_prof:
			_pf("nuclear.update")
		if nature != null:
			nature.update(dt)
			if perf_prof:
				_pf("nature.update")
		if vfx != null:
			vfx.sim_tick()
			if perf_prof:
				_pf("vfx.sim_tick")
		if seasons != null:
			seasons.step(dt)
		if chronicle != null:
			chronicle.step(dt)
			if perf_prof:
				_pf("chronicle.step")
		defense.update(dt)
		if perf_prof:
			_pf("defense.update")
		defense.update_shots(dt)
		if perf_prof:
			_pf("defense.update_shots")
		session.update(dt)
		if perf_prof:
			_pf("session.update")
		ai.update(dt)
		if perf_prof:
			_pf("ai.update")
		if ops != null:
			ops.update(dt)
			if perf_prof:
				_pf("ops.update")
		if guide != null:
			guide.update(dt)
			if perf_prof:
				_pf("guide.update")
		if protect != null:
			protect.update(dt)
			if perf_prof:
				_pf("protect.update")
		if naval != null:
			naval.update(dt)
			if perf_prof:
				_pf("naval.update")
		if navy != null:
			navy.update(dt)
			if perf_prof:
				_pf("navy.update")
		if supply != null:
			supply.update(dt)
			if perf_prof:
				_pf("supply.update")
		if arch != null:
			arch.update(dt)
			if perf_prof:
				_pf("arch.update")
		if kpp != null:
			kpp.update(dt)
			if perf_prof:
				_pf("kpp.update")
		if hold != null:
			hold.update(dt)
			if perf_prof:
				_pf("hold.update")
		_update_fires_ruins(dt)
		if perf_prof:
			_pf("_update_fires_ruins")
		if pstat != null:
			pstat.update(dt)
			if perf_prof:
				_pf("pstat.update")
		if drama != null:
			drama.update(dt)
			if perf_prof:
				_pf("drama.update")


func _pf(nm: String) -> void:
	var now: int = Time.get_ticks_usec()
	var d: float = float(now - _pu) / 1000.0
	if d > float(perf_sys.get(nm, 0.0)):
		perf_sys[nm] = d
	_pu = now


func in_nuke_crater(cell: Vector2i) -> bool:
	for z: Dictionary in nuke_zones:
		var c: Vector2i = z["cell"]
		var cr: int = int(z.get("r_crater", Nuclear.NUKE_CRATER_R))
		var dx: int = cell.x - c.x
		var dy: int = cell.y - c.y
		if dx * dx + dy * dy <= cr * cr:
			return true
	return false


func _exit_tree() -> void:
	drain_jobs()
	for key: String in ["fire", "siren", "drone", "heli"]:
		Sfx.loop(key, "", false)
	Sfx.detach_world(self)
