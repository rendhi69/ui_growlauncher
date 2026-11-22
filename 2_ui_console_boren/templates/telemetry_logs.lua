-- ============================================================================
-- UI 2 MENTAHAN: TELEMETRY & CONSOLE LOGS TEMPLATE
-- File: 2_ui_console_boren/templates/telemetry_logs.lua
-- ============================================================================

local TelemetryLogs = {}

function TelemetryLogs.renderLogs(logsList)
    if not ImGui or not ImGui.BeginChild then return end

    ImGui.Text("Telemetry Activity Log:")
    if ImGui.BeginChild("log_scroll_region", ImVec2 and ImVec2(0, 180) or nil, true) then
        if type(logsList) == "table" and #logsList > 0 then
            for i = math.max(1, #logsList - 50), #logsList do
                ImGui.TextUnformatted(tostring(logsList[i]))
            end
        else
            ImGui.TextDisabled("Belum ada log tercatat.")
        end
        ImGui.EndChild()
    end
end

return TelemetryLogs
