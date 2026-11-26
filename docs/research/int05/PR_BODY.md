> Історичний матеріал з `toolchain/int05.qp8pp1c0/PR_BODY.md`. [Реєстр досліджень](../INDEX.md)

## INT-05 · R08 у beta 0.36.4

Цільовий review підтвердив еквівалентність порядку клітинок, кутів, рівних кандидатів, меж карти, bridge behavior і fallback у `Economy.land_point`. У диференційній перевірці збіглися 11 000 результатів `land_point` і 4 400 `Army.safe_point`. Lockstep, порядок і тик застосування команд, бюджети маршрутів, NetHash та RNG збережені.

| Історичний GUI R08 | База | Кандидат |
| --- | ---: | ---: |
| Затримка пакета, мс | 174,449 | 121,996 |
| Economy.land_point, мс | 87,926 | 32,446 |
| Frame time p99, мс | 168,002 | 153,187 |
| Медіана найдовших кадрів, мс | 202,140 | 165,546 |

Затримка пакета скоротилася на **30,1%**. Дані відтворено з raw R08. Ігровий код оптимізації той самий. Загальний FPS **INCONCLUSIVE**.

Окремий PATCH bump `5e0507a4b871` до `0.36.4` синхронізує `version.cfg`, Menus.VERSION, build guard fixtures та локалізовану примітку. PROTO=7, SIM_REV=v036-integration-1, Save.FORMAT=1. ENet допускає однакову повну версію. Пари 0.36.3 ↔ 0.36.4 відхиляються в обох напрямках. MP match metadata також перевіряє повну identity.

## Автоматичні перевірки INT-05

- Python 48/48 без SKIP, simulation 2476/2476, watchdog 101/101, тести кільця 8/8, version consistency.
- Late E 150/150 ticks. NetHash на 4693 `f19767f333c29101`, на 4746 `c9301a1dcbcd76e8`, на 4800 `3c338abc3ec9d5c7`. RNG `1940658711`, збіг команд, шляхів і watchdog. Save/Load 66/66 ticks, фінальний NetHash `8ead8c43990da97d`.
- ENet admission, reconnect і resync, L10N ru/uk/en, HUD/input, Linux native headless, Windows official 4.7.2 x64 і Wine headless PASS. PCK ідентичний на обох платформах.
- HUD коміт 8066964 фіксує seed лише у fixture. Три ізольовані прогони дали однакові seed і 36/36 assertions кожен. Витік DummyTexture при іншому seed відтворювався на базі і R08 та лишається відкритим дефектом lifecycle.
- Native Windows QA **NOT RUN**, deferred by owner. Physical LAN і Steam **NOT RUN**.

[Профіль R08 і методика](../../r08/R08_RESULTS.md)
