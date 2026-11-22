# UI 2: Boren Console ImGui (Modular Dark Console)

UI ini adalah antarmuka Console ImGui profesional yang digunakan pada **rilis skrip terakhir** (Auto Plant, Dirt Farm, Soil Builder, Transfer, dan Harvest).
UI ini mengusung tema **Obsidian Slate Dark** (`#070F1E` / `#0C182B`) dengan aksen Cyber Emerald & Blue.

## Struktur File
- `components/boren_theme.lua`: Modul pewarnaan aman, palette warna, serta style var push/pop tanpa crash.
- `components/boren_widgets.lua`: Modul komponen mentahan (Button, Badge, Status Dot, Card, Tab Bar, safeInput).
- `components/boren_mini_hud.lua`: Mini HUD overlay melayang di sudut kiri atas layar.
- `templates/form_template.lua`: Template mentahan formulir antrean world & storage restock.
- `templates/telemetry_logs.lua`: Template mentahan tabel antrean & console log realtime.
- `example/demo_boren_console.lua`: Script contoh lengkap runnable Console ImGui siap pakai.

## Cara Menggunakan di Script Anda
```lua
local Theme = require("components/boren_theme")
local Widgets = require("components/boren_widgets")

function onDrawImGui()
    local cCnt, vCnt = Theme.pushTheme()
    local openWin = ImGui.Begin("BOREN CONSOLE PRO")
    if openWin then
        Widgets.badge("STATUS: ONLINE", "emerald")
        if Widgets.styledButton("EXECUTE TASK", "emerald", 140, 32) then
            print("Button clicked!")
        end
    end
    ImGui.End()
    Theme.popTheme(cCnt, vCnt)
end
```
