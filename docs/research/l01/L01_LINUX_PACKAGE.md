# L01 · Linux desktop QA package

> Історичний матеріал з `toolchain/linux-native/L01_LINUX_PACKAGE.md`. [Реєстр досліджень](../INDEX.md)

```text
DroneFlames-Linux/
├── DroneFlames.x86_64
├── DroneFlames.pck
├── addons/godotsteam/linux64/
│   ├── libgodotsteam.linux.template_release.x86_64.so
│   └── libsteam_api.so
├── addons/webrtc_native/lib/libwebrtc_native.linux.template_release.x86_64.so
├── licenses/
├── BUILD_PROVENANCE.json
└── SHA256SUMS.txt
```

PCK SHA256 **55b31c4877990cb1543aabf9eaa4eaf6463bc9a2b7b34968db5fd5d5ad1c0abd**. Ці самі байти витягнуто з перевіреного patched Windows EXE на beta c91e0e6. Builder звіряє запитану Git-ревізію, Windows provenance та EXE SHA256, межі PCK, магію й trailer. Staging фізичний і розміщений під linux-native. ELF/.so платформні, PCK спільний. Production tracked .godot, project.binary, override.cfg і GDScript лишилися без змін.

```bash
df doctor --platform linux
df build --platform linux --revision c91e0e6
df run --platform linux --check
df run --platform linux --headless --quit-after 15
df run --platform linux
```

Build бере останній перевірений patched Windows package відповідної ревізії як джерело PCK. Якщо його немає, повертає BLOCKED. Native запуск виконує ELF напряму, з ізольованим XDG-профілем linux-native/profiles/cli, без updater та Steam-автентифікації. Linux patched profile — BLOCKED, release packaging — NOT_IMPLEMENTED.

Provenance (`evidence/BUILD_PROVENANCE.json`) · Package SHA256 (`evidence/PACKAGE_SHA256SUMS.txt`)

Перевірка portability охопила 883 tracked шляхи під game. У текстових .gd/.tscn/.gdextension/.cfg/.remap не виявлено literal res:// з помилкою лише регістру, колізій назв без урахування регістру або абсолютних Windows drive paths. Динамічно складені ресурси покрито лише маршрутом desktop smoke. Windows updater має окремі OS guards. Save/Settings лишаються в user://. Фактичний smoke save записано в XDG_DATA_HOME/godot/app_userdata/DroneFlames/saves, режим виконання ELF збережено.
