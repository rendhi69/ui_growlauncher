-- ============================================================================
-- UI 3 CONTOH LENGKAP: DEMO RUNNABLE BOREN.APEX SUITE v3.0
-- File: 3_ui_new_apex/example/demo_apex_suite.lua
-- ============================================================================
-- Jalankan file ini langsung di executor Growlauncher untuk mencoba Apex Suite!
-- ============================================================================

local APEX_DEMO_STATE = {
    running = false,
    minimized = false,
    activeTab = 1,
    worldInput = "APEXFARM1",
    doorInput = "",
    treesPlanted = 480,
    treesSpliced = 240,
    seed1Count = 200,
    seed2Count = 150,
}

function onDrawImGui()
    if not ImGui or not ImGui.Begin then return end

    -- Floating Mini HUD
    if APEX_DEMO_STATE.minimized then
        if ImGui.SetNextWindowSize and ImVec2 then pcall(ImGui.SetNextWindowSize, ImVec2(360, 56), 4) end
        if ImGui.Begin("BOREN.APEX MINI HUD##apex_mini") then
            ImGui.Text(APEX_DEMO_STATE.running and "[*] RUNNING | " or "[o] IDLE | ")
            ImGui.SameLine()
            ImGui.Text("World: " .. APEX_DEMO_STATE.worldInput)
            ImGui.SameLine()
            if ImGui.Button("Expand##exp") then APEX_DEMO_STATE.minimized = false end
            ImGui.SameLine()
            if ImGui.Button(APEX_DEMO_STATE.running and "STOP##st" or "START##st") then
                APEX_DEMO_STATE.running = not APEX_DEMO_STATE.running
            end
        end
        ImGui.End()
        return
    end

    -- Full Apex Dashboard
    if ImGui.SetNextWindowSize and ImVec2 then pcall(ImGui.SetNextWindowSize, ImVec2(720, 480), 4) end
    local openWin = ImGui.Begin("BOREN.APEX SUITE v3.0 - AUTO PLANT PRO##apex_main")
    if openWin then
        -- 1. Header Bar
        ImGui.Text("BOREN.APEX SUITE v3.0 | NODE: ID_BOT_01 | EXIT | 24ms | " .. (APEX_DEMO_STATE.running and "STATUS: RUNNING" or "STATUS: READY"))
        ImGui.SameLine()
        if ImGui.Button("-- MINIMIZE HUD##top_min") then APEX_DEMO_STATE.minimized = true end

        ImGui.Separator()

        -- 2. KPI Telemetry Ribbon
        ImGui.Text(string.format("POHON DITANAM: %d  |  SPLICE: %d  |  STOK SEED 1: %d  |  STOK SEED 2: %d",
            APEX_DEMO_STATE.treesPlanted, APEX_DEMO_STATE.treesSpliced, APEX_DEMO_STATE.seed1Count, APEX_DEMO_STATE.seed2Count))

        ImGui.Separator()

        -- 3. Modern Pill Tabs
        local tabs = { "Farm Dispatch", "Storage Vault", "Engine Pacing", "Safety & Shield", "Live Telemetry" }
        for idx, tName in ipairs(tabs) do
            local isAct = (idx == APEX_DEMO_STATE.activeTab)
            local label = isAct and ("[ " .. tName .. " ]") or ("  " .. tName .. "  ")
            if ImGui.Button(label .. "##atab_" .. idx) then APEX_DEMO_STATE.activeTab = idx end
            if idx < #tabs and ImGui.SameLine then ImGui.SameLine() end
        end

        ImGui.Separator()

        -- 4. Tab 1: Dispatch
        if APEX_DEMO_STATE.activeTab == 1 then
            ImGui.Text("=== BOREN APEX - PROFESSIONAL FARM DISPATCH ===")
            ImGui.Text("World Target: " .. APEX_DEMO_STATE.worldInput)
            ImGui.SameLine()
            if ImGui.Button("Sync World Saat Ini##sync_now") then
                local w = (GetWorld and GetWorld() and GetWorld().name) or "APEX_FARM"
                APEX_DEMO_STATE.worldInput = w
            end

            ImGui.Text("Quick Presets:")
            local presets = { "Grass #880", "Pepper #456", "L-Grid #2304", "Chand #5666" }
            for idx, p in ipairs(presets) do
                if ImGui.Button(p .. "##apre_" .. idx) then
                    if sendNotification then sendNotification("Preset dipilih: " .. p) end
                end
                if idx < #presets and ImGui.SameLine then ImGui.SameLine() end
            end

            ImGui.Separator()
            local heroLabel = APEX_DEMO_STATE.running and ">>> STOP AUTO PLANT <<<" or ">>> INITIATE AUTO PLANT <<<"
            if ImGui.Button(heroLabel .. "##hero_action") then
                APEX_DEMO_STATE.running = not APEX_DEMO_STATE.running
            end
        else
            ImGui.Text("Pengaturan Apex Tab: " .. tostring(tabs[APEX_DEMO_STATE.activeTab]))
        end
    end
    ImGui.End()
end

if LogToConsole then
    LogToConsole("`2[Boren Store] `0UI 3 (Apex Suite v3.0) berhasil dimuat! Ketik /plant atau buka layar.")
end
