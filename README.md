# UI Growlauncher Library & Templates (Boren Store)

Koleksi lengkap mentahan UI (User Interface) untuk bot **Growlauncher** (Android & PC).
Repository ini memisahkan 2 varian UI utama, lengkap dengan modul mentahan (button, form, input, toggle, theme, card) serta contoh script runnable (`demo_*.lua`) yang bisa langsung dieksekusi di Growlauncher.

---

## Daftar Desain UI

```
ui_growlauncher/
├── 1_ui_native_launcher/      # UI 1: Native Menu Bawaan Growlauncher (Nempel di UI Launcher)
└── 2_ui_console_boren/        # UI 2: Console ImGui Boren Store (Dipakai di Script Rilis Terakhir)
```

---

### 1. UI 1: Native Launcher Menu (`1_ui_native_launcher/`)
- **Karakteristik:** Tampil langsung menempel pada menu bawaan Growlauncher (tanpa overlay melayang terpisah).
- **Teknologi:** Menggunakan `UserInterface.new()` bawaan APK Growlauncher / builder format JSON schema, serta in-game dialog native (`SendVariant` dialog).
- **Kelebihan:** Sangat ringan, terintegrasi langsung dengan menu bot Growlauncher, tidak menghalangi layar game.
- **Komponen Mentahan:**
  - `addLabelApp`, `addLabel`, `addDivider`
  - `addToggle`, `addToggleButton`, `addExpandableToggle`
  - `addButton`, `addChildButton`, `addChildToggle`
  - `addInputString`, `addInputInt`, `addSlider`
  - `addItemPicker`, `addDisplayList`, `addTooltip`
  - In-game Native Dialog Builder (`add_text_input`, `add_checkbox`, `add_button`, dll.)

---

### 2. UI 2: Boren Console ImGui (`2_ui_console_boren/`)
- **Karakteristik:** Tampilan Console ImGui gelap profesional (Obsidian Slate `#070F1E` & Cyber Emerald/Blue) yang dipakai pada rilis script terakhir (Plant, Dirt Farm, Soil Builder, Transfer, Harvest).
- **Teknologi:** `ImGui` engine dengan sistem theme modular aman (`theme_widgets.lua`), pencegah crash style var, dan virtual keyboard touch trigger.
- **Kelebihan:** Fleksibel, multi-tab (`[1. Farm Dispatch]`, `[2. Storage Vault]`, dll.), mendukung status badge, tabel antrean multi-world, dan mini HUD overlay.
- **Komponen Mentahan:**
  - `boren_theme.lua`: Color palette, safe `pushTheme()` / `popTheme()`.
  - `boren_widgets.lua`: `styledButton()`, `badge()`, `statusDot()`, `card()`, `tabBar()`, `safeInput()`.
  - `boren_mini_hud.lua`: Mini HUD overlay melayang di pojok kiri atas.
  - `form_template.lua` & `telemetry_logs.lua`: Form input multi-world & console log live.


---

## Cara Mencoba Contoh Script (Demo)

Setiap folder UI dilengkapi file `example/demo_*.lua`. Anda cukup menyalin isi file tersebut atau menjalankan loader di Growlauncher:
1. Buka executor Growlauncher.
2. Load script demo dari salah satu folder UI.
3. Menu/Console UI akan langsung muncul di layar game Anda!

---
Dikembangkan oleh **Boren Store** / **rendhi69**.
