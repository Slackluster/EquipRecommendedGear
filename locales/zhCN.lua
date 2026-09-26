--------------------------------------
-- Equip Recommended Gear: zhCN.lua --
--------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s): cikichen

if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s 有新版本可用：" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "调试模式已启用"
L.DEBUG_DISABLED =                       "调试模式已禁用"
L.INVALID_COMMAND =                      "无效指令"

-- Settings
L.SETTINGS_VERSION =                     GAME_VERSION_LABEL .. ":" -- "Version"
L.SETTINGS_SUPPORT_TEXTLONG1 =           "开发这个插件需要大量的时间和精力。"
L.SETTINGS_SUPPORT_TEXTLONG2 =           "请考虑在经济上支持开发者。"
L.SETTINGS_SUPPORT_TEXT =                "支持"
L.SETTINGS_SUPPORT_BUTTON =              "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =                "谢谢！"
L.SETTINGS_HELP_TEXT =                   "反馈与帮助"
L.SETTINGS_HELP_BUTTON =                 "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =                   "加入 Discord 服务器。"
L.SETTINGS_URL_COPY =                    "按 Ctrl+C 复制："
L.SETTINGS_URL_COPIED =                  "链接已复制到剪贴板"

L.SETTINGS_KEYSLASH_TITLE =              SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令" -- "Keybindings"
-- _G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equip Recommended Gear" -- Not the addon name, but the action
-- L.SLASH_DO_THE_THING =                   "Equip recommended gear" -- Not the addon name, but the action
L.SLASH_OPEN_SETTINGS =                  "打开设置"

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
