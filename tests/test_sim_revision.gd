extends SceneTree
## Admission identity and fail-before-mutation saved-session version gate; isolated user:// only.
var args: Dictionary = {}
var checks: int = 0
var failures: Array = []
func _initialize() -> void:
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--") and arg.contains("="):
			args[arg.get_slice("=",0).trim_prefix("--")] = arg.substr(arg.find("=")+1)
	_run.call_deferred()
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures.append(label)
		push_error(label)
func state(n: NetSession) -> Array:
	return [n.mode,n.is_host,n.in_match,n.go,n.resume_wait,n.reconnecting,n.rejoining,
		n.exec_turn,n.exec_tick,n.turns.duplicate(true),n._pending.duplicate(true),n.status_text,n.slots.duplicate(true)]
func _run() -> void:
	if not OS.get_user_data_dir().contains("phase5c"):
		push_error("Run with an isolated Phase5C user directory")
		quit(2)
		return
	check(NetConfig.PROTO == 7,"transport protocol unchanged")
	check(NetConfig.SIM_REV == "pr10-phase5b2-1","candidate revision identifies new simulation semantics")
	check(NetConfig.version() == Menus.VERSION+"/7/pr10-phase5b2-1","full admission identity includes revision")
	var n := NetSession.new()
	n.mode = NetSession.Mode.LAN
	n.is_host = true
	n.in_match = true
	n.go = true
	n.resume_wait = false
	n.exec_turn = 17
	n.exec_tick = 2
	n.turns = {18:[{"t":"fixture"}]}
	n._pending = [{"t":"fixture pending"}]
	n.status_text = "unchanged"
	n.slots = [{"peer":1,"name":"fixture"}]
	var before: Array = state(n)
	for old: String in ["", Menus.VERSION+"/7", Menus.VERSION+"/7/pr10-critical-1", Menus.VERSION+"/6/pr10-phase5b2-1", Menus.VERSION+"/7/future-incompatible"]:
		NetConfig.save_match({"v":old,"snap":PackedByteArray([0,1]),"turn":999,"cfg":{"bots":11}})
		check(NetConfig.load_match().get("v") == old,"fixture is real serialized match: "+old)
		for attempt in 2:
			check(n.resume_host() == "Партия сохранена в другой версии игры","incompatible resume refused before snapshot parse: "+old)
			check(state(n) == before,"incompatible resume preserves session/queues/turn/flags: "+old)
	NetConfig.clear_match()
	check(n.resume_host() == "Нет сохранённой партии","missing match refused")
	check(state(n) == before,"missing match leaves session unchanged")
	n.free()
	var result := {"passed":failures.is_empty(),"checks":checks,"failures":failures,"identity":NetConfig.version()}
	FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("SIM_REV ",JSON.stringify(result))
	quit(0 if failures.is_empty() else 1)
