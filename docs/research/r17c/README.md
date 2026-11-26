# DroneFlames R17C

> Історичний матеріал з `toolchain/performance/r17c.bisE12lZ/README.md`. [Реєстр досліджень](../INDEX.md)

[Результат і межі приймання](R17C_RESULTS.md). [Політика preflight](readiness.md). Сирий підсумок (`raw/initial-preflight/summary.json`).

`run.py`, `monitor.py`, `telemetry.py`, `analyze.py`, `evaluate.py`, `preflight.py` і `CRITERIA.md` скопійовано побайтно з R17B. `host.py` використовує той самий sampler та додає read-only телеметрію хоста. Фактична команда була `python3 host.py raw/initial-preflight 60`. Статус 3 означає невиконання readiness. Політика та код хешовані до цього запуску.

PCK і runtime залишаються в R17B як окремі локальні файли за шляхом `/home/zagor/projects/droneflames-toolchain/performance/r17b.tcCPTLHp`. Їхні точні хеші зафіксовано в `provenance/`. Змінені оригінальні файли PoC та точний patch лишаються в резервній копії R17B. Архів також містить копії diff та fixtures. Розпакуйте архів і застосуйте `sha256sum -c SHA256SUMS` для перевірки перенесених доказів.
