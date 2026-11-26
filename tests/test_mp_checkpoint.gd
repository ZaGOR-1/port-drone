extends SceneTree
## Isolated synthetic profiles. No live account or transport is used.

const MainScript = preload("res://game/main.gd")
const PRIMARY := NetConfig.MATCH_FILE
const BACKUP := PRIMARY + ".bak"
const STAGING := PRIMARY + ".tmp"
const WRITE_LIMIT := 32768
var failures: Array[String] = []
var checks := 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	var mode: String = OS.get_cmdline_user_args()[0]
	if not OS.get_user_data_dir().contains("df_mp_checkpoint_"):
		quit(2)
		return
	match mode:
		"seed", "retry":
			await _live(mode)
		"short-write", "short-tail":
			_short_write()
		"publish":
			_publish()
		_:
			quit(2)
			return
	print("MP_CHECKPOINT ", JSON.stringify({"case": mode, "checks": checks, "failures": failures}))
	quit(0 if failures.is_empty() else 1)


func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)


func _live(mode: String) -> void:
	seed(159331)
	var main: Node = MainScript.new()
	main.name = "Main"
	root.add_child(main)
	current_scene = main
	for i: int in 180:
		await process_frame
		if main.world.data != null and main.in_menu and not main.loading.visible:
			break
	var ready: bool = main.world.data != null and not main.world.countries.is_empty() and not main.loading.visible
	_check(ready, "stock Main reached its menu")
	if ready:
		main.set_process(false)
		main.net.set_process(false)
		main.net.lan.set_process(false)
		main.world.set_process(false)
		main.in_menu = false
		main.world.player = main.world.countries[0]
		main.world.player.is_player = true
		main.world.game_time = 42.0
		NetConfig.set_nick("CheckpointFixture")
		if mode == "seed":
			var snap := Save.net_snapshot(main)
			var image := {"v": NetConfig.version(), "mode": "lan", "turn": 10, "snap": snap,
				"t": int(Time.get_unix_time_from_system())}
			# Use the legacy writer independent of either implementation.
			var f := FileAccess.open(PRIMARY, FileAccess.WRITE)
			_check(f != null and f.store_var(image, false), "legacy checkpoint written")
			if f != null:
				f.close()
			_check(NetConfig.load_match() == image and not Save._net_body(snap).is_empty(),
				"committed legacy checkpoint and snapshot are readable")
		else:
			_retry(main)
	main.queue_free()
	await process_frame


func _retry(main: Node) -> void:
	var net: NetSession = main.net
	net.is_host = true
	net.in_match = true
	net.go = true
	net.mode = NetSession.Mode.LAN
	net.exec_turn = 11
	var hash_before := NetHash.of(main.world)
	var rng_before: int = main.world.rng.state
	_check(DirAccess.make_dir_absolute(STAGING) == OK, "temporary-file open fault installed")
	net.save_match()
	_check(net._saved_turn == -1, "failed write leaves saved turn unchanged")
	_check(NetConfig.load_match().is_empty(), "failed initial write cannot create a checkpoint")
	_check(DirAccess.remove_absolute(STAGING) == OK, "temporary storage became available")
	net.save_match()
	var saved := NetConfig.load_match()
	var snap: PackedByteArray = saved.get("snap", PackedByteArray())
	_check(saved.get("turn") == 10 and net._saved_turn == 10, "retry commits the same turn")
	_check(snap == Save.net_snapshot(main) and not Save._net_body(snap).is_empty(),
		"committed snapshot is exact and passes restore preflight")
	_check(hash_before == NetHash.of(main.world) and rng_before == main.world.rng.state,
		"saving and retry preserve simulation hash and RNG")
	var saved_hash := FileAccess.get_sha256(PRIMARY)
	main.world.game_time += 1.0
	net.save_match()
	_check(not saved_hash.is_empty() and FileAccess.get_sha256(PRIMARY) == saved_hash,
		"successful saves still deduplicate the same turn")
	net._reset_lockstep()
	_check(net._saved_turn == -1, "a fresh lockstep session has no saved turn")
	net.in_match = false
	net.is_host = false
	net.go = false


func _short_write() -> void:
	var image := NetConfig.load_match()
	var digest := FileAccess.get_sha256(PRIMARY)
	_check(image.get("turn") == 10 and FileAccess.get_size(PRIMARY) > WRITE_LIMIT,
		"good checkpoint exceeds injected write limit")
	var next := image.duplicate()
	next["turn"] = 11
	NetConfig.save_match(next)
	_check(not digest.is_empty() and FileAccess.get_sha256(PRIMARY) == digest and NetConfig.load_match() == image,
		"short write preserves the original checkpoint byte for byte")
	_check(not FileAccess.file_exists(STAGING), "failed staging file was removed")


func _publish() -> void:
	var original := NetConfig.load_match()
	var digest := FileAccess.get_sha256(PRIMARY)
	_check(original.get("turn") == 10 and not digest.is_empty(), "legacy checkpoint is available")
	var next := original.duplicate()
	next["turn"] = 11
	_check(DirAccess.make_dir_absolute(BACKUP) == OK and _write_text(BACKUP + "/blocked"),
		"rotation destination is blocked by a nonempty directory")
	NetConfig.save_match(next)
	_check(FileAccess.get_sha256(PRIMARY) == digest and NetConfig.load_match() == original,
		"failed rotation preserves the primary")
	_check(not FileAccess.file_exists(STAGING), "failed rotation staging file was removed")
	_check(DirAccess.remove_absolute(BACKUP + "/blocked") == OK and DirAccess.remove_absolute(BACKUP) == OK,
		"rotation destination is available again")
	NetConfig.save_match(next)
	_check(NetConfig.load_match().get("turn") == 11 and FileAccess.get_sha256(BACKUP) == digest,
		"successful publication replaces primary and retains the old checkpoint")

	# Recreate the on-disk boundary after backup rotation but before publication.
	_check(DirAccess.remove_absolute(BACKUP) == OK and DirAccess.rename_absolute(PRIMARY, BACKUP) == OK
		and _write_text(STAGING), "interrupted publication leaves a backup and staging bytes")
	var prior := NetConfig.load_match()
	digest = FileAccess.get_sha256(BACKUP)
	_check(prior.get("turn") == 11 and not digest.is_empty(), "backup is readable across an interrupted promotion")
	_check(DirAccess.make_dir_absolute(PRIMARY) == OK and _write_text(PRIMARY + "/blocked"),
		"primary destination is blocked by a nonempty directory")
	next["turn"] = 12
	NetConfig.save_match(next)
	_check(FileAccess.get_sha256(BACKUP) == digest and NetConfig.load_match() == prior,
		"failed promotion preserves the readable backup")
	_check(DirAccess.remove_absolute(PRIMARY + "/blocked") == OK and DirAccess.remove_absolute(PRIMARY) == OK
		and _write_text(PRIMARY), "a truncated primary simulates an older failed save")
	_check(NetConfig.load_match() == prior, "truncated primary falls back to the backup")
	NetConfig.save_match(next)
	_check(NetConfig.load_match().get("turn") == 12 and FileAccess.get_sha256(BACKUP) == digest,
		"successful retry publishes over the broken primary and keeps the backup")
	_check(_write_text(STAGING), "created a leftover temporary file before explicit clear")
	NetConfig.clear_match()
	_check(NetConfig.load_match().is_empty() and not FileAccess.file_exists(PRIMARY)
		and not FileAccess.file_exists(BACKUP) and not FileAccess.file_exists(STAGING),
		"explicit clear removes primary, backup and leftover staging")


func _write_text(path: String) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	return f != null and f.store_string("partial")
