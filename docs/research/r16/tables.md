> Історичний матеріал з `toolchain/performance/r16.Z7ODtxEb/reports/tables.md`. [Реєстр досліджень](../INDEX.md)

## Крива масштабування

| Сценарій | n | Активні | Споруди живі | Казарми | Ops | Снаряди | У кадрі p50 | FPS | 1% low | Frame p99 мс | Tick p99 мс | Mean tick мс | GPU p50 мс | Main CPU % | RSS МіБ |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Medium | 1 | 591 → 436 | 300 | 62 | 0 | 220 | 192.50 | 98.82 | 24.66 | 28.41 | 17.07 | 5.96 | 0.49 | 98.36 | 1984.57 |
| C1200 | 1 | 1197 → 993 | 591 | 118 | 0 | 399 | 393.50 | 44.28 | 16.15 | 56.64 | 27.48 | 12.26 | 0.45 | 99.60 | 2005.13 |
| D1920 | 1 | 1801 → 1599 | 875 | 188 | 0 | 636 | 603.00 | 21.13 | 9.38 | 98.95 | 56.58 | 21.82 | 0.86 | 99.53 | 2009.61 |
| D2100 | 3 | 1925 → 1710 | 874 | 208 | 0 | 667 | 658.00 | 20.27 | 9.73 | 97.81 | 52.42 | 23.56 | 1.33 | 99.52 | 1999.63 |
| Dense D2100 | 3 | 2100 → 1663 | 906 | 208 | 0 | 605 | 1905.00 | 14.82 | 6.26 | 159.03 | 103.65 | 26.73 | 1.83 | 99.53 | 1988.27 |
| Late E 4650 | 1 | 774 → 736 | 738 | 118 | 88 | 15 | 101.00 | 37.54 | 7.19 | 121.07 | 56.94 | 19.16 | 0.58 | 99.07 | 1668.35 |
| Long D2100 restore 4800 | 1 | 1059 → 1070 | 1033 | 208 | 126 | 11 | 237.50 | 23.97 | 3.56 | 206.21 | 147.42 | 23.19 | 0.87 | 99.48 | 1663.38 |
| D3000 stress | 1 | 2685 → 2475 | 880 | 290 | 0 | 790 | 956.50 | 14.82 | 6.47 | 146.05 | 93.31 | 33.93 | 1.62 | 99.88 | 2015.31 |
| D4000 stress | 1 | 3546 → 3327 | 885 | 380 | 0 | 922 | 1283.00 | 11.66 | 5.32 | 167.65 | 114.61 | 44.22 | 1.67 | 99.71 | 1999.41 |
| D5000 stress | 3 | 4535 → 4293 | 903 | 471 | 0 | 1090 | 1572.50 | 9.80 | 4.12 | 230.87 | 164.81 | 55.07 | 1.65 | 99.76 | 1992.68 |
| Dense D5000 stress | 1 | 5000 → 4533 | 962 | 490 | 0 | 836 | 4735.50 | 6.85 | 2.98 | 323.54 | 202.53 | 60.89 | 2.29 | 99.84 | 2008.46 |

## Ізоляція CPU/GPU

| Прогін | FPS | Frame p99 мс | Tick mean мс | Unit prep мс | HUD excl мс | Viewport CPU p50 мс | GPU p50 мс | Draw calls p50 | Visible list p50 | Map anchors p50 | Map prep мс | Main CPU % |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| D2100-active | 22.11 | 92.07 | 22.16 | 6.96 | 1.37 | 1.15 | 0.80 | 423.50 | 665.00 | 2012.00 | 0.32 | 99.70 |
| D2100-away | 30.77 | 78.29 | 20.75 | 2.24 | 1.10 | 0.45 | 0.42 | 338.00 | 0.00 | 127.00 | 0.09 | 99.09 |
| D2100-headless | 24.51 | 91.30 | 20.80 | — | — | — | — | — | — | — | — | 100.06 |
| D2100-high1600 | 22.20 | 96.01 | 22.21 | 6.89 | 1.30 | 1.08 | 1.16 | 418.50 | 665.00 | 2012.00 | 0.30 | 99.15 |
| D2100-low | 21.65 | 106.80 | 22.77 | 6.95 | 1.22 | 1.45 | 0.55 | 361.50 | 665.00 | 2012.00 | 0.32 | 100.08 |
| D2100-pause | 49.00 | 28.96 | — | 11.31 | 1.28 | 0.94 | 0.64 | 365.00 | 700.00 | 2012.00 | 0.08 | 98.99 |
| D2100-zoom-in | 22.02 | 91.89 | 21.62 | 6.95 | 1.32 | 1.30 | 0.94 | 423.00 | 665.00 | 1020.00 | 0.28 | 99.00 |
| D2100-zoom-out | 21.62 | 111.26 | 22.01 | 6.05 | 1.17 | 1.60 | 0.79 | 413.00 | 665.00 | 3205.00 | 0.37 | 99.08 |
| heavy-active | 10.59 | 218.07 | 50.67 | 13.66 | 3.51 | 2.19 | 1.72 | 448.00 | 1608.00 | 2012.00 | 0.34 | 99.95 |
| heavy-away | 14.08 | 191.61 | 49.91 | 3.30 | 2.53 | 0.65 | 1.02 | 341.00 | 0.00 | 127.00 | 0.12 | 99.81 |
| heavy-headless | 11.01 | 228.23 | 49.96 | — | — | — | — | — | — | — | — | 99.99 |
| heavy-high1600 | 10.16 | 225.01 | 52.06 | 14.26 | 3.63 | 2.21 | 2.55 | 441.00 | 1608.00 | 2012.00 | 0.38 | 99.79 |
| heavy-low | 10.31 | 240.95 | 51.50 | 14.06 | 3.60 | 2.20 | 1.06 | 379.00 | 1608.00 | 2012.00 | 0.36 | 99.79 |
| heavy-pause | 22.87 | 59.05 | — | 23.70 | 3.32 | 2.03 | 1.32 | 365.00 | 1668.00 | 2012.00 | 0.12 | 99.65 |
| heavy-zoom-in | 10.31 | 216.38 | 53.43 | 12.30 | 3.68 | 1.89 | 1.87 | 443.00 | 1294.00 | 1020.00 | 0.36 | 99.71 |
| heavy-zoom-out | 9.42 | 254.12 | 54.09 | 13.22 | 3.78 | 2.61 | 1.62 | 425.00 | 1613.00 | 3207.00 | 0.26 | 99.75 |

## Розміри карт

| Прогін | Карта | Активні | Споруди живі | Mean tick мс | Frame p99 мс | RSS МіБ | VRAM МіБ |
| --- | --- | --- | --- | --- | --- | --- | --- |
| map-512 | 512 | 1959 | 714 | 22.81 | 87.13 | 1932.30 | 426.00 |
| screen-D2100 | 1024 | 1925 | 874 | 23.56 | 97.81 | 2003.56 | 554.00 |
| map-2048 | 2048 | 2016 | 897 | 22.44 | 118.59 | 2235.88 | 554.00 |

## detail-D2100 · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 6.34 | 4.381 | 4.381 | 1460.633 | 1460.633 |
| Army.update | 22.153 | 4.154 | 4.154 | 1.0 | 1.0 |
| ArmyFire._impact | 3.649 | 3.649 | 3.649 | 4.558 | 4.558 |
| UnitsLayer._ground_units | 3.211 | 3.211 | 3.211 | 1.0 | 1.0 |
| Army._acquire | 3.188 | 2.574 | 2.574 | 150.133 | 150.133 |
| UnitsLayer._draw | 5.458 | 2.243 | 2.243 | 2.0 | 2.0 |
| Vision.update | 1.772 | 1.772 | 1.772 | 1.0 | 1.0 |
| FXLayer._process | 1.311 | 1.311 | 1.311 | 1.0 | 1.0 |
| GameWorld._sim_step | 25.368 | 1.304 | 1.304 | 1.0 | 1.0 |
| UnitsLayer._pre_frame | 1.295 | 1.295 | 1.295 | 1.0 | 1.0 |

## detail-D2100 · Top-10 scopes у найдовшому кадрі

Тик 133, кадр 118.75 мс, tick 16.638 мс, turn 94.985 мс, поза заміряними exclusive scopes 19.187 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Economy.land_point | 18.556 | 18.556 | 3452 |
| Army.order_attack | 78.139 | 16.637 | 4 |
| Army.safe_point | 36.732 | 16.469 | 10672 |
| Economy.nav_path | 19.316 | 13.294 | 7 |
| Army._advance | 6.011 | 4.117 | 1403 |
| Economy._dry_segments | 4.025 | 4.025 | 7 |
| UnitsLayer._ground_units | 3.916 | 3.916 | 1 |
| Army.update | 13.656 | 3.481 | 1 |
| HUD._process | 3.425 | 3.361 | 1 |
| UnitsLayer._draw | 6.288 | 2.367 | 2 |

## detail-dense · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| UnitsLayer._ground_units | 9.333 | 9.333 | 9.333 | 1.0 | 1.0 |
| Army._acquire | 6.335 | 5.676 | 5.676 | 158.742 | 158.742 |
| ArmyFire._impact | 5.418 | 5.418 | 5.418 | 5.6 | 5.6 |
| Army._advance | 6.65 | 4.755 | 4.755 | 1557.833 | 1557.833 |
| Army.update | 28.8 | 4.485 | 4.485 | 1.0 | 1.0 |
| UnitsLayer._draw | 13.337 | 3.999 | 3.999 | 2.0 | 2.0 |
| UnitsLayer._pre_frame | 2.954 | 2.954 | 2.954 | 1.0 | 1.0 |
| Vision.update | 2.141 | 2.141 | 2.141 | 1.0 | 1.0 |
| FXLayer._process | 1.574 | 1.574 | 1.574 | 1.0 | 1.0 |
| HUD._process | 1.611 | 1.332 | 1.332 | 1.0 | 1.0 |

## detail-dense · Top-10 scopes у найдовшому кадрі

Тик 133, кадр 225.249 мс, tick 17.384 мс, turn 185.83 мс, поза заміряними exclusive scopes 42.613 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Army.safe_point | 103.064 | 55.582 | 36968 |
| Economy.land_point | 43.53 | 43.53 | 7301 |
| Army.order_attack | 168.231 | 29.206 | 4 |
| Economy.nav_path | 17.089 | 12.028 | 6 |
| UnitsLayer._ground_units | 8.862 | 8.862 | 1 |
| UnitsLayer._draw | 13.925 | 5.059 | 2 |
| Army._advance | 5.806 | 4.136 | 1401 |
| Army.update | 13.991 | 3.783 | 1 |
| Economy._dry_segments | 3.314 | 3.314 | 6 |
| UnitsLayer._pre_frame | 3.31 | 3.31 | 1 |

## detail-heavy · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 16.572 | 11.278 | 11.278 | 3948.4 | 3948.4 |
| ArmyFire._impact | 11.015 | 11.015 | 11.015 | 8.65 | 8.65 |
| Army.update | 55.713 | 9.268 | 9.268 | 1.0 | 1.0 |
| UnitsLayer._ground_units | 7.648 | 7.648 | 7.648 | 1.0 | 1.0 |
| Army._acquire | 8.179 | 6.483 | 6.483 | 367.417 | 367.417 |
| UnitsLayer._pre_frame | 3.414 | 3.414 | 3.414 | 1.0 | 1.0 |
| Vision.update | 3.159 | 3.159 | 3.159 | 1.0 | 1.0 |
| Army._dry_step | 3.138 | 3.026 | 3.026 | 3946.25 | 3946.25 |
| HUD._process | 3.552 | 2.993 | 2.993 | 1.0 | 1.0 |
| UnitsLayer._draw | 10.351 | 2.699 | 2.699 | 2.0 | 2.0 |

## detail-heavy · Top-10 scopes у найдовшому кадрі

Тик 133, кадр 285.095 мс, tick 41.481 мс, turn 241.742 мс, поза заміряними exclusive scopes 41.769 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Economy.land_point | 71.022 | 71.022 | 13577 |
| Army.safe_point | 125.84 | 48.761 | 34581 |
| Army.order_attack | 199.994 | 38.993 | 4 |
| Economy.nav_path | 19.45 | 14.305 | 7 |
| Army._advance | 16.479 | 11.305 | 3896 |
| Army.update | 37.052 | 9.352 | 1 |
| HUD._process | 8.109 | 7.934 | 1 |
| UnitsLayer._ground_units | 6.901 | 6.901 | 1 |
| Army._sieges | 6.315 | 5.682 | 1 |
| FXLayer._process | 4.339 | 4.339 | 1 |

## detail-late · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 6.76 | 2.925 | 2.925 | 1008.02 | 1008.02 |
| Economy.update | 2.547 | 2.547 | 2.547 | 1.0 | 1.0 |
| Army.update | 12.146 | 2.136 | 2.136 | 1.0 | 1.0 |
| Vision.update | 1.619 | 1.619 | 1.619 | 1.0 | 1.0 |
| Economy._dry_segments | 1.614 | 1.614 | 1.614 | 4.333 | 4.333 |
| UnitsLayer._draw | 2.164 | 1.539 | 1.539 | 2.0 | 2.0 |
| Economy.nav_path | 3.893 | 1.474 | 1.474 | 4.333 | 4.333 |
| Operations.update | 5.436 | 1.378 | 1.378 | 1.0 | 1.0 |
| Operations._army | 1.145 | 1.145 | 1.145 | 10.653 | 10.653 |
| FXLayer._process | 0.956 | 0.956 | 0.956 | 1.0 | 1.0 |

## detail-late · Top-10 scopes у найдовшому кадрі

Тик 4693, кадр 201.55 мс, tick 18.073 мс, turn 182.175 мс, поза заміряними exclusive scopes 41.333 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Army.safe_point | 105.844 | 71.282 | 57880 |
| Economy.land_point | 31.735 | 31.735 | 6341 |
| Army.order_attack | 163.92 | 27.188 | 4 |
| Economy.nav_path | 8.381 | 3.843 | 6 |
| Economy._dry_segments | 2.971 | 2.971 | 6 |
| Army._advance | 5.105 | 2.679 | 1010 |
| HUD._process | 2.528 | 2.491 | 1 |
| Economy.update | 2.207 | 2.207 | 1 |
| GameWorld._sim_step | 18.03 | 2.081 | 1 |
| UnitsLayer._draw | 2.556 | 1.886 | 2 |

## detail-longresume · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 7.798 | 4.204 | 4.204 | 1494.667 | 1494.667 |
| Army.update | 17.469 | 3.075 | 3.075 | 1.0 | 1.0 |
| UnitsLayer._draw | 3.844 | 2.524 | 2.524 | 2.0 | 2.0 |
| Vision.update | 2.402 | 2.402 | 2.402 | 1.0 | 1.0 |
| Army._train | 2.291 | 2.29 | 2.29 | 1.0 | 1.0 |
| Operations._army | 1.753 | 1.753 | 1.753 | 11.342 | 11.342 |
| UnitsLayer._ground_units | 1.317 | 1.317 | 1.317 | 1.0 | 1.0 |
| FXLayer._process | 1.236 | 1.236 | 1.236 | 1.0 | 1.0 |
| Economy.nav_path | 2.538 | 1.128 | 1.128 | 2.833 | 2.833 |
| Operations.wd_exit | 1.11 | 1.108 | 1.108 | 0.317 | 0.317 |

## detail-longresume · Top-10 scopes у найдовшому кадрі

Тик 4813, кадр 323.786 мс, tick 18.646 мс, turn 295.734 мс, поза заміряними exclusive scopes 58.942 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Army.safe_point | 187.165 | 107.147 | 84435 |
| Economy.land_point | 73.489 | 73.489 | 15434 |
| Army.order_attack | 276.882 | 43.126 | 4 |
| Vision.update | 6.791 | 6.791 | 1 |
| Army._advance | 6.537 | 4.983 | 1490 |
| Economy.nav_path | 9.873 | 4.673 | 5 |
| Economy.update | 3.945 | 3.945 | 1 |
| Army.update | 12.267 | 3.937 | 1 |
| Economy._dry_segments | 3.444 | 3.444 | 5 |
| UnitsLayer._draw | 4.313 | 2.875 | 2 |

## detail-current4800 · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 7.958 | 4.358 | 4.358 | 1494.667 | 1494.667 |
| Army.update | 17.573 | 3.081 | 3.081 | 1.0 | 1.0 |
| UnitsLayer._draw | 3.743 | 2.452 | 2.452 | 2.0 | 2.0 |
| Vision.update | 2.386 | 2.386 | 2.386 | 1.0 | 1.0 |
| Army._train | 2.311 | 2.31 | 2.31 | 1.0 | 1.0 |
| Operations._army | 1.746 | 1.746 | 1.746 | 11.342 | 11.342 |
| UnitsLayer._ground_units | 1.289 | 1.289 | 1.289 | 1.0 | 1.0 |
| FXLayer._process | 1.231 | 1.231 | 1.231 | 1.0 | 1.0 |
| Economy.nav_path | 2.578 | 1.16 | 1.16 | 2.833 | 2.833 |
| Operations.wd_exit | 1.094 | 1.092 | 1.092 | 0.317 | 0.317 |

## detail-current4800 · Top-10 scopes у найдовшому кадрі

Тик 4816, кадр 327.32 мс, tick 299.476 мс, turn 299.494 мс, поза заміряними exclusive scopes 12.842 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Operations._army | 134.621 | 134.621 | 916 |
| Operations.wd_exit | 61.766 | 61.656 | 20 |
| Operations._tick.membership_scan | 16.154 | 16.154 | 126 |
| Operations._wd_orders | 94.69 | 15.87 | 4 |
| Operations.update | 275.595 | 11.361 | 1 |
| Operations.AutoCmd.tick | 62.402 | 9.645 | 1 |
| Economy.nav_path | 14.792 | 7.207 | 38 |
| Operations._wd_tick | 113.12 | 5.635 | 1 |
| HUD._process | 5.258 | 5.258 | 1 |
| Economy._dry_segments | 4.978 | 4.978 | 38 |

## detail-heavy-resume · Top-10 sustained exclusive

| Scope | Inclusive мс/тик | Exclusive мс/тик | Exclusive мс/кадр | Calls/тик | Calls/кадр |
| --- | --- | --- | --- | --- | --- |
| Army._advance | 13.643 | 8.941 | 8.941 | 3026.908 | 3026.908 |
| Army.update | 38.767 | 6.545 | 6.545 | 1.0 | 1.0 |
| Operations._army | 4.44 | 4.44 | 4.44 | 13.042 | 13.042 |
| UnitsLayer._draw | 7.389 | 4.137 | 4.137 | 2.0 | 2.0 |
| Army._train | 3.983 | 3.982 | 3.982 | 1.0 | 1.0 |
| ArmyFire._impact | 3.69 | 3.69 | 3.69 | 3.1 | 3.1 |
| UnitsLayer._ground_units | 3.248 | 3.248 | 3.248 | 1.0 | 1.0 |
| Army._acquire | 3.842 | 2.901 | 2.901 | 269.733 | 269.733 |
| Vision.update | 2.605 | 2.605 | 2.605 | 1.0 | 1.0 |
| HUD._process | 1.935 | 1.921 | 1.921 | 1.0 | 1.0 |

## detail-heavy-resume · Top-10 scopes у найдовшому кадрі

Тик 961, кадр 431.385 мс, tick 403.36 мс, turn 403.378 мс, поза заміряними exclusive scopes 21.433 мс.

| Scope | Inclusive мс | Exclusive мс | Calls |
| --- | --- | --- | --- |
| Operations._army | 214.362 | 214.362 | 615 |
| Operations._tick.membership_scan | 25.927 | 25.927 | 91 |
| Army._acquire | 30.919 | 23.818 | 2195 |
| Operations.AutoCmd.tick | 246.406 | 23.367 | 1 |
| Operations.strength_units | 46.13 | 23.038 | 67 |
| ArmyFire._aim_all | 16.276 | 16.276 | 1 |
| Army._advance | 12.691 | 8.975 | 3081 |
| Army._posts | 9.581 | 7.803 | 1 |
| Operations._wd_orders | 18.859 | 7.285 | 1 |
| Army.update | 85.758 | 6.274 | 1 |
