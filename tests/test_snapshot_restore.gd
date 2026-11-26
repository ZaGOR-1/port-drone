extends SceneTree
## Inject the loader result; execute the real session success/failure/queue lifecycle.
var checks: int = 0
var failures: Array = []
var scenarios: Dictionary = {}

class MainStub:
	extends Node
	var world: GameWorld
	var successes: int = 0
	var closed: int = 0
	var toasts: Array = []
	var inject_error: bool = false
	func net_prepare_restore() -> bool:
		if inject_error:
			push_error("R02_INJECTED_POST_LOAD_FAILURE")
		return true
	func net_after_restore() -> void:
		successes += 1
	func net_match_closed() -> void:
		closed += 1
	func net_toast(text: String) -> void:
		toasts.append(text)

class InjectNet:
	extends NetSession
	signal release_load
	var result: bool = true
	var partial: bool = false
	var deferred: bool = false
	var loads: int = 0
	func _restore_snapshot(_buf: PackedByteArray, current: Callable = Callable()) -> bool:
		loads += 1
		if deferred:
			await release_load
		if not current.is_null() and (not current.is_valid() or not current.call()):
			return false
		if result or partial:
			gw.game_time = 100.0 + loads
			gw.rng.state = 900 + loads
		return result

func _initialize() -> void:
	_run.call_deferred()

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures.append(message)
		push_error(message)

func fixture() -> InjectNet:
	var m := MainStub.new()
	root.add_child(m)
	var w := GameWorld.new()
	m.world = w
	w.data = WorldData.new(16,16,42)
	w.rng = Rng.new(42)
	w.mil = Military.new(w)
	w.army = Army.new(w)
	w.econ = Economy.new(w)
	w.diplo = Diplomacy.new(w)
	var c := Country.new()
	c.id = 1
	c.is_player = true
	w.countries.append(c)
	w.player = c
	w.net_tick = 22
	w.game_time = 4.0
	w.net_driven = true
	w.set_process(true)
	var net := InjectNet.new()
	m.add_child(net)
	net.setup(m)
	net.set_process(false)
	net.in_match = true
	net.mode = NetSession.Mode.LAN
	net.local_slot = 0
	net.rejoining = true
	net.exec_turn = 4
	net.exec_tick = 2
	net.turns = {100:[]}
	net._pending = [{"k":"town","s":0,"cell":Vector2i(2,2)}]
	return net

func state(n: InjectNet) -> Dictionary:
	var m: MainStub = n.main
	return {"turn":n.exec_turn,"tick":n.exec_tick,"net_tick":n.gw.net_tick,
		"time":n.gw.game_time,"rng":n.gw.rng.state,"hash":NetHash.of(n.gw),
		"in_match":n.in_match,"go":n.go,"rejoining":n.rejoining,"reconnecting":n.reconnecting,
		"restoring":n._restoring,"slot":n.local_slot,"pending":n._pending.duplicate(true),
		"turns":n.turns.duplicate(true),"resyncs":n.resyncs,"successes":m.successes,"closed":m.closed,"toasts":m.toasts.duplicate()}

func dispose(n: InjectNet) -> void:
	var w: GameWorld = n.gw
	n.main.free()
	w.free()

func failed(n: InjectNet, before: Dictionary, label: String, partial: bool = false) -> void:
	var after := state(n)
	check(not n.in_match and not n.go and not n._restoring and not n.reconnecting and not n.rejoining,label+": fail closed, no automatic reconnect")
	check(n.main.successes == 0 and not n.main.toasts.has("ВЫ СНОВА В ПАРТИИ"),label+": no success notification")
	check(n._pending.is_empty() and n.turns.is_empty(),label+": ended session discards commands")
	check(n.resyncs == 0,label+": failure not counted as successful restore")
	check(not n.status_text.is_empty(),label+": visible failure diagnostic")
	if not partial:
		check(after["time"] == before["time"] and after["rng"] == before["rng"] and after["hash"] == before["hash"],label+": rejected input leaves sampled authoritative world unchanged")
	else:
		check(not n.gw.is_processing(),label+": partially rebuilt world cannot run")
	scenarios[label] = {"before":before,"after":after}

func _run() -> void:
	for label: String in ["invalid","truncated","deserialize","missing","incompatible","reconnect","resync"]:
		var n := fixture()
		n.result = false
		if label == "resync":
			n.rejoining = false
			n.go = true
		var before := state(n)
		await n._restore_from(label.to_utf8_buffer(),99)
		failed(n,before,label)
		dispose(n)
	var partial := fixture()
	partial.result = false
	partial.partial = true
	var old := state(partial)
	await partial._restore_from(PackedByteArray([1]),99)
	failed(partial,old,"intermediate",true)
	dispose(partial)
	var n := fixture()
	var pending: Array = n._pending.duplicate(true)
	await n._restore_from(PackedByteArray([1]),99)
	check(n.exec_turn == 100 and n.exec_tick == 0 and n.gw.net_tick == 300,"valid: commit clocks after loader success")
	check(n.go and not n.rejoining and not n._restoring and n.main.successes == 1,"valid: resume and notify once")
	check(n._pending == pending and n.turns.has(100),"valid: pending and next turn preserved")
	var once := state(n)
	await n._restore_from(PackedByteArray([1]),99)
	check(state(n) == once and n.loads == 1,"duplicate: already applied snapshot is idempotent")
	scenarios["valid_and_duplicate"] = state(n)
	dispose(n)
	n = fixture()
	n.result = false
	await n._restore_from(PackedByteArray([0]),10)
	# Retry is an explicit fresh session, not an infinite automatic reconnect loop.
	n.in_match = true
	n.local_slot = 0
	n.mode = NetSession.Mode.LAN
	n.rejoining = true
	n.result = true
	await n._restore_from(PackedByteArray([1]),11)
	check(n.in_match and n.go and n.exec_turn == 12 and n.gw.net_tick == 36,"retry: a fresh session can restore successfully")
	dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),10)
	n._restore_from(PackedByteArray([1]),12)
	n._restore_from(PackedByteArray([1]),11)
	check(n.loads == 1,"concurrent: loader executions serialized")
	n.deferred = false
	n.release_load.emit()
	await process_frame
	check(n.exec_turn == 13 and n.gw.net_tick == 39 and n.loads == 2,"concurrent: only newest queued snapshot applied")
	dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),99)
	n.leave(false,true,true,true)
	var ended := state(n)
	n.release_load.emit()
	await process_frame
	check(state(n) == ended,"cancel: stale async completion cannot mutate ended session")
	dispose(n)
	n = fixture()
	n.is_host = true
	n.resume_wait = true
	n.slots = [{"peer":1,"left":false,"name":"Host"}]
	n.result = false
	await n._resume_restore({"snap":PackedByteArray([0]),"turn":99})
	check(not n.in_match and not n.go and n._host_turn == 0 and n.main.successes == 0,"host resume: failure cannot start or advance saved match")
	dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),20)
	n.leave(false,true,true,true)
	n.in_match = true
	n.local_slot = 0
	var replacement := state(n)
	n.release_load.emit()
	await process_frame
	check(state(n) == replacement,"new session: stale completion cannot commit into replacement session")
	dispose(n)
	n = fixture()
	n._snap_begin(10,3,1)
	n._snap_begin(10,3,1)
	n._snap_part(0,PackedByteArray([1,2,3]))
	var assembled := state(n)
	n._snap_begin(10,3,1)
	n._snap_part(0,PackedByteArray([1,2,3]))
	check(n.loads == 1 and state(n) == assembled,"assembly: repeated begin/parts do not reapply completed snapshot")
	dispose(n)
	n = fixture()
	var pre_fragment := state(n)
	n._snap_begin(10,3,1)
	n._snap_part(1,PackedByteArray([1,2,3]))
	failed(n,pre_fragment,"invalid_fragment")
	dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),30)
	if n.has_method("_restore_timeout"):
		n.call("_restore_timeout",n.get("_restore_epoch"),30)
	else:
		check(false,"timeout: bounded restore deadline exists")
	check(not n.in_match and not n.go and not n._restoring,"timeout: bounded failure ends session")
	n.release_load.emit()
	await process_frame
	check(not n.in_match and n.main.successes == 0,"timeout: late completion cannot report success")
	dispose(n)
	n = fixture()
	var checkpoint := FileAccess.open(NetConfig.MATCH_FILE, FileAccess.WRITE)
	check(checkpoint != null and checkpoint.store_var({"marker":"R02-synthetic"}),
		"failure preservation fixture written")
	if checkpoint != null:
		checkpoint.close()
	NetConfig.save_rejoin({"tok":"R02-synthetic","mode":"lan"})
	var saved: PackedByteArray = FileAccess.get_file_as_bytes(NetConfig.MATCH_FILE)
	n.result = false
	await n._restore_from(PackedByteArray([0]),40)
	check(not saved.is_empty() and FileAccess.get_file_as_bytes(NetConfig.MATCH_FILE) == saved,
		"failure preserves saved host checkpoint")
	check(NetConfig.load_rejoin().get("tok","") == "R02-synthetic","failure preserves saved seat for explicit retry")
	dispose(n)
	n = fixture()
	n.local_slot = 3
	var before_owner := state(n)
	await n._restore_from(PackedByteArray([1]),50)
	failed(n,before_owner,"missing_local_country",true)
	dispose(n)
	n = fixture()
	n.main.inject_error = true
	var before_callback := state(n)
	await n._restore_from(PackedByteArray([1]),60)
	failed(n,before_callback,"post_load_cleanup",true)
	check(n.gw.net_tick == before_callback["net_tick"],"post-load error cannot commit snapshot tick")
	dispose(n)
	for saved_meta: Dictionary in [{"snap":"bad","turn":99},{"snap":PackedByteArray([0]),"turn":"99"},{"snap":PackedByteArray([0])}]:
		n = fixture()
		n.is_host = true
		n.resume_wait = true
		var before_saved := state(n)
		await n._resume_restore(saved_meta)
		failed(n,before_saved,"invalid_saved_resume_"+str(checks))
		dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),99)
	n._start_reconnect()
	var lost_state := state(n)
	n.release_load.emit()
	await process_frame
	check(n.reconnecting and not n.go and not n._restoring,"connection loss cancels active restore and keeps bounded reconnect")
	check(n.gw.game_time == lost_state["time"] and n.gw.rng.state == lost_state["rng"] and n.gw.net_tick == lost_state["net_tick"] and n.main.successes == 0,"connection loss: old loader cannot commit while reconnecting")
	dispose(n)
	n = fixture()
	n.deferred = true
	n._restore_from(PackedByteArray([1]),99)
	n._on_promoted()
	n.release_load.emit()
	await process_frame
	check(not n.in_match and not n.go and not n._restoring,"promotion cannot host a partially restored world")
	check(n.main.successes == 0,"promotion: invalidated restore has no success callback")
	dispose(n)
	n = fixture()
	var before_overflow := state(n)
	await n._restore_from(PackedByteArray([1]),0x7fffffffffffffff)
	failed(n,before_overflow,"overflow_turn")
	check(n.loads == 0,"overflow turn rejected before touching authoritative world")
	dispose(n)
	var result := {"checks":checks,"passed":failures.is_empty(),"failures":failures,"scenarios":scenarios,"expected_post_load_errors":1}
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			FileAccess.open(arg.trim_prefix("--out="),FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("SNAPSHOT_RESTORE ",JSON.stringify({"checks":checks,"failures":failures}))
	quit(0 if failures.is_empty() else 1)
