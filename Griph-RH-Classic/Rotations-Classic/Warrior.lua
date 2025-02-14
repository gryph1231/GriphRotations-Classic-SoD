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
    ChallengingShout = Spell(1161),
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
    MockingBlow = Spell(7402),
    IntimidatingShout = Spell(5246),
    Taunt = Spell(355),
    ShieldSlam = Spell(23922),
    WilloftheForsaken = Spell(7744),
    SweepingStrikes = Spell(12292),
    ShieldBlock = Spell(2565),
    Slam = Spell(1464),
    EnragedRegeneration = Spell(402913),
    Default = Spell(1),

    HeroicStrike = Spell(78),
    Retaliation = Spell(20230),
    Cleave = Spell(845),
    BerserkerRage = Spell(18499),
    berserkerrage = Spell(20554), --berserking
    DemoralizingShout = Spell(11555),
    ShieldWall = Spell(871),
    PiercingHowl = Spell(12323),
    LastStand = Spell(12975),
    Whirlwind = Spell(1680),
    BattleStance = Spell(2457),
    TasteforBlood = Spell(426969),
    Bloodrage = Spell(2687),
    BattleShout = Spell(6673),
    Meathook = Spell(403228),
    Shockwave = Spell(440488),
    DeathWish = Spell(12328),
    CommandingShout = Spell(403215),
    Recklessness = Spell(1719),
    MortalStrike = Spell(12294),
    ConcussionBlow = Spell(12809),
    Hamstring = Spell(1715),
    ThunderClap = Spell(11581),
    Bloodthirst3 = Spell(23893),
    Bloodthirst2 = Spell(23892),
    Bloodthirst4 = Spell(23894),
    
    Pummel = Spell(6552),
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
S.Meathook.TextureSpellID = { 20589 }    -- escape artist
S.ShieldWall.TextureSpellID = { 20580 }  -- shadowmeld
S.ThunderClap.TextureSpellID = { 20549 } -- warstomp
S.Recklessness.TextureSpellID = { 20594 }    --  stoneform




local function GetTankedEnemiesInRange()
    local count = 0
    local enemiesInRange = RangeCount(10) -- Get the number of enemies within 10 yards

    for i = 1, enemiesInRange do
        local unitID = "nameplate" .. i -- Iterate through nameplates
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

    -- if Target:Exists() then
    --     return S.Charge:Cast()
    -- end

    local namegladiator = GetSpellInfo('Gladiator Stance')
    local namebattleforecast = GetSpellInfo('Battle Forecast')
    local nameechoesofberserkerstance = GetSpellInfo('Echoes of Berserker Stance')
    local namebloodsurge = GetSpellInfo('Blood Surge')
    local namebloodfrenzy = GetSpellInfo('Blood Frenzy')


    local nameflagellation = GetSpellInfo('Flagellation')
    local nameprecisetiming = GetSpellInfo('Precise Timing')
    local namerampage = GetSpellInfo('Rampage')
    local nameconsumedbyrage = GetSpellInfo('Consumed By Rage')


    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")


    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end

    if AuraUtil.FindAuraByName("Rend", "target", "PLAYER|HARMFUL") then
        renddebuff = select(6, AuraUtil.FindAuraByName("Rend", "target", "PLAYER|HARMFUL")) - GetTime()
    else
        renddebuff = 0
    end
    nextauto = math.max(0, (GriphRH.lasthit() - UnitAttackSpeed('player')) * -1)



    local fury = S.Bloodthirst:IsAvailable() or S.Bloodthirst2:IsAvailable() or S.Bloodthirst3:IsAvailable() or S.Bloodthirst4:IsAvailable()
    local arms = S.MortalStrike:IsAvailable() or  S.MortalStrike2:IsAvailable() 
    local prot = IsEquippedItemType("Shield")



    if AuraUtil.FindAuraByName("Blessing of Freedom", "target")
        or AuraUtil.FindAuraByName("Free Action", "target")
        or AuraUtil.FindAuraByName("Decoy Totem", "target")
        or AuraUtil.FindAuraByName("Evasion", "target") then
        hamstringTarget = false
    else
        hamstringTarget = true
    end
    if AuraUtil.FindAuraByName("Divine Protection", "target")
        or AuraUtil.FindAuraByName("Intimidating Shout", "target", "PLAYER|HARMFUL")
        or AuraUtil.FindAuraByName("Ice Block", "target")
        or AuraUtil.FindAuraByName("Blessing of Protection", "player")
        or AuraUtil.FindAuraByName("Blessing of Protection", "target")
        or AuraUtil.FindAuraByName("Invulnerability", "target")
        or AuraUtil.FindAuraByName("Dispersion", "target") then
        stoprotation = true
    else
        stoprotation = false
    end
    local STttd = UnitHealth("target") / getCurrentDPS()
    local _, instanceTypepvp = IsInInstance()
    local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

    local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local channelTime = elapsedTimech / 1000

    local castTime = elapsedTimeca / 1000

    local castchannelTime = math.random(275, 500) / 1000

    local spellwidgetfort = UnitCastingInfo("target")
    -- print(AuraUtil.FindAuraByName("Aspect of the Hawk","target"))
    if AuraUtil.FindAuraByName("Commanding Shout", "player") then
        commandingshoutbuffremains = select(6, AuraUtil.FindAuraByName("Commanding Shout", "player", "PLAYER")) -
        GetTime()
    else
        commandingshoutbuffremains = 0
    end
    if AuraUtil.FindAuraByName("Battle Shout", "player") then
        battleshoutbuffremains = select(6, AuraUtil.FindAuraByName("Battle Shout", "player")) - GetTime()
    else
        battleshoutbuffremains = 0
    end


    local nametasteforblood = GetSpellInfo('Taste for Blood')
    if AuraUtil.FindAuraByName("Sunder Armor", "target", "PLAYER|HARMFUL") then
        sunderarmorstack = select(3, AuraUtil.FindAuraByName("Sunder Armor", "target", "PLAYER|HARMFUL"))
    else
        sunderarmorstack = 0
    end

    if AuraUtil.FindAuraByName("Sunder Armor", "target", "PLAYER|HARMFUL") then
        sunderarmorremains = select(6, AuraUtil.FindAuraByName("Sunder Armor", "target", "PLAYER|HARMFUL")) - GetTime()
    else
        sunderarmorremains = 0
    end
    if AuraUtil.FindAuraByName("Battle Forecast", "player", "PLAYER") then
        battleforecastremains = select(6, AuraUtil.FindAuraByName("Battle Forecast", "player", "PLAYER")) - GetTime()
    else
        battleforecastremains = 0
    end
    if AuraUtil.FindAuraByName("Echoes of Berserker Stance", "player", "PLAYER") then
        echoesofberserkerstanceremains = select(6,
            AuraUtil.FindAuraByName("Echoes of Berserker Stance", "player", "PLAYER")) - GetTime()
    else
        echoesofberserkerstanceremains = 0
    end
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID =
    GetWeaponEnchantInfo()

-- print("dodge spells:", checkOverpowerTimespells())
-- print("dodge spells and autos:", checkOverpowerTime())

    if (checkOverpowerTimeautos()>1.5 or checkOverpowerTimespells()>1.5 or Player:BuffRemains(S.TasteforBlood) > 1.5) and S.Overpower:CooldownRemains() < 2 then
        canoverpower = true
    else
        canoverpower = false
    end


    -- if (Target:IsAPlayer() and (UnitClass("target") == 4 or UnitClass("target") == 3 or UnitClass("target") == 1 or UnitClass("target") == 2 or UnitClass("target") == 7 or UnitClass("target") == 11) and Player:HealthPercentage() < 75
    --         or GetTankedEnemiesInRange() >=2 and Player:HealthPercentage() < 75) and CheckInteractDistance("target", 3) and S.Retaliation:CooldownRemains() < 2
    -- then
    --     retaliation = true
    -- else
    --     retaliation = false
    -- end
    if RangeCount(10) > 1 and GriphRH.AoEON() and S.SweepingStrikes:IsAvailable() and S.SweepingStrikes:CooldownRemains() < 2 and Player:Rage() < 30 then
        dontspend = false
    else
        dontspend = true
    end

    if CheckInteractDistance("target", 3) and S.Whirlwind:CooldownRemains() > 2
        and (canoverpower )
        and Player:Rage() <= 25 then
        berserkerstance = false
        battlestance = true
    else
        berserkerstance = true
        battlestance = false
    end


    if (S.SweepingStrikes:CooldownRemains() > 2 and S.Whirlwind:CooldownRemains() > 2 or Player:Rage() >= 30 or Player:Rage() >= 25 and S.SweepingStrikes:CooldownRemains() > 2) then
        spendaoe = true
    else
        spendaoe = false
    end

    if (Player:Rage() >= 30 or S.Bloodthirst:CooldownRemains() > 2 and S.Whirlwind:CooldownRemains() > 2) then
        spend = true
    else
        spend = false
    end

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------SPELL QUEUES-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if GriphRH.QueuedSpell():ID() == S.IntimidatingShout:ID() and S.IntimidatingShout:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end
    if GriphRH.QueuedSpell():ID() == S.Intercept:ID() and (S.Intercept:CooldownRemains() > 2 or not IsSpellInRange("Intercept","target") or Target:IsDeadOrGhost() or not Player:CanAttack(Target) or  IsCurrentSpell(SpellRank('Charge')) ) then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end
    if GriphRH.QueuedSpell():ID() == S.Charge:ID() and (IsCurrentSpell(SpellRank('Charge')) or Target:IsDeadOrGhost() or not Player:CanAttack(Target)) then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.PiercingHowl:ID() and (S.PiercingHowl:TimeSinceLastCast()<1 or AuraUtil.FindAuraByName("Piercing Howl",  "target", "PLAYER|HARMFUL")) then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Taunt:ID() and S.Taunt:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.ChallengingShout:ID() and S.ChallengingShout:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end


    if GriphRH.QueuedSpell():ID() == S.ConcussionBlow:ID() and S.ConcussionBlow:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Retaliation:ID() and S.Retaliation:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Meathook:ID() and (S.Meathook:CooldownRemains() > 2 or UnitLevel("player") + 1 < UnitLevel("target") or TargetinRange(10)) then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.MockingBlow:ID() and S.MockingBlow:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Hamstring:ID() and (S.Hamstring:TimeSinceLastCast()<1 or AuraUtil.FindAuraByName("Hamstring", "target", "PLAYER | HARMFUL")) then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Shockwave:ID() and S.Shockwave:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end



    if GriphRH.QueuedSpell():ID() == S.Recklessness:ID() and S.Recklessness:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == nil or not Player:AffectingCombat() then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end



    if GriphRH.QueuedSpell():ID() == S.Recklessness:ID()  then
        return GriphRH.QueuedSpell():Cast()
    end
    
    if GriphRH.QueuedSpell():ID() == S.PiercingHowl:ID() and (IsReady("Piercing Howl") or Player:Rage() > 5) and S.PiercingHowl:IsAvailable() then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.IntimidatingShout:ID() and RangeCount(10)>=1 and CheckInteractDistance("target", 3)  then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Intercept:ID() and IsReady("Intercept") then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Charge:ID() and IsReady("Charge") then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Taunt:ID() and IsReady("Taunt") then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.ChallengingShout:ID() and IsReady("Challenging Shout") then
        return GriphRH.QueuedSpell():Cast()
    end


    if GriphRH.QueuedSpell():ID() == S.ConcussionBlow:ID() and IsReady("Concussion Blow") then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Retaliation:ID()  then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Meathook:ID() and IsReady("Meathook") then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.MockingBlow:ID() and IsReady("Mocking Blow") then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Hamstring:ID() and IsReady("Hamstring") then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Shockwave:ID() and IsReady("Shockwave") then
        return GriphRH.QueuedSpell():Cast()
    end




    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
        if IsPlayerFeared() and IsReady("Will of the Forsaken") then
            return S.WilloftheForsaken:Cast()
        end
        if IsPlayerFeared() and IsReady("Berserker Rage") and S.WilloftheForsaken:CooldownRemains() > 2 then
            return S.berserkerrage:Cast()
        end


        if IsReady("Enraged Regeneration") and Player:HealthPercentage() < 70 then
            return S.EnragedRegeneration:Cast()
        end


        if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
            return I.autoattack:ID()
        end

        if Target:IsAPlayer() and IsReady("Rallying Cry") and inRange25 >= 1 and Player:HealthPercentage() <= 15 then
            return S.RallyingCry:Cast()
        end

        -- if retaliation == true and IsReady("Retaliation") and not prot then
        --     return S.Retaliation:Cast()
        -- end



        if stoprotation == false then
            if IsReady("Shield Bash") and spellwidgetfort ~= 'Widget Fortress' and (Target:IsChanneling() or castTime > 0.25 + castchannelTime or channelTime > 0.25 + castchannelTime) and CheckInteractDistance("target", 3) and GriphRH.InterruptsON() then
                return S.ShieldBash:Cast()
            end
            if IsReady("Pummel") and spellwidgetfort ~= 'Widget Fortress' and (Target:IsChanneling() or castTime > 0.25 + castchannelTime or channelTime > 0.25 + castchannelTime) and CheckInteractDistance("target", 3) and GriphRH.InterruptsON() then
                return S.Pummel:Cast()
            end
            if IsReady("Victory Rush") and CheckInteractDistance("target", 3) and Player:HealthPercentage() < 75 then
                return S.VictoryRush:Cast()
            end
            if Target:IsAPlayer() and hamstringTarget == true and IsReady("Hamstring") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Hamstring", "target", "PLAYER|HARMFUL") then
                return S.Hamstring:Cast()
            end



            --prot rotation



            if prot then
                if GetShapeshiftFormID() ~= 24 and IsReady("Gladiator Stance")
                    and CheckInteractDistance("target", 3) then
                    return S.GladiatorStance:Cast()
                end
   

                if IsReady("Last Stand") and CheckInteractDistance("target", 3) and Player:HealthPercentage() < 50 and not AuraUtil.FindAuraByName("Shield Wall", "player") then
                    return S.LastStand:Cast()
                end
                if IsReady("Shield Wall") and CheckInteractDistance("target", 3) and (Player:HealthPercentage() < 50 and not AuraUtil.FindAuraByName("Last Stand", "player") or Player:HealthPercentage() < 30) then
                    return S.ShieldWall:Cast()
                end


                if IsReady("Bloodrage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Berserker Rage", "player") then
                    return S.Bloodrage:Cast()
                end
                if IsReady("Berserker Rage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Bloodrage", "player") and (Player:HealthPercentage() < 90 or GetTankedEnemiesInRange() >= 1) then
                    return S.berserkerrage:Cast()
                end

                -- if CheckInteractDistance("target", 3) and isTanking == false and not Target:IsAPlayer() and Target:AffectingCombat() and not UnitInRaid("player") then
                --     if IsReady("Taunt") and CheckInteractDistance("target", 3) then
                --         return S.Taunt:Cast()
                --     end
                --     if IsReady("Mocking Blow") and CheckInteractDistance("target", 3) and S.Taunt:CooldownRemains() > 2 then
                --         return S.MockingBlow:Cast()
                --     end
                -- end


                -- if IsReady("Challenging Shout") and CheckInteractDistance("target", 3) and HL.CombatTime() > 4 and RangeCount(20) > GetTankedEnemiesInRange() and not UnitInRaid("player") and not Target:IsAPlayer() then
                --     return S.ChallengingShout:Cast()
                -- end



                if IsReady("Rend") and CheckInteractDistance("target", 3)
                    and renddebuff == 0 and (nametasteforblood == "Taste for Blood" or namebloodfrenzy == "Blood Frenzy" or UnitClass("target") == 4)
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


                if IsReady("Thunder Clap") and RangeCount(10)>1 and GriphRH.AoEON() and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage")) then
                    return S.ThunderClap:Cast()
                end
                if IsReady("Shield Slam") and CheckInteractDistance("target", 3) then
                    return S.ShieldSlam:Cast()
                end

       

        
                if IsReady("Shield Block") and not AuraUtil.FindAuraByName("Shield Block", "player") and CheckInteractDistance("target", 3) and Player:HealthPercentage()<85 then
                    return S.ShieldBlock:Cast()
                end

                if IsReady("Revenge") and RangeCount(10)>1 and GriphRH.AoEON() and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage")) then
                    return S.Revenge:Cast()
                end
                if IsReady("Execute") and CheckInteractDistance("target", 3) and (Target:HealthPercentage() <= 20 and (Player:Rage() >= 40 or STttd < 3) or AuraUtil.FindAuraByName("Sudden Death", "player")) then
                    return S.Execute:Cast()
                end
                
                if IsReady("Revenge") and (RangeCount(10)==1 or not GriphRH.AoEON()) and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage")) then
                    return S.Revenge:Cast()
                end

                if IsReady("Slam") and CheckInteractDistance("target", 3)
                    and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge", "player") then
                    return S.Slam:Cast()
                end


                if IsReady("Overpower") and CheckInteractDistance("target", 3) then
                    return S.Overpower:Cast()
                end



                -- if IsReady("Recklessness")  and CheckInteractDistance("target", 3) and GriphRH.CDsON() then
                --     return S.Recklessness:Cast()
                -- end	








          

                if IsReady("Thunder Clap") and Player:Rage()>=16 and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage")) then
                    return S.ThunderClap:Cast()
                end
                if IsReady("Demoralizing Shout") and S.DemoralizingShout:TimeSinceLastCast()>2 and not AuraUtil.FindAuraByName("Demoralizing Shout", "target", "PLAYER|HARMFUL") and CheckInteractDistance("target", 3) and RangeCount(10) >= 1 and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage")) then
                    return S.DemoralizingShout:Cast()
                end
                if IsReady("Sunder Armor") and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage") and Player:Rage() >= 20) then
                    return S.SunderArmor:Cast()
                end


                if IsReady("Raging Blow") and CheckInteractDistance("target", 3) then
                    return S.RagingBlow:Cast()
                end
                if IsReady("Quick Strike") and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage") and Player:Rage() >= 20) then
                    return S.QuickStrike:Cast()
                end

                if IsReady("Cleave") and not IsCurrentSpell(SpellRank('Cleave')) and RangeCount(10) > 1 and GriphRH.AoEON()
                    and TargetinRange(5) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage") and Player:Rage() > 30) then
                    return S.Cleave:Cast()
                end


                if IsReady("Heroic Strike") and not IsCurrentSpell(SpellRank('Cleave')) and not IsCurrentSpell(SpellRank('Heroic Strike'))
                    and CheckInteractDistance("target", 3) and (Player:Rage() >= 60 or (AuraUtil.FindAuraByName("Enrage", "player") or nameconsumedbyrage ~= "Consumed By Rage") and Player:Rage() > 30) and (RangeCount(10) == 1 or not GriphRH.AoEON()) then
                    return S.HeroicStrike:Cast()
                end

                if IsReady("Battle Shout") and Player:IsMoving() and battleshoutbuffremains < 10  then
                    return S.BattleShout:Cast()
                end

                if IsReady("Commanding Shout") and Player:IsMoving() and commandingshoutbuffremains < 10 and not AuraUtil.FindAuraByName("Blood Pact", "player") then
                    return S.CommandingShout:Cast()
                end
            end


            --fury rotation



            if fury then

                
                if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance")
                    and CheckInteractDistance("target", 3) and S.BerserkerStance:TimeSinceLastCast() > 1.5
                    and S.BattleStance:TimeSinceLastCast() > 1.5 and not canoverpower and 
                    (
                    S.TacticalMastery:IsAvailable() and Player:Rage() <= 25 or 
                     Player:Rage() <= 15 or --check to rage<=5
                     S.Whirlwind:CooldownRemains() < 2 and GriphRH.AoEON() and RangeCount(10) > 1
                    ) 
                    then
                    return S.BerserkerStance:Cast()
                end

                if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance")
                    and CheckInteractDistance("target", 3)
                    and ( canoverpower 
                    and (S.TacticalMastery:IsAvailable() and Player:Rage() <= 25 or Player:Rage() <= 15  --check to rage<=5 this is for testing only
                    or S.Whirlwind:CooldownRemains()>2 and RangeCount(10)>1 or not GriphRH.AoEON() or RangeCount(10) ==1))
                    and S.BerserkerStance:TimeSinceLastCast() > 1.5 and S.BattleStance:TimeSinceLastCast() > 1.5

                then
                    return S.BattleStance:Cast()
                end


                if IsReady("Bloodrage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Berserker Rage", "player") then
                    return S.Bloodrage:Cast()
                end
                if IsReady("Berserker Rage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Bloodrage", "player") and (Player:HealthPercentage() < 90 or GetTankedEnemiesInRange() >= 1) then
                    return S.berserkerrage:Cast()
                end



                if IsReady("Rampage") and CheckInteractDistance("target", 3) and GriphRH.CDsON() then
                    return S.Rampage:Cast()
                end


                if IsReady("Rend") and CheckInteractDistance("target", 3) and STttd > 5 and HL.CombatTime() > 2
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


                if IsReady("Death Wish") and CheckInteractDistance("target", 3) and GriphRH.CDsON() then
                    return S.DeathWish:Cast()
                end

                if IsReady("Whirlwind") and TargetinRange(5) and RangeCount(10) > 1 and GriphRH.AoEON() then
                    return S.Whirlwind:Cast()
                end

                if IsReady("Overpower") and CheckInteractDistance("target", 3) and (checkOverpowerTimeautos()<2 or checkOverpowerTimespells() <2) then
                    return S.Overpower:Cast()
                end

       
                if IsReady("Execute") and CheckInteractDistance("target", 3) and (Target:HealthPercentage() <= 20 and (Player:Rage() >= 40 or STttd < 3) or AuraUtil.FindAuraByName("Sudden Death", "player")) then
                    return S.Execute:Cast()
                end


                if IsReady("Slam") and CheckInteractDistance("target", 3)
                    and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge", "player") then
                    return S.Slam:Cast()
                end

                if IsReady("Overpower") and CheckInteractDistance("target", 3) then
                    return S.Overpower:Cast()
                end



                -- if IsReady("Recklessness")  and CheckInteractDistance("target", 3) and GriphRH.CDsON() then
                --     return S.Recklessness:Cast()
                -- end	



                if IsReady("Bloodthirst") and CheckInteractDistance("target", 3) then
                    return S.Bloodthirst:Cast()
                end

                if IsReady("Whirlwind") and CheckInteractDistance("target", 3) and (Player:Rage() >= 30 or S.Bloodthirst:CooldownRemains() > 2) then
                    return S.Whirlwind:Cast()
                end

                if IsReady("Raging Blow") and CheckInteractDistance("target", 3) then
                    return S.RagingBlow:Cast()
                end
                if IsReady("Quick Strike") and CheckInteractDistance("target", 3) and spend then
                    return S.QuickStrike:Cast()
                end


                if IsReady("Battle Shout") and Player:IsMoving() and battleshoutbuffremains < 10  then
                    return S.BattleShout:Cast()
                end

                if IsReady("Commanding Shout") and Player:IsMoving() and commandingshoutbuffremains < 10 and not AuraUtil.FindAuraByName("Blood Pact", "player") then
                    return S.CommandingShout:Cast()
                end





                if IsReady("Cleave") and not IsCurrentSpell(SpellRank('Cleave')) and RangeCount(10) > 1 and GriphRH.AoEON()
                    and TargetinRange(5) and Player:Rage() >= 40 then
                    return S.Cleave:Cast()
                end


                if IsReady("Heroic Strike") and not IsCurrentSpell(SpellRank('Cleave')) and not IsCurrentSpell(SpellRank('Heroic Strike'))
                    and CheckInteractDistance("target", 3) and Player:Rage() >= 40 and (RangeCount(10) == 1 or not GriphRH.AoEON()) then
                    return S.HeroicStrike:Cast()
                end
            end


            if arms then
                if RangeCount(15) >= 2 and GriphRH.AoEON() then
                    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance") and CheckInteractDistance("target", 3)
                        and S.SweepingStrikes:CooldownRemains() < 2 and S.BerserkerStance:TimeSinceLastCast() > 1.5 and S.BattleStance:TimeSinceLastCast() > 1.5
                    then
                        return S.BattleStance:Cast()
                    end

                    if IsReady("Sweeping Strikes") and CheckInteractDistance("target", 3) then
                        return S.SweepingStrikes:Cast()
                    end

                    if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance")
                        and ((S.Whirlwind:CooldownRemains() < 2 and AuraUtil.FindAuraByName("Sweeping Strikes", "player")
                                or S.SweepingStrikes:CooldownRemains() > 2) and not canoverpower
                            and CheckInteractDistance("target", 3) and S.BerserkerStance:TimeSinceLastCast() > 1.5
                            and S.BattleStance:TimeSinceLastCast() > 1.5 or S.Whirlwind:CooldownRemains() < 2 and S.SweepingStrikes:TimeSinceLastCast() < 2) then
                        return S.BerserkerStance:Cast()
                    end



                    if IsReady("Bloodrage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Berserker Rage", "player") then
                        return S.Bloodrage:Cast()
                    end
                    if IsReady("Berserker Rage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Bloodrage", "player") and (Player:HealthPercentage() < 90 or GetTankedEnemiesInRange() >= 1) then
                        return S.berserkerrage:Cast()
                    end

                    if IsReady("Bloodthirst") and CheckInteractDistance("target", 3) then
                        return S.Bloodthirst:Cast()
                    end

                    if IsReady("Mortal Strike") and CheckInteractDistance("target", 3) then
                        return S.MortalStrike:Cast()
                    end



                    if IsReady('Whirlwind') and UnitCreatureType("target") ~= "Totem" and TargetinRange(5)
                        and (Player:Rage() >= 30 and S.SweepingStrikes:CooldownRemains() > 2 or Player:Rage() >= 30) then
                        return S.Whirlwind:Cast()
                    end

                    if IsReady("Execute") and CheckInteractDistance("target", 3) and AuraUtil.FindAuraByName("Sudden Death", "player") and spendaoe then
                        return S.Execute:Cast()
                    end

                    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance")
                        and CheckInteractDistance("target", 3) and S.Whirlwind:CooldownRemains() > 2 and S.SweepingStrikes:CooldownRemains() > 2
                        and (canoverpower ) and S.BerserkerStance:TimeSinceLastCast() > 1.5 and S.BattleStance:TimeSinceLastCast() > 1.5
                    then
                        return S.BattleStance:Cast()
                    end

                    if IsReady("Rend") and CheckInteractDistance("target", 3) and spendaoe
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


                    if IsReady('Overpower') and CheckInteractDistance("target", 3) and spendaoe then
                        return S.Overpower:Cast()
                    end

                    if IsReady("Slam") and CheckInteractDistance("target", 3)
                        and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge", "player") and spendaoe then
                        return S.Slam:Cast()
                    end

                    if IsReady("Execute") and CheckInteractDistance("target", 3) and spendaoe then
                        return S.Execute:Cast()
                    end

                    if IsReady("Cleave") and not IsCurrentSpell(SpellRank('Cleave'))
                        and TargetinRange(5) and (spendaoe or S.Whirlwind:CooldownRemains() > 2 or not AuraUtil.FindAuraByName("Berserker Stance", "player") and Player:Rage() >= 25) then
                        return S.Cleave:Cast()
                    end

                    if IsReady("Quick Strike") and CheckInteractDistance("target", 3) and Player:Rage() >= 25 then
                        return S.QuickStrike:Cast()
                    end
                end


                if RangeCount(15) == 1 or not GriphRH.AoEON() or RangeCount(15) == 2 and STttd < 2 and HL.CombatTime() > 2 then
                    if GetShapeshiftFormID() ~= 19 and IsReady("Berserker Stance")
                        and not canoverpower
                        and CheckInteractDistance("target", 3) and S.BerserkerStance:TimeSinceLastCast() > 1.5 and S.BattleStance:TimeSinceLastCast() > 1.5 then
                        return S.BerserkerStance:Cast()
                    end

                    if IsReady("Bloodrage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Berserker Rage", "player") then
                        return S.Bloodrage:Cast()
                    end
                    if IsReady("Berserker Rage") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Bloodrage", "player") and (Player:HealthPercentage() < 90 or GetTankedEnemiesInRange() >= 1) then
                        return S.berserkerrage:Cast()
                    end

                    if IsReady("Mortal Strike") and CheckInteractDistance("target", 3) then
                        return S.MortalStrike:Cast()
                    end

                    if IsReady("Execute") and CheckInteractDistance("target", 3) and AuraUtil.FindAuraByName("Sudden Death", "player") then
                        return S.Execute:Cast()
                    end


                    if GetShapeshiftFormID() ~= 17 and IsReady("Battle Stance")
                        and CheckInteractDistance("target", 3) and S.Whirlwind:CooldownRemains() > 2
                        and (canoverpower ) and S.BerserkerStance:TimeSinceLastCast() > 1.5 and S.BattleStance:TimeSinceLastCast() > 1.5
                    then
                        return S.BattleStance:Cast()
                    end

                    if IsReady("Rend") and CheckInteractDistance("target", 3)
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


                    if IsReady('Overpower') and CheckInteractDistance("target", 3) then
                        return S.Overpower:Cast()
                    end

                    if IsReady("Slam") and CheckInteractDistance("target", 3)
                        and namebloodsurge == "Blood Surge" and AuraUtil.FindAuraByName("Blood Surge", "player") then
                        return S.Slam:Cast()
                    end

                    if IsReady('Whirlwind') and TargetinRange(5) and Player:Rage() >= 30 then
                        return S.Whirlwind:Cast()
                    end
                    if IsReady("Execute") and CheckInteractDistance("target", 3) and Player:Rage() >= 30 then
                        return S.Execute:Cast()
                    end

                    if IsReady("Heroic Strike") and not IsCurrentSpell(SpellRank('Cleave')) and not IsCurrentSpell(SpellRank('Heroic Strike'))
                        and CheckInteractDistance("target", 3) and Player:Rage() > 30 then
                        return S.HeroicStrike:Cast()
                    end

                    if IsReady("Quick Strike") and CheckInteractDistance("target", 3) and Player:Rage() >= 30 then
                        return S.QuickStrike:Cast()
                    end
                end

                if IsReady("Battle Shout") and Player:IsMoving() and battleshoutbuffremains < 10  then
                    return S.BattleShout:Cast()
                end

                if IsReady("Commanding Shout") and Player:IsMoving() and commandingshoutbuffremains < 10 and not AuraUtil.FindAuraByName("Blood Pact", "player") then
                    return S.CommandingShout:Cast()
                end
            end
        end
    end



    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------Out of combat----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
        if not IsCurrentSpell(6603) and TargetinRange(5) and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and Target:AffectingCombat() then
            return I.autoattack:ID()
        end

  

        if IsReady("Battle Shout") and Player:IsMoving() and battleshoutbuffremains < 10 then
            return S.BattleShout:Cast()
        end

        if IsReady("Commanding Shout") and Player:IsMoving() and commandingshoutbuffremains < 10 and not AuraUtil.FindAuraByName("Blood Pact", "player") then
            return S.CommandingShout:Cast()
        end

        if GetShapeshiftFormID() ~= 17 and Player:IsMoving() and IsReady("Battle Stance") and RangeCount(20) == 0 
        and namegladiatorstance ~= "Gladiator Stance" and (fury or arms)
       and (S.Charge:CooldownRemains() < 2 ) then
            return S.BattleStance:Cast()
        end

        if IsReady("Gladiator Stance") and Player:IsMoving() and namegladiator == "Gladiator Stance" and GetShapeshiftFormID() ~= 24 and prot then
            return S.GladiatorStance:Cast()
        end

        if  IsCurrentSpell(6603) and  IsReady("Charge") and Player:IsMoving() and IsSpellInRange("Charge","target")==1  then
            return S.Charge:Cast()
        end


    end


    return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(1, APL);
