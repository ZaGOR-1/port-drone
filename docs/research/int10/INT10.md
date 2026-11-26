# INT-10 · R18B у beta 0.36.9

> Історичний матеріал з `toolchain/int10.GjFgeuwy/handoff/INT10.md`. [Реєстр досліджень](../INDEX.md)

[PR #18](https://github.com/ZaGOR-1/port-drone/pull/18) інтегровано merge commit `93bd6afdfb51b4dfb5c6d04e3339e37bbdbda035`, стара beta `117781083ff108c8353b9e53a3eda3d49bedd0fe`. Другий батько `803ca9ec5586596dc23b81a490bd68d866c9947e` додає лише 0.36.9, примітку ru/uk/en, version assertions та PROJECT_STATE. Production PoC `b33d49c` і звіт `800a251` звірено. Гілки та stash збережено, локальна beta чиста.

## Перевірки

- Початковий R18B CI та CI фінального кандидата пройшли. У фінальній діагностиці 50/50 тестів із Godot і 2476/2476 simulation checks. Локально build identity 3/3, release-policy 15/15, localization lint і примітка в PCK ru/uk/en. R18B GO, 330 покрокових зіставлень, R18 differential, Save/Load, ENet reconnect/resync і lifecycle перенесено за ідентичністю production diff. Performance виміри повторно не запускалися.
- R17 fixture на official PCK A/B пройшов 33/33 і побайтно відтворив попередні приймальні звіти. Типізований `Array[Unit]` зберігає початкові операції й усі assertions. Початковий збій був на A. [Відтворення](README.md).
- ENet admission 0.36.9/0.36.9 PASS. Змішані 0.36.8/0.36.9 відхилено в обох напрямках. PROTO 7, SIM_REV `v036-integration-1`, Save.FORMAT 1, 30 тіків/с.
- Official Windows x64 і Linux x86_64 PASS. Побайтова PCK identity в обох архівах і admission inputs. SHA256 PCK `23715df9cd87dc3d9e7e886afc27d05800f7888ccb4d39b793552f892a700556`. Native Linux і Wine smoke PASS. SHA256 архівів у `../packages/SHA256SUMS`.
- Фізичний Windows A/B, фізичні LAN і Steam — NOT RUN за рішенням власника. У щільному D2100 R18B одна контрольна пара дала +9,16% frame p95. В обох smoke 0.36.9 є відомі типи teardown-попереджень. CanvasItem RID 15 → 16, ObjectDB instances 234 → 236, resources in use 44 → 44 проти INT-09. Причину окремо не перевіряли.
- **NATIVE-01** зафіксовано у PROJECT_STATE як наступний напрям, ізольований Rust + GDExtension PoC. Статус — заплановано.

## Відновлення

`beta-0.36.8-to-0.36.9.increment.bundle` вимагає стару beta. Перевірено незалежний restore, fast-forward, tree, source version, clean status та `git fsck`. Докази в `../evidence/bundle-restore.log`.

CI PASS для [PR-кандидата](https://github.com/ZaGOR-1/port-drone/actions/runs/45653672698) і [merge-коміту beta](https://github.com/ZaGOR-1/port-drone/actions/runs/45654806564).
