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
    chestrune = Spell(20589),--escape artist
    Charge = Spell(100),
    Overpower = Spell(7887),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend1 = Spell(772),
    Rend2 = Spell(6546),
    Bloodthirst = Spell(23881),
    Rend3 = Spell(6547),
    BerserkerStance = Spell(2458),
    QuickStrike = Spell(429765),
    handrune = Spell(20580),--shadowmeld
    SweepingStrikes = Spell(12292),
    Slam = Spell(1464),
    HeroicStrike = Spell(78),
    Cleave = Spell(845),
    BerserkerRage = Spell(18499),
	-- Warstomp = Spell(20549),
	Whirlwind = Spell(1680),
    BattleStance = Spell(2457),
	Bloodrage = Spell(2687),
	-- Execute = Spell(20662),
	BattleShout1 = Spell(6673),
    BattleShout2 = Spell(5242),
    DeathWish = Spell(12328),
    BattleShout3 = Spell(6192),
    CommandingShout = Spell(469),
    MortalStrike = Spell(12294),
	Hamstring = Spell(1715),
	ThunderClap = Spell(11581),
    commandingshout = Spell(20580), -- shadowmeld
	
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

    local function OnEvent(self, event, unitTarget, event1, flagText, amount, schoolMask)
        if unitTarget == 'target' and event1 == 'DODGE' and S.Overpower:CooldownRemains()<2 then
            overpower = true 
        else
            overpower = false
        end
    end
    
    local f = CreateFrame("Frame")
    f:RegisterEvent("UNIT_COMBAT")
    f:SetScript("OnEvent", OnEvent)
    
  
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


if CheckInteractDistance("target",3) and (overpower == true or S.SweepingStrikes:CooldownRemains()<2 and S.SweepingStrikes:IsAvailable() and RangeCount11()>1 and RubimRH.CDsON()) then
    battlestance = true
    berserkerstance = false
else
    battlestance = false
    berserkerstance = true
end



--  BattleStance -- GetShapeshiftFormID() == 1
--  DefensiveStance -- GetShapeshiftFormID() == 2
--  BerserkerStance -- GetShapeshiftFormID() == 3
-- print(S.BattleStance:TimeSinceLastCast())
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------DW FURY----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--   print(IsReady("Overpower"))
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and dwfury == true then
	
        if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
            return I.autoattack:ID()
        end

        if Target:IsAPlayer() and IsReady("Hamstring") and CheckInteractDistance("target",2) and (GetUnitSpeed("target") /7 *100)>65 and not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
            return S.Hamstring:Cast()
        end

        if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance") and CheckInteractDistance("target",3) and berserkerstance == true and Player:Rage()<50 then
            return S.BerserkerStance:Cast()
        end

        if IsReady("Death Wish") and CheckInteractDistance("target",3) then
            return S.DeathWish:Cast()
        end	
        

        
        if IsReady("Bloodrage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Berserker Rage","player") then
            return S.Bloodrage:Cast()
        end

        if IsReady("Berserker Rage") and CheckInteractDistance("target",2) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Bloodrage","player") then
            return S.BerserkerRage:Cast()
        end

        if IsReady("Execute") and Target:HealthPercentage()<=20 and CheckInteractDistance("target",2) then
            return S.Execute:Cast()
        end	

       

        if GetShapeshiftFormID() ~= 19 and S.BattleStance:TimeSinceLastCast()>1.5 and (S.Overpower:TimeSinceLastCast()>2 or berserkerstance == true) and IsReady("Berserker Stance") and CheckInteractDistance("target",3) and Player:Rage()<50 then
            return S.BerserkerStance:Cast()
        end
    

        if IsReady("Overpower") and CheckInteractDistance("target",2) then
            return S.Overpower:Cast()
        end	
      
        if Target:IsAPlayer() and IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
            return S.BattleShout1:Cast()
            end	
            if Target:IsAPlayer() and IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") then
                return S.commandingshout:Cast()
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
        
        if IsReady('Raging Blow')  and CheckInteractDistance("target",2) and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable())  then
            return S.chestrune:Cast()
        end
        
        if IsReady('Whirlwind')  and CheckInteractDistance("target",2) and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable()) then
            return S.Whirlwind:Cast()
        end
        if  IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
            return S.BattleShout1:Cast()
            end	

            if  IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") then
                return S.commandingshout:Cast()
                end	

        if IsReady('Quick Strike')  and CheckInteractDistance("target",2) and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable()) and (S.Whirlwind:IsAvailable() and S.Whirlwind:CooldownRemains() >= 1.5 or not S.Whirlwind:IsAvailable()) and Player:Rage() >= 50 then
            return S.handrune:Cast()
        end
        
        if IsReady('Cleave') and not IsCurrentSpell(SpellRank('Cleave')) and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() > 1 then
            return S.Cleave:Cast()
        end
        
        if IsReady('Heroic Strike') and not IsCurrentSpell(SpellRank('Heroic Strike')) and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() == 1 then
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

    if Target:IsAPlayer() and IsReady("Hamstring") and CheckInteractDistance("target",2) and (GetUnitSpeed("target") /7 *100)>65 and not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
        return S.Hamstring:Cast()
    end

    if Target:IsAPlayer() and IsReady("Mortal Strike") and CheckInteractDistance("target",2) and not AuraUtil.FindAuraByName("Mortal Strike","target","PLAYER|HARMFUL")  then
        return S.MortalStrike:Cast()
        end	
                

        if Target:IsAPlayer() and IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
            return S.BattleShout1:Cast()
            end	
            if Target:IsAPlayer() and IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") then
                return S.commandingshout:Cast()
                end	


    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and battlestance == true then
        return S.BattleStance:Cast()
    end

    if IsReady("Sweeping Strikes") and CheckInteractDistance("target",2) and RangeCount11()>1 and RubimRH.CDsON() then
        return S.SweepingStrikes:Cast()
    end

    if IsReady("Overpower") and CheckInteractDistance("target",3) and (RangeCount11()==1 or RangeCount11()>1 and AuraUtil.FindAuraByName("Sweeping Strikes","player") or S.SweepingStrikes:CooldownRemains()>2 or not S.SweepingStrikes:IsAvailable() or not RubimRH.CDsON()) then
        return S.Overpower:Cast()
    end


    if GetShapeshiftFormID() ~= 19 and CheckInteractDistance("target",3) and S.BattleStance:TimeSinceLastCast()>2 and berserkerstance == true and (RangeCount11()==1 or RangeCount11()>1 and S.SweepingStrikes:CooldownRemains()>2 ) and IsReady("Berserker Stance") and Player:Rage()<50 then
        return S.BerserkerStance:Cast()
    end

    
    if IsReady("Berserker Rage") and CheckInteractDistance("target",3) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Bloodrage","player") then
        return S.BerserkerRage:Cast()
    end

    if IsReady("Bloodrage") and CheckInteractDistance("target",3) and nameflagellation == 'Flagellation' and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Berserker Rage","player") then
        return S.Bloodrage:Cast()
    end


      


        if IsReady('Whirlwind') and RangeCount10() > 1 and CheckInteractDistance("target",2) then
            return S.Whirlwind:Cast()
        end

        if IsReady("Execute") and Target:HealthPercentage()<=20 and CheckInteractDistance("target",2) and Player:Rage()>=30 then
        return S.Execute:Cast()
        end	

    if IsReady("Mortal Strike") and CheckInteractDistance("target",2) then
    return S.MortalStrike:Cast()
    end	

    if IsReady('Slam') and (RangeCount11()==1 or RangeCount11()>1 and AuraUtil.FindAuraByName("Sweeping Strikes","player") or S.SweepingStrikes:CooldownRemains()>2 or not S.SweepingStrikes:IsAvailable() or not RubimRH.CDsON()) and CheckInteractDistance("target",2) and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
        return S.Slam:Cast()
    end
    if IsReady('Raging Blow')  and CheckInteractDistance("target",2) and (S.MortalStrike:IsAvailable() and S.MortalStrike:CooldownRemains() >= 1.5 or not S.MortalStrike:IsAvailable()) then
        return S.chestrune:Cast()
    end

    if IsReady('Whirlwind')  and CheckInteractDistance("target",2) and (S.MortalStrike:IsAvailable() and S.MortalStrike:CooldownRemains() >= 1.5 or not S.MortalStrike:IsAvailable()) then
        return S.Whirlwind:Cast()
    end

    if IsReady('Quick Strike') 
    and CheckInteractDistance("target",2) 
    and (not S.MortalStrike:IsAvailable() 
    or S.MortalStrike:IsAvailable() 
    and S.MortalStrike:CooldownRemains() >= 1.5) 
    and (not S.Whirlwind:IsAvailable() 
    or S.Whirlwind:IsAvailable() 
    and S.Whirlwind:CooldownRemains() >= 1.5) 
    and Player:Rage() >= 50 then
        return S.handrune:Cast()
    end


    if IsReady("Execute") and Target:HealthPercentage()<=20 and CheckInteractDistance("target",2) then
    return S.Execute:Cast()
    end	

    if IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
        return S.BattleShout1:Cast()
        end	
        if  IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") then
            return S.commandingshout:Cast()
            end	
    if IsReady('Cleave') and not IsCurrentSpell(SpellRank('Cleave'))  and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() > 1 then
        return S.Cleave:Cast()
    end
    if IsReady('Heroic Strike') and not IsCurrentSpell(SpellRank('Heroic Strike')) and CheckInteractDistance("target",2) and Player:Rage() >= 80 and RangeCount10() == 1 then
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

    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and inRange25==0 and IsReady('Charge') and Player:Rage()>50 then
        return S.BattleStance:Cast()
    end

    if GetShapeshiftFormID() == 17 and IsReady('Charge') and not IsCurrentSpell(SpellRank('Charge')) and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and targetRange25 then
        return S.Charge:Cast()
    end


end

	
return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

RubimRH.Rotation.SetAPL(1, APL);
