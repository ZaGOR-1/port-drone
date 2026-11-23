# Localization Tests

```bash
python3 tools/check_l10n.py --json /tmp/df-l10n-catalogs.json
DF_GODOT=/path/to/pinned/godot python3 -m unittest discover -s tests -p 'test_l10n.py' -v
```

Обидва режими CI вже запускають unittest discovery. Перевірка PO виявляє повторний ключ у тому самому контексті, неправильні locale headers, singular/plural структуру, порожні або fuzzy активні записи та неправильні placeholders. Позиційні аргументи мають зберігати порядок і специфікатор, іменовані можуть міняти порядок і граматичний відмінок. Кандидати за евристикою прямих Label/Button/tooltip literals і відмінності структури каталогів доступні у JSON. Динамічні ключі й правильність перекладу перевіряються функціональним та ручним QA.

- **L10N PASS у заявленому scope**. Три unittest, серед них 77 Godot checks на реальних контролах. ru/uk/en, меню, Settings із підекранами, New Game, список saves, офлайн Multiplayer, підстановки, fallback, змінення підказок HUD, збереження вибору й вибір локалі updater. Фактичний UI font має і/ї/є/ґ та ё/ы/э/ъ. У Godot editor fixture штатні Steam/WebRTC .so не включені. Окремий native пакет використовує exact Linux GDExtension.
- **Регресії PASS**. 31 Python/Godot test із suites build identity, release mock, CI policy, snapshot restore, v0.36 regressions і network identity. Simulation regression 2476/2476. Release suites використовували mocks, публікації не було.
- **Короткий replay PASS**. На одному Linux engine і тому самому instrumented PCK R06-A зі змінами цієї гілки в ru, uk і en виконано по 150 fixed ticks з seed 20261016, 216 початковими юнітами і тими самими командами. Покрокові NetHash, події черги, command CRC, NetHash.parts і movement digest збіглися. Final NetHash 410d967a76cc617b.
- **Windows build PASS**. Свіжий ізольований official Windows x64 PE+PCK, три DLL, SHA256 та embedded identity v0.36.0/7/v036-integration-1. Native Windows GUI, Steam, реальні LAN/WebRTC і створення SFX — NOT RUN.
- **Native Linux GUI**. Той самий PCK із Windows EXE, Linux ELF і залежності L01 скопійовано в ізольований QA-пакет. На Vulkan перевірено реальні україномовні меню, Continue на копії синтетичного save, паузу, Settings і перехід на en з оновленням картки «План розвитку». Це окремий кандидат, L01 залишився без змін.

### Залишковий ручний checklist

1. ru/uk/en на чистому й наявному профілях. Зміна locale через Settings під час гри, повернення до HUD, перезапуск. Перевірка відкритих дипломатичних карток, військових tooltip і журналу старих сповіщень.
2. На 960×540 і 1600×900, UI scale 70/100/130%. Довгі команди, підтвердження, tooltip, таймери, авіакрило, ядерна шахта, земельний обмін, хроніка. Перевірити три публічні локалі, нейтральні власні назви і знаки і/ї/є/ґ.
3. Save HUD, пошкоджений слот, заміна й rollback на копіях. Offline створення lobby та join діалог. Окремо реальні transport errors, відключення, sync, Steam/ENet/WebRTC.
4. Перевірити 244 uk і 222 en порожні записи за фактичними dynamic call sites, окремо прихований es. Повний Localization PASS потребує завершення цих сценаріїв.
