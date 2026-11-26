# INT-07 · Перевірки 0.36.6

> Історичний матеріал з `toolchain/int07.4IWmLXCl/handoff/QA.md`. [Реєстр досліджень](../INDEX.md)

Передмерджевий runtime і version fixtures походять із `8649531`. Наступний коміт `afa9847` змінює лише документацію. Official native Linux і Windows x64 пакети побудовані вже з точного HEAD `afa9847`. Тести ізоляції на фізичній копії source та окремих профілях.

| Перевірка | Доказ |
| --- | --- |
| Python discovery 49/49 без SKIP | python.log (`../evidence/python.log`) |
| Simulation 2476/2476 | regression.json (`../evidence/simulation/regression.json`) |
| Watchdog 101/101 на A і B | A (`../evidence/watchdog-A/result.json`) · B (`../evidence/watchdog-B/result.json`) |
| R10 differential 49/49 на A і B | A (`../evidence/r10-A/result.json`) · B (`../evidence/r10-B/result.json`) |
| R14 differential 59/59 на A і B | A (`../evidence/r14-A/result.json`) · B (`../evidence/r14-B/result.json`) |
| Ring 8/8 і HUD/input 36/36 | ring (`../evidence/fixtures/land-point.json`) · HUD/input (`../evidence/fixtures/hud-camera-input.json`) |
| L10N, version guard | L10N (`../evidence/l10n.log`) · version (`../evidence/version.log`) |
| D2100/C1200, Late E, Save/Load | Replay (`../evidence/replay.log`) |
| Admission 0.36.6, відхилення змішаних версій | patch admission (`../evidence/patch-admission.log`) |
| ENet reconnect/resync | enet.log (`../evidence/enet.log`) |
| Linux native, Windows x64 і Wine smoke | PCK provenance (`../pre-final/parity.json`) · Linux smoke (`../pre-final/linux-smoke.log`) · Wine smoke (`../pre-final/wine-smoke.log`) |

На першому Save/Load без фіксованого кадрового кроку хеш `Operations` відрізнявся при продовженні з окремо записаного B save. NetHash, RNG, стани юнітів і споруд, watchdog, артилерія, шляхи й черги збіглися. У декодованому `sys.ops` різнилися тільки `prompt.t` і `prompt.shown["select_barracks:f6"]`, 0 проти 1/30 с. `Main._prompt_tick` викликає `Operations.next_prompt` за кадровим delta, а той записує поточний game time. Для повтору передано `--fixed-fps 30` під час генерації сейвів і завантажень. Перший прогін (`../evidence/replay-ui-timing-first.log`) · Декодований diff (`../evidence/ops-ui-timing.diff`) · Команди повтору (`../save-fixed-qa.sh`)

Результати фізичного Windows GUI/FPS, LAN, Steam — NOT RUN. Історичні teardown warnings збіглися в pre-merge smoke R14 та INT-07 за типами і кількістю. Це перевірка headless запуску й завершення в умовах smoke.
