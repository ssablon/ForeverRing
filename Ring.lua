local addonName, ns = ...

local RING_TEX = "Interface\\AddOns\\ForeverRing\\ring.tga"
local THIN_TEX = "Interface\\AddOns\\ForeverRing\\thin_ring.tga"
local RING_TEX_ALT = "Interface\\AddOns\\ForeverRing\\images\\ring.tga"
local THIN_TEX_ALT = "Interface\\AddOns\\ForeverRing\\images\\thin_ring.tga"

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

local root, cursorTex, rangeTex, rangeLabel
local cachedUILeft, cachedUIBottom

local function call(fn, ...)
	if not fn then
		return nil
	end
	local ok, a, b, c, d, e = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b, c, d, e
end

local function applyTexture(tex, primary, fallback)
	if not tex then
		return
	end
	local ok = pcall(tex.SetTexture, tex, primary, "CLAMP")
	if not ok then
		pcall(tex.SetTexture, tex, fallback, "CLAMP")
	end
end

function ns.PlayerClassColor()
	local ok, _, class = pcall(UnitClass, "player")
	if not ok then
		class = nil
	end
	if RAID_CLASS_COLORS and class and RAID_CLASS_COLORS[class] then
		local c = RAID_CLASS_COLORS[class]
		return c.r or 1, c.g or 0.82, c.b or 0.2
	end
	local pack = CLASS_COLORS[class or ""]
	if pack then
		return pack[1], pack[2], pack[3]
	end
	return 0.83, 0.63, 0.09
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

local function shouldShow()
	if ns.db and ns.db.enabled == false then
		return false
	end
	if ns.db and ns.db.onlyCombat then
		return call(UnitAffectingCombat, "player") == true
	end
	if ns.db and ns.db.showOutOfCombat == false then
		return call(UnitAffectingCombat, "player") == true
	end
	return true
end

function ns.ClearRingRect()
	cachedUILeft, cachedUIBottom = nil, nil
end

-- Same math as CursorRing: raw GetCursorPosition / UIParent scale, minus GetRect.
local function followCursor(frame)
	if not cachedUILeft then
		local left, bottom = UIParent:GetRect()
		cachedUILeft, cachedUIBottom = left, bottom
	end
	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	x = x / scale - (cachedUILeft or 0)
	y = y / scale - (cachedUIBottom or 0)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end

function ns.CreateRing()
	if root then
		root:Show()
		ns.ApplyRingSettings()
		return root
	end
	root = CreateFrame("Frame", "ForeverRingFrame", UIParent)
	root:SetSize(48, 48)
	root:SetFrameStrata("TOOLTIP")
	root:SetFrameLevel(100)
	root:EnableMouse(false)
	root:SetClampedToScreen(false)
	if root.SetIgnoreParentScale then
		root:SetIgnoreParentScale(false)
	end
	root:SetPoint("CENTER", UIParent, "CENTER")

	rangeTex = root:CreateTexture(nil, "BACKGROUND")
	applyTexture(rangeTex, THIN_TEX, THIN_TEX_ALT)
	rangeTex:SetPoint("CENTER")
	rangeTex:SetSize(66, 66)
	rangeTex:SetVertexColor(0.05, 0.95, 0.55, 1)
	rangeTex:Hide()

	cursorTex = root:CreateTexture(nil, "BORDER")
	applyTexture(cursorTex, RING_TEX, RING_TEX_ALT)
	cursorTex:SetAllPoints()
	cursorTex:SetVertexColor(1, 1, 1, 1)

	rangeLabel = root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("TOP", root, "BOTTOM", 0, -1)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetText("")

	root:SetScript("OnUpdate", function(self)
		pcall(followCursor, self)
	end)

	ns.ApplyRingSettings()
	return root
end

function ns.ApplyRingSettings()
	if not root then
		return
	end
	local size = tonumber(ns.db and ns.db.ringSize) or 48
	local gap = tonumber(ns.db and ns.db.rangeGap) or 18
	root:SetSize(size, size)
	if cursorTex then
		applyTexture(cursorTex, RING_TEX, RING_TEX_ALT)
		cursorTex:SetAllPoints()
		local r, g, b = ns.RingColor()
		cursorTex:SetVertexColor(r, g, b, 1)
		cursorTex:SetAlpha(1)
		cursorTex:SetShown(not ns.db or ns.db.showRing ~= false)
	end
	if rangeTex then
		applyTexture(rangeTex, THIN_TEX, THIN_TEX_ALT)
		rangeTex:SetSize(size + gap, size + gap)
	end
	if shouldShow() then
		root:Show()
	else
		root:Hide()
	end
end

function ns.UpdateRingCombat()
	if not root then
		return
	end
	if not shouldShow() then
		root:Hide()
		return
	end
	root:Show()
	if cursorTex then
		local r, g, b = ns.RingColor()
		cursorTex:SetVertexColor(r, g, b, 1)
		cursorTex:Show()
	end

	local showRange = not ns.db or ns.db.showRange ~= false
	local showText = not ns.db or ns.db.showRangeText ~= false
	local yards, minR, maxR = ns.RangeYards and ns.RangeYards()
	if showRange and yards then
		local color = ns.RangeColor and ns.RangeColor(yards) or { 0.05, 0.95, 0.55 }
		rangeTex:SetVertexColor(color[1], color[2], color[3], 1)
		rangeTex:Show()
		if showText then
			if maxR then
				rangeLabel:SetText(string.format("%d-%d", minR, maxR))
			else
				rangeLabel:SetText(string.format("%d+", minR or yards))
			end
			rangeLabel:Show()
		else
			rangeLabel:SetText("")
		end
	else
		rangeTex:Hide()
		rangeLabel:SetText("")
	end
end
