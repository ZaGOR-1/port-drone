> Історичний матеріал з `toolchain/performance/r07/PR_BODY_FINAL.md`. [Реєстр досліджень](../INDEX.md)

## R07

Late E відтворив watchdog spike на тику 4746 у beta 0.36.2. Перевикористано квадрат радіуса, локальні координати й квадрат відстані в одному проході кільця зі збереженням порядку кандидатів та tie-breaking. Зміна обмежена `Operations.wd_exit`.

На Godot 4.7.2 official, Linux Vulkan Mobile і RTX 4060 три черговані пари дали watchdog 156,51 → 128,42, 149,08 → 132,57 і 154,83 → 131,77 мс. Медіана пошуку на 4746 — 118,42 → 99,96 мс. Max simulation tick 189,32 → 168,70 мс, frame p99 190,83 → 161,35 мс. Максимальний кадр на 4693 лишився окремим піком командного batch. FPS INCONCLUSIVE. [Деталі A/B і CPU breakdown](../../r07/R07_RESULTS.md)

## Перевірки

- Детермінований replay збігся на кожному тику за NetHash, RNG, шляхами, чергами, вибраними виходами та часом застосування команд. Перезавантаження з 89 operations і 30 відкладеними наказами дало однаковий продовжений replay.
- Simulation 2476/2476, Python 47/47 без SKIP, цільові випадки watchdog, Save/Load і двопроцесний ENet loopback PASS.
- Linux official build/smoke і Windows official x64 build/Wine smoke PASS. Однаковий PCK у комплекті.
- Версія 0.36.2, PROTO 7, SIM_REV v036-integration-1 і Save.FORMAT 1.

Залишаю Draft для review і Windows native A/B. Фізичні Windows GUI, LAN та Steam — NOT RUN.

[CI — PASS](https://github.com/ZaGOR-1/port-drone/actions/runs/45460907715)
У додатковій парі C1200 B/A NetHash збігся. Зміни FPS між двома C-парами різноспрямовані. Цільовий fixture дав 101/101 на A і B.
