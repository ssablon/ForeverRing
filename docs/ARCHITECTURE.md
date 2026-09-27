# Architecture — Forever Ring

Client camelot `16001`. `Ring.lua` démarre tout seul (événements comme CursorRing), sans dépendre de Core. Texture = `Interface\\AddOns\\CursorRing\\ring.tga` (fichier déjà validé). Le frame est d'abord ancré au centre de l'écran, puis l'`OnUpdate` CursorRing le colle à la souris. Si l'OnUpdate plante, l'anneau reste visible au centre. `enabled` est forcé à true au chargement.

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
