--------------------------------------
-- Equip Recommended Gear: zhTW.lua --
--------------------------------------
-- Chinese (Traditional, Taiwan) localisation
-- Translator(s):

if GetLocale() ~= "zhTW" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s 有新版本可用：" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "除錯模式已啟用"
L.DEBUG_DISABLED =                       "除錯模式已停用"
L.INVALID_COMMAND =                      "指令無效"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "開發這個插件需要投入大量的時間與心力。"
L.SUPPORT_TEXTLONG2 =                    "歡迎考慮以金錢支持開發者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "謝謝！"
L.FEEDBACK_AND_HELP =                    "意見回饋與協助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入 Discord 伺服器。"
L.CTRL_C_COPY =                          "按 Ctrl+C 複製："
L.LINK_COPIED =                          "連結已複製到剪貼簿"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜線指令" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": 裝備推薦裝備" -- Not the addon name, but the action
L.DO_THE_THING =                         "裝備推薦裝備" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "開啟設定"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "完成任務時執行"
L.RUN_AFTER_QUEST_DESC =                 "每次完成任務時執行 %s。" -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "升級時執行"
L.RUN_AFTER_LEVELUP_DESC =               "每次升級時執行 %s。" -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "切換專精時執行"
L.RUN_AFTER_SPECSWITCH_DESC =            "每次切換專精時執行 %s。" -- %s becomes the addon name
L.MESSAGE_NEVER =                        "永不傳送訊息"
L.MESSAGE_NEVER_DESC =                   "即使 %s 裝備了物品等級更高的裝備，也不傳送聊天訊息。" -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "僅裝備提升時"
L.MESSAGE_UPGRADE_DESC =                 "僅當 %s 裝備了物品等級更高的裝備時才傳送聊天訊息。" -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "一律傳送訊息"
L.MESSAGE_ALWAYS_DESC =                  "即使 %s 沒有裝備物品等級更高的裝備，也一律傳送聊天訊息。" -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "包含武器"
L.INCLUDE_WEAPONS_DESC =                 "執行此操作時包含武器。"

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "戰鬥中無法推薦裝備"
L.ERROR_INVENTORY =                      "無法讀取背包中的物品"
L.ERROR_EQUIPPED =                       "無法讀取已裝備的物品"
L.ERROR_EQUIP =                          "無法裝備推薦裝備"
L.EQUIP_NO_UPGRADE =                     "你目前已為 %s 裝備推薦裝備" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "已為 %s 裝備推薦裝備" -- %s becomes "Spec Class"
