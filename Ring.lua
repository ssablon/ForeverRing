local addonName, ns = ...

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

local NUM = 64
local COLORS_OOR = { 1, 0.16, 0.16 }
local root, cursorTex, rangeTex, rangeFill, rangeLabel
local castSegs, rangeSegs

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

local function classRGB()
	if ns.db and ns.db.classColor == false then
		local c = ns.db.ringColor
		if c then
			return c[1] or 1, c[2] or 0.82, c[3] or 0.2
		end
		return 1, 0.82, 0.2
	end
	local _, class = safe(UnitClass, "player")
	local pack = CLASS_COLORS[class or ""]
	if pack then
		return pack[1], pack[2], pack[3]
	end
	return 0.83, 0.63, 0.09
end

local function makeSegs(parent, count, size)
	local list = {}
	for i = 1, count do
		local tex = parent:CreateTexture(nil, "ARTWORK")
		tex:SetTexture("Interface\\Buttons\\WHITE8x8")
		tex:SetSize(3, math.max(6, size * 0.12))
		tex:SetPoint("CENTER", parent, "CENTER", 0, 0)
		tex:SetVertexColor(1, 1, 1, 0)
		list[i] = tex
	end
	return list
end

local function placeSegs(list, size, lit, r, g, b, a)
	local n = #list
	local radius = size * 0.42
	for i = 1, n do
		local tex = list[i]
		local angle = (i - 1) / n * math.pi * 2 - math.pi * 0.5
		tex:ClearAllPoints()
		tex:SetPoint("CENTER", root, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
		tex:SetRotation(angle + math.pi * 0.5)
		if i <= lit then
			tex:SetVertexColor(r, g, b, a)
		else
			tex:SetVertexColor(r, g, b, 0)
		end
	end
end

local function shouldShow()
	if ns.db and ns.db.enabled == false then
		return false
	end
	if ns.db and ns.db.onlyCombat and not safe(UnitAffectingCombat, "player") then
		return false
	end
	if ns.db and ns.db.showOutOfCombat == false and not safe(UnitAffectingCombat, "player") then
		return false
	end
	return true
end

function ns.CreateRing()
	if root then
		return root
	end
	root = CreateFrame("Frame", "ForeverRingFrame", UIParent)
	root:SetSize(48, 48)
	root:SetFrameStrata("TOOLTIP")
	root:EnableMouse(false)
	root:SetClampedToScreen(false)

	cursorTex = root:CreateTexture(nil, "BORDER")
	cursorTex:SetTexture("Interface\\Minimap\\Ping\\MiniMap-Ping-Ring")
	cursorTex:SetAllPoints()
	cursorTex:SetVertexColor(1, 0.82, 0.2, 1)

	rangeTex = root:CreateTexture(nil, "BACKGROUND")
	rangeTex:SetTexture("Interface\\Minimap\\Ping\\MiniMap-Ping-Ring")
	rangeTex:SetPoint("CENTER")
	rangeTex:SetSize(64, 64)
	rangeTex:SetVertexColor(0.05, 0.95, 0.55, 0.9)

	rangeSegs = makeSegs(root, NUM, 64)
	castSegs = makeSegs(root, NUM, 48)

	rangeLabel = root:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	rangeLabel:SetPoint("TOP", root, "BOTTOM", 0, -2)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetText("")

	root:SetScript("OnUpdate", function(self)
		local x, y = safe(GetCursorPosition)
		local scale = safe(self.GetEffectiveScale, UIParent) or safe(UIParent.GetEffectiveScale, UIParent) or 1
		if not x or not y or not scale or scale == 0 then
			return
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
	end)

	ns.ApplyRingSettings()
	return root
end

function ns.ApplyRingSettings()
	if not root then
		return
	end
	local size = (ns.db and ns.db.ringSize) or 48
	local gap = (ns.db and ns.db.rangeGap) or 16
	root:SetSize(size, size)
	cursorTex:SetSize(size, size)
	rangeTex:SetSize(size + gap, size + gap)
	local r, g, b = classRGB()
	cursorTex:SetVertexColor(r, g, b, 1)
	cursorTex:SetShown(not ns.db or ns.db.showRing ~= false)
	rangeTex:SetShown(ns.db and ns.db.showRange ~= false)
	rangeLabel:SetShown(ns.db and ns.db.showRangeText ~= false)
	root:SetShown(shouldShow())
end

function ns.UpdateRingCombat()
	local fill, color = ns.RangeFill()
	if rangeTex and color then
		rangeTex:SetVertexColor(color[1], color[2], color[3], 0.95)
	end
	if rangeSegs then
		local size = ((ns.db and ns.db.ringSize) or 48) + ((ns.db and ns.db.rangeGap) or 16)
		local lit = math.floor(fill * NUM + 0.5)
		local c = color or COLORS_OOR
		placeSegs(rangeSegs, size, ns.db and ns.db.showRange ~= false and lit or 0, c[1], c[2], c[3], 0.95)
	end
	if rangeLabel then
		if ns.db and ns.db.showRangeText ~= false then
			rangeLabel:SetText(ns.RangeText())
		else
			rangeLabel:SetText("")
		end
	end

	local casting = false
	local progress = 0
	if ns.db and ns.db.showCast ~= false then
		local name, _, _, startMS, endMS = safe(UnitCastingInfo, "player")
		if not name then
			name, _, _, startMS, endMS = safe(UnitChannelInfo, "player")
		end
		if name and startMS and endMS and endMS > startMS then
			casting = true
			progress = (GetTime() - startMS / 1000) / ((endMS - startMS) / 1000)
			if progress < 0 then
				progress = 0
			end
			if progress > 1 then
				progress = 1
			end
		end
	end
	if castSegs then
		local size = (ns.db and ns.db.ringSize) or 48
		local lit = casting and math.floor(progress * NUM + 0.5) or 0
		placeSegs(castSegs, size * 0.72, lit, 1, 1, 1, 0.85)
	end
	if root then
		root:SetShown(shouldShow())
	end
end
