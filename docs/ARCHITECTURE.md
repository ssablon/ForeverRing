# Architecture — Forever Mouse Ring-Range

Client camelot `16001`. `Ring.lua` démarre tout seul via un frame `drive` (l'anneau peut se cacher sans perdre le suivi). Textures : `ring.tga` (classe), `thin_ring.tga` (portée). Cadres centrés. Yards **au-dessus**. Incantation = 48 segments, ticker seulement pendant le cast, rouge si interrompu. Portée : `rangeSource` auto (mouseover → focus → cible). `enabled`, combat, menus UI, opacité. Textes joueur : anglais par défaut, `ns.db.locale` = `auto` (GetLocale) ou un pack (frFR, deDE, …).

Ticker 0,25 s pour la portée. `OnUpdate` sur le drive : curseur + masquage UI.

Options : fenêtre custom (cartes + interrupteurs). Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
