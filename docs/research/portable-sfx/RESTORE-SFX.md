# Відновлення portable SFX

> Історичний матеріал з `toolchain/backups/20261123-EoyiC0/RESTORE-SFX.md`. [Реєстр досліджень](../INDEX.md)

Виконай `sha256sum -c SHA256SUMS.txt`, віднови основний архів за `RESTORE.md`, тоді розпакуй доповнення в той самий каталог. Доповнення оновлює два файли локального `windows-dev/` та відновлює SFX tooling, кандидат і QA-зведення.

```bash
tar -I zstd -xf portable-sfx.tar.zst -C ~/projects/droneflames-toolchain
cd ~/projects/droneflames-toolchain
sha256sum -c SFX-RESTORED-SHA256SUMS.txt
python3 portable-sfx/package_sfx.py verify portable-sfx/artifacts/ubuntu-20261123
./windows-dev/df-windows pack-sfx --out ./portable-sfx/artifacts/repacked
cmp portable-sfx/artifacts/ubuntu-20261123/DroneFlames.exe portable-sfx/artifacts/repacked/DroneFlames.exe
```

Для повторного пакування встанови MinGW GCC 13 POSIX і binutils версій із `portable-sfx/README.md`. Для відновлення вже готового SFX і перевірки його SHA256 вистачить основних інструментів Ubuntu. Первинний `RESTORED-SHA256SUMS.txt` звіряй до розпакування доповнення, оскільки `df-windows` та його README оновлено. Збережи обидва архіви та обидві інструкції разом із `SHA256SUMS.txt` у приватному зовнішньому сховищі.
