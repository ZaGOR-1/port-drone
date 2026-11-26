# DroneFlames · L01

> Історичний матеріал з `toolchain/l02-portability.H0BQrG/before/linux-native/PROJECT_STATE.md`. [Реєстр досліджень](../INDEX.md)

PARTIAL відносно повного native port. Desktop smoke official 4.7.2 Linux x86_64 із незмінним PCK пройшов. Є точні GodotSteam/WebRTC залежності, GUI, Save/Continue й короткий lockstep із Windows під Wine. Patched Linux, реальний Multiplayer і релізні перевірки відкриті. Production beta чиста на c91e0e6. [Smoke](../l01/L01_SMOKE_TESTS.md) · [L02](L02_PLAN.md)

## L02 · Native Linux stabilization

Поточний L02 має статус PARTIAL. Native build від beta `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b` напряму пакує спільний PCK `0.36.1`. Radeon і RTX 4060 пройшли Vulkan та OpenGL startup. Закриття через GNOME XWayland, розпакований launcher і df пройшло. FIX06 replay, двосторонні saves і native/mixed ENet із resync пройшли. Точний ігровий ресурс історичного mesh-попередження, фізичний Windows/LAN, Steam і WebRTC лишаються відкритими. [Поточний handoff](L02_RUNTIME_ANALYSIS.md)
