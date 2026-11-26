# Відновлення Windows toolchain на Ubuntu 26.04.1 LTS

> Історичний матеріал з `toolchain/backups/20261123-EoyiC0/RESTORE.md`. [Реєстр досліджень](../INDEX.md)

Скопіюй увесь цей каталог на інший фізичний диск або в приватне зовнішнє сховище. У каталозі копії виконай `sha256sum -c SHA256SUMS.txt`. Розпаковуй у новий порожній каталог і збережи структуру сусідніх каталогів. За замовчуванням `df-windows` очікує checkout у `/home/zagor/projects/port-drone`. На іншому шляху передай `build --source /шлях/до/port-drone`.

```bash
mkdir -p ~/projects/droneflames-toolchain
tar -I zstd -xf toolchain.tar.zst -C ~/projects/droneflames-toolchain
cd ~/projects/droneflames-toolchain
sha256sum -c RESTORED-SHA256SUMS.txt
./windows-dev/df-windows run --check --template patched
```

Потрібні Git, Python 3.12+, Bash, GNU coreutils, tar, zstd, unzip і, для локального запуску Windows EXE, Wine x64. Перевірено на Git 2.53.0, Python 3.14.4, zstd 1.5.7 і Wine 10.0. Офіційний editor і template збережено в `official-4.7.2/`. Наявні Release і QA EXE відновлюють Windows workflow без компіляції Godot. Після відновлення можна виконати `./windows-dev/df-windows build c91e0e6 --template patched` із чистим checkout. Збережений patched package доступний одразу. Нову official збірку створює `./windows-dev/df-windows build c91e0e6 --template official`.

Для майбутньої повторної компіляції Godot дивись `mingw-patched/README.md` і `BUILD_MANIFEST.json`. Окремо отримай офіційне дерево Godot на `ed1daf0bf001b61586d9930840f2f1394092c079` у `mingw-patched/godot/`. Встанови GCC/G++ 13 POSIX, MinGW headers і GNU binutils версій із маніфесту та SCons 4.10.1, наприклад `pipx install scons==4.10.1`. Після перевірки архівів розпакуй залежності.

```bash
cd mingw-patched
unzip -q deps/godot-angle-static-x86_64-gcc-13-release.zip -d deps/angle
unzip -q deps/accesskit-c-0.22.3.zip -d deps/accesskit
./build.sh preflight
```

Підтвердь preflight і fixtures для нового середовища перед збіркою та створенням свіжого `PREFLIGHT_PASS` за правилами `mingw-patched/README.md`. Для QA runtime додавай `disable_path_overrides=no` в окремій копії.

ZIP взяті з офіційних Godot release assets, точні URL і SHA256 в `dependency-pins.json`. AccessKit ZIP містить MIT, Apache-2.0 і Chromium notices. ANGLE ZIP збережено разом із ліцензіями pinned Godot fork `c7c2bb9a034bc6e31379a987fb2f461d31ec9362`, ANGLE `d8c00a9d42834118e90c3a8a7fb562bcf86a7145`, astc-encoder `573c475389bf51d16a5c3fc8348092e094e50e8f` і Chromium zlib `c2469fdd73f192383d2d94288da0ff5b9a3869f5`. Комплект призначений для приватного відновлення.
