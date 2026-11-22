-- ============================================================================
-- UI 1 CONTOH LENGKAP: DEMO RUNNABLE NATIVE LAUNCHER MENU
-- File: 1_ui_native_launcher/example/demo_native_launcher.lua
-- ============================================================================
-- Jalankan file ini langsung di Growlauncher untuk melihat menu native!
-- ============================================================================

-- Inline Menu Builder sederhana agar demo bisa dijalankan standalone
local function buildNativeDemo()
    local CATEGORY = "BOREN STORE"
    
    if not addCategory or not addIntoModule then
        if LogToConsole then LogToConsole("`4[Demo UI 1] addCategory / addIntoModule tidak ditemukan di environment ini!") end
        return
    end

    -- Daftarkan Kategori Utama
    pcall(addCategory, CATEGORY, "SportsEsports")

    -- Menu 1: Kontrol & Target
    local menuJson1 = {
        sub_name = "1. Kontrol & Target",
        icon = "PlayArrow",
        menu = {
            { type = "labelapp", text = "Boren Native Bot v1.0", icon = "Storefront" },
            { type = "toggle_button", text = "▶ START / ■ STOP BOT", default = false, alias = "demo_btn_power" },
            { type = "toggle", text = "Pause Eksekusi Bot", default = false, alias = "demo_chk_pause" },
            { type = "display_list", text = "Status Bot", default = "READY (Tekan Start)", alias = "demo_stat_bot" },
            { type = "divider" },
            { type = "input_string", text = "World Target", default = "BORENFARM", label = "World", placeholder = "Nama World", icon = "Public", alias = "demo_inp_world" },
            { type = "input_string", text = "Door ID", default = "", label = "Door", placeholder = "Kosong = White Door", icon = "DoorFront", alias = "demo_inp_door" },
            { type = "slider", text = "Delay Break (ms)", min = 100, max = 500, default = 180, step = 10, usedot = false, alias = "demo_sld_delay" },
            { type = "button", text = "+ Tambah World Saat Ini", alias = "demo_btn_cur_world" },
            { type = "button", text = "📋 Buka In-Game Dialog", alias = "demo_btn_open_dialog" }
        }
    }

    local function encode(t)
        if jsonEncode then return jsonEncode(t) end
        return "{\"sub_name\":\"" .. t.sub_name .. "\",\"icon\":\"" .. t.icon .. "\",\"menu\":[]}"
    end

    pcall(addIntoModule, CATEGORY, encode(menuJson1))

    if LogToConsole then
        LogToConsole("`2[Boren Store] `0UI 1 (Native Launcher Menu) berhasil dimuat ke menu Growlauncher!")
    end
end

-- Hook event ketika tombol/toggle di-klik user di menu Growlauncher
function OnValue(vtype, name, value)
    if name == "demo_btn_power" then
        local isOn = (value == true or value == "true")
        if LogToConsole then LogToConsole("`9[UI 1 Event] Power bot: " .. (isOn and "`2AKTIF" or "`4MATI")) end
        if editDisplayList then editDisplayList("demo_stat_bot", isOn and "BOT SEDANG BERJALAN..." or "BOT BERHENTI.") end
    elseif name == "demo_btn_cur_world" then
        local w = (GetWorld and GetWorld() and GetWorld().name) or "EXIT"
        if LogToConsole then LogToConsole("`9[UI 1 Event] Mengambil world saat ini: `w" .. w) end
        if sendNotification then sendNotification("World saat ini: " .. w) end
    elseif name == "demo_btn_open_dialog" then
        if sendVariant then
            local dlg = "add_label_with_icon|big|Boren Native Dialog|left|242|\nadd_textbox|Ini adalah contoh in-game dialog yang menempel di GT.|left|\nadd_text_input|demo_dlg_inp|Masukkan Catatan:|Contoh Catatan|32|\nadd_quick_exit|\nend_dialog|demo_dlg_ok|Tutup|Simpan|"
            pcall(sendVariant, { [0] = "OnDialogRequest", [1] = dlg }, -1)
        end
    end
end

buildNativeDemo()
