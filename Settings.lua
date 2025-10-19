------------------------------------------
-- Equip Recommended Gear: Settings.lua --
------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not EquipRecommendedGear_Settings then EquipRecommendedGear_Settings = {} end
		if not EquipRecommendedGear_Settings["debug"] then EquipRecommendedGear_Settings["debug"] = false end
		if not EquipRecommendedGear_CharSettings then EquipRecommendedGear_CharSettings = {} end
		app.Settings()
	end
end)

--------------
-- SETTINGS --
--------------

-- Settings
function app.Settings()
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.NameLong)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata(appName, "Version")))

	local cbVariable, cbName, cbTooltip = "runAfterQuest", L.RUN_AFTER_QUEST, L.RUN_AFTER_QUEST_DESC
	local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, EquipRecommendedGear_Settings, Settings.VarType.Boolean, cbName, true)

	local ddVariable, ddName, ddTooltip = "chatMessage", L.CHAT_MESSAGE, L.CHAT_MESSAGE_DESC
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, L.MESSAGE_NEVER, L.MESSAGE_NEVER_DESC)
		container:Add(1, L.MESSAGE_UPGRADE, L.MESSAGE_UPGRADE_DESC)
		container:Add(2, L.MESSAGE_ALWAYS, L.MESSAGE_ALWAYS_DESC)
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, EquipRecommendedGear_Settings, Settings.VarType.Number, ddName, 1)

	local initializer = CreateSettingsCheckboxDropdownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)

	local variable, name, tooltip = "ignoreLemixJewelry", L.SETTINGS_IGNORELEMIXJEWELRY_TITLE, L.SETTINGS_IGNORELEMIXJEWELRY_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, EquipRecommendedGear_Settings, Settings.VarType.Boolean, name, true)
	checkbox = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "includeWeapons", L.SETTINGS_INCLUDEWEAPONS_TITLE, L.SETTINGS_INCLUDEWEAPONS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, EquipRecommendedGear_CharSettings, Settings.VarType.Boolean, name, true)
	checkbox = Settings.CreateCheckbox(category, setting, tooltip)
	if PlayerGetTimerunningSeasonID() then EquipRecommendedGear_CharSettings["includeWeapons"] = false end
end
