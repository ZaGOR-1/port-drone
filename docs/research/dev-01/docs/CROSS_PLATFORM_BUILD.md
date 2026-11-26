# DroneFlames · Cross-Platform Build v1

> Історичний матеріал з `toolchain/dev-environment/docs/CROSS_PLATFORM_BUILD.md`. [Реєстр досліджень](../../INDEX.md)

Один репозиторій гри з однією активною гілкою інтеграції. CLI df читає Development Environment manifest і передає платформні операції чинному бекенду. Windows x64 пакується на Ubuntu x86_64. Linux x86_64 має локальний official desktop QA backend із L01.

| Host і ціль | Doctor | Build / run / package |
| --- | --- | --- |
| Ubuntu x86_64 → Windows x64 | PASS для official і patched | Дві свіжі збірки й run --check пройшли. Wine launcher і SFX pack доступні через df-windows. |
| Ubuntu в WSL2 → Windows x64 | Спільний Linux-адаптер | Нативно у WSL2 у цій задачі NOT RUN. GUI через Wine залежить від WSLg і графічного стеку. |
| Windows 11 x64 → Windows x64 | Викликає наявний PowerShell check | Native backend BLOCKED. Синтаксис PowerShell PASS, нативне виконання NOT RUN. |
| Linux x86_64 → Linux x86_64 | Official pins PASS | Official desktop build/run PASS у L01. Patched і release packaging відкриті. |

df-windows зберігає свої команди, окремий Wine prefix і правила QA. Він вибирає чистий Git revision, перевіряє pin, фізично матеріалізує revision у staging, збирає PCK наявним редактором і перевіряє binary identity. Лише успішна перевірка оновлює latest для вибраного профілю. Linux editor/PCK packer, дані гри та тести залишаються спільними. Runtime, нативні бібліотеки, staging, launcher і спосіб пакування залежать від платформи.

### Докази тестів

- Ізольований workspace із пробілами в шляху. Локальна копія beta c91e0e6 і копії обох pinned профілів. Дві свіжі Windows QA-збірки, верифікація runtime, identity, DLL і SHA256. df run --check і прямий df-windows run --check пройшли для обох.
- Окремий SFX verify пройшов для наявного artifact ubuntu-20261123. Перевірені PE32+ AMD64, launcher, 4 вкладені компоненти й SHA256. Нова збірка SFX і Wine GUI у цьому циклі — NOT RUN. Dispatch для pack перевірено unit-тестом.
- 11 unit-тестів PASS, з них 7 для CLI і 4 наявні restore. Перевірено help, невалідні аргументи й manifest, відсутній backend, native Windows dispatch і Linux NOT_IMPLEMENTED.
- Синтаксис setup-windows.ps1 і check-windows.ps1 — PASS в установленому PowerShell на Ubuntu. Native Windows, Steam, LAN і WSL2 — NOT RUN. Ізольований Linux editor smoke підтвердив відсутність .so.
- Production beta чиста на c91e0e6. Відбитки R01/R02 і точні стани R03–R06 збіглися з вхідними. Немає інтегрованих PoC.

[Команди](CLI_REFERENCE.md) · [Manifest](../PLATFORM_MANIFEST.md) · [Linux](LINUX_READINESS.md) · [Windows](../WINDOWS_READINESS.md) · [Архів](../../r03-r06/R03_R06_BACKUP.md)

[L01 Linux package](../../l01/L01_LINUX_PACKAGE.md)
