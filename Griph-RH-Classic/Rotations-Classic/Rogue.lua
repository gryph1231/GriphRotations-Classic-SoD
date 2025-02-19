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
	Rupture = Spell(11275),
	SliceandDiceR1 = Spell(5171),
	SliceandDice = Spell(6774),
	Backstab = Spell(53),
	Evasion = Spell(26669),
	CrimsonTempest = Spell(412096),
	DeadlyPoisonDebuff = Spell(434312),
	KidneyShot = Spell(408),
	Feint = Spell(11303),
	Gouge = Spell(1776),
	BladeFlurry = Spell(13877),
	AdrenalineRush = Spell(13750),
	Kick = Spell(1766),
	ColdBlood = Spell(14177),
	Shiv = Spell(5938),
	Ambush = Spell(462721),
	Distract = Spell(1725),
	Blind = Spell(2094),
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
	ThistleTea = Item(7676),
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

	if AuraUtil.FindAuraByName('Occult Poison II','target','PLAYER|HARMFUL') then
		_, _, occult_poison_stacksII = AuraUtil.FindAuraByName('Occult Poison II','target','PLAYER|HARMFUL')
	else
		occult_poison_stacksII = 0
	end

	local envenom_damage = 0
	
	if (deadly_poison_stacks or deadly_poison_stacksII or deadly_poison_stacksIII or deadly_poison_stacksIV or occult_poison_stacksI or occult_poison_stacksII) and not UnitIsPlayer('target') then
		if (deadly_poison_stacks >= 1 or deadly_poison_stacksII >= 1 or deadly_poison_stacksIII >= 1 or deadly_poison_stacksIV >= 1 or occult_poison_stacksI >= 1 or occult_poison_stacksII >= 1) and Player:ComboPoints() >= 1 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 1 + attack_power * 0.072
		end

		if (deadly_poison_stacks >= 2 or deadly_poison_stacksII >= 2 or deadly_poison_stacksIII >= 2 or deadly_poison_stacksIV >= 2 or occult_poison_stacksI >= 2 or occult_poison_stacksII >= 2) and Player:ComboPoints() >= 2 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 2 + attack_power * 0.144
		end

		if (deadly_poison_stacks >= 3 or deadly_poison_stacksII >= 3 or deadly_poison_stacksIII >= 3 or deadly_poison_stacksIV >= 3 or occult_poison_stacksI >= 3 or occult_poison_stacksII >= 3) and Player:ComboPoints() >= 3 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 3 + attack_power * 0.216
		end

		if (deadly_poison_stacks >= 4 or deadly_poison_stacksII >= 4 or deadly_poison_stacksIII >= 4 or deadly_poison_stacksIV >= 4 or occult_poison_stacksI >= 4 or occult_poison_stacksII >= 4) and Player:ComboPoints() >= 4 then
			envenom_damage = ((5.741530 - 0.255683 * UnitLevel("player") + 0.032656 * UnitLevel("player") * UnitLevel("player")) * 80 / 100) * 4 + attack_power * 0.288
		end

		if (deadly_poison_stacks >= 5 or deadly_poison_stacksII >= 5 or deadly_poison_stacksIII >= 5 or deadly_poison_stacksIV >= 5 or occult_poison_stacksI >= 5 or occult_poison_stacksII >= 5) and Player:ComboPoints() >= 5 then
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
		or UnitName(unitID) == "Mindless Undead" or UnitName(unitID) == "Spectral Projection" or UnitName(unitID) == "Scholomance Occultist" or UnitName(unitID) == "Fireguard Destroyer"
		
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
	if IsReady('Crimson Tempest') and GriphRH.AoEON() and ((cp_finish_condition and CTRefreshableAOE(2) >= 3) or (Player:ComboPoints() >= 3 and CTRefreshableAOE(0) >= 4) or (target_unhealthy and CTRefreshableAOE(2) >= 3)) then
		return S.CloakRune:Cast()
	end

	if IsReady('Slice and Dice') and CTRefreshableAOE(2) < 3 and (not UnitIsPlayer('target') or IsSpellInRange("Sinister Strike", "target") == 0) and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or (not GetSpellCooldown('Cut to the Chase') and ((Player:BuffRemains(S.SliceandDice) < 4 and Player:ComboPoints() >= 2 and (Player:ComboPoints() >= 5 or (target_unhealthy and RangeCount(5) > 1)))))) then
		return S.SliceandDice:Cast()
	end

	if IsReady('Rupture',1) and GriphRH.CDsON() and GetSpellCooldown('Carnage') and cp_finish_condition and ((not AuraUtil.FindAuraByName('Rupture','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Crimson Tempest','target','PLAYER|HARMFUL')) or (AuraUtil.FindAuraByName('Rupture','target','PLAYER|HARMFUL') and Target:DebuffRemains(S.Rupture) <= 3)) and target_healthy then
		return S.Rupture:Cast()
	end

	if IsReady('Envenom',1) and ((cp_finish_condition and (not AuraUtil.FindAuraByName("Envenom", "player") or Player:Energy() >= 65 or (Player:Energy() >= 50 and IsReady('Poisoned Knife',1)) or UnitIsPlayer('target'))) or (EnvenomDMG() >= UnitHealth('target') and not UnitIsPlayer('target')) or (GetSpellCooldown('Cut to the Chase') and (AuraUtil.FindAuraByName("Slice and Dice", "player") and ((Player:Buff(S.SliceandDice) and Player:BuffRemains(S.SliceandDice) < 4) or (((Player:Buff(S.SliceandDice) and Player:BuffRemains(S.SliceandDice) < 8)) and cp_finish_condition))))) then
		if IsReady('Cold Blood') and IsReady('Envenom',1) and not AuraUtil.FindAuraByName("Cutthroat", "player") and GriphRH.CDsON() and ((deadly_poison_stacks and deadly_poison_stacks >= 5) or (deadly_poison_stacksII and deadly_poison_stacksII >= 5) or (deadly_poison_stacksIII and deadly_poison_stacksIII >= 5) or (deadly_poison_stacksIV and deadly_poison_stacksIV >= 5) or (occult_poison_stacksI and occult_poison_stacksI >= 5) or (occult_poison_stacksII and occult_poison_stacksII >= 5)) and cp_finish_condition then
			return S.ColdBlood:Cast()
		end
	
		return S.Envenom:Cast()
	end

	if IsReady('Eviscerate',1) and not GetSpellCooldown('Envenom') and GetSpellCooldown('Cut to the Chase') and (AuraUtil.FindAuraByName("Slice and Dice", "player") and ((Player:Buff(S.SliceandDice) and Player:BuffRemains(S.SliceandDice) < 4) or (Player:Buff(S.SliceandDice) and Player:BuffRemains(S.SliceandDice) < 8 and (cp_finish_condition or target_unhealthy)))) then
		return S.Eviscerate:Cast()
	end

	if IsReady('Between The Eyes',1) and (not GetSpellCooldown('Envenom') or (not AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison II','target','PLAYER|HARMFUL'))) and (cp_finish_condition or (BTEDMG() >= UnitHealth('target') and not UnitIsPlayer('target'))) then
		if IsReady('Cold Blood') and IsReady('Between the Eyes',1) and not AuraUtil.FindAuraByName("Cutthroat", "player") and GriphRH.CDsON() and cp_finish_condition then
			return S.ColdBlood:Cast()
		end
	
		return S.BetweenTheEyes:Cast()
	end

	if IsReady('Eviscerate',1) and (not GetSpellCooldown('Envenom') or (not AuraUtil.FindAuraByName('Deadly Poison','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison II','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison III','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Deadly Poison IV','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison I','target','PLAYER|HARMFUL') and not AuraUtil.FindAuraByName('Occult Poison II','target','PLAYER|HARMFUL'))) and (cp_finish_condition or target_unhealthy) then
		return S.Eviscerate:Cast()
	end

	return nil
end

local function PvP()
	if not AuraUtil.FindAuraByName('Cheap Shot','target','HARMFUL') or Target:DebuffRemains(S.CheapShot) <= 0.5 then
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

local GetItemCooldown =  (C_Container and C_Container.GetItemCooldown(7676)) or 0

if 300 - GetTime() + GetItemCooldown <= 0 then
    thistleteaoffcooldown = true
else
    thistleteaoffcooldown = false
end

if BehindCheckTimer then 
	BehindTimer = GetTime() - BehindCheckTimer
end

if FrontCheckTimer then
	FrontTimer = GetTime() - FrontCheckTimer
end

-- if UnitIsPlayer('target') then
-- 	stop_rotation = AuraUtil.FindAuraByName("Divine Protection","target") or AuraUtil.FindAuraByName("Ice Block","target") or AuraUtil.FindAuraByName("Blessing of Protection","target") or AuraUtil.FindAuraByName("Invulnerability","target")
-- 	or (AuraUtil.FindAuraByName("Dispersion","target") and (not max_energy or Player:ComboPoints() >= 5))
-- end

if UnitIsPlayer('target') then 
	if AuraUtil.FindAuraByName("Divine Protection","target") 
	or AuraUtil.FindAuraByName("Ice Block","target") 
	or AuraUtil.FindAuraByName("Blessing of Protection","target") 
	or AuraUtil.FindAuraByName("Invulnerability","target")
	or (AuraUtil.FindAuraByName("Dispersion","target") and (not max_energy or Player:ComboPoints() >= 5)) then
    	stop_rotation = true
	else
		stop_rotation = false
	end
else
	stop_rotation = false
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
and S.KidneyShot:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Blind:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Feint:ID() ~= GriphRH.queuedSpell[1]:ID())
or (S.Gouge:ID() == GriphRH.queuedSpell[1]:ID() and (S.Gouge:CooldownRemains() > 2 or Front == False or not TargetinRange(5)))
or (S.Distract:ID() == GriphRH.queuedSpell[1]:ID() and S.Distract:CooldownRemains() > 2)
or (S.KidneyShot:ID() == GriphRH.queuedSpell[1]:ID() and (S.KidneyShot:CooldownRemains() > 2 or Target:DebuffRemains(S.CheapShot) >= 2 or Player:ComboPoints() == 0 or (not TargetinRange(5) and not GetSpellCooldown('Between the Eyes'))))
or (S.Blind:ID() == GriphRH.queuedSpell[1]:ID() and (S.Blind:CooldownRemains() > 2 or not TargetinRange(10)))
or (S.Feint:ID() == GriphRH.queuedSpell[1]:ID() and (not IsReady("Feint",1) or not UnitCanAttack('player','target')))
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
		elseif not IsCurrentSpell(6603) and not Target:IsDeadOrGhost() and (not AuraUtil.FindAuraByName("Stealth", "player") or (TargetinRange(5) and (S.CheapShot:CooldownRemains() > 2 or not UnitIsPlayer('target')))) then
			return Item(135274, { 13, 14 }):ID()
		elseif AuraUtil.FindAuraByName('Redirect','player') and stop_rotation == false then
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

if S.Feint:ID() == GriphRH.queuedSpell[1]:ID() then
	return S.Feint:Cast()
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
and (((UnitAffectingCombat('target') and (TargetinRange(10) or IsCurrentSpell(6603) or UnitAffectingCombat('player'))) and not AuraUtil.FindAuraByName("Gouge","target","PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Blind","target","PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Sap","target","PLAYER|HARMFUL")) 
or IsCurrentSpell(6603)) and not AuraUtil.FindAuraByName('Redirect','player') and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Gouge:ID() ~= GriphRH.queuedSpell[1]:ID() 
and S.Kick:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Distract:ID() ~= GriphRH.queuedSpell[1]:ID() and S.Blind:ID() ~= GriphRH.queuedSpell[1]:ID() and S.BladeFlurry:ID() ~= GriphRH.queuedSpell[1]:ID()
and S.Feint:ID() ~= GriphRH.queuedSpell[1]:ID() and stop_rotation == false then
	if not IsCurrentSpell(6603) and TargetinRange(5) then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Adrenaline Rush') and IsSpellInRange("Sinister Strike", "target") == 1 and GriphRH.CDsON() and Player:Energy() < 100 and (target_healthy or RangeCount(5) >= 2) then
		return S.AdrenalineRush:Cast()
	end

	if IsSpellInRange("Sinister Strike", "target") == 1 and Player:Energy() < 25 and UnitIsPlayer('target') and GriphRH.CDsON() and thistleteaoffcooldown and stop_rotation == false 
	and AuraUtil.FindAuraByName('Cheap Shot','target','HARMFUL') and Target:DebuffRemains(S.CheapShot) < 0.75 and Player:Energy() < 25 then
		return I.ThistleTea:Cast()
	end

	if PvP() and UnitIsPlayer('target') then
		return PvP()
	end

	if Finish() and (not UnitIsPlayer('target') or S.KidneyShot:CooldownRemains() > 2) then
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