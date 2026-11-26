# R18B · Взаємодія з R17

> Історичний матеріал з `toolchain/performance/r18b-profile-b.gFaqgQ6i/evidence/rebase-review.md`. [Реєстр досліджень](../INDEX.md)

База A `117781083ff108c8353b9e53a3eda3d49bedd0fe`, версія 0.36.8. В окремому worktree B застосовано commit `6d83ef995a154e842906d2ebdb15a41c5a883ce3`. `army_fire.gd` і `test_r18_impact.gd` побайтно тотожні R18A. Конфлікт `Army.save_state` об’єднав виключення `units_revision` R17 та `_impact_units` R18. Відповідні `Save.fill` зберігають обидва правила. PROTO, SIM_REV, Save.FORMAT і 30 тіків/с успадковано з beta.

- `Army.update` виконує `fire.update` перед очищенням загиблих. Удар читає поточні HP/стан/ворожість. Пізніше видалення загиблих збільшує R17 `units_revision`. Звичайний spawn і FPV проходять через `Army.add_unit`. При зміні `Unit.home` R17 відстежує `home_revision`.
- Lookup R18 живе в shell batch. Він інвалідується перед синхронними naval callback за активних транспортів, fort callback та city strike, який може викликати `Rail.on_strike → RailTroops.on_hit → _unload`. Посадка і висадка у Naval та RailTroops застосовують R17 `Army.remove_unit/add_unit`. Фаза `Operations.update` після army phase перевіряє обидві R17 ревізії, а в кінці очищає membership lookup.
- Цільовий fixture охоплює spawn, destruction, same-size mutation, повторний виклик і fallback; city fixture запускає реальну висадку з пошкодженого потяга. Диференціали R18 core 42/42, city 7/7 та ArmyFire impact 59/59 пройшли на A/B. Proof replay порівнює NetHash, RNG, впорядкований стан, Operations/watchdog, impact trace та wire payload на кожному тику. Heavy і Late E повторюють контрольні R18A хеші. Repeated restore Late E пройшов двічі на варіант.
