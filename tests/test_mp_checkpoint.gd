extends SceneTree
## Isolated synthetic profiles. The host loader uses an ephemeral ENet room.

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
		"seed", "retry", "resume":
			await _live(mode)
		"short-write", "short-tail":
			_short_write()
		"publish":
			_publish()
		"review":
			_review()
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
		elif mode == "retry":
			_retry(main)
		else:
			await _resume(main, int(OS.get_cmdline_user_args()[1]))
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
	_check(DirAccess.remove_absolute(PRIMARY) == OK and DirAccess.make_dir_absolute(STAGING) == OK,
		"disk checkpoint removed and retry storage temporarily blocked")
	for attempt: int in 2:
		_check(not net.save_match() and NetConfig.load_match().is_empty(),
			"stale marker cannot hide a failed same-turn repair (attempt %d)" % attempt)
	_check(DirAccess.remove_absolute(STAGING) == OK and net.save_match() and NetConfig.load_match().get("turn") == 10,
		"same-turn repair commits after transient failure")
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
	for attempt: int in 2:
		_check(not NetConfig.save_match(next), "blocked publication returns failure (attempt %d)" % attempt)
		_check(FileAccess.get_sha256(BACKUP) == digest and NetConfig.load_match() == prior,
			"failed promotion preserves the only readable backup (attempt %d)" % attempt)
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


func _write_image(path: String, image: Dictionary) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	return f != null and f.store_var(image, false)


func _review() -> void:
	var original := NetConfig.load_match()
	_check(original.get("turn") == 10, "start with a valid primary")
	if original.is_empty():
		return
	var next := original.duplicate()
	next["turn"] = 11
	_check(_write_text(STAGING) and NetConfig.load_match() == original, "interrupted write ignores partial tmp")
	_check(_write_image(STAGING, next) and NetConfig.load_match() == original, "complete tmp is still unpublished")
	_check(DirAccess.rename_absolute(PRIMARY, BACKUP) == OK and NetConfig.load_match() == original,
		"interruption after rotation loads backup")
	_check(DirAccess.rename_absolute(STAGING, PRIMARY) == OK and NetConfig.load_match() == next,
		"interruption after publication loads the new primary")

	var bad := next.duplicate(true)
	var broken: PackedByteArray = bad["snap"]
	broken.encode_u32(4, 1)  # Shorten the encoded two-item snapshot wrapper, keeping all bytes on disk.
	bad["snap"] = broken
	var original_size := FileAccess.get_size(PRIMARY)
	var backup_hash := FileAccess.get_sha256(BACKUP)
	_check(_write_image(PRIMARY, bad) and FileAccess.get_size(PRIMARY) == original_size,
		"corrupt primary has the same size and a decodable outer Variant")
	var payload := var_to_bytes(next)
	_check(_write_image(STAGING, next) and NetConfig._staged_matches(payload),
		"readback accepts exact serialized bytes")
	_check(_write_image(STAGING, bad) and FileAccess.get_size(STAGING) == original_size
		and not NetConfig._staged_matches(payload), "readback rejects same-length staging corruption")
	_check(NetConfig.load_match() == original, "same-size corrupted snapshot falls back to backup")
	for attempt: int in 2:
		_check(not NetConfig.save_match(bad), "invalid snapshot cannot commit (attempt %d)" % attempt)
		_check(FileAccess.get_sha256(BACKUP) == backup_hash and NetConfig.load_match() == original,
			"invalid snapshot cannot replace readable backup (attempt %d)" % attempt)
	_check(NetConfig.save_match(next) and FileAccess.get_sha256(BACKUP) == backup_hash,
		"valid retry never rotates corrupt primary onto valid backup")
	NetConfig.clear_match()
	_check(_write_image(STAGING, next) and NetConfig.load_match().is_empty(),
		"staging alone is never an eligible checkpoint")
	NetConfig.clear_match()
	_check(_write_image(PRIMARY, original), "restore seed for publication tests")


func _resume(main: Node, port: int) -> void:
	var net: NetSession = main.net
	NetConfig.LAN_PORT = port
	net.is_host = true
	net.in_match = true
	net.go = true
	net.mode = NetSession.Mode.LAN
	net.slots = [{"peer": 1, "name": "CheckpointFixture", "arch": 0}]
	net.exec_turn = 11
	var saved_rng: int = main.world.rng.state
	_check(net.save_match(), "session publishes a real checkpoint with a local host seat")
	var primary_hash := ""
	for use_backup: bool in [false, true]:
		if use_backup:
			_check(DirAccess.rename_absolute(PRIMARY, BACKUP) == OK, "only the backup exists after interruption")
		main.in_menu = true
		net.in_match = false
		_check(net.resume_host().is_empty(), "public LAN host-resume accepts checkpoint (backup=%s)" % use_backup)
		var deadline := Time.get_ticks_msec() + 30000
		while net.in_match and net._restored_turn != 10 and Time.get_ticks_msec() < deadline:
			await process_frame
		_check(net._restored_turn == 10 and net.exec_turn == 11 and net._saved_turn == 10,
			"public restore commits saved marker and turn (backup=%s)" % use_backup)
		_check(main.world.rng.state == saved_rng and main.world.game_time == 42.0,
			"public restore recovers snapshot state (backup=%s)" % use_backup)
		if use_backup:
			_check(NetHash.of(main.world) == primary_hash, "primary and backup resume to the same NetHash")
		else:
			primary_hash = NetHash.of(main.world)
	net.in_match = false
	net.leave(false, false, true, true)
