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

GriphRH.Spell[4] = {
	Default = Spell(30681),
	Stealth = Spell(1784),
	Eviscerate = Spell(2098),
	Pull = Spell(6603),
	ExposeArmor = Spell(26866),
	Garrote = Spell(48676),
	CheapShot = Spell(1833),
	Rupture = Spell(48672),
	SliceandDiceR1 = Spell(5171),
	SliceandDiceR2 = Spell(6774),
	Backstab = Spell(53),
	Evasion = Spell(26669),
	DeadlyPoisonDebuff = Spell(434312),
	KidneyShot = Spell(408),
	Feint = Spell(48659),
	Gouge = Spell(1776),
	BladeFlurry = Spell(13877),
	AdrenalineRush = Spell(13750),
	Kick = Spell(1766),
	ColdBlood = Spell(14177),
	Shiv = Spell(5938),
	Ambush = Spell(462721),
	Distract = Spell(1725),
	Blind = Spell(2094),
	--ThistleTea = Spell(),
	SinisterStrike = Spell(1752),
	Shadowstrike = Spell(399985),
	Mutilate = Spell(399960),
	Envenom = Spell(399963),
	BetweenTheEyes = Spell(400009),
	PoisonedKnife = Spell(425012),
	ShurikenToss = Spell(399986),
	CloakRune = Spell(20594), --stoneform
};

local S = GriphRH.Spell[4]

if not Item.Rogue then
    Item.Rogue = {}
end

Item.Rogue = {

};

local I = Item.Rogue;

if not behindCheck1 then
    behindCheck1 = CreateFrame("Frame")
end

local BehindCheckTimer = 0
local FrontCheckTimer = 0

local frame = behindCheck1
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:SetScript("OnEvent", function(self,event,errorType,message)
	if message == 'You must be behind your target' then
		BehindCheckTimer = GetTime()
	elseif message == 'You must be in front of your target' then
		FrontCheckTimer = GetTime()
	end	
end)

local function EnvenomDMG()
	--Evis base damage (the numbers listed in the ability description) + AP*0.15
	--https://dpscalculator.blogspot.com/2006/07/112-attack-power-scaling-with.html
	--https://www.wowhead.com/classic/news/class-and-spell-changes-datamined-season-of-discovery-phase-4-ptr-344182
	if AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL') then
		_, _, deadly_poison_stacks = AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL')
	else
		deadly_poison_stacks = 0
	end
	
	if AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL') then
		_, _, deadly_poison_stacksII = AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL')
	else
		deadly_poison_stacksII = 0
	end
	
	if AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL') then
		_, _, deadly_poison_stacksIII = AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL')
	else
		deadly_poison_stacksIII = 0
	end
	
	if AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL') then
		_, _, deadly_poison_stacksIV = AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL')
	else
		deadly_poison_stacksIV = 0
	end

	if AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL') then
		_, _, occult_poison_stacksI = AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL')
	else
		occult_poison_stacksI = 0
	end

	local envenom_damage = 0
	
	if (deadly_poison_stacks or deadly_poison_stacksII or deadly_poison_stacksIII or deadly_poison_stacksIV or occult_poison_stacksI) and not UnitIsPlayer('target') then
		if (deadly_poison_stacks >= 1 or deadly_poison_stacksII >= 1 or deadly_poison_stacksIII >= 1 or deadly_poison_stacksIV >= 1 or occult_poison_stacksI >= 1) and Player:ComboPoints() >= 1 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 1 + attack_power * 0.072
		end

		if (deadly_poison_stacks >= 2 or deadly_poison_stacksII >= 2 or deadly_poison_stacksIII >= 2 or deadly_poison_stacksIV >= 2 or occult_poison_stacksI >= 2) and Player:ComboPoints() >= 2 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 2 + attack_power * 0.144
		end

		if (deadly_poison_stacks >= 3 or deadly_poison_stacksII >= 3 or deadly_poison_stacksIII >= 3 or deadly_poison_stacksIV >= 3 or occult_poison_stacksI >= 3) and Player:ComboPoints() >= 3 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 3 + attack_power * 0.216
		end

		if (deadly_poison_stacks >= 4 or deadly_poison_stacksII >= 4 or deadly_poison_stacksIII >= 4 or deadly_poison_stacksIV >= 4 or occult_poison_stacksI >= 4) and Player:ComboPoints() >= 4 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 4 + attack_power * 0.288
		end

		if (deadly_poison_stacks >= 5 or deadly_poison_stacksII >= 5 or deadly_poison_stacksIII >= 5 or deadly_poison_stacksIV >= 5 or occult_poison_stacksI >= 5) and Player:ComboPoints() >= 5 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 5 + attack_power * 0.36
		end
	end

	return envenom_damage + buffer
end

local function EviscerateDMG()
	local eviscerate_damage = 0

	if not UnitIsPlayer('target') then
		if Player:ComboPoints() == 1 then
			eviscerate_damage = 199 + buffer
		end

		if Player:ComboPoints() == 2 then
			eviscerate_damage = 350 + buffer
		end

		if Player:ComboPoints() == 3 then
			eviscerate_damage = 501 + buffer
		end

		if Player:ComboPoints() == 4 then
			eviscerate_damage = 652 + buffer
		end

		if Player:ComboPoints() == 5 then
			eviscerate_damage = 803 + buffer
		end
	end

	return eviscerate_damage
end

local function CTRefreshableAOE(pandemic)
	local CTRefreshable8 = 0
	local MissingCT = 0

    for id = 1, 40 do
		local unitID = "nameplate" .. id
		local immune = UnitName(unitID) == "Skeletal Berserker" or UnitName(unitID) == "Skeletal Guardian" or UnitName(unitID) == "Shrieking Banshee" or UnitName(unitID) == "Skeletal Servant" or UnitName(unitID) == "Risen Guard"
		or UnitName(unitID) == "Risen Lackey" or UnitName(unitID) == "Risen Protector" or UnitName(unitID) == "Spectral Tutor" or UnitName(unitID) == "Risen Aberration" or UnitName(unitID) == "Risen Construct" 
		or UnitName(unitID) == "Spectral Teacher" or UnitName(unitID) == "Risen Bonewarder" or UnitName(unitID) == "Splintered Skeleton" or UnitName(unitID) == "Arcane Aberration" or UnitName(unitID) == "Mana Remnant" 
		or UnitName(unitID) == "Eldreth Spirit" or UnitName(unitID) == "Eldreth Apparition" or UnitName(unitID) == "Arcane Feedback" or UnitName(unitID) == "Arcane Torrent" or UnitName(unitID) == "Black Guard Sentry"
		or UnitName(unitID) == "Mindless Undead" or UnitName(unitID) == "Spectral Projection" or UnitName(unitID) == "Scholomance Occultist"
		
		local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Crimson Tempest",unitID,"PLAYER|HARMFUL")
		
		if AuraUtil.FindAuraByName("Crimson Tempest",unitID,"PLAYER|HARMFUL") then
			timerCT = expirationTime - HL.GetTime()
		else
			timerCT = nil
		end

		if timerCT and pandemic then 
			if UnitCanAttack("player", unitID) and not immune and IsSpellInRange("Shoot Bow",unitID) == 0 and UnitHealth(unitID) > ((hiDmg * (1 + GetNumGroupMembers())) * 1.5) and timerCT <= pandemic then
				CTRefreshable8 = CTRefreshable8 + 1
			end
		end
		
		if UnitCanAttack("player", unitID) and not immune and IsSpellInRange("Shoot Bow",unitID) == 0 and UnitHealth(unitID) > ((hiDmg * (1 + GetNumGroupMembers())) * 1.5) and not AuraUtil.FindAuraByName("Crimson Tempest",unitID,"PLAYER|HARMFUL") then
			MissingCT = MissingCT + 1
		end
	end

	return CTRefreshable8 + MissingCT
end

local function BTEDMG()
	local bte_damage = 0

	if not UnitIsPlayer('target') then
		if Player:ComboPoints() == 1 then
			bte_damage = 90 + buffer
		end

		if Player:ComboPoints() == 2 then
			bte_damage = 145 + buffer
		end

		if Player:ComboPoints() == 3 then
			bte_damage = 200 + buffer
		end

		if Player:ComboPoints() == 4 then
			bte_damage = 255 + buffer
		end

		if Player:ComboPoints() == 5 then
			bte_damage = 311 + buffer
		end
	end

	return bte_damage
end

local function Build()
	if IsReady('Shuriken Toss',1) and (CTRefreshableAOE(0) >= 2 or not IsInInstance() or not GetSpellCooldown('Crimson Tempest') or (UnitIsPlayer('target') and IsSpellInRange("Sinister Strike", "target") == 1)) and target_healthy then
		return S.ShurikenToss:Cast()
	end

	if IsReady('Ambush',1) and not cp_finish_condition then
		if IsReady('Cold Blood') and GriphRH.CDsON() then
			return S.ColdBlood:Cast()
		end
	
		return S.Ambush:Cast()
	end

	if IsReady('Backstab',1) and not GetSpellCooldown('Mutilate') and (Behind == true or GetSpellCooldown('Cutthroat')) and not cp_finish_condition then
		return S.Backstab:Cast()
	end

	if IsReady('Poisoned Knife',1) and Player:ComboPoints() <= 4 then
		-- if IsReady('Stealth') and GetSpellCooldown('Master of Subtlety') then
		-- 	return S.Stealth:Cast()
		-- end

		return S.PoisonedKnife:Cast()
	end

	if IsReady('Sinister Strike',1) and not GetSpellCooldown('Mutilate') and not cp_finish_condition then
		return S.SinisterStrike:Cast()
	end

	if IsReady('Mutilate',1) and not cp_finish_condition then
		return S.Mutilate:Cast()
	end

	return nil
end

local function Finish()
	if IsReady('Crimson Tempest',1) and GriphRH.AoEON() and ((cp_finish_condition and CTRefreshableAOE(2) >= 3) or (Player:ComboPoints() >= 3 and CTRefreshableAOE(0) >= 4) or (target_unhealthy and CTRefreshableAOE(2) >= 3)) then
		return S.CloakRune:Cast()
	end

	if IsReady('Slice and Dice') and CTRefreshableAOE(2) < 3 and (not UnitIsPlayer('target') or IsSpellInRange("Sinister Strike", "target") == 0 or ((S.KidneyShot:CooldownRemains() > 2 and not GetSpellCooldown('Between the Eyes')) or (S.BetweenTheEyes:CooldownRemains() > 2 and GetSpellCooldown('Between the Eyes')))) and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or (not GetSpellCooldown('Cut to the Chase') and (((Player:BuffRemains(S.SliceandDiceR1) < 4 or Player:BuffRemains(S.SliceandDiceR2) < 4) and Player:ComboPoints() >= 2 and (Player:ComboPoints() >= 5 or (target_unhealthy and RangeCount(5) > 1)))))) then
		return S.SliceandDiceR1:Cast()
	end

	if IsReady('Envenom',1) and ((cp_finish_condition and (not AuraUtil.FindAuraByName("Envenom", "player") or Player:Energy() >= 65 or UnitIsPlayer('target'))) or (EnvenomDMG() >= UnitHealth('target') and not UnitIsPlayer('target')) or (GetSpellCooldown('Cut to the Chase') and (AuraUtil.FindAuraByName("Slice and Dice", "player") and (((Player:Buff(S.SliceandDiceR1) and Player:BuffRemains(S.SliceandDiceR1) < 4) or (Player:Buff(S.SliceandDiceR2) and Player:BuffRemains(S.SliceandDiceR2) < 4)) or (((Player:Buff(S.SliceandDiceR1) and Player:BuffRemains(S.SliceandDiceR1) < 8) or (Player:Buff(S.SliceandDiceR2) and Player:BuffRemains(S.SliceandDiceR2) < 8)) and cp_finish_condition))))) then
		if IsReady('Cold Blood') and IsReady('Envenom',1) and not AuraUtil.FindAuraByName("Cutthroat", "player") and GriphRH.CDsON() and ((deadly_poison_stacks and deadly_poison_stacks >= 5) or (deadly_poison_stacksII and deadly_poison_stacksII >= 5) or (deadly_poison_stacksIII and deadly_poison_stacksIII >= 5) or (deadly_poison_stacksIV and deadly_poison_stacksIV >= 5) or (occult_poison_stacksI and occult_poison_stacksI >= 5)) and cp_finish_condition then
			return S.ColdBlood:Cast()
		end
	
		return S.Envenom:Cast()
	end

	if IsReady('Eviscerate',1) and not GetSpellCooldown('Envenom') and GetSpellCooldown('Cut to the Chase') and (AuraUtil.FindAuraByName("Slice and Dice", "player") and (((Player:Buff(S.SliceandDiceR1) and Player:BuffRemains(S.SliceandDiceR1) < 4) or (Player:Buff(S.SliceandDiceR2) and Player:BuffRemains(S.SliceandDiceR2) < 4)) or (((Player:Buff(S.SliceandDiceR1) and Player:BuffRemains(S.SliceandDiceR1) < 8) or (Player:Buff(S.SliceandDiceR2) and Player:BuffRemains(S.SliceandDiceR2) < 8)) and (cp_finish_condition or target_unhealthy)))) then
		return S.Eviscerate:Cast()
	end

	if IsReady('Between The Eyes',1) and (not GetSpellCooldown('Envenom') or (not AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL'))) and (cp_finish_condition or (BTEDMG() >= UnitHealth('target') and not UnitIsPlayer('target'))) then
		if IsReady('Cold Blood') and IsReady('Between the Eyes',1) and not AuraUtil.FindAuraByName("Cutthroat", "player") and GriphRH.CDsON() and cp_finish_condition then
			return S.ColdBlood:Cast()
		end
	
		return S.BetweenTheEyes:Cast()
	end

	if IsReady('Eviscerate',1) and (not GetSpellCooldown('Envenom') or (not AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL'))) and (cp_finish_condition or target_unhealthy) then
		return S.Eviscerate:Cast()
	end

	return nil
end

local function PvP()
	if not AuraUtil.FindAuraByName('Cheap Shot','target','HARMFUL') then
		if IsReady('Between the Eyes',1) and GetSpellCooldown('Between the Eyes') and cp_finish_condition then
			return S.BetweenTheEyes:Cast()
		end

		if IsReady('Kidney Shot',1) and not GetSpellCooldown('Between the Eyes') and cp_finish_condition then
			return S.KidneyShot:Cast()
		end
	end

	return nil
end

local function APL()
	--print(UnitIsPlayer('target'))
	--print(EnvenomDMG(),EviscerateDMG(),UnitHealth('target'))
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or (AuraUtil.FindAuraByName("Stealth", "player") and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID()) or AuraUtil.FindAuraByName("Food", "player") 
or AuraUtil.FindAuraByName("Food & Drink", "player") or AuraUtil.FindAuraByName('Gouge','target') or AuraUtil.FindAuraByName('Blind','target') then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

attack_power1,attack_power2,_ = UnitAttackPower('player')

attack_power = attack_power1 + attack_power2

lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage('player');

if UnitIsPlayer('target') then
	buffer = 0
else
	buffer = (hiDmg * (num(instanceType == 'party' or instanceType == 'raid') * GetNumGroupMembers())) * 1.2	
end

target_healthy = not UnitIsPlayer('target') and UnitHealth('target') > ((UnitHealthMax('player') * (1 + (GetNumGroupMembers() * 0.5))) / 4) * 2

--target_unhealthy = UnitHealth('target') < (hiDmg * (1 + GetNumGroupMembers()))
target_unhealthy = not UnitIsPlayer('target') and UnitHealth('target') < ((((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 5 + attack_power * 0.36) + (hiDmg * (num(instanceType == 'party' or instanceType == 'raid') * GetNumGroupMembers()))) * 1.3

cp_finish_condition = (Player:ComboPoints() >= 5 or (Player:ComboPoints() >= 4 and GetSpellCooldown('Mutilate')))

local max_energy = (Player:Energy() == 110 and IsEquippedItem("Craft of the Shadows")) or Player:Energy() == 100

if BehindCheckTimer then 
	BehindTimer = GetTime() - BehindCheckTimer
end

if FrontCheckTimer then
	FrontTimer = GetTime() - FrontCheckTimer
end

_,instanceType = IsInInstance()

local Behind = true

local Front = true

if BehindTimer and BehindTimer < Player:GCD() then
	Behind = false
end

if FrontTimer and FrontTimer < Player:GCD() then
	Front = false
end

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if ((GriphRH.queuedSpell[1]:CooldownRemains() > 2 or not Player:AffectingCombat()) and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Gouge:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Distract:ID() ~= GriphRH.queuedSpell[1]:ID() 
and S.KidneyShot:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Blind:ID() ~= GriphRH.queuedSpell[1]:ID())
or (S.Gouge:ID() == GriphRH.queuedSpell[1]:ID() and (S.Gouge:CooldownRemains() > 2 or Front == False or not TargetinRange(5)))
or (S.Distract:ID() == GriphRH.queuedSpell[1]:ID() and S.Distract:CooldownRemains() > 2)
or (S.KidneyShot:ID() == GriphRH.queuedSpell[1]:ID() and (S.KidneyShot:CooldownRemains() > 2 or Player:ComboPoints() == 0 or (not TargetinRange(5) and not GetSpellCooldown('Between the Eyes'))))
or (S.Blind:ID() == GriphRH.queuedSpell[1]:ID() and (S.Blind:CooldownRemains() > 2 or not TargetinRange(10)))
or (S.Kick:ID() == GriphRH.queuedSpell[1]:ID() and (not UnitCastingInfo('target') or not TargetinRange(5))) then
	GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
end

if S.Pull:ID() == GriphRH.queuedSpell[1]:ID() then
	if UnitCanAttack('player','target') then
		if UnitIsPlayer('target') then
			if IsReady('Cheap Shot',1) and AuraUtil.FindAuraByName("Stealth", "player") then
				return S.CheapShot:Cast()
			end
		end

		if IsReady('Stealth') and GetSpellCooldown('Shadowstrike') and S.Shadowstrike:CooldownRemains() == 0 and TargetinRange(20) and Player:Energy() >= 20 then
			return S.Stealth:Cast()
		end

		if IsReady('Shadowstrike',1) then
			return S.Shadowstrike:Cast()
		end

		if IsReady('Ambush',1) and Behind == true and not GetSpellCooldown('Mutilate') and AuraUtil.FindAuraByName("Stealth", "player") then
			return S.Ambush:Cast()
		elseif IsReady('Backstab',1) and Behind == true and not GetSpellCooldown('Mutilate') then
			return S.Backstab:Cast()
		elseif not IsCurrentSpell(6603) and not Target:IsDeadOrGhost() and (not AuraUtil.FindAuraByName("Stealth", "player") or TargetinRange(5)) and (not UnitIsPlayer('target') or not IsReady("Cheap Shot")) then
			return Item(135274, { 13, 14 }):ID()
		elseif AuraUtil.FindAuraByName('Redirect','player') then
			if PvP() and UnitIsPlayer('target') then
				return PvP()
			end
		
			if Finish() and (not UnitIsPlayer('target') or S.KidneyShot:CooldownRemains() > 2 or max_energy) then
				return Finish()
			end
		
			if Build() then
			--and (Player:Energy() > 80 or (not GriphRH.InterruptsON() or (target_unhealthy and RangeCount(5) <= 1)))
				return Build()
			end
		else
			GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
		end
	else
		GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }		
	end
end

if S.Distract:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.Distract:Cast()
end

if S.Gouge:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.Gouge:Cast()
end

if S.KidneyShot:ID() == GriphRH.queuedSpell[1]:ID() and Player:ComboPoints() >= 1 then
	if GetSpellCooldown('Between the Eyes') then
		return S.BetweenTheEyes:Cast()
	end

	if not GetSpellCooldown('Between the Eyes') then
		return S.KidneyShot:Cast()
	end
end

if S.Blind:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.Blind:Cast()
end

if S.Kick:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.Kick:Cast()
end

if S.BladeFlurry:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.BladeFlurry:Cast()
end

-- if GriphRH.QueuedSpell():CanCast() and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID() then
-- 	return GriphRH.QueuedSpell():Cast()
-- end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Interrupt & Dispels-----------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if IsReady('Kick',1) and GriphRH.InterruptsON() and Target:CastPercentage() > math.random(10, 85) then
	return S.Kick:Cast()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() then

end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if UnitCanAttack('player','target') and not Target:IsDeadOrGhost() and (not AuraUtil.FindAuraByName("Stealth", "player") or IsCurrentSpell(6603)) 
and ((UnitAffectingCombat('target') and not AuraUtil.FindAuraByName("Gouge","target","PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Sap","target","PLAYER|HARMFUL")) 
or IsCurrentSpell(6603)) and not AuraUtil.FindAuraByName('Redirect','player') and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Gouge:ID() ~= GriphRH.queuedSpell[1]:ID() 
and S.Kick:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Distract:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Blind:ID() ~= GriphRH.queuedSpell[1]:ID() and S.BladeFlurry:ID() ~= GriphRH.queuedSpell[1]:ID() then
	if not IsCurrentSpell(6603) and TargetinRange(5) then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Adrenaline Rush') and IsSpellInRange("Sinister Strike", "target") == 1 and GriphRH.CDsON() and Player:Energy() < 100 and (target_healthy or RangeCount(5) >= 2) then
		return S.AdrenalineRush:Cast()
	end

	-- if IsReady('Thistle Tea') and IsSpellInRange("Sinister Strike", "target") == 1 and GriphRH.CDsON() and (Player:Energy() <= 10 or (UnitIsPlayer('target') and Player:Energy() <= 30)) and ((target_healthy or UnitIsPlayer('target')) or RangeCount(5) >= 2) then
	-- 	return S.ThistleTea:Cast()
	-- end

	if PvP() and UnitIsPlayer('target') then
		return PvP()
	end

	if Finish() and (not UnitIsPlayer('target') or S.KidneyShot:CooldownRemains() > 2 or max_energy) then
		return Finish()
	end

	if Build() then
	--and (Player:Energy() > 80 or (not GriphRH.InterruptsON() or (target_unhealthy and RangeCount(5) <= 1)))
		return Build()
	end
end
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(4, APL);

--GriphRH.Rotation.SetPvP(4, PvP);
--GriphRH.Rotation.SetPASSIVE(4, PASSIVE);


-- local addonName, addonTable = ...;
-- local HL = HeroLibEx;
-- local Cache = HeroCache;
-- local Unit = HL.Unit;
-- local Player = Unit.Player;
-- local Target = Unit.Target;
-- local Arena = Unit.Arena
-- local Spell = HL.Spell;
-- local Item = HL.Item;
-- local Nameplate = Unit.Nameplate;


-- GriphRH.Spell[4] = {
--     Evasion = Spell(5277),
--     EnvenomBuff = Spell(399963),
--     Envenom = Spell(399963),
--     DeadlyPoisonDebuff = Spell(434312),
--     SliceandDice = Spell(5171),
--     Default = Spell(1),
--     Blind = Spell(2094),
--     CloakofShadows = Spell(31224),
--     Distract = Spell(1725),
--     Sap = Spell(11297),
--     Stealth = Spell(1784),
--     Vanish = Spell(26889),
--     Ambush = Spell(8724),
--     CheapShot = Spell(1833),
--     DeadlyThrow = Spell(48674),
--     DeadlyPoison = Spell(27187),
--     Eviscerate = Spell(6761),
--     ExposeArmor = Spell(26866),
--     Garrote = Spell(703),
--     KidneyShot = Spell(408),
--     Rupture = Spell(1943),
--     SnD = Spell(6774),
--     Backstab = Spell(53),
--     Feint = Spell(48659),
--     tott = Spell(57934),
--     Gouge = Spell(1776),
--     Kick = Spell(1766),
--     Shiv = Spell(5938),
--     SinisterStrike = Spell(1757),
--     Sprint = Spell(11305),
--     WilloftheForsaken = Spell(7744),
--     AdrenalineRush = Spell(13750),
--     BladeFlurry = Spell(13877),
--     KillingSpree = Spell(51690),
--     FanofKnives = Spell(51723),
--     ColdBlood = Spell(14177),
--     HungerforBlood = Spell(51662),
--     HungerforBloodBuff = Spell(63848),
--     Mutilate = Spell(399956),
--     Shadowstrike = Spell(399985),
--     Riposte = Spell(14251),
--     BladeDance = Spell(400012),
--     WidgetVolley = Spell(436833), --gnomer kick tracking widget volley spell

--     chestrune = Spell(20580), 
--     beltrune = Spell(20554), 
--     legrune = Spell(399963), 
--     handrune = Spell(399956),

--     ThistleTea = Spell(20589),--GGL escape artist

    
-- };
-- local S = GriphRH.Spell[4]





-- local function APL()


--     inRange5 = RangeCount(5)
--     -- inRange8 = RangeCount(8)
--     inRange10 = RangeCount(10)
--     -- inRange15 = RangeCount(15)
--     inRange20 = RangeCount(20)
--     inRange25 = RangeCount(25)
--     inRange30 = RangeCount(30)
--     targetRange5 = IsItemInRange(8149, "target") --works
--     -- targetRange8 = IsItemInRange(135432, "target")
--     targetRange10 = IsItemInRange(17626, "target") --works
--     -- targetRange15 = IsItemInRange(6451, "target")
--     targetRange20 = IsItemInRange(10645, "target")--works
--     targetRange25 = IsItemInRange(13289, "target") --works
--     targetRange30 = IsItemInRange(835, "target") --works
-- -- print('target range 5:',targetRange5)
-- -- print('target range 8:',targetRange8)

-- -- print('target range 10:',targetRange10)

-- -- print('target range 15:',targetRange15)

-- -- print('target range 20:',targetRange20)
-- -- print('target range 25:',targetRange25)
-- -- print('target range 30:',targetRange30)


-- if AuraUtil.FindAuraByName("Slice and Dice","player") then
--     SnDbuffremains = select(6,AuraUtil.FindAuraByName("Slice and Dice","player","PLAYER"))- GetTime()
-- else
--     SnDbuffremains = 0
-- end
-- if AuraUtil.FindAuraByName("Blade Dance","player") then
--     BDbuffremains = select(6,AuraUtil.FindAuraByName("Blade Dance","player","PLAYER"))- GetTime()
-- else
--     BDbuffremains = 0
-- end


-- if Target:Exists() and getCurrentDPS() and getCurrentDPS()>0 then
-- targetTTD = UnitHealth('target')/getCurrentDPS()
-- else targetTTD = 8888
-- end

--     local targetdying = (aoeTTD() < 2.5 or targetTTD<2.5)

-- if targetdying and Player:ComboPoints()>=3 or Player:ComboPoints()>=4 then
--     finish = true
-- else finish = false
-- end
-- -- print('aoettd:',aoeTTD())
-- -- print('targetTTD:',targetTTD)
-- local spellwidgetfort= UnitCastingInfo("target")
-- local namehonoramongthieves = GetSpellInfo('Honor Among Thieves')

-- local namecuttothechase = GetSpellInfo('Cut to the Chase')
-- local namemasterofsublety = GetSpellInfo('Master of Sublety')
-- local namequickdraw = GetSpellInfo('Quick Draw')
-- local namecarnage = GetSpellInfo('Carnage')
-- local nameshiv = GetSpellInfo('Shiv')
-- local namemainguache = GetSpellInfo('Main Guache')
-- local namemutilate = GetSpellInfo(399956)
-- local namesaberslash = GetSpellInfo('Saber Slash')
-- local nameshadowstrike = GetSpellInfo('Shadowstrike')
-- -- print(namemutilate)
--     local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
--     local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

--     local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
   
--     local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
    
--     local channelTime = elapsedTimech / 1000

--     local castTime = elapsedTimeca / 1000

--     local castchannelTime = math.random(275, 500) / 1000

--     local targetttd20= (aoeTTD()>20 or UnitHealth('target')>2500 or Target:IsAPlayer() and Target:HealthPercentage()>75)
--     local targetttd10= (aoeTTD()>10 or UnitHealth('target')>2250 or Target:IsAPlayer() and Target:HealthPercentage()>65 and Target:HealthPercentage()<=75)
--     local targetttd8= (aoeTTD()>8 or UnitHealth('target')>2000 or Target:IsAPlayer() and Target:HealthPercentage()>55 and Target:HealthPercentage()<=65)
--     local targetttd6= (aoeTTD()>6 or UnitHealth('target')>1750 or Target:IsAPlayer() and Target:HealthPercentage()<=55)
--     local targetttd3= (aoeTTD()>3 or Target:IsAPlayer() and Target:HealthPercentage()<20)

--     if Player:IsCasting() or Player:IsChanneling() then
--         return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
--     elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
--         or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
--         return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
--     end

--     if inRange25 == 0 then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.Gouge:ID() and (S.Gouge:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.BladeFlurry:ID() and (S.BladeFlurry:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.KidneyShot:ID() and (S.KidneyShot:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.Kick:ID() and (S.Kick:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end
--     if GriphRH.QueuedSpell():ID() == S.Backstab:ID() and (Player:Energy()<60 or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.Distract:ID() and (S.Distract:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
--         GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
--     end

--     if GriphRH.QueuedSpell():ID() == S.Gouge:ID() and Player:Energy()> 35 and targetRange10 then
--         return GriphRH.QueuedSpell():Cast()
--     end

--     if GriphRH.QueuedSpell():ID() == S.KidneyShot:ID() and not Target:Debuff(S.CheapShot) and Player:ComboPoints()>=1 and Player:Energy()> 15 and targetRange10 then
--         return GriphRH.QueuedSpell():Cast()
--     end
--     if GriphRH.QueuedSpell():ID() == S.Backstab:ID() and targetRange10 then
--         return GriphRH.QueuedSpell():Cast()
--     end
--     if GriphRH.QueuedSpell():ID() == S.Kick:ID() and Player:Energy()> 15 and targetRange10 then
--         return GriphRH.QueuedSpell():Cast()
--     end
--     if GriphRH.QueuedSpell():ID() == S.Blind:ID() then
--         return GriphRH.QueuedSpell():Cast()
--     end

--     if GriphRH.QueuedSpell():ID() == S.Distract:ID() then
--         return GriphRH.QueuedSpell():Cast()
--     end

--     if GriphRH.QueuedSpell():ID() == S.BladeFlurry:ID() then
--         return GriphRH.QueuedSpell():Cast()
--     end

--     local GetItemCooldown =  (C_Container and C_Container.GetItemCooldown(7676)) or 0

--     if 300-GetTime()+GetItemCooldown<=0 then
--         thistleteaoffcooldown = true
--     else
--         thistleteaoffcooldown=false
--     end

--     if AuraUtil.FindAuraByName("Deadly Poison","target","PLAYER|HARMFUL") then
--         deadlypoisonstack =select(3,AuraUtil.FindAuraByName("Deadly Poison","target","PLAYER|HARMFUL"))
--     elseif AuraUtil.FindAuraByName("Deadly Poison II","target","PLAYER|HARMFUL") then 
--         deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison II","target","PLAYER|HARMFUL"))
--     elseif AuraUtil.FindAuraByName("Deadly Poison III","target","PLAYER|HARMFUL") then 
--         deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison III","target","PLAYER|HARMFUL"))
--     elseif AuraUtil.FindAuraByName("Deadly Poison IV","target","PLAYER|HARMFUL") then 
--         deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison IV","target","PLAYER|HARMFUL"))
--     elseif AuraUtil.FindAuraByName("Deadly Poison V","target","PLAYER|HARMFUL") then 
--         deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison V","target","PLAYER|HARMFUL"))
--     elseif AuraUtil.FindAuraByName("Deadly Poison VI","target","PLAYER|HARMFUL") then 
--         deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison VI","target","PLAYER|HARMFUL"))
--     else
--         deadlypoisonstack = 0
--     end


--     if AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL") then
--         rupturedebuff = select(6,AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")) - GetTime()
--          else
--             rupturedebuff = 0 
--         end
--         if AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL") and namecarnage =='Carnage' then
--             carnagedebuff = select(6,AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL")) - GetTime()
--               else
--                  carnageedebuff = 0 
--              end

--         if AuraUtil.FindAuraByName("Garrote","target","PLAYER|HARMFUL") then
--            garrotedebuff = select(6,AuraUtil.FindAuraByName("Garrote","target","PLAYER|HARMFUL")) - GetTime()
--              else
--                 garrotedebuff = 0 
--             end

--             -- print('rupturetime:',rupturedebuff)
--             -- print('garrootetime:',garrotedebuff)
--             -- print('is garrote castable:',IsReady('Garrote'))

--             if namehonoramongthieves == 'Honor Among Thieves' and
--                  (Player:ComboPoints()<=1   
--                 or
--                  Player:Energy()>=70 and (S.AdrenalineRush:IsAvailable() and AuraUtil.FindAuraByName("Adrenaline Rush", "player") and Player:Energy()>=50
--                         or EnergyTimeToNextTick()<1
--                         or namemasterofsublety =='Master of Sublety' and AuraUtil.FindAuraByName("Master of Sublety", "player") and Player:ComboPoints()<=3)
--                 or targetttd6) then
                            

--                             build = true
--                         else
--                             build = false
--                         end
              

             
--                         if AuraUtil.FindAuraByName("Divine Protection","target") 
--                         or AuraUtil.FindAuraByName("Ice Block","target") 
--                         or AuraUtil.FindAuraByName("Blessing of Protection","player") 
--                         or AuraUtil.FindAuraByName("Blessing of Protection","target") 
--                         or AuraUtil.FindAuraByName("Invulnerability","target") 
--                         or AuraUtil.FindAuraByName("Dispersion","target") then
--                             stoprotation = true
--                         else
--                             stoprotation = false
--                         end


                

--     if Player:AffectingCombat() and not AuraUtil.FindAuraByName("Stealth", "player") and not AuraUtil.FindAuraByName("Drink", "player") 
--     and not AuraUtil.FindAuraByName("Food", "player") and (not AuraUtil.FindAuraByName("Vanish", "player") or AuraUtil.FindAuraByName("Cold Blood", "player")) and not AuraUtil.FindAuraByName("Food & Drink", "player")
--     and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then -- In combat
--         if not IsCurrentSpell(6603) and targetRange10 then
--             return I.autoattack:ID()
--         end

--         if stoprotation == false then 


--         if S.Kick:CooldownRemains()<2 and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetRange10 and GriphRH.InterruptsON() then
--             return S.Kick:Cast()
--         end


--         if IsReady('Adrenaline Rush') and GriphRH.CDsON() and targetRange10 then
--             return S.AdrenalineRush:Cast()
--         end

--         if (UnitName('target') == "STX-25/NB" and GriphRH.InterruptsON() and Player:Energy()>55 or not GriphRH.InterruptsON() or UnitName('target') ~= "STX-25/NB") then 
--         if Player:Energy()<20 and UnitHealthMax('target')>100000 and IsUsableItem(7676)==true and thistleteaoffcooldown==true and GetItemCount(7676) >= 1 and GriphRH.CDsON() then
--         return  S.ThistleTea:Cast()
--         end 


--         if IsReady('Gouge') and Behind == false and Target:IsAPlayer() and targetRange10 and HL.CombatTime()<3 then
--             return S.Gouge:Cast()
--         end

--         if IsReady('Kidney Shot') and Player:ComboPoints()>=4 and Target:IsAPlayer() and targetRange10 then
--             return S.KidneyShot:Cast()
--         end
--         if IsReady('Between the Eyes') and Player:ComboPoints()>=4 and Target:IsAPlayer() and targetRange10 then
--             return S.legrune:Cast()
--         end
 

--         if IsReady('Rupture') and UnitCreatureType("target") ~= "Elemental" and not AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")  
--         and namecarnage == 'Carnage' and (not AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL")  
--         or  rupturedebuff <1  
--         or garrotedebuff<1.5 )
--         and Player:ComboPoints()>=3 and targetttd8 then
--             return S.Rupture:Cast()
--         end

--         if IsReady("Slice and Dice") and namecuttothechase == 'Cut to the Chase' and not AuraUtil.FindAuraByName("Slice and Dice", "player") and Player:ComboPoints()>=1 and (targetttd10 or inRange25>1 and aoeTTD()>5) then
--             return S.SliceandDice:Cast()
--         end
--         if  IsReady("Slice and Dice") and namecuttothechase ~= 'Cut to the Chase' and SnDbuffremains<1 and Player:ComboPoints()>=3 and (HL.CombatTime()<3 or targetttd20 or inRange25>1 and aoeTTD()>5) then
--             return S.SliceandDice:Cast()
--         end
        
--         if IsReady('Slice and Dice') and not AuraUtil.FindAuraByName("Cold Blood", "player") and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or SnDbuffremains<2 and inRange25>1) and targetRange10 and finish then
--             return S.SliceandDice:Cast()
--         end

--         if IsReady('Blade Dance') and (isTanking == true or not Target:IsCasting() or inRange25>1) and not DungeonBoss() and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Blade Dance", "player") or BDbuffremains<3 and inRange25>1) and targetRange10 and (finish or Player:ComboPoints()>=2 and (HL.CombatTime()<5 and not AuraUtil.FindAuraByName("Blade Dance", "player"))) then
--             return S.legrune:Cast()
--         end

--         if IsReady('Vanish') and namemasterofsublety =='Master of Sublety' and deadlypoisonstack>=1 and GriphRH.CDsON() and IsReady('Envenom') and Player:ComboPoints()>=5 and targetRange10 and not AuraUtil.FindAuraByName("Master of Sublety", "player") then
--             return S.Vanish :Cast()
--         end

--         if IsReady('Cold Blood') and GriphRH.CDsON() and deadlypoisonstack>=1 and finish and targetRange10 then
--             return S.ColdBlood:Cast()
--         end
      
      
--         if IsReady('Envenom') and deadlypoisonstack>=1 and AuraUtil.FindAuraByName("Cold Blood", "player") and targetRange10 and finish then
--             return S.legrune:Cast()
--         end
--         if IsReady('Envenom') and deadlypoisonstack>=1 and namehonoramongthieves~= 'Honor Among Thieves' and targetRange10 and Player:ComboPoints()>=4 then
--             return S.legrune:Cast()
--         end
--         if IsReady('Envenom') and deadlypoisonstack>=1 and namehonoramongthieves== 'Honor Among Thieves' and targetRange10 and (Player:ComboPoints()>=5 or Player:ComboPoints()>=4 and Player:Energy()>=70) then
--             return S.legrune:Cast()
--         end
--         if IsReady('Envenom') and targetRange10 and (Player:ComboPoints()>=3 and targetttd3 and deadlypoisonstack >=3) then
--             return S.legrune:Cast()
--         end


--         if IsReady('Envenom') and targetRange10 and finish and deadlypoisonstack>=1 then
--             return S.legrune:Cast()
--         end

--         if IsReady('Between the Eyes') and finish and (inRange25==1 or targetRange30) then
--             return S.legrune:Cast()
--         end

--         if IsReady('Riposte') and AuraUtil.FindAuraByName("Blade Dance", "player") and targetRange10 then
--             return S.Riposte:Cast()
--         end

--         if IsReady('Eviscerate') and targetRange10 and Player:ComboPoints()>=5 then
--             return S.Eviscerate:Cast()
--         end

--         if IsReady('Shuriken Toss') and inRange25>4 and targetRange10 and not Player:Buff(S.BladeFlurry) and  Player:ComboPoints() < 5 then
--             return S.beltrune:Cast()
--         end
 

--         if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
--             return S.handrune:Cast()
--         end

--         if IsReady('Mutilate') and targetRange10 and Player:ComboPoints() <5 and namemutilate == 'Mutilate' and (build == true or namehonoramongthieves ~= 'Honor Among Thieves') then
--             return S.handrune:Cast()
--         end

--         if  IsReady('Main Gauche') and targetRange10 and Player:ComboPoints() <=2 and namemainguache == 'Main Guache' then
--             return S.handrune:Cast()
--         end

--         if IsReady('Shiv') and targetRange10 and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
--             return S.handrune:Cast()
--         end

--         if  IsReady('Saber Slash') and targetRange10 and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' and (build == true or namehonoramongthieves ~= 'Honor Among Thieves') then
--             return S.handrune:Cast()
--         end

--         if IsReady('Backstab') and namemutilate ~= 'Mutilate' and targetRange10 and not Player:IsTanking(Target) and Behind ~= false then
--             return S.Backstab:Cast()
--         end

--         if IsReady('Sinister Strike') and targetRange10 and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
--             return S.SinisterStrike:Cast()
--         end
--     end
--     end
   

--     end
--   --     -- Out of combat

--     if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
       
--         if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
          
--             if IsReady('Envenom') and deadlypoisonstack>=1 and AuraUtil.FindAuraByName("Cold Blood", "player") and targetRange10 and finish then
--                 return S.legrune:Cast()
--             end
--             if IsReady('Stealth') and targetRange10 and namecarnage == 'Carnage' then
--                 return S.Stealth:Cast()
--             end

--             if IsReady('Cheap Shot') and Target:IsAPlayer() and targetRange10 then
--                 return S.CheapShot:Cast()
--             end

--             if IsReady('Garrote') and UnitCreatureType("target") ~= "Elemental" and targetRange10 and namecarnage == 'Carnage' and Behind ~= false then
--                 return S.Garrote:Cast()
--             end

--             if IsReady('Ambush') and targetRange10 and namemutilate ~='mutilate' then
--                 return S.Ambush:Cast()
--             end

--             if IsReady('Shadowstrike') and AuraUtil.FindAuraByName("Stealth", "player") and (inRange25 >=1 or targetRange30) then
--                 return S.handrune:Cast()
--             end

--             if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
--                 return S.handrune:Cast()
--             end

--             if  IsReady('Mutilate') and targetRange10 and Player:ComboPoints() <4 and namemutilate == 'Mutilate' then
--                 return S.handrune:Cast()
--             end
    
    
--             if  IsReady('Main Gauche') and targetRange10 and Player:ComboPoints() < 5 and namemainguache == 'Main Guache' then
--                 return S.handrune:Cast()
--             end
    
--             if IsReady('Shiv') and targetRange10 and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
--                 return S.handrune:Cast()
--             end
    
--             if  IsReady('Saber Slash') and targetRange10 and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' then
--                 return S.handrune:Cast()
--             end
    
--             if IsReady('Sinister Strike') and targetRange10 and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
--                 return S.SinisterStrike:Cast()
--             end

--             if not IsCurrentSpell(6603) and targetRange10 and not AuraUtil.FindAuraByName("Stealth", "player")  then
--                 return I.autoattack:ID()
--             end

--         end

--         return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
--     end



--     return 135328
-- end

-- GriphRH.Rotation.SetAPL(4, APL);
