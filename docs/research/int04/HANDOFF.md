# INT-04 · R07 у beta 0.36.3

> Історичний матеріал з `toolchain/int04.l9g7ydNd/handoff/HANDOFF.md`. [Реєстр досліджень](../INDEX.md)

[PR #12](https://github.com/ZaGOR-1/port-drone/pull/12) інтегровано звичайним merge commit. Попередня beta `b2af27a67d503aa6587a82dc5255458fedf32e79`, нова beta `690915646ec0186b5086cd254dcd6b8eab85f6c0`, кандидат `fed3752bb5ba46ac54a73ec44ddae0d7f63514d3`, повне дерево `537cfa00ca103687f1c6df376325951a65f9cf2a`. Merge має кандидат другим батьком і зберігає R07. Version bump `ec1e824716a63eebf56a0cfa0a470ccb1f624f27`. Main `172df65e3bd004efed9a5444e90a284d9d69db10`. Release, теги і GitHub deployments відсутні. [CI до merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45464186972) · [CI після merge](https://github.com/ZaGOR-1/port-drone/actions/runs/45465164135)

Після fast-forward основний checkout `/home/zagor/projects/port-drone` має узгоджені HEAD, index і всі tracked файли. Локальну та віддалену `perf/watchdog-exit-search` видалено після перевіреного відновлення bundle. Worktree R07 лишено detached на історичному `721e846`, оскільки його шлях використовує runner. Stash `40a9f64` збережено без застосування.

Python 47/47 без SKIP, simulation 2476/2476, watchdog 101/101, build identity, L10N ru/uk/en, HUD/input, Save/Load і ENet loopback пройшли. Початковий discovery виявив залежність тесту «Що нового» від позиції категорії. Виправлений тест і повний повтор пройшли. ENet підтвердив точний допуск 0.36.3 і відмову змішаним 0.36.2↔0.36.3 в обох напрямках. Late E 150/150 ticks, snapshot continuation 66/66. Контрольні значення є в `evidence/replay-final.log`. Загальний FPS INCONCLUSIVE. Найдовший кадр 200,60 → 204,65 мс.

## QA-пакети

- `/home/zagor/projects/droneflames-toolchain/int04.l9g7ydNd/packages/DroneFlames-0.36.3-Windows-x64-QA.zip`
- `/home/zagor/projects/droneflames-toolchain/int04.l9g7ydNd/packages/DroneFlames-0.36.3-Linux-x86_64-QA.tar.gz`

Обидва зібрано з точного merge SHA на official Godot 4.7.2. EXE, ELF, DLL і SO перевірено. SHA256 спільного PCK `640d229ce572171875dca036f5103be254d098e266a1fe49a57ef31ac8d7ea20`. Розміри й SHA256 архівів у `provenance/`. Linux native і Wine headless пройшли. Фізичний Windows GUI і навантаження NOT RUN, відкладено власником. Physical LAN і Steam NOT RUN.

## Відновлення Git

Почни з чистої beta `b2af27a67d503aa6587a82dc5255458fedf32e79`, відновленої через DEV-02 та INT-03. З каталогу handoff виконай `sha256sum -c SHA256SUMS.txt`.

```bash
bundle='/absolute/path/to/handoff/beta-0.36.3.increment.bundle'
git bundle verify "$bundle"
git fetch "$bundle" refs/heads/beta:refs/remotes/int04/beta
git merge --ff-only refs/remotes/int04/beta
git rev-parse HEAD
python3 tools/build.py --print-version
```

Очікуваний HEAD `690915646ec0186b5086cd254dcd6b8eab85f6c0`, версія 0.36.3. В незалежному клоні перевірено SHA, дерево, індекс, байти файлів, fsck та ancestry кандидата. Для відновлення вершини робочої гілки створи локальну гілку на `fed3752bb5ba46ac54a73ec44ddae0d7f63514d3` після імпорту bundle. Runtime і QA-бінарники зберігаються в DEV-02 і QA-пакетах.

## Відкат через PR

Від актуальної origin/beta створи окрему гілку `revert/int04-r07` в окремому worktree. Виконай `git revert -m 1 690915646ec0186b5086cd254dcd6b8eab85f6c0`, перевір diff, version guard і R07 fixtures. Опублікуй reviewable revert PR до beta за погодженням. Відкат повертає зміни PR #12, включно з PATCH bump, якщо поточні зміни beta не потребують окремого узгодження версії.

## R08

[Контекст R08](r08/README.md) містить точний контрольний кадр 4693, чотири wire digests, історичні вимірювання 153,69–164,13 мс і відтворення з fixture та snapshot у `r07/`. Scope `NetSession._exec` включає вкладені обробники. Дослідження причини й зміни R08 відкладено.
