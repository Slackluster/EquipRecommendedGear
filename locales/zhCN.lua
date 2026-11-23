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
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "开发这个插件需要大量的时间和精力。"
L.SUPPORT_TEXTLONG2 =                    "请考虑在经济上支持开发者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "谢谢！"
L.FEEDBACK_AND_HELP =                    "反馈与帮助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入 Discord 服务器。"
L.CTRL_C_COPY =                          "按 Ctrl+C 复制："
L.LINK_COPIED =                          "链接已复制到剪贴板"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": 装备推荐装备" -- Not the addon name, but the action
L.DO_THE_THING =                         "装备推荐装备" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "打开设置"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "完成任务时运行"
L.RUN_AFTER_QUEST_DESC =                 "每次完成任务时运行 %s。" -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "升级时运行"
L.RUN_AFTER_LEVELUP_DESC =               "每次升级时运行 %s。" -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "切换专精时运行"
L.RUN_AFTER_SPECSWITCH_DESC =            "每次切换专精时运行 %s。" -- %s becomes the addon name
L.MESSAGE_NEVER =                        "永不发送消息"
L.MESSAGE_NEVER_DESC =                   "即使 %s 装备了更高物品等级的装备，也不发送聊天消息。" -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "仅装备提升时"
L.MESSAGE_UPGRADE_DESC =                 "仅当 %s 装备了更高物品等级的装备时发送聊天消息。" -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "始终发送消息"
L.MESSAGE_ALWAYS_DESC =                  "即使 %s 没有装备更高物品等级的装备，也始终发送聊天消息。" -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "包含武器"
L.INCLUDE_WEAPONS_DESC =                 "执行此操作时包含武器。"

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "战斗中无法推荐装备"
L.ERROR_INVENTORY =                      "无法读取背包中的物品"
L.ERROR_EQUIPPED =                       "无法读取已装备物品"
L.ERROR_EQUIP =                          "无法装备推荐的装备"
L.EQUIP_NO_UPGRADE =                     "你当前已为 %s 装备推荐装备" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "已为 %s 装备推荐装备" -- %s becomes "Spec Class"
