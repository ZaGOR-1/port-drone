# Пофайлове покриття аудиту

Дата: 2026-11-19; HEAD `af1b4c975564bac916db079d8470c2394d4920e5`. **881/881 tracked-файл інвентаризовано. 598 текстів проаналізовано автоматично повністю; 283 binaries — лише metadata. Ручне читання всіх текстів НЕ завершено.**

## Що означають статуси

- `FULL` — повний текст прочитано агентом (порожні рядки могли приховуватися у виводі). Це не доказ відсутності дефектів.
- `PARTIAL+AUTO` — прочитані лише зазначені діапазони, повний текст охоплено автоматичним аналізом.
- `AUTO` — весь UTF-8 текст пройшов структурний/лексичний аналіз, не ручний семантичний review. Для JSON/PO/import — повний відповідний data parse. **AUTO не означає FULL.**
- `METADATA` — binary: тип/розмір/SHA256/magic; без декомпіляції, перегляду кадрів чи runtime load.
- `SKIPPED/MISSING` не виявлено серед tracked paths; невиконані runtime checks зазначені окремо.

Автоматичний метод: читання всіх bytes і SHA256; UTF-8 decode (тільки `.import` відкидає кінцевий NUL у пам’яті); для кожного рядка індекс symbols/functions/calls, extends/signals, res:// і user://, RPC/await/thread/clock sites; AST.parse Python; JSON parse; PO literal parsing, duplicate keys; import/remap resolution; atlas bounds і tutorial filenames. Regex не є GDScript compiler/AST і не доводить повний control/data flow.

Кожний SHA256 прив’язує статус до точного вмісту. Перевіряти свіжість проти файлів, а не лише HEAD: робоче дерево могло змінитися без commit. Діапазони — 1-based.

## Усі tracked-файли

| Шлях | Статус | Ручні рядки | Bytes | SHA256 | Метод / причина |
|---|---|---|---:|---|---|
| `.github/workflows/build.yml` | FULL | 1–87 | 2525 | `05cb3ebb21c00e6b07be6a5c26cfe74949d6b5c7166bf23ca0f2e637c7975feb` | Manual full text + static analysis |
| `.gitignore` | FULL | 1–4 | 35 | `67e6778602c2d5ee2cc74169e8fd6782d8f1d67598f58f9cc5946fa5856eccac` | Manual full text + static analysis |
| `README.md` | FULL | 1–77 | 5053 | `9e7e62124a23f6c59afe6787739009e0df49d74458612a242f254c406c73f9b0` | Manual full text + static analysis |
| `docs/performance.md` | FULL | 1–59 | 5607 | `eb6c3199d4bb610da954e664147cfa965ee387f4be32f05a5c13c8b9dd556f1c` | Manual full text + static analysis |
| `game/.godot/exported/133200997/export-178df499c26bcd3357cc4c21fb1eaa2e-main.scn` | METADATA | — | 672 | `cbbea5cb74fd4bc16649f7b29d6c800d44fc82c6798934505a73d1de7196d2f7` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/extension_list.cfg` | AUTO | — | 100 | `ba50fdc97b6a8b8e2629d44623739c9c905353dd3968ad2170c01e8fe938dfeb` | Manual semantic remainder NEEDS INSPECTION |
| `game/.godot/global_script_class_cache.cfg` | AUTO | — | 20742 | `faac5cfe1869b750bcb4eb57316735b541feb2608036ecf11ff8403b14f2bae6` | Manual semantic remainder NEEDS INSPECTION |
| `game/.godot/imported/DFSymbols-Bold.ttf-91b47a1d5d67d6b57987018016496dc6.fontdata` | METADATA | — | 3455 | `e03da3752e12f5f9dbc97c058714a1dd3b77a8fc4e0c6da2d722bde26544dcc2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/PressStart2P-Regular.ttf-e20d5ff307f5ecfa1e9984f5c6184197.fontdata` | METADATA | — | 56281 | `9d1800ee8642bc5529d66193852e0487558db55d04dfbe0f58554a14f6c0a85e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/Rubik-Variable.ttf-0d6caa2cebc29bdfa43eba92e1157738.fontdata` | METADATA | — | 179617 | `c138c7b042bed3f216f12ff70dd3f3d3668daa7c64e80c6942e6d43dad1e4eff` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/RussoOne-Regular.ttf-6dfa1e4f3354d5ba40d0775191309a1f.fontdata` | METADATA | — | 23695 | `297b0b1bb4b218a34651aecab381700d22d78d920b24ba8501c6ba68ba7c4eb6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/aa_gun.ogg-979ec9bb496ed18ab5ef7f5ebe5c4961.oggvorbisstr` | METADATA | — | 15396 | `176cc56fcddd3e79a2cc9c604178e5863d3e44670ec9aa93022fb771e0783fc8` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/aid_sent.ogg-d9ba057004adcf43afd86a8e5da36ec0.oggvorbisstr` | METADATA | — | 17480 | `02580c3e9ab10e9ee52676c78bc92c9b901f0bc9d0da1cd025c436ea41b48adc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/air_rumble_loop.ogg-424951264ea12b9db46317a6e14508b5.oggvorbisstr` | METADATA | — | 53563 | `c2da1c88174e0b71af17a89dda9a25f785a955d389b3f3ef88cd95338e69148b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/alarm_general_quarters.ogg-53b2059bee6576e63f5eb19ebbf3718b.oggvorbisstr` | METADATA | — | 29696 | `d32188f1a2913e50b25bae4e7edb2602fd57c23924c731b324d73f7d972c3c69` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ambient_battle_loop.ogg-7335a36194a955a3b75be872ab496ce2.oggvorbisstr` | METADATA | — | 116252 | `d044538dab393f4487c68c4d10b29d6f274f2ffa02e0638a75ca5810c6da2233` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ambient_wind_loop.ogg-d6901d9168d3218ffa9033ddcd576db8.oggvorbisstr` | METADATA | — | 147512 | `aa0e6743adb3267a0aaa74a76221a2fb3013530526dc10cb1e6e8d0775a3db52` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/artillery_far.ogg-f008ecb3f228a83ebf174e7dfbcf8e76.oggvorbisstr` | METADATA | — | 17896 | `f908458038e22e74ff627d38ac620b70680b28d7655d3db71e41e06d787863d1` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/artillery_fire.ogg-3677631adfe723b2485907b4110e30c5.oggvorbisstr` | METADATA | — | 16448 | `201b2e208725ba5c75922d82dbc05c2f3504215f4dd0a9b07d8aed30eebc50a9` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/asm_flyby.ogg-e0b9f619732fe836826b844c4c75012a.oggvorbisstr` | METADATA | — | 20992 | `2e42ecf45318724de3c19569e4e8d2ec123b4d31ed908da46241cff755d18d72` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/asm_launch.ogg-7c474f46f3f9d139f30b0c952a9cfef5.oggvorbisstr` | METADATA | — | 23404 | `1933f619af7cdad76ad1857a283a58909470a2c170b9dc574fa852a4e9369899` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atgm_hit.ogg-29aaf7b284fb5a9495cf316f9832efad.oggvorbisstr` | METADATA | — | 15820 | `55d44704185481d96ec5cd547ab63ce0476710b7615243b172cee53b0f0d43ea` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atgm_launch.ogg-8175950692153ad889cc74f6cccb737c.oggvorbisstr` | METADATA | — | 19104 | `2c57252ad706612e2f2f933159387bb486f1e99e6a9be180d83a8b71715c5447` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_acc1.png-ede1a6e1514174cf3a539e23beac8337.ctex` | METADATA | — | 854 | `7313bf4ac28ed9462bf204e01a95698a727f7ab6017893eed28a25683ed02514` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_air316.png-9ed98be72566bfeacc129b339146c9bf.ctex` | METADATA | — | 8144 | `7b3073d71ecd575a4255f02ae5a90f3dfa66d233c8fb805104bb1a954a750a8a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ally320.png-1302d6f1b182d815603c10e78835140a.ctex` | METADATA | — | 782 | `c4700d80ff1a8b064db62bdf4e922b6da5902c887d76438564784a8b4d218f5c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_cm28.png-47c7dfa39cb4018e44a323d0064ce223.ctex` | METADATA | — | 1128 | `70ab9c10ce3276044bb4666630644c27c3625fa90bfff3a12148828692415ff3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_cosm_bn.png-5f154ec8c621b4cfa884e694b3adcc62.ctex` | METADATA | — | 10942 | `f14b83e9d1e54b3059b61dcfb4e1c83577559f6c95eb8948ae5389693081695a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_cosm_bn_anim.png-aaa87720d4cf11525a45aa49cdd33dc0.ctex` | METADATA | — | 24112 | `0b7a4bcd8e158246fad35752251d42b0db818175c00df9012d079a39ea27a418` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_cosm_fr.png-909914ebc0d3e03a417075cf262b74cb.ctex` | METADATA | — | 5170 | `ae57d6d1366a43e8cdb8efd926bb7729d5f086889f1ba3c800d38cd469903cd3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_cosm_tt.png-918ebb0cdb0d9e506f42a9ab0254f7b1.ctex` | METADATA | — | 1514 | `afaf80bc480ae88881bdac504a4286a47beedaccf91c525debf2953be776e596` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_debris314.png-f77a8b1c182f302bfbc4d10d0974db83.ctex` | METADATA | — | 1158 | `a5b06373b6555730e5c7ce464833b8a60c43c11842790741cbd9d252509526b8` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dip26.png-a50fac87e56b311ff246146fea79998a.ctex` | METADATA | — | 2452 | `27fc2aae0ed95819098bba68566d592377861789e60a85c34abd1db6e5b2559e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dip331.png-e705254f6db27ef8aad57bb08f67e44d.ctex` | METADATA | — | 3590 | `4f74f2a6cf2770231930c1b406bd19223e41d543ad8e420627db746032b35f6a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dmg314_asia.png-cbef536cc657ebad2babef8eea330771.ctex` | METADATA | — | 39060 | `65fc6707762506d1cde4605b0a32d94bb747aba0089b7d1a2595fee30f2cf38e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dmg314_clad.png-646bb4b36d84acafa907caf711e8561a.ctex` | METADATA | — | 105652 | `b146f053c54563eb07a858a882a4c50a33fdabd0288769a7e741d32bb652e9f2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dmg314_east.png-5d04a7084a5c5990c01e3fcb7a285627.ctex` | METADATA | — | 37012 | `45aead6c52db4b62f092d9e5ede1911d276a9ee3702b04823a36893859bfc988` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dmg314_usa.png-1990bd0a32400b4464936aacbe76c8cc.ctex` | METADATA | — | 36742 | `23b892e4f4f94808697029b25c52ceb3cd9ed4ea025fd75f164c3e5bebbca318` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_dmg314_west.png-ddeee37a6591ca874179766961f62d8e.ctex` | METADATA | — | 38450 | `f221a3357f96701bb31a2235882c2a12c62a40bd22836ca3f8e33a04d76d84d3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fauna319.png-6ab845f9f3e93634fc962092c4169ce8.ctex` | METADATA | — | 2464 | `2a3ba984dc3daf8ed0b1c9a3316e49da0061a351b8aa23bdafcf96a0aaca833a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_flora.png-44590681b9f06708df2ebb963db27864.ctex` | METADATA | — | 2104 | `f5fc3bbb950bf988b277d729c99a853dee59b9d7d09a477c39de4b06294c51ed` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fui_crane.png-d8a3e033bb0201c45adcac9913776cb3.ctex` | METADATA | — | 6888 | `58416d9d6901b03e6e253005d907b41656df07e6de22f1e5b49f7feb44af2a87` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx.png-819514f57dd8259668e1c932f9b9f402.ctex` | METADATA | — | 3270 | `85d82f4f5d3021f6ef4294a241e6b22af55898faa5148523fa21c5a0f315720c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx2.png-030e7c49319a8ebfef772854c86894e1.ctex` | METADATA | — | 17338 | `20b292a14f32915c71bff795e1cc9e7a7484f129f344fbb0be74f5f8b64faa4f` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx3.png-8209f2dc7c5cd7d77177c23d4d41b9ee.ctex` | METADATA | — | 6412 | `32d1c789f0e5a283812c61af1d93c16f4f0c397b1e84e61d298312791d9ffc83` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx314.png-0850251a5d61a31bc066169340952de6.ctex` | METADATA | — | 36434 | `b69f9d43495c8f42b91286ea84b105f4bbac1bdd394decedbdacf2c0fe353c27` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx4.png-56dcbbb6162c2f4691e330303633d547.ctex` | METADATA | — | 5692 | `3ba7364fe51384c4c331cb9eecd4b8a9c1835b19102b3917865d1118ded309f4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx5.png-ab80c3c54867cbcdca59a1f459942d70.ctex` | METADATA | — | 2064 | `f92591088d55975837d2ed68fa097fca8d7da25db6e93d1692c88a3ccbf5746e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx6.png-af9a6d63df27444126b5bed79265fc42.ctex` | METADATA | — | 3068 | `7e842416714f02495b562d06d3604d76eea8f4e12cc40e3c8b59e00110d6a5c4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx8.png-ea3a88f9e0e4a229c44b0ddf072c5897.ctex` | METADATA | — | 2270 | `d44ad0ab2b229f3f551eeb3a10753d308e2c0b64fe06ddd1f58bd3b0da5d12ca` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_fx_navy.png-b69661dc71906a4b5e22d5e7481c7ef0.ctex` | METADATA | — | 11322 | `19184e4c581ec84a688672e72612867c6cd3c6cc4dcf040b3bdaadb650e9fdf9` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_kpp30.png-a93ed7adf22bcc765977a49664884bf6.ctex` | METADATA | — | 20470 | `305aa17b2821956870ee586417de55a2e9ba841a5508deed7f5014fba5b8f560` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_life.png-be1c8179f2407e74a591079374e5691b.ctex` | METADATA | — | 1802 | `2f25124f1941ba8ea072e9542136e5379f066cfacfb514fc5d06488c22efa95e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_mines27.png-3c3f7220e0081082e2bf4bbd6db34525.ctex` | METADATA | — | 5082 | `a4426b2382a6b05422d994c913c390d3a18d308198af8c6a774a85f597f264cd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_navy1.png-6942b2ea2bca67263a49c1f9673dd50f.ctex` | METADATA | — | 67422 | `9c93e78b4ce47ab982b922d7ac66813bef6bada4fc03e9d22d927dd2a21ff602` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_navy30.png-5a6d379c4a2fa44adb2b34636c06839d.ctex` | METADATA | — | 1398 | `e4d4875c32f9004bf78545065b2977e01d4f25f4121014c01130a79482f5e14d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_net29.png-602e13593f844eefb89fb81a07874089.ctex` | METADATA | — | 1902 | `82f14396e6d66d011401c2b04d640efe3782cf93ebb1b34bd88543d2e2964eee` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_rail332.png-8133da3a4a152066997669b30f7f2d57.ctex` | METADATA | — | 6904 | `e3108bcd1cfa7fd3fae35b4bb5eed987a9ae71494b11109f6816db29db7d876d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_style_asia.png-f071150dda9cb8a67e55eb3ccdd70c16.ctex` | METADATA | — | 10884 | `651489930fd44d6f8bc9a5157846100e28b8d3c017a6492492b01911b5d7edcb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_style_clad.png-02d262fb88c03c404f684a2add209125.ctex` | METADATA | — | 18266 | `9949b11750bcfb35831987a6fecfaf05769dec99d508399063b6e3ced2c54bba` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_style_usa.png-53ea159b1f195745e32466eaece00aae.ctex` | METADATA | — | 10984 | `80beac6d9600d6f03808ca5289c64f5b8a0e5acabea6858fcf9660e0bd651e01` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_style_west.png-0271c47ef0872c4e1df670a7764f0ccd.ctex` | METADATA | — | 11070 | `8172b8141f5e173bab974ab851666d22a0b55c22b1ed753e4fd9ca2b00419833` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui.png-6dfca041ca9271bd9d995742ef8a3e13.ctex` | METADATA | — | 2288 | `3cd65d6e361f293b2749e417a32871d91f414f32c30a97e6cb034b26388a3dd6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui10.png-438b2dcdca153becb54d5ed67090043c.ctex` | METADATA | — | 1914 | `21d81fd70dc5d1c4520640c03f19954bb689653438ae480ea91c98e6564aa1a3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui11.png-ac8b586f6644547daeaf098fbef049f4.ctex` | METADATA | — | 1224 | `73e763edf18d2245dbc942ca3f7f56567ebb7c2680b4894b2e42039631db47d4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui12.png-c41e95a98ce3701c123404f8143d9afa.ctex` | METADATA | — | 270 | `74636e8963193a6cb51afbb24407b8054dc78991859ee5d12e968f1d9d09367a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui13.png-f0c1a88d637fbe501391c31b0a963dfe.ctex` | METADATA | — | 508 | `0df8b3f4184548b7826b2d81bb845fd7ba5fb1534895842849942ffb8c3a68c2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui14.png-42c9942c7f020926c23898d5a765e042.ctex` | METADATA | — | 894 | `2a573f98542d1a2719c3cdc75075f5ab5378773363b9a0a0f5450d9eff819e76` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui15.png-de359818c26a3c651dbb34706cf12844.ctex` | METADATA | — | 2008 | `a2ca462410ed034f275bfb07aae5a43ed8382703eca856205949d7f247bcbeec` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui16.png-c4541e381ec13232832ff6a0920c595a.ctex` | METADATA | — | 1192 | `0fc5357b9bf0a46fe1da8f56ffc9d77657a47457c367a9b17b91763f39391c87` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui17.png-ef7fce5f352ee7fbccc263bc7e25dcf4.ctex` | METADATA | — | 500 | `43b44de39901fdd4504de0459f5066d5613b7acfcb745c4f8c396c64880a7290` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui18.png-8acd448677491a3c7b8599a4bd3e6bf2.ctex` | METADATA | — | 352 | `99f98094a930107d743253f766eb1a06cfa38e8146c40448b919ab65d4cfaabd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui19.png-f3a82508edccf8befa4178179e276dbf.ctex` | METADATA | — | 4246 | `0c66f58de5ccbf3109ba72c175df6e02a86aadfe0a3b5292cc19f4bc5c788ff0` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui2.png-3318ef99b1a78d5e4912043e779d1091.ctex` | METADATA | — | 1694 | `d88920a8875897e3a9812a06a7f3f676eab2ce2a4345f98ad32e41adaf6518bc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui20.png-0e129bba3f42611415b8ff57b882c402.ctex` | METADATA | — | 4972 | `0e8ba669c9fe6cf82917c1d1cd1605ac6b287606dfc49184b81712ebb61e6fbb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui3.png-0136db1f3d6a82fbdc8ad97d7aa250dc.ctex` | METADATA | — | 1060 | `cbef7933fa59908164afa343838795be31581d8f5cb81b5c9c05f0d293b8ac97` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui316.png-80e52c1a7adc3812bacbfdfcc6a97a35.ctex` | METADATA | — | 330 | `aac4a490b952180e351f3cdd326c2f61348cc2ec3d2030f116146a7ea94cf752` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui319.png-e0344b8f726930049abecac7998c2f5a.ctex` | METADATA | — | 1488 | `bf54f6da30c1aff1d4e54c6bfc57d4e781fec0e9cc142595b0c3e335837aa418` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui335.png-59ed26dde6b7a373e9bda86e7a9e61f8.ctex` | METADATA | — | 536 | `2b2b317584dd271280637c6a177dc2328d67290ba0e7f6bce10b52925c3fffd6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui4.png-bd82b030d49c933fe08f8361440bd304.ctex` | METADATA | — | 1770 | `fef908b8da2cac2e7a0634cd09d9f346fed4577b2469adce25bad2682448c223` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui5.png-10cfa6f1414004b408ef3d508c470055.ctex` | METADATA | — | 1534 | `2891f4bb347280097816f8234eb990fdb2686c2fd794be678caa1d2e01ce90cb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui6.png-ebb15e02d2ec9f496c6d168d83f77945.ctex` | METADATA | — | 1872 | `f489294a73ff5dbcee3dc5141184ca8ada8ca3ee22036962bc16c04c82bdd774` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui7.png-8168a5fc546ff29bf309688754a9e1f9.ctex` | METADATA | — | 2378 | `2c7ceacb3adf7e13e7ae8c8f81051dd961a49be399b7eacdb6b60b0dd6633288` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui8.png-02f75c90c544446b9c1b23b9f4913137.ctex` | METADATA | — | 814 | `12cb2a840a9e4ec588b143923eea3028e4d21e5dcdd5c13d10705337947204a0` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_ui9.png-29f955d552b93202a22ca2deb3dd1c37.ctex` | METADATA | — | 7008 | `31a9154913e90c289fc7da62f16dacc7151888b87f28fd02c8f650fb2f1e8e28` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_units314.png-b4b70d33422c73a8511839a8ada97dca.ctex` | METADATA | — | 53362 | `e08acb54b8a30a65e6636f4128b6d2a8e342ed149208936dc6534d6c64142ab0` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_uran30.png-ddc5b4b00c12199cc0116efeb462e75d.ctex` | METADATA | — | 10782 | `d022f57174eff9f36f18557e44564006df8a90fd9c720a895da03479097be073` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_uran30ui.png-2ed0b9d32612d87a58db8368e78a7e76.ctex` | METADATA | — | 548 | `1112d692d74cf9469c5f0d46a19950aeba20cf91278a8d4f1b93bf7dcc5b263e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_vfx19.png-35840159397420d1919457ae12903f15.ctex` | METADATA | — | 2420 | `5376782bef45c7ae6685869c7259cb609156d3b3f45815e0502ba7d69167574f` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world.png-8985d8936bd17bce3a76f5ae7d597742.ctex` | METADATA | — | 6562 | `f3f093d34f340bb3eb7141dbda1a7daf2af1024e0fbc7bc7dc6907cb85e1cf49` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world10.png-f39cd13b2414a7b3a56f94fce0507e24.ctex` | METADATA | — | 5732 | `def6012df535cdeb4d8b2f28e835245076dd7e3c19ab350921134f2838954651` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world11.png-b43c3255ccbdcc6f040c191d3ad2c010.ctex` | METADATA | — | 7932 | `5e1b1a429de6f081186b544797369f697571baaade17e45638f1b905ec7c1c8c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world12.png-6699771229e9ae1985fc2f4f65023d57.ctex` | METADATA | — | 1380 | `874aa980a46463288a6372e1ccc0cad1530b33dda370071fc27f382cee491c4b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world13.png-fc9826388ee258af378e411e214ad9dd.ctex` | METADATA | — | 1528 | `0808bd7c22b667923067abadd8e94cfb62f0a3e69d131dea5ba52614f0a2ac5c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world2.png-c57956e995856b9309b6ccf3f0f59c6e.ctex` | METADATA | — | 6404 | `d54fe3ff6d912a16bbe0f90735ff1b3ee7a892ba610629a0948cb398d2149b0e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world3.png-4593f983832e51bda3576cf00fede955.ctex` | METADATA | — | 5346 | `46f39c158a8b483866519e905dfc879a69e798be742f04a38e5de13b4ff12029` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world4.png-4b4292fcba303dfbad7f1d41276737b5.ctex` | METADATA | — | 1400 | `e72ccde4ed10df9cfc2ddd5d605ea60d3c2c704f3386adcd3b7e522efc18b65a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world5.png-c20c86f9f6a66e5d789bbde5976c7292.ctex` | METADATA | — | 12248 | `0bae00f9fdd6f9511e02ac75170ca3130d25ee4b0a0c0f013d1abbb1650454fc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world6.png-fa97eccff5d849534f1bd0489f0fe192.ctex` | METADATA | — | 6698 | `403efede0e638994a4fb779ae1d4320cf93e9d79978d3f8afb6969138abeca90` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world7.png-6622e18981486e9da3204372015703bd.ctex` | METADATA | — | 5508 | `27944f71834c065a2c512c3cd0ad33a4f4d31822e15b83c2bae5a7e0346898fd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world8.png-d6ecf50c54cccb75174aeeed2e56bbec.ctex` | METADATA | — | 1974 | `2e16222653e0e31e75d5c831ed9a857e7e233ab342afb2af27d0d6ea90bf7a3c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/atlas_world9.png-23a93f80f98e625fbe54ca84dcd2ad56.ctex` | METADATA | — | 9902 | `76c785d9c9fa4671ad5171fd015b522fd683d67e4add37ef368fed263a38a78e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/attack_jet_loop.ogg-30c46f7db2e9f84681ae06dbf4ddfda1.oggvorbisstr` | METADATA | — | 52499 | `9ed218ee9fd8f785d3ec9298485903ecc486c24fe8ea010cc3ef6b4709f3fcde` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/battle_close_loop.ogg-bd7537cc2d28f3a6a84ae786d873882f.oggvorbisstr` | METADATA | — | 203124 | `667d76dd843cb54246376c0c14b362c1063894208ca52c69e5233f335f5ec6b2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/birds_day_loop.ogg-2096460e32809c63edbf5a8b6398c7d1.oggvorbisstr` | METADATA | — | 191380 | `dec9a05e6d801c1862177bec6df0bd91d0601acc1538c2683316469edf7ac4fc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/bomber_loop.ogg-dde7ffc5c88527479408d0015203e101.oggvorbisstr` | METADATA | — | 40503 | `3fda1c411bb2928bf239ea2d8eb5498a792aab80f977d7dba00ef7be35392935` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/bomber_pass.ogg-608c1ab740402e170fa00bbb08bd934a.oggvorbisstr` | METADATA | — | 43639 | `c03ba1d79aba11cd0a6384ab43752e34e2c371b3c83de56d0608fdf113510950` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/bow_wash_loop.ogg-88b4de4d15f02bc1ebcbf220f4881e94.oggvorbisstr` | METADATA | — | 54040 | `f4f614acc75d1b48b444cd59af4eb5c7a561c4c9420ebb6fe46ad07ea7fca395` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/building_collapse.ogg-6374e77fcc6127713610ce06d17adce1.oggvorbisstr` | METADATA | — | 34840 | `976003707805cb6ebf9321c0de2aacdce3c2558b0c46a6588b77de5084a9dbfc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/call_to_arms.ogg-3a1411196c47a845e2f7f9ee5e7fa03f.oggvorbisstr` | METADATA | — | 24068 | `ff06df38dedb8fd00174544924d77749fe947d40b7579301c7917378f948311e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/cannonade_loop.ogg-110a7c26c76ae9fbd49931d53da3324d.oggvorbisstr` | METADATA | — | 233612 | `0b64332df6b1ae731b6abd41f0a55fd1a3fe2238f98096b435fa88b85b7e996d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/chaff_burst.ogg-52cd1a58d519e29df0abedb1297a330d.oggvorbisstr` | METADATA | — | 10592 | `050dd1b8f26863a1993f913b607620e83c30a1b0103ca11285ffcbc5facf0e15` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ciws_burst.ogg-fd7ca7f3ab9c6f3ec32e054dee20b790.oggvorbisstr` | METADATA | — | 13256 | `f860b821b94e79b4f56dccae3f034fea5aab9a64dc6f016f1da6e6c78d1e4577` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/concrete_thud.ogg-2e020a9659a616b329745549811b1ff0.oggvorbisstr` | METADATA | — | 16944 | `3ec8cd6a20de67522ce50857eeade2036ab700b424f0aa4e0db490a7133a9742` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/conference_gong.ogg-95468d0e96ada9496cbb7106bbe7a0d7.oggvorbisstr` | METADATA | — | 32596 | `20bdbdf11b163b7ae2440febf9c3599d94b618b14d5914017f2b07d23da8d26c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/container_clank.ogg-1bdaba9a2b84478b9f8d3329491210ba.oggvorbisstr` | METADATA | — | 14624 | `8837ed348da8155bb8063f6fa9ee5d1f88e3c96aa2a18379291cc341224bc497` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/convoy_horn.ogg-e19a913a325621350faa1ebdbe1cf319.oggvorbisstr` | METADATA | — | 23436 | `db4a407e056b9dfe9b76353805dfec76a9f815a435fb1cb9d2ddf50c0a6eef69` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/crickets_night_loop.ogg-758c3a5322ac46595752b39ced92ba2d.oggvorbisstr` | METADATA | — | 196572 | `fbe134b722b7abf34a3a533b1b0e6096338397bb4322d053976ace4161c52aff` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/cruise_launch_vls.ogg-c463b9127c69ebdd75c40ab40dc9f25f.oggvorbisstr` | METADATA | — | 25728 | `7df3f4945d4cbbf40ab5ee443ba1e142e05a92c1ee859055bec404e00de28e89` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/cruise_missile_loop.ogg-6855a1d8b1d1a22ef863eecb12846734.oggvorbisstr` | METADATA | — | 44043 | `69d1e781d506112ceda76073941581c86845bc13e8c9aa4d4c6af4c662c9cf8f` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/cruise_missile_pass.ogg-6851c44bc2fd92b075344abd9042acfa.oggvorbisstr` | METADATA | — | 24891 | `eec9ed27426a2772c9c1eb2f824b594b1a2f5b35468a5f07d414f893fc1bdf63` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/decoy_flares.ogg-f8a2bded91d9a9db2891c3fbeb3086e9.oggvorbisstr` | METADATA | — | 18780 | `ab0f31e34973f0914f9efa5b2a452971f0201373718ca96e4ef0c690ec3e529a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/det28_navyfx.png-edb9768bcbec9c36d8e51467f140177a.ctex` | METADATA | — | 2130 | `81147a1184daab455a82f343c9d85d2a85b5bcc3784047332fef301a9c589102` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/det30_fx.png-48ca5c21bc8cc1c9b701e130a52f4bcc.ctex` | METADATA | — | 4090 | `4d6f2de6d6106464e53ad9a47c2bc49dcb3adad0b9957703399457e20776308e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/dig_trench.ogg-7e4695f16009d2b4a4227ddb266ead95.oggvorbisstr` | METADATA | — | 22864 | `63cc7af5c5d9baa0b8155e540634dd4ad2ff78d1c5dec8102f208ed37feeedde` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/dock_crane.ogg-f2b0e01db6272af472e9ac322cfed15c.oggvorbisstr` | METADATA | — | 25020 | `69db0bac2563817afebfa16b55d8cd74eb136e8fde84bb70c87bc99d376fc49c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/drone_buzz_loop.ogg-25125dd10bcb335f9aaf784d9aae2379.oggvorbisstr` | METADATA | — | 36292 | `5609e8950cc0e05be845691ad6a219ca69dde06249e6faf88f56beec4c9025e4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/drone_launch.ogg-8841ac61f74cce4dc9c2de23b6b0e480.oggvorbisstr` | METADATA | — | 22228 | `20f3a125f49dc2c771ec81b66a9b5ec29a50c7799fa4cda180c053c5f8c2da38` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ew_hum.ogg-29b202c4de2d543c9d1c6369dc8dc25d.oggvorbisstr` | METADATA | — | 36220 | `0511ec13af3ed565647edcbd4515639c4880edceec8a231ab3725c45c6080e79` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/expl_big_1.ogg-506f5b8797ba49cbed34ece3aa7ce853.oggvorbisstr` | METADATA | — | 20004 | `53a3293a4ffc5fc89fe8986cbde4d5c6213ae510a0245777320a4896b1fef577` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/expl_big_2.ogg-e4df3dc25545fe89661de721f8170cc3.oggvorbisstr` | METADATA | — | 21852 | `3976b8cea989e7066c35ad004fd74c866dc016129b8d19cea19a984200e71652` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/expl_far.ogg-1de376c01090977e81b467c638d4e95a.oggvorbisstr` | METADATA | — | 20768 | `fc59e253cfd72d8359f52a6bdbea49628b0aa9435b0d0bd297af48e75f110754` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/expl_small_1.ogg-181d8e64eeef2ed6018cc8c0ec1a4dfe.oggvorbisstr` | METADATA | — | 14728 | `028905a0185c6c084f4f7676cbe1b308e2a15948b86d634ed098513db9384dad` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/expl_small_2.ogg-c584048f718bf20af34decfbc9ff3869.oggvorbisstr` | METADATA | — | 14480 | `56fecbc11d394b8ab2f4841ac006859a5e698dcd4684256076cf888ce8c68b06` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/far_boom_1.ogg-4e7289cbbd8f6a78edd2cbd747f071bf.oggvorbisstr` | METADATA | — | 51612 | `602c7ce7239f2c78519032878ed266ae95973b3fa4abf361ed7afd830f805164` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/far_boom_2.ogg-958338f2829bb5bd4dc83c354030b450.oggvorbisstr` | METADATA | — | 49012 | `b5767a28f748f0c0735df944c8e4658f405aa85feb6387dff6bf5acbbf1ccee4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/far_boom_3.ogg-3449ea9280586763f56068831edf76e9.oggvorbisstr` | METADATA | — | 55248 | `b899625602ef79ff18e2e607e9a7bbd989a24cf9cbf873362527657ec30f75b4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/fire_loop.ogg-5a28f6709770d664b075b089cf668824.oggvorbisstr` | METADATA | — | 46592 | `832ea189fd53c515f4f66a1b9bbb729b6ab4f9af6b0011a39bb3ab68f6d156d8` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/fpv_buzz.ogg-296b802a4a89af4dd8b05ea887265330.oggvorbisstr` | METADATA | — | 19796 | `df8f37525ee21479dfed6281a05b90b351df0bff8a585e62d59b2a3e76093ebd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/game.mp3-e615eede3e79fe2ec9ad254dc83d4aff.mp3str` | METADATA | — | 1840655 | `0c664897d79c47d3455c729081638b52a2d7fe5d7937095c390d3c3a53daadf7` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/grenade.ogg-207b5d1b33d4d23636ddbf1759bdead8.oggvorbisstr` | METADATA | — | 13888 | `2959c9b78cead98b3d3c9fa7010af1cfb457ac81f37925f0c2380f2c12f29fe4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/heli_loop.ogg-882cba32d028882e752ee2d97aef07da.oggvorbisstr` | METADATA | — | 52844 | `a6a543add6a6fbc9f4f6507517ead18f9c46db60b7ccdc9604606b5a787ed12d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/hyper_launch.ogg-8c16c5abe1aa4dc6782d6823e9f2d1de.oggvorbisstr` | METADATA | — | 26956 | `f9dd89bef15baebde44337cc60bc32dbc41b7bf84960078e85b1f6649ed44a24` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex` | METADATA | — | 3426 | `5065348df8b1d7fa8484298b54140bd0cdae1c53b35a8bca37f7ffde71b45d2b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/icon_ios.png-b700ae5f5836fae99942ab596dc691de.ctex` | METADATA | — | 588 | `7e39d8a1c03d394f3e39117b47165437dccd3183bd8d6c32c77bb480b7232ff2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/industry_hum_loop.ogg-acf6814acc0016bf29f989e7cc31f55f.oggvorbisstr` | METADATA | — | 140616 | `0e51c89cbefbc952e2a059965043a7dffcc7cbc4c4a200d1c2c5842d78a5c6e4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/intercept_pop.ogg-bd914e86a61935f83a50b0dffb42891d.oggvorbisstr` | METADATA | — | 13892 | `9c9a6b09339daea29cd644dcc9269125c01b6bc8125356161747d49ae34b19ac` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/jet_flyby.ogg-73854ea0fd6aebf95f18bcd7e0e59a15.oggvorbisstr` | METADATA | — | 25884 | `caea2df18a3ca2ef3008532e2601a8e516e9b9bec6ea990f28d556c5bc85e3c6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/jet_pass.ogg-0fb59c48a0521ef52cf679666425ed61.oggvorbisstr` | METADATA | — | 30551 | `b268b3e4dfd5d73a0398a48cbe059299603db7a23728ef669d88eec2ba77a93d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/jet_uav_loop.ogg-818a281f9474c16cfb081c88b52eff72.oggvorbisstr` | METADATA | — | 46447 | `32c068cbdfdc2e5fbdeddf5f1c46a1a51bb7dc5ba62e45bbc8af46f3de28d4d2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/jet_uav_pass.ogg-339a6587725c7c78e8d9aa44c8229726.oggvorbisstr` | METADATA | — | 29147 | `df43072742275afaeea63c32269f5d7c774b25b5058b7aab3dcd60140e676506` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/kab_fall.ogg-0fc0b08b735271128350a95180358f0c.oggvorbisstr` | METADATA | — | 36251 | `a3c163ca77be56a559b1e3422f9f967e308aee73658b6b077b5b10394020c5bb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/lang_bg340.png-5032b2af7ba8e503f37680e1ef9ff915.ctex` | METADATA | — | 11616 | `0f7c22f9a5de1c9e16f728ea2920fbbc2ea8dde2c6104ef0d7baf35d5a783dd1` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/main.png-244485f4a09cc87d5a1da387c430dbd5.ctex` | METADATA | — | 376 | `359f2b0466b85322e3253011f1a77da8fe1465bf81f87f6e22329802d20227a8` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/menu.mp3-82b3ae3235abf149375461aff2aa964b.mp3str` | METADATA | — | 1441087 | `8655c5f2162d137ada5c602edc6f03926e920e84635af284dbffcce3ede6e204` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/mg_burst.ogg-8a742f8b18d4c508d521ee99b9b7187b.oggvorbisstr` | METADATA | — | 15348 | `b55401100b8530e90c57370d474f67c280915fb59c1ba81f213160d2e83e4487` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/missile_cruise_launch.ogg-5afd008269d1b10b7b27d7a69c0cf2a0.oggvorbisstr` | METADATA | — | 24600 | `58c414c8ae862efe37b71751222bfba44c3396824766ba7890b4cc2e7aae5b1a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/missile_launch.ogg-e7407a95b949cf1a6d73f5ff083c0196.oggvorbisstr` | METADATA | — | 29044 | `23bd32175316dc1ccac135e5238ac3fdaae45ae6d7b54bf251731da8a96ddb16` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/missile_whistle.ogg-47659192617c64fc3496f485f5347c42.oggvorbisstr` | METADATA | — | 22048 | `7fee94e061f5c2f6dca8b7a068150da6ddb3eee42cff0b387890e6811ad4e763` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/mlrs_salvo.ogg-f86c185e40a2afe77346634c269d0e20.oggvorbisstr` | METADATA | — | 36540 | `aa59fd7eb35061a9becf9c95d070bea2664f625bde715d17faa7e236f75bfeef` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/mortar_fire.ogg-6600f5da6376304e7d60b9d7442e7d6b.oggvorbisstr` | METADATA | — | 13232 | `dfbc85bac841da2d639782b7083c9b47a3ec896dcfa3fdd1551bf5bbc4e2d504` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/naval_gun.ogg-b800734c48add1b21b5ca49de6cf8dc2.oggvorbisstr` | METADATA | — | 11596 | `32735b1ced1ba924549ccb020cf16d200b89f0caabe07e8554818e0dadc97bd8` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/navbase_ambient_loop.ogg-67829f4fd160a1d14b9dc284f73073d0.oggvorbisstr` | METADATA | — | 91316 | `3773df46554090b00e5d90ef9f44a3a55380da8bade6c5247275b01b44bf84fc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/net_catch.ogg-9f7625a989fefe4537c17ab7a3ceeca5.oggvorbisstr` | METADATA | — | 16580 | `8d3855397cb998172b0fc795273a8c6f1ecb822ead6c03e62ae21727efb20ced` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/opening.ogg-0d4f30de440568441166d6f5079d4cb3.oggvorbisstr` | METADATA | — | 694348 | `2db9b29e627e05a3a11dbd836a98db0ba0eebe5ffb5afc2ebd3687693024300d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/protest_note.ogg-2e1cc101e76b4225ac215158f3122d3e.oggvorbisstr` | METADATA | — | 6560 | `74a6339a65cd17a21349786cc5c4e89c1a0ad699b03a6f98c4458b6c76dcd4a3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/pumpjack_loop.ogg-e59f016eae33fc4ab2ec48926c416bee.oggvorbisstr` | METADATA | — | 33468 | `76eba87529e0860927b41ff2d74246ac1f182a0fe6a6be5fcffeb9a70e6c778e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/radar_ping.ogg-69f2991b2de22007e3360c6c3468062e.oggvorbisstr` | METADATA | — | 12284 | `30baf0f53b41266cd8b32217731ceefc28691dd23c0c425256db3c1e8da6dac2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/recon_drone_buzz.ogg-445653856940a0c8a86dd009f4a3a359.oggvorbisstr` | METADATA | — | 38164 | `cb567342a82f127f3265616f921a481ef525b0541a794a637c95458afe484d84` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/repair_work.ogg-592c8e8cce74738408da52eb33d0db3c.oggvorbisstr` | METADATA | — | 26612 | `4196b863c9a32357d7e7758e26c62d2e547e7f46ff5e89f44256cb2f23b0e8c1` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/rifle_burst_1.ogg-a68c7b3ec61e0d54021bbee33ee46bae.oggvorbisstr` | METADATA | — | 11084 | `797f64803af5c45f2aa4ba73582c5543390ed9deca480e383e5f261a6fbf399a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/rifle_burst_2.ogg-554731b34a244f8d050506c3f5cdc20b.oggvorbisstr` | METADATA | — | 11488 | `f134e477b4ece4220e70055c20ef6926282b496b23ba06ab7f36c3375a74a6e2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/river_loop.ogg-0dcaca4a1297d2aa0f2b7f538f100d18.oggvorbisstr` | METADATA | — | 151364 | `860d0b5b22f3eb61c7d2ec0380d91a8e7fa7c52b5de6190f07c736be160ad478` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/rpg_fire.ogg-f50809fe045ca343ac241f539d24415f.oggvorbisstr` | METADATA | — | 16252 | `19defa8959adcf52efd927f2af44eede4306f947696f047fa55ae5adf28b7093` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/sam_launch.ogg-66989b10dff5b1503e73ae59e8429558.oggvorbisstr` | METADATA | — | 20056 | `0d87f3b93a1150eca2320f33fff83eae7a8c9056aaf205b1f3fbc467a5519d1d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/sawmill_saw.ogg-5c418b06ad47521e606dbf66b2cffdf5.oggvorbisstr` | METADATA | — | 18064 | `388d94400cd2d0878d3d2145eee569cc0b9a786f00505a9de6b6d1c8420e70f5` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/sea_explosion.ogg-98998c4fe92cdaecac249331f02be94a.oggvorbisstr` | METADATA | — | 20128 | `cff18fb1ffd95f2e1d3de1a3e22ac349616e2c69c8c304425fbf9a24c862a636` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/shell_whistle_in.ogg-e392d75b3e59c4896349baded7190be8.oggvorbisstr` | METADATA | — | 13032 | `761941b96cbf97e61b8e2a5faf4c747cc0708b425362679b1106b91a414d16ca` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_engine_loop.ogg-f10b096e32c6e358229b1a547bff7c70.oggvorbisstr` | METADATA | — | 45784 | `5497c0575d8d66eedc8a3185638f94f4efb0888c2c7057b2f05ab8b63d2817a0` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_fire_loop.ogg-e52506af5bb2262cab5419e91e14563f.oggvorbisstr` | METADATA | — | 54640 | `2af5d2f100764f1398c37a4deb459dbdf2aa916e56bf8c184be158646a06002a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_hit.ogg-e683327208a699bae24e2823a4e6ef76.oggvorbisstr` | METADATA | — | 21944 | `17663948517a0c3e1927f71903d7c92e8e5b78d7f794a486bb970d9343ab91e6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_horn.ogg-11643bd30d78b765f0f0011e31db97fd.oggvorbisstr` | METADATA | — | 19240 | `82b0f33236ee7827ef2f804a439c1c7dddcebceaa03c3e452fcfb8f4cb20cffd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_sam_launch.ogg-38833717ef7da8bc06593c730a9a0e54.oggvorbisstr` | METADATA | — | 20064 | `3ca5a55bfc7d643dbdf015546e14a123e0ebfa33d521fa702d4bf44a84e97ef3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ship_sinking.ogg-0bd139b2c30d929d68059d17c9fdc387.oggvorbisstr` | METADATA | — | 31268 | `13a09c4091ca6eb2e18149561dbaaeacad3944360a92d72f4d5fff5b118fc741` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/siren_loop.ogg-2da5333374c632b98410140fa6d6a190.oggvorbisstr` | METADATA | — | 65208 | `91fd98ada72f3522dc19e96bc076b95d4b231f4dd5f3cc187f7a71b2f8f77f1a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/splash.png-929ed8a00b89ba36c51789452f874c77.ctex` | METADATA | — | 4262 | `8e393878eff91c3c3d1be47deaf477a361cae2f4044c08270c4066e73883e1f7` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/splash_big.ogg-cfbb65c0955c7c48616400c6c4b619b1.oggvorbisstr` | METADATA | — | 16976 | `2a6fab7d938bb1be85867b3f346f657b1f8e46d362c62904bf2111d803485059` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/style_cards29.png-3cfc1451ff607d36dca9a120ab007a3f.ctex` | METADATA | — | 3210 | `99d61f557e2738808e365d7b8cd37646726a18d1f93c3cb78510ff038ebc585c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/style_cards31.png-33610680990bbf5d3eea35e7c656867b.ctex` | METADATA | — | 3438 | `638d429c8cbf84a31e5a22a202d105d0f1953ff75d0d9e2e72901240b72d0f21` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/surf_loop.ogg-29691a3c557121bb4704b4d1d3f0ce73.oggvorbisstr` | METADATA | — | 180476 | `4a251e110e968fb025de1dd5a591d4f26650deed74c6d66a1d54e7b594421573` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/tank_cannon.ogg-7a56c999cad8e59cf9594934739b6ea3.oggvorbisstr` | METADATA | — | 15412 | `a0159aa5326e6ada4bdcaf2caaf97066701e20c6ca8ecb2c808cd3aa47e6ede5` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/territory_claim.ogg-b7b1326e9c1044414d8f6910bb3b9807.oggvorbisstr` | METADATA | — | 7148 | `971a7c9991295712e7151cefe949c00996f3b834fb2fca8e1c035d0c0a5e0a70` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/town_hum_loop.ogg-27676b20ca29da8f023b17191adcb069.oggvorbisstr` | METADATA | — | 182116 | `103f136532dcf3d6197604eb02ea08e6539efc116b0b9fbbc62f39f87a4f0f37` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/train_horn.ogg-371bc297f529bae2c89ed6ec661859a7.oggvorbisstr` | METADATA | — | 17664 | `9cbee217f9eb63eecd4e296df314199fe90cc46394b35899d8aec02b5c0b9a21` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/train_roll_loop.ogg-56dc0cb6006f70c86b3b380804037dfe.oggvorbisstr` | METADATA | — | 35864 | `2c5d864e85b3fbb5dc7cc89d3c1de6907f20847e368c5ab987cca3272e7e82d9` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/treaty_signed.ogg-387bee68e6e3bab461044519617e622f.oggvorbisstr` | METADATA | — | 10684 | `7e408a6c5109e4fe51598861a5292f09bc42364574204e400beaceaacfbf040b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/truck_pass.ogg-479475eb81cefe6f12ce36fbe9c9fe1c.oggvorbisstr` | METADATA | — | 31672 | `769ab2f1b31424d77c55efa815125501cf4885bc58f78d60c90bd2a9ef9d240e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_alert.ogg-988fe82ff9e82dcb87c0db3d68263f59.oggvorbisstr` | METADATA | — | 11724 | `efaf381bcfa050174be9652628fdf90ba7f174d8919508e68a121752fc768e4d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_build.ogg-ee2bcec096456cf0b3e9366c5ea0263f.oggvorbisstr` | METADATA | — | 14956 | `bd668ce577da4adafd22e19bba42d292c034f18b33f4afc1bc3d9cb2c4bad5c1` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_cancel.ogg-0af9dcc49b9476885fe30cf5ed96f6c9.oggvorbisstr` | METADATA | — | 7732 | `ffba4adb4f5de6c81cbf0001a150187a33037e98afdbcd1b0fde3a7c5343f5ab` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_capture.ogg-d14c9b752706d96e874fec7fdeec1d12.oggvorbisstr` | METADATA | — | 26188 | `e5d33889d02771063873bb601fb1a6b331b864d21ce927151b02dd50fc209d08` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_city_lost.ogg-f5dfd9b5068cd7372e2d08211db82ab6.oggvorbisstr` | METADATA | — | 29680 | `5acac0d5320427741ecb78378bab2848caf65121bc63db89c74f433d3f314ad6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_click.ogg-a0115987ce9b356fbf9f508472b8fe54.oggvorbisstr` | METADATA | — | 8152 | `224653decefd7c010ec8f8905d486298fd098ee0558cadc187e64aa5420f7dde` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_close.ogg-e0e0d6f14b0bc5421f789fe116759ffe.oggvorbisstr` | METADATA | — | 7956 | `3d2807b0eee37dc018de37fd9764a510a370b044502b70b932814c9e942885fc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_defeat.ogg-56fb8cb220b77730a06ed5b3cf1ae717.oggvorbisstr` | METADATA | — | 44448 | `70267fce889cd8a8d692363475d14573ea27fe1d2a4bfacef5fe03ff42fe86f5` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_error.ogg-daea22c0b55cf2f8b80c96b97cf1c4fa.oggvorbisstr` | METADATA | — | 8276 | `0c9fe2a67d302c50ea246e0939a93df2771791bf87cd961b8aefd68ee85e1bcb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_money.ogg-74fde25d72381782c2ea7251623b2de2.oggvorbisstr` | METADATA | — | 13500 | `22f0279410d340abad8acc43565cb95f04c30f5ab5c445490aacd984d615178d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_open.ogg-47d1a9beff873fb2fb97d6208b7dc831.oggvorbisstr` | METADATA | — | 9616 | `90b5fbdea1a4382ad4f7208882c0f70e3b02aed652523d24da7bd2d14a903039` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_select.ogg-4a72474f3198c2c271fd2fb015a5c59e.oggvorbisstr` | METADATA | — | 8140 | `144a92392f28dbbf68d32d54793642aaf29a598104b84fde829cce7dc250f19d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_tab.ogg-d0ca93f47c85caf91d669fe07bea419e.oggvorbisstr` | METADATA | — | 9036 | `534643fcf6588dc0107b71bc86a66616900cd7836a22696aec5aecf5e9f67efc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_victory.ogg-57f1f32a21b706eed9dffd4d45c8ab53.oggvorbisstr` | METADATA | — | 47256 | `bc8caf9d855d97d12b75abde4b7010a2a98964b026c14e01a4f201a2ab904039` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/ui_war.ogg-282400b05b50d910ad95dede15f0b42a.oggvorbisstr` | METADATA | — | 29024 | `fcfa9ce74e256ed2eab6a8071a71bdaabd5d06d65d413c58e093f6395eff71e6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/vassal_sworn.ogg-257648476fa09c53de622f6b08345a26.oggvorbisstr` | METADATA | — | 21824 | `e89ef8f9d9301afe776e841c6789e428b60ceb967633161471051b4296b2dde5` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/vfx19_clouds.png-35c8dee564abb601cac1f026b17da43c.ctex` | METADATA | — | 11032 | `8ecd3ef69bc1e3703b3d5c0f1ccba1f3fc6334d72ce7b97b9b16ebce91d4c9f7` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/vls_hatch_open.ogg-ed2bed6703f008978ff10d42f57e5d64.oggvorbisstr` | METADATA | — | 12972 | `2f8f6be7a83b7ed5f6a008e100cef7a0376c90ba9e413012a3d52d0d9c4ea04c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/imported/warship_horn.ogg-17e6f5c28b23faffb1859445edff0dad.oggvorbisstr` | METADATA | — | 21860 | `c2de0f5e9d35f6642669914ca364e830af4a85780f7a34f48d1ecd86241cb002` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/.godot/uid_cache.bin` | METADATA | — | 23697 | `00ce7b62a80e8414baa4465587e68fd447d61a70fdd7fe66062ae518faaa6509` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/addons/df_device/df_device.gdextension` | FULL | 1–13 | 599 | `805460879da28a6f88af0b6eb643ce48b3568049546617b57084cf95e5f4c318` | Manual full text + static analysis |
| `game/addons/godotsteam/godotsteam.gdextension` | FULL | 1–28 | 2053 | `17c40ec7a79c7c860fbbaa11ab29c246105b96854cfbf046557787e41a11194a` | Manual full text + static analysis |
| `game/addons/webrtc_native/webrtc_native.gdextension` | FULL | 1–20 | 920 | `80e72a9120bfc2d83ad4ea1b5968c66b26f8ac1775bac9b5de1b88c00618d6cb` | Manual full text + static analysis |
| `game/assets/audio/music/game.mp3.import` | AUTO | — | 151 | `c472ec272d8af5e2cb0d286c9a4ec251452920f05e7efcd2f7e1730758fafa30` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/music/menu.mp3.import` | AUTO | — | 151 | `d96020f2216cbabfa960e27113d59ba3d5a2e75618c6558279db3f09c67731ac` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/music/opening.ogg.import` | AUTO | — | 174 | `00eedf70bcb6e7f77e7d26dfa58f408b21e2aea1a65ab2012f07eb69be94fa26` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/aa_gun.ogg.import` | AUTO | — | 174 | `a62f83f66b5926ad6d636579ec2c7bc1bbc83214dac3be13ea9a6fde38d9f1fd` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/aid_sent.ogg.import` | AUTO | — | 176 | `3f3b1ee0d4518fd4e1cced69a4e833529dcb610370f8c80b6f6eb6f0eb4a9da8` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/air_rumble_loop.ogg.import` | AUTO | — | 182 | `06ded4fbeef9f673cab4582dfc8c1cb53a9bd79aea0a4d06dff88d8122794b14` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/alarm_general_quarters.ogg.import` | AUTO | — | 190 | `c3c908f22cb0447d2aeab0144b35525c6daee67020506c738720d35fa65dfc0c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ambient_battle_loop.ogg.import` | AUTO | — | 186 | `15c6ea59cb0a4ac7f0692ff567222ea637fea58ef6f79fd33b6a24eea38defac` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ambient_wind_loop.ogg.import` | AUTO | — | 185 | `295373cfa33426ab08b04a1fe54c57fa0c22a8ef226182e3d6f7d6f24057a6d5` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/artillery_far.ogg.import` | AUTO | — | 181 | `2b39f4a5702d2374374ad96667cd486eac2cd30b56cce2e060b7dde83143d326` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/artillery_fire.ogg.import` | AUTO | — | 181 | `6e40fe3f5374c60929a920ce0dd13e25c304b625bab7fba9e38f56c6601e3412` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/asm_flyby.ogg.import` | AUTO | — | 177 | `19be51eaf59e71b3c4ef8f746c97094c2488751c8755534e3f4bb40df4bd83c3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/asm_launch.ogg.import` | AUTO | — | 178 | `6cfd9286701553398d5fa6b77bca8b5e370f5b072f82eea8b3a8339911d896ab` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/atgm_hit.ogg.import` | AUTO | — | 176 | `28625384e28087a57985383623705e8c3c61045cee73e56279f2f7d7b8409503` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/atgm_launch.ogg.import` | AUTO | — | 179 | `fae2c310b225ef83c1d9872a3ee1ebb1cc2b0552e1e92301f598cea9cd774fc7` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/attack_jet_loop.ogg.import` | AUTO | — | 183 | `40e82d0c359c6d5eb28e3525387e03ad07320fdc2546d9f18d8994e482d7feaf` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/battle_close_loop.ogg.import` | AUTO | — | 184 | `7a60383f463bc48eb8f4da8330cae939a779d00edeccbd8f64f2017bc93ec84b` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/birds_day_loop.ogg.import` | AUTO | — | 182 | `5fedf56afd1da7957b6e9037ae36398c137c6c4b3903109ffab58ec0c3dc9ad3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/bomber_loop.ogg.import` | AUTO | — | 178 | `83bbbfe5a4b1402bb2c5c7b313296389dd8987ef268bde1b8a4749b3db3b0059` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/bomber_pass.ogg.import` | AUTO | — | 179 | `7c8c8900958f91051d1e7823649b2f2a3f4e7ded6d31d9e3de6b468d07396b21` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/bow_wash_loop.ogg.import` | AUTO | — | 181 | `c8f5c1014e4f4c34c88bbbc666bc96ee80d5f71c9020737435f431539a0127f6` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/building_collapse.ogg.import` | AUTO | — | 185 | `8df31b4ae8365d8e5ec8be1ad38202d0e10b4504f44d5d2c1d6febe1a1a5cced` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/call_to_arms.ogg.import` | AUTO | — | 180 | `627e1797923895ef8bd319970ebb4365d02234a479c9d8bf753ad5c48dd587a4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/cannonade_loop.ogg.import` | AUTO | — | 182 | `f52241786968c71d6d5ffd8244a031ac07aca6c2bb07bdc365d058c99fb7c519` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/chaff_burst.ogg.import` | AUTO | — | 179 | `77a0b7053faf47a28cd104964b3db8777788edd55bfbf14ae49910705c98b348` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ciws_burst.ogg.import` | AUTO | — | 177 | `ec80146ae4bcb0da73da066947f4c286abf7e501d2b55bd86937357b07d703b3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/concrete_thud.ogg.import` | AUTO | — | 181 | `150e9cb3b74599b3ed9687bb7620507e60b84722509dae679214cb441ad6bf8d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/conference_gong.ogg.import` | AUTO | — | 182 | `18fc21bc30b1aa43f0efa8e12da728a44c854950595dbe1d85adc4f2a89e092b` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/container_clank.ogg.import` | AUTO | — | 183 | `c92659b5e0242adedb03fe0c41aaf0bf65cea27614e55a462467561a574aaddc` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/convoy_horn.ogg.import` | AUTO | — | 178 | `f3ced70aad23f44d8b4ee8c602291c3ef3c742aacf5e16b605a2bf84cac1b6f0` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/crickets_night_loop.ogg.import` | AUTO | — | 186 | `0ff5af8b0303a5d8d13de513afd85f537454c534a9213b532dbd375301940e7e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/cruise_launch_vls.ogg.import` | AUTO | — | 185 | `edb8cac7e5b0eff1c19abf159f2439fc2e68b7fb9ed6f75f99408a6ea8e56365` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/cruise_missile_loop.ogg.import` | AUTO | — | 187 | `6bdfaacc79a7ca801c8cff25ca7d17a7d2d470093ed02ab35cabe12c496b2875` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/cruise_missile_pass.ogg.import` | AUTO | — | 187 | `5f99be6139a3c1071436bd9ef38bd36c017cd85238ff69cb08731c9661100ee6` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/decoy_flares.ogg.import` | AUTO | — | 180 | `8a0b692f515f8481bcf84b9e0f292f707a145043e9f74c7fa4fa35a254e13be2` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/dig_trench.ogg.import` | AUTO | — | 178 | `10753f80ce6d6ab7cd518d3a453d3675a5ae8796fe0f4094c348d7ae69ef05c3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/dock_crane.ogg.import` | AUTO | — | 178 | `129b1d4787c75beec99b597e4408220d3c19ef317e30935b380e3afcf0ded8bd` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/drone_buzz_loop.ogg.import` | AUTO | — | 183 | `65d7aac0af6c4f7b3636f42fa7daf6a99925dca6ab4f02bc9369fedd46b7fbb4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/drone_launch.ogg.import` | AUTO | — | 179 | `18e964f05efddd199b8fd95d1e60c111eb2ef49411f2ba8ade1d2442bfdd4170` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ew_hum.ogg.import` | AUTO | — | 174 | `184b53d6b7421711fe94574bdfaa402804a9f8557da6d948a6ec303fc3bfe307` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/expl_big_1.ogg.import` | AUTO | — | 178 | `f96b75d77ec83dc00bbd8336f052f466e889fecb80a8c01fb2a4cffb1ad26bef` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/expl_big_2.ogg.import` | AUTO | — | 178 | `c74d55948c0f1b7c40fe6b5b51808e2da7114778bba2bf3ad1d99956eb487787` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/expl_far.ogg.import` | AUTO | — | 176 | `d806c8f842cbdcfd933de00da5f7e27a144b5ba54439d70b96feb1712695c036` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/expl_small_1.ogg.import` | AUTO | — | 179 | `75bc268398a65be11acc34accd7f88f41f21538f43d8493f1c09f48cce809dea` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/expl_small_2.ogg.import` | AUTO | — | 180 | `49f0f135915a249f53c61e0917b42fc310d5d12a2b58513ada8032dacc9223d9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/far_boom_1.ogg.import` | AUTO | — | 178 | `40a7d7e7bbe9ee153fdf0b3c5dcce91f9e5400fb183a14c8185c32a36b089701` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/far_boom_2.ogg.import` | AUTO | — | 178 | `3be7ba638c6d98325d4f7cdf1a1deea53ee1c560a49af9d0ba765beca2976e11` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/far_boom_3.ogg.import` | AUTO | — | 177 | `078a7e2bf60be0cf48ee05c8517942e0ac6c4c52d501558e2914ff42fbe000c1` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/fire_loop.ogg.import` | AUTO | — | 177 | `c4510bdef31f41fff237f301d75ef4a95e905c7b44b7afee80bc6c1ce0317f8d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/fpv_buzz.ogg.import` | AUTO | — | 176 | `bf3e16e2cd680a8c45516493448c07aed456e8eec9559bd471c12e3f604cf2d1` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/grenade.ogg.import` | AUTO | — | 175 | `3bd68ef183db05a222f51fd3f469992a13739c1ec2d28caa581c4bdfbf95d696` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/heli_loop.ogg.import` | AUTO | — | 177 | `6404b5fc09c378130542d75d150bf90d641aa0db11e7e5e22c66101414465a92` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/hyper_launch.ogg.import` | AUTO | — | 180 | `b2309259ac0d7f498db31e0fad4cad2d93c146e48ca220acf5e769d1b1a0aa2a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/industry_hum_loop.ogg.import` | AUTO | — | 185 | `9b9ce50498d060ce0e7c9ae9c3c5a019e961ff38db45d2682751a1c781be5411` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/intercept_pop.ogg.import` | AUTO | — | 180 | `1f74012bfabe765d30cddcc0072e43ce3864910b5dce7cf7c05b43265c862a8e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/jet_flyby.ogg.import` | AUTO | — | 176 | `70fc8d8ab52e851863b0d5ccd932f2db98bc46dbfedea2a0966954249347e2de` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/jet_pass.ogg.import` | AUTO | — | 176 | `9aace7217512a4c07dde9109445ebeebbb5d2265ff919e898ec14260a8f784bc` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/jet_uav_loop.ogg.import` | AUTO | — | 180 | `da178a6d9126ddc1f3404133fe0969f0eeac8d95489d8a437d3df183fc23799c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/jet_uav_pass.ogg.import` | AUTO | — | 180 | `e5f512a20cae1db8dca7df4ff40129fb3f9e95a9cf68584425cc009d002348da` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/kab_fall.ogg.import` | AUTO | — | 176 | `f2e95a5b74c314c2cfe1ecb6f488ce91346d16eb6eeb5faa8fb643392e531a40` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/mg_burst.ogg.import` | AUTO | — | 175 | `58dcfad2613652551fb8de7749e41c0cce832e4f98c590e4fb782b2ede78c8d8` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/missile_cruise_launch.ogg.import` | AUTO | — | 188 | `1efb31f87ef6eb78300c54abf0e30c44d7b213fc65ba64a42da33178a4f1be04` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/missile_launch.ogg.import` | AUTO | — | 181 | `21d74543088af7e749abdbcd10c945042cc60b85ccdb4222be29966c3cc66c88` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/missile_whistle.ogg.import` | AUTO | — | 182 | `869f62a8572ac5eafcdda05891c3b8aeacc3f534b38ec67bc9607ded9b92af7f` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/mlrs_salvo.ogg.import` | AUTO | — | 178 | `b8edbfe5ef2650779207d693d252b073fa0477dfd0711d1fc4db655c20ac6b37` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/mortar_fire.ogg.import` | AUTO | — | 178 | `6c5e05ed7700cf56cc97199b73693699e989dfedb8611a60f909ed1dd4fd3048` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/naval_gun.ogg.import` | AUTO | — | 176 | `09bd2ed32904a563d932ed201fa3335c3b5e8d8960d3f47ba05aafa19e36c78d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/navbase_ambient_loop.ogg.import` | AUTO | — | 188 | `e97cbef9f49cc4405494a1c585f159ed182759861ba7e49b6930f5d90acca107` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/net_catch.ogg.import` | AUTO | — | 177 | `0073894b4269f598c96f12a194a989e7f70262847142b110da56d7cd2c2deede` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/protest_note.ogg.import` | AUTO | — | 180 | `9df2982adc9ec63e9ef517ad12c31aedef7f4435e2e02cfdad40fcdf0fa20b1d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/pumpjack_loop.ogg.import` | AUTO | — | 181 | `37a7a4795c2e7a60d79c283585877267330f4394f8707e35ecb21fcf3f01823d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/radar_ping.ogg.import` | AUTO | — | 178 | `4db2cc57f43cda7443818e0d8d2775ca32cdb5b66a82a20e7849ea5f6edc70ad` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/recon_drone_buzz.ogg.import` | AUTO | — | 184 | `78db93941a517ddd01dd9986f1529c86a469890965ca187b7cd22ac0149553a3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/repair_work.ogg.import` | AUTO | — | 178 | `f152ed8d7604554a3af7ef98d9e04263c8772e6dae7d9bbed56dd1cfbccee4a9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/rifle_burst_1.ogg.import` | AUTO | — | 181 | `a146fb70e62cf6dd16aa39e4478fae798ce1bc2eee121ed5e01d8677d4e443a3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/rifle_burst_2.ogg.import` | AUTO | — | 180 | `cd12f714ea75cbb9ea6e44ae9aac71f665594ee461eeadc3171ac1fe70438676` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/river_loop.ogg.import` | AUTO | — | 178 | `cf2c3fe387a989c5c79bdefa0ca317e783103d15b40a85500731cddae8a2cec1` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/rpg_fire.ogg.import` | AUTO | — | 176 | `1e9c7c0814f23f2e1b4924a0a5e2e588c1714179c494de652b874914a4e54009` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/sam_launch.ogg.import` | AUTO | — | 178 | `b2938ad197d36a95c742d2a5f2f9f59c5604c8f24ffdee78324fdfabebcc6f3c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/sawmill_saw.ogg.import` | AUTO | — | 179 | `4cecf201cae465bf00084a9c348d4d3097a828738ad7b3da9982becb2430fdf4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/sea_explosion.ogg.import` | AUTO | — | 180 | `b7d94dc3a4aed43f2648652c9a8f89bea6b5aa298a3f2032c3bb22c867b3132c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/shell_whistle_in.ogg.import` | AUTO | — | 184 | `8b2bb5171bfd0f358544c1232a6aaffb33d866e370419406143ac2356d963285` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_engine_loop.ogg.import` | AUTO | — | 184 | `3fe7bb90ec110135133aa8d20a5c6cd7e5b9908807635e01877d49183abba13f` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_fire_loop.ogg.import` | AUTO | — | 182 | `3b4674b066d4d3a65a3d742cc0854a0ad2fa921edbad2649c2025cd68c2cf3bc` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_hit.ogg.import` | AUTO | — | 176 | `c1d7bad1a50e93c8504e5902e06266913a6ad2190350dfa59caf518b50996ae9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_horn.ogg.import` | AUTO | — | 177 | `09488ec94102d6a8af33f2e4dd095408e04164763767171f382e673109548701` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_sam_launch.ogg.import` | AUTO | — | 183 | `92df856b40dc6f313029c2e9d7b5c67b0fbca5a33e7e5a0366c617cf674019ab` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ship_sinking.ogg.import` | AUTO | — | 180 | `9677aa0fc3de239015e20b44a82f9d7bd652186cf855b06aa435c13e4502db1a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/siren_loop.ogg.import` | AUTO | — | 178 | `5fe1945c5dda1bb98840950f798ac451c46a43316a72c7519737a9342991518e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/splash_big.ogg.import` | AUTO | — | 177 | `9753bab6a5d36caaa705f795a269199dff6d420bd46179b9a40f4e6dc3540a1d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/surf_loop.ogg.import` | AUTO | — | 177 | `6bdd4212386e0aa19db1b8ef06b4ba511c00ec0144e585e57b19dae52b5a7010` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/tank_cannon.ogg.import` | AUTO | — | 179 | `796601096f54160833ab5f4b0a48ec77bd939f66aef714b2d24e294590a0d858` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/territory_claim.ogg.import` | AUTO | — | 183 | `5898ea026a8fa79a8d518a4c4c2044db42357620f8d5af566e96be4153308256` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/town_hum_loop.ogg.import` | AUTO | — | 181 | `61d8dca69e9a5bba8b05c61f36710454952b2f91f430cef1a52c702229056722` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/train_horn.ogg.import` | AUTO | — | 178 | `abfdec62bcd5d8b136e24876e43fa84ac04e819dae7eac87975f17e46d38b97d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/train_roll_loop.ogg.import` | AUTO | — | 183 | `94766d324e3b27fceb6ad1c22b38d03867478401495b06739fd23af1d6f5d856` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/treaty_signed.ogg.import` | AUTO | — | 181 | `fff8f84de3e7a32bafa38f1efea756a1e15877317201a6cd1297f4a8e0fb6f05` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/truck_pass.ogg.import` | AUTO | — | 178 | `37c4320d7d9331c58b9935396517de6ef9530a7157d549ee6e5ce9679e9269da` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_alert.ogg.import` | AUTO | — | 176 | `03ddde3ae312b32ac11c2899d04c24c4a9bd597b1b1095fc84b24fb4182daf18` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_build.ogg.import` | AUTO | — | 176 | `34ccc7a143ca1349e5509182e0af07958b77f9dd7e393101abc426a0f2b2edf0` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_cancel.ogg.import` | AUTO | — | 177 | `375f9bbca81735544bf03ea8b9cfedbab83f448456d47808c0a071c9a1dd1100` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_capture.ogg.import` | AUTO | — | 177 | `ac5f210fba3bf7243e83e11887cfea9ed37fba989723eac97ce5d2c9e8092f01` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_city_lost.ogg.import` | AUTO | — | 180 | `12186b30b6ad8f2e3d0872a01057c62de33081e27e5818058de5d7bcd04fdb90` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_click.ogg.import` | AUTO | — | 175 | `372b675644d5aca49bcd2877f2a6a915ff8bb1127faae57afccddd816ad0f6d2` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_close.ogg.import` | AUTO | — | 176 | `44683a498d4d9c7269aabfa36fdb1c81d4f1dd7e9e947afedd499859d5fa0a30` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_defeat.ogg.import` | AUTO | — | 177 | `3bd3319cd1f076b6b97d731f10fe9a838052aec0cb8abd9010f43194963dd150` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_error.ogg.import` | AUTO | — | 176 | `fdeea09a16f2000024d17cf094fbf4fac738d0c5d4b7d30c5f8b56757dc97ccb` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_money.ogg.import` | AUTO | — | 176 | `7270b58747db00400eb697d068e05887689f7a2a819b16d13629175106d5794a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_open.ogg.import` | AUTO | — | 174 | `7bccbd8d6e178e54e76ccdabf1972ca99d84a8d2a6b4a280ae50b38e5b380c5c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_select.ogg.import` | AUTO | — | 177 | `a418668f96490f9d6e345d8950ceda4089045e31b41a7c6c325a96af253758d9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_tab.ogg.import` | AUTO | — | 174 | `2eeeb04a42ba824f393f23d722f76d91829f6024539ed81ce35f1deaf2712494` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_victory.ogg.import` | AUTO | — | 178 | `ed33af41ac3518a7802817d118fb433510b1e57a519e7851381714ac765c44bf` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/ui_war.ogg.import` | AUTO | — | 174 | `1e3334e363e6f4a38877b9cecb6ed89b7d775ab245c0272918c6a42044f00dcc` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/vassal_sworn.ogg.import` | AUTO | — | 180 | `9413907305984c96a497c110fd2ebff625181e8e46cbeb58434342b9d4dfe409` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/vls_hatch_open.ogg.import` | AUTO | — | 182 | `a54be534cef063fe7333da1494d88a025af66db5c3a360cf9e9e6721414710f6` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/audio/sfx/warship_horn.ogg.import` | AUTO | — | 179 | `11af1f8882558c4d17ee6aa22d397d4d0b98969ae15e768b88afe8888c41fed0` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/fonts/DFSymbols-Bold.ttf.import` | AUTO | — | 171 | `ee444ac2e3fb716ba19404d65017a41ba83d8dd6ffbc91358c45ef7f5ac35475` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/fonts/PressStart2P-Regular.ttf.import` | AUTO | — | 177 | `74929284623cc9bcd242971e83c57ccf3a9c66dabfb4bb9d823dbe587de5db63` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/fonts/Rubik-Variable.ttf.import` | AUTO | — | 171 | `e4030dde8a76871bab060cc67fc7a6c791163a8aa8e11b901e5cf7072238a1b8` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/fonts/RussoOne-Regular.ttf.import` | AUTO | — | 172 | `989240d3a19a782b35a05a32fc298265fe3451711e322f970995551dbada2081` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/palettes/main.png.import` | AUTO | — | 193 | `85f72fb444d364b50e014669f8cc2c3dd3c4cc463e0cd95daf6681f84ab87e6d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/palettes/main_named.json` | AUTO | — | 1669 | `8a21f68402e2f9e5efc68c4d99bb17f952afb4ff0bb34a726054c94bcd096883` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/palettes/terrain19.json` | AUTO | — | 1615 | `ef49141bb1a61664c4f2fafd8909c8c9cbe4089b665f1f5b739dd00a67e2e124` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/palettes/terrain_colors.json` | AUTO | — | 1201 | `4b54ba0840aead73627235167364ce979e7e0a8885a72c70a0fe586ed255255f` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_acc1.json` | AUTO | — | 801 | `9703b5c37ebdecf4d5a43f46fcd346b832adb246cba2747c1b6917908c4b3640` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_acc1.png.import` | AUTO | — | 198 | `5f5c9228e9935e3270856022c1e1c2766b146b9e2722168866af78e320c31dcd` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_air316.json` | AUTO | — | 2229 | `c063d4c6022fb1124b290ef146900869fcedcd69bb41caee7fc8ac50c6650445` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_air316.png.import` | AUTO | — | 200 | `1ed45893a9ff3e051666e6b63806b68aba05c0a129eb445249b4fce55ab0bfcf` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ally320.json` | AUTO | — | 897 | `cf3b41a1992a95b721ee81f76395008ce936c44d200088b68db38ff137844984` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ally320.png.import` | AUTO | — | 202 | `3e0bcd38fd6eba8a0ddd1bf4d1cd6b1f93a4302171671fcee208d25e546f7991` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_cm28.json` | AUTO | — | 687 | `5ce5c6c42dd8a5b50f6a2498bf0d3b0ea4259da5911362a1c5121bbef66de796` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_cm28.png.import` | AUTO | — | 198 | `82b7a31f51a2e557c896293fd6aae5a073a5a77b3e09345a4e5786c3b3cc038a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_cosm_bn.json` | AUTO | — | 3087 | `03e9437f41efde114c223a89725a20e30f8b1891359474d56cc4bdf112f7627a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_cosm_bn.png.import` | AUTO | — | 202 | `a3b39ed973de3256c21435072189b4eef95fe5a110caf922d09800f0caf21ee4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_cosm_bn_anim.json` | AUTO | — | 4595 | `15543cadfd497da85486e69e7b2dd2e48dbfa72b8a675fc067517a7f785439d6` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_cosm_bn_anim.png.import` | AUTO | — | 207 | `1ce674f7c4ce42ab93d9983195550e493e3e1145ee4c058120749a8bf2a8004f` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_cosm_fr.json` | AUTO | — | 3028 | `d3af281fcbe6a714847b8132a8774eb718768f6a26ee34a6a852c37a90e885f0` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_cosm_fr.png.import` | AUTO | — | 202 | `926b54c1106b0dd90aa39e4ffaf6d51e26e597ae5bd261256a79cd050e8ad8a2` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_cosm_tt.json` | AUTO | — | 1568 | `8d08e1ed860d8b2a06da1c10e5f77cd244f76a9d86a08b7e5aee9e3bc30f570e` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_cosm_tt.png.import` | AUTO | — | 202 | `25dba562919a0a7cefd70762c897dc394c93ef03ec94cc6c7dc0335c8b54fc40` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_debris314.json` | AUTO | — | 3258 | `cdf0226056e09ede34a67477232cd41939d43422b02a276367b6f2baabf1bc72` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_debris314.png.import` | AUTO | — | 204 | `4ea96f147461ca9ede0ea6150338b406dc88309f175508a91d4c47305ee2e394` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dip26.json` | AUTO | — | 2496 | `f008f0f83e6c5c7c103607c09c9dae83aa61fedd83db3685c834812cab1c6214` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dip26.png.import` | AUTO | — | 200 | `2e1e95bf7a3b5159919087025e5802c89cf32f171e7451752f771803dfa58d96` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dip331.json` | AUTO | — | 3865 | `715b01168114cf07d6b2fda1030439bb3fd8fc2f40c4c330ec9ffb414c4816c2` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dip331.png.import` | AUTO | — | 200 | `421d6509dcd080af842e64788094ddf17a580f379aa7482fa1dbea121fd1f5ff` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dmg314_asia.json` | AUTO | — | 40813 | `1b48f5a126eece355d289b28840e53cd4235068803dd2702c38cbe81fefbe283` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dmg314_asia.png.import` | AUTO | — | 206 | `b035d35ed116a496401b1e2657b2d3948a99136460157f3903ccdd27c77e757e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dmg314_clad.json` | AUTO | — | 190399 | `3a4b1bf64f2bdee02522735325be598ba44b01be94f4794cc5ad017597820b58` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dmg314_clad.png.import` | AUTO | — | 206 | `1e727f5dc0323f672972f92bc095f78866f7bfe052196d65dd0878d9091ae3a7` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dmg314_east.json` | AUTO | — | 38771 | `8e9861cdaa1ffac74dbc0f1ecbc52e64f0d122831522f494029863a5732e9de3` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dmg314_east.png.import` | AUTO | — | 205 | `abeca2befaaa80bcf9633902029396831e3f86044abbd52efcc7d8b1770d3393` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dmg314_usa.json` | AUTO | — | 40373 | `0314d191dc159cd906d3c4c9e440d6fc31e04968db5883072c8bf2bfddc21268` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dmg314_usa.png.import` | AUTO | — | 205 | `ffc5040558d62746fd80f10f3c771eb9d6c1a751d8b264c8f1cb7e296f5990b0` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_dmg314_west.json` | AUTO | — | 40770 | `40b3ccb052b1475a73c9c30f43b08764040ecd28144ffb289a4c929b9db19de7` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_dmg314_west.png.import` | AUTO | — | 206 | `6171f4f12bc81bfad3c625e962dacd00339d74dc5454559438948835adc0932c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fauna319.json` | AUTO | — | 6068 | `2deb64d52bb81446a3eaea9639006b71343c5761272236c3cb33f5ecc1ccc975` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fauna319.png.import` | AUTO | — | 203 | `5c190fb5f799f438c6f651adcf86221bf1f67dd5039e13e92588ce03a47657ea` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_flora.json` | AUTO | — | 8896 | `14f43317982ae3b5509ca22b8e8fed3f8adb6c22b00888189de32039f0106690` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_flora.png.import` | AUTO | — | 199 | `c39afb52fcc96cb56d613e5ec4a9997c208b5305f53fa0a6110427a06b40aeee` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fui_crane.json` | AUTO | — | 816 | `e2ee1286bc7e78d0193ead30a5bf6165cbcf34d2604a21c0ddcb02499e202d29` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fui_crane.png.import` | AUTO | — | 204 | `ee8eb26d59cbafee965b8e96df041bb891d17ca3909860bebafd7e2e667756a2` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx.json` | AUTO | — | 1656 | `7fb83801c65c5e362d37279301b3a6b203934a860e4d7465943771206db57ded` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx.png.import` | AUTO | — | 197 | `5c2e9a542bce07e488166349792d016eafe26cf931d866f7d51fe809df07a81b` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx2.json` | AUTO | — | 1449 | `3153d1af6db596e2c60e9479c188e9c0fc4f5522f48987520c8064b1ffd75883` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx2.png.import` | AUTO | — | 198 | `41ce5f6388c64e197d74d34594b065d35bcdab5416cef849fbc5cbd5d3e4b5d4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx3.json` | AUTO | — | 825 | `9d57e32facefdd1cd9b461d6e47b088c9556ee38c0423656f686a442cc574046` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx3.png.import` | AUTO | — | 198 | `7ce3e42531070b0c79868a68762ac9198c8c424012bf2474b9d0c6c136822229` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx314.json` | AUTO | — | 4786 | `d5dff61a44cd511d9eef2dc796010ef1c198f8f22d9a1a37f4c2039a124eaffd` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx314.png.import` | AUTO | — | 200 | `2cf70aa69b16d99006d1e5e4caca10e0f5ef8c2217a389d49e846718baf54b33` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx4.json` | AUTO | — | 1197 | `669a6917301b4ad2d8bb5298821f80b33576b713a46aa9b7096d4679e5fca49a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx4.png.import` | AUTO | — | 198 | `28cbc6561120e1b0e3cee24637d19c3ee420c6245f396120155f4af55d4d7f83` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx5.json` | AUTO | — | 734 | `bfdf09cf21f260beccffcf5e0bc7dc0815fc5b75216697fda173d510ee3ce751` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx5.png.import` | AUTO | — | 198 | `46867e70227f0e63ae5f81ccdea1200963751ea67ea8cc0df2107e30f4a7470d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx6.json` | AUTO | — | 1234 | `f9b0210f814ccbd8a58e66e2e5e5cda94ae52fc0719511f620035511ae404b65` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx6.png.import` | AUTO | — | 198 | `be7677b402567d96a5e3b6d363d7a1bf6a5edcc442393b5445054f2a6cf5cc62` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx8.json` | AUTO | — | 738 | `f28c52a902f494998bd7f721864db3cfb525c2eb120709b2a871948ef9c3b84d` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx8.png.import` | AUTO | — | 198 | `1f07ef55fe486c68400e9c3e457b83e198699d892e7b48036a28e89305b0bd61` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_fx_navy.json` | AUTO | — | 2651 | `00f9d33c6ab8f11f225acdd6701151db39b2bc3144c54483e6389a8a332ab9e5` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_fx_navy.png.import` | AUTO | — | 201 | `71bddc7f8b932ea2f463bd8b3572b1be48df8eaae5d8b26bd819e1c08035adef` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_kpp30.json` | AUTO | — | 73218 | `e3210c38bc684449d01eb0c5308bee5427997277f99fb11d34b310256251ffe7` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_kpp30.png.import` | AUTO | — | 199 | `802d91ecc96e32b372d9b8365655a5c921170a4c8dba9615900f98726e4a0f61` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_life.json` | AUTO | — | 6198 | `209c01e127f99cd51b8422ae50da003b6dadd0db98e7a0a5dd02a40a6e19670c` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_life.png.import` | AUTO | — | 199 | `cdda5ef9597729e6477fbc738766faed99c8aeade66ea6ccbcd7f14d8725c593` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_mines27.json` | AUTO | — | 6799 | `12774ac07cfeeeb6cfa4354257c92effa33560a04252ee79aed1944fcaa12a2a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_mines27.png.import` | AUTO | — | 201 | `22b134ddd0f966cf7865e249cd4f9f01f7fdca2d98ade170dbeb69147e1e1bdb` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_navy1.json` | AUTO | — | 32713 | `4eb1a1060ef27845dc49a6390436c301eb4712320d1f251f50a83277b14f51e5` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_navy1.png.import` | AUTO | — | 199 | `fe21a2336b07bf8188a77fdd23e458f759430d9c04888282fd2b1ee7252ddd83` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_navy30.json` | AUTO | — | 1691 | `d0c3f53f0d0cac3e2e4c4c1b4afb7b4ecb7f71fe7e922e83800773c1b42b4e3a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_navy30.png.import` | AUTO | — | 201 | `5aa714222faceeaf3196b3885ba9979354c468aa25a116341b4a208f32666bed` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_net29.json` | AUTO | — | 2188 | `475b322ee890e1820800097357fbe5e1175d488e65e7669e376ef83fc207f4cf` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_net29.png.import` | AUTO | — | 200 | `5121521e532b834c2706249cbbe57cd44054ce5367e93ddfcec5ac38602dbb17` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_rail332.json` | AUTO | — | 8430 | `0395d07c5a59ee7fe87c8134852a731c5208f133b34c5798d3207b28b601ae74` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_rail332.png.import` | AUTO | — | 202 | `e5bae7e5ae9d3107b5ec0d9669166a6d9b78f9b62df0891ba2e6348bc0c5fb8e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_style_asia.json` | AUTO | — | 22689 | `29fbd963e3075bbc2cc36e6ae5e0d587d1d17f70f560e9e0dabd7d4d4b88c4fa` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_style_asia.png.import` | AUTO | — | 205 | `1a40e5a0ecac41b87b12eddcb0393ea5d016f187b6ac77bf8233b648a57b13f3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_style_clad.json` | AUTO | — | 49197 | `bed2698d69513bd004e48de5d16e7ae9e1f3bb720bd0b760e1ccc32a9e6583cc` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_style_clad.png.import` | AUTO | — | 205 | `5a64c45c6452b3c46c1af1ee8432462a279842d39291e5da4516607903a5fe64` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_style_usa.json` | AUTO | — | 23159 | `2b89d7c0ece915a29b4bb3146dcdd1a99ac676f95af716bc52c0c026e11dacb9` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_style_usa.png.import` | AUTO | — | 204 | `b0f89cffc19395b6b4ea62b2ace352bd58b1af6358b454b98acd161402a008cc` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_style_west.json` | AUTO | — | 26115 | `668f51667db35e7c8ede74820a4cf7bd01d46904199895307a78153075567ce0` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_style_west.png.import` | AUTO | — | 205 | `807095af9da9871eaa041de6e6b57faacb6f4c41e21d87749072467a8d0b735b` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui.json` | AUTO | — | 3039 | `35b3b7ca9e57b14e7b647e499870be6f83aadc9be9280399d02da8d3eea6c3d8` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui.png.import` | AUTO | — | 197 | `d19339b7a0b8f065bf37e2e92b56eae75dc7abc9b6b109f648495967f4cc55f2` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui10.json` | AUTO | — | 1667 | `fed22907b6115421d4c58f5df4fc5d367f17201f6bf3adc571d72e214a2c17c3` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui10.png.import` | AUTO | — | 199 | `d9bf3a03e94f2d4fd6fd522a079755722130f29be11944246ccc55a669e64abd` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui11.json` | AUTO | — | 987 | `3bda690d1a7b2756b398d694ee5fc585e3018d80bf4ddbf2c47ad0eab4e5dd61` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui11.png.import` | AUTO | — | 199 | `f2d679c6f5b8140511ab265be0aaaf40a84b8c9ee58bbf318f442d805adaf320` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui12.json` | AUTO | — | 214 | `b01b882a9d7a51349192eaaa994293ab90b0aeaa8d08882760667345873428dc` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui12.png.import` | AUTO | — | 198 | `3f3011d6785ead7bf075909aa2995502e900654bb4499469053492cefcd7acee` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui13.json` | AUTO | — | 258 | `ea2c7259c62967d5060a3b76860ac52558da4832e0903e08e2dbd7dd55b4d69e` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui13.png.import` | AUTO | — | 199 | `267c1b3fa9dce96e8426721978a98af04595083e11aa1061cb3558ae11a41fd9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui14.json` | AUTO | — | 563 | `f67289d2f5383d8f685f02c2c646fd530a1f86cde9206f651ad95b3cd7f2ef05` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui14.png.import` | AUTO | — | 199 | `ad53b6901ab80fe1149ac738e29697920bbf63e3db46db1d3a970fff89ff7e44` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui15.json` | AUTO | — | 1564 | `bea66ab56569451668f03c1350c7330228f9b0a2f189dd804f841f2aa7407249` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui15.png.import` | AUTO | — | 199 | `f2c6732b817e46418ec1e735cde7c47b888518d02a0e8f01c0d1756b8558a495` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui16.json` | AUTO | — | 856 | `3003e423f37a1e90d373e74a6db188e2ef040ae3b946b6733cb6dd5201efa0d3` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui16.png.import` | AUTO | — | 199 | `d78393e06d47c1863d1df7212aba544f4e1e81d6227064b68cbe236db7971238` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui17.json` | AUTO | — | 308 | `c4b9b38bfb7616b0e9b2699dacff9ba1d764056e818a22b0b7ee245f90e33041` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui17.png.import` | AUTO | — | 199 | `e22affb49f4758e98b9b74df916ef28dfd1ddc404e3761252384773db28f0b02` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui18.json` | AUTO | — | 219 | `09326cf316079b7e840130b2c3a4e49ba16c2684539f285a2e87cd14667c93b1` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui18.png.import` | AUTO | — | 199 | `5e90550a90cc18f6c53fac71ba4b543eac1db654f85c476e6bb1908e407107e7` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui19.json` | AUTO | — | 5005 | `eac3712cc5893bc91736e743298f1d031d4867bbaccf2011ea7d3bdf37e6dc61` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui19.png.import` | AUTO | — | 199 | `f103043cab0ce975711ccc30406ac6ce578e30fd33cebec2e225ac4e1cc1800a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui2.json` | AUTO | — | 1344 | `486c96d8347bb63ea72dc9009d749ff491d79da3006f50607ae70b013465005e` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui2.png.import` | AUTO | — | 198 | `358321bc1cd944538a45fffcfe7effbd3237ba29620d6c6a3d175c488817019f` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui20.json` | AUTO | — | 2352 | `07d2a37b2e31a39265d6e4443917d29ed5e3e13f093ea5473c0ffdf8852a4d8a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui20.png.import` | AUTO | — | 198 | `87f6048e88d1dc7f323c850bad63fe5af7b6cbecb38addac5f78935443ab4e14` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui3.json` | AUTO | — | 603 | `df5e05481aa9f0118687f24ff271b6baeac01801ffe9a1d7fc20ab5a2f625afc` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui3.png.import` | AUTO | — | 198 | `346b2c804f99ef462ad29277f04e4004ad55c20d689d67184a767822f2411fe4` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui316.json` | AUTO | — | 253 | `283ced52c72568c219eb11eac17840667a1377ef6a6b5c8a0aa785ae01766c5c` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui316.png.import` | AUTO | — | 200 | `e9ab2190bddb7d1acbcdcdb1b7dc641cdd9fb0bc1adb61017875ebe46cf0efac` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui319.json` | AUTO | — | 1048 | `725d5a00376c8a443e4c4d90d85f201ed1508a5489918218b18d48583d506814` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui319.png.import` | AUTO | — | 199 | `242e7e5fcbe380c90c3d6184a7e4057e1ce28aaa31ce14b96d21a9db3a7df288` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui335.json` | AUTO | — | 305 | `ad54e8321339fdf8e07199c28782b64453eaa40fe584c0fe517f59e1ffc65cb7` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui335.png.import` | AUTO | — | 200 | `209817027e05c85c5faa6f2f607f2779a40937ed374dab09a8bb5d34ec69163a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui4.json` | AUTO | — | 1101 | `73e33d24004b36dda103aeeb54ef3c274971681dcf22bf42f907847ab4505696` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui4.png.import` | AUTO | — | 198 | `51e1292fac26878bfaf8b814833686851c766bbc39329fac38f5f27abf64d18e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui5.json` | AUTO | — | 814 | `772ee34370e7c30976e229c07f3acce75bbc94cd78b6eb305edc9e87842ad4b4` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui5.png.import` | AUTO | — | 198 | `d39b2064a4060935cfac032c26b3ce66dcc1b1ac1f96ad3d44d014b0a8d74f6a` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui6.json` | AUTO | — | 1037 | `229a3fe7011df5dcffbd47768d64d634b7c5408e5f6be6bae5501939f9ba4292` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui6.png.import` | AUTO | — | 197 | `ded0c5d3310fed75dacb50c51cf528a18a5c1a402db3097e92e572e251d52155` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui7.json` | AUTO | — | 1597 | `867615e9ffb24b7231b10a70015a9850a26456d0e61fcafcf1a7022427d8eefc` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui7.png.import` | AUTO | — | 198 | `9900b1badebb44bc0fa57040c512f809f115bac4a328793ad75983287b26659e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui8.json` | AUTO | — | 668 | `53a64ae9aaed2da5c8650785bd64fd4cadc4b8c67dfedbe7df889ca88dfd0315` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui8.png.import` | AUTO | — | 198 | `fdc090fe5cd711b3156bbcb4545ddd2e9a162e78dc291b2fdb193b8c7a9286c3` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_ui9.json` | AUTO | — | 5072 | `035dc7abd32c914c223302d0b41179ddc617dcdaa995b987b8e1b0d1b42be5a6` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_ui9.png.import` | AUTO | — | 198 | `dd1a2503f746d2782c46dab29c0d38e1c8bbffd6c308a1c1abd634bfe9ff53f9` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_units314.json` | AUTO | — | 48164 | `0e38ce74c3168b962565f216a6370dfbb77bfa13387e5af967670b743818f0c5` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_units314.png.import` | AUTO | — | 203 | `f7b230159ae146692d0e69959cf44a7b024cba630c6e8611e64ceb33f24f0dd8` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_uran30.json` | AUTO | — | 8282 | `6791b2fbd702c2e85314d312948d53be6c8cb06d79e86cac7e321a8349fb569c` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_uran30.png.import` | AUTO | — | 201 | `c115ec8e830504727a93056780bd61453e3361e1e1ea82f114918f2340392b52` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_uran30ui.json` | AUTO | — | 469 | `555e50997a10e889feabebd49dfbfabcffd1c25538d6eaba857c0ec1e1e7eec7` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_uran30ui.png.import` | AUTO | — | 202 | `e8fd77d5e846794109b377e358c7e7baa100b0a090824249f05e4bac8b36210e` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_vfx19.json` | AUTO | — | 4451 | `3132bf0222204e2fa0a081b066f47592bd11f018869dec6bb6ab980bae59585d` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_vfx19.png.import` | AUTO | — | 200 | `3c822a35498fcb6433aec22deb8b1a8292ee25977ca8bdfd9c54e30bd9f2fc05` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world.json` | AUTO | — | 11462 | `aed2efe059356520e4b00f565ff073796b3453df12c405c8cc441449cd2e0162` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world.png.import` | AUTO | — | 200 | `d1de58dbff93cac1308561f6bfd115ce30ea04d40811627d7f762cf433d5bf1d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world10.json` | AUTO | — | 4928 | `2c0a621265d12140ac4efaedebb1f4f8f9723d3308008c15638a1223acbbe11b` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world10.png.import` | AUTO | — | 201 | `9c620aefc77144bf4e133cbb2a5b51d28ec13a4b5c26b46a8353410fa6c96906` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world11.json` | AUTO | — | 17051 | `8c5f75895a298ed1ea122f91a051ec0bbc5ecf4aef6763b16460b764cd72ecbd` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world11.png.import` | AUTO | — | 202 | `0223c05850542bd8d2026d65338c9b5ea2d7c3535c5dcbc45644fdded6d783a5` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world12.json` | AUTO | — | 1218 | `27e4a43e2ccc5aba424cffbff6799f05fb4b0d9bad497adf06ece9bc5a6d147c` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world12.png.import` | AUTO | — | 201 | `6bb7dcb14b461f14a7bc90d3d467533de3d896b8814bf8c88dfd65d8d0869950` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world13.json` | AUTO | — | 707 | `567d3109e952a81d08a0c2ad3d12b84770839fcb2916c915fb134809bc66daf5` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world13.png.import` | AUTO | — | 201 | `5f99decc1ff3c4e775a141597334c67010dc4cdcfedc10f7820fc794a01ce005` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world2.json` | AUTO | — | 5454 | `812c735ecb260dc54e957477dff13fddbeed06bdee2ad5631f0bd6b2a7507e1a` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world2.png.import` | AUTO | — | 200 | `7d500bac340288e42e6afc6109a8492618c11702408cf09a7f540df6d624e794` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world3.json` | AUTO | — | 6739 | `d4e7ca706d3ded7780c66f4e052a0bdb1dbae03320f5314b1d3662233edd0ff4` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world3.png.import` | AUTO | — | 201 | `4430ae68574f06a6041aa4d30476960088b7dc0a46280fcfe3a64ce50c0b5634` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world4.json` | AUTO | — | 1948 | `255cbc0027891d92d5a29a0efe14f3189554c3f36d250a99c8e6b77844296302` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world4.png.import` | AUTO | — | 200 | `afc838a52d8c1f16a9435e85b160bc9cdc37da39b757015bf8c7304c5344dc2d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world5.json` | AUTO | — | 3536 | `133f2ca16d4e01795c2f1737aeaca3090386f958a5c1dae2c2b289524c89d48c` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world5.png.import` | AUTO | — | 201 | `06a80fdad31a3756e67a538563e6eaecb7c4975d05309fc7e9c9160ca07bd3dd` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world6.json` | AUTO | — | 9267 | `6b0a7aa58d77d09aac47e2690634ef7a3fb65efb46a6b14a6841eef72cc6f838` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world6.png.import` | AUTO | — | 201 | `7327807b0f0c6a9965968248aed1a04f73819150c9ef8987e3c8e2222eb2865c` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world7.json` | AUTO | — | 5439 | `362a9de4f8879585076e897481d43f9e210a642b80c28c3904847f0ee63fcf04` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world7.png.import` | AUTO | — | 201 | `738a15c2d3f80e330a3409222ed5966d7f55b56640df2a4a3d58b260b7ec9266` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world8.json` | AUTO | — | 2901 | `5837506d6866dca212196170a372243b7ce168b873d636503a6840131b4a8668` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world8.png.import` | AUTO | — | 201 | `125c73bd97e6adeb1550ffdfda4fa9d9ebd1d5abe216da529121c82191ea0999` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/atlas_world9.json` | AUTO | — | 9670 | `28268edbc5aaec70cf50b9b2675e819b07130bc1690370d533f83cee816f6214` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/atlas_world9.png.import` | AUTO | — | 200 | `4cc052483d9ccd9dabe8772613e74d7cfef2da9ec6e031cece945ca98b67467f` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/det28_navyfx.json` | AUTO | — | 870 | `558d8523102a116c89af86c56b6814b85f147fe9b17ab13acbe56ca2a7c30c24` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/det28_navyfx.png.import` | AUTO | — | 201 | `d641cdbf75bb1ecfffe2ebe2e7c1e0f740d29236e7b0130eb54ff63fbb9b5198` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/det30_fx.json` | AUTO | — | 1421 | `13b0124c03ba53f04c571448d61a7e8a9c73eede8e2c8ad8cf17d5a99b65f0aa` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/sprites/det30_fx.png.import` | AUTO | — | 196 | `941350304beffee6dae01ec8bfece98e5813716589170eb86fbe382d04485607` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/lang_bg340.png.import` | AUTO | — | 199 | `d2b347efc6be08a1b16b99dca41be1dada420a4509ff66b53f48db37d6044507` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/style_cards29.png.import` | AUTO | — | 201 | `d70305d038a2c8d7b8c8bbb1e87fcd0a869590a313b707b4083901325624f02d` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/style_cards31.png.import` | AUTO | — | 202 | `cfed303b155098a2c67bbb5a93dd37521551c110c04adc1f3cf2190c83869f99` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/sprites/vfx19_clouds.png.import` | AUTO | — | 201 | `716d0f734582353b45010269506418c4886a66d991c507db7ef8999826eb3f0b` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/assets/video/opening.ogv` | METADATA | — | 7584379 | `8c64e6e07dfaeba55ac00c90fc66d8bccb01dbaaca12cb496010fae223ea963d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/01_econ_basics.ogv` | METADATA | — | 1387668 | `e1622157b9adf33be6aaccc510ae36f63b84501a775e24aa1291c9bf4471c8ec` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/02_econ_cities.ogv` | METADATA | — | 1265494 | `7eed12ef84498f4d1f10f1fff08097127700d37dc7e3a4b905e41b10ed304798` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/03_econ_ores.ogv` | METADATA | — | 1320776 | `86ae38aa2345d622e78a6dccde57a6f202671cadf68eb0c6c2579e1d03006b20` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/04_econ_chains.ogv` | METADATA | — | 1007735 | `762f78ad95e47c6fc5ee23eda0b6d155db0294c4c54ac504f0197673c225afca` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/05_trade_port.ogv` | METADATA | — | 1149591 | `8f112c8d093404fbf59a04c1364916be27162f1286e2a9c72dfca5392941b2e6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/06_rail_build.ogv` | METADATA | — | 1062379 | `3009e2b012fafcf990a6f21095ddc802837fb7a3058642e395f3c8702c6936a2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/07_supply.ogv` | METADATA | — | 716272 | `ad0e8e18bd126832809fd492138f34aed80efd302fc9fddc26e1dea8b154f86a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/08_army_barracks.ogv` | METADATA | — | 864548 | `4ba812411618eefbf1822639d5fdd07a05c725900e9b6d07a69b3d03355eeb05` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/09_army_orders.ogv` | METADATA | — | 1351713 | `20d1e537bdf86cd14b382690d4d7c5bb278bab8e3ee474fb9b9f60a8d5a7fa6b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/10_army_rail.ogv` | METADATA | — | 1471643 | `dd3feffb53abfd33bda20e4793dc294e435adcfbb18ca152f59b0059e9587d1e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/11_army_groups.ogv` | METADATA | — | 1416048 | `e423b3f0993eb2f0ed26fe3c5c68903ef39cfd48ebec17a2fbfb3c88c0160259` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/12_army_upkeep.ogv` | METADATA | — | 971867 | `366bbbf02f2a8568fdeaade2caa52e2b1cea8e0b83d363522e2299f50a00403d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/13_ad_who.ogv` | METADATA | — | 1946173 | `029032d5a8617032dd5aad6827eea2c463757097afd89b0a036ab1b1dac851b9` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/14_ad_radar_rules.ogv` | METADATA | — | 1438541 | `1c2bb02e2c65a9a91200dd14d445e8495a6096e236229460d5ebfef62e995d62` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/15_strike_drones.ogv` | METADATA | — | 1404247 | `cbb100331116623f169cd01a270c0c50da524483a471d6b09a5d9b33e7f401ca` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/16_strike_missiles.ogv` | METADATA | — | 1083595 | `b2bd61207c7afc0e8f6c69f20063296de491a2c2b5b17de49f47cbbf6f98a83d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/17_strike_air.ogv` | METADATA | — | 1009801 | `6ad00d170c8e5b35f3fdf481f154b3552d6033baf9eddf194b9a1c0b336df6ee` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/18_navy_basics.ogv` | METADATA | — | 1254081 | `147857b247ca728cafb03aaf69c2abd856faefe4702637d6520de38a6208e3ef` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/19_dip_treaties.ogv` | METADATA | — | 1121038 | `16714aa2b7358f33e735d7529fe15d68584d2bbe7e76264247b621a486c53309` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/20_dip_requests.ogv` | METADATA | — | 1172802 | `fe8b1c6a37be162d950ae3cf74db84594f17d4c9b299dd703a89d03a7109ea6c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/21_dip_war_peace.ogv` | METADATA | — | 1117286 | `5a15c09dca0e54d04b06a88487f305bccca58368cf2c0f1f7a90e7d6ba0636dc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/22_game_saves.ogv` | METADATA | — | 969320 | `7725a21428d11b9c869e7af9798cd26367d0cc442d9ffca2769a524475fd9a61` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/01_econ_basics.ogv` | METADATA | — | 1363644 | `5d01f63086c7f6946ee50cb498aca575dfa32ad5de2cf2f3977d99f300b89702` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/02_econ_cities.ogv` | METADATA | — | 1272715 | `8fae89608bf17cbde59a7d5529e6a290091259df6a39744c1b6767f718b59948` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/03_econ_ores.ogv` | METADATA | — | 1271079 | `b48a8157df78ac70ffedf9e85c2b6467492f94b033dd5b096bb8b21f8af90a64` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/04_econ_chains.ogv` | METADATA | — | 965554 | `a0a2d110d25f03375fa9e806fd0074fdbcf5359159293c0e14a1831c6a31bdfa` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/05_trade_port.ogv` | METADATA | — | 1089466 | `2365aaeba4e0520a5551967353984d78743c6c03e47c54f16027fa2e1d9500aa` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/06_rail_build.ogv` | METADATA | — | 1037213 | `d8ebe59ded41644b98f24d4ab507c1238ef447cf3effcc34fee08fcefa364a1e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/07_supply.ogv` | METADATA | — | 687677 | `4c3f58de128e3b16afb9bb61154c34d46060a97648a5f89f2d06314f31fff407` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/08_army_barracks.ogv` | METADATA | — | 847958 | `29a839431d7a5ffed98834823188fce60a4de9f3318d47d0fbcfe186945cdade` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/09_army_orders.ogv` | METADATA | — | 1249711 | `12c978669167187ca667a1d0a048908cae9b02c9d231895afb7abc762725d2cf` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/10_army_rail.ogv` | METADATA | — | 1470578 | `f06f1138fe0640f551c978849d61d23f353e6acb4386da3954e1abe596d8001e` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/11_army_groups.ogv` | METADATA | — | 1397169 | `362f2ea3a0f6d3e748c87830d1b43dc0aebce94db0a97b6ff71c54da021f9b3d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/12_army_upkeep.ogv` | METADATA | — | 971546 | `4e08258082ae2954f941f717ef57336cce0b80012d9aa76bb244d73f97a67317` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/13_ad_who.ogv` | METADATA | — | 1924043 | `3636ab643f5a12a5cde3baf83b9ab1e76494aba7f01743985bad29724b6b84d5` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/14_ad_radar_rules.ogv` | METADATA | — | 1445255 | `678a41e84483842e55c654d1f861dfc4a32629c0246b87cb96811d552648533b` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/15_strike_drones.ogv` | METADATA | — | 1365533 | `fb856f016e611d94b198a8c5ec8c0a449b474f10a0bc31fa0008b8628daf148f` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/16_strike_missiles.ogv` | METADATA | — | 1090377 | `c49425b4c39101bad8ccc9db75d5cb89d43acee07e2290b030201dbcec0d9498` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/17_strike_air.ogv` | METADATA | — | 1034120 | `7922875597e968a929ef073f6fd3ce28ec4c8c4481a19d4ce173fba50f0e96f6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/18_navy_basics.ogv` | METADATA | — | 1236639 | `3ea8632b23f7c385afb7f5d49ab9bae89e25a9531d139c871c7fcab1fbd5ac3a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/19_dip_treaties.ogv` | METADATA | — | 1122535 | `593eb6baaa7381e5cbf9e057e5d3975980372f4192818ac3dbd5f63addac574d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/20_dip_requests.ogv` | METADATA | — | 1099395 | `773f3cc8b06d1f842505d6f7ced193332eac347e67c1ac3724247cc3d4a82ac6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/21_dip_war_peace.ogv` | METADATA | — | 1066486 | `8bd0590ab4dcee7390f4e4e28e446472977f3779d6dd5fd4a7b52b0e735cb30a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/en/22_game_saves.ogv` | METADATA | — | 843989 | `54038e89f02a7acde9e742f7437c30582eafd56d4292de890d9ae8619298f8e4` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/tutorial_clips.json` | AUTO | — | 16733 | `28d49400a464ffa84eff858a6a8f8535d19602daa1f437d8861059886efcd89b` | All JSON values decoded; schema/atlas checks where applicable |
| `game/assets/video/tutorial/uk/01_econ_basics.ogv` | METADATA | — | 1402194 | `f87a574451e76f03767c27300d74e1b215a45d95c085c2c59c1d109047ac8226` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/02_econ_cities.ogv` | METADATA | — | 1274009 | `c1c5a953cf65bd8b4de3040c6a73782e17273effe44d722dfe3adff324053e46` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/03_econ_ores.ogv` | METADATA | — | 1333742 | `0176cdb325581aafaa176dc99db62222c1836eaed96ef61a6ef942cda2372440` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/04_econ_chains.ogv` | METADATA | — | 1009069 | `32097409ed81d8807977a819ee00443d2a0009da07faf7a7193662686b7082b3` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/05_trade_port.ogv` | METADATA | — | 1141015 | `da52014713f4aca04d78f470975c2e288d490546a130479e8c3844e1862ecfbb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/06_rail_build.ogv` | METADATA | — | 1065136 | `f3c83a4eed8783e4c9d3c0cbde9175b5d45ea7d1c3df5fd3597a323d8606e7ff` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/07_supply.ogv` | METADATA | — | 734672 | `182250a432d44af9ad45e4fbe29b5069a11932111772f847c02d417c8697b7fc` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/08_army_barracks.ogv` | METADATA | — | 848273 | `55e8ca29b396f6396b1c74809cef3f10327c78e68b3e4cb85a554c8a286653bb` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/09_army_orders.ogv` | METADATA | — | 1318954 | `fa808ab95ce3c2aa6c6fdf08299efaf016d486b81a80c44be9fb5b2ebdc36052` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/10_army_rail.ogv` | METADATA | — | 1464318 | `9934ebe3f64c2c9e022a2e9c814efd17d9a1d4f1e71f9a466c3f62eea8ef0f02` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/11_army_groups.ogv` | METADATA | — | 1386963 | `fc8c5908899558cd170154821c859d5bed8eb799c86bf12f38d5b2aa1e4559e2` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/12_army_upkeep.ogv` | METADATA | — | 979811 | `eebc91e93f99908e48a35a8f1792396e62aefbd0fedc4526723149a39a602108` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/13_ad_who.ogv` | METADATA | — | 1904090 | `04c14568d2e0e1d6189b1c9d0d4d82978d889fcf89c3ef850c6f335d7d2e7aea` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/14_ad_radar_rules.ogv` | METADATA | — | 1430461 | `4dc2c56d430c070d91b0f44930fb809107dd21bf07ab11fee30d695eb3040bcd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/15_strike_drones.ogv` | METADATA | — | 1398734 | `8e90bf875690e8573800f2c8f7793e10d5325f079047e0a6b42fad1208b71931` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/16_strike_missiles.ogv` | METADATA | — | 1063254 | `b1e3d42076f12b3b33dc3885c61fd6adaaa32dc11b8fc110c02a344173144ad6` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/17_strike_air.ogv` | METADATA | — | 1007271 | `cd22fba711403ec1ffbaf76f7ff614f6e7de27bbc6264e070ecbaa157e63817d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/18_navy_basics.ogv` | METADATA | — | 1224345 | `b3d48158a5913ec2088831ba3a1955e9247020f58885daf6a2a5244e114e8a8a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/19_dip_treaties.ogv` | METADATA | — | 1123190 | `c6e8e56e957ae5656c2215e7907b348959f0210751f21f72c49b2ac338c3224a` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/20_dip_requests.ogv` | METADATA | — | 1156195 | `f636c141bba2d2f6d6ad965e0fb70f7ea8dc34a4cebafafc187a286865bbbe4d` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/21_dip_war_peace.ogv` | METADATA | — | 1090826 | `b35cec9e0827006f212c86cd359b7723d6753870e232b39e035148d966546e24` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/assets/video/tutorial/uk/22_game_saves.ogv` | METADATA | — | 978379 | `5b9ebd0c8bbd6cc75cbc666869c9c772264e610ec2ea5055ef3ccbc16a0c6f46` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/core/air_sfx.gd` | AUTO | — | 3777 | `906ec811450b319cacf7f5ba4838e1e6733fdbf723b980e7d603726d0dca2435` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/flag_maker.gd` | AUTO | — | 30441 | `b79292ed14a70b2148e33d8b4fbd2af19b1a49ccf0f10caf499de7e59bafe59a` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/hash32.gd` | FULL | 1–19 | 345 | `18e793f47905b8b4f2e46eaa0fd3eb39d3d210bf13d6c23e7e62fb325b971c66` | Manual full text + static analysis |
| `game/core/loc.gd` | FULL | 1–554 | 14470 | `abd0400582e8aba85210044ec9560693d8305740662a0577133eb267c62de181` | Manual full text + static analysis |
| `game/core/name_gen.gd` | AUTO | — | 20241 | `9077b15a70e8714d931161e3cbaa2fb1c4e79a5564d3abcd231f4cf6f0734f56` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/navy_sfx.gd` | AUTO | — | 8758 | `002eafe35ab082329b0b09de6b50ab2387bb97f5239f83b311bd3e812c6e5fdc` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/palette.gd` | AUTO | — | 447 | `9caf357803a3b15a7f98f8066bdf79b9a1f619fe0bd3521037b94ad67573fb3d` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/rng.gd` | FULL | 1–60 | 1144 | `0a9e0e794f55e11d6e2ef80558672d5f5c7866acddb22840528a05dd644a5d40` | Manual full text + static analysis |
| `game/core/sfx.gd` | PARTIAL+AUTO | 1–170 | 36142 | `7c20300205b72f0e120477ee9b23f85c79410cf72d425b6538cf5b106cec3189` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/soundscape.gd` | AUTO | — | 9608 | `ba78e8dd42e0faba1dbb1d2fcf6fa9c4f0a8f1978e1df8d39ece61aee66cb5cb` | Manual semantic remainder NEEDS INSPECTION |
| `game/core/sprite_atlas.gd` | FULL | 1–48 | 1483 | `033f24c12d815e94d3e939f3018fb11a5e48689036afaaf956d4f31ebc53965f` | Manual full text + static analysis |
| `game/game/ad_relocate.gd` | AUTO | — | 12701 | `8a2b45302850d6e04f3df74b1d458f2e47b675fff916daa8b727126743d3acf2` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ad_trip.gd` | AUTO | — | 6642 | `87e8cc014df7d2d317ee9f5047c5ddbe323547523ab032baf805e2fc385e4327` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/aftermath.gd` | AUTO | — | 20452 | `76650157f3b9673d2c6e259b6c80beff18b3d674d30d9670a4a2497b42fc7fec` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ai.gd` | PARTIAL+AUTO | 1–165, 350–640 | 93637 | `12457145eb82f8b9a98dfced7ebae8b899cc5dc794de9d41eb9cad662195cd44` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ai_persona.gd` | FULL | 1–57 | 2134 | `41802b454c7081afd9bad667383c35be6ef87e36c3bd044a288efd8483d61518` | Manual full text + static analysis |
| `game/game/air.gd` | PARTIAL+AUTO | 1–145 | 85654 | `0b962c518bff3bf822e40f9a031d6354330bc96f24bede665292787422fe247c` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/air_duel.gd` | AUTO | — | 5747 | `2480258acb5f887bbc81fbbd63e38b6a384706c55b0142d1d8d9f19cbd2285a9` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/air_wreck.gd` | AUTO | — | 8032 | `4cea2ab798802946ef8305eb62f75f5455caeeaed7cde9ddce5cf15b9ae1de65` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/aircraft.gd` | FULL | 1–80 | 1717 | `b7a763ce9d09476a3ab3487b92f4ec2f5a80671ae2f157b26a3ec584f19971e5` | Manual full text + static analysis |
| `game/game/alliances.gd` | AUTO | — | 26818 | `aae6382032df2312b00c0148e7b0e6ada21bcb1d4dc09bdcb495eb23b91fa88c` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ally_care.gd` | AUTO | — | 14976 | `780e836030ee5c81ed995dee61cc0e174188c6bb337cb564b378e44269f5b671` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ally_rift.gd` | AUTO | — | 13525 | `ee778992f2dd610436b3617ddf0894e690920536230f3e4d44d3f1c951386fcf` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/arch_style.gd` | AUTO | — | 11774 | `c402899950faf3d9562e1f3f9a4d0887201300b0b80c91290d2d60e17d6fc9c3` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/army.gd` | PARTIAL+AUTO | 1–150, 362–465, 620–670 | 85344 | `8dfad5adb21c6ea609f9ec12a260be43dc332cae968c4cffdbb9ea5dbddae892` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/army_fire.gd` | PARTIAL+AUTO | 1–112, 365–574 | 23995 | `dcdb7c15c0d569c3b35179780006a7b3dde4767988849464baf1ef6cc5ea9c77` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/army_groups.gd` | AUTO | — | 23281 | `9c43704040f23cf6d9d2185e1548432d8f2a7d6a83a6d613c00babe874da6cf2` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/army_reinf.gd` | AUTO | — | 9067 | `531cbcf2c6eee3cb6007844ddc3579dceb6bf2953a9ae631cca88d953de178b0` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/army_tac.gd` | AUTO | — | 29262 | `b994f9f263fed56d6eaba5bf64a8af1efc6e1a3adbdb9475c21a68b018d6962a` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/auto_cmd.gd` | AUTO | — | 21488 | `afdf5763c7dbbc1110425998a384d4c6418c79c552399240fb88365ff389900f` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/battle_watch.gd` | AUTO | — | 15164 | `7324ab089fdbad1140307ce03b2556f9c082b748334e24edd8d6676fbab36bf8` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/border_fill.gd` | AUTO | — | 27972 | `49d3d54bba2ee065b44ca721832081b60d3e042555eb15631adf8708b917c442` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/border_gap.gd` | AUTO | — | 7563 | `7ad0372bc6ccbc079fc47e59e58c8503603b781f2c54cbfa29a6bfe845c98b9d` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/border_posts.gd` | AUTO | — | 17441 | `9a5d3ba247b50394031a48b921b9a42e2f19776d9e5e3ddf5f3d239fdc41d6fa` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/bridge.gd` | FULL | 1–150 | 3266 | `5d2cad7e7350ca071dbc9f2d2668a263f778eb926b581a1ba3339ceabb08b9e7` | Manual full text + static analysis |
| `game/game/bridge_guard.gd` | AUTO | — | 15497 | `c0d0c0f1235f74b4fc5a384909b7c1ed0fb8d63c1197557ebda6219ce61a139b` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/cad344.gd` | FULL | 1–125 | 1841 | `38be4d6f0006e58139433f10ec3951442a11a453db2ec653f6a593587aa08d3c` | Manual full text + static analysis |
| `game/game/city.gd` | FULL | 1–52 | 1052 | `22e4329eb863b55dfabb29007b2926bc7007dde5bf2a4445ef45808217bc1111` | Manual full text + static analysis |
| `game/game/colony_look.gd` | AUTO | — | 3117 | `c36b449a73abedded33b3d673278ba1624e3bf93b98eae92ddbeb8ab48b089fb` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/country.gd` | FULL | 1–146 | 3231 | `1708086e536a4a80fe2208087eb1b97aca6d365d7ead185bda22203eb2e9f32d` | Manual full text + static analysis |
| `game/game/defense.gd` | AUTO | — | 28716 | `bd04257b6a04f342bc676f0f62e1d7900cf38262b760716055550ba6015b177e` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/depot.gd` | AUTO | — | 17422 | `2ce02f81ac18648e3585a48b0022ceccbb07938b91c318a335c0baeb11967b25` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/dip_react.gd` | AUTO | — | 40745 | `5fdb6c2f9583d377ee767e9e20f445179e9ce785e59992f651d271dc5199075d` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/dip_requests.gd` | AUTO | — | 61259 | `b13ee144111cb1150855c64e0df6f7fedd1a3f591b23392b7670867a6838e6d3` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/diplomacy.gd` | PARTIAL+AUTO | 1–130 | 64845 | `ff69ae1d5a108922599a06c0816c8670c8298cc2f75b7f29c810fa8b7768cb79` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/diplomacy/dip_allies.gd` | AUTO | — | 52818 | `d0eae5405874c3fd7035dc47604305dc574e524e4c0949a574824b814a43aeae` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/diplomacy/dip_base.gd` | PARTIAL+AUTO | 1–200 | 15936 | `e1690558fa407048dbd71f9a54947720eb33d63c9b3f42810f22878db25ef0ea` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/diplomacy/dip_rules.gd` | AUTO | — | 54415 | `38b12c2bbddbedd552cfe95dca812ef86f7ffcbf9f4108f004129bdae3e1f3a3` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/drone.gd` | FULL | 1–63 | 1455 | `99504dfc140707ef1299fa0a212e60c6d2a7b0d1a9a50b044ac47fa98c5acba4` | Manual full text + static analysis |
| `game/game/drone_brain.gd` | AUTO | — | 20087 | `1fa4f15cd4a704ae16fa73d34dc9dc6098b98c4b9c36a8b1295a47c304842ebc` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/econ_guide.gd` | AUTO | — | 75082 | `f1928f4ccfd59f16324ec3666f00aab626fa1b9f4c76bb6c2cfbb64439128e5f` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/econ_rates.gd` | AUTO | — | 20995 | `ca94718f44e093fc75649d1104df56e3a637b44ca11f82eeeb00525c388840e1` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/economy.gd` | FULL | 1–521 | 17781 | `e2e4426cac8ab56dd92e811d7b43ebb8b576e1a892611a82bda2934fc3fe826d` | Manual full text + static analysis |
| `game/game/economy/eco_base.gd` | FULL | 1–385 | 15772 | `989d424baa4622a4a462faf51685cf508eb5648eb19554f28cbbbab8e5f0b8dc` | Manual full text + static analysis |
| `game/game/economy/eco_core.gd` | PARTIAL+AUTO | 1–230, 402–585, 676–872, 881–1040, 1250–1430, 1825–1937 | 60360 | `ada6557429f157f425af1c3bdc82e4799a58a6e8cffa9213c9df162b906babcf` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/economy/eco_trade.gd` | AUTO | — | 59327 | `068e48c029f2e1a96ae84548f1d6bc9a3d793166b795b9e086d76e336daa0901` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/facility.gd` | FULL | 1–147 | 3324 | `d3229df9171d701f4588033af340315b162df2e4a3a53c19e391ac8ee1744d30` | Manual full text + static analysis |
| `game/game/front_plan.gd` | AUTO | — | 127843 | `3ddb26033c331bd46103961054762d457d618e65f57f4c2f93bdae7d208e0745` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/game_config.gd` | FULL | 1–232 | 5840 | `8c057a0120542faa93a76f9ba3287a07d243a007bf22c5b0ce5d8cd2ef9399a5` | Manual full text + static analysis |
| `game/game/game_world.gd` | FULL | 1–551 | 17727 | `03bd81b5ea4fd36a1f249e5e3974124704e7a965f719bbfd360149564c92f716` | Manual full text + static analysis |
| `game/game/game_world/gw_base.gd` | FULL | 1–339 | 8762 | `1e7287e152779d795cf7e04ce1680814c13129a13a5e424c91b22f870d3acdce` | Manual full text + static analysis |
| `game/game/game_world/gw_infra.gd` | PARTIAL+AUTO | 1–435 | 36332 | `b8ee7df24e6e7f29ddd170ab24b16203f1c7ac60b37acd42185eb98dacd6f422` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/game_world/gw_map.gd` | PARTIAL+AUTO | 875–908 | 26346 | `2e7fc58fef390a470c71a427d68b694cf593c55a7b89b3205ba11da063dbe0ea` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/game_world/gw_states.gd` | PARTIAL+AUTO | 671–960 | 29417 | `8cd68eca51776e94e8d80dd082a9b5de736e4d04faf7ecbe846174d548546f38` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/main.gd` | FULL | 1–1645 | 68388 | `3646e6094da9cb1ebcec68c3ddcfd919bb4dcd28115dcce2809d4c55c4fc8cbf` | Manual full text + static analysis |
| `game/game/main.tscn.remap` | FULL | 1–3 | 97 | `2253fa1538fa52e5ee28e4d41bc9ce4e420b29f5157a5ed20f20381249d8b683` | Manual full text + static analysis |
| `game/game/main/main_base.gd` | FULL | 1–200 | 7651 | `3f5b3d1374c3715ec175fa902ea32877a5098371ba2108fd6399112b0e8b197c` | Manual full text + static analysis |
| `game/game/main/main_core.gd` | PARTIAL+AUTO | 1–160, 187–211, 970–1010 | 39185 | `cfce2bb3d9dded920c2668a3a8fbc22720c5e7c04ba1cccae8be24bc08897dd1` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/main/main_input.gd` | AUTO | — | 35466 | `2470acc7f81256236d0a3e27f81e4ae458f8e2153dede5308a507a48bb4e3591` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/main/main_strike.gd` | AUTO | — | 26170 | `be2805e0e2cab75e10549ef6de4302431a37cfe9b80822db61c2fff5a421f036` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/match.gd` | FULL | 1–325 | 8816 | `2d9f5cde09cb6808924a3d024fa553b2b36d564bc18136980c0362c19c64fb78` | Manual full text + static analysis |
| `game/game/military.gd` | PARTIAL+AUTO | 1–215, 1110–1133 | 37734 | `d83db6b6aee976dc262c9f23fee6bd2cd30248b1c928609ec253e85d63692e00` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/military/mil_base.gd` | PARTIAL+AUTO | 1–180 | 21181 | `5dbc79ac19191dedc2db19ad44b2d6bf4fb5ecb665f2ae8592497ec930a286e8` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/military/mil_build.gd` | AUTO | — | 59574 | `fcc102e531379b005a732d001a75db378a4e8385f6272d4f89a11c52139c375c` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/military/mil_strike.gd` | AUTO | — | 39434 | `a95ed2a2b7319773bf5c60711d3948a88ce7f34d45f04bf39f76d486705d5e67` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/missile.gd` | FULL | 1–72 | 1388 | `12c36df9941fcf78416e51782f56bc11e035bb27fa7b4154cf269c26ea4e71ac` | Manual full text + static analysis |
| `game/game/nature.gd` | AUTO | — | 8526 | `79e123e5b01e10636c48fb90b48f7525e0b3569d4c42d114b3104ecab2a35a6a` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/naval.gd` | PARTIAL+AUTO | 1700–1759 | 58101 | `00c27b5d1d4e9d2424d4dec823d9520a188bfc387363bb7b8e026af14bc057f0` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/navy.gd` | PARTIAL+AUTO | 1–190, 1069–1197, 1396–1485, 2980–3064 | 97340 | `c38f8ec550a515a51d04d8f650cc68f33813cf89ad27301ab9a4c7874876b861` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/navy_art.gd` | AUTO | — | 25663 | `90d0cd1c0a9882b65e4e2d1bde214fbb91e07ab68a68ab95cf4ac1af08a45f71` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/navy_fleets.gd` | AUTO | — | 28432 | `e558667df04ca513154628c94e155cc0a206dd6f8a70a59b20dae5414c456884` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/navy_strike.gd` | AUTO | — | 12693 | `28a8591596990a52d2d6eda1db0ea40778650e61a7a04deafe51b108d48441da` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/nuclear.gd` | AUTO | — | 13789 | `d7b132d7254317b5495e0a1f7df31b21a279bc4b96d108ae9428d8cdeb76abe8` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/operations.gd` | PARTIAL+AUTO | 2323–2366 | 115388 | `21d354fcbe683c3d872ab9b262638ab9c2a71c5e634a9f36a9cc14a705ecb5e0` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/peace_conf.gd` | AUTO | — | 44596 | `6a4a5349240670d2eaaf00391cfdcfcb3fe81a8f50911b21795f0cd2202435da` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/port.gd` | AUTO | — | 26402 | `5e99f4f45adfc890cbb78dce577ca1f327928a9c3cc84bfd6523647638dc9665` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/power_status.gd` | AUTO | — | 24342 | `d0981d325c196cf1c8d3f2003d21ebe6723e5a2c2caa6b9c17ecf65eb888fe41` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/protect.gd` | AUTO | — | 33521 | `0bfc4063ced55c4ea04725ed68db16cd5fdabaa5ff0e111632f93ec3a9e1d8b0` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/rail.gd` | PARTIAL+AUTO | 483–550, 735–895 | 74814 | `b9bd50a2ba8172ad603b5d6f6253e7bb5dd7a26540582388f21578c03a135e0f` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/rail_troops.gd` | AUTO | — | 22832 | `62bf0cad2097322850b1776fce6568d340d3c2bff57889bea757eb773792e671` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/ranked_rules.gd` | AUTO | — | 5422 | `765925eb6b3318972695bde3cfa70a9aa646445c42096cf8e70c410a680cd604` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/recon.gd` | PARTIAL+AUTO | 80–100, 812–860 | 26022 | `ba692b167edbcbd58a67dbe5cd59f72a8d7aa969349eb9be8c3956d0a350da5c` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/road_detour.gd` | AUTO | — | 6640 | `2ae817b95e001d0ac3003a04847128ab374f5a81ddaa4bef1708366773113b44` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/save.gd` | FULL | 1–1234 | 36960 | `b5ea99be2c02537003117f4b2818b8af232cf886e9b1d32917b2c34edd4fa6a4` | Manual full text + static analysis |
| `game/game/save_slots.gd` | FULL | 1–466 | 12853 | `32398544ef0f019ab6998cbfde351514e1a166565a99f74c908dec2a3b6f0f12` | Manual full text + static analysis |
| `game/game/ship.gd` | FULL | 1–95 | 2164 | `6bb1c526d50ecc880c5ded61490d2980d50b131bf6a6969541b3bf6d2c9b39fd` | Manual full text + static analysis |
| `game/game/sky_cover.gd` | AUTO | — | 31024 | `4b4b042f50824a8779569b1dbae8323f8da9b6cd9a30afc14f270de3a9fb99a5` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/strike_hub.gd` | AUTO | — | 15070 | `aea0906c685b6740192d6e9cc5c45bfe9bad37b89fc03a64dfc2a43a7e636014` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/strike_sense.gd` | AUTO | — | 6701 | `2bf36b79c1f910a5deca8789d5eb87853f2424550247a8d768ab0f86b2253e83` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/supply.gd` | PARTIAL+AUTO | 110–150, 1400–1560 | 67094 | `218c7bf893f9bc18be4fc8a01a0a596605cfabb76494bae9ccbb350a4d2100ac` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/trade331.gd` | AUTO | — | 35947 | `e917ae3ce1a031be122cc1234b8ca37310544972b40f3d042f092839b7ca1bbf` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/unit.gd` | FULL | 1–89 | 2089 | `ef22247c0ccfd18b3f30306a60edb1599358904717ff07ae2e2b9fb1991e859a` | Manual full text + static analysis |
| `game/game/upkeep335.gd` | AUTO | — | 31054 | `f1b6dff92a96d22a1fb8b760572f005fa6abdd9e53e5da92299d4af21a11075c` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/urban.gd` | AUTO | — | 12658 | `272ba91d134a33a07bd5806033b67c371c04034956f02b7f4ccb65f0c67f289f` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/urban_hold.gd` | AUTO | — | 31338 | `08832b7c891d2e2321f7374eeb77a3551efca923e5672a42147790e3f4c87826` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/vision.gd` | PARTIAL+AUTO | 1–115, 303–400, 640–731 | 18553 | `b431dba943a9f5e21e8ce791b76a88ed7115df1e258073a851302f7df7ddb291` | Manual semantic remainder NEEDS INSPECTION |
| `game/game/world_drama.gd` | AUTO | — | 76983 | `25ac768fc8bf62965eb4272cb1f2ab94dba32ea7015926926c9b05516413ec82` | Manual semantic remainder NEEDS INSPECTION |
| `game/icon.svg` | AUTO | — | 995 | `6c80384360a5b269d1054bfb27241258154e2cc8167c522016fdc1820e84e0f8` | Manual semantic remainder NEEDS INSPECTION |
| `game/icon.svg.import` | AUTO | — | 193 | `74ce355cc8885afae9a90953e5f5b974a9ab820a9b64f684bf096f9c2a3b41b0` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/icon_ios.png.import` | AUTO | — | 197 | `2584f1c27cfa02c887e2764feed951303cc212b301d75b7a3205a06edf960dd1` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/net/account.gd` | AUTO | — | 16595 | `2b45793b91c4ddd9b078dd8838d0782408aac08e311c02ea62d36e001dd7413a` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/api.gd` | FULL | 1–164 | 7397 | `eb5d3204cc9c5927be7abd1d9580181546a4268540ce21d8af922bab2c06db08` | Manual full text + static analysis |
| `game/net/device_check.gd` | FULL | 1–143 | 4428 | `57f3ba74710b2aabf71edb5dc622db29cd065d431ba0336864434757594d7f6c` | Manual full text + static analysis |
| `game/net/dip_chat.gd` | AUTO | — | 9884 | `2f7611372369f7a4c46aa207c9b9751c8fc68fcc1b29620e865136c50f9ab32e` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/ed25519.gd` | AUTO | — | 10847 | `9b77f83741d01c703430029cab445ced8402320ef7af7ad4e8deaa75f56838c8` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/lan_discovery.gd` | FULL | 1–164 | 4102 | `e37691592b029a1c1c6e8eb5f34f7a5861c548c0ee2f5484df9efafaaf476219` | Manual full text + static analysis |
| `game/net/net.cfg` | AUTO | — | 476 | `0668f47cb713043268108035ffe834366f2f898db86be4d8bc7421ef26fb7b97` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/net_codec.gd` | FULL | 1–113 | 2667 | `0b306377b51229bcb0d676f8b592f8f83608e1d2018b018bea45bb5ff6086b17` | Manual full text + static analysis |
| `game/net/net_config.gd` | FULL | 1–200 | 5458 | `7e89779bf99a301b9696edceb24a914857f3be1caa26cb4e6d2fec949fe0e6c9` | Manual full text + static analysis |
| `game/net/net_hash.gd` | FULL | 1–218 | 8445 | `6676a7fff555ad40a710feb3ed804fff376dcdf277c496174285cc47fd07fda9` | Manual full text + static analysis |
| `game/net/net_session.gd` | FULL | 1–3045 | 130931 | `80776a9278c8b41cf7f002d184dcf047c058b4b2b0cb7cbcfbd09d6d817ca81f` | Manual full text + static analysis |
| `game/net/net_tls.gd` | FULL | 1–32 | 777 | `13cccc658f09e4433c46089c43afe369128c4d617f56d66d975f126663c091b8` | Manual full text + static analysis |
| `game/net/ranked.gd` | AUTO | — | 4387 | `b822f51c63987dd67cdff7a6aaf7af6929926c4c2b7bd7ee115d4ea71f50306b` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/reports.gd` | AUTO | — | 3020 | `6356156633348df9a1236301745515c3fe1d3855bf28a41f2a64cb3f74debd49` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/room_browser.gd` | AUTO | — | 3517 | `386ab26014731e10a151929839cffabf3ad96ea8c3de4ffeddf3d56b9486e01c` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/rtc_link.gd` | PARTIAL+AUTO | 1–180 | 14308 | `fdf8bd86438972f6d7ead097050e70947f225a68d4bbc071a2d21b6d8b7d574d` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/server/signal_server.gd` | AUTO | — | 13368 | `9a389f9f0a6d9830a3975ab4172a099f88c895566e6bad08513d7a4a207a78f6` | Manual semantic remainder NEEDS INSPECTION |
| `game/net/tls/backend_roots.crt` | AUTO | — | 16548 | `798fba66e54dbbc03a11be9e540adc790f3b4a5f935192d1dbc9e21cdd9e745b` | UTF-8 PEM text analyzed; certificate trust/expiry NOT validated |
| `game/net/ws_tunnel_peer.gd` | FULL | 1–175 | 3335 | `1e35fb2a664305924f5a07c31132b79c12ad46b39f86a2b4d4d2b449b020f8b4` | Manual full text + static analysis |
| `game/override.cfg` | FULL | 1–14 | 248 | `b085768f5e40bb33f0a55bf0477fdf6fb490ce1905cb713e2757689a57bca720` | Manual full text + static analysis |
| `game/pc/army_select.gd` | AUTO | — | 21935 | `db9f1ad5ab29d3f325af380a426144d1b81cd28919e54de06296e6ff5ad49fd8` | Manual semantic remainder NEEDS INSPECTION |
| `game/pc/boot.tscn` | FULL | 1–6 | 157 | `62733b56a263b9f50c3dfb826f9d778cc49c713710b5df8f1287e9c22358da04` | Manual full text + static analysis |
| `game/pc/pc_port.gd` | FULL | 1–152 | 4631 | `014dab5f86e169a774936d7a4bd70a0e64a0460a6a13b3f56925733e71ee70cf` | Manual full text + static analysis |
| `game/pc/steam_mock.gd` | FULL | 1–245 | 7152 | `6a51064f8c87bdb8bf6478698fa18462b995a6dfb5d35005e652b249f6eb9111` | Manual full text + static analysis |
| `game/pc/steam_net.gd` | FULL | 1–253 | 7390 | `7ecb25ac18ff81a55a1204e4c8be04034e4bc6d4944ce2cdcf134f79ddc14490` | Manual full text + static analysis |
| `game/pc/steam_peer.gd` | FULL | 1–336 | 9974 | `570b8bb3d184678eb7388a4dec541c434d37e7e21b9ac31984a0314de7adc69a` | Manual full text + static analysis |
| `game/pc/updater.gd` | FULL | 1–436 | 17209 | `f59f09e0f3b8b43b60b58fd23133a1f79e565ef2602b6ee5615624091caccd25` | Manual full text + static analysis |
| `game/pc/version.cfg` | FULL | 1–7 | 199 | `2f6b72831961eef21826ee6e2e9efca906d994449dfd78c966416d4f352b0c1c` | Manual full text + static analysis |
| `game/project.binary` | METADATA | — | 1632 | `9aacede7e6b303aeb73c6028318722047cff68eb4b66c032ca4e98f3247215b0` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/splash.png` | METADATA | — | 20678 | `b30abfd4efd65f80b9a72abadaeb4c740518301736a83c9618ca59b942532fab` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `game/splash.png.import` | AUTO | — | 194 | `701497a18d21403098372bc1529c8d238bf49fa2df512f908ef597a5392906ec` | Full remap text parsed; target exists; import runtime NOT tested |
| `game/translations/en.po` | AUTO | — | 962551 | `cc511c80c06220202e84ede4b69228b9ce70cf38ac1303996716dabc7f55514d` | All entries parsed; translation meaning/UI NOT verified |
| `game/translations/es.po` | AUTO | — | 510253 | `d805764f3bff0e994a4e9ef19b7702365275409e725a0faee164da768c117d5c` | All entries parsed; translation meaning/UI NOT verified |
| `game/translations/ru.po` | AUTO | — | 5356 | `36d49a7fa907b7de671bf6b980d484775613045a6b148ac67037ea8eb0c4d9f7` | All entries parsed; translation meaning/UI NOT verified |
| `game/translations/uk.po` | AUTO | — | 1124723 | `5ca90a78b9460c311271cc95b9318120382913bf2165a7f345d3bf548d0c6bae` | All entries parsed; translation meaning/UI NOT verified |
| `game/ui/cosmetics.gd` | AUTO | — | 3418 | `f8202e865e64f2991ae8633fb8bda1227fad2c3d37d11b32ce86401744401b9d` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/cosmetics.json` | AUTO | — | 19051 | `fbcde083cf0b2104af77d184c9245554f6142a19eaeab17a381a953e0dd4839b` | All JSON values decoded; schema/atlas checks where applicable |
| `game/ui/custom_bots.gd` | AUTO | — | 23362 | `b70f3f49f2ed7f3bb2af1b5d0f9eb086a2afbe65cd4e8a7c3a63799ee9f96182` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/flag_editor.gd` | AUTO | — | 31178 | `0143b02844b0879fe872b5cc31ad0e12e7cd8e2a1129d27e47b736435d5c4c1a` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud.gd` | AUTO | — | 27438 | `a29ae2f61abcd03d5063b72a13103f496f3a1ae1d336a24161f738533fd7ad37` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_army.gd` | AUTO | — | 8639 | `a25c728ed34bd189219a5f15b59990500e6866bb8ed3841c41e6d922995f179a` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_base.gd` | AUTO | — | 22602 | `e11b5c479d2fd30f16f6da266bf54aff7029d2eedce8212f04fd3cf142490f32` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_cards.gd` | AUTO | — | 55813 | `1273586a02b1e34ae593d17b050f7ea65a02fa8cd349bf6400845c37f8aff41b` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_dip.gd` | AUTO | — | 33363 | `19dbe2029555791fe29654189f4242117498805643bacafa89951e8f74cacfd9` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_dock.gd` | AUTO | — | 8487 | `2d4dc7a6217922b0727d95a1fd8f844a104b964598b31d7a82442a23e1a5e8d1` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_econ.gd` | AUTO | — | 13322 | `69ded61c84cb9a461ee993c50ee75ba4dad037bc78de24f0b3185e8a8a79780e` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_keys.gd` | AUTO | — | 36630 | `2cb580065c539eccbbe2b231213cd12079154543618bfad8dd41c4ea2985afd1` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_kit.gd` | AUTO | — | 16357 | `735678e02c0f933273e3cd64250af7a7b34dc2f3ab9cd2c880e2876abdb9f0cd` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_lane.gd` | AUTO | — | 11694 | `c5d911666e43a3fd4f9ff89534b6729482b0f6085e9afe70447e6fab3d2f61a2` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_ops.gd` | AUTO | — | 9799 | `32484292e47a950aa19dd30503b8399ad566d81e1c01c91834369abe761c8ebd` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/hud/hud_stack.gd` | AUTO | — | 37736 | `af60c54c5761553e2d4bda27604a5e2e2e7581150f241c48efa8c21220895212` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/lang_picker.gd` | FULL | 1–505 | 16121 | `1d65cba0250e8ac82bae78710e8cff62e3dcaa6e487cdb64a303e66d29cfa71c` | Manual full text + static analysis |
| `game/ui/loading.gd` | AUTO | — | 11348 | `719ccdec4c9cbda244e0c1098500fa1b1ae3c76a8796228f7ec163bb1ce6fe31` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/map_preview.gd` | AUTO | — | 4359 | `292c931ccae9f89d2ad3eedfa40fd0e599280339660a384e82f0449889a9ac87` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/menus.gd` | PARTIAL+AUTO | 1–135 | 168719 | `f45f9130cdf8260106b8582e0dec159e94fb2423dfe3c3455e85b1beb5a4b2ab` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/mp_kit.gd` | AUTO | — | 31556 | `334a9b96fd8e3faf622b75f42bbfec357bff41c210d1aadd4ba2f5ad8eb9dbe2` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/opening.gd` | FULL | 1–239 | 6734 | `bac27a1493225c2260f8c229bb4b4c51be233df6d2f43e7a643517c4491c66c4` | Manual full text + static analysis |
| `game/ui/perf_probe.gd` | AUTO | — | 12431 | `da580bb96ad87d7b56056dfa33647c59af5bc855e14a4deb6b96942ec093e9bd` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/report_screen.gd` | AUTO | — | 10112 | `95f8fc854dcb696d79c755646f0d6eeffae0a4ec550632eaa1bccca17d37a13f` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/route_overlay.gd` | AUTO | — | 24674 | `2407a6f5b533252f3cf9468e9f946c324578bf478441745ae4e18929d276c7a1` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/saves_ui.gd` | AUTO | — | 33716 | `70a41a8c28314799eba9bbd61cf82f4fbd1cf52cd4ed057f34ca948be1afad93` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/tutorial.gd` | AUTO | — | 24002 | `673ec28a10275c967c2f598085e9c9f75c0fe36cb7ecd52f846e5b95e64e71c6` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/ad_rules_sheet.gd` | AUTO | — | 19385 | `1bdfe2d41c9728c12e033c3e2c68b69a1d8ae04d80c8de4338d29e52f0a59f48` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/ally_sheet.gd` | AUTO | — | 9027 | `fad60f5094cbc762310a63e12a7a6000172758cb7ee4e69cd212a51452b09867` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/arm_kit.gd` | AUTO | — | 8217 | `15e56f496fe46e93f74c12adb187f29794b7398e6a65fcd4ee0aea4e2ed26ba9` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_budget.gd` | AUTO | — | 18555 | `25a473f58db42e433eea0d2aa00daa6a1e2379c6665f0e39aaf8e42379d8fb3f` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_dock.gd` | AUTO | — | 81682 | `c039bf432de385c26632efa7fc8ba28fb110f5c4dab363880b214bab416474e7` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_row.gd` | AUTO | — | 10447 | `b22b6ceab03adba495612b3c13f449f25e3aa018e79a9e56b98b4630416eec45` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_sheet.gd` | AUTO | — | 157 | `306f49ffd324638bc8bec28414fa31b9497fcff82709394fc455f16d2dbf5ec5` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_state.gd` | AUTO | — | 6679 | `5bd994835e772e7d50b41e92a97f473d83608b7a9b2a455984c9f16590e77d5a` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_store.gd` | AUTO | — | 5998 | `cfbee77291a1827b8f8d798cbfec806bd1c92d90abb8bc32b8d0bb43e36420f7` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/army_ux.gd` | AUTO | — | 81729 | `cfe7e5b4db386568b49305bdd81df753cd6582ebd30e052d6faca2f3520b2df0` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/bar_track.gd` | AUTO | — | 1232 | `e8608627eea8ca9d463665eec82df73174e33047996889fa1312e2a60f40e45e` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/build_panel.gd` | AUTO | — | 3665 | `3e085a162d2b43acd997b8e196bc516b55835663ae537a20b37e73648fe3f551` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/cmd_sheet.gd` | AUTO | — | 29315 | `b87d0493caf81a4201388d71d8372ed77b17e742257ddbf232257bc25ec03b60` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/conf_declutter.gd` | AUTO | — | 1824 | `a04bc9209ff6bb01bc0778c66174fbaf136cf46ffae120207ff93b5fa6fb0bc4` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/conference_sheet.gd` | AUTO | — | 48568 | `b0ea69603c0ec31efaab15426a81a000408e5cc5de82d72212a1ebccae0300ea` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/dip_api.gd` | AUTO | — | 9933 | `7dd7a1d3030c8c894b18c9d54c3d8c4a7acd297ba52e347988be52f1c166a03c` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/dip_chat_view.gd` | AUTO | — | 11322 | `504c9be50afa0e81fab56ceefb5d5dffa1437e36f2e29898ee1b8c542b4d0c7a` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/dip_page.gd` | AUTO | — | 115346 | `fd5e9927d3add63aa00fd3caf25efff858a5863bba00c3ce378018758181d6d7` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/dip_sheet.gd` | AUTO | — | 95976 | `404e5326f9d8f5d186e016ed1641179c5967ffa48ed6b4a42c9ebe36337121ff` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/econ_hub.gd` | AUTO | — | 54126 | `c52188a7376f073c71104bb2cd0db5f3f1a5350fcb6431df682b414d62d49d2e` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/econ_kit.gd` | AUTO | — | 3322 | `8ce1ee691c2b0edf3e267a948fb39ffbfd85d8271ba9b3b4ff2b58629667690d` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/front_overlay.gd` | AUTO | — | 35050 | `fbdfb391ea1c47d55c02263f3653222ab2ead453f51b542e415a67c29af4a0bd` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/help_tips.gd` | AUTO | — | 16832 | `3b898d5e52c27744b7787b3a569661b500e21934a1ff09a07d4150a0c23b86d6` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/hold_card.gd` | AUTO | — | 7114 | `261d4014b14b5d201c2640100330e056398cc2a04ffb61e5ac424412b82b80f3` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/hold_tip.gd` | AUTO | — | 19265 | `1c8c419b37b5dcc8d6b7e269204860d820b4e77456fc6759438cc885f35c65a6` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/inbox_sheet.gd` | AUTO | — | 14796 | `b7a24222c267ed0f3afc5c59cc1203c1602891258ba1edf491bc5b90c45e06eb` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/jet316_marks.gd` | AUTO | — | 2729 | `63ec2359309135c76d1790e5f9861e97447c89db58b9cd2145166cb9f5044c40` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/map_declutter.gd` | AUTO | — | 2912 | `5bd928498298a9c43b971a5831b8f465066bce73ad30ab5fa913ce3f5ed13df0` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/map_pennants.gd` | AUTO | — | 31539 | `7afc34b85598c187d3c1eb7cfb94d338b52ca9507e4400a85af786731fc0cd1a` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/my_state.gd` | AUTO | — | 71941 | `0b75d7884a99adc3a2b2b396c236648ba8ecd6706e268f1aa01c0721299f6a66` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/navy_dock.gd` | AUTO | — | 76648 | `ba8e67aafb21ab1d19602942a1776bedda0c0d9a154dc8139d57abc73d19b8c8` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/navy_map.gd` | AUTO | — | 16265 | `3d7dd8def712b8417d275c24c18d60d0e21a6fb40372c73a7bd62713db055f2e` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/navy_yard.gd` | AUTO | — | 34193 | `77e9ca4c6a36f7b0937a94f00209873369000029b4a26241fb2804820961d001` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/notif_calm.gd` | AUTO | — | 5438 | `1e720af0fcf7d5a0c0a8f3b3399384cf32b5fc5b1b3f88e0647c8a825846ff56` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/notif_lane.gd` | AUTO | — | 49385 | `df596594cca83d1e9a726649daef5ee40883da8ec213b9e83850d4332b6d9f32` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/path_kit.gd` | AUTO | — | 11965 | `7bc0f7fe007d5a63ec29eab703eeac1519da50b3c7d3b07fa87f5db9c898232d` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/price_spark.gd` | AUTO | — | 3086 | `6cd6000de10efe3896cbda7cac08a3b3b844c73101fe460c79cf7d8980022096` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/rail_back.gd` | AUTO | — | 2918 | `eae4e8367a64ce8c18e3cc83876e8e3cec1d4446609c9d20f11e55c88d4e8426` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/rail_build.gd` | AUTO | — | 10028 | `dc5ca84f8cdcbe0e62c2c5bd2b7ce1f3ade06174ae90cd6895259a6842a9d5c2` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/res_sheet.gd` | AUTO | — | 33543 | `d95e86ffba4b4e36edb4c2d7122cdde4a1cc0713f070bcb1e20be725d6bbaa76` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/speed_pick.gd` | AUTO | — | 14485 | `f458bbdf7ce2cfb457fef9c903b9b9ae2d07062d978c415ad45ec1a2c0c20aab` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/status_watch.gd` | AUTO | — | 7447 | `763bf3338efba81f42bed4b35e58f907c8f1f7352cf7186bbaf00a93d45fa0b7` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/strike_marks.gd` | AUTO | — | 4802 | `3e2aab4e5a80b27243c1ea1e5d4ce1d7dbcccbff606ff14e9fb19d138e9b4499` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/strike_sheet.gd` | AUTO | — | 18383 | `93019a57f9c9db7e0ad2913cf9acd4b7644a6ea097c13eaa9a681977ed851ce7` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/tap_guard.gd` | AUTO | — | 6130 | `c66b8429a6fe640d583f3b6872c81a2c016413b3d4a0ddfe40b335f103bad993` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/trade_sheet.gd` | AUTO | — | 67877 | `20c97175bbef625a231961b84c597fe651e5cdd38fc5c8ea4141e94901429602` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/tutorial_feed.gd` | AUTO | — | 31059 | `1d4b6e0add11771899af4e3b8d12df581e15dc9ffbc1de88f7e2385239bb3598` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui24/width_guard.gd` | AUTO | — | 4026 | `0e6a7ec57b7df081e0868edfbe9f2a9627a42487c34b4d50fcf2fc04fad10720` | Manual semantic remainder NEEDS INSPECTION |
| `game/ui/ui_kit.gd` | AUTO | — | 30388 | `7cd3b15cc60d1124a86856fa7f5392595a986a9d6e3ab53da6d5da3ce8604170` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/ad_cover_layer.gd` | AUTO | — | 5882 | `f101bb48077be82adc95bcd26a1e52b1d65b72ffe35207d64a501f87d69ccc35` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/aftermath_draw.gd` | AUTO | — | 25335 | `8567c9720db5b4bbd82b4ac63a373300950567f930d3b905f8ded6031299a314` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/air_duel_layer.gd` | AUTO | — | 2433 | `208740b43eb0e9e79a0d4aa80289a54e95b74889e7859256c4dccc73c42b4b27` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/air_wreck_draw.gd` | AUTO | — | 14830 | `6b5339e715da8b266780c311b02cd5b9cd8b3b64249b28594c706b95a51fe837` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/biome.gd` | FULL | 1–62 | 1314 | `4b7d02db97eaa5bf829fc25929af5ae88cc28249218fd23729074f617d560d3c` | Manual full text + static analysis |
| `game/world/border_flash.gdshader` | FULL | 1–36 | 1023 | `c0bcfdd60fa6da64e9a1c37181580c3531418cef409583dbdd490e70b4a7bade` | Manual full text + static analysis |
| `game/world/capture_layer.gd` | AUTO | — | 23923 | `47e184b33eed6ab3f59c777e9bae2ac98c56d529b5f15044da15c50371e7b4d7` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/city_gen.gd` | AUTO | — | 17420 | `dba1e41be457153a4cb99b65d115b45776d25250a00377fd562811d2ec878025` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/city_power_layer.gd` | AUTO | — | 3086 | `b3cc2e181e1e4bc1614e75467955e84759c66819df0af45b49450d41f1fc5dbe` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/color_grade.gd` | AUTO | — | 880 | `cb0fd62449a75799a540a2270c271cd0ea3cc929a03ddb0cf4beefca0061f15d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/conf_map.gdshader` | FULL | 1–104 | 3253 | `7b534f2e7a48e292dfc44c84220758da92bc518a9e7f0eae91d184aa19ac8a40` | Manual full text + static analysis |
| `game/world/conf_map_layer.gd` | AUTO | — | 11188 | `c8990ae4b03e89770f877782b0d1d443c56a507bdf4585b0c61534787acc2526` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/cover_draw.gd` | AUTO | — | 1840 | `c9f3ba3eaa16c6467efbd6f09baf20a287113ac1c21f561048033028f49a50c0` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/decal_layer.gd` | AUTO | — | 8856 | `520353757c63405a8819a27cdcff9e38730e689da723b7178c711caf98b2a28d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/dmg_stages.gd` | AUTO | — | 4886 | `3b2cedc251b317ffbc9f68a33efd583930127b89cffdfe84bfdd247d468c336a` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/eco_layer.gd` | AUTO | — | 17658 | `d206cb9ae0dbfc022a10ba73542703b8936ed8c6b0f2019da5cf4ead7432bb17` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/econ_fx_layer.gd` | AUTO | — | 9961 | `8653da6652f2afad6fd8738905a620d595ecc590642f81ef49993a98e1258b92` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/fauna_layer.gd` | AUTO | — | 24925 | `01a529b0f8ccb44dc029ddd44e27ea89d20d7ae97266cc4b9ff01f4e00108ce0` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/flora.gd` | AUTO | — | 4269 | `94d5d03b15e6b7e73cfa228ba0262bf3148c0e5bade665a795d4f5aea7bb81df` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/fog_layer.gd` | AUTO | — | 9910 | `f699ff37bc1357b122edf286bfdd8e19ea600aed311e0df2289e87e4ac771c40` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/fort_layer.gd` | AUTO | — | 6679 | `017b219a1b9beef5ddeec57f19b0cc34b61e411058facafc55da3b62c19d802d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/fx_layer.gd` | AUTO | — | 10114 | `030e6a2524acf30f2e0522b520de2e1862df71dbbaded983627d8bb4ab2ff89c` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/ground_layer.gd` | AUTO | — | 968 | `a2a9691e869e6ad7621ae07d79294f2f0aa4c5ccb84b6956889aad8fb2a78dda` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/hold_layer.gd` | AUTO | — | 7350 | `47923c2752625c504d0634a8775c0ea5ae4b168b0489314c60db6e3690fa00e5` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/labels_layer.gd` | AUTO | — | 41686 | `07f39e527e88f0242f5d1fb05be4c73e35e56acecc79442f866219dd6c156a3c` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/life_layer.gd` | AUTO | — | 16855 | `8d19b85fe15604b2f2e0e9afe8c3e3feaa26c51f9f2dd94a49a5da29e3cd1cbb` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/map_camera.gd` | FULL | 1–409 | 10951 | `a1c1acdee078b0f4546fc314715f78b3116459a71c539dde68f354caa6e21257` | Manual full text + static analysis |
| `game/world/map_icons.gd` | AUTO | — | 11081 | `d9bc7bf4ea9e0b5d423c95f236aacf25e7918d6bc2d76377bd5bd084ea3d8b1e` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/map_mode.gdshader` | FULL | 1–123 | 4505 | `18dafc5f19ee65d53fbf69602748a6b488359f43764ea426292f73f3f9ad0578` | Manual full text + static analysis |
| `game/world/map_mode_layer.gd` | AUTO | — | 23273 | `436d25b35e7040848f2cf98203204e56ffd4eb262a76450c3ed7a57b6718c374` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/nature_layer.gd` | AUTO | — | 8459 | `c5045061b00b24d6d58dc1ffbd11814c94f53e311ee5416f9d18c31027c0781a` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/naval_layer.gd` | AUTO | — | 8446 | `3da95c2d1f3a213932e404c2f81b7f1427366ed085f309206a0027c87ab24e45` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/navy_layer.gd` | AUTO | — | 44250 | `983f89f07910ceaaee7a8af2ac6d0104839f083bf0ddd9d7b5543adc451848af` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/night_layer.gd` | AUTO | — | 28616 | `c4e3aed2010657158df2edbf60069968fc41e4caab34718900ef56a07412a0d9` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/obj_chunk.gd` | AUTO | — | 6693 | `e71373e16d9a838440d95caa5c2d1650ddf1e7ce75cb4237831161a4f0f9c779` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/objects_layer.gd` | AUTO | — | 6058 | `a669bf5cce8d36467c6b8cd11ee514070f437ba8672e7f60ceaf20c26a0933a8` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/ops_layer.gd` | AUTO | — | 21159 | `f152155231995179a2c6b6ffb87f97c83c11948dd82c707bc0071d4de368bb33` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/protect_layer.gd` | AUTO | — | 11894 | `3d8b3916c6fc56c0d993b82514c1a509bad007bd9ae6d47c27099b7a0a21c28c` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/rail_layer.gd` | AUTO | — | 11087 | `9e6b2848d7fa4f34dcf9930a6aa556f8a7f882efac0670986593cf027cb9068d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/rail_view332.gd` | AUTO | — | 14935 | `53c0d26570922a4e32c8952cb56ef1f1727a0b85428b2e32c97485d35b144a8a` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/recon_layer.gd` | AUTO | — | 4919 | `8eadbfba8acb09a657efd06f45a6e4a1efe1be77583b26412d6759856f79e3a3` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/sky_cover.gdshader` | FULL | 1–123 | 4893 | `c7de7e1aea7193b6eee6025efe2eca904b926d2970dcec966fae273171e0851d` | Manual full text + static analysis |
| `game/world/sky_cover_layer.gd` | AUTO | — | 10029 | `f6ccf6c41f342203e2b39468593b9ec381e733c310f04da52a0ca1bd045e4566` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/status_mark.gd` | AUTO | — | 1771 | `0c4160b47dfd27dc8efe53bd68fc99b77163f9a51071c80331e5e8d935b970d6` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/strat_layer.gd` | AUTO | — | 9276 | `b2b593b0599d3f75596f1c89d8d1d8389a025dc3d493724c80598be3c3f06e64` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/strat_map.gdshader` | FULL | 1–166 | 6718 | `62b5227812f7aa61b1734351f047f1026838a655c141c7875942d293dd7730d2` | Manual full text + static analysis |
| `game/world/strat_modes.gd` | AUTO | — | 20566 | `08201b6e7a944fd05086eeaabd7723ed0193a9fb6fab7a4869c063342198f3ea` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/strat_terrain.gd` | AUTO | — | 6218 | `01d6d9e804303ff375b0152e6f6b681b72b084508a32587d059ae37665de329d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/terrain_view.gd` | PARTIAL+AUTO | 1–110, 192–260 | 19768 | `c76407410500aea3d022bc39541576498a581182ca7b1e8aaaf7a12e8442da84` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/territory.gdshader` | FULL | 1–170 | 6876 | `0143522f48425fc0f9137c0bcae99d4a143cec9dc5435d7ffc650fd745f6f25d` | Manual full text + static analysis |
| `game/world/territory_dist.gdshader` | FULL | 1–78 | 2253 | `d816cb761f9c78bdde23957f5a1345551a986248368608e76998447ea271d7e7` | Manual full text + static analysis |
| `game/world/top_layer.gd` | AUTO | — | 3035 | `85f6d54c2e530697ac3e74a029f10f57cb23e30732a03bfc54da708dd44fdcac` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/trade_layer.gd` | AUTO | — | 10136 | `3c07b3307954e0edef74a666b59479834a460917a9469d91d9d506ec635ddd77` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/train_layer.gd` | AUTO | — | 2954 | `3313d3ae5914d6ed0620b4190e71008f5e68d0475a6b9007a73c243852d1cf44` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/units_layer.gd` | AUTO | — | 45423 | `4e030df52897d194f2dadf03c2721b4de1c615c943248dfbd557a1d98b8e1de0` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx.gd` | AUTO | — | 11808 | `0909ff64b291d0dff61ef626a707a00a15dfda33e17269a0a36d4cb8023dbfdf` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_air.gd` | AUTO | — | 29939 | `cb1b220c1a5755d567a802396afedd04a563a174b07b94ebb9604a65a6467b17` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_blast.gd` | AUTO | — | 23527 | `9c445e5a87c2fc9d1fd290311edd6bc7f79761703929143344694ffcbdd062d9` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_clouds.gd` | AUTO | — | 7114 | `addaefd73c20a4df72b946d11b483cdd8092814f42b729a3af55977be93b512f` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_clouds.gdshader` | FULL | 1–90 | 3556 | `6c5102c61ba56906cb1979951c2915e809c007e9c314936b860bc783f9d4ae71` | Manual full text + static analysis |
| `game/world/vfx_glow.gd` | AUTO | — | 2467 | `0d88d10f960d7352b9510aa0d6e3536d1ed5f2fb3acb866089b9fc9aaa6f82b0` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_ground.gd` | AUTO | — | 14095 | `07b4974ecf2244a6e75fed30677335479ed65f0bfdc38a4e15e3a3632d6b95e8` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/vfx_turret.gd` | AUTO | — | 23218 | `e73ff5992798993aaf1a637dfb8f29dd8e12f12eb2568242d8c207cbcfb76d0d` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/war_life.gd` | AUTO | — | 3122 | `d73dad3e4a1afd445f9ceb5a62ea416de34863d9d055f6f3ad7ada61f8914bb4` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/world_data.gd` | FULL | 1–84 | 1843 | `2dfdd95e09aadd4c1cfd7d220d76c3275f7059db4490686e4254875005a4f755` | Manual full text + static analysis |
| `game/world/world_gen.gd` | PARTIAL+AUTO | 1–139 | 20443 | `37080bd31808f5ff202bf34c0c086288a0c6657851744a7cc4ba818c50db2712` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/world_gen2.gd` | AUTO | — | 19817 | `ef03773ec329e80006a7a1bd570d4757d0fb07fc4b0d473dac92b6ae26b6d259` | Manual semantic remainder NEEDS INSPECTION |
| `game/world/world_settings.gd` | FULL | 1–27 | 643 | `758f96673363abee14123940d248adc4a0278cf68d8a7e7364a652876feb641e` | Manual full text + static analysis |
| `libs/libgodotsteam.windows.template_release.x86_64.dll` | METADATA | — | 3980800 | `6535af56d325af0fff52dbb5de3703d110bb430fdef4e3026d7ece617270e530` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `libs/libwebrtc_native.windows.template_release.x86_64.dll` | METADATA | — | 4058112 | `3a8053d325a874493f596630b0f165f3a83e265c61d9fd87d82da6cb4c2a81fd` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `libs/steam_api64.dll` | METADATA | — | 319128 | `8de54d32508e216c9135b8bf025749243d44e404c1c22a8e5fe35acecabe7a9c` | Binary, libmagic/magic/size/hash; semantics UNKNOWN |
| `tests/test_release.py` | FULL | 1–197 | 9170 | `cf2ef89cd60a4f1c100ce38d614f4d4764e809a8a70e6e3f45b2f406bc2dc720` | Manual full text + static analysis |
| `tools/build.py` | FULL | 1–80 | 3518 | `36bbb935cc9bf92180244871c66e181cd345f5c11dcb92cad535e77d02670b16` | Manual full text + static analysis |
| `tools/check_performance.py` | FULL | 1–82 | 4418 | `1b8c284541d22817f8100776c48603485bdd25b04a15b9798144c90695553805` | Manual full text + static analysis |
| `tools/fetch_godot.py` | FULL | 1–24 | 1284 | `d64723f34593e1d6604cebf64917867249945e793e3676d620712c8d2ef6cd22` | Manual full text + static analysis |
| `tools/gdc2gd.py` | FULL | 1–172 | 6922 | `36a5a7a46f951f7b303ba45e23d1941999f04b59d620695643be985f16d79b6c` | Manual full text + static analysis |
| `tools/packproj/pack.gd` | FULL | 1–26 | 681 | `3b8ee2c599a7ed7d57840c3113cad49a7580ca5a695cdafcfed9aaffed80fd49` | Manual full text + static analysis |
| `tools/packproj/project.godot` | FULL | 1–3 | 52 | `021befa3cd820482809a16927967f243ce903f656daedc90e6c5f71dae8edbdb` | Manual full text + static analysis |
| `tools/performance_benchmark.gd` | FULL | 1–114 | 3856 | `d770ca0d2dcdc3ec9f384feb14c93eaacbb636665a48c023978f28d6bf5a73a8` | Manual full text + static analysis |
| `tools/performance_regression.gd` | FULL | 1–245 | 10669 | `30ca52dbe38752f73edbb23b01c1655b5dbc6e546b2c8d6652fa27186fe1eda4` | Manual full text + static analysis |
| `tools/release.py` | FULL | 1–139 | 6038 | `7aeacef36e990e62871abeed75cb9a9f3d1f49c09cc6caac29303361bfd0db65` | Manual full text + static analysis |
| `tools/remote_unzip.py` | FULL | 1–62 | 2328 | `eb131f422e2e17a838c4676f5d2ad30633331d29086f4450535718086a074931` | Manual full text + static analysis |

## Підсумок ручного покриття

- AUTO: 498 файлів.
- FULL: 75 файлів.
- METADATA: 283 файлів.
- PARTIAL+AUTO: 25 файлів.

## Вхідний untracked overlay

Кореневий AGENTS.md, `docs/codex/prompts/CODEX_INITIALIZATION.md` й обов’язкові architecture/build/testing/guardrails прочитані повністю. Вони не входять у 881 tracked-файл. `tools/codex/repository_audit.py`, `scripts/install_pack.py`, `tests/test_pack_scripts.py` також прочитані для audit/test context. Решта package markdown/templates/prompts — допоміжна навігація, не перевірений опис гри; приватна `.serena/` конфігурація не переглядалася. Новостворені verified-документи не включені в базовий tracked-інвентар, щоб уникнути самореференції.

## Продовження ручного аудиту

Phase2 steering: продовжувати за ризиком — bootstrap/updater, save/serialization, deterministic simulation, lockstep/validation/reconnect/restore, build/release; інші модулі за залежностями конкретної зміни. Формально перечитувати всі194 AUTO GDScript не потрібно. Точні PARTIAL ranges лишаються доказом фактичного читання; compiler/load PASS не підвищує їх до manual FULL.

Phase2 додав manual FULL Bridge150/Opening239/LangPicker505 lines. Усі264 runtime scripts завантажені/скомпільовані,3 tool scripts виконані; це runtime syntax coverage, не повний semantic review/branch coverage. Source hashes незмінні; поточні тести й обмеження — RUNTIME_BASELINE. JSON/PO/import раніше обійдені програмно; повторний повний data-analysis без зміни bytes не проводився.
