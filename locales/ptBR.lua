--------------------------------------
-- Equip Recommended Gear: ptBR.lua --
--------------------------------------
-- Portuguese (Brazil) localisation
-- Translator(s):

if GetLocale() ~= "ptBR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Há uma versão mais recente de %s disponível:" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Modo de depuração ativado"
L.DEBUG_DISABLED =                       "Modo de depuração desativado"
L.INVALID_COMMAND =                      "Comando inválido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desenvolver este addon exige muito tempo e dedicação."
L.SUPPORT_TEXTLONG2 =                    "Considere apoiar financeiramente o desenvolvedor."
L.SUPPORT =                              "Apoiar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Obrigado!"
L.FEEDBACK_AND_HELP =                    "Comentários e Ajuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entre no servidor do Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Link copiado para a área de transferência"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandos de barra" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Equipar equipamento recomendado" -- Not the addon name, but the action
L.DO_THE_THING =                         "Equipar equipamento recomendado" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Abrir as configurações"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Executar ao concluir missão"
L.RUN_AFTER_QUEST_DESC =                 "Executar %s sempre que você concluir uma missão." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Executar ao subir de nível"
L.RUN_AFTER_LEVELUP_DESC =               "Executar %s sempre que você subir de nível." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Executar ao trocar de especialização"
L.RUN_AFTER_SPECSWITCH_DESC =            "Executar %s sempre que você trocar de especialização." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "Nunca enviar mensagem"
L.MESSAGE_NEVER_DESC =                   "Não enviar mensagem no chat, mesmo que %s tenha equipado um item de nível superior." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Somente com melhoria"
L.MESSAGE_UPGRADE_DESC =                 "Enviar mensagem no chat somente se %s tiver equipado um item de nível superior." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Sempre enviar mensagem"
L.MESSAGE_ALWAYS_DESC =                  "Sempre enviar uma mensagem no chat, mesmo que %s não tenha equipado um item de nível superior." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Incluir armas"
L.INCLUDE_WEAPONS_DESC =                 "Incluir armas ao executar a ação."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "Não é possível recomendar equipamentos durante o combate"
L.ERROR_INVENTORY =                      "Não foi possível ler os itens do inventário"
L.ERROR_EQUIPPED =                       "Não foi possível ler os itens equipados"
L.ERROR_EQUIP =                          "Não foi possível equipar o equipamento recomendado"
L.EQUIP_NO_UPGRADE =                     "Você já está equipado com o equipamento recomendado para %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Equipamento recomendado para %s equipado" -- %s becomes "Spec Class"
