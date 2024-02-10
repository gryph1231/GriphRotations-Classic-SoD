--- Localize Vars
-- Addon
local addonName, addonTable = ...;

-- HeroLib
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;
local Pet = Unit.Pet;

RubimRH.Spell[3] = {
	Default = Spell(30681),
	ChimeraShot = Spell(409433),
	ChimeraShotz = Spell(14280), --viper sting
	RaptorStrike = Spell(14262),
	AutoShot = Spell(75),
	AimedShot = Spell(19434),
	Multishot = Spell(2643),
	HeartoftheLion = Spell(409580),
	HeartoftheLionz = Spell(20190), --aspect of the wild
	AutoShotz = Spell(19263), --deterrence
	AutoAttack = Spell(6603),
	AspectoftheHawk = Spell(13165),
	ArcaneShot = Spell(3044),
	FlankingStrike = Spell(415320),
	FlankingStrikez = Spell(19306), --counterattack
	SerpentSting = Spell(13550),
	FeedPet = Spell(6991),
	FeedPetBuff = Spell(1539),
	FeignDeath = Spell(5384),
};

local S = RubimRH.Spell[3]

if not Item.Hunter then
    Item.Hunter = {}
end
Item.Hunter.BeastMastery = {
};
local I = Item.Hunter.BeastMastery;


S.AimedShot.TextureSpellID = { 1 }
S.AutoShot:RegisterInFlight()
S.SerpentSting:RegisterInFlight()

local function num(val)
    if val then
        return 1
    else
        return 0
    end
end

local function bool(val)
    return val ~= 0
end

local function RangeCount(range_check)
local range_counter = 0
    
	if range_check then
		for i=1,40 do
			local unitID = "nameplate" .. i
			if UnitExists("nameplate"..i) then           
				local nameplate_guid = UnitGUID("nameplate"..i) 
				local npc_id = select(6, strsplit("-",nameplate_guid))
				if npc_id ~='120651' and npc_id ~='161895' then
					if UnitCanAttack("player",unitID) and IsActionInRange(range_check,unitID) and UnitHealthMax(unitID) > 5
					and UnitName(unitID) ~= "Incorporeal Being" then
						range_counter = range_counter + 1
					end                    
				end
			end
		end
	else
		range_counter = 0
	end
    
    return range_counter
end

local function CleaveCount()
local cleave_counter = 0
     
        for i=1,40 do
			local unitID = "nameplate" .. i
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if UnitCanAttack("player",unitID) and IsActionInRange(37,unitID) and UnitHealthMax(unitID) > 5
					and UnitName(unitID) ~= "Incorporeal Being"	then
                        cleave_counter = cleave_counter + 1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function TargetinRange(range_check)
	if range_check then
		if IsActionInRange(range_check,"target") then
			return true
		else
			return false
		end
	else
		return false	
	end
end

local function stingTime()
local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL")

if expirationTime then
	timer = expirationTime - HL.GetTime()
else
	timer = nil
end
    return timer
end

local function PetHapiness()
local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local happy = ({"Unhappy", "Content", "Happy"})[happiness]
	local loyalty = loyaltyRate > 0 and "gaining" or "losing"
	-- print("Pet is "..happy)
	-- print("Pet is doing "..damagePercentage.."% damage")
	-- print("Pet is "..loyalty.." loyalty")
	return happy
end

local function ManaPct()
    return (UnitPower("Player", 0) / UnitPowerMax("Player", 0)) * 100
end

local function PetActive()
    local petActive = false
    if Pet:Exists() then
        petActive = true
    end

    if Pet:IsActive() then
        petActive = true
    end

    if Pet:IsDeadOrGhost() then
        petActive = false
    end

    return petActive
end

local function SwingTime()
	--1.11 = quiver speed
	local haste = 1.11 * (1 + GetRangedHaste()/100)
	local ASCast = 0.5 / haste
	
	-- speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player");
	-- local f = CreateFrame("Frame")
		-- f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		-- f:SetScript("OnEvent", function(self, event)

		-- local _, subevent, _, sourceGUID, _, _, _, _, destName = CombatLogGetCurrentEventInfo()

		-- local spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
		
		
		-- if subevent == "SPELL_CAST_START" and spellId == 75 then
			-- AutoCheck = GetTime()
		-- end
	-- end)
	
	-- if AutoCheck and AutoCheck > 0 then
		-- return (speed - ASCast) - (GetTime() - AutoCheck)
	-- else
		-- return 0
	-- end
	
	-- FD resets swing timer**
	-- if S.FeignDeath:CooldownRemains() >= 30 - (UnitRangedDamage("player") - ASCast) then 
		-- Swing = (UnitRangedDamage("player") - ASCast) - (30 - S.FeignDeath:CooldownRemains()) 
	-- else
	local Swing = (UnitRangedDamage("player") - ASCast) - S.AutoShot:TimeSinceLastCast()
	--end
	
	if Swing and Swing > 0 then
		return Swing
	else
		return 0
	end
end

local function SpellRank(spell_name)

	if spell_name then
		local _,_,_,_,_,_,spellID,_ = GetSpellInfo(spell_name)
		
		return spellID
	else
		return 0
	end

end

local function IsReady(spell,range_check,aoe_check)
	local start,duration,enabled = GetSpellCooldown(tostring(spell))
	local usable, noMana = IsUsableSpell(tostring(spell))
	local range_counter = 0
	local in_range = false

	for lActionSlot = 1, 120 do
		local lActionText = GetActionTexture(lActionSlot)
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spell)
	
		if lActionText == icon then
			if UnitExists("target") then
				in_range = IsActionInRange(lActionSlot,"target")
			end
		end
	end

	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	
	-- if gcd_remains and gcd_remains < 0 then 
		-- gcd_remains = 0 
	-- end

	if aoe_check then
		if Spell then
			for i = 1, 40 do
				local unitID = "nameplate" .. i
				if UnitExists(unitID) then           
					local nameplate_guid = UnitGUID(unitID) 
					local npc_id = select(6, strsplit("-", nameplate_guid))
					if npc_id ~= '120651' and npc_id ~= '161895' then
						if UnitCanAttack("player", unitID) and IsSpellInRange(Spell, unitID) == 1 and UnitHealthMax(unitID) > 5 then
							range_counter = range_counter + 1
						end                    
					end
				end
			end
		end
	end

	--if usable and enabled and cooldown_remains - gcd_remains < 0.5 and gcd_remains < 0.5 then
	if usable and enabled and cooldown_remains < 0.5 then
		if range_check then
			if in_range == true then 
				return true
			else
				return false
			end
		elseif aoe_check and not range_check then
			if range_counter >= aoe_check then
				return true
			else
				return false
			end
		elseif range_check and aoe_check then
			return 'Input range check or aoe check, not both'
		elseif not range_check and not aoe_check then
			return true
		end
	else
		return false
	end
end

local lastMoveTime = GetTime()  -- Initialize with the current time

-- Function to get the time since last moved
local function TimeSinceLastMoved()
    return GetTime() - lastMoveTime
end

-- Frame to track player movement
local moveFrame = CreateFrame("Frame")
moveFrame:SetScript("OnUpdate", function(self, elapsed)
    local currentSpeed = GetUnitSpeed("player")
    if currentSpeed > 0 then
        -- Update the last move time to the current time if the player is moving
        lastMoveTime = GetTime()
    end
end)

local function APL()
SwingTime()
RangeCount()
TargetinRange()
CleaveCount()
IsReady()
ManaPct()
PetActive()
PetHapiness()
stingTime()
SpellRank()
TimeSinceLastMoved()

if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end 

--1.11 = quiver speed
local MultiShotTime = 0.5 / (1.11 * (1 + GetRangedHaste() / 100))
local AimedShotTime = 3 / (1.11 * (1 + GetRangedHaste() / 100))
local AutoShot = 0

for ActionSlot = 1, 120 do
	local ActionText = GetActionTexture(ActionSlot)
	local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Auto Shot')
	
	if ActionText == icon then
		AutoShot = ActionSlot
	end
end

if not Player:AffectingCombat() then
	if IsReady('Feed Pet') and (PetHapiness() == 'Content' or PetHapiness() == 'Unhappy') and PetActive() and not Pet:Buff(S.FeedPetBuff) then 
		return S.FeedPet:Cast() 
	end
end

if IsReady('Heart of the Lion') and not Player:Buff(S.HeartoftheLion) then
	return S.HeartoftheLionz:Cast()
end

if IsReady('Aspect of the Hawk') and not AuraUtil.FindAuraByName("Aspect of the Hawk", "player")
and not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player")
and not AuraUtil.FindAuraByName("Aspect of the Monkey", "player") then
	return S.AspectoftheHawk:Cast()
end

if UnitCanAttack('player', 'target') and (UnitAffectingCombat('target') or IsCurrentSpell(6603) or IsAutoRepeatAction(AutoShot)) and not Target:IsDeadOrGhost() then 
	if not IsAutoRepeatAction(AutoShot) and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.AutoShotz:Cast()
	end

	if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		return Item(135274, { 13, 14 }):ID()
	end
	
	if IsReady('Raptor Strike') and CheckInteractDistance("target",3) and not IsCurrentSpell(SpellRank('Raptor Strike')) and IsCurrentSpell(6603) then
		return S.RaptorStrike:Cast()
	end
	
	if IsReady('Flanking Strike',1) and CheckInteractDistance("target",3) then
		return S.FlankingStrikez:Cast()
	end

	if IsReady('Multi-Shot',1) and not Player:IsMoving() and SwingTime() > MultiShotTime then
		return S.Multishot:Cast()
	end

	if IsReady('Serpent Sting',1) and not S.SerpentSting:InFlight() and RubimRH.CDsON() 
	and (not AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL") 
	or (AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL") and stingTime() <= Player:GCD())) then
		return S.SerpentSting:Cast()
	end

	if IsReady('Chimera Shot',1) then
		return S.ChimeraShotz:Cast()
	end

	if IsReady('Aimed Shot',1) and RubimRH.CDsON() and TimeSinceLastMoved() > 0.5
	and (SwingTime() > AimedShotTime or S.AutoShot:InFlight()) then
		return S.AimedShot:Cast()
	end

	if IsReady('Arcane Shot',1) and RubimRH.CDsON() and (Player:MovingFor() > 0.5 or not IsReady('Aimed Shot',1)) then
		return S.ArcaneShot:Cast()
	end
end

	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

-- TimeSinceLastCast() <= gcd + casttime?
-- swing timer total - TimeSinceLastCast() = swing time remaining
-- swing timer total = tooltip atk speed - 0.5 (atk cast) - UnitRangedDamage("player")
-- (UnitRangedDamage("player") - 0.5) - TimeSinceLastCast() = swing time remaining


RubimRH.Rotation.SetAPL(3, APL);
RubimRH.Rotation.SetPvP(3, PvP)
RubimRH.Rotation.SetPASSIVE(3, PASSIVE);