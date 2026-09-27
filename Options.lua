local addonName, ns = ...

local PANEL = {
	bgFile = "Interface\\Buttons\\WHITE8x8",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 12,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local win

local function featureOn(key)
	if key == "classColor" then
		return ns.db.classColor ~= false
	end
	return ns.db[key] ~= false
end

local function paintSwitch(sw, on)
	if on then
		sw:SetBackdropColor(0.38, 0.25, 0.02, 0.95)
		sw:SetBackdropBorderColor(1, 0.82, 0.2, 1)
		sw.knob:ClearAllPoints()
		sw.knob:SetPoint("RIGHT", sw, "RIGHT", -3, 0)
		sw.knob:SetVertexColor(1, 0.82, 0.2, 1)
		sw.state:SetText(ns.T("SWITCH_ON"))
		sw.state:SetTextColor(1, 0.92, 0.45)
		sw.state:ClearAllPoints()
		sw.state:SetPoint("CENTER", sw, "CENTER", -10, 0)
	else
		sw:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
		sw:SetBackdropBorderColor(0.42, 0.42, 0.42, 1)
		sw.knob:ClearAllPoints()
		sw.knob:SetPoint("LEFT", sw, "LEFT", 3, 0)
		sw.knob:SetVertexColor(0.48, 0.48, 0.48, 1)
		sw.state:SetText(ns.T("SWITCH_OFF"))
		sw.state:SetTextColor(0.65, 0.65, 0.65)
		sw.state:ClearAllPoints()
		sw.state:SetPoint("CENTER", sw, "CENTER", 10, 0)
	end
end

local function makeCard(parent, titleKey, x, y, width, height)
	local card = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	card:SetSize(width, height)
	card:SetPoint("TOPLEFT", x, y)
	card:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	card:SetBackdropColor(0, 0, 0, 0.55)
	card:SetBackdropBorderColor(0.5, 0.42, 0.28, 0.9)
	local title = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOP", 0, -8)
	title:SetText(ns.T(titleKey))
	title:SetTextColor(1, 0.82, 0.2)
	card.title = title
	card._y = -30
	return card
end

local function addSwitch(card, key, label)
	local row = CreateFrame("Frame", nil, card)
	row:SetHeight(24)
	row:SetPoint("TOPLEFT", card, "TOPLEFT", 12, card._y)
	row:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, card._y)
	local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	txt:SetPoint("LEFT", 0, 0)
	txt:SetPoint("RIGHT", -66, 0)
	txt:SetJustifyH("LEFT")
	txt:SetText(label)
	txt:SetTextColor(0.92, 0.92, 0.92)
	local sw = CreateFrame("Button", nil, row, "BackdropTemplate")
	sw:SetSize(58, 22)
	sw:SetPoint("RIGHT", 0, 0)
	sw:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	local knob = sw:CreateTexture(nil, "ARTWORK")
	knob:SetTexture("Interface\\Buttons\\WHITE8x8")
	knob:SetSize(16, 16)
	sw.knob = knob
	sw.state = sw:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	sw:SetScript("OnClick", function()
		ns.db[key] = not featureOn(key)
		paintSwitch(sw, featureOn(key))
		if ns.ApplyRingSettings then
			ns.ApplyRingSettings()
		end
		if ns.ApplyMinimap then
			ns.ApplyMinimap()
		end
	end)
	paintSwitch(sw, featureOn(key))
	card._y = card._y - 26
	return row
end

local function addSlider(card, key, minV, maxV, fmt)
	local row = CreateFrame("Frame", nil, card)
	row:SetHeight(36)
	row:SetPoint("TOPLEFT", card, "TOPLEFT", 12, card._y)
	row:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, card._y)
	local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	label:SetPoint("TOPLEFT", 0, 0)
	label:SetTextColor(0.92, 0.92, 0.92)
	local bar = CreateFrame("Button", nil, row, "BackdropTemplate")
	bar:SetPoint("TOPLEFT", 0, -16)
	bar:SetPoint("TOPRIGHT", 0, -16)
	bar:SetHeight(16)
	bar:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	bar:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
	bar:SetBackdropBorderColor(0.42, 0.42, 0.42, 1)
	local fill = bar:CreateTexture(nil, "ARTWORK")
	fill:SetTexture("Interface\\Buttons\\WHITE8x8")
	fill:SetVertexColor(1, 0.82, 0.2, 0.85)
	fill:SetPoint("TOPLEFT", 3, -3)
	fill:SetPoint("BOTTOMLEFT", 3, 3)
	local function render()
		local value = tonumber(ns.db[key]) or minV
		label:SetText(string.format(fmt, value))
		local p = (value - minV) / math.max(1, maxV - minV)
		fill:SetWidth(math.max(2, (bar:GetWidth() - 6) * p))
	end
	bar:SetScript("OnMouseDown", function(self)
		self._drag = true
	end)
	bar:SetScript("OnMouseUp", function(self)
		self._drag = false
	end)
	bar:SetScript("OnUpdate", function(self)
		if not self._drag then
			return
		end
		local okL, left = pcall(self.GetLeft, self)
		local okS, scale = pcall(self.GetEffectiveScale, self)
		local okC, cx = pcall(GetCursorPosition)
		left, scale, cx = tonumber(okL and left), tonumber(okS and scale) or 1, tonumber(okC and cx)
		if not left or not cx then
			return
		end
		local p = (cx / scale - left) / math.max(1, self:GetWidth())
		p = math.min(1, math.max(0, p))
		ns.db[key] = math.floor(minV + p * (maxV - minV) + 0.5)
		render()
		ns.ApplyRingSettings()
	end)
	row:SetScript("OnShow", render)
	render()
	card._y = card._y - 42
end

local function ensure()
	if win then
		return win
	end
	win = CreateFrame("Frame", "ForeverRingOptions", UIParent, "BackdropTemplate")
	win:SetSize(560, 420)
	win:SetPoint("CENTER")
	win:SetBackdrop(PANEL)
	win:SetBackdropColor(0.05, 0.05, 0.05, 0.96)
	win:SetBackdropBorderColor(0.55, 0.45, 0.18, 1)
	win:SetFrameStrata("DIALOG")
	win:SetMovable(true)
	win:EnableMouse(true)
	win:RegisterForDrag("LeftButton")
	win:SetScript("OnDragStart", win.StartMoving)
	win:SetScript("OnDragStop", win.StopMovingOrSizing)
	win:Hide()
	tinsert(UISpecialFrames, "ForeverRingOptions")

	local title = win:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -14)
	title:SetText(ns.T("TITLE"))
	title:SetTextColor(0.83, 0.63, 0.09)
	local sub = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	sub:SetPoint("LEFT", title, "RIGHT", 8, 0)
	sub:SetText(ns.T("TITLE_SUB"))
	sub:SetTextColor(0.55, 0.55, 0.55)
	local ver = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ver:SetPoint("TOPRIGHT", -40, -16)
	ver:SetTextColor(0.7, 0.7, 0.7)
	local meta
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		local ok, value = pcall(C_AddOns.GetAddOnMetadata, addonName, "Version")
		if ok then
			meta = value
		end
	end
	ver:SetText(meta or "0.1.0")

	local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)

	local ringCard = makeCard(win, "OPT_CARD_CURSOR", 16, -48, 256, 200)
	addSwitch(ringCard, "showRing", ns.T("OPT_ENABLE_RING"))
	addSwitch(ringCard, "showOutOfCombat", ns.T("OPT_OUT_OF_COMBAT"))
	addSwitch(ringCard, "classColor", ns.T("OPT_CLASS_COLOR"))
	addSlider(ringCard, "ringSize", 24, 128, ns.T("OPT_RING_SIZE"))

	local castCard = makeCard(win, "OPT_CARD_CAST", 288, -48, 256, 200)
	addSwitch(castCard, "showCast", ns.T("OPT_ENABLE_CAST"))
	addSwitch(castCard, "onlyCombat", ns.T("OPT_ONLY_COMBAT"))
	addSwitch(castCard, "showMinimap", ns.T("OPT_MINIMAP"))

	local rangeCard = makeCard(win, "OPT_CARD_RANGE", 16, -260, 256, 140)
	addSwitch(rangeCard, "showRange", ns.T("OPT_ENABLE_RANGE"))
	addSwitch(rangeCard, "showRangeText", ns.T("OPT_RANGE_TEXT"))
	addSwitch(rangeCard, "onlyEnemy", ns.T("OPT_ONLY_ENEMY"))
	addSlider(rangeCard, "rangeGap", 8, 40, ns.T("OPT_RANGE_GAP"))

	local about = makeCard(win, "OPT_CARD_ABOUT", 288, -260, 256, 140)
	local body = about:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	body:SetPoint("TOPLEFT", 12, -30)
	body:SetPoint("BOTTOMRIGHT", -12, 12)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetTextColor(0.88, 0.88, 0.88)
	body:SetText(ns.T("INFO_ABOUT") .. "\n\n" .. ns.T("INFO_CREDIT"))
	return win
end

function ns.ToggleOptions()
	local frame = ensure()
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end

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

local function placeMinimap(btn)
	if not Minimap or not btn then
		return
	end
	local angle = ((ns.db and ns.db.minimapAngle) or 140) * math.pi / 180
	btn:ClearAllPoints()
	btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * 80, math.sin(angle) * 80)
end

function ns.ApplyMinimap()
	if not ns.minimap then
		return
	end
	if ns.db and ns.db.showMinimap == false then
		ns.minimap:Hide()
	else
		ns.minimap:Show()
		placeMinimap(ns.minimap)
	end
end

function ns.CreateMinimap()
	if ns.minimap then
		ns.ApplyMinimap()
		return
	end
	if not Minimap then
		return
	end
	local btn = CreateFrame("Button", "ForeverRingMinimap", Minimap)
	btn:SetSize(32, 32)
	btn:SetFrameStrata("MEDIUM")
	btn:SetFrameLevel(8)
	btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	btn:RegisterForDrag("LeftButton")
	btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetTexture("Interface\\AddOns\\ForeverRing\\images\\logo")
	icon:SetPoint("TOPLEFT", 6, -6)
	icon:SetPoint("BOTTOMRIGHT", -6, 6)
	local border = btn:CreateTexture(nil, "OVERLAY")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetSize(54, 54)
	border:SetPoint("TOPLEFT")
	btn:SetScript("OnClick", function(_, button)
		if button == "RightButton" then
			if not ns.db then
				return
			end
			ns.db.enabled = not (ns.db.enabled ~= false)
			if ns.ApplyRingSettings then
				ns.ApplyRingSettings()
			end
			return
		end
		ns.ToggleOptions()
	end)
	btn:SetScript("OnDragStart", function(self)
		self:SetScript("OnUpdate", function(me)
			local mx, my = safe(Minimap.GetCenter, Minimap)
			local cx, cy = safe(GetCursorPosition)
			local scale = safe(Minimap.GetEffectiveScale, Minimap) or 1
			if not mx or not my or not cx or not cy or scale == 0 then
				return
			end
			ns.db.minimapAngle = math.deg(math.atan2(cy / scale - my, cx / scale - mx))
			placeMinimap(me)
		end)
	end)
	btn:SetScript("OnDragStop", function(self)
		self:SetScript("OnUpdate", nil)
	end)
	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine(ns.T("TITLE"), 1, 0.82, 0)
		GameTooltip:AddLine(ns.T("MINIMAP_L"), 1, 1, 1)
		GameTooltip:AddLine(ns.T("MINIMAP_R"), 0.7, 0.7, 0.7)
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	ns.minimap = btn
	ns.ApplyMinimap()
end

