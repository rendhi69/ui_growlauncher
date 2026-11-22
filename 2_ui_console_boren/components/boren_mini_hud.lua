-- ============================================================================
-- UI 2 MENTAHAN: BOREN FLOATING MINI HUD OVERLAY
-- File: 2_ui_console_boren/components/boren_mini_hud.lua
-- ============================================================================

local BorenMiniHUD = {}

function BorenMiniHUD.render(state, onExpandFn, onTogglePowerFn)
    if not ImGui or not ImGui.Begin then return end

    if ImGui.SetNextWindowSize and ImVec2 then
        local cond = (ImGui.Cond and ImGui.Cond.FirstUseEver) or 4
        pcall(ImGui.SetNextWindowSize, ImVec2(340, 50), cond)
    end

    local openWin = ImGui.Begin("BOREN STORE - MINI HUD##boren_mini", nil, (ImGui.WindowFlags and ImGui.WindowFlags.NoCollapse) or 0)
    if openWin then
        local isRun = state and state.running
        local statusText = isRun and "[AKTIF]" or "[IDLE]"
        ImGui.Text(statusText .. " World: " .. tostring((state and state.currentWorld) or "EXIT"))
        ImGui.SameLine()

        if ImGui.Button("Expand##hud_exp") then
            if onExpandFn then pcall(onExpandFn) end
        end
        ImGui.SameLine()

        local powerLabel = isRun and "STOP##hud_pwr" or "START##hud_pwr"
        if ImGui.Button(powerLabel) then
            if onTogglePowerFn then pcall(onTogglePowerFn) end
        end
    end
    ImGui.End()
end

return BorenMiniHUD
