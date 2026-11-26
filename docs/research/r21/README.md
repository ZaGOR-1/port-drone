> Історичний матеріал з `toolchain/performance/r21/handoff/harness/README.md`. [Реєстр досліджень](../INDEX.md)

A is beta 3298af5878501d458920b41dc5738f60571ac551. Create physical source-A from git archive game/, copy to source-B, then apply ../evidence/production.patch in source-B. Set DF_R09_TOOLCHAIN to the existing 4.7.2 toolchain root and DF_R09_RUNTIME to its official INT-11 Linux installation.

The raw config.json files show the Profile B launch arguments and effective settings. Pack each named variant with prepare.py. The minimal overlays retain the detailed geometry scopes and lean overlays skip them. To rerun the proof with fresh output directories, use run-proof.sh and run-differential.sh. The proof runner's fixture mode reuses the R17B transport fixture with the INT-10 typed-empty-array correction. Its assertions and production setter calls are preserved.

The included raw data can be reanalyzed without launching Godot.

```sh
cd harness
PYTHONDONTWRITEBYTECODE=1 python3 report.py
PYTHONDONTWRITEBYTECODE=1 python3 verify-proof.py
```
