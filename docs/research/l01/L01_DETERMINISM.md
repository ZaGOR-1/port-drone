# L01 · Windows ↔ Linux replay

> Історичний матеріал з `toolchain/linux-native/L01_DETERMINISM.md`. [Реєстр досліджень](../INDEX.md)

Той самий instrumented PCK R06 A на Linux official ELF і Windows patched EXE під Wine. Сценарій A, seed 20261016, 216 початкових юнітів, 150 fixed ticks, вісім команд у turns 4 і 44, CRC 1819051232. FPS у цьому тесті не порівнювався.

| Replay | Початковий NetHash обох | Фінальний NetHash обох | Результат |
| --- | --- | --- | --- |
| A, fixed seed і команди | 78deae51bcb9fd3b | 410d967a76cc617b | 150/150 NetHash, CRC, 12 упорядкованих route/order подій, кінцеві components і movement SHA256. 205 юнітів наприкінці. |
| Копія SP save з Linux GUI | d3502a8f5e695dc8 | 87a3fb85d356a4bb | 150/150 NetHash, Operations digest і movement SHA256. |

Окремий побайтовий digest Operations.save_state розійшовся на 103 з 150 тиків сценарію A, починаючи з тика 48. У повторному діагностичному прогоні різниця відтворилась із тика 66. На тикові 150 dump локалізував її до prompt.t і prompt.shown[select_barracks:f6] (2,533333333333334 проти 2,200000000000002). Записи бойових операцій у dump збіглися. HUD викликає next_prompt і записує game_time при показі підказки. Повна побайтова ідентичність Operations state і реальний кросплатформний Multiplayer залишаються відкритими.

Save.FORMAT=1 і NetHash лишилися спільними. Фізичний Windows, Windows → Linux для disk save, Steam, WebRTC session і ENet LAN — NOT RUN. Покрокові хеші (`evidence/replay-comparison.json`) · Діагностична зміна (`evidence/l01-diagnostic.patch`)
