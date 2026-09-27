# Architecture — Forever Ring

Client camelot `16001`. `Ring.lua` démarre tout seul. Textures : `Interface\\AddOns\\ForeverRing\\ring.tga`, `thin_ring.tga`, `cast_segment.tga`. Anneau de portée **à l'intérieur**. Yards **au-dessus**. Incantation = 48 segments, ticker seulement pendant le cast. Textes joueur : anglais par défaut, `ns.db.locale` = `auto` (GetLocale) ou un pack (frFR, deDE, …).

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
