local addonName, ns = ...

local RING_TEX = "Interface\\AddOns\\ForeverRing\\ring.tga"
local THIN_TEX = "Interface\\AddOns\\ForeverRing\\thin_ring.tga"

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

local root, fillTex, cursorTex, rangeTex, rangeLabel

local function call(fn, ...)
	if not fn then
		return nil
	end
	local ok, a, b, c = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b, c
end

local function setTexture(tex, path)
	if tex then
		pcall(tex.SetTexture, tex, path)
	end
end

function ns.PlayerClassColor()
	local _, class = call(UnitClass, "player")
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
			return tonumber(c[1] or c.r) or 1, tonumber(c[2] or c.g) or 0.82, tonumber(c[3] or c.b) or 0.2
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
end

-- CursorRing places the frame on UIParent. Camelot secret-values break
-- GetRect / scale math, so we pin to WorldFrame in raw cursor pixels.
local function followCursor(frame)
	local x, y = GetCursorPosition()
	local parent = WorldFrame or UIParent
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", parent, "BOTTOMLEFT", x, y)
end

function ns.CreateRing()
	if root then
		root:Show()
		ns.ApplyRingSettings()
		return root
	end
	local parent = WorldFrame or UIParent
	root = CreateFrame("Frame", "ForeverRingFrame", parent)
	root:SetSize(48, 48)
	root:SetFrameStrata("TOOLTIP")
	root:SetFrameLevel(128)
	root:EnableMouse(false)
	root:SetClampedToScreen(false)
	if root.SetIgnoreParentScale then
		root:SetIgnoreParentScale(true)
	end
	root:SetPoint("CENTER", UIParent, "CENTER")

	-- Always-visible fallback. If ring.tga fails on camelot, the square still shows.
	fillTex = root:CreateTexture(nil, "BACKGROUND")
	fillTex:SetAllPoints()
	pcall(fillTex.SetTexture, fillTex, "Interface\\Buttons\\WHITE8x8")
	fillTex:SetVertexColor(1, 0.82, 0.2, 0.35)

	cursorTex = root:CreateTexture(nil, "ARTWORK")
	cursorTex:SetAllPoints()
	setTexture(cursorTex, RING_TEX)
	cursorTex:SetVertexColor(1, 0.82, 0.2, 1)

	rangeTex = root:CreateTexture(nil, "BORDER")
	rangeTex:SetPoint("CENTER")
	rangeTex:SetSize(66, 66)
	setTexture(rangeTex, THIN_TEX)
	rangeTex:SetVertexColor(0.05, 0.95, 0.55, 1)
	rangeTex:Hide()

	rangeLabel = root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("TOP", root, "BOTTOM", 0, -2)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetText("")

	root:SetScript("OnUpdate", function(self)
		pcall(followCursor, self)
	end)
	root:Show()
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
	local r, g, b = ns.RingColor()
	if fillTex then
		fillTex:SetVertexColor(r, g, b, 0.35)
		fillTex:SetShown(not ns.db or ns.db.showRing ~= false)
	end
	if cursorTex then
		setTexture(cursorTex, RING_TEX)
		cursorTex:SetAllPoints()
		cursorTex:SetVertexColor(r, g, b, 1)
		cursorTex:SetShown(not ns.db or ns.db.showRing ~= false)
	end
	if rangeTex then
		setTexture(rangeTex, THIN_TEX)
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
	local r, g, b = ns.RingColor()
	if fillTex then
		fillTex:SetVertexColor(r, g, b, 0.35)
	end
	if cursorTex then
		cursorTex:SetVertexColor(r, g, b, 1)
		cursorTex:SetShown(not ns.db or ns.db.showRing ~= false)
	end

	local showRange = not ns.db or ns.db.showRange ~= false
	local showText = not ns.db or ns.db.showRangeText ~= false
	local yards, minR, maxR
	if ns.RangeYards then
		yards, minR, maxR = ns.RangeYards()
	end
	if showRange and yards then
		local color = ns.RangeColor and ns.RangeColor(yards) or { 0.05, 0.95, 0.55 }
		if rangeTex then
			rangeTex:SetVertexColor(color[1], color[2], color[3], 1)
			rangeTex:Show()
		end
		if showText and rangeLabel then
			if maxR then
				rangeLabel:SetText(string.format("%d-%d", minR, maxR))
			else
				rangeLabel:SetText(string.format("%d+", minR or yards))
			end
			rangeLabel:Show()
		elseif rangeLabel then
			rangeLabel:SetText("")
		end
	else
		if rangeTex then
			rangeTex:Hide()
		end
		if rangeLabel then
			rangeLabel:SetText("")
		end
	end
end

function ns.DebugRing()
	local shown = root and select(2, pcall(root.IsShown, root))
	ns.Print(string.format(
		"frame=%s shown=%s enabled=%s ring=%s parent=%s",
		root and "yes" or "no",
		tostring(shown),
		tostring(not ns.db or ns.db.enabled ~= false),
		tostring(not ns.db or ns.db.showRing ~= false),
		WorldFrame and "WorldFrame" or "UIParent"
	))
end
