# Резервна копія · що скопіювати на зовнішній SSD

> Історичний матеріал з `toolchain/dev-environment/docs/BACKUP_GUIDE.md`. [Реєстр досліджень](../INDEX.md)

Скопіюй **цілий новий каталог** `/home/zagor/projects/droneflames-toolchain/backups/20261123-dev-environment-v1.J78ugB`, разом з `SHA256SUMS.txt`, `BACKUP_INFO.md`, bootstrap і звітом. `essential.tar.zst` містить Git bundle, незакомічені R01/R02, сирі докази, snapshots і точні пакети Godot/SFX. `extended.tar.zst` містить Godot Git source на пінованому коміті, dependency ZIP, notices і додаткову контрольну Windows збірку. Скопіюй обидва для швидкого відновлення. Додатково перенеси цілий попередній каталог `~/projects/droneflames-toolchain/backups/20261123-EoyiC0` як незалежний історичний комплект.

| Архів | Байти | SHA256 |
| --- | ---: | --- |
| `essential.tar.zst` | 1,569,239,302 | `c1c14f444dc0ffa94a48ce7ec29e74e83cb914484578610ab4b07d8ff7e88768` |
| `extended.tar.zst` | 311,153,643 | `05f28cf32859761e318ee16cb9614e3eb4c323d302cc32b7a25803fdf439416a` |

```bash
# Заміни назву версійної папки і mount point на свої.
source="$HOME/projects/droneflames-toolchain/backups/20261123-dev-environment-v1.J78ugB"
target="/media/$USER/External SSD/DroneFlames/20261123-dev-environment-v1.J78ugB"
mkdir -p -- "$target"
rsync -rtv -- "$source/" "$target/"
(cd "$source" && sha256sum -c SHA256SUMS.txt)
(cd "$target" && sha256sum -c SHA256SUMS.txt)
cmp -- "$source/SHA256SUMS.txt" "$target/SHA256SUMS.txt"
```

Перед перевстановленням під'єднай SSD заново й повтори перевірку в каталозі копії. Скопіюй SHA256SUMS у своє довірене сховище для незалежної звірки. Архіви призначені для приватного зовнішнього сховища й можуть містити локальні шляхи у звітах. [Відновлення на Ubuntu](docs/RESTORE_UBUNTU.md)

## Що зберігається окремо

- SSH/GPG keys, пароль і recovery codes, Steam credentials, Codex auth, API tokens, cookie та PAT — у password manager або зашифрованому контейнері. За можливості перевидай токени і повтори логіни після відновлення. Перевір, що можеш відкрити контейнер на іншій машині. Recovery key тримай окремо.
- Приватні saves, settings та `account.bin` зберігай лише якщо хочеш перенести свій профіль. Закрий гру й зроби окрему зашифровану копію. QA архів включає згенеровані fixtures, без приватних Wine профілів.
- Наповни новий локальний Codex config зі збереженого шаблону MCP. Чутливі значення передавай через середовище з password manager. [Codex/MCP](CODEX_MCP.md)
- Величезні SCons objects, Wine prefixes, системні пакети, npm/Python caches і відкриті користувацькі дані виключені. Ubuntu restore з архівів працює після встановлення базових утиліт; повний bootstrap системи потребує документованих залежностей.
