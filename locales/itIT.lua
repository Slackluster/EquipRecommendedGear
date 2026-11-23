--------------------------------------
-- Equip Recommended Gear: itIT.lua --
--------------------------------------
-- Italian (Italy) localisation
-- Translator(s):

if GetLocale() ~= "itIT" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "È disponibile una nuova versione di %s:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Modalità debug attivata"
L.DEBUG_DISABLED =                       "Modalità debug disattivata"
L.INVALID_COMMAND =                      "Comando non valido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Lo sviluppo di questo addon richiede molto tempo e impegno."
L.SUPPORT_TEXTLONG2 =                    "Ti invitiamo a sostenere economicamente lo sviluppatore."
L.SUPPORT =                              "Supporto"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Grazie!"
L.FEEDBACK_AND_HELP =                    "Feedback e aiuto"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entra nel server Discord."
L.CTRL_C_COPY =                          "Ctrl+C per copiare:"
L.LINK_COPIED =                          "Collegamento copiato negli appunti"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandi slash" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equipaggia l'equipaggiamento consigliato" -- Not the addon name, but the action
L.DO_THE_THING =                         "Equipaggia l'equipaggiamento consigliato" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Apri le impostazioni"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Esegui al completamento missione"
L.RUN_AFTER_QUEST_DESC =                 "Esegui %s ogni volta che completi una missione." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Esegui al passaggio di livello"
L.RUN_AFTER_LEVELUP_DESC =               "Esegui %s ogni volta che sali di livello." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Esegui al cambio specializzazione"
L.RUN_AFTER_SPECSWITCH_DESC =            "Esegui %s ogni volta che cambi specializzazione." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "Non inviare mai il messaggio"
L.MESSAGE_NEVER_DESC =                   "Non inviare un messaggio in chat, anche se %s ha equipaggiato un oggetto di livello superiore." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Solo con miglioramento"
L.MESSAGE_UPGRADE_DESC =                 "Invia un messaggio in chat solo se %s ha equipaggiato un oggetto di livello superiore." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Invia sempre il messaggio"
L.MESSAGE_ALWAYS_DESC =                  "Invia sempre un messaggio in chat, anche se %s non ha equipaggiato un oggetto di livello superiore." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Includi armi"
L.INCLUDE_WEAPONS_DESC =                 "Includi le armi quando esegui l'azione."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "Impossibile consigliare equipaggiamento durante il combattimento"
L.ERROR_INVENTORY =                      "Impossibile leggere gli oggetti nell'inventario"
L.ERROR_EQUIPPED =                       "Impossibile leggere gli oggetti equipaggiati"
L.ERROR_EQUIP =                          "Impossibile equipaggiare l'equipaggiamento consigliato"
L.EQUIP_NO_UPGRADE =                     "Stai già indossando l'equipaggiamento consigliato per %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Equipaggiamento consigliato per %s equipaggiato" -- %s becomes "Spec Class"
