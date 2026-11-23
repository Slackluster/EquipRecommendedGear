--------------------------------------
-- Equip Recommended Gear: koKR.lua --
--------------------------------------
-- Korean (Korea) localisation
-- Translator(s):

if GetLocale() ~= "koKR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s의 새 버전이 출시되었습니다:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "디버그 모드 활성화"
L.DEBUG_DISABLED =                       "디버그 모드 비활성화"
L.INVALID_COMMAND =                      "잘못된 명령어"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "이 애드온을 개발하는 데에는 많은 시간과 노력이 필요합니다."
L.SUPPORT_TEXTLONG2 =                    "개발자를 금전적으로 후원하는 것을 고려해 주세요."
L.SUPPORT =                              "후원"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "감사합니다!"
L.FEEDBACK_AND_HELP =                    "피드백 및 도움말"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord 서버에 참여하세요."
L.CTRL_C_COPY =                          "Ctrl+C를 눌러 복사:"
L.LINK_COPIED =                          "링크를 클립보드에 복사했습니다"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " 및 슬래시 명령어" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": 추천 장비 착용" -- Not the addon name, but the action
L.DO_THE_THING =                         "추천 장비 착용" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "설정 열기"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "퀘스트 완료 시 실행"
L.RUN_AFTER_QUEST_DESC =                 "퀘스트를 완료할 때마다 %s을(를) 실행합니다." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "레벨 상승 시 실행"
L.RUN_AFTER_LEVELUP_DESC =               "레벨이 오를 때마다 %s을(를) 실행합니다." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "전문화 변경 시 실행"
L.RUN_AFTER_SPECSWITCH_DESC =            "전문화가 바뀔 때마다 %s을(를) 실행합니다." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "메시지 보내지 않기"
L.MESSAGE_NEVER_DESC =                   "%s이(가) 아이템 레벨이 더 높은 장비를 착용했더라도 채팅 메시지를 보내지 않습니다." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "장비 향상 시에만"
L.MESSAGE_UPGRADE_DESC =                 "%s이(가) 아이템 레벨이 더 높은 장비를 착용한 경우에만 채팅 메시지를 보냅니다." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "항상 메시지 보내기"
L.MESSAGE_ALWAYS_DESC =                  "%s이(가) 아이템 레벨이 더 높은 장비를 착용하지 않았더라도 항상 채팅 메시지를 보냅니다." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "무기 포함"
L.INCLUDE_WEAPONS_DESC =                 "이 작업을 할 때 무기를 포함합니다."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "전투 중에는 장비를 추천할 수 없습니다"
L.ERROR_INVENTORY =                      "가방의 아이템 정보를 읽을 수 없습니다"
L.ERROR_EQUIPPED =                       "착용 중인 아이템 정보를 읽을 수 없습니다"
L.ERROR_EQUIP =                          "추천 장비를 착용할 수 없습니다"
L.EQUIP_NO_UPGRADE =                     "%s에 권장되는 장비를 이미 착용하고 있습니다" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "%s의 추천 장비를 착용했습니다" -- %s becomes "Spec Class"
