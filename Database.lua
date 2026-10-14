------------------------------------------
-- Equip Recommended Gear: Database.lua --
------------------------------------------

local appName, app = ...

-- Strings
app.Name = "Equip Recommended Gear"
app.NameLong = app:Colour("Equip Recommended Gear")
app.NameShort = app:Colour("ERG")
app.NamePrefix = "EquipRecGear"
_G["BINDING_NAME_EQUIPRECOMMENDEDGEAR"] = app.Name
_G["BINDING_NAME_SLACKWARE"] = "Slackware"

-- Textures
app.Icon = "Interface\\Icons\\garrison_bluearmorupgrade"
app.IconReady = CreateSimpleTextureMarkup("Interface\\RaidFrame\\ReadyCheck-Ready")
app.IconNotReady = CreateSimpleTextureMarkup("Interface\\RaidFrame\\ReadyCheck-NotReady")

-- ItemEquipLoc to key
app.Slot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_NECK"] = 2,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_CLOAK"] = 15,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5,
	["INVTYPE_WRIST"] = 9,
	["INVTYPE_HAND"] = 10,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	-- Custom code for rings and trinkets
	["INVTYPE_FINGER"] = 11, -- Also 12
	["INVTYPE_TRINKET"] = 13, -- Also 14
	-- Custom code for weapons
	["INVTYPE_RANGED"] = 1617, -- Main hand, no off hand
	["INVTYPE_RANGEDRIGHT"] = 1617, -- Main hand, no off hand (but also Wands, goddammit Blizzard)
	["INVTYPE_2HWEAPON"] = 1617, -- Main hand, no off hand
	["INVTYPE_WEAPONMAINHAND"] = 16, -- Main hand
	["INVTYPE_WEAPONOFFHAND"] = 17, -- Off hand
	["INVTYPE_HOLDABLE"] = 17, -- Off hand
	["INVTYPE_SHIELD"] = 17, -- Off hand
	["INVTYPE_WEAPON"] = 18, -- Can be main hand or off hand, if char can Dual Wield
}

-- Type.Subtype to item type
app.Type = {
	["General"] = "4.0", -- Neck, Ring, Trinket, Off-Hand (and shirts and tabards, yay)
	["Cloth"] = "4.1",
	["Leather"] = "4.2",
	["Mail"] = "4.3",
	["Plate"] = "4.4",
	["Shield"] = "4.6",
	["Axe1H"] = "2.0",
	["Axe2H"] = "2.1",
	["Bow"] = "2.2",
	["Gun"] = "2.3",
	["Mace1H"] = "2.4",
	["Mace2H"] = "2.5",
	["Polearm"] = "2.6",
	["Sword1H"] = "2.7",
	["Sword2H"] = "2.8",
	["Warglaive"] = "2.9",
	["Staff"] = "2.10",
	["Fist"] = "2.13",
	["Dagger"] = "2.15",
	["Crossbow"] = "2.18",
	["Wand"] = "2.19",
}

-- Armor -> Class
app.Armor = {
	["Cloth"] = { 5, 8, 9 }, -- Priest, Mage, Warlock
	["Leather"] = { 4, 10, 11, 12 }, -- Rogue, Monk, Druid, Demon Hunter
	["Mail"] = { 3, 7, 13 }, -- Hunter, Shaman, Evoker
	["Plate"] = { 1, 2, 6 }, -- Warrior, Paladin, Death Knight
}

-- Weapon -> Spec
app.Weapon = {
	["General"] = { 250, 251, 252, 577, 581, 1480, 102, 103, 104, 1467, 1468, 1473, 253, 254, 255, 62, 63, 64, 268, 270, 269, 65, 66, 70, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 71, 72, 73 }, -- Everyone
	["Shield"] = { 65, 66, 73, 262, 264 }, -- Holy + Prot Pala, Prot Warr, Ele + Resto Shaman
	["Axe1H"] = { 251, 577, 581, 1480, 1467, 1468, 1473, 268, 269, 270, 65, 66, 260, 262, 263, 264, 73 }, -- Frost DK, 3x DH, 3x Evoker, 3x Monk, Holy + Prot Pala, Outlaw Rogue, 3x Shaman, Fury + Prot Warr
	["Axe2H"] = { 65, 70, 71, 72, 250, 251, 252, 1467, 1468, 1473, 255, 262, 264 }, -- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 3x Evoker, Surv Hunter, Ele + Resto Shaman
	["Bow"] = { 253, 254 }, -- BM + Mark Hunter
	["Gun"] = { 253, 254 }, -- BM + Mark Hunter
	["Mace1H"] = { 251, 102, 105, 1467, 1468, 1473, 268, 269, 270, 65, 66, 256, 257, 258, 260, 262, 263, 264, 73 }, -- Frost DK, Balance + Resto Druid, 3x Evoker, 3x Monk, Holy + Prot Pala, 3x Priest, Outlaw Rogue, 3x Shaman, Fury + Prot Warr
	["Mace2H"] = { 65, 70, 71, 72, 250, 251, 252, 102, 103, 104, 105, 1467, 1468, 1473, 262, 264 }, -- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 4x Druid, 3x Evoker, Ele + Resto Shaman
	["Polearm"] = { 250, 251, 252, 102, 103, 104, 105, 255, 268, 269, 270, 65, 70, 71, 72 }, -- 3x DK, 4x Druid, Surv Hunt, 3x Monk, Holy + Ret Pala, Arms + Fury Warr
	["Sword1H"] = { 251, 577, 581, 1480, 1467, 1468, 1473, 62, 63, 64, 268, 269, 270, 65, 66, 260, 265, 266, 267, 73 }, -- Frost DK, 3x DH, 3x Evoker, 3x Mage, 3x Monk, Holy + Prot Pala, Outlaw Rogue, 3x Lock, Fury + Prot Warr
	["Sword2H"] = { 65, 70, 71, 72, 250, 251, 252, 1467, 1468, 1473, 255 }, -- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 3x Evoker, Surv Hunt
	["Warglaive"] = { 577, 581, 1480 }, -- 3x DH
	["Staff"] = { 102, 103, 104, 105, 1467, 1468, 1473, 255, 62, 63, 64, 268, 269, 270, 256, 257, 258, 262, 264, 265, 266, 267, 71, 72 }, -- 4x Druid, 3x Evoker, Surv Hunter, 3x Mage, 3x Monk, 3x Priest, Ele + Resto Shaman, 3x Lock, Fury + Arms Warr
	["Fist"] = { 577, 581, 1480, 1467, 1468, 1473, 268, 269, 270, 260, 262, 263, 264, 73 }, -- 3x DH, 3x Evoker, 3x Monk, Outlaw Rogue, 3x Shaman, Prot Warr
	["Dagger"] = { 102, 105, 1467, 1468, 1473, 62, 63, 64, 256, 257, 258, 259, 261, 262, 263, 264, 265, 266, 267 }, -- Balance + Resto Druid, 3x Evoker, 3x Mage, 3x Priest, Ass + Sub Rogue, 3x Shaman, 3x Lock
	["Crossbow"] = { 253, 254 }, -- BM + Mark Hunter
	["Wand"] = { 62, 63, 64, 256, 257, 258, 265, 266, 267 }, -- 3x Mage, 3x Priest, 3x Lock
}

-- Stat -> Spec
app.Stat = {
	["ITEM_MOD_AGILITY_SHORT"] = { 577, 581, 1480, 103, 104, 253, 254, 255, 268, 269, 259, 260, 261, 263 }, -- 3x DH, Feral + Guardian Druid, 3x Hunter, Brew + Wind Monk, 3x Rogue, Enh Shaman
	["ITEM_MOD_INTELLECT_SHORT"] = { 102, 105, 1467, 1468, 1473, 62, 63, 64, 270, 65, 256, 257, 258, 262, 264, 265, 266, 267 }, -- Balance + Resto Druid, 3x Evoker, 3x Mage, Mist Monk, Holy Pala, 3x Priest, Ele + Resto Shaman, 3x Lock
	["ITEM_MOD_STRENGTH_SHORT"] = { 250, 251, 252, 66, 70, 71, 72, 73 }, -- 3x DK, Prot + Ret Pala, 3x Warr
}
app.DualWield = { 577, 581, 1480, 259, 260, 261, 251, 72, 263, 268, 269 } -- 3x DH, 3x Rogue, Frost DK, Fury Warr, Enh Shaman, Brew + Wind Monk

---- FOREVER

-- -- Armor -> Class
-- -- Preferred armor proficiency, with level-dependent transitions
-- app.Armor = {
--     ["Cloth"] = { 5, 8, 9 }, -- Priest, Mage, Warlock
--     ["Leather"] = { 4, 11, 3, 7 }, -- Rogue, Druid, Hunter + Shaman (1-39)
--     ["Mail"] = { 3, 7, 1, 2 }, -- Hunter + Shaman (40+), Warrior + Paladin (1-39)
--     ["Plate"] = { 1, 2 }, -- Warrior + Paladin (40+)
-- }

-- -- Minimum level at which a class can equip an armor type
-- app.ArmorLevel = {
--     ["Mail"] = { [3] = 40, [7] = 40 }, -- Hunter, Shaman
--     ["Plate"] = { [1] = 40, [2] = 40 }, -- Warrior, Paladin
-- }

-- -- Weapon -> Spec
-- -- Suitable weapon categories, not every technically usable category
-- app.Weapon = {
--     ["General"] = { 102, 103, 105, 253, 254, 255, 62, 63, 64, 65, 66, 70, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 71, 72, 73 }, -- Everyone

--     ["Shield"] = { 65, 66, 262, 264, 73 }, -- Holy + Prot Pala, Ele + Resto Shaman, Prot Warr

--     ["Axe1H"] = { 253, 254, 255, 72, 73 }, -- 3x Hunter, Fury + Prot Warr
--     ["Axe2H"] = { 255, 70, 263, 71, 72 }, -- Surv Hunter, Ret Pala, Enh Shaman, Arms + Fury Warr

--     ["Bow"] = { 253, 254, 255 }, -- 3x Hunter
--     ["Gun"] = { 253, 254, 255 }, -- 3x Hunter

--     ["Mace1H"] = { 102, 105, 65, 66, 256, 257, 258, 262, 264, 72, 73 }, -- Balance + Resto Druid, Holy + Prot Pala, 3x Priest, Ele + Resto Shaman, Fury + Prot Warr
--     ["Mace2H"] = { 103, 70, 263, 71, 72 }, -- Feral Druid, Ret Pala, Enh Shaman, Arms + Fury Warr

--     ["Polearm"] = { 255, 71, 72 }, -- Surv Hunter, Arms + Fury Warr

--     ["Sword1H"] = { 253, 254, 255, 62, 63, 64, 259, 260, 261, 265, 266, 267, 72, 73 }, -- 3x Hunter, Mage, Rogue, Lock, Fury + Prot Warr
--     ["Sword2H"] = { 255, 70, 71, 72 }, -- Surv Hunter, Ret Pala, Arms + Fury Warr

--     ["Staff"] = { 102, 103, 105, 253, 254, 255, 62, 63, 64, 256, 257, 258, 262, 264, 265, 266, 267 }, -- 3x Druid, Hunter, Mage, Priest, Ele + Resto Shaman, Lock

--     ["Fist"] = { 103, 255, 259, 260, 261, 72 }, -- Feral Druid, Surv Hunter, 3x Rogue, Fury Warr

--     ["Dagger"] = { 102, 105, 62, 63, 64, 256, 257, 258, 259, 260, 261, 262, 264, 265, 266, 267, 72 }, -- Balance + Resto Druid, Mage, Priest, Rogue, Ele + Resto Shaman, Lock, Fury Warr

--     ["Crossbow"] = { 253, 254, 255 }, -- 3x Hunter
--     ["Wand"] = { 62, 63, 64, 256, 257, 258, 265, 266, 267 }, -- 3x Mage, Priest, Lock
-- }

-- -- Stat -> Spec
-- -- Primary-stat suitability, allowing multiple relevant stats per spec
-- app.Stat = {
--     ["ITEM_MOD_AGILITY_SHORT"] = { 103, 253, 254, 255, 259, 260, 261, 263, 71, 72, 73 }, -- Feral Druid, Hunter, Rogue, Enh Shaman, Warrior

--     ["ITEM_MOD_INTELLECT_SHORT"] = { 102, 105, 62, 63, 64, 65, 256, 257, 258, 262, 264, 265, 266, 267 }, -- Balance + Resto Druid, Mage, Holy Pala, Priest, Ele + Resto Shaman, Lock

--     ["ITEM_MOD_STRENGTH_SHORT"] = { 103, 66, 70, 263, 71, 72, 73 }, -- Feral Druid, Prot + Ret Pala, Enh Shaman, Warrior
-- }

-- -- Dual wield -> Spec
-- app.DualWield = { 255, 259, 260, 261, 72 } -- Surv Hunter, 3x Rogue, Fury Warr

-- -- Minimum level for dual-wield proficiency
-- app.DualWieldLevel = {
--     [3] = 20, -- Hunter
--     [4] = 10, -- Rogue
--     [1] = 20, -- Warrior
-- }
