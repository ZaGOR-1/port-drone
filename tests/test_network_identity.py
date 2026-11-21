"""Actual loopback ENet hello: equal builds admitted, beta/old revisions rejected."""
import json
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import tempfile
import time
import unittest

from test_godot import _find_godot
from tools.check_performance import _unexpected_errors

ROOT = Path(__file__).resolve().parent.parent


class NetworkIdentityTests(unittest.TestCase):
    def test_real_admission(self):
        godot = _find_godot()
        if godot is None:
            self.skipTest('Pinned Godot missing; set DF_GODOT')
        with tempfile.TemporaryDirectory(prefix='df_identity_') as tmp:
            work = Path(tmp)
            env = os.environ.copy()
            env.update(DF_NO_UPDATE='1', DF_STEAM_MOCK='0', DF_NO_OPENING='1')
            for key in ('XDG_DATA_HOME','XDG_CONFIG_HOME','XDG_CACHE_HOME','APPDATA','LOCALAPPDATA'):
                env[key] = str(work/key); Path(env[key]).mkdir()
            staged = work/'game'
            shutil.copytree(ROOT/'game', staged)
            net_path = staged/'net/net_config.gd'
            menus_path = staged/'ui/menus.gd'
            net = net_path.read_text(); menus = menus_path.read_text()
            version = re.search(r'const VERSION: String = "([^"]+)"', menus)[1]
            rev = re.search(r'const SIM_REV: String = "([^"]+)"', net)[1]
            self.assertEqual(rev, 'v036-integration-1')
            packs = {}
            identities = {'current':f'{version}/7/{rev}',
                          'old_revision':f'{version}/7/pr10-phase5b2-1',
                          'beta':'v0.34.0/7/pr10-phase5b2-1'}
            for name in identities:
                net_path.write_text(net if name == 'current' else net.replace(rev, 'pr10-phase5b2-1'))
                menus_path.write_text(menus if name != 'beta' else menus.replace(version, 'v0.34.0', 1))
                pack = work/(name+'.pck'); packs[name] = pack
                p = subprocess.run([str(godot),'--headless','--path',str(ROOT/'tools/packproj'),
                    '--script','res://pack.gd','--',str(staged),str(pack)], env=env,
                    capture_output=True,text=True,timeout=60)
                self.assertEqual(p.returncode, 0, p.stdout+p.stderr)
            for pair, (host, guest) in enumerate([('current','current'),('current','old_revision'),
                                                 ('current','beta'),('beta','current')]):
                with self.subTest(host=host, guest=guest):
                    # Reserve an ephemeral UDP port; host binds only loopback, discovery disabled.
                    with socket.socket(socket.AF_INET,socket.SOCK_DGRAM) as sock:
                        sock.bind(('127.0.0.1',0)); port = sock.getsockname()[1]
                    ready = work/f'{pair}.ready'; stop = work/f'{pair}.stop'
                    def command(role, pack, out):
                        return [str(godot),'--headless','--main-pack',str(pack),'--script',
                            str(ROOT/'tests/test_network_admission.gd'),'--',f'--role={role}',
                            f'--port={port}',f'--ready={ready}',f'--stop={stop}',
                            f'--host_version={identities[host]}',f'--out={out}']
                    host_report=work/f'{pair}-host.json'; guest_report=work/f'{pair}-guest.json'
                    host_log=work/f'{pair}-host.log'
                    with host_log.open('w') as output:
                        proc = subprocess.Popen(command('host',packs[host],host_report),env=env,
                                                stdout=output,stderr=subprocess.STDOUT)
                        try:
                            deadline = time.monotonic()+20
                            while not ready.exists() and proc.poll() is None and time.monotonic()<deadline:
                                time.sleep(0.02)
                            self.assertTrue(ready.exists(), host_log.read_text())
                            guest_p = subprocess.run(command('guest',packs[guest],guest_report),env=env,
                                capture_output=True,text=True,timeout=55)
                            log = guest_p.stdout+guest_p.stderr
                            self.assertEqual(guest_p.returncode,0,log)
                            self.assertNotIn('SCRIPT ERROR:',log)
                            self.assertEqual(_unexpected_errors(log),[],log)
                            result = json.loads(guest_report.read_text())
                            equal = host == guest
                            self.assertEqual(result['accepted'],equal,result)
                            self.assertEqual(result['rejected'],not equal,result)
                        finally:
                            stop.write_text('stop')
                            try: proc.wait(timeout=10)
                            except subprocess.TimeoutExpired:
                                proc.kill(); proc.wait()
                        self.assertEqual(proc.returncode,0,host_log.read_text())
                        self.assertEqual(json.loads(host_report.read_text())['max_roster'],2 if equal else 1)
                        if env.get('DF_TEST_LOG_DIR'):
                            logs=Path(env['DF_TEST_LOG_DIR']);logs.mkdir(parents=True,exist_ok=True)
                            (logs/f'identity-{host}-{guest}.log').write_text(host_log.read_text()+'\n'+log)
                            shutil.copyfile(guest_report,logs/f'identity-{host}-{guest}.json')
