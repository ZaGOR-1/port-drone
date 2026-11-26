# Linux x86_64 · Readiness до L01

> Історичний матеріал з `toolchain/dev-environment/docs/LINUX_READINESS.md`. [Реєстр досліджень](../../INDEX.md)

Після L01 офіційний Linux desktop QA package, ELF і GDExtension підтверджені. Поточні команди й обмеження наведено в [L01](../../l01/L01_LINUX_PACKAGE.md). Нижче збережено аудит стану до L01.

**BLOCKED для native build/run/package.** Є офіційний Linux editor Godot 4.7.2 x86_64 ELF. Версія 4.7.2.stable.official.ed1daf0bf, SHA256 збігся з pin, ldd не показав відсутніх бібліотек редактора на цьому Ubuntu. У короткому ізольованому запуску точного PCK із Windows QA EXE рушій завершився з кодом 0 і повідомив про відсутні .so. Це доказ того, що редактор прочитав PCK. Export template Linux і перевірений runtime гри відсутні.

| Компонент | Локальний стан | Потрібно для Linux |
| --- | --- | --- |
| Патч Godot | C++ зміни в modules/gdscript; зворотний apply --check пройшов на локальному pinned source | Окремий Linux SCons target і QA. Наявні MinGW EXE, ANGLE, Windows AccessKit SDK paths і Windows-only flags не визначають Linux toolchain. |
| GodotSteam | Windows DLL; є Linux x86_64 debug/release mappings | Відповідні ELF .so і libsteam_api.so, узгоджені з Steamworks SDK та ABI Godot. Перевірити loader, symbols, Steam client/overlay, lobby і relay. |
| WebRTC | Windows DLL; є Linux x86_64 debug/release mappings | Відповідні ELF .so і їхній verified dependency closure. Два клієнти для WebRTC signaling/data channel QA. |
| df_device | Мапінги Apple, Android інтегрується окремо. Linux і Windows mapping відсутні | Desktop DeviceCheck перевіряє singleton і працює з гілкою unavailable. Для звичайного desktop smoke .so необов’язкова. Attestation/ranked сценарії потребують окремого рішення та тестів. |
| ENet | LAN використовує вбудований ENetMultiplayerPeer | Окремий Steam/WebRTC плагін для ENet не потрібен. Перевірити Linux export module, UDP/firewall, host/join і reconnect у Linux–Linux та Windows–Linux. |
| Steam | SteamNet перевіряє наявність Steam singleton. Без нього Steam multiplayer вимкнений. AppID 480 тестовий | Завантажити GDextension й запустити реальний Steam-клієнт з тестовим AppID. Перевірити lifecycle, overlay, connect та relay. Ігровий протокол спільний. |

### Нативні залежності

Git checkout містить три Windows-бінарники у libs і GDExtension descriptors, без вихідних дерев Steam/WebRTC/Device і без їхніх build configurations. PE imports підтверджують прямий зв’язок GodotSteam із steam_api64.dll, а WebRTC — із bcrypt, IPHLPAPI та WS2_32. Для одного спільного вихідного коду розширень слід спочатку зафіксувати точний upstream source/version, відповідний Godot/godot-cpp extension ABI і права на розповсюдження SDK/runtime. З цього самого source створювати Windows DLL і Linux ELF .so окремими target/options. Для Linux зафіксувати мінімальний glibc/libstdc++ та транзитивні залежності. Перевірити entry symbols, DT_NEEDED і RPATH/RUNPATH з локального пакета, включно з розміщенням libsteam_api.so. Готові Windows DLL у Linux target не використовуються.

### Ресурси, дані та desktop smoke

- Переглянуто 883 tracked шляхи під game. Дублів без урахування регістру та випадків неправильного регістру серед literal res:// у gd/tscn/gdextension/cfg/remap не знайдено. Динамічно складені шляхи, binary scenes і результат повного export потребують smoke. Зберігати project.binary, override.cfg, імпорти й remaps зі штатним розміщенням.
- Save, settings та net config використовують user://. Linux smoke ізолює XDG_DATA_HOME, XDG_CONFIG_HOME, XDG_CACHE_HOME. На Linux типовий каталог даних із цією назвою проєкту — ~/.local/share/godot/app_userdata/DroneFlames. Точний шлях перевірити у майбутньому export через OS.get_user_data_dir. Формат save і protocol лишаються спільними.
- PcPort розпізнає Linux як desktop. Native GUI, Vulkan mobile renderer, X11/Wayland windowing, fullscreen, DPI, клавіатурна розкладка, миша, фокус, PipeWire/PulseAudio та playback ще NOT RUN. Wine GUI працює на Windows runtime і не перевіряє Linux шлях.
- Windows tools/build.py додає PCK до PE та пакує DLL. PCKPacker може бути спільним. Linux пакування потребує ELF template і правильного розміщення .so. Перший локальний формат може бути каталожним пакетом ELF + PCK + .so. CI, distro matrix та релізний формат підключаються після smoke.

Історичний BUILD_MANIFEST фіксує 2 abort із 5 на race fixture з official Linux editor. Це окремий тест рушія. Перед використанням будь-якого Linux runtime як QA-кандидата повторити fixture на точному template. [Порядок робіт](../PORTING_ROADMAP.md)
