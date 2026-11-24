# Versioning Policy

Версія гри використовує числову трійку MAJOR.MINOR.PATCH. Під час 0.x застосовуємо SemVer-подібну політику сумісності. PATCH виправляє сумісні дефекти, MINOR додає завершені можливості, MAJOR і несумісності потребують погодження. Один готовий логічний кандидат отримує один bump після релевантного QA. Документація, тести, локальні PoC і tooling самі по собі версію не змінюють.

Канонічне редаговане поле — [pc] version у game/pc/version.cfg. Menus.VERSION — синхронізована константа з v, її читають UI та префікс NetConfig.version. tools/build.py --print-version уже перевіряє рівність. tools/ci/verify_identity.gd звіряє обидві копії у PCK. Тести CI також утримують явний acceptance fixture поточної версії. Windows EXE містить PCK, SFX переносить цей EXE, Linux L01 бере той самий PCK. Native Windows PE version resource або версія ELF Godot не є джерелом версії гри. SHA та dirty записуються в provenance.

У базі немає окремого підтримуваного CHANGELOG.md. Історію гравця формує екран «Що нового», технічні зміни описані в PROJECT_STATE.md і QA reports. Для готового bump актуалізуй відповідні release notes та відомі перевірки версії. У новому кандидатові версію на beta потрібно звірити ще раз перед інтеграцією.

Legacy tools/release.py розпізнає v-теги, ручну числову версію й довші updater-compatible CI suffix. Це окремі правила історичного інструмента. Поточний read-only CI використовує source version і не публікує. Створення тегів потребує окремого дозволу. PROTO, SIM_REV, Save.FORMAT і libs_rev мають власні правила сумісності.

[CI](../.github/workflows/build.yml) · [Version guard](../tools/build.py)
