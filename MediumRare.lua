
local myname, ns = ...


local mobIDs = {
	[33776] = true, -- Gondria
	[38453] = true, -- Arcturis
}


local myfullname = GetAddOnMetadata(myname, "Title")
local function Print(...) print("|cFF33FF99".. myfullname.. "|r:", ...) end


for _,achID in pairs{1312, 2257} do
	for i=1,GetAchievementNumCriteria(achID) do
		local _, critType, completed, _, _, _, _, mobID = GetAchievementCriteriaInfo(achID, i)
		if not completed and critType == 0 then mobIDs[mobID] = true end
	end
end


local tip = CreateFrame("GameTooltip")
tip:SetOwner(WorldFrame, "ANCHOR_NONE")
local tiptext = tip:CreateFontString()
tip:AddFontStrings(tiptext, tip:CreateFontString())
local function Test(id)
	tip:ClearLines()
	if not tip:IsOwned(WorldFrame) then tip:SetOwner(WorldFrame, "ANCHOR_NONE") end
	tip:SetOwner(WorldFrame, "ANCHOR_NONE")
	tip:SetHyperlink(("unit:0xF5300%05X000000"):format(id))
	return tip:IsShown() and tiptext:GetText()
end


local f, e, firstscan = CreateFrame("Frame"), 0, true
f:SetScript("OnUpdate", function(self, elap)
	e = e + elap
	if e < 1 then return end
	e = 0

	local seen
	for mobID in pairs(mobIDs) do
		local name = Test(mobID)
		if name then
			if not firstscan then
				if not IsResting() then
					PlaySoundFile("Interface\\AddOns\\MediumRare\\alert.wav")
					RaidNotice_AddMessage(RaidBossEmoteFrame, "Found rare mob: "..name, ChatTypeInfo["RAID_WARNING"])
					Print("Found rare mob:", name)
				end
			else
				seen = true
				Print("Already seen mob:", name)
			end
			mobIDs[mobID] = nil
		end
	end
	if seen then Print("To reset your cache log out of the game and delete the file <WoW>/Cache/WDB/"..GetLocale().."/creaturecache.wdb") end
	firstscan = nil
end)
