# INT-08 · Локальне приймання 0.36.7

> Історичний матеріал з `toolchain/int08.1UTXXUmq/handoff/QA.md`. [Реєстр досліджень](../INDEX.md)

Код R15 і version bump перевірені у фізичній копії, а обидва official QA-пакети кандидата зібрані через unified `df` на DEV-02. Build guard, runtime identity і PCK parity перевірено на candidate SHA. Godot 4.7.2 використано з наявного pinned toolchain.

| Перевірка | Результат |
| --- | --- |
| Python discovery | 50/50, SKIP 0 |
| Simulation regression | 2476/2476 |
| Watchdog / ring / HUD input | 101/101 на A та B, 8/8, 36/36 |
| R10, R14 і R15 differential | 49/49, 59/59, 1310/1310 на A та B, звіти побайтово однакові |
| L10N, version guard і runtime metadata | PASS, `v0.36.7/7/v036-integration-1` |
| C1200 / D2100 replay | 120/120 на кожному, NetHash `31a7b74c6e28b7b9` / `6bee855c1a62f9d0`, RNG 3317424724 / 544852764 |
| Late E | 150/150, NetHash 4693 `f19767f333c29101`, 4746 `c9301a1dcbcd76e8`, 4800 `3c338abc3ec9d5c7`, RNG `1940658711` |
| Save/Load | 66/66 зі спільного та власного save, кінцевий NetHash `3173b898dea8e6e7`, RNG `2069155221` |
| ENet | Два процеси, авторизація, lockstep, reconnect, resync, відновлення тіків. 0.36.7 допущена з 0.36.7. Змішані 0.36.6/0.36.7 відхилено в обох напрямках |
| Pre-merge пакети | Windows official x64 build, Linux native smoke, Wine headless smoke, однаковий PCK |
| Physical Windows GUI/FPS, LAN, Steam | NOT RUN, Windows QA відкладено власником |

Історичні A replay PCK і A differential PCK побудовано з бази 0.36.6 у R15. Їх повторно використано як контроль й запущено разом із новим B. Smoke signatures кандидата збігаються з R15. DummyTexture, mesh is null і teardown warnings залишаються відкритими. Під час replay використано наявний `--fixed-fps 30` для неавторитетних часових міток HUD. Assertions й історичні hash fixtures збережено. Результати A/B, довідкові хеші та перевірки збірки зберігаються в `../evidence`, `../raw` і `../pre-final`. Апаратні вимірювання R15 повторно обчислено з наявних даних.

Локальний gate (`../evidence/local-gate.log`) · Результати replay (`../evidence/replay.log`) · ENet (`../evidence/enet.log`) · Повний version admission (`../evidence/patch-admission.log`) · PCK parity кандидата (`../pre-final/parity.json`)

## Після merge

Повні дерева кандидата й merge збігаються. На точному SHA beta `d6a38e8db58361430df69ffe0a98e628acac6d8b` пройшов post-merge CI. В архівах перевірено EXE/ELF, три DLL і три SO x86-64, provenance, версію, маніфести й однаковий PCK `c984f1dafdee622da6d206b9427003571244f78e4d8c99a74fc365ac3a6dafb6`. Linux native smoke після розпакування пройшов.

Wine після розпакування · PARTIAL. У першій спробі EXE отримав `Unhandled page fault on execute access to 0000000000000000` після WorldGen. Далі debugger очікував до timeout 124. EXE SHA256 `67b2841566dd2a368578e59cb9a4ea7dbb0b8694b4911eeeca1adfe7490a796d` збігається з двома успішними доархівними smoke. У нових ізольованих Wine-префіксах усі чотири повтори після розпакування пройшли, три з вимкненим автоматичним debugger і один зі стандартною конфігурацією. Контрольний 0.36.6 пройшов 2/2. У цій малій вибірці збій повторно не відтворився. Причинність R15 і зв’язок із відомою native race лишаються невстановленими. Пакет позначено QA. Перший збій (`../post/wine-controls/first-extracted-fail.log`) · Контроль A/B (`../evidence/wine-controls.log`) · Звичайний повтор (`../evidence/wine-standard-retry.log`)

[Pre-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45610133602) · [Post-merge CI](https://github.com/ZaGOR-1/port-drone/actions/runs/45611268786)
