local addonName, ns = ...

local defaults = {
	enabled = true,
	showRing = true,
	showCast = true,
	showRange = true,
	showRangeText = true,
	showOutOfCombat = true,
	onlyCombat = false,
	onlyEnemy = false,
	hideDead = true,
	classColor = true,
	ringSize = 48,
	rangeGap = 18,
	ringColor = { 1, 0.82, 0.2 },
}

local function applyDefaults(db)
	db = db or {}
	for key, value in pairs(defaults) do
		if db[key] == nil then
			db[key] = value
		end
	end
	return db
end

function ns.Print(msg)
	print("|cffd4a017Forever|r |cff66ccffRing|r: " .. (msg or ""))
end

local function start()
	ForeverRingDB = applyDefaults(ForeverRingDB)
	ns.db = ForeverRingDB
	ns.CreateRing()
	ns.ApplyRingSettings()
	if not ns.ticker then
		ns.ticker = C_Timer.NewTicker(0.2, function()
			if ns.UpdateRingCombat then
				ns.UpdateRingCombat()
			end
		end)
	end
	ns.Print(ns.T("INIT"))
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", function(_, event, name)
	if event == "ADDON_LOADED" and name == addonName then
		start()
	elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED"
		or event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
		if ns.ApplyRingSettings then
			ns.ApplyRingSettings()
		end
		if ns.UpdateRingCombat then
			ns.UpdateRingCombat()
		end
	end
end)

SLASH_FOREVERRING1 = "/fring"
SLASH_FOREVERRING2 = "/foreverring"
SlashCmdList["FOREVERRING"] = function(msg)
	msg = string.lower(msg or "")
	if msg == "options" or msg == "config" or msg == "menu" then
		ns.ToggleOptions()
	elseif msg == "toggle" then
		ns.db.enabled = not (ns.db.enabled ~= false)
		ns.ApplyRingSettings()
		ns.Print(ns.db.enabled ~= false and ns.T("LOCKED") or ns.T("UNLOCKED"))
	else
		ns.Print(ns.T("HELP"))
	end
end
