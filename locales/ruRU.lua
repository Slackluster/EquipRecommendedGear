--------------------------------------
-- Equip Recommended Gear: ruRU.lua --
--------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

-- Initialisation
if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Slash commands
L.DEBUG_ENABLED =						"Режим отладки включён."
L.DEBUG_DISABLED =						"Режим отладки отключён."
L.INVALID_COMMAND =						"Неверная команда."

-- Version comms
L.NEW_VERSION_AVAILABLE =				"Доступна новая версия " .. app.NameLong .. ":"

-- Equip Recommended Gear
L.TRY_AGAIN =							"Пожалуйста, попробуйте снова через несколько секунд."
L.ERROR_COMBAT =						"Нельзя рекомендовать экипировку во время боя."
L.ERROR_INVENTORY =						"Не удалось прочитать предметы в сумках." .. " " .. L.TRY_AGAIN
L.ERROR_EQUIPPED =						"Не удалось прочитать надетые предметы." .. " " .. L.TRY_AGAIN
L.ERROR_EQUIP =							"Не удалось надеть рекомендованную экипировку." .. " " .. L.TRY_AGAIN
L.EQUIP_NO_UPDGRADE =					"У вас уже надета рекомендованная экипировка для"
L.EQUIP_UPGRADE =						"Надета рекомендованная экипировка для"

-- Settings
L.SETTINGS_SUPPORT_TEXTLONG =			"Разработка этого аддона требует значительного времени и усилий.\nПожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SETTINGS_SUPPORT_TEXT =				"Поддержать"
L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =				"Спасибо!"
L.SETTINGS_HELP_TEXT =					"Обратная связь и помощь"
L.SETTINGS_HELP_BUTTON =				"Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =					"Присоединиться к серверу Discord."
L.SETTINGS_ISSUES_TEXT =				"Отслеживание ошибок"
L.SETTINGS_ISSUES_BUTTON =				"GitHub" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_ISSUES_DESC =				"Просмотреть трекер ошибок на GitHub."
L.SETTINGS_URL_COPY =					"Ctrl+C — скопировать:"
L.SETTINGS_URL_COPIED =					"Ссылка скопирована в буфер обмена"

L.RUN_AFTER_QUEST =						"Запускать после выполнения задания"
L.RUN_AFTER_QUEST_DESC =				"Запускать " .. app.NameShort .. " каждый раз после выполнения задания."
L.CHAT_MESSAGE =						"Сообщение в чат"
L.CHAT_MESSAGE_DESC =					"Эти настройки влияют только на сообщение в чат после выполнения задания."
L.MESSAGE_NEVER =						"Никогда не отправлять"
L.MESSAGE_NEVER_DESC =					"Не отправлять сообщение в чат, даже если " .. app.NameShort .. " надел улучшение по уровню предмета."
L.MESSAGE_UPGRADE =						"Только при улучшении"
L.MESSAGE_UPGRADE_DESC =				"Отправлять сообщение в чат, только если " .. app.NameShort .. " надел улучшение по уровню предмета."
L.MESSAGE_ALWAYS =						"Всегда отправлять"
L.MESSAGE_ALWAYS_DESC =					"Всегда отправлять сообщение в чат, даже если " .. app.NameShort .. " не надел улучшение."
L.SETTINGS_INCLUDEWEAPONS_TITLE =		"Учитывать оружие"
L.SETTINGS_INCLUDEWEAPONS_TOOLTIP =		"Учитывать оружие при рекомендациях.\nНастройка для каждого персонажа отдельно."
L.SETTINGS_IGNORELEMIXJEWELRY_TITLE =	"[Remix] Игнорировать украшения"
L.SETTINGS_IGNORELEMIXJEWELRY_TOOLTIP =	"Игнорировать украшения для таймеруннеров Легиона."

-- Keybinds
_G["BINDING_NAME_ERG_DOTHETHING"] =		"Equip Recommended Gear"
