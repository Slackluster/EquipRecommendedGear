--------------------------------------
-- Equip Recommended Gear: enUS.lua --
--------------------------------------
-- English (United States) localisation
-- Translator(s): N/A

-- Initialisation
-- if GetLocale() ~= "enUS" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.DEBUG_ENABLED =					"Debug mode enabled."
L.DEBUG_DISABLED =					"Debug mode disabled."
L.INVALID_COMMAND =					"Invalid command."

-- Version comms
L.NEW_VERSION_AVAILABLE =			"There is a newer version of " .. app.NameLong .. " available:"

-- Equip Recommended Gear
L.TRY_AGAIN =						"Please try again in a few seconds."
L.ERROR_COMBAT =					"Cannot recommend gear while in combat."
L.ERROR_INVENTORY =					"Could not read items in inventory." .. " " .. L.TRY_AGAIN
L.ERROR_EQUIPPED =					"Could not read equipped items." .. " " .. L.TRY_AGAIN
L.ERROR_EQUIP =						"Could not equip recommended gear." .. " " .. L.TRY_AGAIN
L.EQUIP_NO_UPDGRADE =				"You are currently equipped with the recommended gear for"	-- Followed by " Spec Class."
L.EQUIP_UPDGRADE =					"Equipped gear recommended for"	-- Followed by " Spec Class."

-- Settings
L.RUN_AFTER_QUEST =					"Run on Quest Completion"
L.RUN_AFTER_QUEST_DESC =			"Run " .. app.NameShort .. " whenever you complete a quest."
L.CHAT_MESSAGE =					"Send Chat Message"
L.CHAT_MESSAGE_DESC =				"These settings only affect the chat message sent after quest completion."
L.MESSAGE_NEVER =					"Never Send Message"
L.MESSAGE_NEVER_DESC =				"Don't send a message in chat, even if " .. app.NameShort .. " has equipped an item level upgrade."
L.MESSAGE_UPGRADE =					"Only With Upgrade"
L.MESSAGE_UPGRADE_DESC =			"Only send a message in chat if " .. app.NameShort .. " has equipped an item level upgrade."
L.MESSAGE_ALWAYS =					"Always Send Message"
L.MESSAGE_ALWAYS_DESC =				"Always send a chat message, even if " .. app.NameShort .. " hasn't equipped an item level upgrade."
L.SETTINGS_INCLUDEWEAPONS_TITLE	=	"Include Weapons"
L.SETTINGS_INCLUDEWEAPONS_TOOLTIP =	"Include weapons when doing the thing.\nThis is a character-specific setting."

-- Keybinds
_G["BINDING_NAME_ERG_DOTHETHING"] =	"Equip Recommended Gear"	-- This time it's not the addon name, but the keybind action, so may be translated
