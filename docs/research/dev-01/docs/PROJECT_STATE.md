# Стан toolchain · Development Environment v1

> Історичний матеріал з `toolchain/dev-environment/docs/PROJECT_STATE.md`. [Реєстр досліджень](../../INDEX.md)

Production source `/home/zagor/projects/port-drone` · `beta` `c91e0e6a7eef831687e6e63550560bba739a6b87`. Діагностичний worktree `/home/zagor/projects/droneflames-toolchain/performance/source` · detached на тому самому коміті. Спільна ідентичність `0.36.0 / 7 / v036-integration-1 / Save.FORMAT 1`.

Інвентар, інструкції та перевірки цієї операції належать локальному toolchain. Production `docs/PROJECT_STATE.md` залишається на committed baseline, щоб виконати вимогу чистої `beta`. [Інвентар](../INVENTORY.md) · [Результати DR](DISASTER_RECOVERY_TEST.md)

Backup локально доступний у `/home/zagor/projects/droneflames-toolchain/backups/20261123-dev-environment-v1.J78ugB`. Essential/Extended DR PASS. Windows native QA NOT RUN.

Наступні кроки — копія на інший фізичний SSD, Windows 11 native перевірка, потім спільний CLI поверх існуючого Windows backend. [План](CROSS_PLATFORM_ARCHITECTURE.md)

## Cross-Platform Build v1

PARTIAL на базі чистого beta c91e0e6. Локальний df зібрав official/patched Windows QA пакети на Ubuntu із перевіркою run --check. Верифіковано наявний SFX. Linux native і Windows native build лишаються заблокованими. Інкремент R03–R06 відновлено з Essential v1, п’ять source дерев і дванадцять staged builds збіглися. [Build v1](CROSS_PLATFORM_BUILD.md) · [Наступні кроки](../PORTING_ROADMAP.md)

## Native Linux L01

Офіційний Godot 4.7.2 ELF зібрано в desktop QA пакет зі спільним PCK та exact Steam/WebRTC dependencies. Нативні GUI, New Game і Save/Continue перевірено. L02 готує patched runtime і мережеву кваліфікацію. [L01](../../l01/linux-native/PROJECT_STATE.md)

## DEV-02 · Development Environment v2

Робочий baseline beta 0.36.1, commit 11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b. DEV-02 змінює зовнішній toolchain. Команди df check, Linux QA tar.gz і user-level installer описано в [CLI_REFERENCE.md](CLI_REFERENCE.md). Історичні refs збираються через performance/portable/ з основного Git object database. Старі worktrees та archive inputs збережені. Відновлення спирається на Essential v1, L01, L02 і DEV-02 increment із Git bundle. Ubuntu build/run, Linux GUI і Windows Wine пройшли. Windows 11, WSL2 і WSLg відкладені до фізичної перевірки.

## Локальне очищення · 2026-11-26

Обсяг toolchain зменшено з 217.18 до 51.69 GiB. Історичні Wine-профілі й артефакти перенесено в перевірений локальний архів. Активний Windows toolchain, резервні копії та Git worktrees збережено. [Списки шляхів, результати й відновлення](../README.md)
