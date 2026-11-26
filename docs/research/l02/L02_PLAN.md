# L02 · Кваліфікація Linux runtime

> Історичний матеріал з `toolchain/linux-native/L02_PLAN.md`. [Реєстр досліджень](../INDEX.md)

1. В ізольованій фізичній копії pinned Godot підготувати patched QA template за manifests/patched-linux-plan.json. Повторити короткий race fixture на exact official і patched ELF, з окремими версіями та SHA256.
2. Повторити native desktop, ввід, fullscreen, звук, Save/Continue і штатне закриття. Відтворити teardown warnings. Додати Windows → Linux на копії synthetic disk save.
3. Повторити lockstep і перевірити authoritative state окремо від HUD prompt timestamps. Зберегти всі розбіжності в serialized state.
4. Перевірити ENet Linux–Linux і Windows–Linux, потім Steam і WebRTC. Розширювати дистрибуцію після QA і перевірки redistributable умов.
