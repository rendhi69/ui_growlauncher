-- ============================================================================
-- UI 3 MENTAHAN: APEX SUITE v3.0 WIDGETS
-- File: 3_ui_new_apex/components/apex_widgets.lua
-- ============================================================================

local ApexWidgets = {}
local ApexTheme = require and pcall(require, "3_ui_new_apex/components/apex_theme") or nil

function ApexWidgets.coloredText(colorVec4, text)
    if not ImGui then return end
    local s = tostring(text or "")
    if colorVec4 and ImGui.TextColored then
        local ok = pcall(ImGui.TextColored, colorVec4, s)
        if ok then return end
    end
    ImGui.Text(s)
end

function ApexWidgets.colorBtn(label, btnType, width, height)
    if not ImGui or not ImGui.Button then return false end
    local P = ApexTheme and ApexTheme.getColors and ApexTheme.getColors()
    local C = ImGui.Col
    local pushed = 0

    if P and C and ImGui.PushStyleColor then
        local function pc(idx, col)
            if idx and col and pcall(ImGui.PushStyleColor, idx, col) then pushed = pushed + 1 end
        end
        if btnType == "emerald" then
            pc(C.Button, P.btnEmerald); pc(C.ButtonHovered, P.btnEmeraldHover); pc(C.ButtonActive, P.btnEmeraldAct)
        elseif btnType == "rose" then
            pc(C.Button, P.btnRose); pc(C.ButtonHovered, P.btnRoseHover); pc(C.ButtonActive, P.btnRoseAct)
        elseif btnType == "amber" then
            pc(C.Button, P.btnAmber)
        end
    end

    local clicked = false
    if width and width > 0 and ImVec2 then
        local ok, res = pcall(ImGui.Button, label, ImVec2(width, height or 0))
        clicked = (ok and res == true)
    else
        local ok, res = pcall(ImGui.Button, label)
        clicked = (ok and res == true)
    end

    if pushed > 0 and ImGui.PopStyleColor then pcall(ImGui.PopStyleColor, pushed) end
    return clicked
end

function ApexWidgets.safeInput(id, curVal, maxLen, fieldW)
    local s = tostring(curVal or ""):gsub("%z.*", "")
    if fieldW and fieldW > 0 and ImGui.PushItemWidth then pcall(ImGui.PushItemWidth, fieldW) end

    local res = s
    if ImGui and ImGui.InputText then
        local ok, r1, r2 = pcall(ImGui.InputText, id, s, maxLen or 64)
        if ok then
            if type(r1) == "boolean" and r1 == true and type(r2) == "string" then
                res = r2:gsub("%z.*", "")
            elseif type(r2) == "boolean" and r2 == true and type(r1) == "string" then
                res = r1:gsub("%z.*", "")
            end
        end
    end

    if fieldW and fieldW > 0 and ImGui.PopItemWidth then pcall(ImGui.PopItemWidth) end
    return res
end

function ApexWidgets.pillTab(label, isActive, width)
    return ApexWidgets.colorBtn((isActive and ("[ " .. label .. " ]") or ("  " .. label .. "  ")), isActive and "emerald" or "std", width or 0, 28)
end

return ApexWidgets
