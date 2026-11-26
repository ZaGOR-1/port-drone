# L02 · BUG-LINUX-02

> Історичний матеріал з `toolchain/l02.3ZzyV6/L02_SHUTDOWN.md`. [Реєстр досліджень](../INDEX.md)

**Причину INT-01 відтворено й локалізовано у середовищі X11 QA.** У свіжому Xvfb без window manager Godot 4.7.2 шукає `WM_DELETE_WINDOW` через `XInternAtom(..., true)`. Якщо atom ще не існує, він отримує None. Тестовий helper створював atom вже після старту процесу. Пізній ClientMessage не збігався з ідентифікатором, який Godot зберіг при запуску. Original reproduction після запиту лишався активним і продовжував симуляцію. `PcPort` не записав `pc_port.cfg`, як мав би після отриманого close.

| Такий самий PCK і ELF, окремий Xvfb | Результат |
| --- | --- |
| Atom відсутній до запуску | `WM_DELETE_WINDOW` відсутній у протоколах вікна. Запит ігнорується. Діагностичний процес завершено після відтворення. |
| Atom створений до старту | `WM_PROTOCOLS` містить `WM_DELETE_WINDOW`. Той самий ClientMessage завершує процес із кодом 0. |

Для Xvfb QA виправлено підготовку дисплея перед запуском у контрольному сценарії (`x11-close-ab.sh`). Звичайний desktop на XWayland має WM протокол. Робочий launcher використовує X11/XWayland. Глобальні налаштування і engine binary не змінювалися.

Діагностичний PCK під gdb підтвердив `PcPort` close → `Main` close → завершений `Save.save_game` → `Menus`/Strat/World worker drain → exit 0. На звичайному ELF закриття меню з розпакованого архіву і закриття відновленої партії через df дали код 0, збережений файл та `pc_port.cfg`. Також перевірено `_NET_CLOSE_WINDOW` через справжній GNOME XWayland на розпакованому пакеті. Процес завершився кодом 0 і записав `pc_port.cfg`. Launcher і df передали свій PID нативному ELF через exec. Залишкові попередження Godot про ObjectDB і ресурси при teardown зберігаються у raw logs.

У цій перевірці Steam auth був вимкнений. ENet `leave` перевірено окремо на двох процесах. Реальний Steam/WebRTC connection shutdown і ручне закриття native Wayland — NOT RUN. [Джерело pinned X11 backend](https://github.com/godotengine/godot/blob/ed1daf0bf001b61586d9930840f2f1394092c079/platform/linuxbsd/x11/display_server_x11.cpp) · Exit evidence (`archive-gui-exit.log`) · GDB (`probe-main-gdb.log`)
