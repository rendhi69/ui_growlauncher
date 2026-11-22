-- ============================================================================
-- UI 1 MENTAHAN: TEMPLATE BUTTONS & CARDS NATIVE
-- File: 1_ui_native_launcher/templates/buttons_and_cards.lua
-- ============================================================================

local ButtonsAndCards = {}

function ButtonsAndCards.attachRunCard(ui)
    if ui.addExpandableToggle and ui.addChildButton and ui.addChildToggle then
        local runCard = ui:addExpandableToggle("▶ PANEL KONTROL UTAMA", false, "cfg_run_power", false, true)
        ui:addChildButton(runCard.list_child, "■ STOP BOT SEKARANG", "btn_force_stop")
        ui:addChildToggle(runCard.list_child, "Pause Eksekusi", false, "cfg_pause_bot")
        ui:addChildButton(runCard.list_child, "♻ REFRESH STATUS", "btn_refresh_status")
    else
        ui:addToggleButton("▶ START / ■ STOP BOT", false, "cfg_run_power")
        ui:addButton("■ STOP BOT SEKARANG", "btn_force_stop")
        ui:addToggle("Pause Eksekusi", false, "cfg_pause_bot")
    end
end

function ButtonsAndCards.attachStatusList(ui)
    ui:addDisplayList("Status Bot", "IDLE (Menunggu Perintah)", "display_bot_status")
    ui:addDisplayList("Info World", "Offline / Tidak di World", "display_world_info")
    ui:addDisplayList("Log Terakhir", "Belum ada aktivitas.", "display_last_log")
end

return ButtonsAndCards
