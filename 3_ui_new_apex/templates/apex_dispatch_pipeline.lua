-- ============================================================================
-- UI 3 MENTAHAN: APEX DISPATCH PIPELINE & PRESETS
-- File: 3_ui_new_apex/templates/apex_dispatch_pipeline.lua
-- ============================================================================

local ApexDispatchPipeline = {}

function ApexDispatchPipeline.render(state, callbacks)
    if not ImGui then return end
    callbacks = callbacks or {}

    ImGui.Text("=== BOREN APEX - PROFESSIONAL FARM DISPATCH ===")
    ImGui.Text("World Target: " .. tostring(state.targetWorld or "(Belum diisi)"))
    ImGui.SameLine()
    ImGui.Text(" | Door: " .. tostring(state.targetDoor or "-"))

    if ImGui.Button("Sync World Saat Ini##sync_apex") then
        if callbacks.onSyncWorld then callbacks.onSyncWorld() end
    end
    ImGui.SameLine()
    if ImGui.Button("Clear Target##clr_apex") then
        if callbacks.onClearTarget then callbacks.onClearTarget() end
    end

    ImGui.Separator()
    ImGui.Text("Quick Presets:")
    local presets = { { name = "Grass #880", id = 880 }, { name = "Pepper #456", id = 456 }, { name = "L-Grid #2304", id = 2304 }, { name = "Chand #5666", id = 5666 } }
    for idx, p in ipairs(presets) do
        if ImGui.Button(p.name .. "##apre_" .. idx) then
            if callbacks.onSelectPreset then callbacks.onSelectPreset(p.id) end
        end
        if idx < #presets and ImGui.SameLine then ImGui.SameLine() end
    end
end

return ApexDispatchPipeline
