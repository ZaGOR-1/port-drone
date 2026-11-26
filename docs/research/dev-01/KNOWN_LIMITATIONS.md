# Межі Development Environment v1

> Історичний матеріал з `toolchain/dev-environment/docs/KNOWN_LIMITATIONS.md`. [Реєстр досліджень](../INDEX.md)

- Ціль — відновлення Ubuntu workflow для Windows x64. Нативний Windows setup/build, Steam/LAN, повні GUI/FPS, новий SFX build і компіляція Godot — **NOT RUN** у цій задачі. Профілювання й контракти гри лишаються прив'язаними до минулих прогонів.
- Essential офлайн відновлює Git, артефакти і QA-докази на машині з базовими програмами. Повне offline-розгортання чистої ОС потребує ще apt/npm/uv пакетів, графічного стеку, моделей автентифікації та, для Windows, редактора. Extended додає Godot source і dependency ZIP; системний MinGW compiler, Node та сторонні MCP пакети встановлюються окремо.
- Wine runners залежать від Linux шляхів `/proc`, Wine prefix і Linux Vulkan. `wineserver` може потребувати окремого PATH. Історичний R02 ENet та локалізація R01 SP hashes — PARTIAL. Копіювання snapshot перевірене побайтово; ігрове завантаження цього snapshot — **NOT RUN**.
- Старі звіти зберігають оригінальні абсолютні шляхи як provenance. Вони можуть містити локальне ім’я профілю. Артефакти призначені для приватного зберігання. Нові wrapper і restore підтримують інший корінь.
- Native Linux Git checkout можна редагувати. Linux runtime потребує окремих GodotSteam і WebRTC бібліотек та рішення для `df_device`. Поточна Linux editor/shadow діагностика має відповідні обмеження.
- Production QA-історія й віддалений repo охоплюють нову Git-історію зі snapshot. Історичний шлях `~/port-drone-worktrees-archive` з production docs був відсутній на цій машині. Докази поза доступними шляхами не перевірено.
- Резервну копію фізично треба перенести на незалежний SSD. SHA256 захищає від пошкодження під час копіювання. Збережи незалежну довірену копію контрольних сум.

- SCons MinGW preflight перевірено у фізичній копії без пробілів у шляху. Restore і звичайне пакування `df-windows` пройшли у шляхах з пробілами.
