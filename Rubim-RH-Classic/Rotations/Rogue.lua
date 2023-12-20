local addonName, addonTable = ...;
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;
local Nameplate = Unit.Nameplate;


RubimRH.Spell[4] = {
    Evasion = Spell(5277),
    EnvenomBuff = Spell(399963),
    Envenom = Spell(399963),
    envenom = Spell(20580),-- shadowmeld
    DeadlyPoisonDebuff = Spell(434312),
    SliceandDice = Spell(5171),
    Default = Spell(1),
    Blind = Spell(2094),
    CloakofShadows = Spell(31224),
    Distract = Spell(2836),
    Sap = Spell(11297),
    Stealth = Spell(1784),
    Vanish = Spell(26889),
    Ambush = Spell(48691),
    CheapShot = Spell(1833),
    DeadlyThrow = Spell(48674),
    DeadlyPoison = Spell(27187),
    Eviscerate = Spell(6761),
    ExposeArmor = Spell(26866),
    Garrote = Spell(48676),
    KidneyShot = Spell(8643),
    Rupture = Spell(48672),
    SnD = Spell(6774),
    Backstab = Spell(53),
    Feint = Spell(48659),
    tott = Spell(57934),
    Gouge = Spell(1776),
    Kick = Spell(1766),
    Shiv = Spell(5938),
    SinisterStrike = Spell(1757),
    Sprint = Spell(11305),
    WilloftheForsaken = Spell(7744),
    AdrenalineRush = Spell(13750),
    BladeFlurry = Spell(13877),

    KillingSpree = Spell(51690),
    FanofKnives = Spell(51723),
    ColdBlood = Spell(14177),

    HungerforBlood = Spell(51662),
    HungerforBloodBuff = Spell(63848),
    Mutilate = Spell(1329),
    Shadowstrike = Spell(399985),
    shadowstrike = Spell(20594), --stone form
    Default = Spell(1),
};
local S = RubimRH.Spell[4]

if not Item.Rogue then
    Item.Rogue = {}
end

Item.Rogue = {

    trinket = Item(28288, { 13, 14 }),
    trinket2 = Item(25628, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),
};

local I = Item.Rogue;


-- S.BladeFlurry.TextureSpellID =  {58749} --nature resist totem
-- S.AdrenalineRush.TextureSpellID  = {16166} --elemental mastery
-- S.HungerforBlood.TextureSpellID = {25464} --frost shock
-- S.SinisterStrike.TextureSpellID = {30706} --totem of wrath
-- S.KillingSpree.TextureSpellID = {33697} -- Blood Fury
-- -- I.trinket.TextureSpellID = {26296} -- berserking
-- S.Evasion.TextureSpellID = {8143} --tremor totem
-- S.tott.TextureSpellID = {131} -- water walking
-- S.Blind.TextureSpellID = {16342} --flametongue weapon
-- S.CloakofShadows.TextureSpellID = {2062} --earth elemental totem
-- S.Distract.TextureSpellID = {2894} --fire elemental totem
-- S.Mutilate.TextureSpellID = {25420} --lesser healing wave
-- S.Stealth.TextureSpellID = {25547} --fire nova totem
-- S.ColdBlood.TextureSpellID = {8177} --grounding totem
-- S.CheapShot.TextureSpellID = {25560} --Frost resist totem
-- S.DeadlyThrow.TextureSpellID = {25557} --flametongue totem
-- S.Envenom.TextureSpellID = {25457} --flame shock
-- S.Eviscerate.TextureSpellID = {25442} --chain lightning
-- S.ExposeArmor.TextureSpellID = {25563} --fire resist totem
-- S.Garrote.TextureSpellID = {25359} --grace of air totem
-- S.KidneyShot.TextureSpellID = {25567} --healing stream totem
-- S.Rupture.TextureSpellID = {25449} -- lightning bolt
-- S.SnD.TextureSpellID = {2825} -- bloodlust
-- S.Feint.TextureSpellID = {25525} --stoneclaw totem
-- S.Kick.TextureSpellID = {8044} --earthshock
-- S.Gouge.TextureSpellID = {25509} --stoneskin totem
-- S.WilloftheForsaken.TextureSpellID = {59547} --gift of naaru
-- S.Vanish.TextureSpellID = {45528} --ghost wolf
-- S.FanofKnives.TextureSpellID = {25423} --chain heal
-- --S.ColdBlood.TextureSpellID = {135863} --natures swiftness


local function RangeCount(spellName)
    local range_counter = 0

    if spellName then
        for i = 1, 40 do
            local unitID = "nameplate" .. i
            if UnitExists(unitID) then
                local nameplate_guid = UnitGUID(unitID)
                local npc_id = select(6, strsplit("-", nameplate_guid))
                if npc_id ~= '120651' and npc_id ~= '161895' then
                    if UnitCanAttack("player", unitID) and IsSpellInRange(spellName, unitID) == 1 and UnitHealthMax(unitID) > 5 then
                        range_counter = range_counter + 1
                    end
                end
            end
        end
    end

    return range_counter
end

local function TargetInRange(spellName)
    if spellName and IsSpellInRange(spellName, "target") == 1 then
        return true
    else
        return false
    end
end




































































































local function IsReady(spell, range_check, aoe_check)
    local start, duration, enabled = GetSpellCooldown(tostring(spell))
    local usable, noMana = IsUsableSpell(tostring(spell))
    local range_counter = 0

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


    -- if usable and enabled and cooldown_remains - gcd_remains < 0.5 and gcd_remains < 0.5 then
    if usable and enabled and cooldown_remains < 0.5 then
        if range_check then
            if IsSpellInRange(tostring(spell), "target") then
                return true
            else
                return false
            end
        elseif aoe_check then
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





















local initialTotalMaxHealth = 0
local combatStartTime = 0
local inCombat = false

local function getTotalHealthOfCombatMobs()
    local totalMaxHealth = 0
    local totalCurrentHealth = 0

    for i = 1, 40 do
        local unitID = "nameplate" .. i
        if UnitExists(unitID) and UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) then
            totalMaxHealth = totalMaxHealth + UnitHealthMax(unitID)
            totalCurrentHealth = totalCurrentHealth + UnitHealth(unitID)
        end
    end

    return totalMaxHealth, totalCurrentHealth
end

-- Event Frame for tracking combat state
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- Player enters combat
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Player leaves combat

eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        combatStartTime = GetTime()
        initialTotalMaxHealth, _ = getTotalHealthOfCombatMobs()
    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
    end
end)

local function getCurrentDPS()
    if inCombat and combatStartTime > 0 then
        local totalMaxHealth, totalCurrentHealth = getTotalHealthOfCombatMobs()
        if totalMaxHealth > initialTotalMaxHealth then
            initialTotalMaxHealth = totalMaxHealth
        end

        local totalDamageDone = initialTotalMaxHealth - totalCurrentHealth
        local combatDuration = GetTime() - combatStartTime
        return math.max(0, totalDamageDone / combatDuration)
    else
        return 0
    end
end



local function aoeTTD()
    local currentDPS = getCurrentDPS()
    local totalCurrentHealth = select(2, getTotalHealthOfCombatMobs())

    if currentDPS and currentDPS > 0 then
        local TTD = totalCurrentHealth / currentDPS
        return TTD
    else
       return 8888
    end
end







local function APL()

    inRange5 = RangeCount("Sinister Strike")
 
    targetRange5 = TargetInRange("Sinister Strike")
    targetRange30 = TargetInRange("Throw")
--range checks with nameplate
local inRange25 = 0
for i = 1, 40 do
    if UnitExists('nameplate' .. i)  then
        inRange25 = inRange25 + 1
    end
end

local targetdying = (Target:TimeToDie()<=4 or UnitHealth('target')<300)

-- print(aoeTTD())
-- print(getSingleTargetTTD())
    local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

    local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local channelTime = elapsedTimech / 1000

    local castTime = elapsedTimeca / 1000

    local castchannelTime = math.random(275, 500) / 1000

  
-- print(aoeTTD())


    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
    end

    --    print(Player:BuffRemains(S.SliceandDice) < 3)

    -- local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
    -- if hasMainHandEnchant ~= true then
    -- mhenchantremains = 0
    -- elseif hasMainHandEnchant == true then
    -- mhenchantremains = mainHandExpiration*0.001
    -- end
    -- if hasOffHandEnchant ~= true then
    -- ohenchantremains = 0
    -- elseif hasOffHandEnchant == true then
    -- ohenchantremains = offHandExpiration*0.001
    -- end
    if inRange25==0 then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Gouge:ID() and (S.Gouge:CooldownRemains()>Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Kick:ID() and (S.Kick:CooldownRemains()>Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Gouge:ID()  then
        return RubimRH.QueuedSpell():Cast()
    end
    
    if RubimRH.QueuedSpell():ID() == S.Kick:ID()  then
        return RubimRH.QueuedSpell():Cast()
    end

  

    if not AuraUtil.FindAuraByName("Stealth", "player") and Player:CanAttack(Target) and Player:AffectingCombat() then
        --Kick
        if S.Kick:CanCast() and RubimRH.CDsON()

            and targetRange5 and (castTime > castchannelTime + 0.5 or channelTime > castchannelTime + 0.5) and select(8, UnitCastingInfo("target")) == false then
            return S.Kick:Cast()
        end
    end
    --     -- Out of combat
    if not Player:AffectingCombat() then
        if not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
            -- --combat
            -- if mhenchantremains<300 and not Player:IsMoving() and GetItemCount('Instant Poison IX')>=1 then
            -- return S.mainhandpoison_instant1:Cast()
            -- end
            -- if ohenchantremains<300 and not Player:IsMoving() and comb and GetItemCount('Deadly Poison IX')>=1 then
            -- return S.offhandpoison_instant1:Cast()
            -- end
            -- if not IsCurrentSpell(6603)  and targetRange5 then
            --     return I.autoattack:ID()
            -- end

            if
            -- S.Stealth:CanCast()
                IsReady('Stealth') and IsReady('Shadowstrike') and not IsReady('Saber Slash')
                and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and S.Stealth:TimeSinceLastCast() > 0.5 and Player:IsMoving() and not Player:Buff(S.Stealth) and Target:Exists() then
                return S.Stealth:Cast()
            end

            if
            -- S.Backstab:CanCast()
                IsReady('Backstab')
                and targetRange5 and not Player:IsTanking(Target)
            then
                return S.Backstab:Cast()
            end

            if
            -- S.Shadowstrike:CanCast()
                IsReady('Shadowstrike')
                and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.shadowstrike:Cast()
            end


            if
            -- S.SinisterStrike:CanCast()
                (IsReady('Sinister Strike') or IsReady('Saber Slash'))
                and targetRange5 and Player:ComboPoints() < 5
            then
                return S.SinisterStrike:Cast()
            end

            if not IsCurrentSpell(6603) and targetRange5 and Player:Energy() < 45 then
                return I.autoattack:ID()
            end

            return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
        end
    end




    if
        Player:AffectingCombat()
        and
        not Player:Buff(S.Stealth)
        and
        Target:Exists()
        and
        Player:CanAttack(Target)
        and
        not Target:IsDeadOrGhost()
    then -- In combat
        if not IsCurrentSpell(6603) and targetRange5 then
            return I.autoattack:ID()
        end


-- if Player:ComboPoints()>Target:DebuffStack(S.DeadlyPoisonDebuff)

        --Slice1
        if
        --   S.SliceandDice:CanCast()
            IsReady('Slice and Dice') and (not targetdying or targetdying and inRange25>1)
            and (Player:BuffRemains(S.SliceandDice) < 5 and ((Player:ComboPoints() >= 2 and HL.CombatTime()<3 
            or aoeTTD()>6 and Player:ComboPoints() >= 4 or targetdying and inRange25 > 1)
            or (inRange25==1 and (
            Player:ComboPoints() >= 2 and  Target:TimeToDie()>6 + Player:GCD()
            or
            Player:ComboPoints() >= 3 and Target:TimeToDie()>8 + Player:GCD())
            or
            Player:ComboPoints() >= 4 and  Target:TimeToDie()>10 + Player:GCD())))
            

        then
            return S.SliceandDice:Cast()
        end

        if IsReady('Envenom')  and
                not Player:Buff(S.EnvenomBuff) and targetRange5 and Player:ComboPoints()>=3 
                and (Target:DebuffStack(S.DeadlyPoisonDebuff)>=3 and targetdying or Target:Debuff(S.DeadlyPoisonDebuff) and Player:ComboPoints()>=5)
              
            then
                return S.envenom:Cast()
            end
    
            if IsReady('Eviscerate')
            and targetRange5 and (not Target:Debuff(S.DeadlyPoisonDebuff) 
            or Target:DebuffStack(S.DeadlyPoisonDebuff)<=2) 
            and (targetdying and Player:ComboPoints()>=2 or Player:ComboPoints()>=5) 
        then
            return S.Eviscerate:Cast()
        end


        if
            IsReady('Backstab')

            -- S.Backstab:CanCast()
            and targetRange5 and not Player:IsTanking(Target)
        then
            return S.Backstab:Cast()
        end

        if
        -- S.SinisterStrike:CanCast()
            (IsReady('Sinister Strike') or IsReady('Saber Slash'))
            and targetRange5 and Player:ComboPoints() < 5
        then
            return S.SinisterStrike:Cast()
        end
    end



    return 135328
end

RubimRH.Rotation.SetAPL(4, APL);
