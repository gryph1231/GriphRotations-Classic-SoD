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

GriphRH.Spell[3] = {
	Default = Spell(30681),
	ChimeraShot = Spell(409433),
	ChimeraShotz = Spell(14280), --viper sting
	BestialWrath = Spell(19574),
	RaptorStrike = Spell(14262),
	AutoShot = Spell(75),
	AimedShot = Spell(19434),
	Multishot = Spell(14288),
	ExplosiveShot = Spell(409552),
	HeartoftheLion = Spell(409580),
	HeartoftheLionz = Spell(20190), --aspect of the wild
	AutoShotz = Spell(19263), --deterrence
	AutoAttack = Spell(6603),
	MendPet = Spell(3662),
	MendPetz = Spell(20549), --war stomp
	Carve = Spell(425711),
    WyvernSting = Spell(19386),
	AspectoftheViper = Spell(415423),
	AspectoftheMonkey = Spell(13163),
	AspectoftheViperz = Spell(13161), --aspect of the beast
	AspectoftheCheetah = Spell(5118),
	AspectoftheCheetahCancel = Spell(19878), --track demons
	Carvez = Spell(20594), --stoneform
	AspectoftheHawk = Spell(13165),
	ArcaneShot = Spell(3044),
	FlankingStrike = Spell(415320),
	FlankingStrikez = Spell(16832), --pet claw
	Counterattack = Spell(19306),
	SerpentSting = Spell(13550),
	WingClip = Spell(14267),
	ConcussiveShot = Spell(5116),
	FeedPet = Spell(6991),
	Flare = Spell(1543),
	FeedPetBuff = Spell(1539),
	FeignDeath = Spell(5384),
	FrostTrap = Spell(409520),
	ExplosiveTrap = Spell(409532),
	Disengage = Spell(14272),
	BloodFury = Spell(20572),
};

local S = GriphRH.Spell[3]

if not Item.Hunter then
    Item.Hunter = {}
end

Item.Hunter.BeastMastery = {
};
local I = Item.Hunter.BeastMastery;

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

local function CleaveCount()
local cleave_counter = 0

        for i=1,40 do
			local unitID = "nameplate" .. i
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if UnitCanAttack("player",unitID) and IsActionInRange(37,unitID) and UnitHealthMax(unitID) > 5 then
                        cleave_counter = cleave_counter + 1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function StingTime()
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

local function APL()
CleaveCount()
IsReady()
ManaPct()
PetActive()
PetHapiness()
StingTime()
--/dump GetMouseFocus().skillLineAbilityID

-- local function OnEvent(self, event, errorType, message, x)
	-- if self == 'player' and errorType == 'CRITICAL' then
		-- print('asdfadsfadsf')
	-- end
-- end

-- local f = CreateFrame("Frame")
-- f:RegisterEvent("UNIT_COMBAT")
-- f:SetScript("OnEvent", OnEvent)


local function OnEvent(self, event, unitTarget, event1, flagText, amount, schoolMask)
	if unitTarget == 'target' and event1 == 'DODGE' then
		print('asdfdsaf')
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_COMBAT")
f:SetScript("OnEvent", OnEvent)

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\mount2.tga", false
end

local AutoShot = 0

for ActionSlot = 1, 120 do
	local ActionText = GetActionTexture(ActionSlot)
	local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Auto Shot')
	
	if ActionText == icon then
		AutoShot = ActionSlot
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if GriphRH.queuedSpell[1]:CooldownRemains() > 2 or not UnitAffectingCombat('player')
	or (S.AspectoftheCheetah:ID() == GriphRH.queuedSpell[1]:ID() and AuraUtil.FindAuraByName("Aspect of the Cheetah", "player"))
	or (S.ConcussiveShot:ID() == GriphRH.queuedSpell[1]:ID() and IsSpellInRange('Auto Shot', 'target') == 0)
	or (S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and not CheckInteractDistance("target",3))
	or (S.BestialWrath:ID() == GriphRH.queuedSpell[1]:ID() and not PetActive())
	or (S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and not AuraUtil.FindAuraByName("Wing Clip", "target"))
	or ((S.FrostTrap:ID() == GriphRH.queuedSpell[1]:ID() or S.ExplosiveTrap:ID() == GriphRH.queuedSpell[1]:ID()) and (AuraUtil.FindAuraByName("Silence","HARMFUL") or AuraUtil.FindAuraByName("Sonic Burst","HARMFUL"))) then
	GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
end

if S.Flare:ID() == GriphRH.queuedSpell[1]:ID() and S.Flare:CooldownRemains() < 2 then
	return S.Flare:Cast()
end

if not (AuraUtil.FindAuraByName("Silence","player","PLAYER|HARMFUL") and AuraUtil.FindAuraByName("Sonic Burst","player","PLAYER|HARMFUL")) then
	if S.FrostTrap:ID() == GriphRH.queuedSpell[1]:ID() and S.FrostTrap:CooldownRemains() < 2 then
		return S.FrostTrap:Cast()
	end

	if S.ExplosiveTrap:ID() == GriphRH.queuedSpell[1]:ID() and S.ExplosiveTrap:CooldownRemains() < 2 then
		return S.ExplosiveTrap:Cast()
	end
end

if S.AspectoftheCheetah:ID() == GriphRH.queuedSpell[1]:ID() and S.AspectoftheCheetah:CooldownRemains() < 2 then
	return S.AspectoftheCheetah:Cast()
end

if S.BestialWrath:ID() == GriphRH.queuedSpell[1]:ID() and PetActive() and S.BestialWrath:CooldownRemains() < 2 then
	return S.BestialWrath:Cast()
end

if S.BloodFury:ID() == GriphRH.queuedSpell[1]:ID() and S.BloodFury:CooldownRemains() < 2 then
	return S.BloodFury:Cast()
end

if S.ConcussiveShot:ID() == GriphRH.queuedSpell[1]:ID() and S.ConcussiveShot:CooldownRemains() < 2 then
	return S.ConcussiveShot:Cast()
end

if S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and S.WingClip:CooldownRemains() < 2 then
	return S.WingClip:Cast()
end

-- if GriphRH.QueuedSpell():CanCast() then
	-- return GriphRH.QueuedSpell():Cast()
-- end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() then
	if IsReady('Feed Pet') and (PetHapiness() == 'Content' or PetHapiness() == 'Unhappy') and PetActive() and not Pet:Buff(S.FeedPetBuff) then 
		return S.FeedPet:Cast() 
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if Player:AffectingCombat() and AuraUtil.FindAuraByName("Aspect of the Cheetah", "player")
and ((AuraUtil.FindAuraByName("Dazed", "player") and UnitAffectingCombat('player'))
or CleaveCount() >= 1 or S.AutoShot:InFlight()) then
	return S.AspectoftheCheetahCancel:Cast()
end

if IsReady('Heart of the Lion') and not Player:Buff(S.HeartoftheLion) then
	return S.HeartoftheLionz:Cast()
end

if IsReady('Aspect of the Viper') and ManaPct() < 25 and not AuraUtil.FindAuraByName("Aspect of the Viper", "player") 
and ((not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player") and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")) 
or (UnitAffectingCombat('player') and CheckInteractDistance("target",3))) then
	return S.AspectoftheViperz:Cast()
end

if UnitCanAttack('player', 'target') and (UnitAffectingCombat('target') or IsCurrentSpell(6603) or IsAutoRepeatAction(AutoShot)) and not Target:IsDeadOrGhost() then 
	if not IsAutoRepeatAction(AutoShot) and not Player:IsMoving() and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.AutoShotz:Cast()
	end

	if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Counterattack') and CheckInteractDistance("target",3) and UnitIsPlayer("target") then
		return S.Counterattack:Cast()
	end

	if IsReady('Carve') and CheckInteractDistance("target",3) and CleaveCount() >= 3 then
		return S.Carvez:Cast()
	end
	
	if IsReady('Flanking Strike',1) and CheckInteractDistance("target",3) then
		return S.FlankingStrikez:Cast()
	end

	if IsReady('Raptor Strike') and CheckInteractDistance("target",3) then
		return S.RaptorStrike:Cast()
	end

	if IsReady('Carve') and CheckInteractDistance("target",3) and IsCurrentSpell(6603) then
		return S.Carvez:Cast()
	end

	if CheckInteractDistance("target",3) then
		if IsReady('Aspect of the Hawk') and ManaPct() > 20 and (S.RaptorStrike:CooldownRemains() > 1 and S.FlankingStrike:CooldownRemains() > 1 and (S.Carve:CooldownRemains() > 1 or CleaveCount() < 3))
		and not AuraUtil.FindAuraByName("Aspect of the Hawk", "player")
		and not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player")
		and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")
		and (not AuraUtil.FindAuraByName("Aspect of the Viper", "player") or ManaPct() == 100)
		and not AuraUtil.FindAuraByName("Aspect of the Monkey", "player") then
			if PetActive() or IsAutoRepeatAction(AutoShot) or not UnitIsPlayer('target') then
				return S.AspectoftheHawk:Cast()
			elseif not PetActive() and (IsCurrentSpell(6603) or UnitIsPlayer('target')) then
				return S.AspectoftheMonkey:Cast()
			end
		end
	elseif not CheckInteractDistance("target",3) then
		if IsReady('Aspect of the Hawk') and ManaPct() > 20 
		and ((S.Multishot:CooldownRemains() > 1 or Player:IsMoving() and not GriphRH.CDsON()) 
		or ((S.Multishot:CooldownRemains() > 1 or Player:IsMoving()) and (S.SerpentSting:CooldownRemains() > 1 
		or AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL")) and S.ArcaneShot:CooldownRemains() > 1 and GriphRH.CDsON()))
		and not AuraUtil.FindAuraByName("Aspect of the Hawk", "player")
		and not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player")
		and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")
		and (not AuraUtil.FindAuraByName("Aspect of the Viper", "player") or ManaPct() == 100)
		and not AuraUtil.FindAuraByName("Aspect of the Monkey", "player") then
			if PetActive() or IsAutoRepeatAction(AutoShot) or not UnitIsPlayer('target') then
				return S.AspectoftheHawk:Cast()
			elseif not PetActive() and (IsCurrentSpell(6603) or UnitIsPlayer('target')) then
				return S.AspectoftheMonkey:Cast()
			end
		end
	end

	-- if IsReady('Concussive Shot',1) then
		-- return S.ConcussiveShot:Cast()
	-- end

	if IsReady('Chimera Shot',1) or IsReady('Explosive Shot',1) then
		return S.ChimeraShotz:Cast()
	end

	if IsReady('Multi-Shot',1) and not Player:IsMoving() then
		return S.Multishot:Cast()
	end

	if IsReady('Serpent Sting',1) and UnitName('target') ~= "Incendiary Bomb" and not S.SerpentSting:InFlight() and GriphRH.CDsON() 
	and (not AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL") 
	or (AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL") and StingTime() <= Player:GCD())) then
		return S.SerpentSting:Cast()
	end

	if IsReady('Arcane Shot',1) and GriphRH.CDsON() then
		return S.ArcaneShot:Cast()
	end
end

	return "Interface\\Addons\\Griph-RH-Classic\\Media\\mount2.tga", false
end

GriphRH.Rotation.SetAPL(3, APL);
GriphRH.Rotation.SetPvP(3, PvP)
GriphRH.Rotation.SetPASSIVE(3, PASSIVE);