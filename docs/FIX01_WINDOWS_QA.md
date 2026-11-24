# FIX-01 — Windows x64 QA

Статус інтеграції **CONDITIONAL**. Нативний Windows GUI після виправлень **NOT RUN**. Баг-репорт попередньої збірки зафіксовано в [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7#issuecomment-7116888734).

- `df build --platform windows --profile official` і `df run --platform windows --profile official --check` — **PASS**. Source `a0c33d76cdb52b3b667855220b2d6bee0a01d253`, game tree `d0fcbd205a2cf997b0ab7bef04916bb72e180070`, версія 0.36.0, Godot `4.7.2.stable.official.ed1daf0bf`.
- EXE SHA256 `d0cbff54461f30cf72d85c4ee2c7975f6f9a1fbad54a1d5139ea0dd1f14e06b2`. Пакет містить `libgodotsteam.windows.template_release.x86_64.dll`, `libwebrtc_native.windows.template_release.x86_64.dll`, `steam_api64.dll`. Повні хеші в `BUILD_PROVENANCE.json` та `QA-SHA256SUMS.txt`.
- Portable ZIP `DroneFlames-FIX01-Windows-x64-a0c33d7.zip`, SHA256 `422ae4426a9ee5dd5420a0d8e265e0b6d8c911de51efab63773f096ccaee3c6c`.
- Wine headless startup — **PASS**, код 0. Ізоляція профілю, `DF_STEAM_MOCK=0` й вимкнений updater, діагностику shutdown збережено.
- Для Windows використати наявний `Run-DroneFlames.ps1` з пакета, який запускає окремий QA-профіль з вимкненим updater (`powershell -NoProfile -ExecutionPolicy Bypass -File .\Run-DroneFlames.ps1 -Mode Gui`). Перед тестом звірити SHA256. Занести OS build, роздільну здатність, DPI, UI scale та параметри миші.

| Сценарій Windows 11 | Результат |
|---|---|
| uk/ru/en, DPI 100/125/150%, довгі підписи, відкриття групи, контекстне меню біля краю й resize | NOT RUN |
| Найнижчі кнопки, scroll та армійські підказки у короткому вікні | NOT RUN |
| Wheel над кнопкою, scrollbar і тлом Settings, зміна мови, wheel після закриття | NOT RUN |
| 20 ЛКМ, 20 з мікрорухами, double click, відпускання над HUD та Alt+Tab | NOT RUN |
| LMB/RMB pan, клік і Shift-рамка для виділення, ПКМ і Shift+ПКМ для наказів | NOT RUN |
