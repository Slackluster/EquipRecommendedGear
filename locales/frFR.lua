--------------------------------------
-- Equip Recommended Gear: frFR.lua --
--------------------------------------
-- French (France) localisation
-- Translator(s): Klep-Ysondre

if GetLocale() ~= "frFR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Une nouvelle version de %s est disponible :" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Mode débogage activé"
L.DEBUG_DISABLED =                       "Mode débogage désactivé"
L.INVALID_COMMAND =                      "Commande non valide"

-- Settings
L.SETTINGS_VERSION =                     GAME_VERSION_LABEL .. ":"    -- "Version"
L.SETTINGS_SUPPORT_TEXTLONG1 =           "Le développement de cette extension demande beaucoup de temps et d’efforts."
L.SETTINGS_SUPPORT_TEXTLONG2 =           "Veuillez envisager de soutenir financièrement le développeur."
L.SETTINGS_SUPPORT_TEXT =                "Soutien"
L.SETTINGS_SUPPORT_BUTTON =              "Buy Me a Coffee"    -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =                "Merci !"
L.SETTINGS_HELP_TEXT =                   "Commentaires et aide"
L.SETTINGS_HELP_BUTTON =                 "Discord"    -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =                   "Rejoignez le serveur Discord."
L.SETTINGS_URL_COPY =                    "Ctrl + C pour copier :"
L.SETTINGS_URL_COPIED =                  "Lien copié dans le presse-papiers"

L.SETTINGS_KEYSLASH_TITLE =              SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »"    -- "Keybindings"
-- _G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equip Recommended Gear" -- This time it's not the addon name, but the keybind action, so may be translated
L.SLASH_OPEN_SETTINGS =                  "Ouvrir les paramètres"

L.GENERAL =                              GENERAL -- "General"
-- L.RUN_AFTER_QUEST =                      "Run on Quest Completion"
-- L.RUN_AFTER_QUEST_DESC =                 "Run %s whenever you complete a quest." -- %s becomes the addon name
-- L.RUN_AFTER_LEVELUP =                    "Run on Level Up"
-- L.RUN_AFTER_LEVELUP_DESC =               "Run %s whenever you level up." -- %s becomes the addon name
-- L.RUN_AFTER_SPECSWITCH =                 "Run on Spec Switch"
-- L.RUN_AFTER_SPECSWITCH_DESC =            "Run %s whenever you switch specs." -- %s becomes the addon name
-- L.MESSAGE_NEVER =                        "Never Send Message"
-- L.MESSAGE_NEVER_DESC =                   "Don't send a message in chat, even if %s has equipped an item level upgrade." -- %s becomes the addon name
-- L.MESSAGE_UPGRADE =                      "Only With Upgrade"
-- L.MESSAGE_UPGRADE_DESC =                 "Only send a message in chat if %s has equipped an item level upgrade." -- %s becomes the addon name
-- L.MESSAGE_ALWAYS =                       "Always Send Message"
-- L.MESSAGE_ALWAYS_DESC =                  "Always send a chat message, even if %s hasn't equipped an item level upgrade." -- %s becomes the addon name
-- L.INCLUDE_WEAPONS =                      "Include Weapons"
-- L.INCLUDE_WEAPONS_DESC =                 "Include weapons when doing the thing."

-- Equip Recommended Gear
-- L.ERROR_COMBAT =                         "Cannot recommend gear while in combat"
-- L.ERROR_INVENTORY =                      "Could not read items in inventory"
-- L.ERROR_EQUIPPED =                       "Could not read equipped items"
-- L.ERROR_EQUIP =                          "Could not equip recommended gear"
-- L.EQUIP_NO_UPGRADE =                     "You are currently equipped with the recommended gear for %s" -- %s becomes "Spec Class"
-- L.EQUIP_UPGRADE =                        "Equipped gear recommended for %s" -- %s becomes "Spec Class"
