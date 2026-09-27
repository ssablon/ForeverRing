local addonName, ns = ...

local IMG = "Interface\\AddOns\\ForeverRing\\images\\"

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
local uiLeft, uiBottom

local function readable(value)
	if value == nil then
		return nil
	end
	if issecretvalue and issecretvalue(value) then
		return nil
	end
	if canaccessvalue and not canaccessvalue(value) then
		return nil
	end
	return value
end

local function call(fn, ...)
	if not fn then
		return nil
	end
	local ok, a, b, c, d, e = pcall(fn, ...)
	if not ok then
		return nil
	end
	return readable(a), readable(b), readable(c), readable(d), readable(e)
end

local function classRGB()
	if ns.db and ns.db.classColor == false then
		local c = ns.db.ringColor
		if c then
			return c[1] or 1, c[2] or 0.82, c[3] or 0.2
		end
		return 1, 0.82, 0.2
	end
	local _, class = call(UnitClass, "player")
	local pack = CLASS_COLORS[class or ""]
	if pack then
		return pack[1], pack[2], pack[3]
	end
	return 0.83, 0.63, 0.09
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

local function refreshUIRect()
	uiLeft, uiBottom = nil, nil
	if UIParent and UIParent.GetRect then
		local left, bottom = call(UIParent.GetRect, UIParent)
		uiLeft, uiBottom = left, bottom
	end
end

local function followCursor(frame)
	local x, y = call(GetCursorPosition)
	local scale = call(UIParent.GetEffectiveScale, UIParent)
	if not x or not y or not scale or scale == 0 then
		return
	end
	if uiLeft == nil then
		refreshUIRect()
	end
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale - (uiLeft or 0), y / scale - (uiBottom or 0))
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

	rangeTex = root:CreateTexture(nil, "BACKGROUND")
	rangeTex:SetTexture(IMG .. "thin_ring")
	rangeTex:SetPoint("CENTER")
	rangeTex:SetSize(66, 66)
	rangeTex:SetVertexColor(0.05, 0.95, 0.55, 1)

	cursorTex = root:CreateTexture(nil, "ARTWORK")
	cursorTex:SetTexture(IMG .. "ring")
	cursorTex:SetAllPoints()
	cursorTex:SetVertexColor(1, 0.82, 0.2, 1)

	rangeLabel = root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("TOP", root, "BOTTOM", 0, -1)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetText("")

	root:SetScript("OnUpdate", function(self)
		local ok = pcall(followCursor, self)
		if not ok then
			return
		end
	end)

	refreshUIRect()
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
	cursorTex:SetAllPoints()
	rangeTex:SetSize(size + gap, size + gap)
	local r, g, b = classRGB()
	cursorTex:SetVertexColor(r, g, b, 1)
	cursorTex:SetShown(not ns.db or ns.db.showRing ~= false)
	rangeTex:SetShown(false)
	rangeLabel:SetText("")
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

	local showRange = not ns.db or ns.db.showRange ~= false
	local showText = not ns.db or ns.db.showRangeText ~= false
	local yards, minR, maxR = ns.RangeYards()
	if showRange and yards then
		local color = ns.RangeColor(yards)
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

function ns.ClearRingRect()
	refreshUIRect()
end
