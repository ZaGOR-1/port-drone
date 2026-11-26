> Історичний матеріал з `toolchain/pr7-windows-qa.M7KMMf/pr-7-body.md`. [Реєстр досліджень](../INDEX.md)

## Summary

Підготувати локалізацію DroneFlames і правила розробки до review в `beta`.

- Закріплено Git Workflow v2, правила погодженого push і Draft PR, чинну політику версіонування та джерело версії.
- Задокументовано політику локалізації `uk`, `ru`, `en` і fallback. Іспанська лишається прихованою.
- Усунено змішування української й російської у перевірених сценаріях. У L10N-02 перевірено 466 порожніх записів, заповнено 29 активних перекладів і додано два пропущені ключі в обох каталогах.
- Виправлено форматування динамічних текстів HUD, сповіщень, дипломатії, Multiplayer і завантаження. Розширено тести каталогів, множини, перемикання мови, fallback та збереження мовних налаштувань.

## Commits

- `f71eebc` — правила Git, версіонування й локалізації.
- `07d73d9` — початкові виправлення локалізації.
- `15b6bbb` — автоматичні перевірки каталогів і перемикання мови.
- `f1e1f66` — динамічні тексти HUD і Multiplayer.
- `3ee7f1d` — переклад етапів завантаження до анімації.
- `a8aff50` — аудит і докази L10N-02.
- `0e8316e` — погоджена публікація гілок і workflow Pull Requests.

## Verified

Результати L10N-02 належать до того самого дерева гри `26e85284d4c7ae2d11bdc95a0f09eef623d15683`.

- 125 Godot L10N checks, 46/46 unittest, 2476/2476 simulation checks.
- 30 fixed ticks зі спільного snapshot у `uk`, `ru`, `en`. NetHash і RNG збіглися на кожному тіку. Фінальний NetHash `787a72dc394849ab`.
- Linux GUI QA у трьох локалях, зокрема Continue, перемикання та збереження української після перезапуску.
- Windows x64 build checks пройшли для PE, embedded PCK, DLL і SHA256.
- Wine startup smoke дійшов до українського меню. Контрольні запуски з обмеженням кадрів завершилися за таймаутом після появи меню.
- Після оновлення Git-документації повторно перевірено каталоги, 19 тестів CI та release policy з mock-даними, версію та чистоту diff.

## Remaining QA

- Native Windows GUI, DPI, довгі підписи та масштаб UI.
- Реальні Steam/LAN reconnect і resync.
- Рідкісні армійські накази, дипломатичні повідомлення й старі сповіщення після зміни мови.
- Пошкоджені saves, заміна й rollback.
- Помилки завантаження та контрольної суми updater.

## Integration status

**PARTIAL — Review candidate.** У рідкісних гілках можливий неперевірений мовний fallback. Для мережевого QA обом сторонам потрібен той самий EXE і комплект DLL з однаковими SHA256. Контракти Multiplayer і Save/Load залишилися чинними. Windows native GUI і живий transport QA залишаються відкритими.

## Version

`0.36.0` — unchanged.


## CI та Windows 11 QA · PR #7

[DroneFlames CI #45278752360](https://github.com/ZaGOR-1/port-drone/actions/runs/45278752360) завершився успішно. Python/CI policy і Godot/Windows x64 build — PASS, release job — SKIPPED. Діагностика CI підтверджує 46/46 unittest, 125 L10N checks і 2476/2476 simulation checks. CI checkout на `61fcb9e33584082e1e6eca4a61b66f8af2f8ba79` має те саме Git-дерево, що й feature HEAD.

Для ручного QA створено локальний Windows x64 ZIP через наявний `df build` з чистого feature HEAD `0e8316ee167b11a90925e33a126290b6848d9986`. Версія `0.36.0`, official Godot `4.7.2.stable.official.ed1daf0bf`. Embedded identity, EXE і три DLL перевірено. ZIP містить `BUILD_PROVENANCE.json`, `QA-SHA256SUMS.txt` та `WINDOWS-QA.txt`.

- EXE SHA256 `eb5060b3f6731c8bdbfc42637d9b4bf4b101c5d38b74ea37ca81ffdcec4543ad`
- Локальний QA ZIP SHA256 `883668885c8f75e882b17b9330bbaac0e34c16e240c14da3e5f739eb1e3674c1`
- Цей EXE пройшов headless startup у Wine 10.0 на Ubuntu. Завантажився `uk`, згенерувався світ і процес повернув exit 0. У логах є повідомлення про витоки ресурсів при завершенні.

Native Windows GUI, матриця `uk/ru/en` × DPI 100/125/150%, довгі написи й tooltip, пошкоджені saves і rollback, рідкісні накази й дипломатія, Steam/LAN reconnect і resync та updater error paths залишаються NOT RUN. Для updater потрібен окремий debug fixture із локальним endpoint. **PARTIAL — готовий до фінального review і ручного QA, лишається Draft.**
