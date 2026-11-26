# L01 · Smoke Tests

> Історичний матеріал з `toolchain/linux-native/L01_SMOKE_TESTS.md`. [Реєстр досліджень](../INDEX.md)

| Перевірка | Результат |
| --- | --- |
| df doctor/build/run --check/headless | PASS для official, SHA256 і ELF/ldd пройшли. Patched повернув BLOCKED. |
| Реальний native desktop | Головне меню на X11/XWayland зі шрифтами, текстурами та картою відображено. |
| Vulkan | Forward Mobile, Vulkan 1.4.329, NVIDIA RTX 4060 Laptop. Підтверджено в Xvfb і desktop запуску через df. |
| Аудіо | PipeWire показав активний нем’ютований потік s16le stereo 44,1 кГц. Прослуховування вручну NOT RUN. |
| Ввід | Миша й Escape спрацювали через XTest в ізольованому Xvfb. Фізична клавіатура, IME, DPI та native Wayland input ще потребують QA. |
| Нова гра | Карта 512×512, створена столиця, 4 країни, ігровий годинник і HUD. |
| Save/Continue | Створено slot_1 через паузу, відновлено через Continue з головного меню. Windows runtime під Wine прочитав копію. |
| Завершення | Desktop через df --quit-after 120 завершився кодом 0 з teardown warnings. Синтетичний WM close в Xvfb не завершив довший процес до timeout. Штатне ручне закриття відкрите. |
| Windows regression | run --check обох профілів PASS на наявних пакетах. Windows GUI і SFX у L01 не повторювали. |
| CLI і restore | 13/13 unit-тестів PASS. |

Saves/settings збереглися в окремому XDG-профілі L01. Replay Windows використовував окремий Wine prefix. Реальні Steam акаунти й LAN не використовували. Xvfb GUI також показав XIM/DRI3 warnings і два mesh-null повідомлення під час повернення в меню.

Меню (`evidence/menu.png`) · Нова гра (`evidence/xvfb-new-game.png`) · Saved (`evidence/xvfb-saved.png`) · Continue (`evidence/xvfb-restored.png`) · Desktop exit (`evidence/cli-desktop-exit.log`) · Audio (`evidence/gui-audio.json`)
