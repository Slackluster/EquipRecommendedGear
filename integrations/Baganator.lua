local appName, app = ...
local api = app.api

-- Baganator integration
EventUtil.ContinueOnAddOnLoaded("Baganator", function()
	Baganator.API.RegisterUpgradePlugin("Equip Recommended Gear", "equip_recommended_gear", function(itemLink)
		return api:IsItemUpgrade(itemLink)
	end)

	app.Event:Register("PLAYER_LEVEL_UP", function(level, healthDelta, powerDelta, numNewTalents, numNewPvpTalentSlots, strengthDelta, agilityDelta, staminaDelta, intellectDelta)
		if Baganator.API.IsUpgradePluginActive("equip_recommended_gear") then
			app.IsItemEquippable = {}
			Baganator.API.RequestItemButtonsRefresh()
		end
	end)
end)
