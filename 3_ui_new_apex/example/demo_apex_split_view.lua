-- ============================================================================
-- BOREN.APEX SUITE v3.0 - NATIVE DEAR IMGUI SPLIT-VIEW DASHBOARD
-- File: demo_apex_split_view.lua
-- ============================================================================
-- 100% Murni Native Dear ImGui (Lua) - Tanpa CSS, Tanpa Tailwind, Tanpa HTML.
-- Dirancang khusus untuk arsitektur Growlauncher (Android & PC).
-- Fitur:
--   1. Split-View Master-Detail: Sidebar Navigasi di KIRI + Workspace di KANAN
--   2. Grid Form Presisi: Target World, Door ID, dan Sync World sejajar 1 baris
--   3. Quick Presets Bar: Tombol terbagi rata simetris
--   4. Card Container Bergaris (BeginChild dengan border = true)
--   5. Status Telemetry Header & Bottom Hero Action Dock
-- ============================================================================

local APEX = {
    running = false,
    minimized = false,
    activeTab = 1,
    worldInput = "FARMLAND_99",
    doorInput = "",
    seed1Input = "456",
    seed2Input = "15",
    mode3Petak = true,
    splicingOn = false,
    treesPlanted = 480,
    treesSpliced = 240,
    seed1Stock = 200,
    seed2Stock = 0,
    queue = {
        { name = "BORENFARM_01", door = "", seed = "#456 (Pepper)", status = "DONE" },
        { name = "BORENFARM_02", door = "VIP", seed = "#456 (Pepper)", status = "ACTIVE" },
        { name = "BORENFARM_03", door = "", seed = "#456 (Pepper)", status = "READY" },
    }
}

-- ============================================================================
-- PALETTE WARNA NEON APEX (Dear ImGui Vec4 Murni)
-- ============================================================================
local function getColors()
    local v4 = (ImVec4 and function(r, g, b, a) return ImVec4(r, g, b, a or 1.0) end) or function(...) return nil end
    return {
        winBg        = v4(0.04, 0.06, 0.10, 0.98),
        cardBg       = v4(0.06, 0.09, 0.14, 0.95),
        borderCyan   = v4(0.00, 0.85, 0.95, 0.85),
        borderMuted  = v4(0.12, 0.22, 0.35, 0.65),
        btnDark      = v4(0.08, 0.13, 0.20, 1.00),
        btnHover     = v4(0.12, 0.22, 0.35, 1.00),
        btnEmerald   = v4(0.06, 0.60, 0.38, 1.00),
        btnEmeraldHov= v4(0.08, 0.75, 0.46, 1.00),
        btnCyan      = v4(0.00, 0.55, 0.75, 1.00),
        btnRose      = v4(0.75, 0.15, 0.28, 1.00),
        textWhite    = v4(0.95, 0.98, 1.00, 1.00),
        textMuted    = v4(0.52, 0.64, 0.78, 1.00),
        textEmerald  = v4(0.15, 0.95, 0.60, 1.00),
        textCyan     = v4(0.00, 0.90, 1.00, 1.00),
        textAmber    = v4(1.00, 0.75, 0.15, 1.00),
    }
end

-- ============================================================================
-- HELPER PUSH/POP STYLE IMGUI AMAN
-- ============================================================================
local function pushApexStyle()
    local cCnt, vCnt = 0, 0
    if not ImGui then return 0, 0 end
    local C = ImGui.Col
    local V = ImGui.StyleVar
    local P = getColors()

    if ImGui.PushStyleColor and C then
        local function pc(idx, col)
            if idx and col and pcall(ImGui.PushStyleColor, idx, col) then cCnt = cCnt + 1 end
        end
        pc(C.WindowBg,          P.winBg)
        pc(C.ChildBg,           P.cardBg)
        pc(C.Border,            P.borderCyan)
        pc(C.FrameBg,           P.btnDark)
        pc(C.FrameBgHovered,    P.btnHover)
        pc(C.Button,            P.btnDark)
        pc(C.ButtonHovered,     P.btnHover)
        pc(C.Text,              P.textWhite)
        pc(C.TextDisabled,      P.textMuted)
        pc(C.Separator,         P.borderMuted)
    end

    if ImGui.PushStyleVar and V then
        local function pv(idx, val)
            if idx and val and pcall(ImGui.PushStyleVar, idx, val) then vCnt = vCnt + 1 end
        end
        pv(V.WindowRounding,    8.0)
        pv(V.ChildRounding,     6.0)
        pv(V.FrameRounding,     4.0)
        pv(V.WindowBorderSize,  1.2)
        pv(V.FrameBorderSize,   1.0)
    end

    return cCnt, vCnt
end

local function popApexStyle(cCnt, vCnt)
    if not ImGui then return end
    if vCnt and vCnt > 0 and ImGui.PopStyleVar then pcall(ImGui.PopStyleVar, vCnt) end
    if cCnt and cCnt > 0 and ImGui.PopStyleColor then pcall(ImGui.PopStyleColor, cCnt) end
end

local function textCol(colVec4, txt)
    if colVec4 and ImGui and ImGui.TextColored then
        local ok = pcall(ImGui.TextColored, colVec4, tostring(txt or ""))
        if ok then return end
    end
    ImGui.Text(tostring(txt or ""))
end

local function customButton(label, btnType, width, height)
    if not ImGui or not ImGui.Button then return false end
    local P = getColors()
    local C = ImGui.Col
    local pushed = 0

    if P and C and ImGui.PushStyleColor then
        local target = (btnType == "emerald" and P.btnEmerald)
                    or (btnType == "cyan" and P.btnCyan)
                    or (btnType == "rose" and P.btnRose)
                    or P.btnDark
        if pcall(ImGui.PushStyleColor, C.Button, target) then pushed = pushed + 1 end
        if btnType == "emerald" and pcall(ImGui.PushStyleColor, C.ButtonHovered, P.btnEmeraldHov) then pushed = pushed + 1 end
    end

    local clicked = false
    if width and width > 0 and ImVec2 then
        local ok, res = pcall(ImGui.Button, label, ImVec2(width, height or 26))
        clicked = (ok and res == true)
    else
        local ok, res = pcall(ImGui.Button, label)
        clicked = (ok and res == true)
    end

    if pushed > 0 and ImGui.PopStyleColor then pcall(ImGui.PopStyleColor, pushed) end
    return clicked
end

local function safeInputText(id, curVal, maxLen, fieldWidth)
    local s = tostring(curVal or ""):gsub("%z.*", "")
    if fieldWidth and fieldWidth > 0 and ImGui.PushItemWidth then pcall(ImGui.PushItemWidth, fieldWidth) end

    local res = s
    if ImGui and ImGui.InputText then
        local ok, r1, r2 = pcall(ImGui.InputText, id, s, maxLen or 32)
        if ok then
            if type(r1) == "boolean" and r1 == true and type(r2) == "string" then res = r2
            elseif type(r2) == "boolean" and r2 == true and type(r1) == "string" then res = r1
            elseif type(r1) == "string" and r1 ~= s then res = r1 end
        end
    end

    if fieldWidth and fieldWidth > 0 and ImGui.PopItemWidth then pcall(ImGui.PopItemWidth) end
    return res
end

-- ============================================================================
-- 1. FLOATING MINI HUD
-- ============================================================================
local function renderFloatingHUD()
    if not ImGui or not ImGui.Begin then return end
    if ImGui.SetNextWindowSize and ImVec2 then pcall(ImGui.SetNextWindowSize, ImVec2(360, 52), 4) end

    local openWin = ImGui.Begin("BOREN.APEX MINI HUD##mini_hud", nil, (ImGui.WindowFlags and ImGui.WindowFlags.NoCollapse) or 0)
    if openWin then
        local P = getColors()
        if APEX.running then textCol(P.textEmerald, "[*] RUNNING") else textCol(P.textMuted, "[o] IDLE") end
        ImGui.SameLine()
        ImGui.Text("| World: " .. tostring(APEX.worldInput))
        ImGui.SameLine()
        if customButton("Expand##exp", "cyan", 65, 24) then APEX.minimized = false end
        ImGui.SameLine()
        if customButton(APEX.running and "STOP##pwr" or "START##pwr", APEX.running and "rose" or "emerald", 65, 24) then
            APEX.running = not APEX.running
        end
    end
    ImGui.End()
end

-- ============================================================================
-- 2. WORKSPACE TAB 1: FARM DISPATCH (GRID TERATUR)
-- ============================================================================
local function renderDispatchTab()
    local P = getColors()

    -- Card 1: Entry Form Antrean Baru
    if ImGui.BeginChild("card_entry_form", ImVec2 and ImVec2(0, 160) or nil, true) then
        textCol(P.textCyan, "[*] ENTRY ANTREAN FARM WORLD BARU")
        ImGui.Separator()

        -- Baris 1: World Target, Door ID, dan Tombol Sync (Sejajar 1 Baris Presisi!)
        ImGui.Text("World:")
        ImGui.SameLine()
        APEX.worldInput = safeInputText("##inp_w", APEX.worldInput, 24, 120)

        ImGui.SameLine()
        ImGui.Text("Door:")
        ImGui.SameLine()
        APEX.doorInput = safeInputText("##inp_d", APEX.doorInput, 16, 60)

        ImGui.SameLine()
        if customButton("Sync World##btn_sync", "cyan", 90, 24) then
            local cur = (GetWorld and GetWorld() and GetWorld().name) or "MY_FARM"
            APEX.worldInput = cur
            if sendNotification then sendNotification("World sinkron: " .. cur) end
        end

        -- Baris 2: Seed 1 Utama, Seed 2 Splice, Toggle Mode
        ImGui.Text("Seed 1:")
        ImGui.SameLine()
        APEX.seed1Input = safeInputText("##inp_s1", APEX.seed1Input, 8, 50)

        ImGui.SameLine()
        ImGui.Text("Seed 2:")
        ImGui.SameLine()
        APEX.seed2Input = safeInputText("##inp_s2", APEX.seed2Input, 8, 50)

        ImGui.SameLine()
        local modeLabel = APEX.mode3Petak and "[Mode: 3 Petak]" or "[Mode: 1 Petak]"
        if customButton(modeLabel .. "##btn_mode", APEX.mode3Petak and "emerald" or "dark", 115, 24) then
            APEX.mode3Petak = not APEX.mode3Petak
        end

        ImGui.SameLine()
        local spliceLabel = APEX.splicingOn and "[Splice: ON]" or "[Splice: OFF]"
        if customButton(spliceLabel .. "##btn_spl", APEX.splicingOn and "emerald" or "dark", 95, 24) then
            APEX.splicingOn = not APEX.splicingOn
        end

        -- Baris 3: Quick Presets (Tombol Terbagi Rata)
        ImGui.Text("Quick:")
        ImGui.SameLine()
        local presets = { { name = "Grass #880", s1 = "880" }, { name = "Pepper #456", s1 = "456" }, { name = "L-Grid #2304", s1 = "2304" }, { name = "Chand #5666", s1 = "5666" } }
        for idx, pr in ipairs(presets) do
            if customButton(pr.name .. "##pre_" .. idx, "dark", 88, 22) then
                APEX.seed1Input = pr.s1
            end
            if idx < #presets then ImGui.SameLine() end
        end

        -- Baris 4: Tombol Tambah ke Antrean (Lebar Penuh)
        if customButton("+ TAMBAHKAN KE ANTREAN DISPATCH##add_queue", "emerald", 0, 26) then
            table.insert(APEX.queue, { name = APEX.worldInput, door = APEX.doorInput, seed = "#" .. APEX.seed1Input, status = "READY" })
            if sendNotification then sendNotification("World ditambahkan: " .. APEX.worldInput) end
        end

        ImGui.EndChild()
    end

    -- Card 2: Active Dispatch Pipeline Table
    if ImGui.BeginChild("card_pipeline_table", ImVec2 and ImVec2(0, 140) or nil, true) then
        textCol(P.textCyan, string.format("ACTIVE DISPATCH PIPELINE (%d WORLDS)", #APEX.queue))
        ImGui.SameLine()
        if customButton("Clear All##clr_q", "rose", 70, 20) then APEX.queue = {} end
        ImGui.SameLine()
        if customButton("Simpan##sav_q", "dark", 60, 20) then end
        ImGui.SameLine()
        if customButton("Muat##lod_q", "dark", 50, 20) then end
        ImGui.Separator()

        if #APEX.queue == 0 then
            ImGui.TextDisabled("Antrean kosong. Masukkan nama world di atas lalu klik '+ Tambahkan'.")
        else
            for i, row in ipairs(APEX.queue) do
                local stCol = (row.status == "DONE" and P.textEmerald) or (row.status == "ACTIVE" and P.textCyan) or P.textMuted
                textCol(P.textMuted, string.format("#%d", i))
                ImGui.SameLine()
                textCol(P.textWhite, string.format("%-14s", row.name))
                ImGui.SameLine()
                textCol(P.textMuted, string.format("Door: %-6s", (row.door ~= "" and row.door or "-")))
                ImGui.SameLine()
                textCol(P.textAmber, string.format("Seed: %s", row.seed))
                ImGui.SameLine()
                textCol(stCol, string.format("[%s]", row.status))
                ImGui.SameLine()
                if customButton("X##del_" .. i, "rose", 22, 18) then
                    table.remove(APEX.queue, i)
                    break
                end
            end
        end

        ImGui.EndChild()
    end

    -- Bottom Action Dock
    textCol(P.textMuted, "PACING: FAST | SHIELD: ACTIVE | RESTOCK THRESHOLD: 150")
    local heroLabel = APEX.running and ">>> STOP AUTO PLANT <<<" or ">>> INITIATE AUTO PLANT <<<"
    if customButton(heroLabel .. "##hero_action", APEX.running and "rose" or "emerald", 260, 32) then
        APEX.running = not APEX.running
    end
    ImGui.SameLine()
    if customButton("Reset Status Antrean##rst_q", "dark", 150, 32) then
        for _, row in ipairs(APEX.queue) do row.status = "READY" end
    end
end

-- ============================================================================
-- 3. JENDELA UTAMA: MASTER-DETAIL SPLIT VIEW (SIDEBAR KIRI + WORKSPACE KANAN)
-- ============================================================================
local function renderMainDashboard()
    if not ImGui or not ImGui.Begin then return end

    if ImGui.SetNextWindowSize and ImVec2 then
        pcall(ImGui.SetNextWindowSize, ImVec2(760, 480), 4)
    end

    local openWin = ImGui.Begin("BOREN.APEX SUITE v3.0 - AUTO PLANT PRO##apex_split_deck", nil, (ImGui.WindowFlags and ImGui.WindowFlags.NoCollapse) or 0)
    if openWin then
        local P = getColors()

        -- A. TOP TELEMETRY HEADER
        textCol(P.textCyan, "BOREN.APEX SUITE v3.0")
        ImGui.SameLine()
        textCol(P.textMuted, "| NODE: ID_BOT_01 |")
        ImGui.SameLine()
        textCol(P.textEmerald, tostring(APEX.worldInput))
        ImGui.SameLine()
        textCol(P.textMuted, "| 24ms |")
        ImGui.SameLine()
        textCol(APEX.running and P.textEmerald or P.textMuted, APEX.running and "STATUS: RUNNING" or "STATUS: READY")

        ImGui.SameLine()
        if customButton("-- Minimize##top_min", "dark", 85, 22) then APEX.minimized = true end

        ImGui.Separator()

        -- B. KPI TELEMETRY RIBBON
        textCol(P.textMuted, "POHON DITANAM:")
        ImGui.SameLine()
        textCol(P.textEmerald, string.format(" %d ", APEX.treesPlanted))
        ImGui.SameLine()
        textCol(P.textMuted, "|  SPLICE:")
        ImGui.SameLine()
        textCol(P.textEmerald, string.format(" %d ", APEX.treesSpliced))
        ImGui.SameLine()
        textCol(P.textMuted, "|  STOK BENIH 1:")
        ImGui.SameLine()
        textCol(P.textCyan, string.format(" %d ", APEX.seed1Stock))
        ImGui.SameLine()
        textCol(P.textMuted, "|  STOK BENIH 2:")
        ImGui.SameLine()
        textCol(P.textMuted, string.format(" %d ", APEX.seed2Stock))

        ImGui.Separator()

        -- C. SPLIT VIEW: SIDEBAR KIRI (160px) + WORKSPACE KANAN
        -- 1. Sidebar Navigasi Kiri
        if ImGui.BeginChild("sidebar_nav_rail", ImVec2 and ImVec2(165, 0) or nil, true) then
            textCol(P.textMuted, "MODULES DECK")
            ImGui.Separator()

            local navItems = {
                "Farm Dispatch",
                "Storage Vault",
                "Engine Pacing",
                "Safety Shield",
                "Live Telemetry"
            }

            for idx, name in ipairs(navItems) do
                local isAct = (idx == APEX.activeTab)
                local btnLabel = isAct and ("> " .. name) or ("  " .. name)
                if customButton(btnLabel .. "##nav_" .. idx, isAct and "emerald" or "dark", 145, 28) then
                    APEX.activeTab = idx
                end
            end

            -- Indikator Status di Bagian Bawah Sidebar
            ImGui.SetCursorPosY(310)
            ImGui.Separator()
            textCol(P.textMuted, "ENGINE CORE:")
            textCol(P.textEmerald, "[*] ONLINE v3.0")
            textCol(P.textMuted, "Zero-Miss Path")

            ImGui.EndChild()
        end

        ImGui.SameLine()

        -- 2. Workspace Kanan (Sesuai Tab yang Dipilih)
        if ImGui.BeginChild("workspace_content_deck", ImVec2 and ImVec2(0, 0) or nil, true) then
            if APEX.activeTab == 1 then
                renderDispatchTab()
            elseif APEX.activeTab == 2 then
                textCol(P.textCyan, "=== STORAGE VAULT & SEED RESTOCK ===")
                ImGui.Separator()
                ImGui.Text("Storage World: STORAGE_SEED_01")
                ImGui.Text("Ambil Seed Saat Stok < 10")
            elseif APEX.activeTab == 3 then
                textCol(P.textCyan, "=== ENGINE PACING & SPEED ===")
                ImGui.Separator()
                ImGui.Text("Delay Plant: 120 ms")
                ImGui.Text("Delay Move: 180 ms")
            elseif APEX.activeTab == 4 then
                textCol(P.textCyan, "=== SAFETY & SHIELD PROTECTION ===")
                ImGui.Separator()
                ImGui.Text("Anti-Ban Shield: AKTIF")
                ImGui.Text("Auto-Disconnect saat Mod Join: AKTIF")
            elseif APEX.activeTab == 5 then
                textCol(P.textCyan, "=== LIVE TELEMETRY & LOGS ===")
                ImGui.Separator()
                ImGui.Text("[00:00:01] Bot initialized.")
                ImGui.Text("[00:00:02] Connected to dispatch queue.")
            end

            ImGui.EndChild()
        end
    end
    ImGui.End()
end

-- ============================================================================
-- GLOBAL HOOK IMGUI
-- ============================================================================
function onDrawImGui()
    local cCnt, vCnt = pushApexStyle()
    if APEX.minimized then
        renderFloatingHUD()
    else
        renderMainDashboard()
    end
    popApexStyle(cCnt, vCnt)
end

if LogToConsole then
    LogToConsole("`2[BOREN.APEX] `0Demo Split-View Dashboard berhasil dimuat! Ketik /plant atau buka layar.")
end
