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

	local string = app.Button.Tooltip:CreateFontString("ARTWORK", nil, "GameFontNormal")
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

	-- Fury Warrior talent choice
	if app.SpecID == 72 then
		-- Single-Minded Fury
		if IsPlayerSpell(81099) then
			app.SpecID = 721
		else
			app.SpecID = 722
		end
	end

	local armorClass
	for k, v in pairs(app.Armor) do
		for _, v2 in pairs(v) do
			if v2 == app.ClassID then
				armorClass = k
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

						local itemType = classID.."."..subclassID
						local equippable = false

						-- Filter by armor class
						if itemType == app.Type[armorClass] or (itemType == app.Type["General"] and itemEquipLoc ~= "INVTYPE_TABARD" and itemEquipLoc ~= "INVTYPE_BODY" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD") or itemEquipLoc == "INVTYPE_CLOAK" then
							equippable = true
						end

						-- Filter by spec-appropriate weapons
						if itemType == "2.19" then itemEquipLoc = "INVTYPE_WEAPONMAINHAND" end	-- Adjust Wands because goddammit Blizzard
							--722
						for typeText, typeNumber in pairs(app.Type) do
							if typeNumber == itemType and not (itemType == "4.1" or itemType == "4.2" or itemType == "4.3" or itemType == "4.4" or (itemType == "4.0" and itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_WEAPONOFFHAND")) then
								for _, spec in pairs(app.Weapon[typeText]) do
									if spec == app.SpecID then
										print(itemLink)
										for stat, _ in pairs(C_Item.GetItemStats(itemLink)) do
											if primaryStat == stat then
												equippable = true
											end
										end
									end
								end
							end
						end

						if equippable then
							tinsert(eligibleItems, { itemLink = itemLink, itemID = itemID, itemEquipLoc = itemEquipLoc, unique = unique, ilv = ilv, bag = bag, bagSlot = bagSlot })
						end
					end
				end
			end
		end
	end

	app.CanDualWield = false
	for k, v in pairs(app.DualWield) do
		if app.SpecID == v then
			app.CanDualWield = true
		end
	end

	-- Move one-handed weapons to main hand, if the character cannot dual wield
	if not app.CanDualWield then
		for k, v in pairs(eligibleItems) do
			if app.Slot[v.itemEquipLoc] == 18 then
				upgrades[k].itemEquipLoc = "INVTYPE_WEAPONMAINHAND"
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

	-- Weapon upgrades
	if EquipRecommendedGear_CharSettings["includeWeapons"] then
		local filtered = {}
		local weapons = {}
		for _, item in ipairs(eligibleItems) do
			if app.Slot[item.itemEquipLoc] > 15 then
				tinsert(weapons, { itemLink = item.itemLink, itemID = item.itemID, ilv = item.ilv, bag = item.bag, bagSlot = item.bagSlot, equipSlot = app.Slot[item.itemEquipLoc] })
			else
				tinsert(filtered, item)
			end
		end
		eligibleItems = filtered

		-- Get best weapon combo (thanks, ChatGPT)
		local function findBestWeaponCombo(weaponUpgrade)
			if #weaponUpgrade == 0 then return {} end

			-- Single weapon: return as-is (normalize 2H to 16)
			if #weaponUpgrade == 1 then
				local single = weaponUpgrade[1]
				if single.equipSlot == 1617 then
					single.equipSlot = 16
				end
				return { single }
			end

			local maxIlv = 0
			local bestCombo = {}

			-- HELPER FUNCTIONS

			-- Compute total ilvl of a combo; returns 0 for invalid combos
			local function comboScore(w1, w2)
				if not w2 then
					-- Single weapon: 2H counts double
					return (w1.equipSlot == 1617) and (w1.ilv * 2) or w1.ilv
				end

				-- Disallow mixing 2H with anything else
				if w1.equipSlot == 1617 or w2.equipSlot == 1617 then
					return 0
				end

				-- Only valid dual-wield combos
				local valid =
					(w1.equipSlot == 16 and w2.equipSlot == 17) or
					(w1.equipSlot == 16 and w2.equipSlot == 18) or
					(w1.equipSlot == 18 and w2.equipSlot == 17) or
					(w1.equipSlot == 18 and w2.equipSlot == 18)

				return valid and (w1.ilv + w2.ilv) or 0
			end

			-- Determines if a new combo is better than the current best
			local function isBetterCombo(newCombo, newScore)
				if newScore > maxIlv then
					return true
				elseif newScore == maxIlv then
					-- Tie-breaking: prefer more equipped weapons
					local equippedNew, equippedOld = 0, 0
					local idNew, idOld = 0, 0
					for _, w in ipairs(newCombo) do
						if w.bag == -1 then equippedNew = equippedNew + 1 end
						idNew = idNew + w.itemID
					end
					for _, w in ipairs(bestCombo) do
						if w.bag == -1 then equippedOld = equippedOld + 1 end
						idOld = idOld + w.itemID
					end

					if equippedNew > equippedOld then return true
					elseif equippedNew < equippedOld then return false end
					-- Final tie-breaker: higher itemID
					return idNew > idOld
				end
				return false
			end

			-- FURY WARRIOR
			if app.SpecID == 722 then
				for i = 1, #weaponUpgrade - 1 do
					local w1 = weaponUpgrade[i]
					if w1.equipSlot == 1617 then
						for j = i + 1, #weaponUpgrade do
							local w2 = weaponUpgrade[j]
							if w2.equipSlot == 1617 then
								local score = w1.ilv + w2.ilv
								if isBetterCombo({ w1, w2 }, score) then
									maxIlv = score
									bestCombo = { w1, w2 }
								end
							end
						end
					end
				end
			else
				-- OTHER SPECS
				for i = 1, #weaponUpgrade do
					local w1 = weaponUpgrade[i]

					-- Single 2H
					if w1.equipSlot == 1617 then
						local score = w1.ilv * 2
						if isBetterCombo({ w1 }, score) then
							maxIlv = score
							bestCombo = { w1 }
						end
					end

					-- Dual-wield combos
					for j = i + 1, #weaponUpgrade do
						local w2 = weaponUpgrade[j]
						local score = comboScore(w1, w2)
						if score > 0 and isBetterCombo({ w1, w2 }, score) then
							maxIlv = score
							bestCombo = { w1, w2 }
						end
					end
				end
			end

			-- ADJUST EQUIPSLOT
			if #bestCombo == 1 and bestCombo[1].equipSlot == 1617 then
				-- Single 2H → main hand (16)
				bestCombo[1].equipSlot = 16
			elseif #bestCombo == 2 then
				local w1, w2 = bestCombo[1], bestCombo[2]
				local s1, s2 = w1.equipSlot, w2.equipSlot

				local function assignSlots(first, second)
					first.equipSlot = 16
					second.equipSlot = 17
				end

				-- Handle valid dual-wield combos AND 2H+2H
				if (s1 == 16 and s2 == 17)
				or (s1 == 16 and s2 == 18)
				or (s1 == 18 and s2 == 17)
				or (s1 == 18 and s2 == 18)
				or (s1 == 1617 and s2 == 1617) then

					-- Special handling for 18+18 or 1617+1617
					if (s1 == 18 and s2 == 18) or (s1 == 1617 and s2 == 1617) then
						-- One equipped? keep its bagSlot
						if w1.bag == -1 and w2.bag ~= -1 then
							if w1.bagSlot == 16 then assignSlots(w1, w2) else assignSlots(w2, w1) end
						elseif w2.bag == -1 and w1.bag ~= -1 then
							if w2.bagSlot == 16 then assignSlots(w2, w1) else assignSlots(w1, w2) end
						else
							-- Neither or both equipped → higher ilv in slot 16, tie → higher itemID
							if w1.ilv > w2.ilv or (w1.ilv == w2.ilv and w1.itemID > w2.itemID) then
								assignSlots(w1, w2)
							else
								assignSlots(w2, w1)
							end
						end
					else
						-- Normal dual-wield: assign 16+17
						assignSlots(w1, w2)
					end
				end
			end

			return bestCombo
		end
		weapons = findBestWeaponCombo(weapons)

		for _, item in ipairs(weapons) do
			if item.bag ~= -1 then
				tinsert(upgrades, { itemLink = item.itemLink, bag = item.bag, bagSlot = item.bagSlot, equipSlot = item.equipSlot })
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
