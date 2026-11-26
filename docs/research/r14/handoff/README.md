# R14 · Handoff

> Історичний матеріал з `toolchain/performance/r14.GEz1Tr3B/handoff/README.md`. [Реєстр досліджень](../../INDEX.md)

Ранній performance gate GO. Локальна QA-матриця та перевірка збірок пройшли. Кандидат 0.36.5, робоча гілка `perf/armyfire-impact-buildings`, worktree `/home/zagor/projects/port-drone-r14`. Публікація підтверджена зі збігом локального й віддаленого HEAD. [Draft PR #15 до beta](https://github.com/ZaGOR-1/port-drone/pull/15)

| Роль | Git SHA |
| --- | --- |
| A, beta | `8c83d91d06989cc3857c7560c4690188bf88a964` |
| Зміна й differential fixture | `13dd5bffbd2878bf416c0d3bdd7663c43f7d8f73` |
| B, пакети й HEAD PR | `8a7ddc2c3d4f3659d4d1902e0f1ce17e2dd1b256` |
| Дерево game B | `dd7d630f7b7cba5fef3ea17f85db55c171df60b2` |

- [Методика й еквівалентність](../METHOD.md), [усі пари та перцентилі](../BENCHMARK.md), [профіль і QA](../../../r14/R14_RESULTS.md), повний diff R14 (`R14.diff`).
- Сирі кадри й тіки CSV (`../evidence/R14_RAW_FRAMES.csv`), CPU scopes CSV (`../evidence/R14_CPU_SCOPES.csv`), результати JSON (`../evidence/R14_RESULTS.json`), операції CSV (`../evidence/R14_COUNTS.csv`), операції JSON (`../evidence/R14_COUNTS.json`). Записи кожного запуску збережено в `../raw/`.
- Вхідні fixture дані (`../fixtures/input.json`), Late E snapshot (`../fixtures/late-e.snapshot`), Late E reference JSON (`../fixtures/late-e-reference.json`), differential fixture (`../impact-extended.gd`), D2100 Windows checkpoint (`../ab-stage/DroneFlames-R14-Windows-AB/Checkpoint/slot_1.save`).
- QA Python (`../evidence/python.log`), simulation (`../evidence/simulation.log`), replay і Save/Load (`../evidence/qa-replay.log`), ENet (`../evidence/enet.log`), PCK parity (`../post/parity.json`), Linux smoke (`../post/linux-smoke.log`), Wine smoke (`../post/wine-smoke.log`). У двох smoke-прогонах сценарій запустився, при завершенні зафіксовано витоки ObjectDB і ресурсів. Wine також повідомив про CanvasItem RID.
- Windows A/B для власника (`../packages/DroneFlames-0.36.5-R14-Windows-x64-AB-QA.zip`), Windows x64 B (`../packages/DroneFlames-0.36.5-Windows-x64-QA.zip`), Linux x64 B (`../packages/DroneFlames-0.36.5-Linux-x86_64-QA.tar.gz`), SHA256 архівів (`../packages/SHA256SUMS.txt`). Для ручного Windows A/B використовується спільний D2100 save. Автоматизований Linux fixture окремо застосовував визначений потік lockstep-команд. Physical Windows GUI/FPS, LAN і Steam — NOT RUN.
- PR state (`PR.json`), [GitHub Actions](https://github.com/ZaGOR-1/port-drone/actions/runs/45515184816), віддалені refs після push (`remote-refs.txt`). `beta`, `main`, stash `40a9f64` і незакомічені файли R13 звірено.

Додаткові контрольні пари D2100 та C1200 включено в таблиці. C1200 frame p95 зріс на 6,37% за медіанами, dense tick p99 на 3,11%. Причина хвостових відхилень відкрита. Наступне приймання кандидата — Windows A/B власником. Наступний підтверджений hotspot у хвості D2100 — `ArmyFire._spot`.

CI PASS. Обидва QA jobs успішні. Release job пропущено політикою. CI.json
