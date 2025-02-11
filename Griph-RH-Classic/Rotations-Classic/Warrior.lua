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

GriphRH.Spell[1] = {
    GladiatorStance = Spell(412513),
    MortalStrike2 = Spell(21555),
    ConsumedByRage = Spell(425418),
    ShieldBash = Spell(72),
    Enrage = Spell(425415),
    RagingBlow = Spell(402911),
    Charge = Spell(100),
    Rampage = Spell(426940),
    Overpower = Spell(7887),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend = Spell(772),
    Rend2 = Spell(6546),
    Bloodthirst = Spell(23881),
    Rend3 = Spell(6547),
    BerserkerStance = Spell(2458),
    QuickStrike = Spell(429765),
    Intercept = Spell(20252),
    WilloftheForsaken = Spell(7744),
    SweepingStrikes = Spell(12292),
    Slam = Spell(1464),
    EnragedRegeneration = Spell(402913),
    HeroicStrike = Spell(78),
    Retaliation = Spell(20230),
    Cleave = Spell(845),
    BerserkerRage = Spell(18499),
    berserkerrage = Spell(20554), --berserking

	Whirlwind = Spell(1680),
    BattleStance = Spell(2457),
    TasteforBlood = Spell(426969),
	Bloodrage = Spell(2687),
	BattleShout = Spell(6673),
    DeathWish = Spell(12328),
    CommandingShout = Spell(403215),
    MortalStrike = Spell(12294),
	Hamstring = Spell(1715),
	ThunderClap = Spell(11581),
    Pummel =  Spell(6552),
    TacticalMastery = Spell(12679),
    VictoryRush = Spell(402927),

};

local S = GriphRH.Spell[1]

if not Item.Warrior then
    Item.Warrior = {}
end
Item.Warrior.Arms = {
autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Warrior.Arms;




local function GetTankedEnemiesInRange()
    local count = 0
    local enemiesInRange = RangeCount(10)  -- Get the number of enemies within 10 yards

    for i = 1, enemiesInRange do
        local unitID = "nameplate" .. i  -- Iterate through nameplates
        if UnitExists(unitID) and UnitCanAttack("player", unitID) then
            local isTanking, status = UnitDetailedThreatSituation("player", unitID)
            if isTanking then
                count = count + 1
            end
        end
    end

    return count
end








local function APL()

    inRange5 = RangeCount(5)
    targetRange5 = TargetinRange(5)
    targetRange25 = TargetinRange(25)
    local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end


        local namegladiator = GetSpellInfo('Gladiator Stance' )
        local namebattleforecast = GetSpellInfo('Battle Forecast')
        local nameechoesofberserkerstance = GetSpellInfo('Echoes of Berserker Stance')
        local namebloodsurge = GetSpellInfo('Blood Surge')
        local namebloodfrenzy = GetSpellInfo('Blood Frenzy')


        local nameflagellation = GetSpellInfo('Flagellation' )
    local nameprecisetiming = GetSpellInfo('Precise Timing' )

    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
    or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end

    if AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL") then
        renddebuff = select(6,AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL")) - GetTime()
         else
            renddebuff = 0 
        end
        nextauto = math.max(0, (GriphRH.lasthit()-UnitAttackSpeed('player'))*-1)

-- if HasMainhandWeapon() and HasOffhandWeapon() and namegladiator~='Gladiator Stance' then
--     dwfury = true
--     arms = false
--     glad = false
-- elseif namegladiator=='Gladiator Stance' then
--     glad = true
--     dwfury = false
--     arms = false
-- else
--     glad = false
--     arms = true
--     dwfury = false
-- end

-- print("8:",IsItemInRange(37932,"target")) --voodoo charm




local usewwST = (S.MortalStrike:IsAvailable() and S.MortalStrike:CooldownRemains() >= 2 or not S.MortalStrike:IsAvailable() or S.MortalStrike2:IsAvailable() and S.MortalStrike2:CooldownRemains() >= 2 or not S.MortalStrike2:IsAvailable()) 
-- print('berserker stance: ',berserkerstance)
-- print('check op: ',checkOverpower())
-- print("Taste for Blood: ",Player:Buff(S.TasteforBlood))
-- print("dontspend ",dontspend)

-- if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance") and CheckInteractDistance("target", 3) and berserkerstance == true
-- and S.BerserkerStance:TimeSinceLastCast()>2
-- then
--     return S.BerserkerStance:Cast()
-- end
-- print('form true',GetShapeshiftFormID() ~= 19)
-- print( 'isready berserker stance',IsReady("Berserker Stance") )
-- print('range',CheckInteractDistance("target", 3))
-- print('berserker stance variable',berserkerstance)
-- print('TimeSinceLastCast',S.BerserkerStance:TimeSinceLastCast()>2)


if AuraUtil.FindAuraByName("Blessing of Freedom","target") 
or AuraUtil.FindAuraByName("Free Action","target")
or AuraUtil.FindAuraByName("Decoy Totem","target") 
or AuraUtil.FindAuraByName("Evasion","target") then
    hamstringTarget = false
else
    hamstringTarget = true
end
if AuraUtil.FindAuraByName("Divine Protection","target") 
or AuraUtil.FindAuraByName("Ice Block","target") 
or AuraUtil.FindAuraByName("Blessing of Protection","player") 
or AuraUtil.FindAuraByName("Blessing of Protection","target") 
or AuraUtil.FindAuraByName("Invulnerability","target") 
or AuraUtil.FindAuraByName("Dispersion","target") then
    stoprotation = true
else
    stoprotation = false
end
local STttd = UnitHealth("target")/getCurrentDPS()
local _,instanceTypepvp = IsInInstance()
local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local channelTime = elapsedTimech / 1000

local castTime = elapsedTimeca / 1000

local castchannelTime = math.random(275, 500) / 1000

local spellwidgetfort= UnitCastingInfo("target")
-- print(AuraUtil.FindAuraByName("Aspect of the Hawk","target"))
if AuraUtil.FindAuraByName("Commanding Shout","player","PLAYER") then
    commandingshoutbuffremains = select(6,AuraUtil.FindAuraByName("Commanding Shout","player","PLAYER"))- GetTime()
else
    commandingshoutbuffremains = 0
end
if AuraUtil.FindAuraByName("Battle Shout","player","PLAYER") then
    battleshoutbuffremains = select(6,AuraUtil.FindAuraByName("Battle Shout","player","PLAYER"))- GetTime()
else
    battleshoutbuffremains = 0
end
local namerampage = GetSpellInfo('Rampage')



local nametasteforblood = GetSpellInfo('Taste for Blood')
if AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL") then
    sunderarmorstack =select(3,AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL"))
else
    sunderarmorstack = 0
end
-- print(RangeCount(8))

if AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL") then
    sunderarmorremains = select(6,AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL")) - GetTime()
     else
        sunderarmorremains = 0 
    end
    if AuraUtil.FindAuraByName("Battle Forecast","player","PLAYER") then
        battleforecastremains = select(6,AuraUtil.FindAuraByName("Battle Forecast","player","PLAYER")) - GetTime()
         else
            battleforecastremains = 0 
        end
        if AuraUtil.FindAuraByName("Echoes of Berserker Stance","player","PLAYER") then
            echoesofberserkerstanceremains = select(6,AuraUtil.FindAuraByName("Echoes of Berserker Stance","player","PLAYER")) - GetTime()
             else
                echoesofberserkerstanceremains = 0 
            end
local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()

if AuraUtil.FindAuraByName("Consumed By Rage","player") then
    CbRstack = select(3,AuraUtil.FindAuraByName("Consumed By Rage","player"))
else
    CbRstack = 0
end


if (checkOverpower()==true or Player:Buff(S.TasteforBlood) ) and S.Overpower:CooldownRemains()<1.5 then
    canoverpower = true
else
    canoverpower = false
end

if (Target:IsAPlayer() and UnitIsUnit("targettarget", "player") and  Player:HealthPercentage()<40
     or GetTankedEnemiesInRange()>=2 and Player:HealthPercentage()<75 and S.Whirlwind:CooldownRemains()>1) and CheckInteractDistance("target", 3) and S.Retaliation:CooldownRemains()<2
     then
        retaliation = true
     else retaliation = false
     end
if RangeCount(10)>1 and GriphRH.AoEON() and S.SweepingStrikes:IsAvailable() and S.SweepingStrikes:CooldownRemains()<2 and Player:Rage()<30  then
    dontspend = false
else
    dontspend = true
end

if CheckInteractDistance("target", 3)  and S.Whirlwind:CooldownRemains()>2 
and (canoverpower or retaliation == true) 
 and Player:Rage()<=25 then
    berserkerstance = false
    battlestance = true
else
    berserkerstance = true
    battlestance = false
end


if (S.SweepingStrikes:CooldownRemains()>2 and S.Whirlwind:CooldownRemains()>2 or Player:Rage()>=30 or Player:Rage()>=25 and S.SweepingStrikes:CooldownRemains()>2) then
    spendaoe = true
else
    spendaoe = false
end



-- print(UnitCreatureType("target"))



-- print(IsSpellInRange('Charge', 'target') == 1 )

if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	
  if  IsPlayerFeared() and IsReady("Will of the Forsaken") then
    return S.WilloftheForsaken:Cast()
  end
  if  IsPlayerFeared() and IsReady("Berserker Rage") and S.WilloftheForsaken:CooldownRemains()>2 then
    return S.berserkerrage:Cast()
  end


if IsReady("Enraged Regeneration") and Player:HealthPercentage()<70 then
    return S.EnragedRegeneration:Cast()
end

    if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
        return I.autoattack:ID()
    end
 
    if Target:IsAPlayer() and IsReady("Rallying Cry") and inRange25>=1 and Player:HealthPercentage()<=15 then
        return S.RallyingCry:Cast()
    end	

    if retaliation == true and IsReady("Retaliation") then
        return S.Retaliation:Cast()
    end	


    -- if GetShapeshiftFormID() ~= 24 and IsReady("Gladiator Stance") and namebattleforecast == "Battle Forecast" and battleforecastremains <=3 then
    --     return S.GladiatorStance:Cast()
    -- end


    -- if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and namebattleforecast == "Battle Forecast" and battleforecastremains <=3 and namegladiator ~="Glaidator Stance" then
    --     return S.BattleStance:Cast()
    -- end
    -- if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance") and nameechoesofberserkerstance == "Echoes of Berserker Stance" and echoesofberserkerstanceremains <=3  then
    --     return S.BerserkerStance:Cast()
    -- end


    if stoprotation == false then 
        if IsReady("Shield Bash") and spellwidgetfort~='Widget Fortress' and (Target:IsChanneling() or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and CheckInteractDistance("target", 3) and GriphRH.InterruptsON() then
            return S.ShieldBash:Cast()
        end
        if IsReady("Pummel") and spellwidgetfort~='Widget Fortress' and (Target:IsChanneling() or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and CheckInteractDistance("target", 3) and GriphRH.InterruptsON() then
            return S.Pummel:Cast()
        end
        if IsReady("Victory Rush") and CheckInteractDistance("target", 3) and Player:HealthPercentage()<75 then
            return S.VictoryRush:Cast()
        end	
        if Target:IsAPlayer() and hamstringTarget== true and IsReady("Hamstring") and CheckInteractDistance("target", 3) and  not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
            return S.Hamstring:Cast()
        end

        if IsReady("Bloodrage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Berserker Rage","player")  then
            return S.Bloodrage:Cast()
        end
        if  IsReady("Berserker Rage")  and not AuraUtil.FindAuraByName("Bloodrage","player") and (Player:HealthPercentage()<90 or GetTankedEnemiesInRange()>=1) then
            return S.berserkerrage:Cast()
          end






--AOE rotation




if RangeCount(15)>=2 and GriphRH.AoEON() then



if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and CheckInteractDistance("target", 3) 
and S.SweepingStrikes:CooldownRemains()<2 and S.BerserkerStance:TimeSinceLastCast()>1.5 and S.BattleStance:TimeSinceLastCast()>1.5
then
    return S.BattleStance:Cast()
end

if IsReady("Sweeping Strikes") and CheckInteractDistance("target", 3)  then
    return S.SweepingStrikes:Cast()
end	

if GetShapeshiftFormID() ~= 19  and IsReady("Berserker Stance") 
and (S.Whirlwind:CooldownRemains()<2 and AuraUtil.FindAuraByName("Sweeping Strikes","player") 
or S.SweepingStrikes:CooldownRemains()>2) and not canoverpower
and CheckInteractDistance("target", 3) and S.BerserkerStance:TimeSinceLastCast()>1.5 and S.BattleStance:TimeSinceLastCast()>1.5 then
   return S.BerserkerStance:Cast()
end

if IsReady("Execute")  and CheckInteractDistance("target", 3) and AuraUtil.FindAuraByName("Sudden Death","player") then
    return S.Execute:Cast()
end	

if  IsReady('Whirlwind') and UnitCreatureType("target") ~= "Totem" and TargetinRange(5)
and (Player:Rage()>=25 and S.SweepingStrikes:CooldownRemains()>2 or Player:Rage()>=30) then
    return S.Whirlwind:Cast()
end


if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") 
and CheckInteractDistance("target", 3) and S.Whirlwind:CooldownRemains()>2 and S.SweepingStrikes:CooldownRemains()>2
and (canoverpower or retaliation)  and S.BerserkerStance:TimeSinceLastCast()>1.5 and S.BattleStance:TimeSinceLastCast()>1.5
then
    return S.BattleStance:Cast()
end

if IsReady("Rend")  and CheckInteractDistance("target", 3) and spendaoe
and renddebuff == 0 and (nametasteforblood == "Taste for Blood" or namebloodfrenzy == "Blood Frenzy")  
and (UnitCreatureType("target") == "Beast" 
or UnitCreatureType("target") == "Dragonkin" 
or UnitCreatureType("target") == "Humanoid" 
or UnitCreatureType("target") == "Demon" 
or UnitCreatureType("target") == "Giant" 
or UnitCreatureType("target") == "Critter" 
or UnitCreatureType("target") == "Not specified" 
or UnitCreatureType("target") == "Non-combat Pet" 
 )

then
    return S.Rend:Cast()
end  


if  IsReady('Overpower') and CheckInteractDistance("target", 3) and spendaoe then
    return S.Overpower:Cast()
end

if IsReady("Slam") and CheckInteractDistance("target", 3) 
and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge","player") and spendaoe then
    return S.Slam:Cast()
end  

if IsReady("Execute")  and CheckInteractDistance("target", 3) and spendaoe then
    return S.Execute:Cast()
end	

if  IsReady("Cleave") and not IsCurrentSpell(SpellRank('Cleave'))
and TargetinRange(5) and spendaoe then
   return S.Cleave:Cast()
end	


end


if RangeCount(15)==1 or not GriphRH.AoEON() or RangeCount(15)==2 and STttd<2 and HL.CombatTime()>2 then
    

    if GetShapeshiftFormID() ~= 19  and IsReady("Berserker Stance") 
    and not canoverpower
    and CheckInteractDistance("target", 3) and S.BerserkerStance:TimeSinceLastCast()>1.5 and S.BattleStance:TimeSinceLastCast()>1.5 then
       return S.BerserkerStance:Cast()
    end
    
    
    
    if IsReady("Execute")  and CheckInteractDistance("target", 3) and AuraUtil.FindAuraByName("Sudden Death","player") then
        return S.Execute:Cast()
    end	
    
    
    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") 
    and CheckInteractDistance("target", 3) and S.Whirlwind:CooldownRemains()>2
    and (canoverpower or retaliation) and S.BerserkerStance:TimeSinceLastCast()>1.5 and S.BattleStance:TimeSinceLastCast()>1.5
    then
        return S.BattleStance:Cast()
    end
    
    if IsReady("Rend")  and CheckInteractDistance("target", 3) 
    and renddebuff == 0 and (nametasteforblood == "Taste for Blood" or namebloodfrenzy == "Blood Frenzy")  
    and (UnitCreatureType("target") == "Beast" 
    or UnitCreatureType("target") == "Dragonkin" 
    or UnitCreatureType("target") == "Humanoid" 
    or UnitCreatureType("target") == "Demon" 
    or UnitCreatureType("target") == "Giant" 
    or UnitCreatureType("target") == "Critter" 
    or UnitCreatureType("target") == "Not specified" 
    or UnitCreatureType("target") == "Non-combat Pet" 
     )
    
    then
        return S.Rend:Cast()
    end  
    
    
    if  IsReady('Overpower') and CheckInteractDistance("target", 3)  then
        return S.Overpower:Cast()
    end
    
    if IsReady("Slam") and CheckInteractDistance("target", 3) 
    and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge","player")  then
        return S.Slam:Cast()
    end  
    if  IsReady('Whirlwind')  and TargetinRange(5) then
        return S.Whirlwind:Cast()
    end
    if IsReady("Execute")  and CheckInteractDistance("target", 3) and Player:Rage()>=25 then
        return S.Execute:Cast()
    end	

    if  IsReady("Heroic Strike") and not IsCurrentSpell(SpellRank('Cleave')) and not IsCurrentSpell(SpellRank('Heroic Strike'))
    and CheckInteractDistance("target", 3) and Player:Rage()>30  then
       return S.HeroicStrike:Cast()
    end	
    


end





  




end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Out of combat----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	if not IsCurrentSpell(6603) and targetRange5 and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		return I.autoattack:ID()
	end


    if IsReady("Commanding Shout") and Player:IsMoving() and commandingshoutbuffremains<10 and not AuraUtil.FindAuraByName("Blood Pact", "player") then
        return S.CommandingShout:Cast()
    end


    -- if GetShapeshiftFormID() ~= 24 and IsReady("Gladiator Stance")  then
    --     return S.GladiatorStance:Cast()
    -- end
    if GetShapeshiftFormID() ~= 17 and Player:IsMoving() and IsReady("Battle Stance") and RangeCount(10)==0 and Player:Rage()<25 and (S.Charge:CooldownRemains()<2 or S.Intercept:CooldownRemains()>2) then
        return S.BattleStance:Cast()
    end

    -- if (GetShapeshiftFormID() == 17 or GetShapeshiftFormID() == 24)  and IsReady('Charge') and not IsCurrentSpell(SpellRank('Charge')) and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and targetRange25 and not TargetinRange(5) then
    --     return S.Charge:Cast()
    -- end
    -- if (GetShapeshiftFormID() == 19 or GetShapeshiftFormID() == 24)  and IsReady('Intercept') and not IsCurrentSpell(SpellRank('Intercept')) and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and targetRange25 and not TargetinRange(5) then
    --     return S.Intercept:Cast()
    -- end

end

	
return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(1, APL);
