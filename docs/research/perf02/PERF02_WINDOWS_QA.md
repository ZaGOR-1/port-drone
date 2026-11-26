# PERF-02. Windows 11 QA

> Історичний матеріал з `toolchain/performance/perf02/PERF02_WINDOWS_QA.md`. [Реєстр досліджень](../INDEX.md)

Фізична Windows 11 GUI, LAN та Steam — **NOT RUN**. Windows FPS — **INCONCLUSIVE** до вимірювання на фізичному ПК. Кандидат залишається в [Draft PR #9](https://github.com/ZaGOR-1/port-drone/pull/9).

## Пакети й сценарій

- A — `DroneFlames-PERF01-Windows-x64-130dce25.zip`, SHA256 `9988c5be2ab641d67eb61b7cfaa4acfb8b1b99e7425f09aaebb1973cc7ab76e5`. B — ZIP із HEAD того самого PR, зібраний через `df build --platform windows --profile official`. Точні Git SHA, SHA256 і smoke-результати для B зафіксовано в описі PR та у локальному каталозі `~/projects/droneflames-toolchain/performance/perf02/`. ZIP містить `BUILD_PROVENANCE.json` і маніфести перевірки EXE та DLL.
- Розпакуйте A і B окремо. Звірте контрольні суми, використайте ізольовані профілі й однаковий сейв, роздільність, DPI, zoom та драйвер. Для SP запуск `Run-DroneFlames.ps1 -Mode Gui` вимикає updater. Повторіть A/B і B/A для 50, 199–201, 300 і 500 цілей за наявності боєзапасу.
- Окремо виміряйте затримку після підтвердження, кадри спокою під час preview, закриття HUD і час до першої хвилі. Якщо кнопка вимагає утримання через оголошення війни, відраховуйте після завершення утримання. Перевірте зміну боєзапасу, недоступну ціль, видалення, скасування й повторне відкриття, змішаний і відкладений удар.
- Перевірте номери, траєкторію й маркери при zoom, панорамуванні, зміні розміру вікна та UI scale. Для LAN і Steam використовуйте однакові SHA256 EXE і DLL на обох ПК у кожному прогоні. Звірте черги, порядок цілей і перший фактичний пуск на хості та гості. Відтворіть також сценарій зі спільним кандидатом після погодженої інтеграції PR #8.

## Верифікований локальний пакет

| Поле | Значення |
| --- | --- |
| Git | `c2cbb9086cad700a34ab03f978267633d2427602` |
| Game tree | `429aa4bfc494f240340f901a243170818dcabd0a` |
| Runtime | `Godot 4.7.2.stable.official.ed1daf0bf` |
| Version | `v0.36.1/7/v036-integration-1` |
| Portable ZIP | `DroneFlames-PERF02-Windows-x64-c2cbb908.zip` |
| ZIP SHA256 | `771d9e19e3985147278e55e6eb291ed02f760779003a05ebc1dc54ed1cf1d0f9` |
| EXE SHA256 | `20befe13df151ba932e4c3b93c89c042b6797412381c7c7ea2af26ecd61832d3` |

Wine 10.0 headless/GUI і Linux headless startup — PASS. Обидва runtime завантажили джерела з перевіреного Windows PCK, а Wine використав перевірені DLL комплекту. У журналах є відомі повідомлення про залишкові ресурси під час виходу. Успішність smoke стосується запуску й генерації світу.
