local addonName, ns = ...

local RING_FILE = "Interface\\AddOns\\ForeverRing\\ring.tga"
local THIN_FILE = "Interface\\AddOns\\ForeverRing\\thin_ring.tga"
local CAST_FILE = "Interface\\AddOns\\ForeverRing\\cast_segment.tga"

local NUM_CAST_SEGMENTS = 48
local CAST_OK = { 1, 1, 1 }
local CAST_FAIL = { 1, 0.18, 0.12 }

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

local drive, f, ring, rangeHolder, rangeRing, powerHolder, powerRing, rangeLabel
local castSegments = {}
local cachedUILeft, cachedUIBottom, cachedScale
local lastCursorX, lastCursorY
local lastLit = -1
local lastRangeText, lastRangeR, lastRangeG, lastRangeB, lastHadRange
local lastRingR, lastRingG, lastRingB, lastRingA
local lastPowerSize, lastPowerR, lastPowerG, lastPowerB, lastPowerShow
local createdOnce = false
local casting = false
local interrupted = false
local castTicker
local lastShown
local lastOverUI

local function safe(fn, ...)
	if not fn then
		return nil
	end
	local ok, a, b, c = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b, c
end

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
	cachedUILeft, cachedUIBottom, cachedScale = nil, nil, nil
	lastCursorX, lastCursorY = nil, nil
end

function ns.InCombat()
	local ok, v = pcall(UnitAffectingCombat, "player")
	return ok and v and true or false
end

function ns.AddonOn()
	return not ns.db or ns.db.enabled ~= false
end

local POWER_COLOR = {
	[0] = { 0.20, 0.45, 1.00 },
	[1] = { 0.90, 0.10, 0.10 },
	[2] = { 1.00, 0.50, 0.25 },
	[3] = { 1.00, 0.96, 0.20 },
}

local function setRingTex(tex, file)
	if not tex or not file then
		return
	end
	tex:SetTexture(file, "CLAMP")
	pcall(tex.SetTexCoord, tex, 0, 1, 0, 1)
end

local function evenPx(n)
	n = math.floor((tonumber(n) or 0) + 0.5)
	if n < 8 then
		n = 8
	end
	if n % 2 == 1 then
		n = n + 1
	end
	return n
end

local function placeCenter(child, parent, size)
	if not child or not parent then
		return
	end
	child:ClearAllPoints()
	child:SetSize(size, size)
	child:SetPoint("CENTER", parent, "CENTER", 0, 0)
end

local function ringSize()
	return evenPx(tonumber(ns.db and ns.db.ringSize) or 48)
end

local function rangeGap()
	return tonumber(ns.db and ns.db.rangeGap) or 18
end

local function innerRangeSize()
	local size = ringSize()
	local gap = rangeGap()
	return evenPx(math.max(16, size - gap))
end

local function applyRangeCenter()
	if not rangeHolder or not f then
		return
	end
	placeCenter(rangeHolder, f, innerRangeSize())
	if rangeRing then
		rangeRing:ClearAllPoints()
		rangeRing:SetAllPoints(rangeHolder)
		pcall(rangeRing.SetTexCoord, rangeRing, 0, 1, 0, 1)
	end
end

local function powerColor(ptype, token)
	if PowerBarColor then
		local pack = (token and PowerBarColor[token]) or PowerBarColor[ptype]
		if type(pack) == "table" then
			local r = pack.r or pack[1]
			local g = pack.g or pack[2]
			local b = pack.b or pack[3]
			if r and g and b then
				return r, g, b
			end
		end
	end
	local pack = POWER_COLOR[ptype] or POWER_COLOR[0]
	return pack[1], pack[2], pack[3]
end

local function ringAlpha()
	local v = tonumber(ns.db and ns.db.ringAlpha) or 100
	if v > 1 then
		v = v / 100
	end
	if v < 0.15 then
		return 0.15
	end
	if v > 1 then
		return 1
	end
	return v
end

local function playerPower()
	local okT, ptype, token = pcall(UnitPowerType, "player")
	if not okT then
		return 0, 0, nil
	end
	ptype = tonumber(ptype) or 0
	local okC, cur = pcall(UnitPower, "player", ptype)
	local okM, maxp = pcall(UnitPowerMax, "player", ptype)
	cur = (okC and tonumber(cur)) or 0
	maxp = (okM and tonumber(maxp)) or 0
	if maxp <= 0 then
		return 0, ptype, token
	end
	return cur / maxp, ptype, token
end

local function updatePowerRing()
	if not powerHolder or not powerRing then
		return
	end
	local show = ns.RingShouldShow() and (not ns.db or ns.db.showPower ~= false)
	if not show then
		if lastPowerShow then
			powerHolder:Hide()
			lastPowerShow = false
		end
		return
	end
	local pct, ptype, token = playerPower()
	local r, g, b = powerColor(ptype, token)
	local a = ringAlpha()
	local maxS = evenPx(math.max(12, innerRangeSize() - 8))
	local minS = evenPx(math.max(8, maxS * 0.30))
	if minS > maxS then
		minS = maxS
	end
	local sz = evenPx(minS + (maxS - minS) * pct)
	if sz ~= lastPowerSize then
		lastPowerSize = sz
		placeCenter(powerHolder, f, sz)
		powerRing:ClearAllPoints()
		powerRing:SetAllPoints(powerHolder)
	end
	if r ~= lastPowerR or g ~= lastPowerG or b ~= lastPowerB or lastRingA ~= a then
		lastPowerR, lastPowerG, lastPowerB = r, g, b
		powerRing:SetVertexColor(r, g, b, a)
	end
	if not lastPowerShow then
		powerHolder:Show()
		powerRing:Show()
		lastPowerShow = true
	end
end

local function mouseFrame()
	if GetMouseFoci then
		local ok, foci = pcall(GetMouseFoci)
		if ok and type(foci) == "table" and foci[1] then
			return foci[1]
		end
	end
	if GetMouseFocus then
		return safe(GetMouseFocus)
	end
	return nil
end

local function overWorldOrUnit(frame)
	if not frame then
		return true
	end
	if frame == WorldFrame or frame == UIParent then
		return true
	end
	if f and (frame == f or frame == drive) then
		return true
	end
	local walk = frame
	for _ = 1, 10 do
		if not walk then
			break
		end
		if walk == WorldFrame or walk == f or walk == drive then
			return true
		end
		walk = walk.GetParent and walk:GetParent() or nil
	end
	return false
end

local function mouseOverUI()
	if ns.db and ns.db.hideOverUI == false then
		return false
	end
	if safe(UnitExists, "mouseover") then
		return false
	end
	return not overWorldOrUnit(mouseFrame())
end

function ns.RingShouldShow()
	if not ns.AddonOn() then
		return false
	end
	if ns.db and ns.db.showOutOfCombat == false and not ns.InCombat() then
		return false
	end
	if mouseOverUI() then
		return false
	end
	return true
end

local function applyShown(show)
	if not f then
		return
	end
	if show == lastShown then
		return
	end
	lastShown = show
	if show then
		f:Show()
	else
		f:Hide()
	end
end

local function paintSegments(color, fromI, toI, alpha)
	local r, g, b = color[1], color[2], color[3]
	for i = fromI, toI do
		if castSegments[i] then
			castSegments[i]:SetVertexColor(r, g, b, alpha)
		end
	end
end

local function clearCast()
	if lastLit <= 0 then
		lastLit = 0
		return
	end
	paintSegments(CAST_OK, 1, lastLit, 0)
	lastLit = 0
end

local function setLit(numLit, color)
	color = color or CAST_OK
	local a = ringAlpha()
	if numLit == lastLit and color == CAST_OK then
		return
	end
	if numLit > lastLit then
		paintSegments(color, lastLit + 1, numLit, a)
	else
		paintSegments(CAST_OK, numLit + 1, lastLit, 0)
		if color ~= CAST_OK and numLit > 0 then
			paintSegments(color, 1, numLit, a)
		end
	end
	lastLit = numLit
end

local function stopCastTicker()
	if castTicker then
		castTicker:Cancel()
		castTicker = nil
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

local function castAllowed()
	if ns.db and ns.db.showCast == false then
		return false
	end
	if ns.db and ns.db.onlyCombat and not ns.InCombat() then
		return false
	end
	return ns.RingShouldShow()
end

local function castProgress()
	local now = GetTime()
	local ok, name, _, _, startT, endT = pcall(UnitCastingInfo, "player")
	if ok and name then
		startT, endT = toSeconds(startT, endT)
		if startT and endT and endT > startT then
			return math.min(1, math.max(0, (now - startT) / (endT - startT)))
		end
	end
	ok, name, _, _, startT, endT = pcall(UnitChannelInfo, "player")
	if ok and name then
		startT, endT = toSeconds(startT, endT)
		if startT and endT and endT > startT then
			return math.min(1, math.max(0, 1 - ((now - startT) / (endT - startT))))
		end
	end
	return nil
end

local function updateCastRing()
	if interrupted then
		return
	end
	if not castAllowed() then
		clearCast()
		casting = false
		stopCastTicker()
		return
	end
	local progress = castProgress()
	if not progress then
		if casting then
			clearCast()
		end
		casting = false
		stopCastTicker()
		return
	end
	casting = true
	setLit(math.floor(progress * NUM_CAST_SEGMENTS + 0.5), CAST_OK)
end

local function startCastTicker()
	if castTicker or not castAllowed() then
		return
	end
	castTicker = C_Timer.NewTicker(0.05, updateCastRing)
end

local function flashInterrupt()
	interrupted = true
	casting = false
	stopCastTicker()
	local a = ringAlpha()
	paintSegments(CAST_FAIL, 1, NUM_CAST_SEGMENTS, a)
	lastLit = NUM_CAST_SEGMENTS
	C_Timer.After(0.45, function()
		interrupted = false
		clearCast()
	end)
end

local function followCursor()
	if not f then
		return
	end
	if not cachedUILeft then
		cachedUILeft, cachedUIBottom = UIParent:GetRect()
		cachedScale = UIParent:GetEffectiveScale()
	end
	local x, y = GetCursorPosition()
	local scale = cachedScale or UIParent:GetEffectiveScale()
	x = math.floor(x / scale - cachedUILeft + 0.5)
	y = math.floor(y / scale - cachedUIBottom + 0.5)
	if x == lastCursorX and y == lastCursorY then
		return
	end
	lastCursorX, lastCursorY = x, y
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end

local function tickDrive()
	if not ns.AddonOn() then
		applyShown(false)
		if drive then
			drive:Hide()
		end
		return
	end
	local over = mouseOverUI()
	if over ~= lastOverUI then
		lastOverUI = over
		lastShown = nil
	end
	local show = ns.RingShouldShow()
	if show then
		followCursor()
		updatePowerRing()
	elseif lastPowerShow and powerHolder then
		powerHolder:Hide()
		lastPowerShow = false
	end
	applyShown(show)
end

function ns.CreateRing()
	if not drive then
		drive = CreateFrame("Frame", "ForeverRingDrive", UIParent)
		drive:SetFrameStrata("TOOLTIP")
		drive:SetScript("OnUpdate", tickDrive)
	end
	drive:Show()

	if ring and f then
		lastShown = nil
		applyShown(ns.RingShouldShow())
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

	rangeHolder = CreateFrame("Frame", nil, f)
	rangeHolder:EnableMouse(false)
	rangeRing = rangeHolder:CreateTexture(nil, "BACKGROUND")
	setRingTex(rangeRing, THIN_FILE)
	rangeRing:SetVertexColor(0.05, 0.95, 0.55, ringAlpha())
	applyRangeCenter()
	rangeHolder:Hide()

	powerHolder = CreateFrame("Frame", nil, f)
	powerHolder:EnableMouse(false)
	powerRing = powerHolder:CreateTexture(nil, "ARTWORK")
	setRingTex(powerRing, THIN_FILE)
	powerRing:SetVertexColor(0.20, 0.45, 1.00, ringAlpha())
	powerHolder:Hide()

	for i = 1, NUM_CAST_SEGMENTS do
		local segment = f:CreateTexture(nil, "ARTWORK")
		setRingTex(segment, CAST_FILE)
		segment:SetAllPoints()
		segment:SetRotation(math.rad((i - 1) * (360 / NUM_CAST_SEGMENTS)))
		segment:SetVertexColor(1, 1, 1, 0)
		castSegments[i] = segment
	end

	ring = f:CreateTexture(nil, "BORDER")
	setRingTex(ring, RING_FILE)
	ring:SetAllPoints()
	local r, g, b = ns.RingColor()
	ring:SetVertexColor(r, g, b, ringAlpha())
	ring:Show()

	rangeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rangeLabel:SetPoint("BOTTOM", f, "TOP", 0, 8)
	rangeLabel:SetTextColor(1, 0.92, 0.55)
	rangeLabel:SetAlpha(ringAlpha())
	rangeLabel:SetText("")

	lastShown = nil
	applyShown(ns.RingShouldShow())
	if not createdOnce then
		createdOnce = true
		print("|cffd4a017Forever|r |cff66ccffMouse Ring-Range|r: cursor ring on")
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
	if drive then
		if ns.AddonOn() then
			drive:Show()
		else
			drive:Hide()
		end
	end
	local size = ringSize()
	f:SetSize(size, size)
	if ring then
		ring:ClearAllPoints()
		ring:SetAllPoints(f)
		pcall(ring.SetTexCoord, ring, 0, 1, 0, 1)
	end
	local r, g, b = ns.RingColor()
	local a = ringAlpha()
	if r ~= lastRingR or g ~= lastRingG or b ~= lastRingB or a ~= lastRingA then
		lastRingR, lastRingG, lastRingB, lastRingA = r, g, b, a
		ring:SetVertexColor(r, g, b, a)
	end
	if ns.db and ns.db.showRing == false then
		ring:Hide()
	else
		ring:Show()
	end
	applyRangeCenter()
	lastPowerSize = nil
	lastPowerShow = nil
	updatePowerRing()
	if rangeLabel then
		rangeLabel:ClearAllPoints()
		rangeLabel:SetPoint("BOTTOM", f, "TOP", 0, 8)
		rangeLabel:SetAlpha(a)
	end
	lastShown = nil
	lastOverUI = nil
	lastLit = -1
	applyShown(ns.RingShouldShow())
	if ns.UpdateRingCombat then
		ns.UpdateRingCombat()
	end
	updateCastRing()
end

function ns.UpdateRingCombat()
	if not f then
		ns.CreateRing()
		if not f then
			return
		end
	end
	lastShown = nil
	applyShown(ns.RingShouldShow())
	if not ns.RingShouldShow() then
		return
	end
	local showRange = not ns.db or ns.db.showRange ~= false
	local showText = not ns.db or ns.db.showRangeText ~= false
	local yards, minR, maxR
	if showRange and ns.RangeYards then
		yards, minR, maxR = ns.RangeYards()
	end
	local a = ringAlpha()
	if showRange and yards and rangeRing then
		local color = ns.RangeColor and ns.RangeColor(yards) or { 0.05, 0.95, 0.55 }
		if color[1] ~= lastRangeR or color[2] ~= lastRangeG or color[3] ~= lastRangeB or lastRingA ~= a then
			lastRangeR, lastRangeG, lastRangeB = color[1], color[2], color[3]
			rangeRing:SetVertexColor(color[1], color[2], color[3], a)
			if rangeLabel then
				rangeLabel:SetTextColor(color[1], color[2], color[3])
			end
		end
		if not lastHadRange then
			rangeHolder:Show()
			rangeRing:Show()
			lastHadRange = true
		end
		if showText and rangeLabel then
			local text
			if maxR then
				text = string.format("%d-%d", minR, maxR)
			else
				text = string.format("%d+", minR or yards)
			end
			if text ~= lastRangeText then
				lastRangeText = text
				rangeLabel:SetText(text)
				rangeLabel:Show()
			end
			rangeLabel:SetAlpha(a)
		elseif rangeLabel and lastRangeText then
			lastRangeText = nil
			rangeLabel:SetText("")
		end
	elseif lastHadRange or lastRangeText then
		lastHadRange = false
		lastRangeText = nil
		lastRangeR, lastRangeG, lastRangeB = nil, nil, nil
		if rangeHolder then
			rangeHolder:Hide()
		end
		if rangeRing then
			rangeRing:Hide()
		end
		if rangeLabel then
			rangeLabel:SetText("")
		end
	end
	updatePowerRing()
end

function ns.DebugRing()
	ns.Print(string.format(
		"frame=%s ring=%s on=%s combat=%s",
		f and "yes" or "no",
		ring and "yes" or "no",
		ns.AddonOn() and "yes" or "no",
		ns.InCombat() and "yes" or "no"
	))
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
for _, ev in ipairs({ "UNIT_POWER_UPDATE", "UNIT_POWER_FREQUENT", "UNIT_POWER", "UNIT_DISPLAYPOWER", "UNIT_MAXPOWER" }) do
	pcall(loader.RegisterEvent, loader, ev)
end
loader:SetScript("OnEvent", function(_, event, name)
	if event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" then
		cachedUILeft, cachedUIBottom = nil, nil
		return
	end
	if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" or event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER" or event == "UNIT_MAXPOWER" then
		if name == "player" then
			updatePowerRing()
		end
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
	if event == "UNIT_SPELLCAST_INTERRUPTED" or (event == "UNIT_SPELLCAST_FAILED" and (casting or lastLit > 0)) then
		if ns.db and ns.db.showCast == false then
			return
		end
		flashInterrupt()
		return
	end
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		interrupted = false
		casting = true
		startCastTicker()
		return
	end
	if interrupted then
		return
	end
	casting = false
	clearCast()
	stopCastTicker()
end)
