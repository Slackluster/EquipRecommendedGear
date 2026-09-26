--------------------------------------
-- Equip Recommended Gear: ruRU.lua --
--------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Доступна новая версия %s:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Режим отладки включён"
L.DEBUG_DISABLED =                       "Режим отладки отключён"
L.INVALID_COMMAND =                      "Неверная команда"

-- Settings
L.SETTINGS_VERSION =                     GAME_VERSION_LABEL .. ":" -- "Version"
L.SETTINGS_SUPPORT_TEXTLONG1 =           "Разработка этого аддона требует значительного времени и усилий."
L.SETTINGS_SUPPORT_TEXTLONG2 =           "Пожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SETTINGS_SUPPORT_TEXT =                "Поддержать"
L.SETTINGS_SUPPORT_BUTTON =              "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =                "Спасибо!"
L.SETTINGS_HELP_TEXT =                   "Обратная связь и помощь"
L.SETTINGS_HELP_BUTTON =                 "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =                   "Присоединиться к серверу Discord."
L.SETTINGS_URL_COPY =                    "Ctrl+C — скопировать:"
L.SETTINGS_URL_COPIED =                  "Ссылка скопирована в буфер обмена"

L.SETTINGS_KEYSLASH_TITLE =              SETTINGS_KEYBINDINGS_LABEL .. " & Слэш-команды" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Наденьте рекомендованная экипировка" -- This time it's not the addon name, but the keybind action, so may be translated
L.SLASH_OPEN_SETTINGS =                  "Откройте настройки"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Запускать после выполнения задания"
L.RUN_AFTER_QUEST_DESC =                 "Запускать %s каждый раз после выполнения задания." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Запуск при повышении уровня"
L.RUN_AFTER_LEVELUP_DESC =               "Запускать %s каждый раз, когда вы повышаете уровень." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Запуск при смене специализации"
L.RUN_AFTER_SPECSWITCH_DESC =            "Запускать %s каждый раз, когда вы меняете специализацию." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "Никогда не отправлять"
L.MESSAGE_NEVER_DESC =                   "Не отправлять сообщение в чат, даже если %s надел улучшение по уровню предмета." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Только при улучшении"
L.MESSAGE_UPGRADE_DESC =                 "Отправлять сообщение в чат, только если %s надел улучшение по уровню предмета." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Всегда отправлять"
L.MESSAGE_ALWAYS_DESC =                  "Всегда отправлять сообщение в чат, даже если %s не надел улучшение." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Учитывать оружие"
L.INCLUDE_WEAPONS_DESC =                 "Учитывать оружие при рекомендациях."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "Нельзя рекомендовать экипировку во время боя"
L.ERROR_INVENTORY =                      "Не удалось прочитать предметы в сумках"
L.ERROR_EQUIPPED =                       "Не удалось прочитать надетые предметы"
L.ERROR_EQUIP =                          "Не удалось надеть рекомендованную экипировку"
L.EQUIP_NO_UPGRADE =                     "У вас уже надета рекомендованная экипировка для %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Надета рекомендованная экипировка для %s" -- %s becomes "Spec Class"
