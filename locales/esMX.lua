--------------------------------------
-- Equip Recommended Gear: esMX.lua --
--------------------------------------
-- Spanish (Mexico) localisation
-- Translator(s): Ferran Carril

-- Initialisation
if GetLocale() ~= "esMX" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
-- L.DEBUG_ENABLED =						"Debug mode enabled."
-- L.DEBUG_DISABLED =						"Debug mode disabled."
L.INVALID_COMMAND =						"Comando no válido."

-- Version comms
L.NEW_VERSION_AVAILABLE =				"Hay una versión más nueva de " .. app.NameLong .. " disponible:"

-- Equip Recommended Gear
-- L.TRY_AGAIN =							"Please try again in a few seconds."
-- L.ERROR_COMBAT =						"Cannot recommend gear while in combat."
-- L.ERROR_INVENTORY =						"Could not read items in inventory." .. " " .. L.TRY_AGAIN
-- L.ERROR_EQUIPPED =						"Could not read equipped items." .. " " .. L.TRY_AGAIN
-- L.ERROR_EQUIP =							"Could not equip recommended gear." .. " " .. L.TRY_AGAIN
-- L.EQUIP_NO_UPDGRADE =					"You are currently equipped with the recommended gear for"	-- Followed by " Spec Class."
-- L.EQUIP_UPDGRADE =						"Equipped gear recommended for"	-- Followed by " Spec Class."

-- Settings
L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. ":"	-- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =			"Desarrollar este addon requiere una cantidad significativa de tiempo y esfuerzo.\nPor favor, considera apoyar financieramente al desarrollador."
L.SETTINGS_SUPPORT_TEXT =				"Apoyar"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"¡Gracias!"
L.SETTINGS_HELP_TEXT =					"Comentarios y Ayuda"
L.SETTINGS_HELP_BUTTON =				"Discord"	-- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"Únete al servidor de Discord."
L.SETTINGS_URL_COPY =					"Ctrl+C para copiar:"
L.SETTINGS_URL_COPIED =					"Enlace copiado al portapapeles"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " y Comandos"	-- "Keybindings"
-- _G["BINDING_NAME_ERG_DOTHETHING"] =		app.NameShort .. ": Equip Recommended Gear"	-- This time it's not the addon name, but the keybind action, so may be translated
L.SETTINGS_SLASH_SETTINGS =				"Abrir opciones"
-- L.SETTINGS_SLASH_DEBUG =				"Toggle debug mode"

L.GENERAL =								GENERAL	-- "General"
-- L.RUN_AFTER_QUEST =						"Run on Quest Completion"
-- L.RUN_AFTER_QUEST_DESC =				"Run " .. app.NameShort .. " whenever you complete a quest."
-- L.CHAT_MESSAGE =						"Send Chat Message"
-- L.CHAT_MESSAGE_DESC =					"These settings only affect the chat message sent after quest completion."
-- L.MESSAGE_NEVER =						"Never Send Message"
-- L.MESSAGE_NEVER_DESC =					"Don't send a message in chat, even if " .. app.NameShort .. " has equipped an item level upgrade."
-- L.MESSAGE_UPGRADE =						"Only With Upgrade"
-- L.MESSAGE_UPGRADE_DESC =				"Only send a message in chat if " .. app.NameShort .. " has equipped an item level upgrade."
-- L.MESSAGE_ALWAYS =						"Always Send Message"
-- L.MESSAGE_ALWAYS_DESC =					"Always send a chat message, even if " .. app.NameShort .. " hasn't equipped an item level upgrade."
-- L.SETTINGS_INCLUDEWEAPONS_TITLE	=		"Include Weapons"
-- L.SETTINGS_INCLUDEWEAPONS_TOOLTIP =		"Include weapons when doing the thing.\nThis is a character-specific setting."
