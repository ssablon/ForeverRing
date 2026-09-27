local addonName, ns = ...

local SITE_URL = "https://wow-forever.fr"
local DISCORD_URL = "https://discord.gg/qmb2uDu8Z3"

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
	card.titleKey = titleKey
	card.widgets = {}
	card._y = -30
	return card
end

local function addSwitch(card, key, labelKey)
	local row = CreateFrame("Frame", nil, card)
	row:SetHeight(24)
	row:SetPoint("TOPLEFT", card, "TOPLEFT", 12, card._y)
	row:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, card._y)
	local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	txt:SetPoint("LEFT", 0, 0)
	txt:SetPoint("RIGHT", -66, 0)
	txt:SetJustifyH("LEFT")
	txt:SetText(ns.T(labelKey))
	txt:SetTextColor(0.92, 0.92, 0.92)
	row.label = txt
	row.labelKey = labelKey
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
	row.switch = sw
	row.dbKey = key
	table.insert(card.widgets, row)
	card._y = card._y - 26
	return row
end

local function addSlider(card, key, minV, maxV, fmtKey)
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
		label:SetText(string.format(ns.T(fmtKey), value))
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
	row.refresh = render
	table.insert(card.widgets, row)
	render()
	card._y = card._y - 42
	return row
end

local function makeGoldBtn(parent, width, height, text)
	local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
	btn:SetSize(width, height)
	btn:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	btn:SetBackdropColor(0.38, 0.25, 0.02, 0.95)
	btn:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	label:SetPoint("CENTER")
	label:SetText(text)
	label:SetTextColor(1, 0.92, 0.45)
	btn.label = label
	return btn
end

local function copyText(text)
	if type(text) ~= "string" or text == "" then
		return false
	end
	if CopyToClipboard then
		pcall(CopyToClipboard, text)
	end
	if ChatFrame_OpenChat then
		local ok = pcall(ChatFrame_OpenChat, text, DEFAULT_CHAT_FRAME)
		if ok then
			local box = DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox
			if box and box.HighlightText then
				pcall(box.HighlightText, box)
			end
			ns.Print(ns.T("INFO_COPIED"))
			return true
		end
	end
	return false
end

local function makeLinkRow(parent, labelKey, url)
	local row = CreateFrame("Frame", nil, parent)
	row:SetHeight(26)
	local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	label:SetPoint("LEFT", 0, 0)
	label:SetWidth(72)
	label:SetJustifyH("LEFT")
	label:SetTextColor(0.92, 0.92, 0.92)
	label:SetText(ns.T(labelKey))
	row.label = label
	row.labelKey = labelKey
	local box = CreateFrame("EditBox", nil, row, "BackdropTemplate")
	box:SetPoint("LEFT", label, "RIGHT", 6, 0)
	box:SetPoint("RIGHT", -58, 0)
	box:SetHeight(22)
	box:SetAutoFocus(false)
	box:SetFontObject("ChatFontSmall")
	box:SetTextInsets(4, 4, 2, 2)
	box:SetText(url)
	box:SetCursorPosition(0)
	box:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	box:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
	box:SetBackdropBorderColor(0.42, 0.42, 0.42, 1)
	box:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	box:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	row.box = box
	local copy = makeGoldBtn(row, 52, 22, ns.T("INFO_COPY"))
	copy:SetPoint("RIGHT", 0, 0)
	copy:SetScript("OnClick", function()
		if not copyText(url) then
			box:SetFocus()
			box:HighlightText()
		end
	end)
	row.copy = copy
	return row
end

local function paintTab(btn, selected)
	if selected then
		btn:SetBackdropColor(0.38, 0.25, 0.02, 0.95)
		btn:SetBackdropBorderColor(1, 0.82, 0.2, 1)
		btn.label:SetTextColor(1, 0.92, 0.45)
	else
		btn:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
		btn:SetBackdropBorderColor(0.42, 0.42, 0.42, 1)
		btn.label:SetTextColor(0.75, 0.75, 0.75)
	end
end

local function showTab(which)
	if not win then
		return
	end
	win.activeTab = which
	if win.ringPage then
		win.ringPage:SetShown(which == "ring")
	end
	if win.infoPage then
		win.infoPage:SetShown(which == "info")
	end
	for key, btn in pairs(win.tabs or {}) do
		paintTab(btn, key == which)
	end
end

local function ensure()
	if win then
		return win
	end
	win = CreateFrame("Frame", "ForeverRingOptions", UIParent, "BackdropTemplate")
	win:SetSize(560, 460)
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
	win.title = title
	local sub = win:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	sub:SetPoint("LEFT", title, "RIGHT", 8, 0)
	sub:SetText(ns.T("TITLE_SUB"))
	win.sub = sub
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

	win.tabs = {}
	local function makeTab(key, labelKey, x)
		local btn = CreateFrame("Button", nil, win, "BackdropTemplate")
		btn:SetSize(88, 24)
		btn:SetPoint("TOPLEFT", x, -40)
		btn:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 8,
			edgeSize = 8,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		})
		local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		label:SetPoint("CENTER")
		btn.label = label
		btn.labelKey = labelKey
		btn:SetScript("OnClick", function()
			showTab(key)
		end)
		win.tabs[key] = btn
		return btn
	end
	makeTab("ring", "TAB_RING", 16)
	makeTab("info", "TAB_INFO", 110)

	local ringPage = CreateFrame("Frame", nil, win)
	ringPage:SetPoint("TOPLEFT", 0, -70)
	ringPage:SetPoint("BOTTOMRIGHT", 0, 0)
	win.ringPage = ringPage

	local infoPage = CreateFrame("Frame", nil, win)
	infoPage:SetPoint("TOPLEFT", 0, -70)
	infoPage:SetPoint("BOTTOMRIGHT", 0, 0)
	win.infoPage = infoPage

	local ringCard = makeCard(ringPage, "OPT_CARD_CURSOR", 16, -4, 256, 200)
	addSwitch(ringCard, "showRing", "OPT_ENABLE_RING")
	addSwitch(ringCard, "showOutOfCombat", "OPT_OUT_OF_COMBAT")
	addSwitch(ringCard, "classColor", "OPT_CLASS_COLOR")
	addSlider(ringCard, "ringSize", 24, 128, "OPT_RING_SIZE")

	local castCard = makeCard(ringPage, "OPT_CARD_CAST", 288, -4, 256, 200)
	addSwitch(castCard, "showCast", "OPT_ENABLE_CAST")
	addSwitch(castCard, "onlyCombat", "OPT_ONLY_COMBAT")
	addSwitch(castCard, "showMinimap", "OPT_MINIMAP")

	local rangeCard = makeCard(ringPage, "OPT_CARD_RANGE", 16, -216, 528, 140)
	addSwitch(rangeCard, "showRange", "OPT_ENABLE_RANGE")
	addSwitch(rangeCard, "showRangeText", "OPT_RANGE_TEXT")
	addSwitch(rangeCard, "onlyEnemy", "OPT_ONLY_ENEMY")
	addSlider(rangeCard, "rangeGap", 8, 40, "OPT_RANGE_GAP")

	local about = makeCard(infoPage, "OPT_CARD_ABOUT", 16, -4, 528, 176)
	local body = about:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	body:SetPoint("TOPLEFT", 12, -30)
	body:SetPoint("TOPRIGHT", -12, -30)
	body:SetHeight(44)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetTextColor(0.92, 0.92, 0.92)
	win.aboutBody = body
	local points = about:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	points:SetPoint("TOPLEFT", 12, -78)
	points:SetPoint("TOPRIGHT", -12, -78)
	points:SetHeight(36)
	points:SetJustifyH("LEFT")
	points:SetJustifyV("TOP")
	points:SetWordWrap(true)
	points:SetTextColor(0.78, 0.86, 0.96)
	win.aboutPoints = points
	local credit = about:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	credit:SetPoint("TOPLEFT", 12, -120)
	credit:SetTextColor(1, 0.82, 0.2)
	win.aboutCredit = credit
	local support = about:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	support:SetPoint("TOPLEFT", 12, -140)
	support:SetPoint("RIGHT", -12, 0)
	support:SetJustifyH("LEFT")
	support:SetTextColor(0.72, 0.72, 0.72)
	win.aboutSupport = support

	local commands = makeCard(infoPage, "OPT_CARD_COMMANDS", 16, -192, 256, 168)
	local cmdHint = commands:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cmdHint:SetPoint("TOPLEFT", 12, -28)
	cmdHint:SetPoint("RIGHT", -12, 0)
	cmdHint:SetJustifyH("LEFT")
	cmdHint:SetTextColor(0.72, 0.72, 0.72)
	win.cmdHint = cmdHint
	local cmdList = commands:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cmdList:SetPoint("TOPLEFT", 12, -48)
	cmdList:SetPoint("RIGHT", -12, 0)
	cmdList:SetJustifyH("LEFT")
	cmdList:SetWordWrap(true)
	cmdList:SetTextColor(0.92, 0.92, 0.92)
	win.cmdList = cmdList

	local links = makeCard(infoPage, "OPT_CARD_LINKS", 288, -192, 256, 168)
	win.siteRow = makeLinkRow(links, "INFO_SITE", SITE_URL)
	win.siteRow:SetPoint("TOPLEFT", 12, -36)
	win.siteRow:SetPoint("RIGHT", -12, 0)
	win.discordRow = makeLinkRow(links, "INFO_DISCORD", DISCORD_URL)
	win.discordRow:SetPoint("TOPLEFT", 12, -72)
	win.discordRow:SetPoint("RIGHT", -12, 0)

	win.cards = { ringCard, castCard, rangeCard, about, commands, links }
	win:SetScript("OnShow", function()
		ns.RelocalizeOptions()
		showTab(win.activeTab or "ring")
	end)
	ns.RelocalizeOptions()
	showTab("ring")
	return win
end

function ns.RelocalizeOptions()
	if not win then
		return
	end
	if win.title then
		win.title:SetText(ns.T("TITLE"))
	end
	if win.sub then
		win.sub:SetText(ns.T("TITLE_SUB"))
	end
	if win.aboutBody then
		win.aboutBody:SetText(ns.T("INFO_ABOUT"))
	end
	if win.aboutPoints then
		win.aboutPoints:SetText(ns.T("INFO_ABOUT_POINTS"))
	end
	if win.aboutCredit then
		win.aboutCredit:SetText(ns.T("INFO_CREDIT"))
	end
	if win.aboutSupport then
		win.aboutSupport:SetText(ns.T("INFO_SUPPORT"))
	end
	if win.cmdHint then
		win.cmdHint:SetText(ns.T("INFO_CMD_HINT"))
	end
	if win.cmdList then
		win.cmdList:SetText(ns.T("INFO_CMD_LIST"))
	end
	for _, row in ipairs({ win.siteRow, win.discordRow }) do
		if row and row.label and row.labelKey then
			row.label:SetText(ns.T(row.labelKey))
		end
		if row and row.copy and row.copy.label then
			row.copy.label:SetText(ns.T("INFO_COPY"))
		end
	end
	for _, btn in pairs(win.tabs or {}) do
		if btn.label and btn.labelKey then
			btn.label:SetText(ns.T(btn.labelKey))
		end
	end
	if not win.cards then
		return
	end
	for _, card in ipairs(win.cards) do
		if card.title and card.titleKey then
			card.title:SetText(ns.T(card.titleKey))
		end
		for _, child in ipairs(card.widgets or {}) do
			if child.label and child.labelKey then
				child.label:SetText(ns.T(child.labelKey))
			end
			if child.switch and child.dbKey then
				paintSwitch(child.switch, featureOn(child.dbKey))
			end
			if child.refresh then
				child.refresh()
			end
		end
	end
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

