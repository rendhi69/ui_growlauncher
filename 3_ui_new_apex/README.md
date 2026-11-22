# UI 3: New Apex Suite v3.0 (Modern Cyberpunk & Glassmorphism)

UI ini adalah desain generasi terbaru (**BOREN.APEX SUITE v3.0**) dengan gaya visual futuristik:
- **Warna Utama:** Obsidian Glass (`#060810`), Neon Turquoise / Cyan (`#00F2FE`), Emerald Live (`#05FFA1`), Rose Action (`#FF2E93`).
- **Fitur Khas:**
  - Status Telemetry Ribbon Bar dengan pembaca metrik KPI (`POHON DITANAM`, `SPLICE BERHASIL`, `STOK SEED 1`, `STOK SEED 2`).
  - High Rounding Window (10px) & Smooth Neon Borders.
  - Floating Mini HUD dengan tombol Expand / Start / Stop.
  - Quick Preset Chips (`Grass #880`, `Pepper #456`, `L-Grid #2304`, `Chand #5666`).
  - Hero Execution Button yang menonjol (`>>> INITIATE AUTO PLANT <<<`).

## Struktur File
- `components/apex_theme.lua`: Palette warna futuristik, high rounding style vars, dan push/pop theme aman.
- `components/apex_widgets.lua`: Komponen mentahan (colorBtn, pillTab, coloredText, safeInput).
- `components/apex_mini_hud.lua`: Mini HUD overlay futuristik.
- `templates/apex_kpi_ribbon.lua`: Template mentahan bar counter KPI.
- `templates/apex_dispatch_pipeline.lua`: Template antrean dispatch modern & preset chips.
- `templates/apex_hero_button.lua`: Template tombol aksi utama berpijar.
- `example/demo_apex_suite.lua`: Script contoh lengkap runnable BOREN.APEX Suite v3.0.

## Cara Menggunakan di Script Anda
```lua
local ApexTheme = require("components/apex_theme")
local ApexWidgets = require("components/apex_widgets")

function onDrawImGui()
    local cCnt, vCnt = ApexTheme.pushApexTheme()
    local openWin = ImGui.Begin("BOREN.APEX SUITE v3.0")
    if openWin then
        ApexWidgets.coloredText(ApexTheme.getColors().textEmerald, "BOREN.APEX v3.0")
        if ApexWidgets.colorBtn(">>> INITIATE TASK <<<", "emerald", 280, 40) then
            print("Task initiated!")
        end
    end
    ImGui.End()
    ApexTheme.popApexTheme(cCnt, vCnt)
end
```
