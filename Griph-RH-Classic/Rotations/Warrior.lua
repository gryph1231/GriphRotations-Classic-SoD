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
    
    MortalStrike2 = Spell(21555),
    ConsumedByRage = Spell(425418),
    ShieldBash = Spell(72),
    Enrage = Spell(425415),
    RagingBlow = Spell(402911),
    Charge = Spell(100),
    Overpower = Spell(7887),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend = Spell(772),
    Rend2 = Spell(6546),
    Bloodthirst = Spell(23881),
    Rend3 = Spell(6547),
    BerserkerStance = Spell(2458),
    QuickStrike = Spell(429765),
    SweepingStrikes = Spell(12292),
    Slam = Spell(1464),
    HeroicStrike = Spell(78),
    Cleave = Spell(845),
    BerserkerRage = Spell(18499),
	Whirlwind = Spell(1680),
    BattleStance = Spell(2457),
	Bloodrage = Spell(2687),
	BattleShout = Spell(6673),
    DeathWish = Spell(12328),
    CommandingShout = Spell(469),
    MortalStrike = Spell(12294),
	Hamstring = Spell(1715),
	ThunderClap = Spell(11581),
    Pummel =  Spell(6552),
    VictoryRush = Spell(402927),
    chestrune = Spell(20589),--GGL escape artist - BP macro /cast chest rune ability -- used for raging blow
    commandingshout = Spell(20549), --GGL war stomp - BP keybind is /cast commanding shout
    handrune = Spell(20580),--GGL shadowmeld - BP keybind /cast hands rune ability -- used for quick strike, victory rush (not in profile yet)
    feetrune = Spell(7744), --GGL will of the forsaken - BP keybind /cast feet rune ability -- used for intervene (not in profile yet)/rallying cry/engraged regeneration / gladiator stance(not in profile yet)
    wristrune = Spell(20594), --GGL stone form -- BP /cast wrist rune ability
};

local S = GriphRH.Spell[1]

if not Item.Warrior then
    Item.Warrior = {}
end
Item.Warrior.Arms = {
autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Warrior.Arms;



local function APL()
    inRange5 = RangeCount("Rend")
    targetRange5 = TargetInRange("Rend")
    targetRange25 = TargetInRange("Charge")
    local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end

        local namegladiator = GetSpellInfo('Gladiator Stance' )

    local nameflagellation = GetSpellInfo('Flagellation' )
    local nameprecisetiming = GetSpellInfo('Precise Timing' )

    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
    or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end
    -- print(namegladiator)

    if AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL") then
        renddebuff = select(6,AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL")) - GetTime()
         else
            renddebuff = 0 
        end
        nextauto = math.max(0, (GriphRH.lasthit()-UnitAttackSpeed('player'))*-1)

if HasMainhandWeapon() and HasOffhandWeapon() and namegladiator~='Gladiator Stance' then
    dwfury = true
    arms = false
    glad = false
elseif namegladiator=='Gladiator Stance' then
    glad = true
    dwfury = false
    arms = false
else
    glad = false
    arms = true
    dwfury = false
end


if GetShapeshiftFormID() == 19 then
    playerinBerserkerStance = true
else
    playerinBerserkerStance = false
end

if GetShapeshiftFormID() == 17 then
    playerinBattleStance = true
else
    playerinBattleStance = false
end


if targetrange11() and ((Target:HealthPercentage()>20 or Player:Rage()<30) and checkOverpower() == true or S.SweepingStrikes:CooldownRemains()<2 and S.SweepingStrikes:IsAvailable() and RangeCount10()>1 and GriphRH.CDsON() and GriphRH.AoEON() and not AuraUtil.FindAuraByName("Disarm","player","PLAYER|HARMFUL")) then
    berserkerstance = false
    battlestance = true
else
    berserkerstance = false
    battlestance = true
end
local usewwST = (S.MortalStrike:IsAvailable() and S.MortalStrike:CooldownRemains() >= 1.5 or not S.MortalStrike:IsAvailable() or S.MortalStrike2:IsAvailable() and S.MortalStrike2:CooldownRemains() >= 1.5 or not S.MortalStrike2:IsAvailable()) 


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


if AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL") then
    sunderarmorremains = select(6,AuraUtil.FindAuraByName("Sunder Armor","target","PLAYER|HARMFUL")) - GetTime()
     else
        sunderarmorremains = 0 
    end

local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()

if AuraUtil.FindAuraByName("Consumed By Rage","player") then
    CbRstack = select(3,AuraUtil.FindAuraByName("Consumed By Rage","player"))
else
    CbRstack = 0
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------DW FURY----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and dwfury == true and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	
        if not IsCurrentSpell(6603) and targetrange11() then
            return I.autoattack:ID()
        end
     
        if Target:IsAPlayer() and IsReady("Rallying Cry") and inRange25>=1 and Player:HealthPercentage()<=15 then
            return S.feetrune:Cast()
        end	

        if stoprotation == false then 

            if IsReady("Pummel") and spellwidgetfort~='Widget Fortress' and (Target:IsChanneling() or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetrange11() and GriphRH.InterruptsON() then
                return S.Pummel:Cast()
            end
            if IsReady("Victory Rush") and targetrange11() and Player:HealthPercentage()<50 then
                return S.handrune:Cast()
            end	
    
    

            if IsReady("Rampage") and targetrange11() and namerampage == 'Rampage'  and GriphRH.CDsON() then
                return S.wristrune:Cast()
            end	
    
            
            if Target:IsAPlayer() and hamstringTarget== true and IsReady("Hamstring") and targetrange11() and (GetUnitSpeed("target") /7 *100)>65 and not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
                return S.Hamstring:Cast()
            end
    

    

        if GetShapeshiftFormID() ~= 19  and IsReady("Berserker Stance") and targetrange11() then
            return S.BerserkerStance:Cast()
        end

        if IsReady("Death Wish") and targetrange11() and GriphRH.CDsON() then
            return S.DeathWish:Cast()
        end	
        if IsReady("Berserker Rage") and S.Bloodrage:TimeSinceLastCast()>5 and instanceTypepvp ~= 'pvp' and not Target:IsAPlayer() and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Bloodrage","player") then
            return S.BerserkerRage:Cast()
        end
    
        if IsReady("Bloodrage") and S.BerserkerRage:TimeSinceLastCast()>5 and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Berserker Rage","player") then
            return S.Bloodrage:Cast()
        end


        if IsReady("Execute") and Target:HealthPercentage()<=20 and targetrange11() then
            return S.Execute:Cast()
        end	

        if IsReady("Heroic Strike") and Target:HealthPercentage()<=20 and targetrange11() and not IsCurrentSpell(SpellRank('Heroic Strike'))  then
            return S.HeroicStrike:Cast()
        end	

      
        if Target:IsAPlayer() and IsReady("Battle Shout") and (not AuraUtil.FindAuraByName("Battle Shout","player") or battleshoutbuffremains<3) then
            return S.BattleShout:Cast()
        end	

        if Target:IsAPlayer() and IsReady("Commanding Shout") and (not AuraUtil.FindAuraByName("Commanding Shout","player") or commandingshoutbuffremains<3) and not AuraUtil.FindAuraByName("Blood Pact","player") then
            return S.commandingshout:Cast()
        end	


        if IsReady('Whirlwind') and RangeCount10() > 1 and GriphRH.AoEON() and targetrange11() then
            return S.Whirlwind:Cast()
        end
        
        if IsReady('Bloodthirst') and targetrange11() then
            return S.Bloodthirst:Cast()
        end
        
        if IsReady('Slam')  and targetrange11() and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
            return S.Slam:Cast()
        end
        
        if IsReady('Raging Blow')  and targetrange11() and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable())  then
            return S.chestrune:Cast()
        end
        
        if IsReady('Whirlwind')  and targetrange11() and Player:Rage()>50 then
            return S.Whirlwind:Cast()
        end

        if IsReady("Battle Shout") and (not AuraUtil.FindAuraByName("Battle Shout","player") or battleshoutbuffremains<3) then
            return S.BattleShout:Cast()
        end	

        if IsReady("Commanding Shout") and (not AuraUtil.FindAuraByName("Commanding Shout","player") or commandingshoutbuffremains<3) and not AuraUtil.FindAuraByName("Blood Pact","player") then
            return S.commandingshout:Cast()
        end	


        if IsReady('Quick Strike')  and targetrange11() and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable()) and (S.Whirlwind:IsAvailable() and S.Whirlwind:CooldownRemains() >= 1.5 or not S.Whirlwind:IsAvailable()) and Player:Rage() >= 50 then
            return S.handrune:Cast()
        end
        
        if IsReady('Cleave')  and not IsCurrentSpell(SpellRank('Cleave')) and targetrange11() and Player:Rage() >= 80 and RangeCount10() > 1 and GriphRH.AoEON() then
            return S.Cleave:Cast()
        end
        
        if IsReady('Heroic Strike') and not IsCurrentSpell(SpellRank('Heroic Strike')) and targetrange11() and Player:Rage() >= 80 and (RangeCount10() == 1 or not GriphRH.AoEON()) then
            return S.HeroicStrike:Cast()
        end
        
        if  IsReady("Hamstring") and targetrange11() and Player:Rage() >= 90 and (AuraUtil.FindAuraByName("Wild Strikes","player") or mainHandEnchantID == 563 or mainHandEnchantID == 1783) then
            return S.Hamstring:Cast()
        end

    end
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------2H ARMS----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and arms == true and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then
	
    if not IsCurrentSpell(6603) and targetrange11() then
        return I.autoattack:ID()
    end

    if Target:IsAPlayer() and IsReady("Rallying Cry") and inRange25>=1 and Player:HealthPercentage()<=15 then
        return S.feetrune:Cast()
    end	
    if IsReady("Intercept") and nottargetrange11() and GriphRH.InterruptsON() then
        return S.Charge:Cast()
    end



    if stoprotation == false then 
        if IsReady("Pummel") and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetrange11() and GriphRH.InterruptsON() then
            return S.Pummel:Cast()
        end
        if IsReady("Victory Rush") and targetrange11() and Player:HealthPercentage()<50 then
            return S.handrune:Cast()
        end	
    if Target:IsAPlayer() and hamstringTarget== true and IsReady("Hamstring") and targetrange11() and (GetUnitSpeed("target") /7 *100)>65 and not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
        return S.Hamstring:Cast()
    end

    if Target:IsAPlayer() and IsReady("Mortal Strike") and targetrange11() and not AuraUtil.FindAuraByName("Mortal Strike","target","PLAYER|HARMFUL")  then
        return S.MortalStrike:Cast()
        end	

    if Target:IsAPlayer() and IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
        return S.BattleShout:Cast()
    end	

    if Target:IsAPlayer() and IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") and not AuraUtil.FindAuraByName("Blood Pact","target") then
        return S.commandingshout:Cast()
    end	

    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and battlestance == true then
        return S.BattleStance:Cast()
    end

    if IsReady("Sweeping Strikes") and not AuraUtil.FindAuraByName("Disarm","player","PLAYER|HARMFUL") and targetrange11() and RangeCount10()>1 and GriphRH.CDsON() and GriphRH.AoEON() then
        return S.SweepingStrikes:Cast()
    end

    if IsReady("Overpower") and targetrange11() then
        return S.Overpower:Cast()
    end

    if GetShapeshiftFormID() ~= 19 and (HL.CombatTime()>2.5 or S.SweepingStrikes:CooldownRemains()>Player:GCD()*2) and S.BattleStance:TimeSinceLastCast()>2 and berserkerstance == true and IsReady("Berserker Stance") and targetrange11() and Player:Rage()<50 then
        return S.BerserkerStance:Cast()
    end
    
    if IsReady("Berserker Rage") and S.Bloodrage:TimeSinceLastCast()>5 and instanceTypepvp ~= 'pvp' and not Target:IsAPlayer() and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Bloodrage","player") then
        return S.BerserkerRage:Cast()
    end

    if IsReady("Bloodrage") and S.BerserkerRage:TimeSinceLastCast()>5 and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Berserker Rage","player") then
        return S.Bloodrage:Cast()
    end


    if IsReady('Whirlwind') and RangeCount10() > 1 and GriphRH.AoEON() and targetrange11() then
        return S.Whirlwind:Cast()
    end

    if IsReady("Execute") and Target:HealthPercentage()<=20 and targetrange11() and Player:Rage()>=30 then
        return S.Execute:Cast()
    end	

    if IsReady("Mortal Strike") and targetrange11() then
    return S.MortalStrike:Cast()
    end	

    if IsReady('Slam') and targetrange11() and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
        return S.Slam:Cast()
    end
    if IsReady('Raging Blow')  and targetrange11() and usewwST then
        return S.chestrune:Cast()
    end

    if IsReady('Whirlwind')  and targetrange11() and usewwST then
        return S.Whirlwind:Cast()
    end


    if IsReady('Quick Strike') 
    and targetrange11()
    and usewwST
    and (not S.Whirlwind:IsAvailable() 
    or S.Whirlwind:IsAvailable() 
    and S.Whirlwind:CooldownRemains() >= 1.5) 
    and Player:Rage() >= 50 then
        return S.handrune:Cast()
    end


    if IsReady("Execute") and Target:HealthPercentage()<=20 and targetrange11() then
    return S.Execute:Cast()
    end	

    if IsReady("Battle Shout") and not AuraUtil.FindAuraByName("Battle Shout","player") then
        return S.BattleShout:Cast()
    end	

    if IsReady("Commanding Shout") and not AuraUtil.FindAuraByName("Commanding Shout","player") and not AuraUtil.FindAuraByName("Blood Pact","target") then
        return S.commandingshout:Cast()
    end	


    if IsReady('Cleave') and not IsCurrentSpell(SpellRank('Cleave'))  and targetrange11() and Player:Rage() >= 80 and RangeCount10() > 1 and GriphRH.AoEON() then
        return S.Cleave:Cast()
    end

    if IsReady('Heroic Strike') and not IsCurrentSpell(SpellRank('Heroic Strike')) and targetrange11() and Player:Rage() >= 80 and (RangeCount10() == 1 or not GriphRH.AoEON()) then
        return S.HeroicStrike:Cast()
    end

    if  IsReady("Hamstring") and targetrange11() and Player:Rage() >= 90 and (AuraUtil.FindAuraByName("Wild Strikes","player") or mainHandEnchantID == 563 or mainHandEnchantID == 1783) then
        return S.Hamstring:Cast()
    end
end
end





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------gladiator----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and glad == true and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	



    if not IsCurrentSpell(6603) and targetrange11() then
        return I.autoattack:ID()
    end
 
    if Target:IsAPlayer() and IsReady("Rallying Cry") and inRange25>=1 and Player:HealthPercentage()<=15 then
        return S.feetrune:Cast()
    end	

    if GetShapeshiftFormID() ~= 24 and IsReady("Gladiator Stance")  then
        return S.feetrune:Cast()
    end

    if stoprotation == false then 


        if IsReady("Shield Bash") and spellwidgetfort~='Widget Fortress' and (Target:IsChanneling() or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetrange11() and GriphRH.InterruptsON() then
            return S.ShieldBash:Cast()
        end
        if IsReady("Pummel") and spellwidgetfort~='Widget Fortress' and (Target:IsChanneling() or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetrange11() and GriphRH.InterruptsON() then
            return S.Pummel:Cast()
        end
        if IsReady("Victory Rush") and targetrange11() and Player:HealthPercentage()<50 then
            return S.handrune:Cast()
        end	


        if IsReady("Rampage") and targetrange11() and namerampage == 'Rampage'  and GriphRH.CDsON() then
            return S.wristrune:Cast()
        end	

        
        if Target:IsAPlayer() and hamstringTarget== true and IsReady("Hamstring") and targetrange11() and (GetUnitSpeed("target") /7 *100)>65 and not AuraUtil.FindAuraByName("Hamstring","target","PLAYER|HARMFUL") then
            return S.Hamstring:Cast()
        end



    if IsReady("Death Wish") and targetrange11() and GriphRH.CDsON() and (Target:TimeToDie()<30 or HL.CombatTime()>10 and Target:TimeToDie()>180 or Target:IsAPlayer()) then
        return S.DeathWish:Cast()
    end	
    if IsReady("Berserker Rage") and S.Bloodrage:TimeSinceLastCast()>5 and instanceTypepvp ~= 'pvp' and not Target:IsAPlayer() and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Bloodrage","player") then
        return S.BerserkerRage:Cast()
    end

    if IsReady("Bloodrage") and S.BerserkerRage:TimeSinceLastCast()>5 and targetrange11() and not AuraUtil.FindAuraByName("Flagellation","player") and not AuraUtil.FindAuraByName("Berserker Rage","player") then
        return S.Bloodrage:Cast()
    end

    if IsReady('Whirlwind') and RangeCount10() > 1 and GriphRH.AoEON() and targetrange11() then
        return S.Whirlwind:Cast()
    end

    if IsReady("Overpower") and targetrange11() then
        return S.Overpower:Cast()
    end
    
    if IsReady("Sunder Armor") and targetrange11() and Target:TimeToDie()>30 and (sunderarmorstack<5 or sunderarmorremains<2) then
        return S.SunderArmor:Cast()
    end	


    if IsReady("Execute") and Target:HealthPercentage()<=20 and targetrange11() then
        return S.Execute:Cast()
    end	

    if IsReady("Cleave") and RangeCount11() > 1 and Target:HealthPercentage()<=20 and targetrange11() and not IsCurrentSpell(SpellRank('Cleave')) and targetrange11() then
        return S.Cleave:Cast()
    end	

    if IsReady("Heroic Strike") and RangeCount11() == 1 and Target:HealthPercentage()<=20 and targetrange11() and not IsCurrentSpell(SpellRank('Heroic Strike'))  then
        return S.HeroicStrike:Cast()
    end	





  
    if Target:IsAPlayer() and IsReady("Battle Shout") and (not AuraUtil.FindAuraByName("Battle Shout","player") or battleshoutbuffremains<3) then
        return S.BattleShout:Cast()
    end	

    if Target:IsAPlayer() and IsReady("Commanding Shout") and (not AuraUtil.FindAuraByName("Commanding Shout","player") or commandingshoutbuffremains<3) and not AuraUtil.FindAuraByName("Blood Pact","player") then
        return S.commandingshout:Cast()
    end	


    





    
    -- if IsReady('Bloodthirst') and targetrange11() then
    --     return S.Bloodthirst:Cast()
    -- end
    
    -- if IsReady('Slam')  and targetrange11() and (AuraUtil.FindAuraByName("Blood Surge", "player") or nameprecisetiming == 'Precise Timing') then
    --     return S.Slam:Cast()
    -- end
    
    -- if IsReady('Raging Blow')  and targetrange11() and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable())  then
    --     return S.chestrune:Cast()
    -- end
    
    -- if IsReady('Whirlwind')  and targetrange11() and Player:Rage()>50 then
    --     return S.Whirlwind:Cast()
    -- end

    if IsReady("Battle Shout") and (not AuraUtil.FindAuraByName("Battle Shout","player") or battleshoutbuffremains<3) then
        return S.BattleShout:Cast()
    end	

    if IsReady("Commanding Shout") and (not AuraUtil.FindAuraByName("Commanding Shout","player") or commandingshoutbuffremains<3) and not AuraUtil.FindAuraByName("Blood Pact","player") then
        return S.commandingshout:Cast()
    end	


    -- if IsReady('Quick Strike') and CbRstack>4 and targetrange11() and (S.Bloodthirst:IsAvailable() and S.Bloodthirst:CooldownRemains() >= 1.5 or not S.Bloodthirst:IsAvailable()) and (S.Whirlwind:IsAvailable() and S.Whirlwind:CooldownRemains() >= 1.5 or not S.Whirlwind:IsAvailable()) and Player:Rage() >= 50 then
    --     return S.handrune:Cast()
    -- end
    
    if IsReady('Cleave')  and not IsCurrentSpell(SpellRank('Cleave')) and targetrange11() and Player:Rage() >= 80 and RangeCount10() > 1 and GriphRH.AoEON() then
        return S.Cleave:Cast()
    end
    
    if IsReady('Heroic Strike') and not IsCurrentSpell(SpellRank('Heroic Strike')) and targetrange11() and Player:Rage() >= 80 and (RangeCount10() == 1 or not GriphRH.AoEON()) then
        return S.HeroicStrike:Cast()
    end
    if IsReady("Sunder Armor") and Player:Rage()>80 and targetrange11()   then
        return S.SunderArmor:Cast()
    end	

    if  IsReady("Hamstring") and targetrange11() and Player:Rage() >= 90 and (AuraUtil.FindAuraByName("Wild Strikes","player") or mainHandEnchantID == 563 or mainHandEnchantID == 1783) then
        return S.Hamstring:Cast()
    end





end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Out of combat----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	if not IsCurrentSpell(6603) and targetRange5 then
		return I.autoattack:ID()
	end

    if GetShapeshiftFormID() ~= 24 and IsReady("Gladiator Stance")  then
        return S.feetrune:Cast()
    end

    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and RangeCount11()==0  and glad == false then
        return S.BattleStance:Cast()
    end

    if (GetShapeshiftFormID() == 17 or GetShapeshiftFormID() == 24)  and IsReady('Charge') and not IsCurrentSpell(SpellRank('Charge')) and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and targetRange25 then
        return S.Charge:Cast()
    end


end

	
return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(1, APL);
