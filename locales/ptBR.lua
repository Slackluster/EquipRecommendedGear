--------------------------------------
-- Equip Recommended Gear: ptBR.lua --
--------------------------------------
-- Portuguese (Brazil) localisation
-- Translator(s):

if GetLocale() ~= "ptBR" then return end
local appName, app = ...
local L = app.locales

-- Core
-- L.NEW_VERSION_AVAILABLE =                "There is a newer version of %s available:" -- %s becomes the addon name

-- L.DEBUG_ENABLED =                        "Debug mode enabled"
-- L.DEBUG_DISABLED =                       "Debug mode disabled"
-- L.INVALID_COMMAND =                      "Invalid command"

-- Settings
-- L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
-- L.SUPPORT_TEXTLONG1 =                    "Developing this addon takes a significant amount of time and effort."
-- L.SUPPORT_TEXTLONG2 =                    "Please consider financially supporting the developer."
-- L.SUPPORT =                              "Support"
-- L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
-- L.THANK_YOU =                            "Thank you!"
-- L.FEEDBACK_AND_HELP =                    "Feedback & Help"
-- L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
-- L.JOIN_DISCORD_SERVER =                  "Join the Discord server."
-- L.CTRL_C_COPY =                          "Ctrl+C to copy:"
-- L.LINK_COPIED =                          "Link copied to clipboard"

-- L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Slash Commands" -- "Keybindings"
-- _G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equip Recommended Gear" -- Not the addon name, but the action
-- L.DO_THE_THING =                         "Equip recommended gear" -- Not the addon name, but the action
-- L.OPEN_SETTINGS =                        "Open the settings"

-- L.GENERAL =                              GENERAL -- "General"
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
