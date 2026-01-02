-------------------------------------
-- Equip Recommended Gear: API.lua --
-------------------------------------

-- Equip recommended gear, and send a chat message regardless of if any new gear was equipped
EquipRecommendedGear:DoTheThing()

-- Equip recommended gear, and send a chat message if any new gear was equipped
EquipRecommendedGear:DoTheThing(1)

-- Equip recommended gear, and send no chat message regardless of if any new gear was equipped
EquipRecommendedGear:DoTheThing(0)

-- Returns if an item is equippable and appropriate for the player's class and spec (returns false on shirts)
EquipRecommendedGear:IsItemEquippable(itemLink)

-- Returns if an item is appropriate, and an item level upgrade
EquipRecommendedGear:IsItemUpgrade(itemLink)
