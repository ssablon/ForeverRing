local addonName, ns = ...

-- Same files and SetTexture(path, "CLAMP") as CursorRing.
local RING_FILE = "Interface\\AddOns\\CursorRing\\ring.tga"
local THIN_FILE = "Interface\\AddOns\\CursorRing\\thin_ring.tga"
local CAST_FILE = "Interface\\AddOns\\CursorRing\\cast_segment.tga"

local NUM_CAST_SEGMENTS = 180

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
local castSegments = {}
local cachedUILeft, cachedUIBottom
local createdOnce = false
local casting = false
local castTicker

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

local function innerRangeSize()
	local size = ringSize()
	local gap = rangeGap()
	return math.max(16, size - gap)
end

local function castColor()
	return 1, 1, 1
end

local function clamp01(v)
	if v < 0 then
		return 0
	end
	if v > 1 then
		return 1
	end
	return v
end

local function clearCast()
	local cr, cg, cb = castColor()
	for i = 1, NUM_CAST_SEGMENTS do
		if castSegments[i] then
			castSegments[i]:SetVertexColor(cr, cg, cb, 0)
		end
	end
end

local function toSeconds(startT, endT)
	startT, endT = tonumber(startT), tonumber(endT)
	if not startT or not endT then
		return nil
	end
	if endT > 1000 then
		return startT / 1000, endT / 1000
	end
	return startT, endT
end

local function castProgress()
	local now = GetTime()
	local ok, name, _, _, startT, endT = pcall(UnitCastingInfo, "player")
	if ok and name then
		startT, endT = toSeconds(startT, endT)
		if startT and endT and endT > startT then
			return clamp01((now - startT) / (endT - startT))
		end
	end
	ok, name, _, _, startT, endT = pcall(UnitChannelInfo, "player")
	if ok and name then
		startT, endT = toSeconds(startT, endT)
		if startT and endT and endT > startT then
			return clamp01(1 - ((now - startT) / (endT - startT)))
		end
	end
	return nil
end

local function updateCastRing()
	if not ns.db or ns.db.showCast == false then
		clearCast()
		casting = false
		return
	end
	local progress = castProgress()
	if not progress then
		if casting then
			clearCast()
		end
		casting = false
		return
	end
	casting = true
	local cr, cg, cb = castColor()
	local numLit = math.floor(progress * NUM_CAST_SEGMENTS + 0.5)
	for i = 1, NUM_CAST_SEGMENTS do
		if castSegments[i] then
			castSegments[i]:SetVertexColor(cr, cg, cb, i <= numLit and 1 or 0)
		end
	end
end

local function startCastTicker()
	if castTicker then
		return
	end
	castTicker = C_Timer.NewTicker(0.016, updateCastRing)
end

function ns.CreateRing()
	if ring and f then
		f:Show()
		ring:Show()
		startCastTicker()
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
	f:SetPoint("CENTER", UIParent, "CENTER")

	-- Distance ring INSIDE the cursor ring (BACKGROUND).
	rangeRing = f:CreateTexture(nil, "BACKGROUND")
	rangeRing:SetTexture(THIN_FILE, "CLAMP")
	rangeRing:SetPoint("CENTER", f, "CENTER")
	rangeRing:SetSize(innerRangeSize(), innerRangeSize())
	rangeRing:SetVertexColor(0.05, 0.95, 0.55, 1)
	rangeRing:Hide()

	-- Cast segments: CursorRing ARTWORK + cast_segment.tga, same size as the ring.
	for i = 1, NUM_CAST_SEGMENTS do
		local segment = f:CreateTexture(nil, "ARTWORK")
		segment:SetTexture(CAST_FILE, "CLAMP")
		segment:SetAllPoints()
		segment:SetRotation(math.rad((i - 1) * (360 / NUM_CAST_SEGMENTS)))
		segment:SetVertexColor(1, 1, 1, 0)
		castSegments[i] = segment
	end

	ring = f:CreateTexture(nil, "BORDER")
	ring:SetTexture(RING_FILE, "CLAMP")
	ring:SetAllPoints()
	local r, g, b = ns.RingColor()
	ring:SetVertexColor(r, g, b, 1)
	ring:Show()

	-- Yards OUTSIDE the cursor ring.
	rangeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("BOTTOM", f, "TOP", 0, 8)
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

	f:Show()
	startCastTicker()
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
		local inner = innerRangeSize()
		rangeRing:SetSize(inner, inner)
	end
	if rangeLabel then
		rangeLabel:ClearAllPoints()
		rangeLabel:SetPoint("BOTTOM", f, "TOP", 0, 8)
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
			rangeLabel:Show()
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

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:RegisterEvent("UI_SCALE_CHANGED")
loader:RegisterEvent("DISPLAY_SIZE_CHANGED")
loader:RegisterEvent("UNIT_SPELLCAST_START")
loader:RegisterEvent("UNIT_SPELLCAST_STOP")
loader:RegisterEvent("UNIT_SPELLCAST_FAILED")
loader:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
loader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
loader:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
loader:SetScript("OnEvent", function(_, event, name)
	if event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" then
		cachedUILeft, cachedUIBottom = nil, nil
		return
	end
	if event == "ADDON_LOADED" and name ~= addonName then
		return
	end
	if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		ns.CreateRing()
		return
	end
	if name ~= "player" then
		return
	end
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		casting = true
		return
	end
	casting = false
	clearCast()
end)
