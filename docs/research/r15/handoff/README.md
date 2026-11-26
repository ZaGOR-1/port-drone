# R15 · ArmyFire._spot

> Історичний матеріал з `toolchain/performance/r15.pCbzhv2E/handoff/README.md`. [Реєстр досліджень](../../INDEX.md)

Ранній gate GO і повний локальний QA PASS. База `50f3f04306ec49ea600296135225282907c9955c`, гілка `perf/armyfire-spotting`, worktree `/home/zagor/projects/port-drone-r15`, версія 0.36.6. Код `0dc4460`, документація `75f6a13`.

- [Звіт у репозиторії](../../../r15/R15_RESULTS.md), повний diff (`R15.diff`), [усі A/B-пари й деталізація CPU](../BENCHMARK.md).
- Сирі кадри CSV (`../evidence/R15_RAW_FRAMES.csv`), CPU scopes CSV (`../evidence/R15_CPU_SCOPES.csv`), лічильники CSV (`../evidence/R15_COUNTS.csv`), агреговані результати JSON (`../evidence/R15_RESULTS.json`). Оригінальні `result.json`, `host.csv`, config і журнали кожного прогону в `../raw/`.
- Telemetry з вимірюваних вікон (`../evidence/host-summary.txt`), порядок прогонів і replay (`../evidence/gate.log`), зворотна щільна пара (`../evidence/dense-control.log`). Усі мінімальні прогони включено. Перший B audit зафіксував 24 записи через колектор на кожну країну, збережений у `../evidence/audit-B-collector-misplaced/`. Повтор збирав рівно 4 записи, як A. У початкових differential setup збережено помилку імені класу та помилкове очікування для цілі, яка після зміни власника стала спостерігачем.
- R09–R14 fixture input (`../fixtures/input.json`), Late E snapshot (`../fixtures/late-e.snapshot`), Late E expected traces (`../fixtures/late-e-reference.json`), короткий differential (`../test_spot.gd`), розширений differential (`../test_armyfire_spot.gd`), D2100 спільний Windows checkpoint (`../raw/qa-disk-A/active-battle.save`).
- Розширений differential A (`../evidence/extended-A/result.json`), B (`../evidence/extended-B/result.json`), Python (`../evidence/python.log`), simulation (`../evidence/simulation/regression.json`), Late E і Save/Load (`../evidence/qa-replay.log`), ENet (`../evidence/enet.log`).
- Windows A/B (`../packages/DroneFlames-0.36.6-R15-Windows-x64-AB-QA.zip`), Windows B (`../packages/DroneFlames-0.36.6-Windows-x64-QA.zip`), Linux B (`../packages/DroneFlames-0.36.6-Linux-x86_64-QA.tar.gz`), SHA256 архівів (`../packages/SHA256SUMS.txt`), ідентичність PCK (`../post/parity.json`). Windows A/B використовує спільний save з ручним завантаженням. Linux performance fixture генерує D2100 та відтворює lockstep команди.

D2100 синтетичний seed `20261016`, 45 warmup + 120 тіків, native Ubuntu, RTX 4060 Laptop, Vulkan Mobile, 1280×720, zoom 1.111111, VSync та cap off. `run.py`, `prepare.py`, `spot-profile.py` і `early-gate.sh` зберігають параметри. Докази R03 і R09 доступні у відповідних performance каталогах. Докладний попередній контекст збережено для INT-07. [Контекст INT-07](../../int07/R15_CONTEXT.md)

Фізичні Windows GUI/FPS, Steam і LAN — NOT RUN. Обидва щільні A/B покращили p99, але максимум кадру і 1% low у першій парі погіршилися. Причину розбіжності не встановлено. Для R16 дані не обґрунтовують глобальну зміну spatial index. Новий baseline має спочатку виміряти залишкові витрати різних боїв.

[Draft PR #16 до beta](https://github.com/ZaGOR-1/port-drone/pull/16) · [CI PASS точного HEAD](https://github.com/ZaGOR-1/port-drone/actions/runs/45522311182) · Локальні метадані PR (`../provenance/pr.json`) · CI JSON (`../provenance/ci.json`). PCK звірено безпосередньо з Windows і Linux архівів. Smoke warning signatures та кількості збіглися з INT-07. [Профільні примітки й операції за тиками](../PROFILE_NOTES.md) · SHA256 handoff (`SHA256SUMS.txt`).

Рекомендація — ручний Windows A/B цього комплекту й review перед рішенням про інтеграцію.
