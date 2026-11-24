#!/usr/bin/env bash
# Pack and run from an isolated directory. Point to existing pinned tools and a fresh output.
set -euo pipefail
repo="$(cd -- "$(dirname -- "$0")/../.." && pwd)"
source="$(realpath "$1")"
toolchain="$(realpath "$2")"
stage="$(realpath -m "$3")"
shift 3
l01="$toolchain/linux-native"
editor="$toolchain/official-4.7.2/godot"
mkdir "$stage"
cp -a "$source/game" "$stage/game"
cp -a "$source/tools/packproj" "$stage/packproj"
cp -a "$l01/builds/$(cat "$l01/latest")/DroneFlames-Linux"/{DroneFlames.x86_64,addons} "$stage/"
python3 "$repo/docs/perf01/instrument.py" "$stage/game"
cp "$repo/docs/perf01/fixture.gd" "$stage/game/perf01_fixture.gd"
cat > "$stage/game/perf01_fixture.tscn" <<'SCENE'
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://perf01_fixture.gd" id="1"]

[node name="Perf01" type="Node"]
script = ExtResource("1")
SCENE
sed -i 's|^run/main_scene=.*|run/main_scene="res://perf01_fixture.tscn"|' "$stage/game/override.cfg"
export DF_NO_UPDATE=1 DF_NO_OPENING=1 DF_STEAM_MOCK=0 DF_LANG=ru
export XDG_DATA_HOME="$stage/profile/perf01" XDG_CONFIG_HOME="$stage/config" XDG_CACHE_HOME="$stage/cache"
"$editor" --headless --path "$stage/packproj" --script res://pack.gd -- "$stage/game" "$stage/DroneFlames.pck" > "$stage/pack.log" 2>&1
if [[ ${PERF01_PREPARE_ONLY:-0} == 1 ]]; then
  exit 0
fi
cd "$stage"
render=()
if [[ ${PERF01_HEADLESS:-0} == 1 ]]; then
  render=(--headless)
fi
exec /usr/bin/time -v -o "$stage/process.txt" timeout 300 "$stage/DroneFlames.x86_64" \
  "${render[@]}" --rendering-method gl_compatibility --resolution 1480x950 --audio-driver Dummy \
  -- --out="$stage/result.json" "$@" > "$stage/run.log" 2>&1
