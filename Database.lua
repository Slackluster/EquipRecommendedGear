------------------------------------------
-- Equip Recommended Gear: Database.lua --
------------------------------------------
-- Raw information to refer to

-- Initialisation
local appName, app = ...	-- Returns the addon name and a unique table

-- Used strings
app.NameLong = "|R|cffC69B6DEquip Recommended Gear|R"
app.NameShort = "|R|cffC69B6DERG|R"

-- ItemEquipLoc to key
app.Slot = {}
app.Slot["INVTYPE_HEAD"] = 1
app.Slot["INVTYPE_NECK"] = 2
app.Slot["INVTYPE_SHOULDER"] = 3
app.Slot["INVTYPE_CLOAK"] = 15
app.Slot["INVTYPE_CHEST"] = 5
app.Slot["INVTYPE_ROBE"] = 5
app.Slot["INVTYPE_WRIST"] = 9
app.Slot["INVTYPE_HAND"] = 10
app.Slot["INVTYPE_WAIST"] = 6
app.Slot["INVTYPE_LEGS"] = 7
app.Slot["INVTYPE_FEET"] = 8
-- Custom code for rings and trinkets
app.Slot["INVTYPE_FINGER"] = 11	-- Also 12
app.Slot["INVTYPE_TRINKET"] = 13	-- Also 14
--- Custom code for weapons
app.Slot["INVTYPE_RANGED"] = 1617	-- Main hand, no off hand
app.Slot["INVTYPE_RANGEDRIGHT"] = 1617	-- Main hand, no off hand
app.Slot["INVTYPE_2HWEAPON"] = 1617	-- Main hand, no off hand
app.Slot["INVTYPE_WEAPONMAINHAND"] = 16	-- Main hand
app.Slot["INVTYPE_WEAPONOFFHAND"] = 17	-- Off hand
app.Slot["INVTYPE_HOLDABLE"] = 17	-- Off hand
app.Slot["INVTYPE_SHIELD"] = 17	-- Off hand
app.Slot["INVTYPE_WEAPON"] = 18	-- Can be main hand or off hand, if char can Dual Wield

-- Type.Subtype to item type
app.Type = {}
app.Type["General"] = "4.0"	-- Neck, Ring, Trinket, Off-Hand (and shirts and tabards, yay)
app.Type["Cloth"] = "4.1"
app.Type["Leather"] = "4.2"
app.Type["Mail"] = "4.3"
app.Type["Plate"] = "4.4"
app.Type["Shield"] = "4.6"
app.Type["Axe1H"] = "2.0"
app.Type["Axe2H"] = "2.1"
app.Type["Bow"] = "2.2"
app.Type["Gun"] = "2.3"
app.Type["Mace1H"] = "2.4"
app.Type["Mace2H"] = "2.5"
app.Type["Polearm"] = "2.6"
app.Type["Sword1H"] = "2.7"
app.Type["Sword2H"] = "2.8"
app.Type["Warglaive"] = "2.9"
app.Type["Staff"] = "2.10"
app.Type["Fist"] = "2.13"
app.Type["Dagger"] = "2.15"
app.Type["Crossbow"] = "2.18"
app.Type["Wand"] = "2.19"

-- Armor -> Class
app.Armor = {}
app.Armor["Cloth"] = { 5, 8, 9 }	-- Priest, Mage, Warlock
app.Armor["Leather"] = { 4, 10, 11, 12 }	-- Rogue, Monk, Druid, Demon Hunter
app.Armor["Mail"] = { 3, 7, 13 }	-- Hunter, Shaman, Evoker
app.Armor["Plate"] = { 1, 2, 6}	-- Warrior, Paladin, Death Knight

-- Weapon -> Spec
app.Weapon = {}
app.Weapon["General"] = { 250, 251, 252, 577, 581, 102, 103, 104, 1467, 1468, 1473, 253, 254, 255, 62, 63, 64, 268, 270, 269, 65, 66, 70, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 71, 72, 73 }	-- Everyone
app.Weapon["Shield"] = { 65, 66, 73, 262, 264 }	-- Holy + Prot Pala, Prot Warr, Ele + Resto Shaman
app.Weapon["Axe1H"] = { 251, 577, 581, 1467, 1468, 1473, 268, 269, 270, 65, 66, 260, 262, 263, 264, 72, 73 }	-- Frost DK, 2x DH, 3x Evoker, 3x Monk, Holy + Prot Pala, Outlaw Rogue, 3x Shaman, Fury + Prot Warr
app.Weapon["Axe2H"] = { 65, 70, 71, 72, 250, 251, 252, 1467, 1468, 1473, 255, 262, 264 }	-- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 3x Evoker, Surv Hunter, Ele + Resto Shaman
app.Weapon["Bow"] = { 253, 254 }	-- BM + Mark Hunter
app.Weapon["Gun"] = { 253, 254 }	-- BM + Mark Hunter
app.Weapon["Mace1H"] = { 251, 102, 105, 1467, 1468, 1473, 268, 269, 270, 65, 66, 256, 257, 258, 260, 262, 263, 264, 72, 73 }	-- Frost DK, Balance + Resto Druid, 3x Evoker, 3x Monk, Holy + Prot Pala, 3x Priest, Outlaw Rogue, 3x Shaman, Fury + Prot Warr
app.Weapon["Mace2H"] = { 65, 70, 71, 72, 250, 251, 252, 102, 103, 104, 105, 1467, 1468, 1473, 262, 264 }	-- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 4x Druid, 3x Evoker, Ele + Resto Shaman
app.Weapon["Polearm"] = { 250, 251, 252, 102, 103, 104, 105, 255, 268, 269, 270, 65, 70, 71, 72 }	-- 3x DK, 4x Druid, Surv Hunt, 3x Monk, Holy + Ret Pala, Arms + Fury Warr
app.Weapon["Sword1H"] = { 251, 577, 581, 1467, 1468, 1473, 62, 63, 64, 268, 269, 270, 65, 66, 260, 265, 266, 267, 72, 73 }	-- Frost DK, 2x DH, 3x Evoker, 3x Mage, 3x Monk, Holy + Prot Pala, Outlaw Rogue, 3x Lock, Fury + Prot Warr
app.Weapon["Sword2H"] = { 65, 70, 71, 72, 250, 251, 252, 1467, 1468, 1469, 255 }	-- Holy + Ret Pala, Arms + Fury Warr, 3x DK, 3x Evoker, Surv Hunt
app.Weapon["Warglaive"] = { 577, 581 }	-- 2x DH
app.Weapon["Staff"] = { 102, 103, 104, 105, 1467, 1468, 1473, 255, 62, 63, 64, 268, 269, 270, 256, 257, 258, 262, 264, 265, 266, 267, 71, 72 }	-- 4x Druid, 3x Evoker, Surv Hunter, 3x Mage, 3x Monk, 3x Priest, Ele + Resto Shaman, 3x Lock, Fury + Arms Warr
app.Weapon["Fist"] = { 577, 581, 1467, 1468, 1473, 268, 269, 270, 260, 262, 263, 264, 73 }	-- 2x DH, 3x Evoker, 3x Monk, Outlaw Rogue, 3x Shaman, Prot Warr
app.Weapon["Dagger"] = { 102, 105, 1467, 1468, 1473, 62, 63, 64, 256, 257, 258, 259, 261, 262, 263, 264 }	-- Balance + Resto Druid, 3x Evoker, 3x Mage, 3x Priest, Ass + Sub Rogue, 3x Shaman
app.Weapon["Crossbow"] = { 253, 254 }	-- BM + Mark Hunter
app.Weapon["Wand"] = { 62, 63, 64, 256, 257, 258, 265, 266, 267 }	-- 3x Mage, 3x Priest, 3x Lock

-- Stat -> Spec
app.Stat = {}
app.Stat["ITEM_MOD_AGILITY_SHORT"] = { 577, 581, 103, 104, 253, 254, 255, 268, 269, 259, 260, 261, 263 }	-- 2x DH, Feral + Guardian Druid, 3x Hunter, Brew + Wind Monk, 3x Rogue, Enh Shaman
app.Stat["ITEM_MOD_INTELLECT_SHORT"] = { 102, 105, 1467, 1468, 1473, 62, 63, 64, 270, 65, 256, 257, 258, 262, 264, 265, 266, 267 }	-- Balance + Resto Druid, 3x Evoker, 3x Mage, Mist Monk, Holy Pala, 3x Priest, Ele + Resto Shaman, 3x Lock
app.Stat["ITEM_MOD_STRENGTH_SHORT"] = { 250, 251, 252, 66, 70, 71, 72, 73 }	-- 3x DK, Prot + Ret Pala, 3x Warr

app.DualWield = { 577, 581, 259, 260, 261, 251, 72, 263, 268, 269 }	-- 2x DH, 3x Rogue, Frost DK, Fury Warr, Enh Shaman, Brew + Wind Monk