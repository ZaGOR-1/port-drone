# R08 · Відтворення і докази

> Історичний матеріал з `toolchain/int05.qp8pp1c0/r08/README.md`. [Реєстр досліджень](../../INDEX.md)

У каталозі handoff виконай `sha256sum -c SHA256SUMS.txt`. Повні розміри та SHA256 QA-пакетів у `provenance/`. Збірки перевірено з SHA у `candidate-sha.txt`. Гілка Draft додає документацію поверх цього самого дерева гри. Наявний official runtime і залежності використовуються з DEV-02.

`python3 analyze-r08.py` відновлює покадровий і по-командний CSV та summary з восьми апаратних прогонів. `python3 verify-r08.py` перевіряє записані траси Late E і додаткові fixtures. Для GUI аудитів використовувався XWayland, Vulkan Mobile і RTX 4060 Laptop. У кожному каталозі прогону є лог фактичного renderer, вхідний стан камери, навантаження, список фонових процесів та GNU time. Файли telemetry містять CPU/GPU usage і температури.

## Новий прогін

Використовуй фізичну копію handoff зі свіжими вихідними каталогами. Вкажи `DF_R07_TOOLCHAIN` на DEV-02, `DF_R07_REPO` на чистий checkout з обома комітами, `DF_R07_RUNTIME` на official Linux package з ELF та addons.

```bash
R07_VERIFY=1 R07_SPANS=1 DF_R08_REVISION=690915646ec0186b5086cd254dcd6b8eab85f6c0 python3 prepare-r08.py A4
R07_VERIFY=1 R07_SPANS=1 DF_R08_REVISION="$(cat candidate-sha.txt)" python3 prepare-r08.py B4
DF_R06_TRACE=1 DF_R08_DETAIL=1 DF_R02_SPOT_AUDIT=1 DF_R02_SNAPSHOT=1 ./run.sh A4 audit-new-A h
DF_R06_TRACE=1 DF_R08_DETAIL=1 DF_R02_SPOT_AUDIT=1 DF_R02_SNAPSHOT=1 ./run.sh B4 audit-new-B h
python3 telemetry-r08.py A4 pair-new-A E
python3 telemetry-r08.py B4 pair-new-B E
```

Основний порядок A/B, B/A, A/B. Для контролю без масового пакета останній параметр telemetry — C. В аудиторських прогонах `DF_R08_DETAIL=1` додає лічильники повторних клітинок і safe_point. Для GUI вимірів використовуй типовий режим без цього прапорця, щоб не включати додаткові probe-витрати. `prepare-edge.py` і `run-edges-final.sh` окремо відтворюють command cases. Перед запуском edge runner у фізичній копії прибери лише попередні каталоги edge результатів або перейменуй їх. `reload-A.snapshot` та `reload-B.snapshot` є збереженими snapshot на 4800. Шлях `preload-*.snapshot` містить стан перед пакетом на 4692. Параметрами `DF_R08_EDGE=single` і `DF_R08_EDGE=repeat` вибираються незалежні контрольні випадки. Основна траса Late E використовує історичні команди без змін.

ENet fixture запускали проти PCK із QA-пакета двома процесами з окремими профілями. `python3 run-enet.py /absolute/path/DroneFlames.pck enet-new` відтворює lobby, turn progression, reconnect і resync.
