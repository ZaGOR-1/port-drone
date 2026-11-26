# FIX-STABILITY-02B — фізичний Windows QA

**NOT RUN.** Комплект для QA зібрано з runtime `6ebedf4092f09959a97b75baf232827e10ea9274`, версія `0.36.11`. Використай `review-followup/windows-qa/DroneFlames-0.36.11-FIX-STABILITY-02B-Windows-x64.zip` з архіву `~/projects/droneflames-archive/FIX-STABILITY-02B/`. [Build and Release](../codex/verified/BUILD_RELEASE.md) · [Windows QA](../WINDOWS_QA.md)

- ZIP SHA256 `bc52122604ccf5123578459bb501ad1ad1bed027e8eff02067839154bdc05389`.
- EXE SHA256 `5f2a166dc767188eafdd1d8309e39a710ba610f4dd49e89f939ae77b86a11cd7`. У ZIP є `BUILD_PROVENANCE.json`, `QA-SHA256SUMS.txt` і launcher.
- Для профілів використовуй `sp-continue-42.save` та `sp-continue-77.save` з `review-followup/standalone/`, а для меню — `small.save` і `large-1.save`…`large-5.save` з `latency/`.

У PowerShell звір ZIP, а потім EXE й три DLL з маніфестом. Розпакуй комплект у свіжий каталог для кожного сценарію. До запуску розклади копії в `test-user\Roaming\Godot\app_userdata\DroneFlames\saves`. Launcher вимикає updater і вказує шлях профілю у `test-logs\gui-result.json`.

```powershell
Get-FileHash -Algorithm SHA256 .\DroneFlames-0.36.11-FIX-STABILITY-02B-Windows-x64.zip
# Далі з розпакованого каталогу.
Get-FileHash -Algorithm SHA256 -Path .\DroneFlames.exe, .\*.dll
& .\Run-DroneFlames.ps1 -Mode Gui
```

| Файли слота 1 | Що перевірити |
| --- | --- |
| `slot_1.save` зі snapshot 42 і `slot_1.save.tmp` зі snapshot 77 | Continue завантажує primary. |
| Лише `slot_1.save.tmp` зі snapshot 77 | Continue видимий. Saves показує зайнятий слот і дозволяє відновити його. Нова гра за замовчуванням бере слот 2. Ручний вибір слота 1 вимагає підтвердження заміни. |
| Обрізаний `slot_1.save` і лише один придатний `.bak` або `.tmp` | Continue відновлює єдину придатну копію. |
| Обрізаний primary, `.bak` зі snapshot 42 та `.tmp` зі snapshot 77 | Continue вибирає `.bak`. |
| Усі файли відсутні / обрізані; лише обрізаний `.tmp` | Continue прихований. Обрізаний `.tmp` показує пошкоджений слот. |
| Після відкриття меню видалити primary або замінити його другим snapshot | Натискання вибирає актуальну копію. Якщо файлів більше немає, гра повертається до меню зі штатним повідомленням. |

Запиши для кожного випадку видимість Continue, вибрану копію з рядка `[Save] loaded`, результат повторного завантаження і PASS/FAIL/NOT RUN. Порівняй наявність і SHA256 файлів до та після самого відкриття меню. Для випробування заміни під час роботи веди окремий хеш зразка після власної зміни. Збережи engine log і `gui-result.json`.

Для першого та повторного відкриття меню поклади `small.save` як `slot_1.save` або `large-N.save` як `slot_N.save` для п’яти слотів. Зафіксуй ОС, CPU/GPU і диск, стан профілю, час видимого очікування й оцінку першого відкриття з великими слотами. Локальний A/B дав +82,07 мс для цього першого відкриття. [Виміри й методика](INTEGRATION_READINESS.md#час-відкриття-меню)

Для MP використовуй handoff PR #27. Фізична перевірка суміщеного кандидата потребує його власної збірки та одного точного EXE/DLL комплекту для обох ПК. [PR #27](https://github.com/ZaGOR-1/port-drone/pull/27) · [Two-peer QA](../codex/verified/WINDOWS_TWO_PEER_QA_PLAN.md)

## Команди власнику після погодження

Звір фактичний HEAD, дерево `game/` і віддалені refs. Якщо tip `beta` або однойменна гілка змінилися, перевір актуальний diff і можливість fast-forward перед публікацією.

```bash
cd "$HOME/projects/droneflames-worktrees/fix-stability-02"
git status --short --branch
git rev-parse HEAD HEAD:game
test "$(git rev-parse HEAD:game)" = 8a140427aee1b1961b16edca467375f90d1727a9
git remote get-url origin
git remote get-url --push origin
git ls-remote --heads origin beta fix/sp-continue-recovery
git diff --check f152242 HEAD
git push --set-upstream origin HEAD:refs/heads/fix/sp-continue-recovery
gh pr create --repo ZaGOR-1/port-drone --draft --base beta --head fix/sp-continue-recovery \
  --title "fix(save): recover SP Continue from valid fallback copies" \
  --body-file docs/fix-stability-02/PR_SUMMARY.md
```
