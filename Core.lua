--------------------------------------
-- Equip Recommended Gear: Core.lua --
--------------------------------------

local appName, app = ...
app.locales = {}
app.api = {}
EquipRecommendedGear = app.api
local api = app.api
local L = app.locales

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

function app.Event:Register(eventName, func)
	if not self.handlers[eventName] then
		self.handlers[eventName] = {}
		self:RegisterEvent(eventName)
	end
	table.insert(self.handlers[eventName], func)
end

app.Event:SetScript("OnEvent", function(self, event, ...)
	if self.handlers[event] then
		for _, handler in ipairs(self.handlers[event]) do
			handler(...)
		end
	end
end)

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag = {}

		C_ChatInfo.RegisterAddonMessagePrefix("EquipRecGear")
		app:CreateSlashCommands()
	end
end)

-------------------
-- VERSION COMMS --
-------------------

function app:SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "PARTY")
	end
end

app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata(appName, "Version")
	app:SendAddonMessage(message)
end)

app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == app.NamePrefix then
		local version = text:match("version:(.+)")
		if version and not app.Flag.VersionCheck then
			local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
			if expansion then
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata(appName, "Version")
				local expansion2, major2, minor2, iteration2 = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
				if expansion2 then
					expansion2 = string.format("%02d", expansion2)
					major2 = string.format("%02d", major2)
					minor2 = string.format("%02d", minor2)
					local localGameVersion = tonumber(expansion2 .. major2 .. minor2)
					local localAddonVersion = tonumber(iteration2)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						app:Print(L.NEW_VERSION_AVAILABLE, version)
						app.Flag.VersionCheck = true
					end
				end
			end
		end
	end
end)

--------------------
-- SLASH COMMANDS --
--------------------

function app:CreateSlashCommands()
	SLASH_RELOADUI1 = "/rl"
	SlashCmdList.RELOADUI = ReloadUI

	SLASH_EquipRecommendedGear1 = "/erg"
	function SlashCmdList.EquipRecommendedGear(msg, editBox)
		-- Split message into command and rest
		local command, rest = msg:match("^(%S*)%s*(.-)$")

		if command == "debug" then
			if app.Settings["debug"] == false then
				app.Settings["debug"] = true
				app:Print(L.DEBUG_ENABLED)
			else
				app.Settings["debug"] = false
				app:Print(L.DEBUG_DISABLED)
			end
		elseif command == "settings" then
			app:OpenSettings()
		else
			app:Print(L.INVALID_COMMAND)
		end
	end
end

----------------------
-- HELPER FUNCTIONS --
----------------------

function app:Colour(string)
	return "|cff3FC7EB" .. string .. "|r"
end

function app:Print(...)
	print(app.NameShort .. ":", ...)
end
