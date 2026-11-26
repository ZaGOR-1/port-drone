# Porting Roadmap · Спільний checkout

> Історичний матеріал з `toolchain/dev-environment/docs/PORTING_ROADMAP.md`. [Реєстр досліджень](../INDEX.md)

1. Перший практичний крок — у фізичній копії c91e0e6 зафіксувати офіційний Linux x86_64 export template Godot 4.7.2 і сумісний набір GodotSteam debug/release, Steam API та WebRTC debug/release. Для кожного компонента записати джерело, ABI, ліцензію, розміщення та SHA256. Зібрати каталожний Linux smoke package із тим самим PCK і перевірити відсутність loader errors у fresh XDG профілі.
2. Виконати startup, save/reload і migration fixtures, keyboard/mouse, windowed/fullscreen, Vulkan та audio на Ubuntu. Підтвердити manifest-пін native runtime, запустити Godot race fixture й наявні lockstep/Save/Load регресії. За потреби окремо підготувати patched Linux template з тим самим C++ diff і окремими SCons pins.
3. Перевірити ENet LAN, Steam та WebRTC на двох клієнтах, спочатку Linux–Linux, потім Windows–Linux зі спільною protocol/save identity. Linux runtime, Steam client, реальні DLL/.so та exact commit фіксувати в QA.
4. Додати Linux backend у df після підтверджених smoke/QA. Для native Windows спочатку перевірити bootstrap і launch на Windows 11, потім винести спільні PCK/verify кроки у Windows adapter. Записувати артефакти, runtime SHA256, Git revision і game tree у спільний provenance.
5. Підключити CI, підписання та дистрибуцію за окремим рішенням. Уся робота йде зі спільним кодом гри та з платформними target/configuration paths.
