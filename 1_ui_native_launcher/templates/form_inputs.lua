-- ============================================================================
-- UI 1 MENTAHAN: TEMPLATE FORM & INPUTS NATIVE
-- File: 1_ui_native_launcher/templates/form_inputs.lua
-- ============================================================================

local FormInputs = {}

-- Menambahkan grup form lengkap (World Name, Door ID, Item Picker, Delay Slider)
function FormInputs.attachStandardForm(ui, config)
    config = config or {}

    ui:addLabel("=== PENGATURAN TARGET & BOT ===")
    ui:addInputString("Nama World Target", config.world or "WORLDFARM", "World", "Contoh: BORENFARM", "Public", "cfg_world_target")
    ui:addInputString("Door ID (Opsional)", config.door or "", "Door ID", "Kosong = White Door", "DoorFront", "cfg_door_target")
    ui:addInputInt("Item ID Benih / Block", config.itemId or 4584, "Item ID", "4584 = Pepper", "Numbers", "cfg_item_id")
    ui:addItemPicker("Pilih Item dari List", "Pepper Tree", config.itemId or 4584, "cfg_item_picker")
    ui:addSlider("Delay Action (ms)", 50, 500, config.delay or 180, 10, false, "cfg_delay_action")
    ui:addDivider()
end

return FormInputs
