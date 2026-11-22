# UI Growlauncher Library & Templates (Boren Store)

Koleksi lengkap mentahan UI (User Interface) untuk bot **Growlauncher** (Android & PC).
Repository ini memisahkan 3 varian UI utama yang pernah dibuat, lengkap dengan modul mentahan (button, form, input, toggle, theme, card) serta contoh script runnable (`demo_*.lua`) yang bisa langsung dieksekusi di Growlauncher.

---

## Daftar 3 Desain UI

```
ui_growlauncher/
├── 1_ui_native_launcher/      # UI 1: Native Menu Bawaan Growlauncher (Nempel di UI Launcher)
├── 2_ui_console_boren/        # UI 2: Console ImGui Boren Store (Dipakai di Script Rilis Terakhir)
└── 3_ui_new_apex/             # UI 3: New Apex Suite v3.0 (Desain Modern Neon Cyan & Glassmorphism)
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

### 3. UI 3: New Apex Suite v3.0 (`3_ui_new_apex/`)
- **Karakteristik:** Tampilan futuristik kelas Apex (Cyberpunk Glassmorphism `#060810`, aksen Neon Cyan `#00F2FE`, Emerald `#05FFA1`, dan Rose `#FF2E93`).
- **Teknologi:** High-tier ImGui custom styling dengan window rounding tinggi (10px), glowing border, dan responsive dynamic layout.
- **Kelebihan:** Visual sangat modern dan memukau, dilengkapi Telemetry Header bar, Metric KPI Ribbon stat counters (`POHON DITANAM`, `SPLICE BERHASIL`), Quick Preset Chips, dan Hero Execution Button (`>>> INITIATE AUTO PLANT <<<`).
- **Komponen Mentahan:**
  - `apex_theme.lua`: Glass palette, neon borders, smooth rounding.
  - `apex_widgets.lua`: `colorBtn()`, `pillTab()`, `coloredText()`, `statusBadge()`, `safeInput()`.
  - `apex_mini_hud.lua`: Sleek floating mini HUD dengan toggle instant.
  - `apex_kpi_ribbon.lua`: Stat counter ribbon bar.
  - `apex_dispatch_pipeline.lua`: Modern form input & dispatch table.
  - `apex_hero_button.lua`: Glowing action execution button.

---

## Cara Mencoba Contoh Script (Demo)

Setiap folder UI dilengkapi file `example/demo_*.lua`. Anda cukup menyalin isi file tersebut atau menjalankan loader di Growlauncher:
1. Buka executor Growlauncher.
2. Load script demo dari salah satu folder UI.
3. Menu/Console UI akan langsung muncul di layar game Anda!

---
Dikembangkan oleh **Boren Store** / **rendhi69**.
