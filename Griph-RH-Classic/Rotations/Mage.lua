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
	shadowprotection = Spell(605), --mind control
	Shoot = Spell(5019),
	Scorch = Spell(2948),
	chestrune = Spell(20594),--stoneform
	handrune = Spell(20554), --berserking
	legrune = Spell(20580), --shadowmeld
	Pyroblast = Spell(11366),
	feetrune = Spell(1706), -- levitate
	Fireball = Spell(133),
	waistrune = Spell(7744), --will of the forsaken
	FireBlast = Spell(10199),
	Default = Spell(1),
	Frostbolt = Spell(116),
	Counterspell = Spell(2139),
	FrostArmor = Spell(168),
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

		targetRange30 = TargetInRange("Frostbolt")


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


local scorchDebuff, scorchCount, scorchExpiration = AuraUtil.FindAuraByName("Improved Scorch", "target", "PLAYER|HARMFUL")
local scorchRemainingTime = scorchDebuff and (scorchExpiration - GetTime()) or 0






if Player:CanAttack(Target) and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and (Player:AffectingCombat() or IsCurrentSpell(5019) or Target:AffectingCombat() or IsCurrentSpell(6603) or S.Frostbolt:InFlight() or S.Fireball:InFlight()) and not Target:IsDeadOrGhost() then 




	if IsReady("Counterspell") and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetRange30 and GriphRH.InterruptsON() then
		return S.Counterspell:Cast()
	end

	if IsReady("Evocation") and Player:ManaPercentage()<=15 and instanceType~= 'pvp' and instanceType~= 'none' and GriphRH.CDsON() then
		return S.Evocation:Cast()
	end


	if IsReady('Scorch') and targetRange30 and (not scorchDebuff or  S.ImprovedScorch:IsAvailable() and (scorchCount < 5 or scorchRemainingTime <= 5)) and not Player:IsMoving() then
		return S.Scorch:Cast()
	end
	
	if IsReady('Pyroblast') and AuraUtil.FindAuraByName("Hot Streak", "player") then
		return S.Pyroblast:Cast()
	end
	
	if IsReady('Fireball') and AuraUtil.FindAuraByName("Combustion", "player") and AuraUtil.FindAuraByName("Icy Veins", "player") and not Player:IsMoving() then
		return S.Fireball:Cast()
	end
	
	if IsReady('Fire Blast')  then
		return S.FireBlast:Cast()
	end

	if IsReady('Scorch') and not Player:IsMoving() then
		return S.Scorch:Cast()
	end
	if IsReady('Fireball') and not Player:IsMoving() then
		return S.Fireball:Cast()
	end

	if GCDRemaining()==0  and not IsAutoRepeatAction(Shoot) and not IsCurrentSpell(5019) and not Player:IsMoving() and targetRange30 and Player:ManaPercentage()<10 then
		return "Interface\\Addons\\Griph-RH-Classic\\Media\\ABILITY_SHOOTWAND.blp", false
	end

	if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
		return I.autoattack:ID()
	end

end



if not Player:AffectingCombat() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then 

	if IsReady('Arcane Intellect') and not AuraUtil.FindAuraByName("Arcane Intellect","player") and Player:IsMoving() then
		return S.ArcaneIntellect:Cast()
	end
	
	if IsReady('Frost Armor') and Player:ManaPercentage()>80 and Player:IsMoving() and not AuraUtil.FindAuraByName("Frost Armor","player") then
		return S.FrostArmor:Cast()
	end
	
	
	end
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end
	
GriphRH.Rotation.SetAPL(8, APL);
GriphRH.Rotation.SetPASSIVE(8, PASSIVE);
