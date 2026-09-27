# Forever Mouse Ring-Range — guide agent

Anneau de curseur pour **WoW Forever** (client camelot, interface `16001`). Nom affiché : **Forever Mouse Ring-Range (Multi language)**. Dossier / SavedVariables restent `ForeverRing`. Un cercle suit la souris. Un anneau de portée plus petit est à l'intérieur. Les yards sont au-dessus. L'incantation remplit l'anneau. L'addon ne lance aucun sort. Textes joueur en anglais par défaut ; Auto = langue du client ; le joueur peut choisir une autre langue (dont le français).

Version actuelle : **1.0.1**. Auteur : Vohnka — https://wow-forever.fr  
Dépôt : https://github.com/ssablon/ForeverRing (privé, branche `main`).

Pas de publication CurseForge tant que l'utilisateur n'a pas validé.

## Source de vérité

Éditer **ce dépôt**. La copie jouée est :

`D:\World of Warcraft\_classic_beta_\Interface\AddOns\ForeverRing`

(sinon le chemin `Program Files (x86)\World of Warcraft\_classic_beta_\Interface\AddOns\ForeverRing`)

## Versioning

Une seule source : première ligne de `VERSION.txt` (`x.y.z`). Recopier dans les **deux** TOC (`## Version`) et `AGENTS.md`. Ajouter le bloc du jour en tête de `curseforge/CHANGELOG.md`.

Ne pas uploader sur CurseForge tant que ce n'est pas demandé.

## Fichiers

`Credits.lua` → `Locale.lua` → `Range.lua` → `Ring.lua` → `Options.lua` → `Core.lua`

État partagé dans `ns` (deuxième valeur de `...`).

| Besoin | Fichier |
| --- | --- |
| Distance cible | `Range.lua` |
| Anneau curseur + anneau de portée | `Ring.lua` (`ring.tga`, `thin_ring.tga`, `cast_segment.tga` à la racine) |
| Fenêtre d'options (style Forever Rotation) | `Options.lua` |
| Crédits, commandes, liens | Onglet Info de `Options.lua` (jamais dans une carte de réglages) |
| Slash, SavedVariables | `Core.lua` |
| Textes (11 langues, `auto` = client, sinon `ns.db.locale`) | `Locale.lua` |

## Pièges camelot

- Protéger chaque appel Blizzard par `pcall`.
- Ne pas appeler `CombatLogGetCurrentEventInfo`.
- Ne pas mesurer la hauteur de texte (`GetStringHeight`).
- Les deux TOC restent identiques.
