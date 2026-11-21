#!/usr/bin/env python3
"""Verify pinned engine files and Windows artifacts without launching the updater."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess
import sys
import zipfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from tools.release import release_assets

LIBRARIES = {
    'libgodotsteam.windows.template_release.x86_64.dll',
    'libwebrtc_native.windows.template_release.x86_64.dll',
    'steam_api64.dll',
}


def sha256(path):
    with path.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def check_pe(data, name):
    if len(data) < 64 or data[:2] != b'MZ':
        raise ValueError(f'{name}: missing DOS header')
    pe = struct.unpack_from('<I', data, 60)[0]
    if (pe + 26 > len(data) or data[pe:pe+4] != b'PE\0\0'
            or struct.unpack_from('<H', data, pe+4)[0] != 0x8664
            or struct.unpack_from('<H', data, pe+24)[0] != 0x20b):
        raise ValueError(f'{name}: expected Windows AMD64 PE32+')


def verify_environment(folder):
    pin = json.loads(Path(__file__).with_name('godot-4.7.2.json').read_text())
    files = {}
    for name, expected in pin['files'].items():
        path = folder / name
        digest = sha256(path)
        if path.stat().st_size != expected['bytes'] or digest != expected['sha256']:
            raise ValueError(f'Pinned Godot mismatch: {name}')
        files[name] = digest
    version = subprocess.check_output([str((folder/'godot').resolve()), '--version'], text=True).strip()
    if version != '4.7.2.stable.official.ed1daf0bf':
        raise ValueError(f'Unexpected editor version: {version}')
    return {'version': version, 'sha256': files}


def verify_artifacts(package, template, source_root=ROOT):
    assets = release_assets(package)  # Integrity validation only; never calls publish().
    exe = package / 'DroneFlames.exe'
    with exe.open('rb') as built, template.open('rb') as original:
        check_pe(built.read(4096), exe.name)
        built.seek(-12, 2)
        pck_size, magic = struct.unpack('<QI', built.read(12))
        start = exe.stat().st_size - 12 - pck_size
        aligned = (template.stat().st_size + 63) // 64 * 64
        if magic != 0x43504447 or pck_size < 16 or start != aligned:
            raise ValueError('Invalid embedded PCK trailer or offset')
        built.seek(start)
        if built.read(4) != b'GDPC':
            raise ValueError('Missing embedded PCK header')
        built.seek(0)
        while chunk := original.read(1024 * 1024):
            if built.read(len(chunk)) != chunk:
                raise ValueError('EXE prefix does not match the verified template')
        if built.read(aligned - template.stat().st_size).strip(b'\0'):
            raise ValueError('Nonzero template alignment padding')
    archive = next(a for a in assets if a.suffix == '.zip')
    with zipfile.ZipFile(archive) as z:
        if len(z.namelist()) != len(LIBRARIES) or set(z.namelist()) != LIBRARIES:
            raise ValueError('Native ZIP must contain exactly three unique DLL basenames')
        if z.testzip() is not None:
            raise ValueError('Native ZIP CRC failure')
        for name in sorted(LIBRARIES):
            data = z.read(name)
            check_pe(data, name)
            if hashlib.sha256(data).hexdigest() != sha256(source_root/'libs'/name):
                raise ValueError(f'Native ZIP differs from tracked DLL: {name}')
            if sha256(package/name) != sha256(source_root/'libs'/name):
                raise ValueError(f'Sidecar DLL differs from tracked DLL: {name}')
    for launcher in (source_root/'tools/qa').glob('Run-*.ps1'):
        if sha256(package/launcher.name) != sha256(launcher):
            raise ValueError(f'Launcher differs from source: {launcher.name}')
    return {'pck_bytes': pck_size, 'pck_offset': start,
            'sha256': {p.name: sha256(p) for p in sorted(package.iterdir())
                       if p.is_file() and p.name not in {'BUILD_PROVENANCE.json', 'QA-SHA256SUMS.txt'}}}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--godot-dir', type=Path, required=True)
    p.add_argument('--package', type=Path)
    p.add_argument('--out', type=Path, required=True)
    args = p.parse_args()
    report = {'engine': verify_environment(args.godot_dir)}
    if args.package:
        report['source_sha'] = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
        report['source_dirty'] = bool(subprocess.check_output(['git', 'status', '--porcelain'], cwd=ROOT, text=True).strip())
        report['game_tree'] = subprocess.check_output(['git', 'rev-parse', 'HEAD:game'], cwd=ROOT, text=True).strip()
        report['artifacts'] = verify_artifacts(args.package, args.godot_dir/'windows_release_x86_64.exe')
        (args.package/'BUILD_PROVENANCE.json').write_text(json.dumps(report, indent=2)+'\n')
        # Separate from build.py's two-entry manifest, which release_assets validates.
        lines = [f'{sha256(f)}  {f.name}\n' for f in sorted(args.package.iterdir())
                 if f.is_file() and f.name != 'QA-SHA256SUMS.txt']
        (args.package/'QA-SHA256SUMS.txt').write_text(''.join(lines))
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
