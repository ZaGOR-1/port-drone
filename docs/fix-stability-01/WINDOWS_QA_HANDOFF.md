# FIX-STABILITY-01B — фізичний Windows QA

**Статус NOT RUN.** Використай один portable Windows x64 ZIP на обох ПК. Локальний пакет лежить у `~/projects/droneflames-archive/FIX-STABILITY-01B/windows-qa/DroneFlames-0.36.11-FIX-STABILITY-01B-Windows-x64.zip`. SHA256 ZIP `a30b0324fff1f12d2fdb88d7b1db005c7091988dfd87dea856d7b4628cfe0ba7`. SHA256 `DroneFlames.exe` `f3d830ca242f2d6813152e0471194be4bce5d593a2b92e5f36f46d7ca1914fab`. У комплекті три DLL, `QA-SHA256SUMS.txt` та `BUILD_PROVENANCE.json` із source `6c778b355b8a6c1e32a1c653c360f074cc356aa0`. Updater вимкнено launcher і порожнім `repo`. [Базовий план двох ПК](../codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md)

1. На обох ПК звір ZIP, EXE і три DLL за SHA256. Розпакуй комплект у свіжий каталог. Запусти `& .\Run-MultiplayerQA.ps1 -Mode Gui -Transport LAN -Peer host` або той самий launcher із `-Peer guest` на другому ПК. Для Steam повтори з `-Transport Steam` і окремими профілями `host-steam` та `guest-steam`.
2. Створи матч і дочекайся двох успішних checkpoint, які створюються кожні 600 turn. Звір лог `[Net] match saved at turn ...` та SHA256 primary і `.bak` у `mpqa-user/<peer>/Roaming/Godot/app_userdata/DroneFlames/`. Закрий вікно хоста, запусти з тим самим профілем, відкрий MP «Продовжити» й поверни guest. Запиши turn відновлення, повернення seat і результат команд обох учасників.
3. У тестовій копії host-профілю повтори відмову відкриття, заблокувавши `.tmp` на Windows через `FileShare.None`. Окремо заблокуй наявний `.bak` тим самим способом і дочекайся спроби ротації. Після кожної відмови звір попередній checkpoint за SHA256. Відпусти handle й дочекайся успішного запису. Тести точного повтору того самого turn наведено в Linux gate. Приклади команди для другого PowerShell і звільнення handle наведено нижче.
4. На зупиненому процесі, лише в копії тестового профілю, відклади старий `.bak` убік і перенеси валідний primary у `.bak`. Залиши довільний неповний `.tmp`. Запусти гру й виконай MP «Продовжити». Очікується відновлення turn із `.bak`. Продовж матч до нового вдалого checkpoint і підтвердь, що новий primary відкривається штатно.
5. Запиши PASS/FAIL/NOT RUN для кожного випадку з даними обох ПК, SHA256 і точним turn. Додай очищені від rejoin tokens, облікових даних та інших приватних полів логи launcher і результат JSON. [Перевірки та залишкові ризики](INTEGRATION_READINESS.md)

```powershell
# У другому PowerShell із кореня тестового комплекту.
$checkpoint = Join-Path $PWD 'mpqa-user\host\Roaming\Godot\app_userdata\DroneFlames\net_match.save'
$locked = [IO.File]::Open("$checkpoint.tmp", [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
# Для окремого тесту .bak використовуй "$checkpoint.bak" і FileMode.Open.
# Після підтвердження відмови.
$locked.Dispose()
```

## Публікація власником після погодження

Команди готують Draft PR до `beta` з поточною версією й відкритим QA. Виконай їх з наявного worktree `fix/mp-host-checkpoint` після звірки точного локального HEAD. Якщо remote повернув новий tip `beta` або однойменну гілку з іншою історією, спочатку звір diff і fast-forward.

```bash
cd "$HOME/projects/droneflames-worktrees/fix-stability-01"
git status --short --branch
git rev-parse HEAD
git remote get-url origin
git remote get-url --push origin
git ls-remote --heads origin beta fix/mp-host-checkpoint
git diff --check f152242 HEAD
git push --set-upstream origin HEAD:refs/heads/fix/mp-host-checkpoint
gh pr create --repo ZaGOR-1/port-drone --draft --base beta --head fix/mp-host-checkpoint \
  --title "fix(net): make host checkpoint publication recoverable" \
  --body-file docs/fix-stability-01/PR_SUMMARY.md
```

Після релевантного QA звір свіжий tip `beta`. У погодженому PATCH bump синхронізуй `game/pc/version.cfg`, `Menus.VERSION`, acceptance fixture CI та «Що нового». Перезбери й перевір новий packaged identity. `resume_host()` вимагає точного повного identity, тому старі MP host saves версії 0.36.11 отримають штатний version mismatch після bump. Зафіксуй цей перехід у release notes. [Versioning Policy](../VERSIONING_POLICY.md)
