# FIX-01 — регресійні перевірки

Контрольований сценарій `tests/test_hud_camera_input.gd` подає синтетичні події через `Window.push_input`. GUI і Main працюють через звичайні Godot input callbacks. Тест використовує ізольований профіль, синтетичний світ із фіксованим seed, казарму та піхоту. Симуляція зупинена під час порівняння позиції й zoom камери. Fixture входить до CI через `test_v036_regressions.py`.

- Дві серії по 20 кліків, double click, мікрорух, UI та world, release над UI, втрата фокуса, навмисні LMB і RMB pan.
- Settings scroll і межа scroll, backdrop, зміна мови, wheel після закриття. Перевірка scroll армійських overlay й доступності дій.
- Bounds списку армій, редактора й високого popover, зміна розміру відкритої панелі, uk/ru/en.
- Виділення піхоти через Shift+ЛКМ і прямокутник, звичайний шлях диспетчеризації наказу через Shift+ПКМ.

Цільовий прогін запускається з кореня фізичної QA-копії:

```sh
DF_GODOT=/path/to/pinned-godot PYTHONDONTWRITEBYTECODE=1 \
  python3 -m unittest discover -s tests -p test_v036_regressions.py \
  -k hud_layout_and_camera_input -v
```

Попередня версія fixture на `c91e0e6` і `0e8316e` відтворила всі три дефекти. Цільовий headless fixture — **36/36 PASS**. Релевантні simulation regressions — **2476/2476 PASS**. У редакторі Linux журнал містить відомі повідомлення про відсутність debug-версій розширень Steam/WebRTC і діагностику ресурсів при завершенні. Performance suites R01–R07 не запускалися.
