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

RubimRH.Spell[11] = {
    --list of all druid spells and abilities

    Barkskin = Spell(22812),
    EntanglingRoots = Spell(9853),

    FaerieFire = Spell(9907),

    Hibernate = Spell(18658),

    Moonfire = Spell(8926),

    Wrath = Spell(5179),

    NaturesGrasp = Spell(17329),

    OmenOfClarity = Spell(16864),

    Thorns = Spell(9910),

    HealingTouch = Spell(9889),
    -- Rank11 = Spell(25297),

    Innervate = Spell(29166),

    MarkOfTheWild = Spell(9885),

    Regrowth = Spell(9858),

    Rejuvenation = Spell(9841),


    Bash                 = Spell(8983),

    CatForm              = Spell(768),

    ChallengingRoar      = Spell(5209),
    Claw                 = Spell(9850),
    Cower                = Spell(9892),
    Dash                 = Spell(9821),

    DemoralizingRoar     = Spell(9898),

    BearForm             = Spell(5487),
    DireBearForm         = Spell(9634),

    Enrage               = Spell(5229),

    FaerieFireFeral      = Spell(17392),

    FeralCharge          = Spell(16979),

    FerociousBite        = Spell(31018),

    FrenziedRegeneration = Spell(22896),

    Growl                = Spell(6795),
    Maul                 = Spell(9881),

    Pounce               = Spell(9827),

    Prowl                = Spell(9913),

    Rake                 = Spell(9904),

    Ravage               = Spell(9867),

    Rip                  = Spell(9896),

    Shred                = Spell(9830),

    Swipe                = Spell(9908),

    TigersFury           = Spell(9846),

    -- End of spells
};

local S = RubimRH.Spell[11]

if not Item.Druid then
    Item.Druid = {}
end
Item.Druid = {

    -- trinket = Item(28040, { 13, 14 }),
    -- trinket2 = Item(31615, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Druid;








local function num(val)
    if val then
        return 1
    else
        return 0
    end
end

local function bool(val)
    return val ~= 0
end
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

local function target_is_dummy()
    local x = UnitName("target")
    local targetisdummy = false

    if x then
        name = x:sub(-5)
    end

    if Target:Exists() then
        if name == 'Dummy' or name == 'elist' then
            targetisdummy = true
        end
    else
        targetisdummy = false
    end

    return targetisdummy
end

local function AreaTTD()
local currHealth = {}
local currHealthMax = {}
local areaTTD = {}

    for id = 1, 40 do
        local unitID = "nameplate" .. id
        if UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) 
        and ((UnitHealth(unitID) / UnitHealthMax(unitID)) * 100) < 100 then
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
    
    local count = 1
    local highest = 0

    for count = 1, #currHealthMax do
        if areaTTD[count] > highest then 
            highest = areaTTD[count]
        end
        count = count + 1
    end
    
	if highest ~= 0 then
		return highest
	else
		return 9999
	end

end

local function TargetTTD()
    local currHealth = {}
    local currHealthMax = {}
    local allGUID = {}
    local areaTTD = {}
    local areaTTD_Predicted = {}
    local areaDPS = {}
    local count = 1
    local highest = 0

    for id = 1, 40 do
        local unitID = "nameplate" .. id
        if UnitCanAttack("player", unitID)
            and ((UnitHealth(unitID) / UnitHealthMax(unitID)) * 100) < 100 then
            if UnitGUID('Target') then
                currTarget = UnitGUID('Target')
            end

            table.insert(allGUID, UnitGUID(unitID))
            table.insert(currHealth, UnitHealth(unitID))
            table.insert(currHealthMax, UnitHealthMax(unitID))

            if #allGUID >= 1 and UnitGUID('Target') then
                while (UnitGUID('Target') ~= allGUID[count]) do
                    count = count + 1
                    break
                end
            end

            if #currHealthMax >= 1 then
                for id = 1, #currHealthMax do
                    dps = (currHealthMax[#currHealth] - currHealth[#currHealth]) /
                        HL.CombatTime("nameplate" .. #currHealthMax)
                    if #currHealthMax ~= count then
                        areaTTD[#currHealthMax] = currHealth[#currHealth] / dps
                        --areaTTD_Predicted[#currHealthMax] = currHealth[#currHealth] / (dps + playerDPS)
                    else
                        areaTTD_Predicted[#currHealthMax] = currHealth[#currHealth] / dps
                    end
                end
            end
        end
    end
    if target_is_dummy() then
        return 8675309
    elseif #currHealthMax >= 1 and areaTTD_Predicted[count] then
        return areaTTD_Predicted[count]
    else
        return 1
    end
end


function PlayerHasAggroOnTarget()
    local status = UnitThreatSituation("player", "target")

    return status == 3
end

local function APL()
    inRange5 = RangeCount("Rake")
    inRange30 = RangeCount("Entangling Roots")
    targetRange5 = TargetInRange("Rake")
    targetRange30 = TargetInRange("Entangling Roots")


    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
    end

    if RubimRH.QueuedSpell():IsReadyQueue() then
        return RubimRH.QueuedSpell():Cast()
    end

    -- In combat rotation -
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then



    if not IsCurrentSpell(6603) and targetRange30 and not AuraUtil.FindAuraByName("Prowl", "player") then
        return Item(135274, { 13, 14 }):ID()
    end


    -- Health Check for Crowd Control
    if Player:HealthPercentage() < 50 then
        -- Exit form if in Cat or Bear Form

        if Player:Buff(S.CatForm) then
            return S.CatForm:Cast()
        end
        if Player:Buff(S.BearForm) or Player:Buff(S.DireBearForm) then
            return S.BearForm:Cast()
        end

        -- Primary Crowd Control: Nature's Grasp
        if inRange30 >= 1 and S.NaturesGrasp:CanCast() and not Player:Buff(S.NaturesGrasp)
        then
            return S.NaturesGrasp:Cast()
        end

        -- Secondary Crowd Control: Hibernate or Entangling Roots
        if targetRange30 and (UnitCreatureType('target') == "Beast" or UnitCreatureType('target') == "Dragonkin")
            and not Target:Debuff(S.Hibernate) and S.Hibernate:CanCast()
        then
            return S.Hibernate:Cast()
        end

        if not Target:Debuff(S.EntanglingRoots) and S.EntanglingRoots:CanCast(Target)
        then
            return S.EntanglingRoots:Cast()
        end

        if Player:HealthPercentage() < 50
            and S.HealingTouch:CanCast()
        then
            return S.HealingTouch:Cast()
        end

        if Player:HealthPercentage() < 60 and not AuraUtil.FindAuraByName("Regrowth", "player")
            and S.Regrowth:CanCast()
        then
            return S.Regrowth:Cast()
        end

        if not AuraUtil.FindAuraByName("Regrowth", "player")
            and S.Rejuvenation:CanCast()
        then
            return S.Rejuvenation:Cast()
        end
    end


    -- Check for multiple enemies: Opt for Bear Form for defense
    if inRange30 > 1 or Player:HealthPercentage() < 60 and inRange30 >= 1 then
        if not Player:Buff(S.BearForm) and not Player:Buff(S.DireBearForm) and (S.BearForm:CanCast() or S.DireBearForm:CanCast()) then
            return S.BearForm:Cast()
        end


        -- Check for Bear Form specific abilities
        if (Player:Buff(S.BearForm) or Player:Buff(S.DireBearForm)) then
            -- Frenzied Regeneration: Activate when health falls below 25% and you have more than 30 Rage
            if Player:HealthPercentage() < 25 and Player:Rage() > 30
                and S.FrenziedRegeneration:CanCast()
            then
                return S.FrenziedRegeneration:Cast()
            end

            -- Feral Charge: Employ when the target is too far for melee attacks
            if not targetRange5 and targetRange30 and S.FeralCharge:CanCast(Target) then
                return S.FeralCharge:Cast()
            end

            -- Growl: Use to attract enemy attention
            if (PlayerHasAggroOnTarget() ~= 3 and S.Growl:CanCast() and targetRange5) then -- Assuming IsNotTargetingPlayer() checks target's focus
                return S.Growl:Cast()
            end

            -- Faerie Fire (Feral): Apply to enemies not currently affected by this debuff
            if targetRange30
                and not Target:Debuff(S.FaerieFireFeral) and
                S.FaerieFireFeral:CanCast()
            then
                return S.FaerieFireFeral:Cast()
            end

            -- Enrage: Activate when Rage is under 15 and health exceeds 80%
            if targetRange5 and Player:Rage() < 15 and Player:HealthPercentage() > 80 and S.Enrage:CanCast() then
                return S.Enrage:Cast()
            end

            -- Demoralizing Roar: Apply to enemies not already debuffed by this
            if targetRange5
                and not Target:Debuff(S.DemoralizingRoar)
                and S.DemoralizingRoar:CanCast()
            then
                return S.DemoralizingRoar:Cast()
            end

            -- Maul: Utilize as soon as it becomes available
            if targetRange5 and S.Maul:CanCast()

            then
                return S.Maul:Cast()
            end

            -- Swipe: Use when Rage exceeds 35
            if targetRange5 and Player:Rage() > 35
                and S.Swipe:CanCast()
            then
                return S.Swipe:Cast()
            end
        end
    end



    -- Check for single enemy and DPS purposes: Opt for Cat Form
    if  inRange30 == 1 and targetRange30 then
        if not Player:Buff(S.CatForm) and S.CatForm:CanCast() then
            -- Switch to Cat Form for DPS
            return S.CatForm:Cast()
        end




        if Player:Buff(S.CatForm) and not AuraUtil.FindAuraByName("Prowl", "player") then
            -- if  RubimRH.CDsON()
            -- and (S.TigersFury.Rank1:CanCast()
            -- or S.TigersFury.Rank2:CanCast()
            -- or S.TigersFury.Rank3:CanCast()
            -- or S.TigersFury.Rank4:CanCast())
            -- then
            --     return S.TigersFury.Rank4:Cast()
            -- end


            -- Faerie Fire (Feral): Cast if the target is not debuffed by it
            if targetRange30 and not Target:Debuff(S.FaerieFireFeral) and S.FaerieFireFeral:CanCast()
            then
                return S.FaerieFireFeral:Cast()
            end


            -- Rake: Use when the target lacks its debuff and your Combo Points are below 5
            if targetRange5 and Player:ComboPoints() < 5 and not Target:Debuff(S.Rake) and S.Rake:CanCast()
            then
                return S.Rake:Cast()
            end

  

            -- -- Rip: Apply when the target lacks its debuff and you've accumulated 5 Combo Points
            if targetRange5 and Player:ComboPoints() == 5 and TargetTTD()>10
                and not Target:Debuff(S.Rip)
                and S.Rip:CanCast()
            then
                return S.Rip:Cast()
            end
            -- -- Ferocious Bite: Best used when you've reached 5 Combo Points
            if targetRange5 and Player:ComboPoints() == 5
                and S.FerociousBite:CanCast()
            then
                return S.FerociousBite:Cast()
            end


          -- -- Shred: Employ if your Combo Points are under 5 or if you have the Clearcasting buff
          if not Player:IsTanking(Target) and targetRange5 and (Player:ComboPoints() < 5 or AuraUtil.FindAuraByName("Clearcasting", "player"))
          and S.Shred:CanCast()
      then
          return S.Shred:Cast()
      end

            -- -- Claw: Opt for this if Shred is not viable due to positioning or fails for other reasons
            if targetRange5 and S.Claw:CanCast() then
                return S.Claw:Cast()
            end



        end
    end

   end







    -- Out of combat rotation - heals,buffs, etc.
    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
        --Put out of combat rotation - heals,buffs, etc.

        if Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not AuraUtil.FindAuraByName("Prowl", "player") then
            if not IsCurrentSpell(6603) and targetRange5 then
                return Item(135274, { 13, 14 }):ID()
            end
        end
        -- Buff: Mark of the Wild
        if S.MarkOfTheWild:CanCast() and not AuraUtil.FindAuraByName("Mark of the Wild", "player") then
            return S.MarkOfTheWild:Cast()
        end

        -- Buff: Thorns
        if S.Thorns:CanCast()
            and not AuraUtil.FindAuraByName("Thorns", "player") then
            return S.Thorns:Cast()
        end

        -- Buff: Omen of Clarity
        if S.OmenOfClarity:CanCast() and not AuraUtil.FindAuraByName("Omen of Clarity", "player") then
            return S.OmenOfClarity:Cast()
        end
    end










    return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end






RubimRH.Rotation.SetAPL(11, APL);
