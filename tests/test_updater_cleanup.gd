extends RefCounted
## Executes the real updater cleanup only; never adds updater to a SceneTree or calls _ready/_run.
var checks: int = 0
var failures: Array = []
var skipped: Array = []

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures.append(label)
		push_error(label)

func put(dir: String, name: String, contents: String = "fixture") -> void:
	var f := FileAccess.open(dir.path_join(name),FileAccess.WRITE)
	assert(f != null)
	f.store_string(contents)
	f.close()

func run(base: String) -> Dictionary:
	if not base.is_absolute_path() or not (base.contains("phase5c") or base.contains("df_updater_")):
		return {"passed":false,"checks":0,"failures":["Refusing non-test directory"],"skipped":[]}
	DirAccess.make_dir_recursive_absolute(base)
	var root_dir := DirAccess.open(base)
	if root_dir == null or not root_dir.get_files().is_empty() or not root_dir.get_directories().is_empty():
		return {"passed":false,"checks":0,"failures":["Fixture root must be empty"],"skipped":[]}
	var dir: String = base.path_join("installation")
	DirAccess.make_dir_absolute(dir)
	var u: Node = (load("res://pc/updater.gd") as GDScript).new()
	u.set("_exe",dir.path_join("DroneFlames.exe"))
	var foreign: Array[String] = ["notes.tmp","backup.old","draft.new","other_game.exe.old","other_lib.dll.new","libs.rev","save.bak"]
	for name: String in foreign:
		put(dir,name)
	put(dir,"DroneFlames.exe")
	put(dir,"DroneFlames.exe.old","valid rollback fixture")
	put(dir,"DroneFlames.exe.new")
	put(dir,"DroneFlames.exe.tmp")
	put(dir,"write.test.tmp")
	put(dir,"libs.zip.tmp")
	for lib: String in u.LIB_FILES:
		put(dir,lib)
		put(dir,lib+".old","valid rollback fixture")
		put(dir,lib+".new")
	u.call("_cleanup_old")
	for name: String in foreign:
		check(FileAccess.file_exists(dir.path_join(name)),"unrelated file retained: "+name)
	check(FileAccess.file_exists(dir.path_join("DroneFlames.exe")),"running executable retained")
	check(FileAccess.file_exists(dir.path_join("DroneFlames.exe.old")),"rollback retained even when primary exists but integrity is unproven")
	for lib: String in u.LIB_FILES:
		check(FileAccess.file_exists(dir.path_join(lib+".old")),"library rollback retained: "+lib)
	for name: String in ["DroneFlames.exe.new","write.test.tmp","libs.zip.tmp"]:
		check(not FileAccess.file_exists(dir.path_join(name)),"owned expendable temporary cleaned: "+name)
	check(FileAccess.file_exists(dir.path_join("DroneFlames.exe.tmp")),"unproduced executable .tmp is not assumed owned")
	for lib: String in u.LIB_FILES:
		check(FileAccess.file_exists(dir.path_join(lib+".new")),"unproduced DLL staging retained: "+lib)
	var d := DirAccess.open(dir)
	var before: PackedStringArray = d.get_files()
	u.call("_cleanup_old")
	check(d.get_files() == before,"repeated cleanup is idempotent")
	# Missing and zero-length primaries are not grounds to discard possible recovery staging.
	DirAccess.remove_absolute(dir.path_join("steam_api64.dll"))
	put(dir,"steam_api64.dll.new")
	put(dir,"libs.zip.tmp")
	put(dir,"libgodotsteam.windows.template_release.x86_64.dll","")
	put(dir,"libgodotsteam.windows.template_release.x86_64.dll.new")
	u.call("_cleanup_old")
	for name: String in ["steam_api64.dll.old","steam_api64.dll.new","libs.zip.tmp","libgodotsteam.windows.template_release.x86_64.dll.old","libgodotsteam.windows.template_release.x86_64.dll.new"]:
		check(FileAccess.file_exists(dir.path_join(name)),"incomplete update recovery retained: "+name)
	# A started .old executable must remain intact too.
	put(dir,"DroneFlames.exe.old","running rollback fixture")
	u.set("_exe",dir.path_join("DroneFlames.exe.old"))
	u.call("_cleanup_old")
	check(FileAccess.file_exists(dir.path_join("DroneFlames.exe.old")),"running .old executable retained")
	if u.has_method("_is_safe_updater_artifact"):
		for name: String in ["../write.test.tmp","sub/libs.zip.tmp","..\\DroneFlames.exe.new","DroneFlames.exe.new:stream"]:
			check(not bool(u.call("_is_safe_updater_artifact",name,d)),"path/alternate stream rejected: "+name)
	else:
		check(false,"bounded artifact validator exists")
	# Directory with an owned-looking basename must not be removed.
	DirAccess.make_dir_absolute(dir.path_join("write.test.tmp"))
	u.call("_cleanup_old")
	check(DirAccess.dir_exists_absolute(dir.path_join("write.test.tmp")),"owned-looking directory retained")
	put(base,"outside.txt","outside sentinel")
	var link: String = dir.path_join("libs.zip.tmp")
	DirAccess.remove_absolute(link)
	var linked: Error = d.create_link(base.path_join("outside.txt"),link)
	if linked == OK:
		u.call("_cleanup_old")
		check(d.is_link("libs.zip.tmp"),"artifact symlink retained")
		check(FileAccess.get_file_as_string(base.path_join("outside.txt")) == "outside sentinel","symlink external target unchanged")
	else:
		skipped.append("artifact symlink creation: "+error_string(linked))
	var primary_link: Error = d.create_link(base.path_join("outside.txt"),dir.path_join("steam_api64.dll"))
	if primary_link == OK:
		u.call("_cleanup_old")
		check(FileAccess.file_exists(dir.path_join("steam_api64.dll.new")),"symlink primary is not evidence of a valid install")
	else:
		skipped.append("primary symlink creation: "+error_string(primary_link))
	# Permission errors are observed on POSIX; Windows deny-delete semantics need their own fixture.
	if OS.get_name() == "Linux":
		var denied := base.path_join("denied")
		DirAccess.make_dir_absolute(denied)
		put(denied,"write.test.tmp")
		FileAccess.set_unix_permissions(denied,365) # 0555
		u.set("_exe",denied.path_join("DroneFlames.exe"))
		u.call("_cleanup_old")
		check(FileAccess.file_exists(denied.path_join("write.test.tmp")),"delete permission failure retains file without script error")
		FileAccess.set_unix_permissions(denied,493)
	else:
		skipped.append("POSIX permission fixture N/A on "+OS.get_name())
	if OS.get_name() == "Windows":
		var win := base.path_join("windows-case")
		DirAccess.make_dir_absolute(win)
		put(win,"droneflames.exe")
		put(win,"DRONEFLAMES.EXE.NEW")
		put(win,"DRONEFLAMES.EXE.OLD")
		put(win,"WRITE.TEST.TMP")
		u.set("_exe",win.path_join("droneflames.exe"))
		u.call("_cleanup_old")
		check(not FileAccess.file_exists(win.path_join("DRONEFLAMES.EXE.NEW")) and not FileAccess.file_exists(win.path_join("WRITE.TEST.TMP")),"Windows real filesystem case-insensitive cleanup")
		check(FileAccess.file_exists(win.path_join("DRONEFLAMES.EXE.OLD")),"Windows case-insensitive rollback retained")
		put(win,"write.test.tmp")
		var held := FileAccess.open(win.path_join("write.test.tmp"),FileAccess.READ)
		check(held != null,"Windows held-file fixture opened")
		u.call("_cleanup_old")
		if FileAccess.file_exists(win.path_join("write.test.tmp")):
			check(true,"Windows sharing-denied temporary retained")
		else:
			skipped.append("Runtime permits unlink with FileAccess handle; exclusive deny-delete not exercised")
		if held != null:
			held.close()
		u.call("_cleanup_old")
		check(not FileAccess.file_exists(win.path_join("write.test.tmp")),"Windows retry after handle close cleans owned temporary")
	u.free()
	return {"passed":failures.is_empty(),"checks":checks,"failures":failures,"skipped":skipped,"platform":OS.get_name(),"real_cleanup_only":true}
