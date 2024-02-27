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

RubimRH.Spell[1] = {
    ConsumedByRage = Spell(425418),
    Enrage = Spell(425415),
    RagingBlow = Spell(402911),
    ragingblow = Spell(20589),--escape artist
    Charge = Spell(100),
    Overpower = Spell(7384),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend1 = Spell(772),
    Rend2 = Spell(6546),
    Bloodthirst = Spell(23881),
    Rend3 = Spell(6547),
    BerserkerStance = Spell(2458),
    QuickStrike = Spell(429765),
    quickStrike = Spell(20594), --stone form
    Slam = Spell(1464),
    HeroicStrike = Spell(78),
    Cleave = Spell(845),
    BerserkerRage = Spell(18499),
	-- Warstomp = Spell(20549),
	Whirlwind = Spell(1680),
    BattleStance = Spell(7165),
	Bloodrage = Spell(2687),
	-- Execute = Spell(20662),
	BattleShout1 = Spell(6673),
    BattleShout2 = Spell(5242),
    DeathWish = Spell(12328),
    BattleShout3 = Spell(6192),
    MortalStrike = Spell(12294),
	
	ThunderClap = Spell(11581),
	
};

local S = RubimRH.Spell[1]

if not Item.Warrior then
    Item.Warrior = {}
end
Item.Warrior.Arms = {
autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Warrior.Arms;





local function APL()



    local inRange25 = 0
    for i = 1, 40 do
        if UnitExists('nameplate' .. i) then
            inRange25 = inRange25 + 1
        end
    end

    inRange5 = RangeCount("Rend")

    local nameflagellation = GetSpellInfo('Flagellation' )
    local nameprecisetiming = GetSpellInfo('Precise Timing' )

    targetRange5 = TargetInRange("Rend")
    targetRange25 = TargetInRange("Charge")

    if AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL") then
        renddebuff = select(6,AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL")) - GetTime()
         else
            renddebuff = 0 
        end
        nextauto = math.max(0, (RubimRH.lasthit()-UnitAttackSpeed('player'))*-1)

if HasMainhandWeapon() and HasOffhandWeapon() then
    dwfury = true
    arms = false
else
    arms = true
    dwfury = false
end
-- print(GetShapeshiftFormID())
--  BattleStance -- GetShapeshiftFormID() == 1
--  DefensiveStance -- GetShapeshiftFormID() == 2
--  BerserkerStance -- GetShapeshiftFormID() == 3
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------DW FURY----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and dwfury == true then
	
        if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
            return I.autoattack:ID()
        end

        if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance") and RangeCount11()>=1 and not AuraUtil.FindAuraByName("Overpower","player") then
            return S.BerserkerStance:Cast()
        end

        if IsReady("Death Wish") and CheckInteractDistance("target",3) then
            return S.DeathWish:Cast()
        end	

        if IsReady("Bloodrage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") then
            return S.Bloodrage:Cast()
        end

        if IsReady("Berserker Rage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") then
            return S.BerserkerRage:Cast()
        end

        if IsReady("Execute") and Target:HealthPercentage()<=20 and CheckInteractDistance("target",2) then
            return S.Execute:Cast()
        end	

        if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and AuraUtil.FindAuraByName("Overpower","player") and RangeCount11()>=1 then
            return S.BattleStance:Cast()
        end

        if IsReady("Overpower") and CheckInteractDistance("target",2) then
            return S.Overpower:Cast()
        end	

        if IsReady('Heroic Strike') and Target:HealthPercentage()<=20 and RangeCount11() ==1 and CheckInteractDistance("target",2) and not IsCurrentSpell(SpellRank('Heroic Strike'))  then
            return S.HeroicStrike:Cast()
        end
        if IsReady('Whirlwind') and RangeCount10() > 1 and CheckInteractDistance("target",2) then
            return S.Whirlwind:Cast()
        end
        
        if IsReady('Bloodthirst') and CheckInteractDistance("target",2) then
            return S.Bloodthirst:Cast()
        end
        
        if IsReady('Slam')  and CheckInteractDistance("target",2) and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
            return S.Slam:Cast()
        end
        
        if IsReady('Raging Blow')  and CheckInteractDistance("target",2) and S.Bloodthirst:CooldownRemains() >= 1.5  then
            return S.ragingblow:Cast()
        end
        
        if IsReady('Whirlwind')  and CheckInteractDistance("target",2) and S.Bloodthirst:CooldownRemains() >= 1.5 then
            return S.Whirlwind:Cast()
        end
        
        if IsReady('Quick Strike')  and CheckInteractDistance("target",2) and S.Bloodthirst:CooldownRemains() >= 1.5 and S.Whirlwind:CooldownRemains() >= 1.5 and Player:Rage() >= 50 then
            return S.quickstrike:Cast()
        end
        
        if IsReady('Cleave')  and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() > 1 then
            return S.Cleave:Cast()
        end
        
        if IsReady('Heroic Strike')  and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() == 1 then
            return S.HeroicStrike:Cast()
        end
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------2H ARMS----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and arms == true then
	
    if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
        return I.autoattack:ID()
    end

    if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance") and RangeCount11()>=1 and not AuraUtil.FindAuraByName("Overpower","player") then
    return S.BerserkerStance:Cast()
    end

    if IsReady("Bloodrage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") then
    return S.Bloodrage:Cast()
    end

    if IsReady("Berserker Rage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") then
    return S.BerserkerRage:Cast()
    end

    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and AuraUtil.FindAuraByName("Overpower","player") and RangeCount11()>=1 then
        return S.BattleStance:Cast()
        end
    
        if IsReady("Overpower") and CheckInteractDistance("target",2) then
        return S.Overpower:Cast()
        end	

        if IsReady('Whirlwind') and RangeCount10() > 1 and CheckInteractDistance("target",2) then
            return S.Whirlwind:Cast()
        end
        

    if IsReady("Mortal Strike") and CheckInteractDistance("target",2) then
    return S.MortalStrike:Cast()
    end	

    if IsReady('Slam')  and CheckInteractDistance("target",2) and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
        return S.Slam:Cast()
    end
    if IsReady('Raging Blow')  and CheckInteractDistance("target",2) and S.MortalStrike:CooldownRemains() >= 1.5  then
        return S.ragingblow:Cast()
    end

    if IsReady('Whirlwind')  and CheckInteractDistance("target",2) and S.MortalStrike:CooldownRemains() >= 1.5 then
        return S.Whirlwind:Cast()
    end

    if IsReady('Quick Strike')  and CheckInteractDistance("target",2) and S.MortalStrike:CooldownRemains() >= 1.5 and S.Whirlwind:CooldownRemains() >= 1.5 and Player:Rage() >= 50 then
        return S.quickstrike:Cast()
    end


    if IsReady("Execute") and Target:HealthPercentage()<=20 and CheckInteractDistance("target",2) then
    return S.Execute:Cast()
    end	
    if IsReady('Cleave')  and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() > 1 then
        return S.Cleave:Cast()
    end
    if IsReady('Heroic Strike')  and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() == 1 then
        return S.HeroicStrike:Cast()
    end
    
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Out of combat----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	if not IsCurrentSpell(6603) and targetRange5 then
		return I.autoattack:ID()
	end

    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and RangeCount11() ==0 then
        return S.BattleStance:Cast()
    end

if IsCurrentSpell(6603) and GetShapeshiftFormID() == 1 and IsReady('Charge') and not IsCurrentSpell(SpellRank('Charge')) and targetRange25 then
    return S.Charge:Cast()
end


end

	
return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

RubimRH.Rotation.SetAPL(1, APL);
