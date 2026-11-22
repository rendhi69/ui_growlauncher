# UI 1: Native Growlauncher Menu & In-Game Dialog

UI ini menggunakan sistem bawaan (native) dari **Growlauncher**.
Menu akan menempel langsung pada panel interface Growlauncher, serta mendukung popup dialog native in-game.

## Struktur File
- `components/native_menu_builder.lua`: Modul pembuat menu native (`UserInterface.new` / JSON schema).
- `components/native_dialog_builder.lua`: Modul pembuat dialog popup in-game via `SendVariant`.
- `templates/form_inputs.lua`: Template mentahan kolom input teks, angka, toggle, slider, dan item picker.
- `templates/buttons_and_cards.lua`: Template mentahan tombol, expandable card, dan display list.
- `example/demo_native_launcher.lua`: Script contoh lengkap runnable yang menampilkan seluruh komponen.

## Cara Menggunakan di Script Anda
```lua
local MenuBuilder = require("components/native_menu_builder") -- atau paste kodenya

local ui = MenuBuilder.new("1. Setting Bot", "PlayArrow")
ui:addLabelApp("Boren Bot Controller", "Storefront")
ui:addToggle("Aktifkan Auto Farm", false, "cfg_auto_farm")
ui:addInputString("Nama World Target", "WORLDFARM", "World", "WORLD1", "Public", "cfg_world_name")
ui:addButton("START BOT", "btn_start_bot")

MenuBuilder.registerCategory("BOREN STORE", "Games")
MenuBuilder.addMenuToCategory("BOREN STORE", ui)
```
