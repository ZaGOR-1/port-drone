# L01 · Нативні бібліотеки

> Історичний матеріал з `toolchain/linux-native/L01_GDEXTENSIONS.md`. [Реєстр досліджень](../INDEX.md)

| Залежність | Походження | Стан |
| --- | --- | --- |
| GodotSteam | v4.23.2-gde, commit 3513509dc7349f479378b0f2af2b96107f08c157. Upstream вказує Godot 4.4+ | Linux x86_64 debug/release. Windows Release DLL побайтово збіглася з upstream. Linux Release завантажився. |
| Steam API | libsteam_api.so із того самого релізу GodotSteam, release family Steamworks SDK 1.65 | ELF завантажився. Пара Windows steam_api64.dll побайтово збіглася з upstream. |
| WebRTC native | 1.2.2-stable, commit 62135fc034cbdc5aee177136e526e3ead3cc563a. Descriptor мінімум 4.3 | Linux x86_64 debug/release. SHA256 ZIP звірено з Release API, Windows Release DLL збіглася. Linux Release завантажився. |
| df_device | Descriptor Apple, Android plugin згаданий у коментарі. Source/tag для поточного проєкту не встановлено | Shared extension_list активує GodotSteam і WebRTC. DeviceCheck обробляє відсутність DFDevice. |

GodotSteam ZIP отримано з Codeberg Release. До піну внесено локальний SHA256, звірено розмір з Release API і обидві відомі Windows DLL з архіву. Окремого підписаного upstream checksum для ZIP не встановлено. Використано Linux файли з тих самих upstream-релізів як і Windows. [GodotSteam](https://codeberg.org/godotsteam/godotsteam/releases/tag/v4.23.2-gde) · [WebRTC](https://github.com/godotengine/webrtc-native/releases/tag/1.2.2-stable)

SHA256 усіх п’яти файлів є в runtime manifest. Перевірено ELF64 x86_64, entry symbols, DT_NEEDED і ldd без нерозв’язаних залежностей. Steam API лежить поруч із GodotSteam і знаходиться через RPATH $ORIGIN. /proc/maps показав усі три Release .so. Debug файли перевірено за SHA256 і ELF/ldd. Runtime manifest (`manifests/runtime.json`) · Loaded paths (`evidence/gui-loaded-libraries.txt`) · ELF (`evidence/elf-closure.txt`)

GodotSteam і WebRTC plugin — MIT. Notices Godot, GodotSteam і залежностей WebRTC збережено в licenses. Steam API — Valve redistributable за умовами Steamworks SDK. L01 — локальний QA. Для публічного поширення перевірити Steamworks agreement, AppID і notices. [Steamworks SDK](https://partner.steamgames.com/doc/sdk/api) · [WebRTC license](https://github.com/godotengine/webrtc-native)
