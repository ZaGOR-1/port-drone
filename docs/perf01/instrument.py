"""Add PERF-01 timing scopes to an isolated physical copy of game/."""
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
for relative, names in scopes.items():
    path = root / relative
    source = path.read_text()
    for name in names:
        declaration = re.search(rf"(?m)^(static )?func {name}\((.*)\) -> (\S+):$", source)
        if not declaration:
            # _draw_ghost can live in a parent script across revisions.
            if name == "_draw_ghost":
                continue
            raise ValueError(f"{relative}: {name}")
        static, args, return_type = declaration.groups()
        params = ", ".join(re.findall(r"(?:^|, )([a-zA-Z_][a-zA-Z_0-9]*):", args))
        probe = 'preload("res://perf01_scopes.gd")'
        call = f"_perf01_{name}({params})"
        label = (path.stem + name) if name == "_draw" else name
        before = "var result := " if return_type != "void" else ""
        wrapper = (
            declaration[0] + f'\n\tvar stamp: int = Time.get_ticks_usec()\n\t{before}{call}'
            f'\n\t{probe}.sample("{label}", stamp)\n'
            + ("\treturn result\n" if before else "")
        )
        original = f"{static or ''}func _perf01_{name}({args}) -> {return_type}:"
        source = source[:declaration.start()] + wrapper + "\n\n" + original + source[declaration.end():]
    path.write_text(source)
(root / "perf01_scopes.gd").write_text("""extends RefCounted

static var enabled: bool = false
static var values: Dictionary = {}

static func sample(label: String, stamp: int) -> void:
	if not enabled:
		return
	if not values.has(label):
		values[label] = []
	values[label].append(Time.get_ticks_usec() - stamp)
""")
