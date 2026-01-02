------------------------------------------
-- Equip Recommended Gear: ItemInfo.lua --
------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.IsItemEquippable = {}
	end
end)

----------------------
-- ITEM INFORMATION --
----------------------

function api:IsItemEquippable(itemLink)
	assert(self == api, "Call EquipRecommendedGear:IsItemEquippable(), not EquipRecommendedGear.IsItemEquippable()")

	if not itemLink then return false end
	if app.IsItemEquippable[itemLink] ~= nil then return app.IsItemEquippable[itemLink] end
	if not C_Item.IsEquippableItem(itemLink) then return false end

	local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)
	if app.Slot[itemEquipLoc] == 4 then return false end	-- Skip shirts

	-- Filter class/spec eligibility
	app.SpecID = PlayerUtil.GetCurrentSpecID()
	if app.SpecID == 72 then
		if C_SpellBook.IsSpellKnown(81099) then
			app.SpecID = 721
		else
			app.SpecID = 722
		end
	end

	local armorClass
	for armor, classes in pairs(app.Armor) do
		for _, class in pairs(classes) do
			if class == app.ClassID then
				armorClass = armor
				break
			end
		end
	end

	local primaryStat
	for stat, specs in pairs(app.Stat) do
		for _, spec in pairs(specs) do
			if spec == app.SpecID then
				primaryStat = stat
				break
			end
		end
	end

	local itemType = classID.."."..subclassID
	local equippable = false

	-- Filter by armor class
	if itemType == app.Type[armorClass] or (itemType == app.Type["General"] and itemEquipLoc ~= "INVTYPE_TABARD" and itemEquipLoc ~= "INVTYPE_BODY" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD") or itemEquipLoc == "INVTYPE_CLOAK" then
		equippable = true
	end

	-- Filter by spec-appropriate weapons
	if itemType == "2.19" then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end	-- Adjust Wands because goddammit Blizzard
	for typeText, typeNumber in pairs(app.Type) do
		if typeNumber == itemType and not (itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" or (itemType == "4.0" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND")) then
			for _, spec in pairs(app.Weapon[typeText]) do
				if spec == app.SpecID then
					for stat, _ in pairs(C_Item.GetItemStats(itemLink)) do
						if primaryStat == stat then
							equippable = true
						end
					end
				end
			end
		end
	end

	app.IsItemEquippable[itemLink] = equippable
	return equippable
end

function api:IsItemUpgrade(itemLink)
	assert(self == api, "Call EquipRecommendedGear:IsItemUpgrade(), not EquipRecommendedGear.IsItemUpgrade()")

	if not itemLink then return false end
	if not api:IsItemEquippable(itemLink) then return false end

	local equippedItemLevel = {}
	local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
	local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)

	if classID.."."..subclassID == "2.19" then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end	-- Adjust Wands because goddammit Blizzard
	local dualwield = false
	for _, spec in pairs(app.DualWield) do
		if PlayerUtil.GetCurrentSpecID() == spec then dualwield = true end
		break
	end

	if app.Slot[itemEquipLoc] <= 10 or app.Slot[itemEquipLoc] == 15 then
		if GetInventoryItemLink("player", app.Slot[itemEquipLoc]) then
			table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(app.Slot[itemEquipLoc])))
		else
			table.insert(equippedItemLevel, 0)
		end
	elseif app.Slot[itemEquipLoc] == 11 then
		for _, slot in ipairs({ 11, 12 }) do
			if GetInventoryItemLink("player", slot) then
				table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot)))
			else
				table.insert(equippedItemLevel, 0)
			end
		end
	elseif app.Slot[itemEquipLoc] == 13 then
		for _, slot in ipairs({ 13, 14 }) do
			if GetInventoryItemLink("player", slot) then
				table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot)))
			else
				table.insert(equippedItemLevel, 0)
			end
		end
	elseif dualwield and app.Slot[itemEquipLoc] == 18 then
		for _, slot in ipairs({ 16, 17 }) do
			if GetInventoryItemLink("player", slot) then
				table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot)))
			else
				table.insert(equippedItemLevel, 0)
			end
		end
	elseif app.Slot[itemEquipLoc] == 16 or app.Slot[itemEquipLoc] == 18 then
		if GetInventoryItemLink("player", 16) then
			table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(16)))
		else
			table.insert(equippedItemLevel, 0)
		end
	elseif app.Slot[itemEquipLoc] == 17 then
		if GetInventoryItemLink("player", 17) then
			table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(17)))
		elseif GetInventoryItemLink("player", 16) then
			table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(16)))
		else
			table.insert(equippedItemLevel, 0)
		end
	elseif app.Slot[itemEquipLoc] == 1617 then
		if PlayerUtil.GetCurrentSpecID() == 72 and not C_SpellBook.IsSpellKnown(81099) then
			for _, slot in ipairs({ 16, 17 }) do
				if GetInventoryItemLink("player", slot) then
					table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot)))
				else
					table.insert(equippedItemLevel, 0)
				end
			end
		else
			if GetInventoryItemLink("player", 16) then
				table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(16)))
			else
				table.insert(equippedItemLevel, 0)
			end
		end
	end
	equippedItemLevel = math.min(unpack(equippedItemLevel))

	return itemLevel > equippedItemLevel
end
