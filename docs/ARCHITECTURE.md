# Architecture — Forever Ring

Client camelot `16001`. Le frame est parenté à `WorldFrame` et collé avec `GetCursorPosition` brut (pixels), sans `GetRect` ni division d'échelle — les secret values camelot cassaient le suivi UIParent. Texture `ring.tga` (CursorRing en secours) + carré `WHITE8x8` visible si le TGA échoue. Couleur de classe ou couleur manuelle. Anneau extérieur + yards pour la cible.

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
