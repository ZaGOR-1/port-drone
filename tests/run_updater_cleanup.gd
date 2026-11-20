extends SceneTree
func _initialize() -> void:
	_run.call_deferred()
func _run() -> void:
	var args: Dictionary = {}
	for a: String in OS.get_cmdline_user_args():
		args[a.get_slice("=",0).trim_prefix("--")] = a.substr(a.find("=")+1)
	var suite = load("res://dev/test_updater_cleanup.gd").new() if ResourceLoader.exists("res://dev/test_updater_cleanup.gd") else load(args["suite"]).new()
	var result: Dictionary = suite.run(args["root"])
	FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("UPDATER_CLEANUP ",JSON.stringify(result))
	quit(0 if result["passed"] else 1)
