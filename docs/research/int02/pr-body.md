> Історичний матеріал з `toolchain/int02.50NeyJ/pr-body.md`. [Реєстр досліджень](../INDEX.md)

## DroneFlames v0.36.1 · INT-02

Інтеграція погодженого кандидата `f3db608d77a8d7f78af22c6122108962e5f3c75f` у `beta`. Дерево `0f97159041c77942b9ce4a6ab86fbff69a495c59`.

- #7 · Локалізація uk/ru/en, динамічні тексти, runtime-перемикання мов, Development Standards, Git Workflow v2 і політика версіонування.
- #8 · Межі армійських меню, ізоляція GUI scroll від zoom карти та обробка десктопних жестів миші.
- #9 · PERF-01 і PERF-02. Додавання цілей, маркери, preview і підтвердження масового залпу ОТРК. Версія `0.36.1`.

`PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`.

## INT-01

- Python 47/47, simulation 2476/2476, L10N 125/125, HUD/миша 36/36, keyboard 130/130, UI scale 26/26, Windows UI fixture 20/20. Save/Load 11/11, mock updater 42/42.
- Міжмовний replay збігся за 30 тіків, NetHash `787a72dc394849ab`. MP ОТРК на 500 цілях дав однакові wire payload, RNG і NetHash `e1ac3fe366391da7` у трьох локалях. ENet loopback із reconnect і resync пройшов.
- Official Windows x64 QA package і Wine headless/GUI пройшли в обсязі INT-01. Linux відкрив Settings, створив партію, зберіг її та відновив через Continue.
- **Windows native QA — NOT RUN, відкладено власником. Physical LAN/Steam — NOT RUN.**
- При дефіциті боєзапасу підтвердження 420 ракет для 500 цілей зайняло 83,82 мс. У Linux OpenGL зафіксовано `mesh is null` і попередження про ресурси в runtime-прогонах. Після запиту X11 на закриття відновленої партії процес залишився активним і був завершений через SIGTERM.

## Merge і rollback

Після зеленого CI використати merge commit і звірити дерево `beta` з кандидатом. Дочекатися CI на новому `beta` перед очищенням. Якщо потрібен rollback, створити гілку від актуальної `beta`, виконати `git revert -m 1 <integration-merge-sha>` після звірки батьків і відкрити PR у `beta` з CI та review.
