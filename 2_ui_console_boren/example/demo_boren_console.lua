-- ============================================================================
-- UI 2 CONTOH LENGKAP: DEMO RUNNABLE BOREN CONSOLE IMGUI
-- File: 2_ui_console_boren/example/demo_boren_console.lua
-- ============================================================================
-- Jalankan file ini langsung di executor Growlauncher untuk mencoba Console ImGui!
-- ============================================================================

local DEMO_STATE = {
    running = false,
    minimized = false,
    activeTab = 1,
    currentWorld = "EXIT",
    worldInput = "WORLDFARM1",
    doorInput = "",
    treesPlanted = 120,
    logs = {
        "[00:00:01] System boot successful.",
        "[00:00:02] Connected to Growlauncher runtime.",
        "[00:00:03] Ready for dispatch."
    }
}

function onDrawImGui()
    if not ImGui or not ImGui.Begin then return end

    -- Mode Floating Mini HUD jika dimimize
    if DEMO_STATE.minimized then
        if ImGui.SetNextWindowSize and ImVec2 then pcall(ImGui.SetNextWindowSize, ImVec2(340, 50), 4) end
        if ImGui.Begin("BOREN MINI HUD##demo_m") then
            ImGui.Text(DEMO_STATE.running and "[*] AKTIF | " or "[o] IDLE | ")
            ImGui.SameLine()
            ImGui.Text("World: " .. DEMO_STATE.currentWorld)
            ImGui.SameLine()
            if ImGui.Button("Expand") then DEMO_STATE.minimized = false end
            ImGui.SameLine()
            if ImGui.Button(DEMO_STATE.running and "STOP" or "START") then DEMO_STATE.running = not DEMO_STATE.running end
        end
        ImGui.End()
        return
    end

    -- Window Utama Console ImGui
    if ImGui.SetNextWindowSize and ImVec2 then pcall(ImGui.SetNextWindowSize, ImVec2(620, 420), 4) end
    local openWin = ImGui.Begin("BOREN STORE - CONSOLE PRO v2.0##main_con")
    if openWin then
        -- Top Status Header
        ImGui.Text("STATUS: " .. (DEMO_STATE.running and "RUNNING" or "READY") .. " | BOT: NODE_01 | WORLD: " .. DEMO_STATE.currentWorld)
        ImGui.SameLine()
        if ImGui.Button("-- Minimize") then DEMO_STATE.minimized = true end

        ImGui.Separator()

        -- Tab Navigation
        local tabs = { "1. Dispatch", "2. Storage", "3. Pacing", "4. Logs" }
        for idx, tName in ipairs(tabs) do
            local isAct = (idx == DEMO_STATE.activeTab)
            if ImGui.Button((isAct and ("[" .. tName .. "]") or (" " .. tName .. " ")) .. "##tab_" .. idx) then
                DEMO_STATE.activeTab = idx
            end
            if idx < #tabs and ImGui.SameLine then ImGui.SameLine() end
        end

        ImGui.Separator()

        -- Tab Contents
        if DEMO_STATE.activeTab == 1 then
            ImGui.Text("=== WORLD DISPATCH FORM ===")
            ImGui.Text("World Input:")
            ImGui.SameLine()
            if ImGui.InputText then
                local ok, r1, r2 = pcall(ImGui.InputText, "##inp_w", DEMO_STATE.worldInput, 32)
                if ok and type(r1) == "string" then DEMO_STATE.worldInput = r1
                elseif ok and type(r2) == "string" then DEMO_STATE.worldInput = r2 end
            end

            if ImGui.Button("Sync World Sekarang") then
                local w = (GetWorld and GetWorld() and GetWorld().name) or "MYWORLD"
                DEMO_STATE.worldInput = w
                DEMO_STATE.currentWorld = w
            end

            ImGui.Separator()
            if ImGui.Button(DEMO_STATE.running and "■ STOP AUTO PLANT" or "▶ INITIATE AUTO PLANT") then
                DEMO_STATE.running = not DEMO_STATE.running
                table.insert(DEMO_STATE.logs, DEMO_STATE.running and "[DISPATCH] Bot dimulai." or "[DISPATCH] Bot dihentikan.")
            end

        elseif DEMO_STATE.activeTab == 4 then
            ImGui.Text("Live Console Logs:")
            if ImGui.BeginChild and ImGui.BeginChild("log_sub", ImVec2 and ImVec2(0, 200) or nil, true) then
                for _, line in ipairs(DEMO_STATE.logs) do ImGui.TextUnformatted(line) end
                ImGui.EndChild()
            end
        else
            ImGui.Text("Pengaturan sub-menu tab " .. DEMO_STATE.activeTab)
        end
    end
    ImGui.End()
end

if LogToConsole then
    LogToConsole("`2[Boren Store] `0UI 2 (Console ImGui) berhasil dimuat! Buka layar game untuk melihat.")
end
