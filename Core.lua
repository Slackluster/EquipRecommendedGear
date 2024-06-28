--------------------------------------
-- Equip Recommended Gear: Core.lua --
--------------------------------------
-- Main AddOn code

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table
app.api = {}	-- Create a table to use for our "API"
EquipRecommendedGear = app.api	-- Create a namespace for our "API"
local api = app.api	-- Our "API" prefix

----------------------
-- HELPER FUNCTIONS --
----------------------

-- WoW API Events
local event = CreateFrame("Frame")
event:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		self[event](self, ...)
	end
end)
event:RegisterEvent("ADDON_LOADED")
event:RegisterEvent("CHAT_MSG_ADDON")
event:RegisterEvent("QUEST_TURNED_IN")

-- Table dump
function app.Dump(table)
	local function dumpTable(o)
		if type(o) == 'table' then
			local s = '{ '
			for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
			end
		return s .. '} '
		else
			return tostring(o)
		end
	end
	print(dumpTable(table))
end

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

-- Create SavedVariables, default user settings, and session variables
function app.Initialise()
	-- Declare SavedVariables
	if not EquipRecommendedGear_Settings then EquipRecommendedGear_Settings = {} end

	-- Enable default user settings
	if EquipRecommendedGear_Settings["runAfterQuest"] == nil then EquipRecommendedGear_Settings["runAfterQuest"] = true end
	if EquipRecommendedGear_Settings["chatMessage"] == nil then EquipRecommendedGear_Settings["chatMessage"] = 1 end

	-- Declare session variables
	app.DoingStuff = false

	-- Get player info
	app.Sex = C_PlayerInfo.GetSex(PlayerLocation:CreateFromUnit("player"))
	app.ClassID = PlayerUtil.GetClassID()

	-- Register our AddOn communications channel
	C_ChatInfo.RegisterAddonMessagePrefix("EquipRecGear")
end

function app.CreateAssets()
	-- The button
	app.Button = CreateFrame("Button", "rcButton", PaperDollSidebarTabs)
	app.Button:SetWidth(30)
	app.Button:SetHeight(30)
	app.Button:SetNormalTexture("Interface\\AddOns\\EquipRecommendedGear\\assets\\erg_icon.blp")
	app.Button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	app.Button:SetPoint("TOPRIGHT", PaperDollSidebarTab1, "TOPLEFT", -4, -4)
	app.Button:SetFrameStrata("HIGH")
	app.Button:RegisterForClicks("AnyDown", "AnyUp")
	app.Button:SetScript("OnClick", function()
		-- Make sure it doesn't run twice because it checks for both down and up
		if app.DoingStuff == false then
			app.DoingStuff = true
			
			-- Run the code
			api.DoTheThing()
			C_Timer.After(.5, function() api.DoTheThing(0) end)	-- Run it twice because sometimes weird stuff happens >:
			
			C_Timer.After(1, function() app.DoingStuff = false end)
		end
	end)
	app.Button:SetScript("OnEnter", function() app.Button.Tooltip:Show() end)
	app.Button:SetScript("OnLeave", function() app.Button.Tooltip:Hide() end)

	-- Tooltip
	app.Button.Tooltip = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.Button.Tooltip:SetFrameStrata("TOOLTIP")
	app.Button.Tooltip:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	app.Button.Tooltip:SetBackdropColor(0, 0, 0, 0.7)
	app.Button.Tooltip:EnableMouse(true)

	-- Tooltip text
	local string = app.Button.Tooltip:CreateFontString("ARTWORK", nil, "GameFontNormal")
	string:SetPoint("CENTER", app.Button.Tooltip, "CENTER", 0, 0)
	string:SetPoint("TOP", app.Button.Tooltip, "TOP", 0, -10)
	string:SetJustifyH("CENTER")
	string:SetText("|cffFFFFFFEquip Recommended Gear")
	string:SetScale(1.1)
	app.Button.Tooltip:SetHeight(string:GetStringHeight()*1.1+20)
	app.Button.Tooltip:SetWidth(string:GetStringWidth()*1.1+20)
	app.Button.Tooltip:Hide()
	app.Button.Tooltip:SetPoint("BOTTOMLEFT", app.Button, "TOPRIGHT", 0, 4)
end

-- When an AddOn is fully loaded
function event:ADDON_LOADED(addOnName, containsBindings)
	-- When it's our AddOn
	if addOnName == appName then
		-- Run the components
		app.Initialise()
		app.CreateAssets()
		app.Settings()
	end
end

------------------
-- DO THE THING --
------------------

-- DoTheThing(0): send no chat messages even if new gear equipped
-- DoTheThing(1): only send chat message if new gear equipped
-- DoTheThing(): send all chat messages
function api.DoTheThing(msg)
	-- Don't do stuff if we're in combat
	if UnitAffectingCombat("player") == true then
		app.Print("Cannot recommend gear while in combat.")
		do return end
	end

	-- Check this stuff now, because this is when it matters and it could've changed
	app.SpecID = PlayerUtil.GetCurrentSpecID()
	app.Level = UnitLevel("player")

	-- Can the player dual wield
	app.CanDualWield = false
	for k, v in pairs(app.DualWield) do
		if app.SpecID == v then
			app.CanDualWield = true
		end
	end

	-- Get all equipped items (except weapons, we check those later)
	local itemLevel = {}
	itemLevel[1] = GetInventoryItemLink("player", 1) or 0	-- Head
	itemLevel[2] = GetInventoryItemLink("player", 2) or 0	-- Neck
	itemLevel[3] = GetInventoryItemLink("player", 3) or 0	-- Shoulders
	itemLevel[15] = GetInventoryItemLink("player", 15) or 0	-- Back
	itemLevel[5] = GetInventoryItemLink("player", 5) or 0	-- Chest
	itemLevel[9] = GetInventoryItemLink("player", 9) or 0	-- Wrist
	itemLevel[10] = GetInventoryItemLink("player", 10) or 0	-- Hands
	itemLevel[6] = GetInventoryItemLink("player", 6) or 0	-- Waist
	itemLevel[7] = GetInventoryItemLink("player", 7) or 0	-- Legs
	itemLevel[8] = GetInventoryItemLink("player", 8) or 0	-- Feet
	itemLevel[11] = GetInventoryItemLink("player", 11) or 0	-- Finger1
	itemLevel[12] = GetInventoryItemLink("player", 12) or 0	-- Finger2
	itemLevel[13] = GetInventoryItemLink("player", 13) or 0	-- Trinket1
	itemLevel[14] = GetInventoryItemLink("player", 14) or 0	-- Trinket2

	-- Turn all equipped items into their iLv values
	for k, v in pairs(itemLevel) do
		if v ~= 0 then
			local itemID = GetItemInfoInstant(v)
			local _, _, _, _, _, _, _, _, _, maxLevel = C_Heirloom.GetHeirloomInfo(itemID)
			local ilv = GetDetailedItemLevelInfo(v) or 0
			if C_Heirloom.IsItemHeirloom(itemID) == true then
				-- Check if we're not too quick
				if maxLevel ~= nil then
					-- If heirloom isn't maxed, assume player wants to keep it equipped
					if maxLevel >= app.Level then
						ilv = 9999
					end
				else
					app.Print("Something went wrong. Please try again in a few seconds.")
					do return end
				end	
			end
			itemLevel[k] = ilv
		end
	end

	-- Get bag info
	local bag = {}
	for i = 0, 5 do
		bag[i] = C_Container.GetContainerNumSlots(i)
	end

	-- Check bags for soulbound gear
	local item = {}
	for k, v in pairs(bag) do
		if v > 0 then
			for i=1, v, 1 do
				local itemLink = C_Container.GetContainerItemLink(k, i)

				if itemLink ~= nil then
					-- If the item is equippable
					if C_Item.IsEquippableItem(itemLink) then
						-- Get item info
						local _, _, _, _, itemMinLevel, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)
						if itemEquipLoc == nil or classID == nil or subclassID == nil then
							app.Print("Something went wrong. Please try again in a few seconds.")
							do return end
						end

						-- If the item is soulbound and the player's level is high enough to equip it
						if C_Item.IsBound(ItemLocation:CreateFromBagAndSlot(k, i)) == true and app.Level >= itemMinLevel then
							local itemlevel = GetDetailedItemLevelInfo(itemLink)

							-- Add 1 item level to heirlooms, so when it's a tie it is preferred over the alternative
							local itemID = C_Item.GetItemInfoInstant(itemLink)
							if C_Heirloom.IsItemHeirloom(itemID) == true then
								itemlevel = itemlevel + 1
							end

							item[#item+1] = {item = itemLink, slot = itemEquipLoc, type = classID.."."..subclassID, ilv = itemlevel }
						end
					end
				end
			end
		end
	end
	-- Also add equipped weapons, to make things a lot easier on ourselves
	for slot = 16, 17 do
		if GetInventoryItemLink("player", slot) ~= nil then
			-- Get item info
			local itemLink = GetInventoryItemLink("player", slot)
			local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)
			local itemlevel = GetDetailedItemLevelInfo(itemLink)

			-- Check for heirlooms
			local itemID = GetItemInfoInstant(itemLink)
			local _, _, _, _, _, _, _, _, _, maxLevel = C_Heirloom.GetHeirloomInfo(itemID)

			if C_Heirloom.IsItemHeirloom(itemID) == true then
				-- Check if we're not too quick
				if maxLevel ~= nil then
					-- If heirloom isn't maxed, assume player wants to keep it equipped
					if maxLevel >= app.Level then
						itemlevel = 9999
					end
				else
					app.Print("Something went wrong. Please try again in a few seconds.")
					do return end
				end	
			end

			-- Check if we're not too quick
			if itemEquipLoc == nil or classID == nil or subclassID == nil then
				app.Print("Something went wrong. Please try again in a few seconds.")
				do return end
			end

			-- Process the weapons
			item[#item+1] = {item = itemLink, slot = itemEquipLoc, type = classID.."."..subclassID, ilv = itemlevel }
		end
	end

	-- Get the player's armor class
	local armorClass
	for k, v in pairs(app.Armor) do
		for _, v2 in pairs(v) do
			if v2 == app.ClassID then
				armorClass = k
			end
		end
	end

	-- Get the player's primary stat
	local primaryStat
	for k, v in pairs(app.Stat) do
		for _, v2 in pairs(v) do
			if v2 == app.SpecID then
				primaryStat = k
			end
		end
	end

	-- Check soulbound gear for eligibility
	local upgrade = {}
	local weaponUpgrade = {}

	for k, v in pairs(item) do
		-- Check if the item can and should be equipped (armor -> class)
		local equippable = false
		if v.type == app.Type[armorClass] or (v.type == app.Type["General"] and v.slot ~= "INVTYPE_TABARD" and v.slot ~= "INVTYPE_BODY" and v.slot ~= "INVTYPE_WEAPONOFFHAND" and v.slot ~= "INVTYPE_HOLDABLE" and v.slot ~= "INVTYPE_SHIELD") or v.slot == "INVTYPE_CLOAK" then
			equippable = true
		end
		-- Get the weapon type
		local weapon = false
		for k2, v2 in pairs(app.Type) do
			if v2 == v.type and not (v.type == "4.1" or v.type == "4.2" or v.type == "4.3" or v.type == "4.4" or (v.type == "4.0" and v.slot ~= "INVTYPE_HOLDABLE" and v.slot ~= "INVTYPE_WEAPONOFFHAND")) then
				for _, v3 in pairs(app.Weapon[k2]) do
					-- Check if the item can and should be equipped (weapon -> spec)
					if v3 == app.SpecID then
						weapon = true
						for k, v in pairs(GetItemStats(v.item)) do
							-- Check if the item has the spec's primary stat
							if primaryStat == k then
								equippable = true
							end
						end
					end
				end
			end
		end

		if equippable == true then
			-- Check for Unique-Equipped items
			local itemID = GetItemInfoFromHyperlink(v.item)
			if C_Item.GetItemUniquenessByID(itemID) == true then
				-- Check against equipped items
				for slot = 1, 17 do
					local equippedItemID = GetInventoryItemID("player", slot)
					-- If the same one is also equipped
					if equippedItemID and equippedItemID == itemID then
						if v.ilv <= GetDetailedItemLevelInfo(v.item) then
							v.ilv = -1	-- Dirty way to make sure the item isn't marked as an upgrade
						end
					end
				end
				-- Check against others in bag
				for k2, v2 in pairs(upgrade) do
					if v2.item == v.item then
						-- Grab the lowest iLv of the two, and remove it from the equation
						if v2.ilv <= v.ilv then
							v2.ilv = -1	-- Dirty way to make sure the item isn't marked as an upgrade
						else
							v.ilv = -1	-- Dirty way to make sure the item isn't marked as an upgrade
						end
					end
				end
			end

			-- Set the iLv to compare to
			local compareItemLevel = 9999	-- Default should be not applicable
			if weapon == true and equippable == true then
				compareItemLevel = 0
				--app.Dump(v)
			elseif v.slot == "INVTYPE_FINGER" then
				compareItemLevel = math.min(itemLevel[11], itemLevel[12])
			elseif v.slot == "INVTYPE_TRINKET" then
				compareItemLevel = math.min(itemLevel[13], itemLevel[14])
			else
				compareItemLevel = itemLevel[app.Slot[v.slot]]
			end

			-- Check if the item level is higher
			if v.ilv > compareItemLevel then
				upgrade[#upgrade+1] = { item = v.item, slot = app.Slot[v.slot], ilv = v.ilv }
			end
		end
	end

	-- Place the highest ring or trinket into its own slot (thanks ChatGPT)
	local function changeHighestForSlot(table, fromSlot, toSlot)
		local highestEntry = nil
	
		for i = #table, 1, -1 do
			local entry = table[i]
			local slot = entry.slot
	
			if slot == fromSlot then
				if not highestEntry or entry.ilv > highestEntry.ilv then
					highestEntry = entry
				end
			end
		end
	
		if highestEntry then
			highestEntry.slot = toSlot
		end
	end
	changeHighestForSlot(upgrade, 11, 12)
	changeHighestForSlot(upgrade, 13, 14)

	-- Count rings and trinkets
	local ringNo = 0
	local trinketNo = 0
	local ringKey
	local trinketKey
	for k, v in pairs(upgrade) do
		if v.slot == 11 or v.slot == 12 then
			ringNo = ringNo + 1
			ringKey = k
		elseif v.slot == 13 or v.slot == 14 then
			trinketNo = trinketNo + 1
			trinketKey = k
		end
	end

	-- Move rings/trinkets to proper slot if there's only one
	if ringNo == 1 and itemLevel[11] < itemLevel[12] then
		upgrade[ringKey].slot = 11
	end
	if trinketNo == 1 and itemLevel[13] < itemLevel[14] then
		upgrade[trinketKey].slot = 13
	end

	-- Move one-handed weapons to main hand, if the character cannot dual wield
	if app.CanDualWield == false then
		for k, v in pairs(upgrade) do
			if v.slot == 18 then
				upgrade[k].slot = 16
			end
		end
	end

	-- Check upgrades for multiples of the same slot and only keep the best one, or best two for 1-Handers (thanks ChatGPT)
	local function processGearTable(gearTable)
		local seenSlots = {}
	
		for i = #gearTable, 1, -1 do
			local entry = gearTable[i]
			local slot = entry.slot
	
			if slot == 18 then
				-- Handle slot 18 (keep the best two)
				seenSlots[slot] = seenSlots[slot] or {}
	
				if #seenSlots[slot] < 2 then
					-- If fewer than two entries, just add the current entry
					table.insert(seenSlots[slot], entry)
				else
					-- Find the two entries with the highest ilv
					local minIlvIndex = 1
					for j = 2, #seenSlots[slot] do
						if seenSlots[slot][j].ilv < seenSlots[slot][minIlvIndex].ilv then
							minIlvIndex = j
						end
					end
	
					-- Replace the entry with the lowest ilv if the current entry has a higher ilv
					if entry.ilv > seenSlots[slot][minIlvIndex].ilv then
						seenSlots[slot][minIlvIndex] = entry
					else
						-- Remove the current entry if its ilv is not higher
						table.remove(gearTable, i)
					end
				end
			elseif not seenSlots[slot] or entry.ilv > seenSlots[slot].ilv then
				-- For other slots, keep only the entry with the highest ilv
				seenSlots[slot] = entry
				-- Remove any additional entries for the same slot
				for j = #gearTable, i + 1, -1 do
					if gearTable[j].slot == slot then
						table.remove(gearTable, j)
					end
				end
			else
				-- Remove duplicates for the same slot with lower ilv
				table.remove(gearTable, i)
			end
		end
	end
	processGearTable(upgrade)

	-- Remove the lowest ring or trinket entry if neither is an upgrade for the best equipped (we previously only checked if it's an upgrade for the worst equipped)
	for k, v in pairs(upgrade) do
		if v.slot == 12 and v.ilv <= itemLevel[12] then
			for k, v in pairs(upgrade) do
				if v.slot == 11 then
					upgrade[k] = nil
				end
			end
		elseif v.slot == 14 and v.ilv <= itemLevel[14] then
			for k, v in pairs(upgrade) do
				if v.slot == 13 then
					upgrade[k] = nil
				end
			end
		end
	end

	-- Move the weapons into a separate table for easier processing
	local weaponUpgrade = {}
	for k, v in pairs(upgrade) do
		if v.slot == 1617 or v.slot == 16 or v.slot == 17 or v.slot == 18 then
			weaponUpgrade[#weaponUpgrade+1] = v
			upgrade[k] = nil
		end
	end

	-- Get best weapons (thanks ChatGPT)
	function findBestWeaponCombo(weaponUpgrade)
		if #weaponUpgrade == 1 then
			return weaponUpgrade
		end
	
		local maxIlv = 0
		local bestCombo = {}
	
		for i, weapon1 in ipairs(weaponUpgrade) do
			for j, weapon2 in ipairs(weaponUpgrade) do
				if i ~= j then
					local comboIlv = weapon1["ilv"]
	
					if weapon1["slot"] == 1617 then
						-- If it's a two-handed weapon, count its ilv twice
						comboIlv = comboIlv * 2
					else
						-- Check valid combinations for one-handed, main-hand, and off-hand weapons
						if (weapon1["slot"] == 16 and weapon2["slot"] == 17) or
						   (weapon1["slot"] == 17 and weapon2["slot"] == 16) or
						   (weapon1["slot"] == 16 and weapon2["slot"] == 18) or
						   (weapon1["slot"] == 18 and weapon2["slot"] == 16) or
						   (weapon1["slot"] == 18 and weapon2["slot"] == 17) or
						   (weapon1["slot"] == 17 and weapon2["slot"] == 18) or
						   (weapon1["slot"] == 18 and weapon2["slot"] == 18) then
							comboIlv = comboIlv + weapon2["ilv"]
						end
					end
	
					if comboIlv > maxIlv then
						maxIlv = comboIlv
						if weapon1["slot"] == 1617 then
							bestCombo = { weapon1 }
						else
							bestCombo = { weapon1, weapon2 }
						end
					end
				end
			end
		end
	
		return bestCombo
	end

	local bestWeapons = findBestWeaponCombo(weaponUpgrade)

	-- Put these back in the upgrade table, if they're not equipped
	for k, v in pairs(bestWeapons) do
		if v.slot == 1617 then v.slot = 16 end
		local item16 = "None"
		local item17 = "None"
		if GetInventoryItemLink("player", 16) ~= nil then
			item16 = GetInventoryItemLink("player", 16)
		end
		if GetInventoryItemLink("player", 17) ~= nil then
			item17 = GetInventoryItemLink("player", 17)
		end

		if not (v.item == item16 or v.item == item17) then
			upgrade[#upgrade+1] = v
		end
	end

	-- Print usage
	local _, specName = GetSpecializationInfoByID(app.SpecID, app.Sex)
	local className, classFile = GetClassInfo(app.ClassID)
	local _, _, _, classColor = GetClassColor(classFile)

	-- Set the message variable if it's not set (properly)
	if not msg then
		msg = 2
	end
	if type(msg) ~= "number" then
		msg = 2
	end

	local next = next
	-- If there's no upgrades
	if next(upgrade) == nil and specName ~= nil then
		-- And the message should be sent
		if msg == 2 then
			app.Print("You are currently equipped with the recommended gear for |c"..classColor..specName.." "..className.."|R.")
		end
	-- If there are upgrades
	elseif specName ~= nil then
		-- And the message should be sent
		if msg >= 1 then
			app.Print("Gear recommended for |c"..classColor..specName.." "..className.."|R equipped.")
		end
	else
		app.Print("Something went wrong. Please try again in a few seconds.")
	end

	-- Equip the upgrades
	for k, v in pairs(upgrade) do
		C_Timer.After(0.5, function()
			if v.slot == 18 then
				C_Item.EquipItemByName(v.item)
			else
				C_Item.EquipItemByName(v.item, v.slot)
			end
		end)
	end
end

-- Do the thing on quest completion
function event:QUEST_TURNED_IN(questID, xpReward, moneyReward)
	-- Run if the setting is enabled
	if EquipRecommendedGear_Settings["runAfterQuest"] == true then
		C_Timer.After(1, function()
			-- And respect the chat message setting
			api.DoTheThing(EquipRecommendedGear_Settings["chatMessage"])
		end)
	end
end

--------------
-- SETTINGS --
--------------

-- Settings
function app.Settings()
	-- Settings page
	function app.SettingChanged(_, setting, value)
		local variable = setting:GetVariable()
		EquipRecommendedGear_Settings[variable] = value
	end

	local category, layout = Settings.RegisterVerticalLayoutCategory(app.NameLong)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")))

	local cbVariable, cbName, cbTooltip = "runAfterQuest", "Run on quest completion", "Run "..app.NameShort.." when completing a quest, thus equipping any new quest rewards that are an item level upgrade."
	local cbSetting = Settings.RegisterAddOnSetting(category, cbName, cbVariable, Settings.VarType.Boolean, EquipRecommendedGear_Settings[cbVariable])
	Settings.SetOnValueChangedCallback(cbVariable, app.SettingChanged)

	local ddVariable, ddName, ddTooltip = "chatMessage", "Send chat message", "These settings only affect the chat message sent after quest completion."
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, "Never send message", "Don't send a message in chat, even if "..app.NameShort.." has equipped an item level upgrade.")
		container:Add(1, "Only with upgrade", "Only send a message in chat if "..app.NameShort.." has equipped an item level upgrade.")
		container:Add(2, "Always send message", "Always send a chat message, even if "..app.NameShort.." hasn't equipped an item level upgrade.")
		return container:GetData()
	end
	local ddSetting = Settings.RegisterAddOnSetting(category, ddName, ddVariable, Settings.VarType.Number, EquipRecommendedGear_Settings[ddVariable])
	Settings.SetOnValueChangedCallback(ddVariable, app.SettingChanged)

	local initializer = CreateSettingsCheckBoxDropDownInitializer(
		cbSetting, cbName, cbTooltip,
		ddSetting, GetOptions, ddName, ddTooltip)
	layout:AddInitializer(initializer)
	
	--initializer:AddSearchTags
	--defaults?
end

-----------------
-- ADDON COMMS --
-----------------

-- Send information to other PSL users
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
function event:GROUP_JOINED(category, partyGUID)
	-- Share our AddOn version with other users
	local message = "version:"..C_AddOns.GetAddOnMetadata("EquipRecommendedGear", "Version")
	app.SendAddonMessage(message)
end

-- When we receive information over the addon comms
function event:CHAT_MSG_ADDON(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
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
						app.Print("There is a newer version of "..app.NameLong.." available: "..version)
					end
				end
			end
		end
	end
end