-- ============================================================================
-- UI 3 MENTAHAN: APEX SUITE v3.0 THEME & GLASS PALETTE
-- File: 3_ui_new_apex/components/apex_theme.lua
-- ============================================================================

local ApexTheme = {}
local colorCache = nil

local function vec4(r, g, b, a)
    if ImVec4 then
        local ok, v = pcall(ImVec4, r, g, b, a)
        if ok and v ~= nil then return v end
    end
    return nil
end

function ApexTheme.getColors()
    if colorCache then return colorCache end
    colorCache = {
        winBg           = vec4(0.04, 0.06, 0.10, 0.96),
        childBg         = vec4(0.05, 0.08, 0.13, 0.95),
        borderNeon      = vec4(0.00, 0.85, 0.95, 0.80),
        borderMuted     = vec4(0.12, 0.22, 0.35, 0.65),
        frameBg         = vec4(0.06, 0.10, 0.16, 0.90),
        frameBgHover    = vec4(0.09, 0.15, 0.24, 1.00),
        frameBgActive   = vec4(0.12, 0.20, 0.32, 1.00),
        titleBg         = vec4(0.05, 0.08, 0.13, 1.00),
        titleBgActive   = vec4(0.08, 0.14, 0.22, 1.00),
        btnStd          = vec4(0.07, 0.13, 0.21, 0.95),
        btnStdHover     = vec4(0.11, 0.22, 0.35, 1.00),
        btnStdActive    = vec4(0.15, 0.30, 0.48, 1.00),
        btnEmerald      = vec4(0.06, 0.55, 0.35, 1.00),
        btnEmeraldHover = vec4(0.08, 0.68, 0.42, 1.00),
        btnEmeraldAct   = vec4(0.10, 0.80, 0.50, 1.00),
        btnRose         = vec4(0.75, 0.15, 0.28, 1.00),
        btnRoseHover    = vec4(0.88, 0.20, 0.35, 1.00),
        btnRoseAct      = vec4(0.98, 0.25, 0.42, 1.00),
        btnAmber        = vec4(0.85, 0.55, 0.10, 1.00),
        textCol         = vec4(0.92, 0.96, 1.00, 1.00),
        textMuted       = vec4(0.50, 0.62, 0.76, 1.00),
        textEmerald     = vec4(0.15, 0.95, 0.60, 1.00),
        textCyan        = vec4(0.00, 0.90, 1.00, 1.00),
        separator       = vec4(0.14, 0.24, 0.38, 0.70)
    }
    return colorCache
end

function ApexTheme.pushApexTheme()
    local cCnt, vCnt = 0, 0
    if not ImGui then return 0, 0 end

    local C = ImGui.Col
    local V = ImGui.StyleVar
    local P = ApexTheme.getColors()

    if ImGui.PushStyleColor and C then
        local function pc(idx, col)
            if idx and col then
                if pcall(ImGui.PushStyleColor, idx, col) then cCnt = cCnt + 1 end
            end
        end
        pc(C.WindowBg,          P.winBg)
        pc(C.ChildBg,           P.childBg)
        pc(C.Border,            P.borderNeon)
        pc(C.FrameBg,           P.frameBg)
        pc(C.FrameBgHovered,    P.frameBgHover)
        pc(C.FrameBgActive,     P.frameBgActive)
        pc(C.TitleBg,           P.titleBg)
        pc(C.TitleBgActive,     P.titleBgActive)
        pc(C.Button,            P.btnStd)
        pc(C.ButtonHovered,     P.btnStdHover)
        pc(C.ButtonActive,      P.btnStdActive)
        pc(C.Text,              P.textCol)
        pc(C.TextDisabled,      P.textMuted)
        pc(C.Separator,         P.separator)
    end

    if ImGui.PushStyleVar and V then
        local function pv(idx, val)
            if idx and val then
                if pcall(ImGui.PushStyleVar, idx, val) then vCnt = vCnt + 1 end
            end
        end
        pv(V.WindowRounding,    10.0)
        pv(V.ChildRounding,     8.0)
        pv(V.FrameRounding,     6.0)
        pv(V.WindowBorderSize,  1.5)
        pv(V.FrameBorderSize,   1.0)
    end

    return cCnt, vCnt
end

function ApexTheme.popApexTheme(cCnt, vCnt)
    if not ImGui then return end
    if vCnt and vCnt > 0 and ImGui.PopStyleVar then pcall(ImGui.PopStyleVar, vCnt) end
    if cCnt and cCnt > 0 and ImGui.PopStyleColor then pcall(ImGui.PopStyleColor, cCnt) end
end

return ApexTheme
