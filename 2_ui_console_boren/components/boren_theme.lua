-- ============================================================================
-- UI 2 MENTAHAN: BOREN CONSOLE THEME & COLOR PALETTE
-- File: 2_ui_console_boren/components/boren_theme.lua
-- ============================================================================

local BorenTheme = {}

local colorCache = nil
local vec4Supported = nil

local function canUseImVec4()
    if vec4Supported ~= nil then return vec4Supported end
    if ImVec4 then
        local ok, v = pcall(ImVec4, 1.0, 1.0, 1.0, 1.0)
        vec4Supported = (ok and v ~= nil)
    else
        vec4Supported = false
    end
    return vec4Supported
end

function BorenTheme.vec2(x, y)
    if ImVec2 then
        local ok, v = pcall(ImVec2, x or 0, y or 0)
        if ok and v ~= nil then return v end
    end
    return nil
end

function BorenTheme.vec4(r, g, b, a)
    if canUseImVec4() then
        local ok, v = pcall(ImVec4, r or 1, g or 1, b or 1, a or 1)
        if ok and v ~= nil then return v end
    end
    return nil
end

function BorenTheme.getColors()
    if colorCache then return colorCache end
    local v4 = BorenTheme.vec4
    colorCache = {
        windowBg        = v4(0.03, 0.06, 0.11, 0.96),
        childBg         = v4(0.04, 0.08, 0.14, 0.98),
        popupBg         = v4(0.04, 0.08, 0.15, 0.98),
        border          = v4(0.14, 0.27, 0.43, 0.85),
        frameBg         = v4(0.05, 0.10, 0.18, 1.00),
        frameBgHovered  = v4(0.08, 0.16, 0.28, 1.00),
        frameBgActive   = v4(0.11, 0.22, 0.38, 1.00),
        titleBg         = v4(0.04, 0.08, 0.15, 1.00),
        titleBgActive   = v4(0.07, 0.15, 0.27, 1.00),
        button          = v4(0.06, 0.12, 0.21, 1.00),
        buttonHovered   = v4(0.11, 0.23, 0.39, 1.00),
        buttonActive    = v4(0.15, 0.33, 0.56, 1.00),
        header          = v4(0.11, 0.28, 0.48, 0.85),
        headerHovered   = v4(0.15, 0.35, 0.59, 0.95),
        headerActive    = v4(0.18, 0.41, 0.68, 1.00),
        tableHeaderBg   = v4(0.06, 0.13, 0.23, 1.00),
        tableRowBg      = v4(0.04, 0.08, 0.14, 0.60),
        tableRowBgAlt   = v4(0.05, 0.10, 0.17, 0.70),
        tableBorder     = v4(0.12, 0.24, 0.38, 0.75),
        text            = v4(0.89, 0.94, 0.99, 1.00),
        textMuted       = v4(0.56, 0.66, 0.78, 1.00),
        emerald         = v4(0.16, 0.75, 0.45, 1.00),
        cyan            = v4(0.00, 0.75, 1.00, 1.00),
        amber           = v4(1.00, 0.72, 0.15, 1.00),
        rose            = v4(0.95, 0.25, 0.35, 1.00),
    }
    return colorCache
end

function BorenTheme.pushTheme()
    local colCount, varCount = 0, 0
    if not ImGui then return 0, 0 end

    local C = ImGui.Col or {}
    local V = ImGui.StyleVar or {}
    local pal = BorenTheme.getColors()

    if ImGui.PushStyleColor and canUseImVec4() then
        local function pushC(idx, col)
            if idx ~= nil and col ~= nil then
                if pcall(ImGui.PushStyleColor, idx, col) then colCount = colCount + 1 end
            end
        end
        pushC(C.WindowBg,          pal.windowBg)
        pushC(C.ChildBg,           pal.childBg)
        pushC(C.PopupBg,           pal.popupBg)
        pushC(C.Border,            pal.border)
        pushC(C.FrameBg,           pal.frameBg)
        pushC(C.FrameBgHovered,    pal.frameBgHovered)
        pushC(C.FrameBgActive,     pal.frameBgActive)
        pushC(C.TitleBg,           pal.titleBg)
        pushC(C.TitleBgActive,     pal.titleBgActive)
        pushC(C.Button,            pal.button)
        pushC(C.ButtonHovered,     pal.buttonHovered)
        pushC(C.ButtonActive,      pal.buttonActive)
        pushC(C.Header,            pal.header)
        pushC(C.Text,              pal.text)
        pushC(C.TextDisabled,      pal.textMuted)
        pushC(C.Separator,         pal.border)
    end

    if ImGui.PushStyleVar and V then
        local function pushV(idx, val)
            if idx ~= nil and val ~= nil then
                if pcall(ImGui.PushStyleVar, idx, val) then varCount = varCount + 1 end
            end
        end
        pushV(V.WindowRounding,   6.0)
        pushV(V.ChildRounding,    4.0)
        pushV(V.FrameRounding,    4.0)
        pushV(V.WindowBorderSize, 1.0)
        pushV(V.FrameBorderSize,  1.0)
    end

    return colCount, varCount
end

function BorenTheme.popTheme(colCount, varCount)
    if not ImGui then return end
    if varCount and varCount > 0 and ImGui.PopStyleVar then
        pcall(ImGui.PopStyleVar, varCount)
    end
    if colCount and colCount > 0 and ImGui.PopStyleColor then
        pcall(ImGui.PopStyleColor, colCount)
    end
end

return BorenTheme
