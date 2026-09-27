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
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Le développement de cette extension demande beaucoup de temps et d’efforts."
L.SUPPORT_TEXTLONG2 =                    "Veuillez envisager de soutenir financièrement le développeur."
L.SUPPORT =                              "Soutien"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Merci !"
L.FEEDBACK_AND_HELP =                    "Commentaires et aide"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Rejoignez le serveur Discord."
L.CTRL_C_COPY =                          "Ctrl + C pour copier :"
L.LINK_COPIED =                          "Lien copié dans le presse-papiers"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »" -- "Keybindings"
-- _G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equip Recommended Gear" -- Not the addon name, but the action
-- L.DO_THE_THING =                         "Equip recommended gear" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Ouvrir les paramètres"

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
