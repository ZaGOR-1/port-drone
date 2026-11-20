"""Evaluate the actual release-job expression against accidental publication events."""
import ast
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parent.parent


def permits_release(event, ref, publish=False, version='', release='true'):
    text = (ROOT/'.github/workflows/build.yml').read_text()
    job = text.split('\n  release:\n', 1)[1]
    expression = re.search(r'^    if: (.+)$', job, re.M).group(1)
    values = {'github.event_name':event, 'github.ref':ref,
              'inputs.publish_release':publish, 'inputs.release_version':version,
              'needs.build.outputs.release':release}
    expression = expression.replace('== true', '== True')
    for key, value in values.items():
        expression = expression.replace(key, repr(value))
    expression = expression.replace('&&',' and ').replace('||',' or ')
    # No arbitrary expressions or tools are executed from workflow text.
    tree = ast.parse(expression, mode='eval')
    allowed = (ast.Expression, ast.BoolOp, ast.And, ast.Or, ast.Compare, ast.Eq, ast.NotEq, ast.Constant)
    if any(not isinstance(node, allowed) for node in ast.walk(tree)):
        raise ValueError('Unsupported policy expression')
    return bool(eval(compile(tree, '<release policy>', 'eval'), {'__builtins__':{}}, {}))


class PublicationPolicyTests(unittest.TestCase):
    def test_automatic_events_cannot_publish(self):
        for event, ref in [('push','refs/heads/beta'), ('push','refs/heads/main'),
                           ('push','refs/tags/v0.34.0'), ('pull_request','refs/pull/10/merge')]:
            with self.subTest(event=event, ref=ref):
                self.assertFalse(permits_release(event, ref))

    def test_manual_build_is_not_authorization_to_publish(self):
        for ref, publish, version, output in [
            ('refs/heads/beta', True, '0.34.0', 'true'),
            ('refs/heads/main', False, '0.34.0', 'true'),
            ('refs/heads/main', True, '', 'true'),
            ('refs/heads/main', True, '0.34.0', 'false'),
        ]:
            with self.subTest(ref=ref,publish=publish,version=version,output=output):
                self.assertFalse(permits_release('workflow_dispatch',ref,publish,version,output))

    def test_explicit_main_release_is_the_only_allowed_route(self):
        self.assertTrue(permits_release('workflow_dispatch','refs/heads/main',True,'0.34.0'))

    def test_beta_build_and_least_privilege(self):
        text = (ROOT/'.github/workflows/build.yml').read_text()
        self.assertIn('branches: [main, beta]',text)
        self.assertNotIn('codex/performance-0.33.2.2',text)
        self.assertRegex(text, r'publish_release:\n(?:.*\n){1,5}?\s+default: false')
        self.assertEqual(text.count('contents: write'),1)
        self.assertIn('contents: write', text.split('\n  release:\n',1)[1])
