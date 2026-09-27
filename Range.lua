local addonName, ns = ...

local CLASS_MAX = {
	WARRIOR = 30,
	PALADIN = 30,
	HUNTER = 35,
	ROGUE = 30,
	PRIEST = 30,
	SHAMAN = 30,
	MAGE = 30,
	WARLOCK = 30,
	DRUID = 30,
}

local COLORS = {
	melee = { 0.05, 0.95, 0.55 },
	close = { 0.45, 1.00, 0.10 },
	mid = { 1.00, 0.82, 0.10 },
	far = { 1.00, 0.50, 0.08 },
	oor = { 1.00, 0.16, 0.16 },
}

local SOURCE_ORDER = { "auto", "target", "mouseover", "focus" }
local SOURCE_KEYS = {
	auto = "OPT_RANGE_AUTO",
	target = "OPT_RANGE_TARGET",
	mouseover = "OPT_RANGE_MOUSEOVER",
	focus = "OPT_RANGE_FOCUS",
}

-- Closest-first. IsSpellInRange nil = unknown, skipped.
local RANGE_SPELLS = {
	{ "Hamstring", 5 },
	{ "Rend", 5 },
	{ "Heroic Strike", 5 },
	{ "Mortal Strike", 5 },
	{ "Sinister Strike", 5 },
	{ "Backstab", 5 },
	{ "Eviscerate", 5 },
	{ "Crusader Strike", 5 },
	{ "Holy Strike", 5 },
	{ "Wing Clip", 5 },
	{ "Mongoose Bite", 5 },
	{ "Raptor Strike", 5 },
	{ "Growl", 5 },
	{ "Maul", 5 },
	{ "Claw", 5 },
	{ "Shred", 5 },
	{ "Mind Flay", 20 },
	{ "Charge", 25 },
	{ "Intercept", 25 },
	{ "Smite", 30 },
	{ "Shadow Word: Pain", 30 },
	{ "Flash Heal", 30 },
	{ "Heal", 30 },
	{ "Holy Light", 30 },
	{ "Flash of Light", 30 },
	{ "Lesser Healing Wave", 30 },
	{ "Healing Wave", 30 },
	{ "Lightning Bolt", 30 },
	{ "Earth Shock", 20 },
	{ "Frostbolt", 30 },
	{ "Fireball", 35 },
	{ "Wrath", 30 },
	{ "Moonfire", 30 },
	{ "Healing Touch", 30 },
	{ "Regrowth", 30 },
	{ "Rejuvenation", 30 },
	{ "Shadow Bolt", 30 },
	{ "Shoot", 30 },
	{ "Auto Shot", 35 },
	{ "Arcane Shot", 35 },
	{ "Serpent Sting", 35 },
}

local function safe(fn, ...)
	if not fn then
		return nil
	end
	local ok, a, b = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b
end

local function unitOk(unit)
	local exists = safe(UnitExists, unit)
	if not exists then
		return false
	end
	if ns.db and ns.db.hideDead and safe(UnitIsDead, unit) then
		return false
	end
	if ns.db and ns.db.onlyEnemy and not safe(UnitCanAttack, "player", unit) then
		return false
	end
	return true
end

local function interact(unit, index)
	return safe(CheckInteractDistance, unit, index) == true
end

local function spellRange(unit, name)
	if C_Spell and C_Spell.IsSpellInRange then
		local r = safe(C_Spell.IsSpellInRange, name, unit)
		if r == true or r == 1 then
			return true
		end
		if r == false or r == 0 then
			return false
		end
	end
	if IsSpellInRange then
		local r = safe(IsSpellInRange, name, unit)
		if r == 1 then
			return true
		end
		if r == 0 then
			return false
		end
	end
	return nil
end

function ns.ClassMaxRange()
	local _, class = safe(UnitClass, "player")
	return CLASS_MAX[class or ""] or 30
end

function ns.RangeColor(yards)
	if ns.db and ns.db.rangeDefaultColor == false then
		local c = ns.db.rangeColor
		if type(c) == "table" then
			return { c[1] or c.r or 0.05, c[2] or c.g or 0.95, c[3] or c.b or 0.55 }
		end
		return COLORS.melee
	end
	local maxR = ns.ClassMaxRange()
	if not yards then
		return COLORS.oor
	end
	if yards <= 5 then
		return COLORS.melee
	end
	if yards <= 8 then
		return COLORS.close
	end
	if yards <= math.max(12, maxR - 15) then
		return COLORS.mid
	end
	if yards <= maxR then
		return COLORS.far
	end
	return COLORS.oor
end

function ns.RangeSource()
	local src = ns.db and ns.db.rangeSource
	if src == "target" or src == "mouseover" or src == "focus" then
		return src
	end
	return "auto"
end

function ns.RangeSourceLabel()
	return ns.T(SOURCE_KEYS[ns.RangeSource()] or "OPT_RANGE_AUTO")
end

function ns.CycleRangeSource()
	if not ns.db then
		return
	end
	local cur = ns.RangeSource()
	local idx = 1
	for i, code in ipairs(SOURCE_ORDER) do
		if code == cur then
			idx = i
			break
		end
	end
	ns.db.rangeSource = SOURCE_ORDER[(idx % #SOURCE_ORDER) + 1]
	if ns.RelocalizeOptions then
		ns.RelocalizeOptions()
	end
	if ns.UpdateRingCombat then
		ns.UpdateRingCombat()
	end
end

function ns.RangeUnit()
	local mode = ns.RangeSource()
	if mode == "target" then
		return unitOk("target") and "target" or nil
	end
	if mode == "mouseover" then
		return unitOk("mouseover") and "mouseover" or nil
	end
	if mode == "focus" then
		return unitOk("focus") and "focus" or nil
	end
	if unitOk("mouseover") then
		return "mouseover"
	end
	if unitOk("focus") then
		return "focus"
	end
	if unitOk("target") then
		return "target"
	end
	return nil
end

local cachedLib, libTried

local function libRange()
	if libTried then
		return cachedLib
	end
	libTried = true
	if not LibStub then
		return nil
	end
	local ok, lib = pcall(LibStub, "LibRangeCheck-3.0", true)
	if ok and lib and lib.GetRange then
		cachedLib = lib
		return lib
	end
	return nil
end

local function estimate(unit)
	local lower, upper

	local function inAt(yards)
		if upper then
			upper = math.min(upper, yards)
		else
			upper = yards
		end
	end

	local function outAt(yards)
		if lower then
			lower = math.max(lower, yards)
		else
			lower = yards
		end
	end

	if interact(unit, 3) then
		inAt(10)
	else
		outAt(10)
	end
	if interact(unit, 2) then
		inAt(11)
	else
		outAt(11)
	end
	if interact(unit, 1) or interact(unit, 4) then
		inAt(28)
	else
		outAt(28)
	end

	for i = 1, #RANGE_SPELLS do
		local row = RANGE_SPELLS[i]
		local r = spellRange(unit, row[1])
		if r == true then
			inAt(row[2])
		elseif r == false then
			outAt(row[2])
		end
	end

	if not lower and not upper then
		return nil
	end
	if lower and upper and lower >= upper then
		return math.max(0, upper - 1), upper
	end
	return lower or 0, upper
end

function ns.GetTargetRange()
	local unit = ns.RangeUnit()
	if not unit then
		return nil
	end
	local lib = libRange()
	if lib then
		local minR, maxR = safe(lib.GetRange, lib, unit, true)
		if minR or maxR then
			return minR, maxR
		end
	end
	return estimate(unit)
end

function ns.RangeYards()
	local minR, maxR = ns.GetTargetRange()
	if not minR and not maxR then
		return nil
	end
	return maxR or minR, minR, maxR
end

function ns.RangeFill()
	local yards = ns.RangeYards()
	if not yards then
		return 0, COLORS.oor
	end
	local maxR = ns.ClassMaxRange()
	local fill = 1 - math.min(1, yards / maxR)
	return fill, ns.RangeColor(yards)
end

function ns.RangeText()
	local _, minR, maxR = ns.RangeYards()
	if not minR and not maxR then
		return ""
	end
	if maxR then
		return string.format("%d-%d", minR, maxR)
	end
	return string.format("%d+", minR)
end
