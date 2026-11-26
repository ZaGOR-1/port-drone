# L02 · GPU і renderer

> Історичний матеріал з `toolchain/l02.3ZzyV6/L02_GPU_RENDERING.md`. [Реєстр досліджень](../INDEX.md)

Lenovo Legion Slim 5, Ubuntu 26.04.1 LTS, kernel `7.0.0-44-generic`. GNOME Shell працює в Wayland і відкрив render nodes обох GPU. `switcherooctl` визначає Radeon як default, AMD renderD129 є основним вузлом Mesa, NVIDIA renderD128 також відкритий і має активний display. Налаштування `prime-select` — on-demand. Із самого переліку дескрипторів не можна вивести єдиний GPU для всіх дисплеїв.

| Режим | Фактичний пристрій | Результат |
| --- | --- | --- |
| XWayland, Vulkan Mobile, default | NVIDIA RTX 4060 Laptop, Vulkan 1.4.329 | PASS |
| XWayland, Vulkan Mobile, AMD ICD | Radeon 760M, Mesa RADV PHOENIX, Vulkan 1.4.335 | PASS |
| XWayland, Vulkan Mobile, NVIDIA ICD | RTX 4060 Laptop, driver 595.99.02 | PASS |
| XWayland, OpenGL Compatibility, AMD | Radeon 760M, radeonsi Mesa 26.0.8, OpenGL 4.6 | PASS startup |
| XWayland, OpenGL Compatibility, NVIDIA PRIME | RTX 4060 Laptop, OpenGL 3.3 NVIDIA 595.99.02 | PASS startup |
| Нативний Wayland, параметри за замовчуванням | До вибору GPU не доходить | FAIL. GLib-GIO, ключ `antialiasing` відсутній у GNOME xsettings schema. |
| Нативний Wayland з `GODOT_WAYLAND_DISABLE_LIBDECOR=1` | Radeon 760M і RTX 4060 в окремих прогонах, Vulkan Mobile | PASS startup, world generation і exit 0 через `--quit-after`. |

Для Linux development рекомендується X11/XWayland + Vulkan Mobile. X11 GPU probe використовував штатний desktop. `glxinfo` та `vulkaninfo` відсутні. Пристрій і backend перевірено безпосередньо за логами Godot. PRIME offload NVIDIA підтверджено на OpenGL, Vulkan selection виконано через ICD змінні процесу. llvmpipe використовувався в контрольному Xvfb reproduction. [Wayland і libdecor](https://github.com/godotengine/godot-docs/blob/master/tutorials/platform/linux/wayland_x11.rst)

```bash
DF=/home/zagor/projects/droneflames-toolchain/dev-environment/scripts/df
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/radeon_icd.json "$DF" run --platform linux
VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json "$DF" run --platform linux
"$DF" run --platform linux --renderer gl_compatibility
GODOT_WAYLAND_DISABLE_LIBDECOR=1 "$DF" run --platform linux --display-driver wayland
```

## Короткий hardware smoke

Однаковий PCK fixture. Seed 935857, світ 512×512, фіксована камера й нічне освітлення, симуляція призупинена, 1200 кадрів на адаптер з вимкненим лімітом FPS. Вимірюються інтервали `frame_post_draw`. GPU, VRAM і температура — device-wide, з поточним desktop навантаженням. CPU виражено у відсотках одного логічного ядра. VRAM Radeon показує memory region, яку звітує драйвер.

| GPU | FPS | p50 / p95 / p99, мс | CPU | GPU | RSS / VRAM, MiB | °C | Samples |
| --- | ---: | --- | ---: | ---: | --- | ---: | ---: |
| Radeon 760M | 250,20 | 2,017 / 4,420 / 9,142 | 49,83% | 35,27% | 1062 / 490 | 53,53 | 15 |
| RTX 4060 | 855,90 | 1,108 / 1,630 / 2,301 | 99,68% | 37,33% | 1846 / 681 | 50,00 | 3 |

Ці значення характеризують короткий контрольований render smoke. Під навантаженням late-game FPS не вимірювався. Radeon raw (`hw-measured-amd.json`) · RTX raw (`hw-measured-nvidia.json`)

## BUG-LINUX-01

INT-01 повідомив `ERROR: Parameter "mesh" is null.` у `mesh_get_aabb` (GLES3, рядок 696) і `mesh_get_surface_count` (рядок 676). Діагностика з одним CanvasItem і ArrayMesh відтворила **обидва** повідомлення у OpenGL і аналоги у Vulkan без GDExtensions. Після `draw_mesh` Godot зберігає RID. Якщо прибрати останній Ref до очищення записаної команди, renderer читає вже звільнений RID. Червоний трикутник зникає. З утриманим Ref до очищення команди трикутник відображається в обох режимах, помилок немає.

Ігровий кандидат шляху — NightLayer, parent CanvasItem і child Lights, єдині явні `draw_mesh` у GDScript. У контрольованому нічному світі три міста мали lit/dark meshes, але `NightLayer.reset()` і повторні redraw не відтворили історичну помилку. Конкретний ігровий ресурс і вплив на кадр INT-01 не підтверджені. Vulkan Mobile пройшов перевірені ігрові сценарії, однак синтетичний випадок відтворюється й на Vulkan. [Godot CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html) · [Точне pinned джерело CanvasItem](https://github.com/godotengine/godot/blob/ed1daf0bf001b61586d9930840f2f1394092c079/scene/main/canvas_item.cpp)
