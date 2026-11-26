extends SceneTree

const MainScript = preload("res://game/main.gd")
const Slots = preload("res://game/save_slots.gd")
const KEYS := ["main", "a0", "a1", "a2", "bak", "tmp", "meta", "png"]
const LEGACY := "user://match.save"
var failures: Array[String] = []
var checks := 0
var old: PackedByteArray
var recent: PackedByteArray
var expected: Dictionary = {}


func _initialize() -> void:
	_run.call_deferred()


func _check(value: bool, label: String) -> void:
	checks += 1
	if not value:
		failures.append(label)


func _run() -> void:
	if not OS.get_user_data_dir().contains("df_sp_continue_"):
		quit(2)
		return
	seed(159331)
	var main := MainScript.new()
	main.name = "Main"
	root.add_child(main)
	current_scene = main
	for i: int in 180:
		await process_frame
		if main.world.data != null and main.in_menu and not main.loading.visible:
			break
	var ready: bool = main.world.data != null and not main.world.countries.is_empty() and not main.loading.visible
	_check(ready, "stock Main reached the menu")
	if ready:
		main.set_process(false)
		main.net.set_process(false)
		main.net.lan.set_process(false)
		main.world.set_process(false)
		await _make_images(main)
		if not old.is_empty() and not recent.is_empty() and expected.size() == 2:
			await _matrix(main)
	main.queue_free()
	await process_frame
	print("SP_CONTINUE ", JSON.stringify({"checks": checks, "failures": failures, "restored": expected}))
	quit(0 if failures.is_empty() else 1)


func _make_images(main: MainScript) -> void:
	main.in_menu = false
	main.world.player = main.world.countries[0]
	main.world.player.is_player = true
	GameConfig.no_save = false
	GameConfig.tutorial = false
	Save.use_slot(1)
	Save.begin_new()
	for clock: int in [42, 77]:
		main.world.game_time = float(clock)
		main.world.rng.next_u32()
		var rng := main.world.rng.state
		_check(Save.save_game(main), "created a production FORMAT1 save at %d" % clock)
		var image := FileAccess.get_file_as_bytes(Save.PATH)
		var evidence := OS.get_environment("DF_TEST_LOG_DIR")
		if not evidence.is_empty():
			_check(_write(evidence.path_join("sp-continue-%d.save" % clock), image), "retained fixture %d" % clock)
		if clock == 42:
			old = image
		else:
			recent = image
		var loaded := await Save.load_slot(main, 1, "main")
		main.world.set_process(false)
		_check(loaded and main.world.game_time == clock and main.world.rng.state == rng,
			"direct primary restore defines expected clock and RNG at %d" % clock)
		if loaded:
			expected[clock] = _state(main)
		# save_game uses the timestamp for Continue's cross-slot ranking.
		await create_timer(0.01).timeout


func _state(main: MainScript) -> Dictionary:
	return {"game_time": main.world.game_time, "rng": main.world.rng.state, "hash": NetHash.of(main.world)}


func _write(path: String, bytes: PackedByteArray) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	return f != null and f.store_buffer(bytes)


func _place(copies: Dictionary, n: int = 1) -> void:
	Slots.delete(n)
	for k: String in copies:
		_check(_write(Slots.path(n, k), copies[k]), "placed %d/%s" % [n, k])


func _files() -> Dictionary:
	var files: Dictionary = {}
	for n: int in [1, 2]:
		for k: String in KEYS:
			var path := Slots.path(n, k)
			if FileAccess.file_exists(path):
				files[path] = FileAccess.get_sha256(path)
	for path: String in [LEGACY, LEGACY + ".pre332"]:
		if FileAccess.file_exists(path):
			files[path] = FileAccess.get_sha256(path)
	return files


func _available(label: String, clock: int, n: int = 1) -> void:
	var before := _files()
	var show := Save.has_save()
	var info := Save.save_info()
	_check(show == (clock >= 0), label + ": Continue visibility")
	_check(info.is_empty() if clock < 0 else info.get("game_time") == clock and info.get("slot") == n,
		label + ": displayed header is from the selected copy")
	_check(_files() == before, label + ": availability preserved every file and checksum")


func _continue(main: MainScript, label: String, clock: int) -> void:
	Save.want = []
	var loaded := await Save.load_game(main)
	main.world.set_process(false)
	_check(loaded == (clock >= 0), label + ": Continue result")
	if clock >= 0:
		_check(loaded and _state(main) == expected[clock], label + ": exact expected clock, RNG and NetHash")


func _future_main() -> PackedByteArray:
	var f := FileAccess.open(Slots.path(1, "main"), FileAccess.READ)
	if f == null:
		return PackedByteArray()
	var magic := f.get_32()
	var header: Dictionary = f.get_var()
	var remaining := f.get_buffer(f.get_length() - f.get_position())
	header["format"] = Save.FORMAT + 1
	var h := var_to_bytes(header)
	var bytes := PackedByteArray()
	bytes.resize(8)
	bytes.encode_u32(0, magic)
	bytes.encode_u32(4, h.size())
	bytes.append_array(h)
	bytes.append_array(remaining)
	return bytes


func _matrix(main: MainScript) -> void:
	var broken := "bad".to_utf8_buffer()
	_place({"main": old, "bak": recent, "tmp": recent})
	_available("primary precedes later backup and temp", 42)
	await _continue(main, "primary", 42)
	var future := _future_main()
	_check(not future.is_empty(), "generated a future-format header over valid snapshot bytes")

	_place({"tmp": old})
	_available("tmp only", 42)
	var tmp_info := Slots.info(1)
	_check(tmp_info["state"] == "ok" and tmp_info["head"].get("game_time") == 42,
		"tmp-only slot is visible in Saves")
	_check(Slots.default_pick() == 2, "new game defaults to an empty slot before a recoverable tmp")
	_check((tmp_info["rows"] as Array).any(func(row: Dictionary) -> bool: return row["key"] == "tmp"),
		"Saves offers an explicit tmp recovery row")
	await _continue(main, "tmp only", 42)
	# Exercise the actual Main menu request on a second load of identical bytes.
	main.world.game_time += 8.0
	Save.want = []
	main.menus.show_main()
	var has_button := false
	for button: Button in main.menus.screen.find_children("*", "Button", true, false):
		if button.text == Loc.t("ПРОДОЛЖИТЬ"):
			has_button = true
			break
	_check(has_button, "main menu exposes Continue for tmp-only recovery")
	if has_button:
		await main._on_menu("load_save")
	main.world.set_process(false)
	_check(_state(main) == expected[42], "repeated Continue through Main restores the exact snapshot")

	_place({"main": broken, "tmp": recent})
	_available("broken primary with tmp", 77)
	await _continue(main, "broken primary with tmp", 77)
	_place({"bak": old})
	_available("backup only", 42)
	_place({"main": broken, "bak": old})
	_available("broken primary with backup", 42)
	await _continue(main, "broken primary with backup", 42)

	_place({"bak": old, "tmp": recent})
	_available("backup precedes temp", 42)
	await _continue(main, "backup precedes temp", 42)
	Save.want = [1, "tmp"]
	_check(await Save.load_game(main), "explicit tmp still loads before backup")
	main.world.set_process(false)
	_check(_state(main) == expected[77], "explicit tmp restores the exact snapshot")
	_place({"main": old, "a0": recent, "bak": old, "tmp": old})
	_available("newer autosave precedes primary", 77)
	await _continue(main, "autosave order", 77)
	Save.want = [1, "main"]
	_check(await Save.load_game(main), "explicit preferred main still loads before newer autosave")
	main.world.set_process(false)
	_check(_state(main) == expected[42], "explicit preferred main restores the exact snapshot")

	_place({"main": future})
	_available("future format only", -1)
	await _continue(main, "future format only", -1)
	_place({"main": future, "bak": old})
	_available("future format with compatible backup", 42)
	_place({"main": recent.slice(0, recent.size() - 1), "bak": old})
	_available("header-readable truncated primary with backup", 42)
	_place({"main": broken, "bak": broken, "tmp": broken})
	_available("all corrupt", -1)
	await _continue(main, "all corrupt", -1)
	_check(not await Save.load_slot(main, 1), "explicit failure marks slot bad")
	_check(_write(Slots.path(1, "tmp"), recent), "placed valid temp after bad flag")
	_available("valid fallback after bad flag", 77)
	Slots.set_flag(1, "end", Slots.END_WIN)
	_available("ended slot stays hidden despite valid fallback", -1)
	_place({"main": old, "tmp": recent})
	Slots.set_flag(1, "end", Slots.END_WIN)
	_check(DirAccess.remove_absolute(Slots.path(1, "main")) == OK, "ended primary is removed, leaving a temp")
	_available("end marker survives loss of the last regular copy", -1)

	_place({"main": recent})
	_place({"bak": old}, 2)
	_available("newest slot originally selected", 77)
	_check(DirAccess.remove_absolute(Slots.path(1, "main")) == OK, "selected file disappears before Continue")
	await _continue(main, "fresh selection after file disappears", 42)
	_check(Save.slot == 2, "Continue switches to the remaining slot")
	_place({"main": old, "bak": recent})
	_place({"main": recent}, 2)
	_available("newer backup does not set an earlier primary's rank", 77, 2)
	await _continue(main, "compare timestamps of the selected copies", 77)
	_check(Save.slot == 2, "slot ranking preserves primary precedence within slot")
	_place({}, 2)
	_place({"main": old})
	_available("slot contents before replacement", 42)
	_check(_write(Slots.path(1, "main"), recent), "replaced selected file before Continue")
	await _continue(main, "fresh read after file replacement", 77)

	_place({"main": recent, "a0": old})
	Slots._write_meta(1, {"files": {"main": Slots.peek(Slots.path(1, "main")), "a0": Slots.peek(Slots.path(1, "a0"))}})
	_available("primary wins before autosave is replaced", 77)
	# Replace the primary with an older valid snapshot while leaving its metadata entry unchanged.
	# Rewriting the sidecar last forces its stale headers to remain eligible for the UI cache.
	var stale_meta := FileAccess.get_file_as_bytes(Slots.path(1, "meta"))
	_check(_write(Slots.path(1, "main"), old) and _write(Slots.path(1, "a0"), recent)
		and _write(Slots.path(1, "meta"), stale_meta), "swapped two snapshots behind a stale sidecar")
	_available("current copy headers determine order with stale metadata", 77)
	await _continue(main, "load uses new autosave order", 77)

	_place({"main": recent, "bak": old})
	_available("prime validation with readable primary", 77)
	var corrupted := recent.duplicate()
	corrupted[-1] ^= 1
	_check(_write(Slots.path(1, "main"), corrupted)
		and FileAccess.get_size(Slots.path(1, "main")) == recent.size(), "same-length corruption after validation")
	_available("same-length corruption invalidates availability", 42)
	await _continue(main, "same-length corruption falls back at load", 42)

	_place({})
	_place({}, 2)
	_available("all absent", -1)
	await _continue(main, "all absent", -1)
	_place({"tmp": broken})
	_check(Slots.info(1)["state"] == "bad", "invalid temp is reported as damaged")
	_available("corrupt temp alone", -1)
	Slots._migrated = false
	_place({"tmp": recent})
	_check(_write(LEGACY, old), "placed both a recoverable temp and legacy save")
	var coexist := _files()
	main.menus.show_main()
	_check(_files() == coexist, "menu preserves recoverable temp when legacy exists")
	await _continue(main, "Continue prefers the current slot before legacy preparation", 77)
	_check(FileAccess.get_sha256(Slots.path(1, "tmp")) == coexist.get(Slots.path(1, "tmp"))
		and FileAccess.get_sha256(LEGACY) == coexist.get(LEGACY), "loading preserves temp and legacy file contents")
	_place({})
	# The legacy mechanism is separate from the read-only probe and still runs at menu entry.
	Slots._migrated = false
	_check(_write(LEGACY, old), "placed a legacy save before showing the menu")
	var before := _files()
	Save.has_save()
	Save.save_info()
	_check(_files() == before, "availability does not migrate or modify legacy files")
	main.menus.show_main()
	_available("normal menu still discovers migrated legacy save", 42)
