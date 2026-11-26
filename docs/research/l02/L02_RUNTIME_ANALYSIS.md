# L02 · Linux runtime і df

> Історичний матеріал з `toolchain/l02.3ZzyV6/L02_RUNTIME_ANALYSIS.md`. [Реєстр досліджень](../INDEX.md)

**PARTIAL.** На Ubuntu 26.04.1 збірка, апаратний запуск і звичайне завершення пройшли. Локалізація джерела історичного mesh-попередження в грі залишається відкритою.

## L01 і базова ідентичність

- Підтверджено L01 package `c91e0e6a-e0iesw_1`, його маніфест і точні SHA256. L01 використовував official ELF та PCK, витягнутий із patched Windows EXE. Linux patched відсутній, `df doctor --profile patched` повертає BLOCKED.
- L02 зібрано з `11380ee014cae95c1bdc2367b0ee9a1b8cbfed7b`, актуальної `origin/beta`. Дерево гри `26dd6975cf20e987d4db703f1cabde4e85483cb0`, версія 0.36.1, `PROTO=7`, `SIM_REV=v036-integration-1`, `Save.FORMAT=1`. PCK Linux build, official Windows build і INT-01 побайтово однакові. SHA256 `80bb33afe001eeb8ef4ac4b1f42a94c667f47be0b59adb888afdbc5257f46d07`.
- Godot `4.7.2.stable.official.ed1daf0bf`, commit `ed1daf0bf001b61586d9930840f2f1394092c079`. Існуючі editor, ELF та release extensions використано за pin. ELF та три .so мають x86_64 ABI. GodotSteam v4.23.2-gde із сумісністю від Godot 4.4, WebRTC Native 1.2.2-stable від 4.3. `libsteam_api.so` знаходиться через `$ORIGIN` GodotSteam. WebRTC має `$ORIGIN` і штатні glibc залежності. `ldd` не показав нерозв’язаних залежностей, ядро завантажило обидві extensions. `df_device` відсутній у shared extension list. Linux пакет містить лише Linux бібліотеки й notices. Це локальний QA-пакет для цього Ubuntu.

## Що змінилося

- Чинний `df` тепер пакує точно вибраний Git ref через наявний `tools/packproj` у фізичній копії. Перевіряє pinned editor і Linux template, версію джерела, SHA256, права виконання та loader. Windows EXE для Linux build не потрібен. Кандидат має `repo=""`, а локальний запуск ізольований від реального user://.
- `latest-l02` оновлюється атомарно після верифікації пакета. Попередній покажчик L01 `latest` збережено. Чинні шляхи Linux assets стабільні. Detached worktrees L10N, INT-01 і PERF у Linux build не беруть участі.
- Linux `df run` і backend використовують exec і повертають код самого ELF. Доступні `--renderer`, `--display-driver`, `--profile-dir`. Стандартний режим X11/XWayland + Vulkan Mobile з успадкованим вибором GPU. Неіснуючі профілі створюються з mode 0700, файл замість каталогу обробляється з кодом 3.
- QA-архів містить ELF, PCK, три .so, запускач, README, ліцензії, runtime manifest, build provenance й SHA256. Розпакування та запуск із UTF-8 шляхів, що містять пробіли, підтверджені. Офіційний Windows df build/run --check пройшли. CLI unit tests 13/13.

```bash
DF=/home/zagor/projects/droneflames-toolchain/dev-environment/scripts/df
"$DF" doctor --platform linux
"$DF" build --platform linux --profile official --source /home/zagor/projects/port-drone --revision HEAD
"$DF" run --platform linux --profile official --check
"$DF" run --platform linux --profile official
```

У цій оболонці команда `df` без явного шляху вказує на GNU df. Для вибору XDG-профілю передай `--profile-dir "/шлях з пробілами"`. Для розпакованого архіву використовуй `Run-DroneFlames.sh` і `DF_LINUX_PROFILE_DIR`.

Виправлення належать зовнішньому toolchain. Ігровий worktree `/home/zagor/projects/port-drone-linux-l02` на `fix/linux-native-runtime` чистий і вказує на погоджену beta. Доказ правок у diff (`L02_TOOLCHAIN.patch`) та provenance (`L02_TOOLCHAIN_PROVENANCE.json`). Відновлення перевірено з копій за допомогою `patch -p1` та `chmod 755 linux-native/scripts/Run-DroneFlames.sh`. `BUILD_PROVENANCE.json`, `RUNTIME_MANIFEST.json` і `runtime-dependencies.log` поруч зі звітом.
