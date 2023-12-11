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
Envenom = Spell(57993),
DeadlyPoison = Spell(27187),
Eviscerate = Spell(2098),
ExposeArmor = Spell(26866),
Garrote = Spell(48676),
KidneyShot = Spell(8643),
Rupture = Spell(48672),
SnD = Spell(6774),
Backstab = Spell(53),
Evasion = Spell(26669),
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
mainhandpoison_instant = Spell(6495), -- sentry totem
offhandpoison_instant = Spell(370), -- purge 
mainhandpoison_instant1 = Spell(25500), -- frostbrand weapon
offhandpoison_instant1 = Spell(8017), -- rockbiter weapon 
KillingSpree = Spell(51690),
FanofKnives = Spell(51723),
ColdBlood = Spell(14177),
SB = Spell(20777), -- ascestral spirit --/use [@player] Saronite Bomb
GTSC = Spell(20549), -- war stomp--/use [@player] Global Thermal Sapper Charge
trinket_gloves = Spell(52127), --water shield
HungerforBlood = Spell(51662),
HungerforBloodBuff = Spell(63848),
Mutilate = Spell(1329),

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


    local function aoeTTD()
        local currHealth = {}
        local currHealthMax = {}
        local allGUID = {}
        local areaTTD = {}
        local count = 1
 
            for id = 1, 40 do
                local unitID = "nameplate" .. id
                if UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) 
                and ((UnitHealth(unitID) / UnitHealthMax(unitID)) * 100) < 100 then
                    if UnitGUID('Target') and UnitAffectingCombat('Target') then
                        currTarget = UnitGUID('Target')
                    end
                    table.insert(allGUID, UnitGUID(unitID))
                    table.insert(currHealth, UnitHealth(unitID))
                    table.insert(currHealthMax, UnitHealthMax(unitID))
                    if #currHealthMax >= 1 then
                        for id = 1, #currHealthMax do
                            dps = (currHealthMax[#currHealth] - currHealth[#currHealth]) / HL.CombatTime("nameplate" .. #currHealthMax)
                            areaTTD[#currHealthMax] = currHealth[#currHealth] / dps
                            end
                    end
                end
            end

            if #allGUID >= 1 and UnitGUID('Target') then 
                while(UnitGUID('Target') ~= allGUID[count]) do
                    count = count + 1
                    break
                end
            end

        if #currHealthMax >= 1 then
            return areaTTD[count]
        else
            return nil
        end

    end

    local function ruptureTime()
        local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")

        if AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL") then
            timer = expirationTime - HL.GetTime()
        else
            timer = 0
        end
            return timer
    end



local function APL()
    aoeTTD()

    inRange5 = RangeCount("Sinister Strike")
    inRange30 = RangeCount("Throw")
    targetRange5 = TargetInRange("Sinister Strike")
    targetRange30 = TargetInRange("Throw")

-- print(UnitLevel("player"))

-- print(Spell(select(7,GetSpellInfo("Sinister Strike"))):CanCast())


            if Target:Exists() and Player:CanAttack(Target) then
                mydps = ((UnitHealthMax('target')-UnitHealth('target'))/HL.CombatTime())
                STttd = Target:TimeToDie()
                if STttd>9999 or STttd == nil then
                    STttd = UnitHealth('target')/mydps
                            end
                AOEttd = aoeTTD()
                if AOEttd == nil then
                    AOEttd = STttd
                end
            end

            if Player:IsCasting() or Player:IsChanneling() then
                return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
            elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
            or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
                return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
            end


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
 


            
        if RubimRH.QueuedSpell():IsReadyQueue() then
            return RubimRH.QueuedSpell():Cast()
        end

--     -- Out of combat
if not Player:AffectingCombat()  then

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

        if S.Stealth:CanCast() and Player:IsMoving() and not Player:Buff(S.Stealth) and targetRange30 and UnitReaction("target","player")==2 then
            return S.Stealth:Cast()
        end

        if S.Backstab:CanCast() and targetRange5 and Player:ComboPoints()<4
        then
            return S.Backstab:Cast()
        end

        if S.SinisterStrike:CanCast() and targetRange5 and Player:ComboPoints()<4
        then
            return S.SinisterStrike:Cast()
        end
        if not IsCurrentSpell(6603)  and targetRange5 and Player:Energy()<45 then
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


        if not IsCurrentSpell(6603)  and targetRange5 then
            return I.autoattack:ID()
        end
    

--                 -- if S.Kick:CanCast() and RubimRH.CDsON() and S.Kick:CooldownUp() and Target:CastPercentage()> math.random(20, 80) and IsItemInRange(34368, 'target') then
--                 --     return S.Kick:Cast()
--                 --     end

--                 if S.Evasion:CanCast() and (inRange10==1 and STttd>4 and Player:IsTanking(Target) or inRange10>1) and Player:HealthPercentage()<55 then
--                     return S.Evasion:Cast()
--                     end

   


                if S.Eviscerate:CanCast() and targetRange5
                    and 
                    ( 
                    Player:ComboPoints()>=1 and STttd<3
                    or
                    Player:ComboPoints()>=2 and STttd<4
                    or
                    Player:ComboPoints()>=3 and STttd<5
                    or
                    Player:ComboPoints()>=4 and STttd<10
                    or
                    Player:ComboPoints()>=5

                    )
                    then
                    return S.Eviscerate:Cast()
                end


                if S.SinisterStrike:CanCast() and targetRange5 and Player:ComboPoints()<4
                then
                    return S.SinisterStrike:Cast()
                end
                
            end



        return 135328
    end
    
RubimRH.Rotation.SetAPL(4, APL);