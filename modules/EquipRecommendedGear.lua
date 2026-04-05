------------------------------------------------------
-- Equip Recommended Gear: EquipRecommendedGear.lua --
------------------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Sex = C_PlayerInfo.GetSex(PlayerLocation:CreateFromUnit("player"))
		app.ClassID = PlayerUtil.GetClassID()

		app:CreateAssets()
	end
end)

----------------------------
-- EQUIP RECOMMENDED GEAR --
----------------------------

function app:CreateAssets()
	app.Button = CreateFrame("Button", "rcButton", PaperDollSidebarTabs)
	app.Button:SetWidth(32)
	app.Button:SetHeight(32)
	app.Button:SetNormalTexture("Interface\\AddOns\\EquipRecommendedGear\\assets\\button-normal.png")
	app.Button:SetHighlightTexture("Interface\\AddOns\\EquipRecommendedGear\\assets\\button-highlight.png", "BLEND")
	app.Button:SetPushedTexture("Interface\\AddOns\\EquipRecommendedGear\\assets\\button-pushed.png")
	app.Button:SetPoint("TOPRIGHT", PaperDollSidebarTab1, "TOPLEFT", -4, -2)
	app.Button:SetFrameStrata("HIGH")
	app.Button:RegisterForClicks("AnyDown", "AnyUp")
	app.Button:SetScript("OnClick", function()
		api:DoTheThing()
	end)
	app.Button:HookScript("OnMouseDown", function()
		app.Button:GetHighlightTexture():Hide()
	end)
	app.Button:SetScript("OnMouseUp", function()
		app.Button:GetHighlightTexture():Show()
	end)
	app.Button:SetScript("OnEnter", function()
		app.Button.Tooltip:Show()
	end)
	app.Button:SetScript("OnLeave", function()
		app.Button:GetHighlightTexture():Show()
		app.Button.Tooltip:Hide()
	end)

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

	local string = app.Button.Tooltip:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("CENTER", app.Button.Tooltip, "CENTER", 0, 0)
	string:SetPoint("TOP", app.Button.Tooltip, "TOP", 0, -10)
	string:SetJustifyH("CENTER")
	string:SetText(app.NameLong)
	string:SetScale(1.1)
	app.Button.Tooltip:SetHeight(string:GetStringHeight()*1.1+20)
	app.Button.Tooltip:SetWidth(string:GetStringWidth()*1.1+20)
	app.Button.Tooltip:Hide()
	app.Button.Tooltip:SetPoint("BOTTOMLEFT", app.Button, "TOPRIGHT", 0, 4)
end

function api:DoTheThing(msg)
	assert(self == api, "Call EquipRecommendedGear:DoTheThing(), not EquipRecommendedGear.DoTheThing()")

	if app.Flag.Busy then return end

	if InCombatLockdown() then
		C_Timer.After(1, function()
			app:Print(L.ERROR_COMBAT)
			app.Flag.Busy = false
		end)
		return
	end

	app.Flag.Busy = true
	app.SpecID = PlayerUtil.GetCurrentSpecID()
	app.Level = UnitLevel("player")

	local _, specName = GetSpecializationInfoByID(app.SpecID, app.Sex)
	local className, classFile = GetClassInfo(app.ClassID)
	local _, _, _, classColor = GetClassColor(classFile)

	local eligibleItems = {}

	for slot = 1, 17 do
		local itemLink = GetInventoryItemLink("player", slot)
		if itemLink and slot ~= 4 then
			local itemID = C_Item.GetItemInfoInstant(itemLink)
			local unique = C_Item.GetItemUniquenessByID(itemID)
			local ilv = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot))
			local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)

			if itemEquipLoc == nil or classID == nil or subclassID == nil then
				C_Timer.After(1, function()
					app:Print(L.ERROR_EQUIPPED)
					app.Flag.Busy = false
				end)
				return
			end

			if C_Heirloom.IsItemHeirloom(itemID) then
				local maxLevel = select(10, C_Heirloom.GetHeirloomInfo(itemID))

				if maxLevel then
					if maxLevel >= app.Level then
						ilv = 9999 -- If heirloom isn't maxed, assume player wants to use it
					end
				else
					C_Timer.After(1, function()
						app:Print(L.ERROR_EQUIPPED)
						app.Flag.Busy = false
					end)
					return
				end
			end

			if classID == 2 and subclassID == 19 then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end -- Adjust Wands because goddammit Blizzard
			tinsert(eligibleItems, { itemLink = itemLink, itemID = itemID, itemEquipLoc = itemEquipLoc, unique = unique, ilv = ilv, bag = -1, bagSlot = slot })
		end
	end

	for bag = 0, 5 do
		local slots = C_Container.GetContainerNumSlots(bag)
		if slots > 0 then
			for bagSlot = 1, slots do
				local itemLink = C_Container.GetContainerItemLink(bag, bagSlot)

				if itemLink and C_Item.IsEquippableItem(itemLink) then
					local _, _, _, _, itemMinLevel, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)
					local itemID = C_Item.GetItemInfoInstant(itemLink)
					local unique = C_Item.GetItemUniquenessByID(itemID)

					if itemEquipLoc == nil or classID == nil or subclassID == nil then
						C_Timer.After(1, function()
							app:Print(L.ERROR_INVENTORY)
							app.Flag.Busy = false
						end)
						return
					end

					if C_Item.IsBound(ItemLocation:CreateFromBagAndSlot(bag, bagSlot)) and app.Level >= itemMinLevel then
						local ilv = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromBagAndSlot(bag, bagSlot))

						if C_Heirloom.IsItemHeirloom(itemID) then
							local maxLevel = select(10, C_Heirloom.GetHeirloomInfo(itemID))

							if maxLevel then
								if maxLevel >= app.Level then
									ilv = 9999 -- If heirloom isn't maxed, assume player wants to use it
								end
							else
								C_Timer.After(1, function()
									app:Print(L.ERROR_INVENTORY)
									app.Flag.Busy = false
								end)
								return
							end
						end

						if api:IsItemUpgrade(itemLink) then
							if classID == 2 and subclassID == 19 then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end -- Adjust Wands because goddammit Blizzard
							tinsert(eligibleItems, { itemLink = itemLink, itemID = itemID, itemEquipLoc = itemEquipLoc, unique = unique, ilv = ilv, bag = bag, bagSlot = bagSlot })
						end
					end
				end
			end
		end
	end

	if app.Settings["debug"] then
		app:Print("DEBUG: ELIGIBLE ITEMS")
		for _, v in ipairs(eligibleItems) do
			local unique = v.unique and "true" or "false"
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Filter unique-equipped
	local filtered = {}
	local seen = {}

	for _, item in ipairs(eligibleItems) do
		if item.unique then
			local existing = seen[item.itemID]
			if existing then
				if item.ilv > existing.ilv then
					seen[item.itemID] = item
				elseif item.ilv == existing.ilv then
					if item.bag == -1 and existing.bag ~= -1 then
						seen[item.itemID] = item
					end
				end
			else
				seen[item.itemID] = item
			end
		else
			tinsert(filtered, item)
		end
	end

	for _, item in pairs(seen) do
		tinsert(filtered, item)
	end

	eligibleItems = filtered

	if app.Settings["debug"] then
		app:Print("DEBUG: ELIGIBLE ITEMS MINUS UNIQUE DUPES")
		for _, v in ipairs(eligibleItems) do
			local unique = v.unique and "true" or "false"
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Keep the highest iLv entries
	local filtered = {}
	local grouped = {}

	for _, item in ipairs(eligibleItems) do
		local slot = app.Slot[item.itemEquipLoc]
		if slot then
			grouped[slot] = grouped[slot] or {}
			tinsert(grouped[slot], item)
		end
	end

	for slot, items in pairs(grouped) do
		table.sort(items, function(a, b)
			if a.ilv ~= b.ilv then
				return a.ilv > b.ilv
			elseif a.bag ~= b.bag then
				return a.bag == -1
			else
				return a.itemID > b.itemID
			end
		end)

		-- Keep two of rings, trinkets, two-handed weapons (fury warr) and one-handed weapons that can go in either slot
		local keepCount = (slot == 11 or slot == 13 or slot == 1617 or slot == 18) and 2 or 1

		for i = 1, math.min(#items, keepCount) do
			tinsert(filtered, items[i])
		end
	end

	eligibleItems = filtered

	if app.Settings["debug"] then
		app:Print("DEBUG: BEST ITEMS")
		for _, v in ipairs(eligibleItems) do
			local unique = v.unique and "true" or "false"
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Gear upgrades
	local openSlots = { [11] = true, [12] = true, [13] = true, [14] = true }
	for _, item in ipairs(eligibleItems) do
		if (app.Slot[item.itemEquipLoc] == 11 or app.Slot[item.itemEquipLoc] == 13) and item.bag == -1 then
			openSlots[item.bagSlot] = false
		end
	end

	local upgrades = {}
	local function ringTrinketSlots(item, a, b)
		if openSlots[a] == true then
			tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = a })
			openSlots[a] = false
		elseif openSlots[b] == true then
			tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = b })
			openSlots[b] = false
		end
	end

	for _, item in ipairs(eligibleItems) do
		if (app.Slot[item.itemEquipLoc] <= 10 or app.Slot[item.itemEquipLoc] == 15) and item.bag ~= -1 then
			tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = app.Slot[item.itemEquipLoc] })
		elseif app.Slot[item.itemEquipLoc] == 11 and item.bag ~= -1 then
			ringTrinketSlots(item, 11, 12)
		elseif app.Slot[item.itemEquipLoc] == 13 and item.bag ~= -1 then
			ringTrinketSlots(item, 13, 14)
		end
	end

	-- Weapon upgrades
	if EquipRecommendedGear_CharSettings["includeWeapons"] then
		local dualWield = false
		for _, spec in pairs(app.DualWield) do
			if app.SpecID == spec then
				dualWield = true
				break
			end
		end

		if not dualWield then
			for i, item in pairs(eligibleItems) do
				if app.Slot[item.itemEquipLoc] == 18 then
					eligibleItems[i].itemEquipLoc = "INVTYPE_WEAPONMAINHAND"
				end
			end
		end

		local twoHand, mainHand, offHand, oneHand = {}, {}, {}, {}
		for _, item in ipairs(eligibleItems) do
			if app.Slot[item.itemEquipLoc] == 1617 then
				tinsert(twoHand, item)
			elseif app.Slot[item.itemEquipLoc] == 16 then
				tinsert(mainHand, item)
			elseif app.Slot[item.itemEquipLoc] == 17 then
				tinsert(offHand, item)
			elseif app.Slot[item.itemEquipLoc] == 18 then
				tinsert(oneHand, item)
			end
		end
		table.sort(twoHand, function(a, b) return a.ilv > b.ilv end)
		table.sort(oneHand, function(a, b) return a.ilv > b.ilv end)

		local weaponUpgrades = {}
		local function addCombo(list)
			local comboItemLevel = 0
			for _, weapon in ipairs(list) do
				comboItemLevel = comboItemLevel + app:GetItemLevel(weapon.itemLink)
			end
			tinsert(weaponUpgrades, { ilv = comboItemLevel / #list, weapons = list })
		end

		if app.Settings["debug"] then
			app:Print("DEBUG: ELIGIBLE WEAPONS")
			DevTools_Dump(twoHand)
			DevTools_Dump(mainHand)
			DevTools_Dump(offHand)
			DevTools_Dump(oneHand)
		end

		-- 2H
		if #twoHand >= 1 and app.SpecID ~= 72 then
			for _, item in ipairs(twoHand) do
				addCombo({ item })
			end
		end
		-- 2H + 2H (Fury)
		if #twoHand >= 2 and app.SpecID == 72 then
			for i = 1, #twoHand do
				for j = i + 1, #twoHand do
					addCombo({ twoHand[i], twoHand[j] })
				end
			end
		end
		-- MH + OH
		for _, mh in ipairs(mainHand) do
			for _, oh in ipairs(offHand) do
				addCombo({ mh, oh })
			end
		end
		-- MH + 1H
		for _, mh in ipairs(mainHand) do
			for _, oh in ipairs(oneHand) do
				addCombo({ mh, oh })
			end
		end
		-- 1H + OH
		for _, mh in ipairs(oneHand) do
			for _, oh in ipairs(offHand) do
				addCombo({ mh, oh })
			end
		end
		-- 1H + 1H
		for i = 1, #oneHand do
			for j = i + 1, #oneHand do
				addCombo({ oneHand[i], oneHand[j] })
			end
		end

		if app.Settings["debug"] then
			app:Print("DEBUG: ELIGIBLE WEAPON COMBOS")
			DevTools_Dump(weaponUpgrades)
		end

		table.sort(weaponUpgrades, function(a, b)
			if a.ilv ~= b.ilv then
				return a.ilv > b.ilv
			end

			-- If tie, prefer equipped
			local function countEquipped(combo)
				local count = 0
				for _, w in ipairs(combo.weapons) do
					if w.bag == -1 then count = count + 1 end
				end
				return count
			end

			local aEquipped = countEquipped(a)
			local bEquipped = countEquipped(b)
			if aEquipped ~= bEquipped then
				return aEquipped > bEquipped
			end

			-- If still tie, use itemID to be deterministic
			return a.weapons[1].itemID > b.weapons[1].itemID
		end)

		if app.Settings["debug"] then
			app:Print("DEBUG: BEST WEAPON COMBO")
			DevTools_Dump(weaponUpgrades[1])
		end

		if weaponUpgrades[1] and not (weaponUpgrades[1].weapons[1].bag == -1 and weaponUpgrades[1].weapons[1].bagSlot == 16) then
			tinsert(upgrades, { itemLink = weaponUpgrades[1].weapons[1].itemLink, bag = weaponUpgrades[1].weapons[1].bag, bagSlot = weaponUpgrades[1].weapons[1].bagSlot, equipSlot = 16 })
		end
		if weaponUpgrades[1] and weaponUpgrades[1].weapons[2] and not (weaponUpgrades[1].weapons[2].bag == -1 and weaponUpgrades[1].weapons[2].bagSlot == 17) then
			tinsert(upgrades, { itemLink = weaponUpgrades[1].weapons[2].itemLink, bag = weaponUpgrades[1].weapons[2].bag, bagSlot = weaponUpgrades[1].weapons[2].bagSlot, equipSlot = 17 })
		end
	end

	table.sort(upgrades, function(a, b)
		if a.bag ~= b.bag then
			return a.bag == -1
		end
	end)

	if app.Settings["debug"] then
		app:Print("DEBUG: UPGRADES")
		for _, v in ipairs(upgrades) do
			print(v.itemLink..", " .. v.bag.."."..v.bagSlot..", " .. v.equipSlot)
		end
	end

	for _, item in ipairs(upgrades) do
		ClearCursor()
		if item.bag == -1 then
			PickupInventoryItem(item.bagSlot)       -- pick up currently equipped weapon
			EquipCursorItem(item.equipSlot)        -- move it to the desired slot
		else
			C_Container.PickupContainerItem(item.bag, item.bagSlot)
			EquipCursorItem(item.equipSlot)
		end
	end

	C_Timer.After(1, function() -- Delay finishing, so the function doesn't run multiple times
		if not msg or type(msg) ~= "number" then msg = 2 end

		local next = next
		if next(upgrades) == nil and specName then
			if msg == 2 then
				app:Print(L.EQUIP_NO_UPDGRADE, "|c" .. classColor .. specName .. " " .. className .. "|r.")
			end
		elseif specName then
			if msg >= 1 then
				app:Print(L.EQUIP_UPDGRADE, "|c" .. classColor .. specName .. " " .. className .. "|r.")
			end
		else
			app:Print(L.ERROR_EQUIP)
		end

		app.Flag.Busy = false
	end)
end

app.Event:Register("QUEST_TURNED_IN", function(questID, xpReward, moneyReward)
	if app.Settings["runAfterQuest"] == true and not InCombatLockdown() then
		C_Timer.After(1, function()
			api:DoTheThing(app.Settings["chatMessage"])
		end)
	end
end)
