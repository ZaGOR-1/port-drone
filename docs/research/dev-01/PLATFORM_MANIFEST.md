# Platform Manifest v1

> Історичний матеріал з `toolchain/dev-environment/docs/PLATFORM_MANIFEST.md`. [Реєстр досліджень](../INDEX.md)

manifests/environment.json (`../manifests/environment.json`) лишається точкою входу для df, Ubuntu bootstrap та Windows PowerShell. Schema v1 доповнено полями platforms і gdextension.targets. Старі ключі для setup/restore збережено.

| Що задається | Джерело |
| --- | --- |
| Ціль windows або linux, архітектура x86_64, доступні build hosts, Windows entrypoints | platforms |
| Default repo, toolchain, редактори, SFX directory | paths, відносно workspace root |
| Release artifacts та latest pointers для official/patched | profiles |
| Godot 4.7.2 і upstream revision | godot |
| SHA256 official editor і Windows template | tools/ci/godot-4.7.2.json із чистого checkout |
| SHA256 patched runtime, QA runtime, C++ diff, профіль і залежності | mingw-patched/BUILD_MANIFEST.json і dependency-pins.json |
| GDExtension Linux mappings і залежності | фактичні .gdextension, із шляхами до descriptors у gdextension.targets |
| Точний Git revision, runtime profile/hash, game tree, внутрішній PCK, DLL | BUILD_PROVENANCE.json і package SHA256 у результаті df-windows |

Файлові шляхи в нових manifest-полях відносні. Корінь приймається через --workspace-root або DF_WORKSPACE_ROOT. Build приймає --source та --engine-dir для явного вибору checkout і редактора. Поточну ревізію бере df-windows через HEAD або --revision. Verifier і SFX tooling зберігають власні вимоги до чистого revision і профілю. Хеші не переписано.

Розкладка чинного бекенду: тимчасові .stage-* під windows-dev, builds/<id>/package для артефактів, latest і latest-patched для останніх перевірених збірок. Мінімальний комплект — DroneFlames.exe, три Windows DLL, QA scripts, provenance й контрольні суми. Manifest описує ці конвенції, якими керує df-windows.
