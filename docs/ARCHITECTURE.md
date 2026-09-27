# Architecture — Forever Ring

Client camelot `16001`. Un frame `TOOLTIP` suit le curseur comme CursorRing : `GetCursorPosition` / `UIParent:GetEffectiveScale` moins `UIParent:GetRect`, sans filtrer les secret values. Texture `ring.tga` + `CLAMP` à la racine de l'addon (copie aussi dans `images\`). Couleur de classe par défaut (`RAID_CLASS_COLORS`), ou couleur manuelle dans les options. Un anneau extérieur (`thin_ring.tga`) change selon la distance de la cible.

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard. Onglets **Ring** et **Info**. Les crédits sont toujours dans Info (About or + commandes + liens), jamais dans une carte de réglages.

Textes : `ns.T` + `ns.db.locale`. Défaut `auto` = `GetLocale()` (enGB → enUS). Bouton Language dans les options (cycle Auto + 10 packs). Packs : enUS, frFR, deDE, esES, esMX, ruRU, zhCN, zhTW, ptBR, itIT, koKR. Clé absente → anglais.
