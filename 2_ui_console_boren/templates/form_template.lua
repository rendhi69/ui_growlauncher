-- ============================================================================
-- UI 2 MENTAHAN: FORM DISPATCH & STORAGE TEMPLATE
-- File: 2_ui_console_boren/templates/form_template.lua
-- ============================================================================

local FormTemplate = {}

function FormTemplate.renderDispatchForm(state, callbacks)
    if not ImGui then return end

    ImGui.Text("=== WORLD DISPATCH QUEUE ===")
    ImGui.Text("World Target: " .. tostring(state.targetWorld or "(Belum diisi)"))
    ImGui.Text("Door ID: " .. tostring(state.targetDoor or "-"))

    if ImGui.Button("Sync World Saat Ini##sync_w") then
        if callbacks and callbacks.onSyncWorld then callbacks.onSyncWorld() end
    end
    ImGui.SameLine()
    if ImGui.Button("Clear Target##clr_w") then
        if callbacks and callbacks.onClearTarget then callbacks.onClearTarget() end
    end

    ImGui.Separator()
    ImGui.Text("Quick Presets (Tanam Benih):")
    local presets = { { name = "Grass #880", id = 880 }, { name = "Pepper #456", id = 456 }, { name = "L-Grid #2304", id = 2304 }, { name = "Chand #5666", id = 5666 } }
    for idx, p in ipairs(presets) do
        if ImGui.Button(p.name .. "##pre_" .. idx) then
            if callbacks and callbacks.onSelectPreset then callbacks.onSelectPreset(p.id) end
        end
        if idx < #presets and ImGui.SameLine then ImGui.SameLine() end
    end
end

return FormTemplate
