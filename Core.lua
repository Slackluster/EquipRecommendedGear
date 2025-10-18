--------------------------------------
-- Equip Recommended Gear: Core.lua --
--------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the addon name and a unique table
app.locales = {}	-- Localisation table
app.api = {}	-- Our "API" prefix
EquipRecommendedGear = app.api	-- Create a namespace for our "API"
local L = app.locales

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

-- Register the event and add it to the handlers table
function app.Event:Register(eventName, func)
	if not self.handlers[eventName] then
		self.handlers[eventName] = {}
		self:RegisterEvent(eventName)
	end
	table.insert(self.handlers[eventName], func)
end

-- Run all handlers for a given event, when it fires
app.Event:SetScript("OnEvent", function(self, event, ...)
	if self.handlers[event] then
		for _, handler in ipairs(self.handlers[event]) do
			handler(...)
		end
	end
end)

----------------------
-- HELPER FUNCTIONS --
----------------------

-- App colour
function app.Colour(string)
	return "|cffC69B6D" .. string .. "|R"
end

-- Print with addon prefix
function app.Print(...)
	print(app.NameShort .. ":", ...)
end

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag = {}
		app.Flag.VersionCheck = 0

		C_ChatInfo.RegisterAddonMessagePrefix("EquipRecGear")

		SLASH_EquipRecommendedGear1 = "/erg";
		function SlashCmdList.EquipRecommendedGear(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Toggle debug
			if command == "debug" then
				if EquipRecommendedGear_Settings["debug"] == false then
					EquipRecommendedGear_Settings["debug"] = true
					app.Print(L.DEBUG_ENABLED)
				else
					EquipRecommendedGear_Settings["debug"] = false
					app.Print(L.DEBUG_DISABLED)
				end
			-- Unlisted command
			else
				app.Print(L.INVALID_COMMAND)
			end
		end
	end
end)

-------------------
-- VERSION COMMS --
-------------------

-- Send information to other ERG users
function app.SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "PARTY")
	end
end

-- When joining a group
app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")
	app.SendAddonMessage(message)
end)

-- When we receive information over the addon comms
app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == "EquipRecGear" then
		-- Version
		local version = text:match("version:(.+)")
		if version then
			if version ~= "@project-version@" then
				local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")
				if localVersion ~= "@project-version@" then
					expansion, major, minor, iteration = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
					expansion = string.format("%02d", expansion)
					major = string.format("%02d", major)
					minor = string.format("%02d", minor)
					local localGameVersion = tonumber(expansion .. major .. minor)
					local localAddonVersion = tonumber(iteration)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						if GetServerTime() - app.Flag.VersionCheck > 600 then
							app.Print(L.NEW_VERSION_AVAILABLE, version)
							app.Flag.VersionCheck = GetServerTime()
						end
					end
				end
			end
		end
	end
end)
