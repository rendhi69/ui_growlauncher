-- ============================================================================
-- UI 3 MENTAHAN: APEX HERO EXECUTION BUTTON
-- File: 3_ui_new_apex/templates/apex_hero_button.lua
-- ============================================================================

local ApexHeroButton = {}

function ApexHeroButton.render(isRunning, onToggleFn, width)
    if not ImGui or not ImGui.Button then return end

    local label = isRunning and ">>> STOP AUTO PLANT <<<" or ">>> INITIATE AUTO PLANT <<<"
    local btnW = width or 320

    if ImVec2 then
        if ImGui.Button(label .. "##apex_hero", ImVec2(btnW, 36)) then
            if onToggleFn then pcall(onToggleFn) end
        end
    else
        if ImGui.Button(label .. "##apex_hero") then
            if onToggleFn then pcall(onToggleFn) end
        end
    end
end

return ApexHeroButton
