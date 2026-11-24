# L10N-03 · Multiplayer QA

Використано PCK із Windows QA EXE `eb5060b3…` на Ubuntu з офіційним Godot editor у headless. Два процеси з окремими профілями й лише інтерфейсом `lo` у виділеному network namespace. Steam mock bypass і заборона LAN broadcast. Тестовий розрив ініційовано викликом наявного handler втрати зв’язку, який закрив peer. Повторне підключення та snapshot передано через реальний ENet на localhost.

| Кейс | Статус і доказ |
| --- | --- |
| Lobby, host `uk` / guest `en` | PASS · два клієнти, гостю виділено слот, lockstep просунувся. |
| Reconnect, snapshot, resync | PASS · повернення на той самий слот, англійське `ATTEMPT 1 · YOUR SLOT IS SAVED`, `[Net] resync to turn 20: ok` у журналі гостя, подальший прогрес тіків. Після відновлення гість вийшов із партії. |
| Несумісна мережева ідентичність | PASS за наявним CI fixture · реальний ENet hello, відмова для відмінної identity. [CI-діагностика](https://github.com/ZaGOR-1/port-drone/actions/runs/45278752360) |
| Фізичний LAN і Windows peer | NOT RUN · discovery, системний firewall, реальний обрив з’єднання, повний GUI transport і покажчики помилок. |
| Steam integration | NOT RUN · Steam lobby/join, reconnect і resync через Steam. |

На двох Windows ПК звір SHA ZIP, EXE й DLL. Використай окремі профілі `Run-MultiplayerQA.ps1` з `-Transport LAN`, `-Peer host` та `-Peer guest`. Пройди create/join, помилковий join, вихід із lobby, старт, обрив зв’язку гостя й повернення в межах 60 секунд. Звір слот, локалізовані повідомлення і виконання нового наказу. Resync підтвердь журналом надсилання та відновлення snapshot. Якщо окремий DIFF/desync resync не виник, познач саме цей кейс NOT RUN. Steam виконуй окремо з явним `-Transport Steam` і дозволеними тестовими акаунтами.
