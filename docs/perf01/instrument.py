"""Add PERF-01 timing scopes to an isolated physical copy of game/."""
import os
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
scopes = {
    "game/main/main_core.gd": ("_missile_tap", "_plan_tap", "_plan_targets", "_missile_mp", "_draw_ghost"),
    "game/main/main_strike.gd": ("_strike_update", "strike_fire", "strike_close", "strike_open", "_plan_back"),
    "game/main.gd": ("_pc_hover_ui", "_process"),
    "game/military/mil_strike.gd": ("missile_multi_plan", "launch_missiles_multi", "tels_for"),
    "game/military.gd": ("_update_tels",),
    "game/strike_hub.gd": ("ready_all", "plan", "eta", "war_notes", "fire"),
    "ui/ui24/strike_sheet.gd": ("refresh",),
    "ui/ui24/strike_marks.gd": ("_draw",),
    "ui/route_overlay.gd": ("_draw",),
}
detailed = os.environ.get("PERF02_SCOPES") == "1"
shortage = os.environ.get("PERF03_SCOPES") == "1"
if detailed:
    extra = {
        "game/main/main_core.gd": ("_set_mode",),
        "game/main/main_strike.gd": ("_strike_done",),
        "game/main/main_input.gd": ("_tap", "_begin_press", "_release_press"),
        "game/military/mil_strike.gd": ("_strike_pts", "missile_plan", "_apply_missile_plan"),
        "game/strike_hub.gd": ("_launch_now",),
        "game/game_world.gd": ("cmd_strike",),
        "game/diplomacy/dip_rules.gd": ("strike_block_at",),
        "net/net_session.gd": ("call_sim", "issue", "_exec", "_owns"),
        "net/net_codec.gd": ("encode", "decode"),
        "ui/ui24/strike_sheet.gd": ("_set_txt",),
        "ui/route_overlay.gd": ("_arc",),
    }
    for key, additional in extra.items():
        scopes[key] = scopes.get(key, ()) + additional
for relative, names in scopes.items():
    path = root / relative
    source = path.read_text()
    if shortage and path.name == "mil_strike.gd":
        if not detailed:
            raise ValueError("PERF03_SCOPES requires PERF02_SCOPES")
        probe = 'preload("res://perf01_scopes.gd")'

        def meter(indent, label, value):
            return f'{indent}if {probe}.enabled:\n{indent}\t{probe}._record("{label}", {value})\n'

        start = source.index("func tels_for(")
        sort = source.index("\tout.sort_custom(", start)
        end = source.index("\n", sort) + 1
        source = (
            source[:sort]
            + meter("\t", "reason_facility_visits", "facilities.size()")
            + f"\tvar sort_stamp: int = {probe}.begin()\n"
            + source[sort:end]
            + f'\t{probe}.sample("reason_sort", sort_stamp)\n'
            + source[end:]
        )
        start = source.index("func missile_multi_plan(")
        plan = source[start:]
        plan = plan.replace('\tout["available"] = avail\n',
                            meter("\t", "stock_facility_visits", "facilities.size()") + '\tout["available"] = avail\n', 1)
        scan = "\t\t\tfor j in launchers.size():\n"
        plan = plan.replace(scan, meter("\t\t\t", "allocation_facility_visits", "launchers.size()") + scan, 1)
        plan = plan.replace("\t\tif got < n:\n",
                            f"\t\tif got < n:\n\t\t\tvar reason_stamp: int = {probe}.begin()\n", 1)
        end = plan.index('\n', plan.index('why = Loc.t("Вне дальности ОТРК")')) + 1
        plan = plan[:end] + f'\t\t\t{probe}.sample("reason", reason_stamp)\n' + plan[end:]
        source = source[:start] + plan
        if "func _missile_in_range(" in source:
            start = source.index("func _missile_in_range(")
            end = source.index("\n\n", start)
            helper = source[start:end]
            helper = helper.replace("\tfor center: Vector2 in centers:\n",
                                    "\tvar visits: int = 0\n\tfor center: Vector2 in centers:\n\t\tvisits += 1\n")
            helper = helper.replace("\t\treturn true\n", meter("\t\t", "reason_center_visits", "visits") + "\t\treturn true\n")
            helper = helper.replace("\treturn false", meter("\t", "reason_center_visits", "visits") + "\treturn false")
            source = source[:start] + helper + source[end:]
            snapshot = "\t\t\t\tfor f: Facility in facilities:\n"
            source = source.replace(snapshot, meter("\t\t\t\t", "reason_facility_visits", "facilities.size()") + snapshot, 1)
    for name in names:
        declaration = re.search(rf"(?m)^(static )?func {name}\((.*)\) -> (\S+):$", source)
        if not declaration:
            # _draw_ghost can live in a parent script across revisions.
            if name in ("_draw_ghost", "_apply_missile_plan"):
                continue
            raise ValueError(f"{relative}: {name}")
        static, args, return_type = declaration.groups()
        params = ", ".join(re.findall(r"(?:^|, )([a-zA-Z_][a-zA-Z_0-9]*):", args))
        probe = 'preload("res://perf01_scopes.gd")'
        call = f"_perf01_{name}({params})"
        label = (path.stem + name) if name == "_draw" else name
        before = "var result := " if return_type != "void" else ""
        timer = f"{probe}.begin()" if detailed else "Time.get_ticks_usec()"
        target_count = ", targets.size()" if detailed and "targets" in params.split(", ") else ""
        wrapper = (
            declaration[0] + f'\n\tvar stamp: int = {timer}\n\t{before}{call}'
            f'\n\t{probe}.sample("{label}", stamp{target_count})\n'
            + ("\treturn result\n" if before else "")
        )
        original = f"{static or ''}func _perf01_{name}({args}) -> {return_type}:"
        source = source[:declaration.start()] + wrapper + "\n\n" + original + source[declaration.end():]
    path.write_text(source)
timing = """extends RefCounted

static var enabled: bool = false
static var values: Dictionary = {}

static func sample(label: String, stamp: int) -> void:
	if not enabled:
		return
	if not values.has(label):
		values[label] = []
	values[label].append(Time.get_ticks_usec() - stamp)
"""
if detailed:
    timing = timing[:timing.index("static func sample")] + """static var child_us: Array[int] = []

static func begin() -> int:
	if not enabled:
		return -1
	child_us.append(0)
	return Time.get_ticks_usec()

static func _record(label: String, value: int) -> void:
	if not values.has(label):
		values[label] = []
	values[label].append(value)

static func sample(label: String, stamp: int, target_count: int = -1) -> void:
	if stamp < 0:
		return
	var elapsed: int = Time.get_ticks_usec() - stamp
	var children: int = child_us.pop_back()
	if not child_us.is_empty():
		child_us[-1] += elapsed
	_record(label, elapsed)
	_record(label + ":exclusive", elapsed - children)
	if target_count >= 0:
		_record(label + ":targets", target_count)
"""
(root / "perf01_scopes.gd").write_text(timing)
