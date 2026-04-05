------------------------------------------
-- Equip Recommended Gear: ItemInfo.lua --
------------------------------------------

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
	if app.Slot[itemEquipLoc] == 4 then return false end -- Skip shirts

	-- Filter class/spec eligibility
	app.SpecID = PlayerUtil.GetCurrentSpecID()

	local itemType = classID.."."..subclassID
	local equippable = false

	local specs = C_Item.GetItemSpecInfo(itemLink)
	if specs and itemEquipLoc == "INVTYPE_TRINKET" then -- Only use spec info for trinkets for now, I'm not sure if it's reliable enough yet
		for _, specID in ipairs(specs) do
			if specID == app.SpecID then
				equippable = true
			end
		end
	else
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

		-- Armor class
		if itemType == app.Type[armorClass] or (itemType == app.Type["General"] and itemEquipLoc ~= "INVTYPE_TABARD" and itemEquipLoc ~= "INVTYPE_BODY" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD") or itemEquipLoc == "INVTYPE_CLOAK" then
			equippable = true
		end
		-- Spec-appropriate weapons
		if itemType == "2.19" then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end -- Adjust Wands because goddammit Blizzard
		for typeText, typeNumber in pairs(app.Type) do
			if typeNumber == itemType and not (itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" or (itemType == "4.0" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND")) then
				for _, spec in pairs(app.Weapon[typeText]) do
					if spec == app.SpecID then
						for stat, _ in pairs(C_Item.GetItemStats(itemLink)) do
							if primaryStat == stat then
								equippable = true
								break
							end
						end
					end
				end
			end
		end
	end

	if itemEquipLoc ~= "INVTYPE_TRINKET" then app.IsItemEquippable[itemLink] = equippable end
	return equippable
end

function app:GetItemLevel(itemLink)
	local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
	if itemLevel >= 350 then
		local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
		if tooltipData and tooltipData.lines then
			for _, lineData in ipairs(tooltipData.lines) do
				if lineData.type == Enum.TooltipDataLineType.ItemLevel then
					itemLevel = lineData.itemLevel
					break
				end
			end
		end
	end
	return itemLevel
end

function api:IsItemUpgrade(itemLink)
	assert(self == api, "Call EquipRecommendedGear:IsItemUpgrade(), not EquipRecommendedGear.IsItemUpgrade()")

	if not itemLink then return false end
	if not api:IsItemEquippable(itemLink) then return false end

	local equippedItemLevel = {}
	local itemLevel = app:GetItemLevel(itemLink)
	local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)

	if classID.."."..subclassID == "2.19" then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end -- Adjust Wands because goddammit Blizzard
	local uniqueEquipped = false
	if C_Item.GetItemUniquenessByID(itemLink) then
		local itemID = C_Item.GetItemIDForItemInfo(itemLink)
		for slot = 1, 17 do
			if GetInventoryItemLink("player", slot) and C_Item.GetItemID(ItemLocation:CreateFromEquipmentSlot(slot)) == itemID then
				uniqueEquipped = slot
			end
		end
	end
	local dualwield = false
	for _, spec in pairs(app.DualWield) do
		if PlayerUtil.GetCurrentSpecID() == spec then dualwield = true end
		break
	end
	if not app.Slot[itemEquipLoc] then return end

	if uniqueEquipped then
		table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(uniqueEquipped)))
	elseif app.Slot[itemEquipLoc] <= 10 or app.Slot[itemEquipLoc] == 15 then
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
	else -- Weapons
		local mainhand = GetInventoryItemLink("player", 16)
		local _, mhItemEquipLoc
		if mainhand then
			_, _, _, _, _, _, _, _, mhItemEquipLoc = C_Item.GetItemInfo(mainhand)

			table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(16)))
		else
			table.insert(equippedItemLevel, 0)
		end

		local twohander = mainhand and app.Slot[mhItemEquipLoc] == 1617
		if not twohander or PlayerUtil.GetCurrentSpecID() == 72 then
			if GetInventoryItemLink("player", 17) then
				table.insert(equippedItemLevel, C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(17)))
			elseif app.Slot[itemEquipLoc] == 17 or (dualwield and app.Slot[itemEquipLoc] == 18) then
				table.insert(equippedItemLevel, 0)
			end
		end
	end

	equippedItemLevel = math.min(unpack(equippedItemLevel))
	return itemLevel > equippedItemLevel
end
