--------------------------------------
-- Equip Recommended Gear: deDE.lua --
--------------------------------------
-- German (Germany) localisation
-- Translator(s):

if GetLocale() ~= "deDE" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Eine neuere Version von %s ist verfügbar:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Debugmodus aktiviert"
L.DEBUG_DISABLED =                       "Debugmodus deaktiviert"
L.INVALID_COMMAND =                      "Ungültiger Befehl"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Die Entwicklung dieses Addons erfordert viel Zeit und Mühe."
L.SUPPORT_TEXTLONG2 =                    "Bitte erwäge, die Entwicklung finanziell zu unterstützen."
L.SUPPORT =                              "Unterstützen"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Vielen Dank!"
L.FEEDBACK_AND_HELP =                    "Feedback und Hilfe"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord-Server beitreten."
L.CTRL_C_COPY =                          "Strg+C zum Kopieren:"
L.LINK_COPIED =                          "Link in die Zwischenablage kopiert"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Slash-Befehle" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Empfohlene Ausrüstung anlegen" -- Not the addon name, but the action
L.DO_THE_THING =                         "Empfohlene Ausrüstung anlegen" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Einstellungen öffnen"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Bei Questabschluss ausführen"
L.RUN_AFTER_QUEST_DESC =                 "Führe %s jedes Mal aus, wenn du eine Quest abschließt." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Bei Stufenaufstieg ausführen"
L.RUN_AFTER_LEVELUP_DESC =               "Führe %s jedes Mal aus, wenn du aufsteigst." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Bei Spezialisierungswechsel ausführen"
L.RUN_AFTER_SPECSWITCH_DESC =            "Führe %s jedes Mal aus, wenn du die Spezialisierung wechselst." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "Nie Nachricht senden"
L.MESSAGE_NEVER_DESC =                   "Keine Chatnachricht senden, selbst wenn %s ein Gegenstandsstufen-Upgrade angelegt hat." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Nur bei Upgrade"
L.MESSAGE_UPGRADE_DESC =                 "Nur dann eine Chatnachricht senden, wenn %s ein Gegenstandsstufen-Upgrade angelegt hat." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Nachricht immer senden"
L.MESSAGE_ALWAYS_DESC =                  "Immer eine Chatnachricht senden, auch wenn %s kein Gegenstandsstufen-Upgrade angelegt hat." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Waffen berücksichtigen"
L.INCLUDE_WEAPONS_DESC =                 "Waffen bei der Aktion berücksichtigen."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "Während des Kampfes kann keine Ausrüstung empfohlen werden"
L.ERROR_INVENTORY =                      "Gegenstände im Inventar konnten nicht gelesen werden"
L.ERROR_EQUIPPED =                       "Angelegte Gegenstände konnten nicht gelesen werden"
L.ERROR_EQUIP =                          "Empfohlene Ausrüstung konnte nicht angelegt werden"
L.EQUIP_NO_UPGRADE =                     "Du trägst derzeit die empfohlene Ausrüstung für %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Empfohlene Ausrüstung für %s angelegt" -- %s becomes "Spec Class"
