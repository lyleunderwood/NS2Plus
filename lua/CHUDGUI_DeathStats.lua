Script.Load("lua/GUIAnimatedScript.lua")

class 'CHUDGUI_DeathStats' (GUIAnimatedScript)

CHUDStatsVisible = false

local kTitleFontName = "fonts/AgencyFB_medium.fnt"
local kStatsFontName = "fonts/AgencyFB_small.fnt"
local kTopOffset = GUIScale(64)
local kFontScale = GUIScale(Vector(1, 1, 0))
local kTitleBackgroundTexture = "ui/objective_banner_marine.dds"
local kTitleBackgroundSize = GUIScale(Vector(210, 45, 0))

local function CHUDGetStatsString()
	local hitssum = 0
	local missessum = 0
	local overallacc = 0
	local lastacc = 0
	
	local statsString = ""
	
	// Weapons that contribute to accuracy
	local trackacc =
	{
		kTechId.Pistol, kTechId.Rifle, kTechId.Minigun, kTechId.Railgun, kTechId.Shotgun,
		kTechId.Axe, kTechId.Bite, kTechId.Parasite, kTechId.Spit, kTechId.Swipe, kTechId.Gore,
		kTechId.LerkBite, kTechId.Spikes, kTechId.Stab
	}
	
	if #CHUDStats > 0 then
		
		for i, wStats in pairs(CHUDStats) do
			if table.contains(trackacc, wStats["weapon"]) then
				hitssum = hitssum + wStats["hits"]
				missessum = missessum + wStats["misses"]
			end
		end

		if hitssum > 0 or missessum > 0 then
			overallacc = hitssum/(hitssum+missessum)*100
			lastacc = (hitssum-CHUD_hits)/((hitssum-CHUD_hits)+(missessum-CHUD_misses))*100
		end
		
		CHUD_hits = hitssum
		CHUD_misses = missessum
		
		statsString = statsString .. string.format("Last life accuracy: %.2f%%\n", lastacc)
		statsString = statsString .. string.format("Player damage: %d\nStructure damage: %d\n\n", math.ceil(CHUD_pdmg), math.ceil(CHUD_sdmg))
		statsString = statsString .. string.format("Current accuracy: %.2f%%\n", overallacc)
		
		CHUD_pdmg = 0
		CHUD_sdmg = 0
	end
	
	return statsString
end


function CHUDGUI_DeathStats:Initialize()

	GUIAnimatedScript.Initialize(self)

	self.titleBackground = self:CreateAnimatedGraphicItem()
	self.titleBackground:SetTexture(kTitleBackgroundTexture)
	self.titleBackground:SetIsScaling(false)
	self.titleBackground:SetColor(Color(1, 1, 1, 0))
	self.titleBackground:SetAnchor(GUIItem.Middle, GUIItem.Top)
	self.titleBackground:SetPosition(Vector(-kTitleBackgroundSize.x/2, kTopOffset, 0))
	self.titleBackground:SetSize(kTitleBackgroundSize)
	self.titleBackground:SetLayer(kGUILayerPlayerHUD)
	
	self.titleShadow = GetGUIManager():CreateTextItem()
	self.titleShadow:SetFontName(kTitleFontName)
	self.titleShadow:SetAnchor(GUIItem.Middle, GUIItem.Middle)
	self.titleShadow:SetTextAlignmentX(GUIItem.Align_Center)
	self.titleShadow:SetTextAlignmentY(GUIItem.Align_Center)
	self.titleShadow:SetPosition(GUIScale(Vector(0, 3, 0)))
	self.titleShadow:SetText("Last life stats")
	self.titleShadow:SetColor(Color(0, 0, 0, 1))
	self.titleShadow:SetScale(kFontScale)
	self.titleShadow:SetInheritsParentAlpha(true)
	self.titleBackground:AddChild(self.titleShadow)
	
    self.titleText = GetGUIManager():CreateTextItem()
    self.titleText:SetFontName(kTitleFontName)
	self.titleText:SetTextAlignmentX(GUIItem.Align_Center)
	self.titleText:SetTextAlignmentY(GUIItem.Align_Center)
	self.titleText:SetPosition(GUIScale(Vector(-2, -2, 0)))
	self.titleText:SetText("Last life stats")
	self.titleText:SetScale(kFontScale)
	self.titleText:SetInheritsParentAlpha(true)
	self.titleShadow:AddChild(self.titleText)
	
	self.statsText = GetGUIManager():CreateTextItem()
	self.statsText:SetFontName(kStatsFontName)
    self.statsText:SetAnchor(GUIItem.Left, GUIItem.Top)
	self.statsText:SetPosition(GUIScale(Vector(10, 45, 0)))
	self.statsText:SetScale(kFontScale)
	self.statsText:SetInheritsParentAlpha(true)
	self.titleBackground:AddChild(self.statsText)
	
	self.timePassed = 10
	self.messageShown = true
	
	self.lastIsDead = PlayerUI_GetIsDead() and Client.GetIsControllingPlayer() and not PlayerUI_GetIsSpecating()
	
	self.requestVisible = false
	
end

function CHUDGUI_DeathStats:Reset()

    GUIAnimatedScript.Reset(self)
	
end

function CHUDGUI_DeathStats:Update(deltaTime)

	GUIAnimatedScript.Update(self, deltaTime)

	local displayTime = 8
	
	local isDead = PlayerUI_GetIsDead() and Client.GetIsControllingPlayer() and not PlayerUI_GetIsSpecating()
	
	// Hide the stats when you're alive
	// When getting beaconed right after dying you could still see the UI
	// Also makes training with cheats in a private server not horrible
	local visible = not Client.GetIsControllingPlayer() or PlayerUI_GetIsThirdperson() or isDead
	self.titleBackground:SetIsVisible(self.requestVisible or visible and CHUDGetOption("deathstats") == 2)
	
	if isDead ~= self.lastIsDead then
	
		self.lastIsDead = isDead
	
		if self.lastIsDead == true then
			self.timePassed = 0
			self.messageShown = false
			if CHUD_pdmg > 0 or CHUD_sdmg > 0 then
				local statsString = CHUDGetStatsString()
				if statsString ~= "" then
					self.statsText:SetText(statsString)
					if not self.requestVisible then
						self.titleBackground:FadeIn(2, "CHUD_DEATHSTATS")
					end
				end
			end
		end
	else
		if self.timePassed < displayTime then
			self.timePassed = self.timePassed + deltaTime
		else
			if self.messageShown == false then
				self.titleBackground:FadeOut(2, "CHUD_DEATHSTATS")
				self.messageShown = true
			end
		end		
	end
	
	if self.titleBackground:GetColor().a > 0 then
		CHUDStatsVisible = true
	else
		CHUDStatsVisible = false
	end
	
end

function CHUDGUI_DeathStats:SendKeyEvent(key, down)

	// Force show when request menu is open
	if GetIsBinding(key, "RequestMenu") and CHUDGetOption("deathstats") > 0 then
		self.titleBackground:SetIsVisible(down)
		self.requestVisible = down
		self.titleBackground:SetColor(Color(1, 1, 1, ConditionalValue(down, 1, 0)))
	end
	
end

function CHUDGUI_DeathStats:Uninitialize()

	GUIAnimatedScript.Uninitialize(self)

	GUI.DestroyItem(self.titleBackground)
	self.titleBackground = nil
	
end

local originalAlienSpecUpdate
originalAlienSpecUpdate = Class_ReplaceMethod( "GUIAlienSpectatorHUD", "Update",
	function(self, deltaTime)
		originalAlienSpecUpdate(self, deltaTime)
		self.eggIcon:SetIsVisible(self.eggIcon:GetIsVisible() and not CHUDStatsVisible)
	end)
		
local originalBalanceUpdate
originalBalanceUpdate = Class_ReplaceMethod( "GUIWaitingForAutoTeamBalance", "Update",
	function(self, deltaTime)
		self.waitingText:SetIsVisible(PlayerUI_GetIsWaitingForTeamBalance() and not CHUDStatsVisible)
	end)