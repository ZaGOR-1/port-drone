# L10N-03 · PR #7 Merge Readiness

**NOT READY.** PR придатний для review і має чистий merge з `beta` у GitHub. Немає результатів обов’язкового Native Windows GUI й DPI. Для приймання також відкриті фізичний LAN, Steam і нативні сценарії помилок. [PR #7](https://github.com/ZaGOR-1/port-drone/pull/7)

| Gate | Status | Evidence | Risk |
| --- | --- | --- | --- |
| GitHub CI | PASS | 46 unittest, 125 L10N, 2476 simulation, Windows job пройшов. [Run](https://github.com/ZaGOR-1/port-drone/actions/runs/45278752360) | CI працює на Ubuntu. |
| Windows build | PASS | SHA джерела, official PE/PCK, 3 DLL, ZIP і EXE перевірено. [Хеші](L10N03_WINDOWS_QA.md) | Потрібний запуск на Windows 11. |
| Localization consistency | PASS | `uk/ru/en` у перевірених L10N-02 GUI, Save/Load і mock updater. [QA](L10N03_QA_SUMMARY.md) | Рідкісні накази й повні transport errors на Windows ще відкриті. |
| Linux GUI | PASS | Використано підтверджений L10N-02 GUI з тим самим деревом гри. [QA](LOCALIZATION_TESTS.md#l10n-02) | Інша платформа й DPI. |
| Native Windows GUI | NOT RUN | Windows 11 чи налаштована VM недоступні. | Обов’язковий gate. Невідомий стан нативних контролів і завершення. |
| DPI/long labels | NOT RUN | Linux UI 70/100/130% перевірено. Windows 100/125/150% відкрито. | Можливе обрізання чи перекриття. |
| Save/Load | PASS | 11/11 Ubuntu assertions, rollback і пошкодження на синтетичних даних. [QA](L10N03_WINDOWS_QA.md) | Нативна Windows UI-матриця відмови відкрита. |
| Multiplayer UI | PASS | Офлайн MP у трьох локалях, ENet fixture з англійським reconnect. [QA](L10N03_MULTIPLAYER_QA.md) | Native GUI та рідкісні коди помилок відкриті. |
| LAN connection | PASS | Ubuntu loopback, lobby, reconnect, snapshot/resync. [QA](L10N03_MULTIPLAYER_QA.md) | Фізичний LAN і Windows firewall — NOT RUN. |
| Steam integration | NOT RUN | Steam bypass у локальних fixtures. | Потрібні два Windows-сеанси і тестові Steam-акаунти. |
| Updater error handling | PASS | 42/42 assertion з mock HTTP в трьох мовах, без заміни EXE. [QA](L10N03_WINDOWS_QA.md) | Native updater GUI, мережевий обрив і текст retry — NOT RUN. |
| Determinism | PASS | 30 fixed ticks, NetHash/RNG збігаються. [QA](L10N03_QA_SUMMARY.md) | Підтверджено сценарій replay. |
| Version consistency | PASS | Пакет і джерело `0.36.0`, PROTO 7, SIM_REV v036-integration-1, Save.FORMAT 1. | Acceptance прив’язано до SHA EXE та DLL. |
| Branch cleanliness | PASS | На початку QA local/remote HEAD збіглися з джерелом ZIP, worktree чистий. GitHub mergeable, review threads 0, production `beta` `c91e0e6a`. | Оновлення `beta` або ігрового дерева потребуватиме повторної звірки. |

Після Windows 11 GUI й DPI, тестів saves і довгих рядків збережи звіт з точним SHA пакета. LAN/Steam, рідкісні сценарії та updater зафіксуй окремо за їхніми платформами. Draft лишається активним до оцінки доказів власником.
