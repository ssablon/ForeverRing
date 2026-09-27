# Architecture — Forever Ring

Client camelot `16001`. `Ring.lua` démarre tout seul. Texture curseur `CursorRing\\ring.tga`. Anneau de portée `thin_ring.tga` **à l'intérieur** (taille = ringSize - rangeGap). Yards **au-dessus** de l'anneau. Incantation = 48 segments (delta SetVertexColor), ticker 50 ms **seulement pendant le cast**. OnUpdate curseur saute si la position n'a pas changé. Portée : pas de redraw si texte/couleur identiques.

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
