# Гілки MAINT-01

> Історичний матеріал з `archive/MAINT-01/BRANCHES.md`. [Реєстр досліджень](../INDEX.md)

DELETE означає кандидат на майбутнє локальне видалення після погодження. ARCHIVE для remote означає зберегти ref і доказ інтеграції. `origin/HEAD` — символьний ref на `origin/main`. Лічильники правої сторони звірено за ancestry і patch equivalence відносно beta.

| Гілка | SHA | В beta | Унікальні / без patch-equivalent | Рішення | Підстава |
| --- | --- | --- | ---: | --- | --- |
| `beta` | `f6298822` | так | 0 / 0 | KEEP | Інтеграційна база |
| `docs/qa01-native-crash` | `ca713a4d` | ні | 1 / 1 | INTEGRATE | QA-01 до Windows QA з межами Wine |
| `docs/r09-baseline` | `93a626e8` | ні | 1 / 1 | ARCHIVE | Історична база до R16/R23 |
| `docs/r16-scalability-baseline` | `c7c031fe` | ні | 1 / 1 | ARCHIVE | Історична база 0.36.7 і provenance fixtures |
| `docs/r23-scalability-assessment` | `43c84b21` | ні | 1 / 1 | INTEGRATE | Звіт R23, таблиці і запис стану |
| `docs/real-world-performance-v2` | `209ae193` | ні | 1 / 1 | INTEGRATE | Profile B і точковий AGENTS §8 |
| `fix/linux-native-runtime` | `11380ee0` | так | 0 / 0 | ARCHIVE | Історичний L02, Linux відкладено |
| `perf/army-advance` | `8c83d91d` | так | 0 / 0 | ARCHIVE | Вершина в beta, локальний R13 NO_GO |
| `perf/army-target-acquisition` | `881eb7a1` | так | 0 / 0 | DELETE | R19 інтегровано PR #19 |
| `perf/ground-unit-rendering` | `b278ce7b` | ні | 2 / 2 | ARCHIVE | R12 NO_GO, два унікальні коміти |
| `perf/impact-candidate-enumeration` | `6d83ef99` | ні | 1 / 1 | ARCHIVE | Початковий R18A, окремо від R18B |
| `perf/impact-candidate-enumeration-r18b` | `803ca9ec` | так | 0 / 0 | DELETE | R18B інтегровано PR #18 |
| `perf/operations-membership-lookup` | `479b91d1` | так | 0 / 0 | DELETE | R17 інтегровано PR #17 |
| `perf/r11-army-update` | `a72a67ca` | ні | 2 / 2 | ARCHIVE | R11 NO_GO, два унікальні коміти |
| `perf/unit-rendering-batching` | `f6298822` | так | 0 / 0 | ARCHIVE | Вершина дорівнює beta, локальний R22 NO_GO |
| `perf/unit-speed-lookup` | `3298af58` | так | 0 / 0 | DELETE | Вершина є точкою бази R20, PoC відхилено |
| `perf/watchdog-lockstep-latency` | `2c38f711` | так | 0 / 0 | DELETE | R21 інтегровано PR #20 |
| `research/native-01-rust-gdextension` | `b19c66c8` | ні | 1 / 1 | ARCHIVE | NATIVE-01 дослідження ABI |
| `research/native-02-impact-candidates` | `2de114d2` | ні | 1 / 1 | ARCHIVE | NATIVE-02, impact candidates |
| `research/native-02b-target-acquisition` | `0c047924` | ні | 1 / 1 | ARCHIVE | NATIVE-02B, acquire NO_GO |
| `research/native-02c-vision-masks` | `054ecc4f` | ні | 1 / 1 | ARCHIVE | NATIVE-02C, Vision NO_GO |
| `research/native-02d-data-oriented-simulation` | `d202278e` | ні | 1 / 1 | ARCHIVE | NATIVE-02D, Army/Unit NO_GO |
| `origin/beta` | `f6298822` | так | 0 / 0 | KEEP | Інтеграційна база |
| `origin/main` | `172df65e` | так | 0 / 0 | KEEP | Стабільна гілка на origin. Локальної main немає. |
| `origin/perf/army-target-acquisition` | `881eb7a1` | так | 0 / 0 | ARCHIVE | Інтегрована гілка PR. Спільний ref потребує окремого рішення. |
| `origin/perf/impact-candidate-enumeration` | `803ca9ec` | так | 0 / 0 | ARCHIVE | Інтегрована гілка PR. Спільний ref потребує окремого рішення. |
| `origin/perf/operations-membership-lookup` | `479b91d1` | так | 0 / 0 | ARCHIVE | Інтегрована гілка PR. Спільний ref потребує окремого рішення. |
| `origin/perf/watchdog-lockstep-latency` | `2c38f711` | так | 0 / 0 | ARCHIVE | Інтегрована гілка PR. Спільний ref потребує окремого рішення. |
