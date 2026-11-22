-- ============================================================================
-- UI 3 MENTAHAN: APEX FLOATING MINI HUD
-- File: 3_ui_new_apex/components/apex_mini_hud.lua
-- ============================================================================

local ApexMiniHUD = {}

function ApexMiniHUD.render(state, onExpandFn, onTogglePowerFn)
    if not ImGui or not ImGui.Begin then return end

    if ImGui.SetNextWindowSize and ImVec2 then
        pcall(ImGui.SetNextWindowSize, ImVec2(360, 56), 4)
    end

    local openWin = ImGui.Begin("BOREN.APEX MINI HUD##apex_mini")
    if openWin then
        local isRun = (state and state.running)
        ImGui.Text(isRun and "[*] RUNNING" or "[o] IDLE")
        ImGui.SameLine()
        ImGui.Text("| World: " .. tostring((state and state.currentWorld) or "OFFLINE"))
        ImGui.SameLine()
        if ImGui.Button("Expand##exp_apex") then
            if onExpandFn then pcall(onExpandFn) end
        end
        ImGui.SameLine()
        if ImGui.Button(isRun and "STOP##st_apex" or "START##st_apex") then
            if onTogglePowerFn then pcall(onTogglePowerFn) end
        end
    end
    ImGui.End()
end

return ApexMiniHUD
