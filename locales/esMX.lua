--------------------------------------
-- Equip Recommended Gear: esMX.lua --
--------------------------------------
-- Spanish (Mexico) localisation
-- Translator(s): Ferran Carril

if GetLocale() ~= "esMX" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Hay una versión más nueva de %s disponible:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Modo de depuración activado"
L.DEBUG_DISABLED =                       "Modo de depuración desactivado"
L.INVALID_COMMAND =                      "Comando no válido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desarrollar este addon requiere una cantidad significativa de tiempo y esfuerzo."
L.SUPPORT_TEXTLONG2 =                    "Por favor, considera apoyar financieramente al desarrollador."
L.SUPPORT =                              "Apoyar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "¡Gracias!"
L.FEEDBACK_AND_HELP =                    "Comentarios y Ayuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Únete al servidor de Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Enlace copiado al portapapeles"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " y Comandos" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equipar equipo recomendado" -- Not the addon name, but the action
L.DO_THE_THING =                         "Equipar equipo recomendado" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Abrir opciones"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Ejecutar al completar una misión"
L.RUN_AFTER_QUEST_DESC =                 "Ejecutar %s al completar una misión." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Ejecutar al subir de nivel"
L.RUN_AFTER_LEVELUP_DESC =               "Ejecutar %s al subir de nivel." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Ejecutar al cambiar de especialización"
L.RUN_AFTER_SPECSWITCH_DESC =            "Ejecutar %s al cambiar de especialización." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "No enviar nunca el mensaje"
L.MESSAGE_NEVER_DESC =                   "No envía mensajes de chat, aunque %s haya equipado un objeto de mayor nivel." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Solo con mejora"
L.MESSAGE_UPGRADE_DESC =                 "Enviar un mensaje de chat solo si %s ha equipado un objeto de mayor nivel." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Enviar siempre el mensaje"
L.MESSAGE_ALWAYS_DESC =                  "Envía siempre un mensaje de chat, aunque %s no haya equipado un objeto de mayor nivel." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Incluir armas"
L.INCLUDE_WEAPONS_DESC =                 "Incluir armas al realizar la acción."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "No se puede recomendar equipo durante el combate"
L.ERROR_INVENTORY =                      "No se han podido leer los objetos del inventario"
L.ERROR_EQUIPPED =                       "No se han podido leer los objetos equipados"
L.ERROR_EQUIP =                          "No se ha podido equipar el equipo recomendado"
L.EQUIP_NO_UPGRADE =                     "Ya tienes equipado el equipo recomendado para %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Equipo recomendado equipado para %s" -- %s becomes "Spec Class"
