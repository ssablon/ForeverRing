# Architecture — Forever Ring

Client camelot `16001`. Un frame `TOOLTIP` suit `GetCursorPosition`. Un anneau intérieur (couleur de classe) marque la souris. Un anneau extérieur change de couleur et de remplissage selon la distance de la cible (`CheckInteractDistance` + quelques `IsSpellInRange`).

Ticker 0,2 s pour la portée et l'incantation. `OnUpdate` seulement pour coller le curseur.

Options : fenêtre custom (cartes + interrupteurs), même chrome que Forever Rotation. Pas le panneau Settings Blizzard.
