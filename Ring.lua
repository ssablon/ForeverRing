local addonName, ns = ...

-- Same files and SetTexture call as CursorRing (CLAMP + .tga).
local RING_FILE = "Interface\\AddOns\\ForeverRing\\ring.tga"
local THIN_FILE = "Interface\\AddOns\\ForeverRing\\thin_ring.tga"

local CLASS_COLORS = {
	WARRIOR = { 0.78, 0.61, 0.43 },
	PALADIN = { 0.96, 0.55, 0.73 },
	HUNTER = { 0.67, 0.83, 0.45 },
	ROGUE = { 1.00, 0.96, 0.41 },
	PRIEST = { 1.00, 1.00, 1.00 },
	SHAMAN = { 0.00, 0.44, 0.87 },
	MAGE = { 0.25, 0.78, 0.92 },
	WARLOCK = { 0.53, 0.53, 0.93 },
	DRUID = { 1.00, 0.49, 0.04 },
}

local f, ring, rangeRing, rangeLabel
local cachedUILeft, cachedUIBottom

function ns.PlayerClassColor()
	local class
	local ok, _, token = pcall(UnitClass, "player")
	if ok then
		class = token
	end
	local pack = CLASS_COLORS[class or ""]
	if pack then
		return pack[1], pack[2], pack[3]
	end
	return 1, 0.82, 0.2
end

function ns.RingColor()
	if ns.db and ns.db.classColor == false then
		local c = ns.db.ringColor
		if type(c) == "table" then
			return c[1] or c.r or 1, c[2] or c.g or 0.82, c[3] or c.b or 0.2
		end
		return 1, 0.82, 0.2
	end
	return ns.PlayerClassColor()
end

function ns.ClearRingRect()
	cachedUILeft, cachedUIBottom = nil, nil
end

local function ringSize()
	return tonumber(ns.db and ns.db.ringSize) or 48
end

local function rangeGap()
	return tonumber(ns.db and ns.db.rangeGap) or 18
end

local function applyColor()
	local r, g, b = ns.RingColor()
	if ring then
		ring:SetVertexColor(r, g, b, 1)
		ring:SetAlpha(1)
	end
end

-- CursorRing CreateCursorRing + OnUpdate, unchanged math.
function ns.CreateRing()
	if ring then
		if f then
			f:Show()
		end
		ns.ApplyRingSettings()
		return f
	end

	local size = ringSize()
	f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(size, size)
	f:SetFrameStrata("TOOLTIP")
	f:SetIgnoreParentScale(false)
	f:EnableMouse(false)
	f:SetClampedToScreen(false)

	ring = f:CreateTexture(nil, "BORDER")
	ring:SetTexture(RING_FILE, "CLAMP")
	ring:SetAllPoints()
	local r, g, b = ns.RingColor()
	ring:SetVertexColor(r, g, b, 1)

	-- Range circle = CursorRing outline: same texture API, larger, BACKGROUND.
	rangeRing = f:CreateTexture(nil, "BACKGROUND")
	rangeRing:SetTexture(THIN_FILE, "CLAMP")
	rangeRing:SetPoint("CENTER", f, "CENTER")
	rangeRing:SetSize(size + rangeGap(), size + rangeGap())
	rangeRing:SetVertexColor(0.05, 0.95, 0.55, 1)
	rangeRing:Hide()

	rangeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("TOP", f, "BOTTOM", 0, -1)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetText("")

	f:SetScript("OnUpdate", function(self)
		if not cachedUILeft then
			cachedUILeft, cachedUIBottom = UIParent:GetRect()
		end

		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		x = x / scale - cachedUILeft
		y = y / scale - cachedUIBottom

		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
	end)

	ns.ApplyRingSettings()
	return f
end

function ns.ApplyRingSettings()
	if not f or not ring then
		return
	end
	local size = ringSize()
	f:SetSize(size, size)
	ring:SetTexture(RING_FILE, "CLAMP")
	ring:SetAllPoints()
	applyColor()
	if ns.db and ns.db.showRing == false then
		ring:Hide()
	else
		ring:Show()
	end
	if rangeRing then
		rangeRing:SetTexture(THIN_FILE, "CLAMP")
		rangeRing:SetSize(size + rangeGap(), size + rangeGap())
	end
	if ns.db and ns.db.enabled == false then
		f:Hide()
	else
		f:Show()
	end
end

function ns.UpdateRingCombat()
	if not f then
		return
	end
	if ns.db and ns.db.enabled == false then
		f:Hide()
		return
	end
	if ns.db and ns.db.onlyCombat then
		local ok, inCombat = pcall(UnitAffectingCombat, "player")
		if not ok or inCombat ~= true then
			f:Hide()
			return
		end
	end
	if ns.db and ns.db.showOutOfCombat == false then
		local ok, inCombat = pcall(UnitAffectingCombat, "player")
		if not ok or inCombat ~= true then
			f:Hide()
			return
		end
	end
	f:Show()
	applyColor()
	if ring then
		if ns.db and ns.db.showRing == false then
			ring:Hide()
		else
			ring:Show()
		end
	end

	local showRange = not ns.db or ns.db.showRange ~= false
	local showText = not ns.db or ns.db.showRangeText ~= false
	local yards, minR, maxR
	if ns.RangeYards then
		yards, minR, maxR = ns.RangeYards()
	end
	if showRange and yards and rangeRing then
		local color = ns.RangeColor and ns.RangeColor(yards) or { 0.05, 0.95, 0.55 }
		rangeRing:SetVertexColor(color[1], color[2], color[3], 1)
		rangeRing:Show()
		if showText and rangeLabel then
			if maxR then
				rangeLabel:SetText(string.format("%d-%d", minR, maxR))
			else
				rangeLabel:SetText(string.format("%d+", minR or yards))
			end
		elseif rangeLabel then
			rangeLabel:SetText("")
		end
	else
		if rangeRing then
			rangeRing:Hide()
		end
		if rangeLabel then
			rangeLabel:SetText("")
		end
	end
end

function ns.DebugRing()
	ns.Print(string.format(
		"frame=%s ring=%s enabled=%s",
		f and "yes" or "no",
		ring and "yes" or "no",
		tostring(not ns.db or ns.db.enabled ~= false)
	))
end
