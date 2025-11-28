------------------------------------------------------
-- Equip Recommended Gear: EquipRecommendedGear.lua --
------------------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales
local api = app.api

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

function app.CreateAssets()
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

function api.DoTheThing(msg)
	if not app.Flag.Busy then app.Flag.Busy = false end
	if app.Flag.Busy == true then return end

	if InCombatLockdown() then
		C_Timer.After(1, function()
			app.Print(L.ERROR_COMBAT)
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

	-- Use custom specIDs for Fury Warr to handle 2x2H vs 2x1H
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

	local eligibleItems = {}
	-- Equipped items are eligible by default
	for slot = 1, 17 do
		local itemLink = GetInventoryItemLink("player", slot)
		if itemLink and slot ~= 4 then	-- Skip shirt slot
			local itemID = C_Item.GetItemInfoInstant(itemLink)
			local unique = C_Item.GetItemUniquenessByID(itemID)
			local ilv = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromEquipmentSlot(slot))
			local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, classID, subclassID = C_Item.GetItemInfo(itemLink)

			if itemEquipLoc == nil or classID == nil or subclassID == nil then
				C_Timer.After(1, function()
					app.Print(L.ERROR_EQUIPPED)
					app.Flag.Busy = false
				end)
				return
			end

			if C_Heirloom.IsItemHeirloom(itemID) then
				local maxLevel = select(10, C_Heirloom.GetHeirloomInfo(itemID))

				if maxLevel then
					if maxLevel >= app.Level then
						ilv = 9999	-- If heirloom isn't maxed, assume player wants to use it
					end
				else
					C_Timer.After(1, function()
						app.Print(L.ERROR_EQUIPPED)
						app.Flag.Busy = false
					end)
					return
				end
			end

			if classID == 2 and subclassID == 19 then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end	-- Adjust Wands because goddammit Blizzard
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
							app.Print(L.ERROR_INVENTORY)
							app.Flag.Busy = false
						end)
						return
					end

					-- Only handle soulbound items
					if C_Item.IsBound(ItemLocation:CreateFromBagAndSlot(bag, bagSlot)) and app.Level >= itemMinLevel then
						local ilv = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromBagAndSlot(bag, bagSlot))

						if C_Heirloom.IsItemHeirloom(itemID) then
							local maxLevel = select(10, C_Heirloom.GetHeirloomInfo(itemID))

							if maxLevel then
								if maxLevel >= app.Level then
									ilv = 9999	-- If heirloom isn't maxed, assume player wants to use it
								end
							else
								C_Timer.After(1, function()
									app.Print(L.ERROR_INVENTORY)
									app.Flag.Busy = false
								end)
								return
							end
						end

						local equippable = api.IsItemEquippable(itemLink)

						if EquipRecommendedGear_Settings["ignoreLemixJewelry"] and PlayerGetTimerunningSeasonID() == 2 and (itemEquipLoc == "INVTYPE_NECK" or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET") then
							equippable = false
						end

						if equippable then
							tinsert(eligibleItems, { itemLink = itemLink, itemID = itemID, itemEquipLoc = itemEquipLoc, unique = unique, ilv = ilv, bag = bag, bagSlot = bagSlot })
						end
					end
				end
			end
		end
	end

	local canDualWield = false
	for _, spec in pairs(app.DualWield) do
		if app.SpecID == spec then
			canDualWield = true
			break
		end
	end

	if not canDualWield then
		for i, item in pairs(eligibleItems) do
			if app.Slot[item.itemEquipLoc] == 18 then
				eligibleItems[i].itemEquipLoc = "INVTYPE_WEAPONMAINHAND"
			end
		end
	end

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: ELIGIBLE ITEMS")
		for _, v in ipairs(eligibleItems) do
			local unique = "false"
			if v.unique then unique = "true" end
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Filter unique-equipped (thanks, ChatGPT)
	local filtered = {}
	local seen = {}

	for _, item in ipairs(eligibleItems) do
		if item.unique then
			local existing = seen[item.itemID]
			if existing then
				if item.ilv > existing.ilv then
					seen[item.itemID] = item
				elseif item.ilv == existing.ilv then
					-- Prefer already equipped
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

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: ELIGIBLE ITEMS MINUS UNIQUE DUPES")
		for _, v in ipairs(eligibleItems) do
			local unique = "false"
			if v.unique then unique = "true" end
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Keep the highest iLv entries (thanks, ChatGPT)
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
		-- Prefer higher item level > equipped items > higher itemID
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

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: BEST ITEMS")
		for _, v in ipairs(eligibleItems) do
			local unique = "false"
			if v.unique then unique = "true" end
			print(v.itemLink..", " .. v.itemID..", " .. v.itemEquipLoc..", " .. unique..", " .. v.ilv..", " .. v.bag.."."..v.bagSlot)
		end
	end

	-- Check ring and trinket slots
	local openSlots = { [11] = true, [12] = true, [13] = true, [14] = true }
	for _, item in ipairs(eligibleItems) do
		if (app.Slot[item.itemEquipLoc] == 11 or app.Slot[item.itemEquipLoc] == 13) and item.bag == -1 then
			openSlots[item.bagSlot] = false
		end
	end

	-- Gear upgrades
	local upgrades = {}
	for _, item in ipairs(eligibleItems) do
		if (app.Slot[item.itemEquipLoc] <= 10 or app.Slot[item.itemEquipLoc] == 15) and item.bag ~= -1 then
			tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = app.Slot[item.itemEquipLoc] })
		elseif app.Slot[item.itemEquipLoc] == 11 and item.bag ~= -1 then
			if openSlots[11] == true then
				tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = 11 })
				openSlots[11] = false
			elseif openSlots[12] == true then
				tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = 12 })
				openSlots[12] = false
			end
		elseif app.Slot[item.itemEquipLoc] == 13 and item.bag ~= -1 then
			if openSlots[13] == true then
				tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = 13 })
				openSlots[13] = false
			elseif openSlots[14] == true then
				tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = 14 })
				openSlots[14] = false
			end
		end
	end

	-- Weapon upgrades (Gemini version!)
	if EquipRecommendedGear_CharSettings["includeWeapons"] then
		local weapons = {}

		-- 1. Extract and Normalize Weapon Data
		-- We cache the numeric slot ID here to avoid looking it up repeatedly in loops
		for _, item in ipairs(eligibleItems) do
			local s = app.Slot[item.itemEquipLoc]
			if s and s > 15 then
				tinsert(weapons, {
					itemLink = item.itemLink,
					itemID = item.itemID,
					ilv = item.ilv,
					bag = item.bag,
					bagSlot = item.bagSlot,
					equipSlot = s, -- 16 (MH), 17 (OH), 18 (1H), 1617 (2H)
					obj = item     -- Reference for strict equality checks
				})
			end
		end

		-- 2. Solver Function
		local function findBestWeaponCombo(candidates)
			if #candidates == 0 then return {} end

			local bestScore = 0
			local bestCombo = {}
			local canTitanGrip = (app.SpecID == 722) -- Fury Warrior (Titan's Grip)

			-- Helper: Update best combo if the new score is higher
			local function checkUpdate(combo, score)
				local isUpgrade = false
				if score > bestScore then
					isUpgrade = true
				elseif score == bestScore and score > 0 then
					-- Tie-breaker 1: Prefer currently equipped items (minimize swapping)
					local newEquipped = (combo[1].bag == -1 and 1 or 0) + (combo[2] and combo[2].bag == -1 and 1 or 0)
					local oldEquipped = (bestCombo[1] and bestCombo[1].bag == -1 and 1 or 0) + (bestCombo[2] and bestCombo[2].bag == -1 and 1 or 0)

					if newEquipped > oldEquipped then
						isUpgrade = true
					elseif newEquipped == oldEquipped then
						-- Tie-breaker 2: Deterministic sort by ItemID sum
						local newId = combo[1].itemID + (combo[2] and combo[2].itemID or 0)
						local oldId = (bestCombo[1] and bestCombo[1].itemID or 0) + (bestCombo[2] and bestCombo[2].itemID or 0)
						if newId > oldId then isUpgrade = true end
					end
				end

				if isUpgrade then
					bestScore = score
					bestCombo = combo
				end
			end

			-- Helper: Check if two items can be dual-wielded
			local function isValidPair(mh, oh)
				if mh.obj == oh.obj then return false end -- Cannot equip the literal same object twice

				-- Fury Warrior: Allow 2H + 2H
				if canTitanGrip and mh.equipSlot == 1617 and oh.equipSlot == 1617 then
					return true
				end

				-- Standard Rules
				-- 1. Main Hand valid? (16, 18, or 1617 if TG)
				local validMH = (mh.equipSlot == 16 or mh.equipSlot == 18) or (canTitanGrip and mh.equipSlot == 1617)
				if not validMH then return false end

				-- 2. Off Hand valid? (17, 18, or 1617 if TG)
				local validOH = (oh.equipSlot == 17 or oh.equipSlot == 18) or (canTitanGrip and oh.equipSlot == 1617)
				if not validOH then return false end

				-- 3. No mixing 2H with 1H/Shield (Strict rule, simplifies logic)
				if (mh.equipSlot == 1617) ~= (oh.equipSlot == 1617) then return false end

				return true
			end

			-- A. Iterate Single Items (For non-Fury 2H users)
			if not canTitanGrip then
				for _, w in ipairs(candidates) do
					if w.equipSlot == 1617 then
						local combo = { [1] = w }
						combo[1].targetSlot = 16 -- Force 2H to slot 16
						checkUpdate(combo, w.ilv * 2) -- Normalize score to match dual wield
					end
				end
			end

			-- B. Iterate Combinations (Dual Wield / Titan's Grip)
			for i = 1, #candidates do
				for j = 1, #candidates do
					if i ~= j then
						local w1, w2 = candidates[i], candidates[j]

						-- Attempt w1 as Main Hand, w2 as Off Hand
						if isValidPair(w1, w2) then
							local combo = { [1] = w1, [2] = w2 }
							combo[1].targetSlot = 16
							combo[2].targetSlot = 17
							checkUpdate(combo, w1.ilv + w2.ilv)
						end
					end
				end
			end

			return bestCombo
		end

		-- 3. Calculate and Apply
		local bestWeaponCombo = findBestWeaponCombo(weapons)

		for _, weapon in ipairs(bestWeaponCombo) do
			-- If we calculated a specific target slot, apply it now
			local finalSlot = weapon.targetSlot or weapon.equipSlot
			if finalSlot == 1617 then finalSlot = 16 end -- Safety fallback

			-- Only queue upgrade if it's in the bag (not already equipped)
			if weapon.bag ~= -1 then
				tinsert(upgrades, {
					itemLink = weapon.itemLink,
					bag = weapon.bag,
					bagSlot = weapon.bagSlot,
					equipSlot = finalSlot
				})
			end
		end
	end

	if EquipRecommendedGear_Settings["debug"] then
		app.Print("DEBUG: UPGRADES")
		for _, v in ipairs(upgrades) do
			print(v.itemLink..", " .. v.bag.."."..v.bagSlot..", " .. v.equipSlot)
		end
	end

	for _, item in ipairs(upgrades) do
		if item.bag and item.bagSlot then	-- This gets weird in super niche situations, so let's doublecheck if the data exists
			ClearCursor()
			C_Container.PickupContainerItem(item.bag, item.bagSlot)
			EquipCursorItem(item.equipSlot)
		end
	end

	C_Timer.After(1, function()	-- Delay finishing, so the function doesn't run multiple times
		if not msg or type(msg) ~= "number" then msg = 2 end

		local next = next
		if next(upgrades) == nil and specName then
			if msg == 2 then
				app.Print(L.EQUIP_NO_UPDGRADE, "|c" .. classColor .. specName .. " " .. className .. "|R.")
			end
		elseif specName then
			if msg >= 1 then
				app.Print(L.EQUIP_UPDGRADE, "|c" .. classColor .. specName .. " " .. className .. "|R.")
			end
		else
			app.Print(L.ERROR_EQUIP)
		end

		app.Flag.Busy = false
	end)
end

app.Event:Register("QUEST_TURNED_IN", function(questID, xpReward, moneyReward)
	if EquipRecommendedGear_Settings["runAfterQuest"] == true and not InCombatLockdown() then
		C_Timer.After(1, function()
			api.DoTheThing(EquipRecommendedGear_Settings["chatMessage"])
		end)
	end
end)
