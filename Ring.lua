local addonName, ns = ...

-- CursorRing uses these exact files and SetTexture(path, "CLAMP").
-- We load CursorRing's files first: they already work on this client.
local RING_FILE = "Interface\\AddOns\\CursorRing\\ring.tga"
local THIN_FILE = "Interface\\AddOns\\CursorRing\\thin_ring.tga"

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
local createdOnce = false

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

-- CursorRing CreateCursorRing + OnUpdate, copied. Ring.lua starts itself
-- (own events) so a later file error cannot prevent the ring from existing.
function ns.CreateRing()
	if ring and f then
		f:Show()
		ring:Show()
		return f
	end

	local size = ringSize()
	f = CreateFrame("Frame", "ForeverRingCursor", UIParent)
	f:SetSize(size, size)
	f:SetFrameStrata("TOOLTIP")
	if f.SetIgnoreParentScale then
		f:SetIgnoreParentScale(false)
	end
	f:EnableMouse(false)
	f:SetClampedToScreen(false)
	-- Visible even if the first OnUpdate errors (no points = invisible).
	f:SetPoint("CENTER", UIParent, "CENTER")

	ring = f:CreateTexture(nil, "BORDER")
	ring:SetTexture(RING_FILE, "CLAMP")
	ring:SetAllPoints()
	local r, g, b = ns.RingColor()
	ring:SetVertexColor(r, g, b, 1)
	ring:Show()

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

	-- Exact CursorRing cursor math. Do not pcall this.
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

	f:Show()
	if not createdOnce then
		createdOnce = true
		print("|cffd4a017Forever|r |cff66ccffRing|r: cursor ring on")
	end
	return f
end

function ns.ApplyRingSettings()
	if not f or not ring then
		ns.CreateRing()
		if not f then
			return
		end
	end
	if ns.db then
		ns.db.enabled = true
	end
	local size = ringSize()
	f:SetSize(size, size)
	f:Show()
	ring:SetAllPoints()
	local r, g, b = ns.RingColor()
	ring:SetVertexColor(r, g, b, 1)
	if ns.db and ns.db.showRing == false then
		ring:Hide()
	else
		ring:Show()
	end
	if rangeRing then
		rangeRing:SetSize(size + rangeGap(), size + rangeGap())
	end
end

function ns.UpdateRingCombat()
	if not f then
		ns.CreateRing()
		if not f then
			return
		end
	end
	f:Show()
	if ring and (not ns.db or ns.db.showRing ~= false) then
		local r, g, b = ns.RingColor()
		ring:SetVertexColor(r, g, b, 1)
		ring:Show()
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
	ns.Print(string.format("frame=%s ring=%s", f and "yes" or "no", ring and "yes" or "no"))
end

-- Same events as CursorRing: do not wait for Core.lua.
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:RegisterEvent("UI_SCALE_CHANGED")
loader:RegisterEvent("DISPLAY_SIZE_CHANGED")
loader:SetScript("OnEvent", function(_, event, name)
	if event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" then
		cachedUILeft, cachedUIBottom = nil, nil
		return
	end
	if event == "ADDON_LOADED" and name ~= addonName then
		return
	end
	ns.CreateRing()
end)
