extends SceneTree
## Two independent loopback ENet processes; real NetSession._on_connected/_hello/_kick.
class HostNode:
	extends Node
	var world: GameWorld

var args: Dictionary = {}
var max_roster: int = 1

func _initialize() -> void:
	for a: String in OS.get_cmdline_user_args():
		args[a.get_slice("=",0).trim_prefix("--")] = a.substr(a.find("=")+1)
	_run.call_deferred()

func _run() -> void:
	NetConfig.test_no_broadcast = true
	var main := HostNode.new()
	main.world = GameWorld.new()
	root.add_child(main)
	var n := NetSession.new()
	n.name = "Net"
	root.add_child(n)
	n.setup(main)
	n.set_process(false)
	n.mode = NetSession.Mode.LAN
	var p := ENetMultiplayerPeer.new()
	var host: bool = args["role"] == "host"
	var err: int
	if host:
		p.set_bind_ip("127.0.0.1")
		err = p.create_server(int(args["port"]),3)
		n.is_host = true
		n.local_slot = 0
		n.slots = [{"peer":1,"name":"Host","ready":true,"left":false}]
		n.lobby_changed.connect(func()->void:max_roster=maxi(max_roster,n.slots.size()))
	else:
		err = p.create_client("127.0.0.1",int(args["port"]))
	if err != OK:
		push_error("ENet test socket: "+error_string(err))
		quit(2)
		return
	get_multiplayer().multiplayer_peer = p
	if host:
		FileAccess.open(args["ready"],FileAccess.WRITE).store_string("ready")
	var deadline: int = Time.get_ticks_msec()+45000
	var accepted: bool = false
	var rejected: bool = false
	while Time.get_ticks_msec() < deadline:
		await process_frame
		if host:
			if FileAccess.file_exists(args["stop"]):
				break
		else:
			accepted = n.local_slot >= 1
			rejected = n.mode == NetSession.Mode.OFF and n.status_text.contains(args["host_version"])
			if accepted or rejected:
				break
	var result := {"role":args["role"],"version":NetConfig.version(),"accepted":accepted,"rejected":rejected,
		"max_roster":max_roster,"status":n.status_text,"local_slot":n.local_slot,"port":int(args["port"])}
	FileAccess.open(args["out"],FileAccess.WRITE).store_string(JSON.stringify(result,"\t"))
	print("ADMISSION ",JSON.stringify(result))
	quit(0 if host or accepted or rejected else 1)
