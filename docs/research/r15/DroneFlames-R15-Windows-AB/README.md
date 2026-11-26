# DroneFlames R15 Windows x64 A/B

> Історичний матеріал з `toolchain/performance/r15.pCbzhv2E/ab-stage/DroneFlames-R15-Windows-AB/README.md`. [Реєстр досліджень](../../INDEX.md)

A — beta 50f3f04306ec49ea600296135225282907c9955c. B — R15 75f6a1327092ad23bcf58cf734010deec6ff870d. Обидва варіанти 0.36.6, official Godot 4.7.2.

Розпакуйте комплект у каталог із правом запису. Запустіть PowerShell ./Run-AB.ps1 -Variant A або ./Run-AB.ps1 -Variant B. Кожен запуск має окремий профіль, спільний D2100 checkpoint і вимкнений updater. У меню завантажте слот 1. Чергуйте A/B та B/A з однаковою швидкістю, камерою, налаштуваннями й тривалістю. Скрипт задає 1280×720, Vulkan Mobile, VSync і FPS cap off.

Це ручний Windows A/B на QA-збірках зі спільного дискового сейву. Linux fixture використовував окремий генератор сценарію та контрольний потік lockstep-команд. Фізичний запуск і вимірювання Windows — NOT RUN. SHA256 і provenance є в комплекті.
