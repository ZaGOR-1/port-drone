extends SceneTree

var checks: int = 0
var failures: Array[String] = []


func _initialize() -> void:
	run.call_deferred()


func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)


func texts(node: Node) -> Array[String]:
	var values: Array[String] = []
	var text: String = ""
	if node is Label or node is Button or node is RichTextLabel:
		text = node.get("text")
	if not text.is_empty():
		values.append(node.atr(text) if node.can_auto_translate() else text)
	for child: Node in node.get_children():
		values.append_array(texts(child))
	return values


func screen_contains(m: Menus, words: Array, label: String) -> void:
	var shown: String = "\n".join(texts(m.screen))
	for word: String in words:
		check(shown.contains(word), "%s missing %s: %s" % [label, word, shown.left(500)])


func check_dynamic(m: Node) -> void:
	var ally = preload("res://game/alliances.gd")
	var lane = preload("res://ui/ui24/notif_lane.gd")
	var bridge: Array = Loc.mk("Мост восстановлен")
	var merged: Variant = lane._note_message({"n": 2, "key": "МОСТЫ", "tk": bridge})
	var expected: Dictionary = {
		"ru": ["1 армия", "2 армии", "5 армий", "21 армия", "МОСТЫ ×2 · Мост восстановлен",
			"ПОПЫТКА 2 · ВАШЕ МЕСТО СОХРАНЕНО", "Северный пакт", "ЗАГРУЖАЮТСЯ: 0 ИЗ 2"],
		"uk": ["1 армія", "2 армії", "5 армій", "21 армія", "МОСТИ ×2 · Міст відновлено",
			"СПРОБА 2 · ВАШЕ МІСЦЕ ЗБЕРЕЖЕНО", "Північний пакт", "ЗАВАНТАЖУЮТЬСЯ: 0 З 2"],
		"en": ["1 army", "2 armies", "5 armies", "21 armies", "BRIDGES ×2 · Bridge restored",
			"ATTEMPT 2 · YOUR SLOT IS SAVED", "Northern Pact", "LOADING: 0 OF 2"]
	}
	var downgrade: Dictionary = {"cid": m.world.player.id, "tier": 1, "old_tier": 2, "state": 0, "old_state": 0}
	var downgrade_text: Dictionary = {"ru": "Ваша страна теряет статус: снова РЕСПУБЛИКА",
		"uk": "Ваша країна втрачає статус: знову РЕСПУБЛІКА", "en": "Your country loses status: back to REPUBLIC"}
	Loc.set_lang("ru", false)
	var kept: Variant = Loc.keep(m.world.pstat.change_text(downgrade, true))
	var tip_prefix: Dictionary = {"ru": "Армия до 12 бойцов", "uk": "Армія до 12 бійців", "en": "Army of up to 12 troops"}
	var old_hints: bool = GameConfig.hints
	GameConfig.hints = false
	var ns: NetSession = m.net
	var shown: MpKit.Plate = MpKit.Plate.new()
	root.add_child(shown)
	ns.in_match = true
	ns.slots.assign([{}, {}])
	m.hud.lane.journal.append({"t": 0.0, "text": Loc.re(merged), "lvl": 1, "k": merged})
	for locale: String in ["ru", "uk", "en", "uk"]:
		Loc.set_lang(locale, false)
		var words: Array = expected[locale]
		var counts: Array[int] = [1, 2, 5, 21]
		for i: int in counts.size():
			var n: int = counts[i]
			check(Loc.n(n, "%d армия", "%d армии", "%d армий") % n == words[i],
				"army plural %d in %s" % [n, locale])
		check(m.hud.lane.journal.back()["text"] == words[4], "retained merged notice " + locale)
		check(Loc.re(kept) == downgrade_text[locale], "retained status event " + locale)
		ns.reconnecting = true
		ns.rc_tries = 2
		shown.set_state(ns.plate(), 1.1)
		check(shown.sub.text == words[5], "reconnect plate formats " + locale)
		ns.reconnecting = false
		ns.is_host = true
		shown.set_state(ns.plate(), 1.1)
		check(shown.sub.text == words[7], "start plate formats " + locale)
		check(ally.display_name("Северный пакт") == words[6], "alliance preset " + locale)
		check(ally.display_name("МОСТЫ") == "МОСТЫ", "custom alliance name " + locale)
		m.hud._show_build_tip("barracks")
		check(m.hud.tip_sub.text.begins_with(tip_prefix[locale]), "build tooltip translated before shortening " + locale)
	GameConfig.hints = old_hints
	m.hud.tip_pc.hide()
	ns.in_match = false
	ns.is_host = false
	ns.slots.clear()
	shown.queue_free()


func run() -> void:
	if not OS.get_user_data_dir().contains("df_l10n_"):
		push_error("Use an isolated df_l10n_ profile")
		quit(2)
		return
	seed(91234)
	root.size = Vector2i(1280, 720)
	check(Loc.norm("uk-UA") == "uk" and Loc.norm("UA") == "uk", "normalize Ukrainian locale")
	check(Loc.device_lang("be_BY") == "ru" and Loc.device_lang("fr_FR") == "en", "picker default and fallback")
	check(not LangPicker.langs().has("es") and Loc.LANGS.has("es"), "Spanish remains development-only")
	var m: Node = (load("res://game/main.gd") as GDScript).new()
	root.add_child(m)
	current_scene = m
	for frame in 320:
		await process_frame
		if m.menus != null and m.loading != null and not m.loading.visible and m.world.data != null:
			break
	m.set_process(false)
	m.world.set_process(false)
	m.net.set_process(false)
	var menu: Menus = m.menus
	var before: String = NetHash.of(m.world)
	var label_src: Dictionary = {
		"ru": ["ИГРАТЬ", "НАСТРОЙКИ", "НОВАЯ ПАРТИЯ", "ЯДЕРНОЕ ОРУЖИЕ", "МУЛЬТИПЛЕЕР", "СОХРАНЕНИЯ", "ЗВУК", "ГРАФИКА", "ХРОНИКИ"],
		"uk": ["ГРАТИ", "НАЛАШТУВАННЯ", "НОВА ПАРТІЯ", "ЯДЕРНА ЗБРОЯ", "МУЛЬТИПЛЕЄР", "ЗБЕРЕЖЕННЯ", "ЗВУК", "ГРАФІКА", "ХРОНІКИ"],
		"en": ["PLAY", "SETTINGS", "NEW GAME", "NUCLEAR WEAPONS", "MULTIPLAYER", "SAVES", "SOUND", "GRAPHICS", "CHRONICLES"]
	}
	var season_labels: Dictionary = {"ru": ["Весна", "Лето", "Осень", "Зима"],
		"uk": ["Весна", "Літо", "Осінь", "Зима"], "en": ["Spring", "Summer", "Autumn", "Winter"]}
	var dynamic: Variant = Loc.mk("Армия №%d вызвала огонь: стреляют %s армии №%d", [3, "X", 8])
	for locale: String in Loc.PUBLIC_LANGS:
		Loc.set_lang(locale, false)
		await process_frame
		check(Loc.cur() == locale and TranslationServer.get_locale() == locale, "active locale " + locale)
		check(Loc.t("Невідомий тестовий ключ") == "Невідомий тестовий ключ", "missing-key fallback " + locale)
		check(Loc.t("ЯДЕРНОЕ ОРУЖИЕ") == label_src[locale][3], "translated match option " + locale)
		menu.show_main()
		screen_contains(menu, [label_src[locale][0], label_src[locale][8]], "main " + locale)
		menu.show_settings(false)
		screen_contains(menu, [label_src[locale][1]], "settings " + locale)
		menu.show_settings_sub("audio")
		screen_contains(menu, [label_src[locale][6]], "audio " + locale)
		menu.show_settings_sub("gfx")
		screen_contains(menu, [label_src[locale][7]], "graphics " + locale)
		menu.show_settings_sub("ui")
		check(menu.current == "settings_ui", "PC settings " + locale)
		menu.show_setup()
		screen_contains(menu, [label_src[locale][2]], "new match " + locale)
		menu.show_saves(false)
		screen_contains(menu, [label_src[locale][5]], "save slots " + locale)
		m.net.lan.scanning = true
		menu._mp_tab = 0
		menu.show_mp()
		screen_contains(menu, [label_src[locale][4]], "offline MP screen " + locale)
		var notice: String = Loc.msg(dynamic)
		check(notice.contains("3") and notice.contains("X") and notice.contains("8"), "format arguments " + locale)
		var season_no: int = m.world.seasons.season
		for index in 4:
			m.world.seasons.season = index
			check(m.world.seasons.name_text() == season_labels[locale][index], "season name %s/%d" % [locale, index])
		m.world.seasons.season = season_no
		check(NetHash.of(m.world) == before, "locale and screen rendering affect no authoritative state " + locale)
		check(Loc.name("DF Player") == "DF Player", "user name unchanged " + locale)
		await process_frame

	menu.close()
	var world: GameWorld = m.world
	world.player = world.countries[0]
	var player: Country = world.player
	var hud: Hud = m.hud
	GameConfig.hints = true
	Hud.plan_closed = false
	hud.plan_state = 1
	Loc.set_lang("ru", false)
	var goals_ru: Array = world.guide.goals(player)
	check(goals_ru.size() > 1 and not hud.plan_head.text.is_empty(), "guide cache and HUD are populated")
	check(hud.plan_head.text.begins_with("ПЛАН РАЗВИТИЯ"), "Russian guide header before switching")
	var state_before_switch: String = NetHash.of(world)
	Loc.set_lang("uk", false)
	var goals_uk: Array = world.guide.goals(player)
	check(goals_ru[1]["title"] != goals_uk[1]["title"], "guide content cache changes with locale")
	check(hud.plan_head.text.begins_with("ПЛАН РОЗВИТКУ"), "visible guide header refreshes immediately")
	check(NetHash.of(world) == state_before_switch, "guide re-render preserves NetHash")

	check_dynamic(m)

	Loc.set_lang("en", false)
	menu.show_settings(false)
	LangPicker.open_from(menu)
	var picker: LangPicker = menu.get_node("LangPicker")
	picker._pick("uk")
	picker._close_sheet()
	await process_frame
	check(Loc.cur() == "uk" and LangPicker.row_title() == "МОВА", "runtime switch refreshes settings")
	screen_contains(menu, ["НАЛАШТУВАННЯ"], "settings after language switch")
	GameConfig.lang = "en"
	Save.load_prefs()
	check(Loc.cur() == "uk" and GameConfig.lang == "uk", "language preference reload")
	var updater: Node = (load("res://pc/updater.gd") as GDScript).new()
	updater.call("_load_cfg")
	check(updater.get("lang") == "uk", "early updater reads persisted in-game locale")
	updater.free()
	for glyph: String in ["і", "ї", "є", "ґ", "ё", "ы", "э", "ъ"]:
		check(UiKit.f_bold.has_char(glyph.unicode_at(0)), "UI font supports " + glyph)
	for issue: String in failures:
		print("FAIL: ", issue)
	print("L10N %s (%d checks)" % ["PASS" if failures.is_empty() else "FAIL", checks])
	quit(0 if failures.is_empty() else 1)
