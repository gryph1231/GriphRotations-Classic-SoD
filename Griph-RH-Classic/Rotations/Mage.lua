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


GriphRH.Spell[8] = {
	ArcaneIntellect = Spell(1459),
	ImprovedScorch = Spell(12873),
	
	Shoot = Spell(5019),
	Scorch = Spell(2948),
	Evocation = Spell(12051),
	Combustion = Spell(11129),
	IceBlock = Spell(11958), 
	Pyroblast = Spell(12523),
	ArcanePower = Spell(12042),
	Fireball = Spell(133),
	ScorchDebuff = Spell(22959),
	HotStreak = Spell(400625),
	FireBlast = Spell(10199),
	Default = Spell(1),
	Frostbolt = Spell(116),
	Counterspell = Spell(2139),
	FrostArmor = Spell(168),
	MageArmor = Spell(6117),
	ManaShield = Spell(1463),
	legrune = Spell(7744), --will of the forsaken - BP /cast leg rune ability
    handrune = Spell(20554), --berserking - BP /cast hands rune ability
	waistrune = Spell(20589),--escape artist - BP /cast waist rune ability
};

local S = GriphRH.Spell[8]


if not Item.Mage then
    Item.Mage = {}
end

Item.Mage = {
thistletea = Item(7676),
    trinket = Item(28288, { 13, 14 }),
    trinket2 = Item(25628, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),
};

local I = Item.Mage;


S.Frostbolt:RegisterInFlight()
S.Fireball:RegisterInFlight()

S.Shoot:RegisterInFlight()


	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	


local function APL()

	local Shoot = 0

	for ActionSlot = 1, 120 do
		local ActionText = GetActionTexture(ActionSlot)
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Shoot')
		
		if ActionText == icon then
			Shoot = ActionSlot
		end
	end

		targetRange30 = TargetInRange("Fireball")


    local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end
local targetrunning = (GetUnitSpeed("target") /7 *100)>90
local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")


local _,instanceType = IsInInstance()
local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local channelTime = elapsedTimech / 1000

local castTime = elapsedTimeca / 1000

local castchannelTime = math.random(275, 500) / 1000

local spellwidgetfort= UnitCastingInfo("target")


if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end


-- if GriphRH.QueuedSpell():ID() == S.FlashHeal:ID() and (not IsUsableSpell("Flash Heal") or Player:MovingFor()>.15) then
-- 	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
-- end
-- if GriphRH.QueuedSpell():ID() == S.FlashHeal:ID() and not IsCurrentSpell("Flash Heal") and IsUsableSpell("Flash Heal") then
-- 	return GriphRH.QueuedSpell():Cast()
-- end



local namefrostfirebolt = GetSpellInfo('Frostfire Bolt' )

local namelivingflame = GetSpellInfo('Living Flame' )
local namelivingbomb = GetSpellInfo('Living Bomb' )


if Player:CanAttack(Target) and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and (Player:AffectingCombat() or IsCurrentSpell(5019) or Target:AffectingCombat() or IsCurrentSpell(6603) or S.Frostbolt:InFlight() or S.Fireball:InFlight()) and not Target:IsDeadOrGhost() then 



	if IsReady('Fire Blast') and targetRange30 and (UnitHealth('target')<200 and not Target:IsAPlayer() or UnitHealthMax('target')>100000 and (Target:TimeToDie()<10 or UnitHealth('target')<2000) or Target:IsAPlayer() and Target:HealthPercentage()<20)  then
		return S.FireBlast:Cast()
	end

	if IsReady("Ice Block") and Player:HealthPercentage()<10 then
		return S.IceBlock:Cast()
	end

	if IsReady("Counterspell") and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetRange30 and GriphRH.InterruptsON() then
		return S.Counterspell:Cast()
	end

	if IsReady("Mana Shield") and Player:ManaPercentage()>90 and Player:HealthPercentage()<15 and (instanceType== 'none' or isTanking == true or Target:IsAPlayer() or instanceType == 'pvp')  and not AuraUtil.FindAuraByName("Mana Shield","player") then
		return S.ManaShield:Cast()
	end	

	-- if IsReady("Evocation") and Player:ManaPercentage()<=15 and instanceType~= 'pvp' and instanceType~= 'none' and GriphRH.CDsON() and Player:StoppedFor()>3 then
	-- 	return S.Evocation:Cast()
	-- end


	if IsReady("Living Bomb") and targetRange30 and not AuraUtil.FindAuraByName("Living Bomb", "target", "PLAYER|HARMFUL")  then
		return S.handrune:Cast()
	end

	if IsReady("Living Flame")  and targetRange30 then
		return S.legrune:Cast()
	end

	if IsReady('Pyroblast') and Player:Buff(S.HotStreak) and targetRange30 then
		return S.Pyroblast:Cast()
	end


	
	if IsReady('Scorch') and targetRange30 and (Target:DebuffStack(S.ScorchDebuff) < 5 or Target:DebuffRemains(S.ScorchDebuff) <= 5) and not Player:IsMoving() then
		return S.Scorch:Cast()
	end
	if IsReady("Arcane Power") and targetRange30 and GriphRH.CDsON()  then
		return S.ArcanePower:Cast()
	end
	if IsReady("Combustion") and targetRange30 and GriphRH.CDsON() and Target:DebuffStack(S.ScorchDebuff) >=5 
	and (AuraUtil.FindAuraByName("Living Bomb", "target", "PLAYER|HARMFUL")) then
		return S.Combustion:Cast()
	end

	if IsReady("Icy Veins") and targetRange30 and GriphRH.CDsON() and (AuraUtil.FindAuraByName("Living Bomb", "player")) then
		return S.legrune:Cast()
	end
	
	if IsReady('Frostfire Bolt') and not Player:IsMoving() then
		return S.waistrune:Cast()
	end
	
	
	if IsReady('Fireball') and namefrostfirebolt ~= 'Frostfire Bolt' and targetRange30 and (AuraUtil.FindAuraByName("Combustion", "player") or AuraUtil.FindAuraByName("Icy Veins", "player")) and not Player:IsMoving() then
		return S.Fireball:Cast()
	end
	
	if IsReady('Fire Blast') and targetRange30 then
		return S.FireBlast:Cast()
	end

	if IsReady('Scorch') and not Player:IsMoving() and targetRange30 then
		return S.Scorch:Cast()
	end
	if IsReady('Fireball') and not Player:IsMoving() and targetRange30 then
		return S.Fireball:Cast()
	end

	if GCDRemaining()==0  and not IsAutoRepeatAction(Shoot) and not IsCurrentSpell(5019) and not Player:IsMoving() and targetRange30 and Player:ManaPercentage()<10 then
		return "Interface\\Addons\\Griph-RH-Classic\\Media\\ABILITY_SHOOTWAND.blp", false
	end

	if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
		return I.autoattack:ID()
	end

	

end--end in combat rotation here



if not Player:AffectingCombat() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then 

	if IsReady('Arcane Intellect') and not AuraUtil.FindAuraByName("Arcane Intellect","player") and Player:IsMoving() then
		return S.ArcaneIntellect:Cast()
	end
	if IsReady('Mage Armor') and instanceType~= 'pvp' and Player:ManaPercentage()>65 and Player:IsMoving() and not AuraUtil.FindAuraByName("Mage Armor","player") then
		return S.MageArmor:Cast()
	end
	if IsReady('Frost Armor') and instanceType== 'pvp' and Player:ManaPercentage()>65 and Player:IsMoving() and not AuraUtil.FindAuraByName("Frost Armor","player") and not AuraUtil.FindAuraByName("Mage Armor","player")  then
		return S.FrostArmor:Cast()
	end

	-- if IsReady('Mana Shield') and Player:ManaPercentage()>65 and Player:IsMoving() and not AuraUtil.FindAuraByName("Mana Shield","player") then
	-- 	return S.ManaShield:Cast()
	-- end
	
	end
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end
	
GriphRH.Rotation.SetAPL(8, APL);
GriphRH.Rotation.SetPASSIVE(8, PASSIVE);
