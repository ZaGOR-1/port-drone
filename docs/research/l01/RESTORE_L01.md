# Відновлення L01 після перевстановлення Ubuntu

> Історичний матеріал з `toolchain/linux-native/RESTORE_L01.md`. [Реєстр досліджень](../INDEX.md)

Зберігай цей архів поруч із Development Environment v1. Інкремент R03–R06 потрібен, якщо плануєш відтворювати кросплатформний replay. У L01 збережені pinned Linux ELF, п’ять Linux бібліотек, notices, backend, зміни df, документи, синтетичний тестовий save та QA-докази. Цей архів локальний.

1. Віднови Development Environment v1 у новий workspace. Для L01 потрібні Git, Python 3.12+, zstd, ldd і Linux графічні залежності. Гра читає незмінений PCK із перевіреного patched Windows QA package, що вже є в Essential v1. Для Linux build/run після відновлення інтернет і Wine не потрібні.
2. У каталозі цього інкремента перевір SHA256SUMS.txt. Використовуй новий порожній каталог для розпакування.

```bash
inc="/path/to/l01-backup"
fresh="$(mktemp -d)"
(cd "$inc" && sha256sum --check --strict SHA256SUMS.txt)
PYTHONDONTWRITEBYTECODE=1 python3 - "$inc" "$fresh" <<'PY'
from pathlib import Path
import sys
sys.path.insert(0, sys.argv[1])
from restore_v1 import extract
extract(Path(sys.argv[1]) / "linux-native-l01.tar.zst", Path(sys.argv[2]))
PY
```

3. Перенеси розпакований linux-native у відновлений droneflames-toolchain, якщо такого каталогу ще немає. Оновлені файли dev-environment у пакеті є overlay до Development Environment v1. Скопіюй їх поверх копії відновленого dev-environment після збереження своєї локальної конфігурації. Старі архіви лишаються окремо.
4. З відновленого workspace виконай:

```bash
df="droneflames-toolchain/dev-environment/scripts/df"
"$df" doctor --platform linux
"$df" build --platform linux --revision c91e0e6
"$df" run --platform linux --check
"$df" run --platform linux --headless --quit-after 15
```

Готовий PCK відтворюється з verified Windows EXE. Повний TPZ, ZIP і дублікати build stages, Wine/XDG profiles та caches в архів не входять. Архіви upstream можна одержати за посиланнями в L01 runtime manifest. Real saves, налаштування Steam і облікові дані лишаються окремими.

Для перенесення на USB скопіюй весь каталог інкремента L01 і після копіювання знову перевір SHA256SUMS.txt.
