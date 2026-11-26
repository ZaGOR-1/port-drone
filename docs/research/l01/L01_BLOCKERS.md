# L01 · Відкриті обмеження

> Історичний матеріал з `toolchain/linux-native/L01_BLOCKERS.md`. [Реєстр досліджень](../INDEX.md)

- Офіційний Linux runtime, PCK і Steam/WebRTC .so придатні до локального desktop smoke.
- Patched Linux Godot ще не зібрано. Історичний GDScript race на official Linux editor вимагає окремої перевірки перед навантаженням.
- Реальний Steam, WebRTC signaling/data channel та ENet Linux/Windows LAN — NOT RUN. Для Steam потрібен клієнт і тестовий AppID.
- HUD prompt timestamps різняться. Teardown має resource warnings, а повернення в меню показало mesh-null. Їх треба відтворити окремо.
- Native Wayland input, DPI, fullscreen, IME, ручне прослуховування і штатний window-close — відкриті.
- Перевірено конкретний Ubuntu/Vulkan host. Пакування для користувачів, ширша Linux сумісність і права поширення Steam API потребують окремої перевірки.
