extends SceneTree
## Read the actual packaged constants, not just the checkout's source files.
func _initialize() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var cfg := ConfigFile.new()
	var err: int = cfg.load("res://pc/version.cfg")
	var actual: String = NetConfig.version()
	var version: String = String(cfg.get_value("pc", "version", "")) if err == OK else ""
	var ok: bool = args.size() == 2 and actual == args[0] and version == args[1] and Menus.VERSION == "v" + version
	print("PACKAGED_IDENTITY ", JSON.stringify({"passed":ok,"identity":actual,"version":version}))
	quit(0 if ok else 1)
