# L01 · Runtime Godot Linux x86_64

> Історичний матеріал з `toolchain/linux-native/L01_RUNTIME.md`. [Реєстр досліджень](../INDEX.md)

Офіційний Release export template **4.7.2.stable.official.ed1daf0bf**, upstream **ed1daf0bf001b61586d9930840f2f1394092c079**. Взято templates/linux_release.x86_64 з офіційного 4.7.2-stable TPZ. SHA256 TPZ звірено з наявним pin і metadata GitHub Releases. SHA256 ELF — d9f79ab89b5ae369aeed11c6052d402e8218cd503bf85b4a235f9c30c46a7c63. Локального сумісного Linux template до L01 не знайшли. [Офіційний реліз](https://github.com/godotengine/godot-builds/releases/tag/4.7.2-stable)

ELF64 AMD64, loader /lib64/ld-linux-x86-64.so.2. Версію й залежності звірено на Ubuntu. Працює автоматичне завантаження сусіднього DroneFlames.pck. Цей Release відхиляє --main-pack через disable_path_overrides. Replay використовує розкладку з однаковими basename.

Офіційного template вистачило для L01 desktop smoke. Еквівалентність Windows C++ patch не встановлена. Попередній official Linux editor мав 2 abort із 5 у спеціальному GDScript race fixture. Для поточного exact Release ELF race fixture ще NOT RUN. Перед stress та широким QA потрібно кваліфікувати patched Linux template з тим самим diff.

У L01 звірено upstream SHA, SHA256 патча, зворотний apply --check на локальному patched source, C++/SCons та ресурси хоста (близько 6 GiB доступної RAM і запас swap). План задає linuxbsd x86_64 release та окремий QA override. На чистому фізичному checkout цієї ревізії застосувати pinned patch і звірити SCons options перед запуском з -j2. L01 Godot не компілював. SCons (`manifests/patched-linux-plan.json`) · ELF (`evidence/elf-closure.txt`) · Preflight (`evidence/patched-preflight.txt`)
