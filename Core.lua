--------------------------------------
-- Equip Recommended Gear: Core.lua --
--------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table
app.api = {}	-- Create a table to use for our "API"
EquipRecommendedGear = app.api	-- Create a namespace for our "API"
local api = app.api	-- Our "API" prefix

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
	return "|cffC69B6D"..string.."|R"
end

-- Print with AddOn prefix
function app.Print(...)
	print(app.NameShort..":", ...)
end

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag = {}
		
		C_ChatInfo.RegisterAddonMessagePrefix("EquipRecGear")

		SLASH_EquipRecommendedGear1 = "/erg";
		function SlashCmdList.EquipRecommendedGear(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Toggle debug
			if command == "debug" then
				if EquipRecommendedGear_Settings["debug"] == false then
					EquipRecommendedGear_Settings["debug"] = true
					app.Print("Debug mode enabled.")
				else
					EquipRecommendedGear_Settings["debug"] = false
					app.Print("Debug mode disabled.")
				end
			-- Unlisted command
			else
				app.Print("Invalid command.")
			end
		end
	end
end)

-------------------
-- VERSION COMMS --
-------------------

-- Send information to other ERG users
function app.SendAddonMessage(message)
	-- Check which channel to use
	if IsInRaid(2) or IsInGroup(2) then
		-- Share with instance group first
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		-- If not in an instance group, share it with the raid
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "RAID")
	elseif IsInGroup() then
		-- If not in a raid group, share it with the party
		ChatThrottleLib:SendAddonMessage("NORMAL", "EquipRecGear", message, "PARTY")
	end
end

-- When joining a group
app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	-- Share our AddOn version with other users
	local message = "version:"..C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")
	app.SendAddonMessage(message)
end)

-- When we receive information over the addon comms
app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	-- If it's our message
	if prefix == "EquipRecGear" then
		-- Version
		local version = text:match("version:(.+)")
		if version then
			if version ~= "@project-version@" then
				-- Extract the interface and version from this
				local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion..major..minor)
				local otherAddonVersion = tonumber(iteration)

				-- Do the same for our local version
				local localVersion = C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")
				if localVersion ~= "@project-version@" then
					expansion, major, minor, iteration = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d%d%d)")
					expansion = string.format("%02d", expansion)
					major = string.format("%02d", major)
					minor = string.format("%02d", minor)
					local localGameVersion = tonumber(expansion..major..minor)
					local localAddonVersion = tonumber(iteration)

					-- Now compare our versions
					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						-- But only send the message once every 10 minutes
						if not app.Flag["versionCheck"] then
							app.Flag["versionCheck"] = 0
						end
						if GetServerTime() - app.Flag["versionCheck"] > 600 then
							app.Print("There is a newer version of "..app.NameLong.." available: "..version)
							app.Flag["versionCheck"] = GetServerTime()
						end
					end
				end
			end
		end
	end
end)