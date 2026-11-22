-- ============================================================================
-- UI 1 MENTAHAN: IN-GAME NATIVE DIALOG BUILDER (SendVariant)
-- File: 1_ui_native_launcher/components/native_dialog_builder.lua
-- ============================================================================
-- Membangun dialog GUI klasik in-game Growtopia melalui packet SendVariant.
-- Cocok untuk popup formulir, pemilihan item, atau kelola list world.
-- ============================================================================

local NativeDialogBuilder = {}
NativeDialogBuilder.__index = NativeDialogBuilder

function NativeDialogBuilder.new(dialogName)
    local self = setmetatable({}, NativeDialogBuilder)
    self.dialog_name = dialogName or "boren_dialog"
    self.lines = {}
    return self
end

function NativeDialogBuilder:addLabelWithIcon(text, itemId, layoutType)
    table.insert(self.lines, string.format("add_label_with_icon|big|%s|left|%d|", tostring(text or ""), tonumber(itemId) or 0))
    return self
end

function NativeDialogBuilder:addSmallText(text)
    table.insert(self.lines, string.format("add_smalltext|%s|", tostring(text or "")))
    return self
end

function NativeDialogBuilder:addTextBox(text)
    table.insert(self.lines, string.format("add_textbox|%s|left|", tostring(text or "")))
    return self
end

function NativeDialogBuilder:addSpacer()
    table.insert(self.lines, "add_spacer|small|")
    return self
end

function NativeDialogBuilder:addTextInput(alias, label, defaultText, maxLen)
    table.insert(self.lines, string.format("add_text_input|%s|%s|%s|%d|", tostring(alias), tostring(label), tostring(defaultText or ""), tonumber(maxLen) or 32))
    return self
end

function NativeDialogBuilder:addCheckbox(alias, label, isChecked)
    table.insert(self.lines, string.format("add_checkbox|%s|%s|%d|", tostring(alias), tostring(label), isChecked and 1 or 0))
    return self
end

function NativeDialogBuilder:addButton(alias, text)
    table.insert(self.lines, string.format("add_button|%s|%s|noflags|0|0|", tostring(alias), tostring(text)))
    return self
end

function NativeDialogBuilder:addQuickExit()
    table.insert(self.lines, "add_quick_exit|")
    return self
end

function NativeDialogBuilder:endDialog(okAlias, cancelAlias, title)
    table.insert(self.lines, string.format("end_dialog|%s|%s|%s|", tostring(okAlias or "boren_ok"), tostring(cancelAlias or "Batal"), tostring(title or "OK")))
    return self
end

function NativeDialogBuilder:build()
    return table.concat(self.lines, "\n")
end

function NativeDialogBuilder:show(netId)
    local content = self:build()
    local targetNetId = tonumber(netId) or -1

    if sendVariant then
        pcall(sendVariant, { [0] = "OnDialogRequest", [1] = content }, targetNetId)
    elseif sendVariantList then
        pcall(sendVariantList, { [0] = "OnDialogRequest", [1] = content }, targetNetId)
    end
end

-- Helper parse response dialog dari packet SendPacket (2) dialog_return
function NativeDialogBuilder.parseResponse(packetStr)
    local fields = {}
    if type(packetStr) ~= "string" then return fields end
    for line in packetStr:gmatch("[^\r\n]+") do
        local k, v = line:match("^([^|]+)|(.*)$")
        if k then fields[k] = v end
    end
    return fields
end

return NativeDialogBuilder
