------------------------------------------------------
-- Equip Recommended Gear: EquipRecommendedGear.lua --
------------------------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the AddOn name and a unique table
local api = app.api	-- Our "API" prefix

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Sex = C_PlayerInfo.GetSex(PlayerLocation:CreateFromUnit("player"))
		app.ClassID = PlayerUtil.GetClassID()

		app.CreateAssets()
	end
end)

----------------------------
-- EQUIP RECOMMENDED GEAR --
----------------------------

-- Button
function app.CreateAssets()
	-- Button
	app.Button = CreateFrame("Button", "rcButton", PaperDollSidebarTabs)
	app.Button:SetWidth(30)
	app.Button:SetHeight(30)
	app.Button:SetNormalTexture("Interface\\AddOns\\EquipRecommendedGear\\assets\\erg_icon.blp")
	app.Button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	app.Button:SetPoint("TOPRIGHT", PaperDollSidebarTab1, "TOPLEFT", -4, -4)
	app.Button:SetFrameStrata("HIGH")
	app.Button:RegisterForClicks("AnyDown", "AnyUp")
	app.Button:SetScript("OnClick", function()
		api.DoTheThing()
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

-- Do the thing
function api.DoTheThing(msg)
	-- Don't do stuff if we're still running this function
	if not app.Flag["Busy"] then app.Flag["Busy"] = false end
	if app.Flag["Busy"] == true then
		do return end
	end

	-- Don't do stuff if we're in combat
	if InCombatLockdown() then
		C_Timer.After(1, function()
			app.Print("Cannot recommend gear while in combat.")
			app.Flag["Busy"] = false
		end)
		do return end
	end

	-- We are now doing stuff
	app.Flag["Busy"] = true

	-- Check this stuff now, because this is when it matters and it could've changed
	app.SpecID = PlayerUtil.GetCurrentSpecID()
	app.Level = UnitLevel("player")

	-- Names for print usage
	local _, specName = GetSpecializationInfoByID(app.SpecID, app.Sex)
	local className, classFile = GetClassInfo(app.ClassID)
	local _, _, _, classColor = GetClassColor(classFile)

	-- Manual override for Fury Warriors, since they can use 2x1H or 2x2H
	if app.SpecID == 72 then
		-- If Single-Minded Fury is learned
		if IsPlayerSpell(81099) then
			app.SpecID = 721
		else
			app.SpecID = 722
		end
	end

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
			local ilv = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(k)) or 0
			if C_Heirloom.IsItemHeirloom(itemID) == true then
				-- Check if we're not too quick
				if maxLevel ~= nil then
					-- If heirloom isn't maxed, assume player wants to keep it equipped
					if maxLevel >= app.Level then
						ilv = 9999
					end
				else
					C_Timer.After(1, function()
						app.Print("Could not read equipped heirloom gear. Please try again in a few seconds.")
						app.Flag["Busy"] = false
					end)
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
							C_Timer.After(1, function()
								app.Print("Could not read gear in inventory. Please try again in a few seconds.")
								app.Flag["Busy"] = false
							end)
							do return end
						end

						-- If the item is soulbound and the player's level is high enough to equip it
						if C_Item.IsBound(ItemLocation:CreateFromBagAndSlot(k, i)) == true and app.Level >= itemMinLevel then
							local itemlevel = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromBagAndSlot(k, i))

							-- Check for heirlooms
							local itemID = C_Item.GetItemInfoInstant(itemLink)
							if C_Heirloom.IsItemHeirloom(itemID) == true then
								local _, _, _, _, _, _, _, _, _, maxLevel = C_Heirloom.GetHeirloomInfo(itemID)
								if maxLevel ~= nil then
									-- If heirloom isn't maxed, assume player wants to use it
									if maxLevel >= app.Level then
										itemlevel = 9999
									end
								end
							end

							item[#item+1] = {item = itemLink, slot = itemEquipLoc, type = classID.."."..subclassID, ilv = itemlevel, bag = k, bagslot = i }
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
			local itemlevel = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot))

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
					C_Timer.After(1, function()
						app.Print("Could not read equipped heirloom weapon(s). Please try again in a few seconds. If this error keeps occurring, please ensure you do not have an outdated Hellscream weapon.")
						app.Flag["Busy"] = false
					end)
					do return end
				end	
			end

			-- Check if we're not too quick
			if itemEquipLoc == nil or classID == nil or subclassID == nil then
				C_Timer.After(1, function()
					app.Print("Could not read equipped weapon(s). Please try again in a few seconds.")
					app.Flag["Busy"] = false
				end)
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
		-- Adjust Wands because goddammit Blizzard
		if v.type == "2.19" then
			v.slot = "INVTYPE_WEAPONMAINHAND"
		end
		-- Get the weapon type
		local weapon = false
		for k2, v2 in pairs(app.Type) do
			if v2 == v.type and not (v.type == "4.1" or v.type == "4.2" or v.type == "4.3" or v.type == "4.4" or (v.type == "4.0" and v.slot ~= "INVTYPE_HOLDABLE" and v.slot ~= "INVTYPE_WEAPONOFFHAND")) then
				for _, v3 in pairs(app.Weapon[k2]) do
					-- Check if the item can and should be equipped (weapon -> spec)
					if v3 == app.SpecID then
						weapon = true
						for k, v in pairs(C_Item.GetItemStats(v.item)) do
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
						if v.ilv <= C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot)) then
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
			elseif v.slot == "INVTYPE_FINGER" then
				compareItemLevel = math.min(itemLevel[11], itemLevel[12])
			elseif v.slot == "INVTYPE_TRINKET" then
				compareItemLevel = math.min(itemLevel[13], itemLevel[14])
			else
				compareItemLevel = itemLevel[app.Slot[v.slot]]
			end

			-- Check if the item level is higher
			if v.ilv > compareItemLevel then
				upgrade[#upgrade+1] = { item = v.item, slot = app.Slot[v.slot], ilv = v.ilv, bag = v.bag, bagslot = v.bagslot }
			end
		end
	end

	-- Move one-handed weapons to main hand, if the character cannot dual wield
	if app.CanDualWield == false then
		for k, v in pairs(upgrade) do
			if v.slot == 18 then
				upgrade[k].slot = 16
			end
		end
	end

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: ELIGIBLE ITEMS")
		DevTools_Dump(upgrade)
	end

	-- Check upgrades for multiples of the same slot and only keep the best one, or best two for rings, trinkets, and 1-Handers (thanks ChatGPT)
	local function processGearTable(gearTable)
		local seenSlots = {}
	
		for i = #gearTable, 1, -1 do
			local entry = gearTable[i]
			local slot = entry.slot
	
			-- Handle slots 18, 11, and 13 (keep the best two)
			if slot == 18 or slot == 11 or slot == 13 then
				seenSlots[slot] = seenSlots[slot] or {}
	
				if #seenSlots[slot] < 2 then
					-- If fewer than two entries, just add the current entry
					table.insert(seenSlots[slot], entry)
				else
					-- Find the entry with the lowest ilv
					local minIlvIndex = 1
					for j = 2, #seenSlots[slot] do
						if seenSlots[slot][j].ilv < seenSlots[slot][minIlvIndex].ilv then
							minIlvIndex = j
						end
					end
	
					-- Replace the entry with the lowest ilv if the current entry has a higher ilv
					if entry.ilv > seenSlots[slot][minIlvIndex].ilv then
						-- Remove the lowest ilv entry from gearTable
						for k = #gearTable, 1, -1 do
							if gearTable[k] == seenSlots[slot][minIlvIndex] then
								table.remove(gearTable, k)
								break
							end
						end
						-- Replace the lowest ilv entry in seenSlots
						seenSlots[slot][minIlvIndex] = entry
					else
						-- Remove the current entry from gearTable if it is not better
						table.remove(gearTable, i)
					end
				end
	
			-- Handle slot 1617 for Fury Warriors without Single-Minded Fury (keep the best two 2H weapons)
			elseif app.SpecID == 722 and slot == 1617 then
				seenSlots[slot] = seenSlots[slot] or {}
	
				if #seenSlots[slot] < 2 then
					-- If fewer than two entries, just add the current entry
					table.insert(seenSlots[slot], entry)
				else
					-- Find the entry with the lowest ilv
					local minIlvIndex = 1
					for j = 2, #seenSlots[slot] do
						if seenSlots[slot][j].ilv < seenSlots[slot][minIlvIndex].ilv then
							minIlvIndex = j
						end
					end
	
					-- Replace the entry with the lowest ilv if the current entry has a higher ilv
					if entry.ilv > seenSlots[slot][minIlvIndex].ilv then
						-- Remove the lowest ilv entry from gearTable
						for k = #gearTable, 1, -1 do
							if gearTable[k] == seenSlots[slot][minIlvIndex] then
								table.remove(gearTable, k)
								break
							end
						end
						-- Replace the lowest ilv entry in seenSlots
						seenSlots[slot][minIlvIndex] = entry
					else
						-- Remove the current entry from gearTable if it is not better
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

	-- Check if one or both of our rings/trinkets are upgrades
	local ringMax = math.max(itemLevel[11], itemLevel[12])
	local trinketMax = math.max(itemLevel[13], itemLevel[14])
	local ringUpgrades = 0
	local trinketUpgrades = 0

	for k, v in pairs(upgrade) do
		if v.slot == 11 and v.ilv > ringMax then
			ringUpgrades = ringUpgrades + 1
		elseif v.slot == 13 and v.ilv > trinketMax then
			trinketUpgrades = trinketUpgrades + 1
		end
	end

	-- If both, move the first we find to another slot
	if ringUpgrades == 2 then
		for k, v in pairs(upgrade) do
			if v.slot == 11 then
				upgrade[k].slot = 12
				break
			end
		end
	end

	if trinketUpgrades == 2 then
		for k, v in pairs(upgrade) do
			if v.slot == 13 then
				upgrade[k].slot = 14
				break
			end
		end
	end

	-- Keep the highest ilv ring if there's only 1 upgrade (thanks ChatGPT)
	if ringUpgrades < 2 then
		local highestIlvIndex = nil
		local found = false
		
		for i = #upgrade, 1, -1 do
			if upgrade[i].slot == 11 then
				if not highestIlvIndex or upgrade[i].ilv > upgrade[highestIlvIndex].ilv then
					highestIlvIndex = i
					found = true
				end
			end
		end
		
		if found then
			-- Remove all rings except the one with the highest ilv
			for i = #upgrade, 1, -1 do
				if upgrade[i].slot == 11 and i ~= highestIlvIndex then
					table.remove(upgrade, i)
				end
			end
		end
	end

	-- Keep the highest ilv trinket if there's only 1 upgrade (thanks ChatGPT)
	if trinketUpgrades < 2 then
		local highestIlvIndex = nil
		local found = false
		
		for i = #upgrade, 1, -1 do
			if upgrade[i].slot == 13 then
				if not highestIlvIndex or upgrade[i].ilv > upgrade[highestIlvIndex].ilv then
					highestIlvIndex = i
					found = true
				end
			end
		end
		
		if found then
			-- Remove all trinkets except the one with the highest ilv
			for i = #upgrade, 1, -1 do
				if upgrade[i].slot == 13 and i ~= highestIlvIndex then
					table.remove(upgrade, i)
				end
			end
		end
	end

	-- If only one left, set it to the proper slot
	if ringUpgrades == 1 and itemLevel[11] > itemLevel[12] then
		for k, v in pairs(upgrade) do
			if v.slot == 11 then
				upgrade[k].slot = 12
			end
		end
	end

	if trinketUpgrades == 1 and itemLevel[13] > itemLevel[14] then
		for k, v in pairs(upgrade) do
			if v.slot == 13 then
				upgrade[k].slot = 14
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

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: ELIGIBLE WEAPONS")
		DevTools_Dump(weaponUpgrade)
	end

	-- Get best weapons (thanks ChatGPT)
	function findBestWeaponCombo(weaponUpgrade)
		if #weaponUpgrade == 1 then
			return weaponUpgrade
		end
	
		local maxIlv = 0
		local bestCombo = {}

		-- Fury Warriors without Single-Minded Fury use two 2Handers
		if app.SpecID == 722 then
			for i, weapon1 in ipairs(weaponUpgrade) do
				for j, weapon2 in ipairs(weaponUpgrade) do
					if i ~= j and weapon1["slot"] == 1617 and weapon2["slot"] == 1617 then
						local comboIlv = weapon1["ilv"] + weapon2["ilv"]

						if comboIlv > maxIlv then
							maxIlv = comboIlv
							bestCombo = { weapon1, weapon2 }
						end
					end
				end
			end
		else
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
		end
	
		return bestCombo
	end

	local bestWeapons = findBestWeaponCombo(weaponUpgrade)

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: BEST WEAPONS")
		DevTools_Dump(bestWeapons)
	end

	-- Sort the best weapons by item level, which matters for dual wielding
	table.sort(bestWeapons, function(a, b)
		if a.ilv == b.ilv then
			return a.item > b.item  -- Sort by item if ilv is the same
		else
			return a.ilv > b.ilv    -- Sort by ilv first
		end
	end)

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: BEST WEAPONS SORTED")
		DevTools_Dump(bestWeapons)
	end

	-- Check the currently equipped weapons
	local item16 = GetInventoryItemLink("player", 16) or "None"
	local item17 = GetInventoryItemLink("player", 17) or "None"
	local dualCount = 0

	for k, v in pairs(bestWeapons) do
		-- Treat 2H weapons for Fury Warriors as though they are One-Handed weapons which can be equipped in any slot
		if v.slot == 1617 and app.SpecID == 722 then
			v.slot = 18
		-- Set other 2H weapons to equip in the main hand slot
		elseif v.slot == 1617 then
			v.slot = 16
		end

		-- If we're dealing with weapons that can be equipped in either slot
		if v.slot == 18 then
			dualCount = dualCount + 1
		end
	end

	-- Put the weapons back in the upgrade table if not equipped (in the right slot)
	for k, v in pairs(bestWeapons) do
		-- If dual wielding is not applicable
		if dualCount == 0 then
			-- If the item is not equipped
			if (v.slot == 16 and v.item ~= item16) or (v.slot == 17 and v.item ~= item17) then
				upgrade[#upgrade+1] = v
			end
		-- If dual wielding with 1 upgrade
		elseif dualCount == 1 then
			if #bestWeapons == 2 then
				if bestWeapons[1].slot == 16 or bestWeapons[2].slot == 17 then
					if k == 1 and v.item ~= item16 then
						v.slot = 16
						upgrade[#upgrade+1] = v
					elseif k == 2 and v.item ~= item17 then
						v.slot = 17
						upgrade[#upgrade+1] = v
					end
				elseif bestWeapons[1].slot == 17 or bestWeapons[2].slot == 16 then
					if k == 2 and v.item ~= item16 then
						v.slot = 16
						upgrade[#upgrade+1] = v
					elseif k == 1 and v.item ~= item17 then
						v.slot = 17
						upgrade[#upgrade+1] = v
					end
				end
			elseif v.item ~= item16 then
				v.slot = 16
				upgrade[#upgrade+1] = v
			end
		-- If dual wielding with 2 upgrades
		elseif dualCount == 2 then
			-- First item, highest iLv, to main hand
			if k == 1 and v.item ~= item16 then
				v.slot = 16
				upgrade[#upgrade+1] = v
			-- Second item, second-highest iLv, to off hand
			elseif k == 2 and v.item ~= item17 then
				v.slot = 17
				upgrade[#upgrade+1] = v
			end
		end
	end

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: BEST WEAPONS SORTED 2")
		DevTools_Dump(bestWeapons)
	end

	-- Set the message variable if it's not set (properly)
	if not msg or type(msg) ~= "number" then
		msg = 2
	end

	-- Equip the upgrades
	for k, v in pairs(upgrade) do
		-- This gets weird in super niche situations, so let's just check if the data exists
		if v.bag and v.bagslot then
			ClearCursor()
			C_Container.PickupContainerItem(v.bag, v.bagslot)
			EquipCursorItem(v.slot)
		end
	end

	-- We're now done doing stuff, delayed so it doesn't run twice while still busy
	C_Timer.After(1, function()
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
			app.Print("Could not equip recommended gear. Please try again in a few seconds.")
		end

		app.Flag["Busy"] = false
	end)
end

-- Do the thing on quest completion
app.Event:Register("QUEST_TURNED_IN", function(questID, xpReward, moneyReward)
	-- Run if the setting is enabled and we're not in combat
	if EquipRecommendedGear_Settings["runAfterQuest"] == true and not InCombatLockdown() then
		C_Timer.After(1, function()
			-- And respect the chat message setting
			api.DoTheThing(EquipRecommendedGear_Settings["chatMessage"])
		end)
	end
end)