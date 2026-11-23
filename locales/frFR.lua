--------------------------------------
-- Equip Recommended Gear: frFR.lua --
--------------------------------------
-- French (France) localisation
-- Translator(s): Klep-Ysondre

if GetLocale() ~= "frFR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Une nouvelle version de %s est disponible :" -- %s becomes the addon name

L.DEBUG_ENABLED =                        "Mode débogage activé"
L.DEBUG_DISABLED =                       "Mode débogage désactivé"
L.INVALID_COMMAND =                      "Commande non valide"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Le développement de cette extension demande beaucoup de temps et d’efforts."
L.SUPPORT_TEXTLONG2 =                    "Veuillez envisager de soutenir financièrement le développeur."
L.SUPPORT =                              "Soutien"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Merci !"
L.FEEDBACK_AND_HELP =                    "Commentaires et aide"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Rejoignez le serveur Discord."
L.CTRL_C_COPY =                          "Ctrl + C pour copier :"
L.LINK_COPIED =                          "Lien copié dans le presse-papiers"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »" -- "Keybindings"
_G["BINDING_NAME_ERG_DOTHETHING"] =      app.NameShort .. ": Équiper l'équipement recommandé" -- Not the addon name, but the action
L.DO_THE_THING =                         "Équiper l'équipement recommandé" -- Not the addon name, but the action
L.OPEN_SETTINGS =                        "Ouvrir les paramètres"

L.GENERAL =                              GENERAL -- "General"
L.RUN_AFTER_QUEST =                      "Exécuter à la fin d'une quête"
L.RUN_AFTER_QUEST_DESC =                 "Exécuter %s à chaque quête terminée." -- %s becomes the addon name
L.RUN_AFTER_LEVELUP =                    "Exécuter à la montée de niveau"
L.RUN_AFTER_LEVELUP_DESC =               "Exécuter %s à chaque montée de niveau." -- %s becomes the addon name
L.RUN_AFTER_SPECSWITCH =                 "Exécuter au changement de spécialisation"
L.RUN_AFTER_SPECSWITCH_DESC =            "Exécuter %s à chaque changement de spécialisation." -- %s becomes the addon name
L.MESSAGE_NEVER =                        "Ne jamais envoyer de message"
L.MESSAGE_NEVER_DESC =                   "Ne pas envoyer de message dans la discussion, même si %s a équipé un objet de niveau supérieur." -- %s becomes the addon name
L.MESSAGE_UPGRADE =                      "Uniquement en cas d'amélioration"
L.MESSAGE_UPGRADE_DESC =                 "Envoyer un message uniquement si %s a équipé un objet de niveau supérieur." -- %s becomes the addon name
L.MESSAGE_ALWAYS =                       "Toujours envoyer un message"
L.MESSAGE_ALWAYS_DESC =                  "Toujours envoyer un message dans la discussion, même si %s n'a pas équipé d'objet de niveau supérieur." -- %s becomes the addon name
L.INCLUDE_WEAPONS =                      "Inclure les armes"
L.INCLUDE_WEAPONS_DESC =                 "Inclure les armes lors de l'exécution de cette action."

-- Equip Recommended Gear
L.ERROR_COMBAT =                         "Impossible de recommander de l'équipement en combat"
L.ERROR_INVENTORY =                      "Impossible de lire les objets de l'inventaire"
L.ERROR_EQUIPPED =                       "Impossible de lire les objets équipés"
L.ERROR_EQUIP =                          "Impossible d'équiper l'équipement recommandé"
L.EQUIP_NO_UPGRADE =                     "Vous portez déjà l'équipement recommandé pour %s" -- %s becomes "Spec Class"
L.EQUIP_UPGRADE =                        "Équipement recommandé équipé pour %s" -- %s becomes "Spec Class"
