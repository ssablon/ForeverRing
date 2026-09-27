local addonName, ns = ...

local L = {}

L.enUS = {
	TITLE = "Forever Ring",
	TITLE_SUB = "(Cursor + range)",
	INIT = "Loaded. /fring options",
	OPTIONS_TITLE = "Forever Ring — Options",
	SWITCH_ON = "ON",
	SWITCH_OFF = "OFF",
	TAB_RING = "Ring",
	TAB_RANGE = "Range",
	TAB_INFO = "Info",
	OPT_NAV_TITLE = "Forever Ring Options",
	OPT_CARD_CURSOR = "Cursor ring",
	OPT_CARD_CAST = "Cast",
	OPT_CARD_RANGE = "Target range",
	OPT_CARD_ABOUT = "About",
	OPT_CARD_COMMANDS = "Commands",
	OPT_ENABLE_RING = "Show cursor ring",
	OPT_ENABLE_CAST = "Show cast on the ring",
	OPT_ENABLE_RANGE = "Show range around the ring",
	OPT_RANGE_TEXT = "Show yard numbers",
	OPT_ONLY_COMBAT = "Only in combat",
	OPT_ONLY_ENEMY = "Only hostile targets",
	OPT_OUT_OF_COMBAT = "Show out of combat",
	OPT_RING_SIZE = "Ring size: %d",
	OPT_RANGE_GAP = "Range ring gap: %d",
	OPT_CLASS_COLOR = "Use class color",
	INFO_ABOUT = "Forever Ring draws a ring on the mouse and a second circle around it for target distance. It never casts.",
	INFO_CREDIT = "Created by Vohnka",
	INFO_CMD_LIST = "/fring — help\n/fring options — this window\n/fring toggle — show or hide",
	HELP = "/fring options | toggle",
	LOCKED = "On.",
	UNLOCKED = "Off.",
	MINIMAP_L = "Left-click: options",
	MINIMAP_R = "Right-click: show or hide the rings. Drag to move.",
	OPT_MINIMAP = "Show minimap button",
}

L.frFR = {
	TITLE = "Forever Ring",
	TITLE_SUB = "(Curseur + portée)",
	INIT = "Chargé. /fring options",
	OPTIONS_TITLE = "Forever Ring — Options",
	SWITCH_ON = "ON",
	SWITCH_OFF = "OFF",
	TAB_RING = "Anneau",
	TAB_RANGE = "Portée",
	TAB_INFO = "Info",
	OPT_NAV_TITLE = "Options Forever Ring",
	OPT_CARD_CURSOR = "Anneau du curseur",
	OPT_CARD_CAST = "Incantation",
	OPT_CARD_RANGE = "Portée de la cible",
	OPT_CARD_ABOUT = "À propos",
	OPT_CARD_COMMANDS = "Commandes",
	OPT_ENABLE_RING = "Afficher l'anneau du curseur",
	OPT_ENABLE_CAST = "Afficher l'incantation sur l'anneau",
	OPT_ENABLE_RANGE = "Afficher la portée autour de l'anneau",
	OPT_RANGE_TEXT = "Afficher les yards",
	OPT_ONLY_COMBAT = "Seulement en combat",
	OPT_ONLY_ENEMY = "Seulement les cibles hostiles",
	OPT_OUT_OF_COMBAT = "Afficher hors combat",
	OPT_RING_SIZE = "Taille de l'anneau : %d",
	OPT_RANGE_GAP = "Écart de l'anneau de portée : %d",
	OPT_CLASS_COLOR = "Couleur de classe",
	INFO_ABOUT = "Forever Ring dessine un anneau sur la souris et un second cercle autour pour la distance de la cible. Il ne lance aucun sort.",
	INFO_CREDIT = "Créé par Vohnka",
	INFO_CMD_LIST = "/fring — aide\n/fring options — cette fenêtre\n/fring toggle — afficher ou cacher",
	HELP = "/fring options | toggle",
	LOCKED = "Activé.",
	UNLOCKED = "Désactivé.",
	MINIMAP_L = "Clic gauche : options",
	MINIMAP_R = "Clic droit : afficher ou cacher les anneaux. Glisser pour déplacer.",
	OPT_MINIMAP = "Bouton de la minimap",
}

local packs = { enUS = L.enUS, frFR = L.frFR }
L.deDE, L.esES, L.esMX, L.ruRU, L.zhCN, L.zhTW, L.ptBR, L.itIT, L.koKR = L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS
packs.deDE, packs.esES, packs.esMX, packs.ruRU, packs.zhCN, packs.zhTW, packs.ptBR, packs.itIT, packs.koKR =
	L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS, L.enUS

local function localeCode()
	local loc
	if ns.db and ns.db.locale and ns.db.locale ~= "" then
		loc = ns.db.locale
	else
		local ok, value = pcall(GetLocale)
		loc = ok and value or "enUS"
	end
	if loc == "enGB" then
		loc = "enUS"
	end
	if loc == "esMX" then
		loc = "esES"
	end
	return loc
end

local fallback = setmetatable({}, {
	__index = function(_, key)
		return L.enUS[key] or key
	end,
})

function ns.T(key)
	local pack = packs[localeCode()] or fallback
	return pack[key] or L.enUS[key] or key
end
