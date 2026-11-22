-- ============================================================================
-- UI 1 MENTAHAN: NATIVE GROWLAUNCHER MENU BUILDER
-- File: 1_ui_native_launcher/components/native_menu_builder.lua
-- ============================================================================
-- Membangun menu native yang menempel di dalam interface Growlauncher.
-- 100% kompatibel dengan APK Growlauncher Android & PC.
-- ============================================================================

local NativeMenuBuilder = {}
NativeMenuBuilder.__index = NativeMenuBuilder

-- Helper serialize table ke JSON murni (jika jsonEncode bawaan tidak ada)
local function safeJsonEncode(val)
    if jsonEncode then return jsonEncode(val) end
    if json and json.encode then return json.encode(val) end
    local t = type(val)
    if t == "string" then
        return '"' .. val:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n') .. '"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        local isArr = (#val > 0)
        local parts = {}
        if isArr then
            for _, v in ipairs(val) do table.insert(parts, safeJsonEncode(v)) end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(val) do
                table.insert(parts, safeJsonEncode(tostring(k)) .. ":" .. safeJsonEncode(v))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    end
    return "null"
end

function NativeMenuBuilder.new(subName, iconName)
    local self = setmetatable({}, NativeMenuBuilder)
    self.sub_name = subName or "Menu"
    self.icon = iconName or "Settings"
    self.menu = {}
    return self
end

function NativeMenuBuilder:addLabelApp(text, icon)
    table.insert(self.menu, { type = "labelapp", text = tostring(text or ""), icon = icon or "Storefront" })
    return self
end

function NativeMenuBuilder:addLabel(text)
    table.insert(self.menu, { type = "label", text = tostring(text or "") })
    return self
end

function NativeMenuBuilder:addDivider()
    table.insert(self.menu, { type = "divider" })
    return self
end

function NativeMenuBuilder:addToggle(text, defaultVal, alias, autoSave)
    table.insert(self.menu, {
        type = "toggle",
        text = tostring(text or ""),
        default = (defaultVal == true),
        alias = tostring(alias or ""),
        autosave = (autoSave == true)
    })
    return self
end

function NativeMenuBuilder:addToggleButton(text, defaultVal, alias)
    table.insert(self.menu, {
        type = "toggle_button",
        text = tostring(text or ""),
        default = (defaultVal == true),
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addButton(text, alias)
    table.insert(self.menu, {
        type = "button",
        text = tostring(text or ""),
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addInputString(text, defaultVal, label, placeholder, icon, alias)
    table.insert(self.menu, {
        type = "input_string",
        text = tostring(text or ""),
        default = tostring(defaultVal or ""),
        label = tostring(label or "Text"),
        placeholder = tostring(placeholder or ""),
        icon = icon or "Public",
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addInputInt(text, defaultVal, label, placeholder, icon, alias)
    table.insert(self.menu, {
        type = "input_int",
        text = tostring(text or ""),
        default = tostring(defaultVal or "0"),
        label = tostring(label or "Angka"),
        placeholder = tostring(placeholder or "0"),
        icon = icon or "Numbers",
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addSlider(text, minVal, maxVal, defaultVal, stepVal, useDot, alias)
    table.insert(self.menu, {
        type = "slider",
        text = tostring(text or ""),
        min = tonumber(minVal) or 0,
        max = tonumber(maxVal) or 100,
        default = tonumber(defaultVal) or minVal or 0,
        step = tonumber(stepVal) or 1,
        usedot = (useDot == true),
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addTooltip(text, supportText, icon, background)
    table.insert(self.menu, {
        type = "tooltip",
        text = tostring(text or ""),
        support_text = tostring(supportText or ""),
        icon = icon or "Info",
        background = (background == true)
    })
    return self
end

function NativeMenuBuilder:addItemPicker(text, item, defaultVal, alias)
    table.insert(self.menu, {
        type = "item_picker",
        text = tostring(text or ""),
        item = item or "Blank",
        default = tostring(defaultVal or "0"),
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addDisplayList(text, defaultVal, alias)
    table.insert(self.menu, {
        type = "display_list",
        text = tostring(text or ""),
        default = tostring(defaultVal or "Default"),
        alias = tostring(alias or "")
    })
    return self
end

function NativeMenuBuilder:addExpandableToggle(text, defaultVal, alias, alwaysExpand, background)
    local obj = {
        type = "expandable_toggle",
        text = tostring(text or ""),
        default = (defaultVal == true),
        alias = tostring(alias or ""),
        always_expand = (alwaysExpand == true),
        background = (background == true),
        list_child = {}
    }
    table.insert(self.menu, obj)
    return obj
end

function NativeMenuBuilder:addChildButton(cardObj, text, alias)
    if cardObj and type(cardObj.list_child) == "table" then
        table.insert(cardObj.list_child, { type = "button", text = tostring(text or ""), alias = tostring(alias or "") })
    end
    return self
end

function NativeMenuBuilder:addChildToggle(cardObj, text, defaultVal, alias, autoSave)
    if cardObj and type(cardObj.list_child) == "table" then
        table.insert(cardObj.list_child, {
            type = "toggle",
            text = tostring(text or ""),
            default = (defaultVal == true),
            alias = tostring(alias or ""),
            autosave = (autoSave == true)
        })
    end
    return self
end

function NativeMenuBuilder:generateJSON()
    return safeJsonEncode({
        sub_name = self.sub_name,
        icon = self.icon,
        menu = self.menu
    })
end

-- ============================================================================
-- GLOBAL REGISTRY HELPERS
-- ============================================================================
function NativeMenuBuilder.registerCategory(categoryName, iconName)
    if addCategory then
        pcall(addCategory, tostring(categoryName), iconName or "Folder")
    end
end

function NativeMenuBuilder.addMenuToCategory(categoryName, menuBuilderObj)
    if addIntoModule and menuBuilderObj and menuBuilderObj.generateJSON then
        local jsonStr = menuBuilderObj:generateJSON()
        pcall(addIntoModule, tostring(categoryName), jsonStr)
    end
end

function NativeMenuBuilder.setToggle(alias, boolVal)
    if editToggle then pcall(editToggle, alias, boolVal == true) end
end

function NativeMenuBuilder.setDisplayList(alias, textVal)
    if editDisplayList then pcall(editDisplayList, alias, tostring(textVal)) end
end

return NativeMenuBuilder
