-- ============================================================================
-- UI 2 MENTAHAN: BOREN CONSOLE REUSABLE WIDGETS
-- File: 2_ui_console_boren/components/boren_widgets.lua
-- ============================================================================

local BorenWidgets = {}
local BorenTheme = require and pcall(require, "2_ui_console_boren/components/boren_theme") or nil

function BorenWidgets.badge(text, badgeType)
    if not ImGui then return end
    local pal = BorenTheme and BorenTheme.getColors and BorenTheme.getColors()
    local col = pal and (pal[badgeType] or pal.cyan)
    if col and ImGui.TextColored then
        pcall(ImGui.TextColored, col, "[" .. tostring(text) .. "]")
    else
        ImGui.Text("[" .. tostring(text) .. "]")
    end
end

function BorenWidgets.statusDot(isActive)
    if not ImGui then return end
    local pal = BorenTheme and BorenTheme.getColors and BorenTheme.getColors()
    local col = isActive and (pal and pal.emerald) or (pal and pal.rose)
    if col and ImGui.TextColored then
        pcall(ImGui.TextColored, col, "(*) ")
    else
        ImGui.Text(isActive and "(*) " or "(o) ")
    end
end

function BorenWidgets.styledButton(label, btnType, width, height)
    if not ImGui or not ImGui.Button then return false end
    local pal = BorenTheme and BorenTheme.getColors and BorenTheme.getColors()
    local C = ImGui.Col
    local pushed = 0
    if pal and C and ImGui.PushStyleColor then
        local target = pal[btnType]
        if target then
            pcall(ImGui.PushStyleColor, C.Button, target)
            pushed = pushed + 1
        end
    end

    local clicked = false
    if width and height and ImVec2 then
        local ok, res = pcall(ImGui.Button, label, ImVec2(width, height))
        clicked = (ok and res == true)
    else
        local ok, res = pcall(ImGui.Button, label)
        clicked = (ok and res == true)
    end

    if pushed > 0 and ImGui.PopStyleColor then
        pcall(ImGui.PopStyleColor, pushed)
    end
    return clicked
end

function BorenWidgets.safeInput(id, val, maxLen, onTouchHook)
    local s = tostring(val or ""):gsub("%z.*", "")
    local changed = false
    local newVal = s

    if ImGui and ImGui.InputText then
        local ok, r1, r2 = pcall(ImGui.InputText, id, s, maxLen or 64)
        if ok then
            if type(r1) == "boolean" and type(r2) == "string" then
                changed = (r1 or r2 ~= s)
                newVal = r2
            elseif type(r1) == "string" then
                changed = (r2 == true or r1 ~= s)
                newVal = r1
            end
        end
    end

    if onTouchHook and ImGui and ImGui.IsItemClicked then
        local okC, clk = pcall(ImGui.IsItemClicked, 0)
        if okC and clk then pcall(onTouchHook) end
    end

    return changed, newVal
end

function BorenWidgets.tabBar(tabs, activeIndex, onSelectFn)
    if not ImGui or type(tabs) ~= "table" then return end
    for idx, name in ipairs(tabs) do
        local isAct = (idx == activeIndex)
        local btnLabel = isAct and ("[" .. name .. "]") or (" " .. name .. " ")
        if BorenWidgets.styledButton(btnLabel .. "##tab_" .. idx, isAct and "cyan" or "button", 0, 26) then
            if onSelectFn then onSelectFn(idx) end
        end
        if idx < #tabs and ImGui.SameLine then ImGui.SameLine() end
    end
end

function BorenWidgets.card(title, renderContentFn)
    if not ImGui or not ImGui.BeginChild then return end
    ImGui.Text(tostring(title))
    ImGui.Separator()
    if ImGui.BeginChild("card_" .. tostring(title), ImVec2 and ImVec2(0, 0) or nil, true) then
        if renderContentFn then pcall(renderContentFn) end
        ImGui.EndChild()
    end
end

return BorenWidgets
