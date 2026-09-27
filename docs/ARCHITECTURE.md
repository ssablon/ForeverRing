# Architecture — Forever Ring

Client camelot `16001`. Le suivi curseur est une copie de CursorRing : frame sur `UIParent`, strata `TOOLTIP`, `SetIgnoreParentScale(false)`, `OnUpdate` = `GetCursorPosition() / GetEffectiveScale() - GetRect()`, `SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)`. Texture `ring.tga` avec `SetTexture(path, "CLAMP")`. Pas de `pcall` sur ce suivi. Anneau de portée = `thin_ring.tga` en BACKGROUND, plus grand. Couleur de classe ou manuelle.

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
