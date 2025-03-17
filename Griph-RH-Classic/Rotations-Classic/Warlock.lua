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

GriphRH.Spell[9] = {


    --put spells here
    -- GladiatorStance = Spell(412513),

};

local S = GriphRH.Spell[9]

if not Item.Warlock then
    Item.Warlock = {}
end
Item.Warlock.General = {
    autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Warlock.General;

--any missing textures change icon
-- S.Meathook.TextureSpellID = { 20589 }    -- escape artist










local function APL()

    --some references
    -- inRange5 = RangeCount(5)
    -- targetRange5 = IsSpellInRange("Hamstring")
    -- targetRange25 = TargetinRange(25)
    local inRange25 = 0
    for i = 1, 40 do
        if UnitExists('nameplate' .. i) then
            inRange25 = inRange25 + 1
        end
    end

    -- if Target:Exists() then
    --     return S.Charge:Cast()
    -- end

    -- local namegladiator = GetSpellInfo('Gladiator Stance')


    local nameflagellation = GetSpellInfo('Flagellation')
    local namerampage = GetSpellInfo('Rampage')
    local nameconsumedbyrage = GetSpellInfo('Consumed By Rage')


    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")


    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end






    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------SPELL QUEUES-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if GriphRH.QueuedSpell():ID() == S.IntimidatingShout:ID() and S.IntimidatingShout:CooldownRemains() > 2 then
        GriphRH.queuedSpell = { GriphRH.Spell[1].Default, 0 }
    end

   
    if GriphRH.QueuedSpell():ID() == S.IntimidatingShout:ID()  then
        return GriphRH.QueuedSpell():Cast()
    end
    




    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
      -- put in combat rotation here
  



    end



    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------Out of combat----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
        -- if not IsCurrentSpell(6603) and (TargetinRange(5) or targetRange5) and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and Target:AffectingCombat() then
        --     return I.autoattack:ID()
        -- end

  





    end


    return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(9, APL);
