## Зміни

- MP-хост публікує checkpoint після перевірки snapshot і повного readback. Попередній придатний checkpoint доступний у `.bak`, коли публікація переривається.
- Помилка запису дозволяє повторити той самий turn. Дедуплікація перевіряє наявний придатний checkpoint.
- Додано regression fixtures, відтворення відмов і фізичний Windows QA handoff. Виправлення обмежене MP host checkpoint.

## Перевірки

- На `f152242` відтворено обрізання checkpoint і втрату retry. На `2ca2152` відтворено ротацію пошкодженого файла того самого розміру поверх придатного backup.
- На `6c778b3` PASS для 67 checkpoint assertions, штатного LAN host restore з двох копій, трьох Linux SIGKILL, Save/Continue, snapshot restore і 2 476 перевірок Godot.
- Windows x64 portable зібрано. SHA256 і packaged identity перевірено. Фізичний Windows LAN/Steam і power-loss durability — NOT RUN.

Baseline `beta f152242`. Версія цього Draft `0.36.11`, PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1. Рішення про merge і PATCH bump після релевантного Windows QA.

Звіт, відтворення, SHA256 і handoff у `docs/fix-stability-01/INTEGRATION_READINESS.md` та `docs/fix-stability-01/WINDOWS_QA_HANDOFF.md`.
