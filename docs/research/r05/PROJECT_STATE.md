# DroneFlames · Стан R05

> Історичний матеріал з `toolchain/performance/r05/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

Статус PARTIAL. Стан і workload відтворюються, A/A frame performance не пройшла допуск. Закінчено вузький CPU профіль і короткий late E replay з додатковим підрахунком PENDING. Наступний кандидат — усунення повторної підготовки перед стартом відкладеного наказу, коли той самий запит гарантовано лишається pending.

Нові дані в `performance/r05`. Джерело `r05/source` — окремий клон `perf/r05` на `c91e0e6a7eef831687e6e63550560bba739a6b87`, лише локальна діагностика, без remote. Production `beta` чиста. R01/R02, R03 і R04 — попередній status, diff і untracked SHA. Документацію production лишено на committed baseline. Для наступної копії зберегти звіти, raw JSON/CSV, сценарії та snapshot, P/Q staged patches, SHA256 і build provenance. Wine prefix і тимчасові build profile каталоги відтворювані.

Lockstep 600 ticks P перевірено заново в Wine. Hashes, orders, exact movement і фінальні підхеші збігаються з R04 A. Q/P late E відновили один snapshot і однаково виконали 150 ticks. Новий повний simulation/Save regression suite і нативний Windows/LAN **NOT RUN** у R05. Gameplay, RNG, protocol і save format збережені.

[Умови](R05_BENCHMARK_CONDITIONS.md) · [CPU](R05_CPU_BREAKDOWN.md) · [Рейтинг](R05_BOTTLENECK_RANKING.md) · [Далі](R05_NEXT_OPTIMIZATION.md)
