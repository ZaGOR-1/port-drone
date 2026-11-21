"""Package checks must reject corruption even after checksums are regenerated."""
import hashlib
from pathlib import Path
import struct
import tempfile
import unittest
import zipfile

from tools.ci.verify_build import LIBRARIES, verify_artifacts


def pe():
    data = bytearray(256)
    data[:2] = b'MZ'
    struct.pack_into('<I', data, 60, 128)
    data[128:132] = b'PE\0\0'
    struct.pack_into('<H', data, 132, 0x8664)
    struct.pack_into('<H', data, 152, 0x20b)
    return bytes(data)


class ArtifactTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='df_ci_artifacts_')
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.package = self.root/'package'
        self.package.mkdir()
        (self.root/'libs').mkdir()
        (self.root/'tools/qa').mkdir(parents=True)
        for name in LIBRARIES:
            (self.root/'libs'/name).write_bytes(pe())
            (self.package/name).write_bytes(pe())
        launcher = 'Run-DroneFlames.ps1'
        (self.root/'tools/qa'/launcher).write_text('fixture launcher\n')
        (self.package/launcher).write_text('fixture launcher\n')
        self.template = self.root/'template.exe'
        self.template.write_bytes(pe())
        pck = b'GDPC'+bytes(60)
        (self.package/'DroneFlames.exe').write_bytes(pe()+pck+struct.pack('<QI', len(pck), 0x43504447))
        self.archive = self.package/'DroneFlames-libs-r1.zip'
        self.write_zip()
        self.manifest()

    def write_zip(self, override=None):
        with zipfile.ZipFile(self.archive, 'w') as z:
            for name in sorted(LIBRARIES):
                z.writestr(name, override if override is not None else pe())

    def manifest(self):
        files = [self.package/'DroneFlames.exe', self.archive]
        (self.package/'SHA256SUMS.txt').write_text(''.join(
            f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.name}\n' for p in files))

    def verify(self):
        return verify_artifacts(self.package, self.template, self.root)

    def test_valid_structure_and_tracked_dlls(self):
        self.assertEqual(self.verify()['pck_bytes'], 64)

    def test_forged_footer_rejected_with_valid_manifest(self):
        p = self.package/'DroneFlames.exe'
        p.write_bytes(p.read_bytes()[:-12]+struct.pack('<QI', 65, 0x43504447))
        self.manifest()
        with self.assertRaisesRegex(ValueError, 'trailer or offset'):
            self.verify()

    def test_template_mismatch_rejected_with_valid_manifest(self):
        p = self.package/'DroneFlames.exe'
        data = bytearray(p.read_bytes());data[200] = 1;p.write_bytes(data)
        self.manifest()
        with self.assertRaisesRegex(ValueError, 'prefix'):
            self.verify()

    def test_native_replacement_rejected_with_valid_manifest(self):
        self.write_zip(pe()+b'changed')
        self.manifest()
        with self.assertRaisesRegex(ValueError, 'tracked DLL'):
            self.verify()

    def test_unexpected_zip_member_rejected_with_valid_manifest(self):
        with zipfile.ZipFile(self.archive, 'a') as z:
            z.writestr('../steam_api64.dll', pe())
        self.manifest()
        with self.assertRaisesRegex(ValueError, 'three unique'):
            self.verify()

    def test_modified_sidecar_and_launcher_rejected(self):
        for name in [next(iter(sorted(LIBRARIES))), 'Run-DroneFlames.ps1']:
            with self.subTest(name=name):
                path = self.package/name
                original = path.read_bytes();path.write_bytes(original+b'changed')
                with self.assertRaises(ValueError):self.verify()
                path.write_bytes(original)
