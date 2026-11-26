# DroneFlames R17 · Real-World Gaming Profile B

> Історичний матеріал з `toolchain/performance/r17-profile-b.53dMPlcV/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

**INCONCLUSIVE для звичайної гри.** Чотири пари Late E завершилися 25.11.2026 у порядку A/B, B/A, B/A, A/B. Під час усіх восьми вимірів була активна Windows VM (`qemu-system-x86`, PID 230788, libvirt). Внесок VM за записаними інтервалами становив приблизно 55,73 CPU-с. VS Code дав 33,49, Chrome 14,52, localsearch-3 12,89, Discord 4,91, Codex 2,31, Steam 0,25 CPU-с. Це оцінки за top-10 назв на інтервал, зведені за вісьмома вимірювальними вікнами, а не за повним часом запуску гри.

Використано офіційний Godot 4.7.2, RTX 4060 Laptop GPU, Vulkan Forward Mobile, 1280×720, VSync 0, без FPS cap. SHA256 підтверджує точні R17B minimal A/B PCK, спільний runtime і Late E snapshot. Незакомічений R17 PoC побайтно відповідає R17C. Seed 20261016, камера (2629.199, 1236.892), zoom (1.111111, 1.111111), 150 simulation ticks на кожне плече від тика 4650. Вісім запусків збіглися з історичними початковим `c3ba32fe4eed13e3` та кінцевим `3c338abc3ec9d5c7` хешами, RNG `1940658711` і wire payload (чотири команди, 760 байтів). Збіглися ігрові лічильники workload. Лічильники об’єктів та пам’яті рушія збережені для діагностики.

| Пара | Порядок | FPS A → B | 1% low A → B | Frame p99, мс | Tick p99, мс | Фоновий CPU, медіана |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | A/B | 26,51 → 30,36 | 6,35 → 7,12 | 129,17 → 113,33 | 57,68 → 39,36 | 36,43% → 24,73% |
| 2 | B/A | 29,21 → 29,19 | 6,61 → 6,44 | 116,16 → 119,86 | 51,45 → 43,66 | 25,99% → 25,39% |
| 3 | B/A | 28,71 → 29,07 | 6,65 → 6,80 | 114,53 → 120,44 | 53,00 → 40,42 | 21,14% → 22,22% |
| 4 | A/B | 27,89 → 29,56 | 5,60 → 6,86 | 154,53 → 114,19 | 64,46 → 42,48 | 20,95% → 19,37% |

Медіани парних змін: FPS +3,62%, 1% low +7,13%, frame p95 −11,86%, p99 −4,54%, максимум −9,64%, tick p99 −27,75%. Tick p99 покращився в усіх парах. Frame p99 зріс у двох парах B/A (+3,19% та +5,16%) і зменшився в обох A/B. Різниця за порядком та нетипові умови лишають відкритим висновок щодо frame-time. Найбільший FPS приріст (+14,54%) збігся зі спадом фонового CPU на 11,70 п.п. і меншим внеском QEMU та Chrome в B. Жодне плече не виключено. Додаткові пари не запускалися, бо VM залишалася активною й просте повторення за тих самих умов не дало б звичайного ігрового сценарію.

Сумарний виміряний час simulation ticks 2,91–3,29 с на запуск. Probe використовує elapsed time і не дає окремого on-CPU лічильника лише для simulation. CPU-час процесу гри за GNU time 20,15–22,22 с на повний запуск. Медіанна частка runnable wait головного потоку 0,10–0,57%. Peak RSS 1665,57–1690,30 MiB. Найвищий інтервальний memory PSI some 2,82% в A четвертої пари. По кожному плечу доступні frame/tick p95/p99/max, час симуляції та процесу, main-thread wait, CPU/RSS і PSI у `reports/profile-b-series.json` та сирих CSV.

## Workflow, QA і Git

- Локальний commit `209ae193c000188312f99c63861a9422c0185884` (`docs(perf): adopt real-world gaming workflow`) у `/home/zagor/projects/port-drone-perf-workflow-v2` на `docs/real-world-performance-v2`. Оновлено AGENTS.md, performance.md і PROJECT_STATE.md. Історичні verdicts збережено.
- У новій локальній копії runner використовує готові PCK та реєструє важкі процеси під час запуску. Validator перевіряє ідентичність, повноту й workload та зберігає фонові метрики. Preflight та фонові пороги прибрано лише з поточного запуску. Синтаксис, порядок, вісім exit codes, налаштування і детермінізм перевірено. Старі runner, validator та raw залишено в історичному handoff. Команда нового запуску `bash series.sh 1 2 3 4` з цього каталогу.
- Історичні visits, peak membership CPU, D2100/D5000 tick p99, differential 37/37, deterministic replay і repeated restore застосовні до звіреного R17. Новий regression suite, disk Save/Load, ENet admission/reconnect/resync, long-running lifecycle, official Linux/Windows x64 builds, PCK identity нових збірок, Linux native і Wine smoke, Windows A/B комплект, фізичний Windows/LAN/Steam — **NOT RUN**.
- `beta` d6a38e8db58361430df69ffe0a98e628acac6d8b, `origin/main` 172df65e3bd004efed9a5444e90a284d9d69db10. Version 0.36.7. R17 і R18A та їхні локальні diff, історичні worktrees й stash `40a9f64` збережено. Для R17 commit, push і PR відкладено. R18 gate і R19 не запускались.

Наступний вимір має припасти на звичайну сесію після завершення роботи Windows VM. Звичайні Chrome, Discord, Steam та інші користувацькі програми можуть працювати. Артефакти R17B залишаються в `/home/zagor/projects/droneflames-toolchain/performance/r17b.tcCPTLHp/`. Шляхи й SHA256 точних входів наведено в `provenance/actual-inputs.sha256`.
