-- ============================================================================
-- UI 3 MENTAHAN: APEX KPI TELEMETRY RIBBON
-- File: 3_ui_new_apex/templates/apex_kpi_ribbon.lua
-- ============================================================================

local ApexKPIRibbon = {}

function ApexKPIRibbon.render(metrics)
    if not ImGui then return end
    metrics = metrics or {}

    ImGui.Text("POHON DITANAM:")
    ImGui.SameLine()
    ImGui.Text(string.format(" %d ", tonumber(metrics.treesPlanted) or 0))
    ImGui.SameLine()
    ImGui.Text(" |  SPLICE:")
    ImGui.SameLine()
    ImGui.Text(string.format(" %d ", tonumber(metrics.treesSpliced) or 0))
    ImGui.SameLine()
    ImGui.Text(" |  STOK BENIH 1:")
    ImGui.SameLine()
    ImGui.Text(string.format(" %d ", tonumber(metrics.seed1Count) or 0))
    ImGui.SameLine()
    ImGui.Text(" |  STOK BENIH 2:")
    ImGui.SameLine()
    ImGui.Text(string.format(" %d ", tonumber(metrics.seed2Count) or 0))
    ImGui.Separator()
end

return ApexKPIRibbon
