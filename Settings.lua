------------------------------------------
-- Equip Recommended Gear: Settings.lua --
------------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not EquipRecommendedGear_Settings then EquipRecommendedGear_Settings = {} end
		if not EquipRecommendedGear_Settings["debug"] then EquipRecommendedGear_Settings["debug"] = false end
		
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

	local cbVariable, cbName, cbTooltip = "runAfterQuest", "Run on Quest Completion", "Run "..app.NameShort.." when completing a quest, thus equipping any new quest rewards that are an item level upgrade."
	local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, EquipRecommendedGear_Settings, Settings.VarType.Boolean, cbName, true)

	local ddVariable, ddName, ddTooltip = "chatMessage", "Send Chat Message", "These settings only affect the chat message sent after quest completion."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "Never Send Message", "Don't send a message in chat, even if "..app.NameShort.." has equipped an item level upgrade.")
		container:Add(1, "Only With Upgrade", "Only send a message in chat if "..app.NameShort.." has equipped an item level upgrade.")
		container:Add(2, "Always Send Message", "Always send a chat message, even if "..app.NameShort.." hasn't equipped an item level upgrade.")
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, EquipRecommendedGear_Settings, Settings.VarType.Number, ddName, 1)

	local initializer = CreateSettingsCheckboxDropdownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)
end