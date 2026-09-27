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

local cachedLib, libTried

-- Classic interact checks: duel ~10, trade ~11, inspect/follow ~28.
local function libRange()
	if libTried then
		return cachedLib
	end
	libTried = true
	if not LibStub then
		return nil
	end
	local names = { "LibRangeCheck-3.0-WildFork", "LibRangeCheck-3.0" }
	for i = 1, #names do
		local ok, lib = pcall(LibStub, names[i], true)
		if ok and lib and lib.GetRange then
			cachedLib = lib
			return lib
		end
	end
	return nil
end

function ns.GetTargetRange()
	if not unitOk("target") then
		return nil
	end
	local lib = libRange()
	if lib then
		local minR, maxR = safe(lib.GetRange, lib, "target", true)
		if minR or maxR then
			return minR, maxR
		end
	end
	local near10 = interact("target", 3)
	local near11 = interact("target", 2)
	local near28 = interact("target", 1) or interact("target", 4)

	if near10 then
		return 0, 10
	end
	if near11 then
		return 8, 11
	end
	if near28 then
		return 11, 28
	end

	local in30 = spellRange("target", "Fireball")
		or spellRange("target", "Lightning Bolt")
		or spellRange("target", "Shadow Bolt")
		or spellRange("target", "Smite")
		or spellRange("target", "Wrath")
		or spellRange("target", "Auto Shot")
		or spellRange("target", "Hunter's Mark")
	if in30 == true then
		return 28, 35
	end
	return 28, nil
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
