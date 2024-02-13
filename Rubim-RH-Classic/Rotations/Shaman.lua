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

RubimRH.Spell[7] = {
	LightningBolt = Spell(SpellRank('Lightning Bolt')),

	AutoAttack = Spell(6603),
	Bloodlust = Spell(2825),
    RockbiterWeapon = Spell(SpellRank('Rockbiter Weapon')),
    Purge = Spell(SpellRank('Purge')),
    CurePoison = Spell(SpellRank('Cure Poison')),
    AncestralSpirit = Spell(SpellRank('Ancestral Spirit')),
    HealingWave = Spell(SpellRank('Healing Wave')),
	FlametongueWeapon = Spell(SpellRank('Flametongue Weapon')),
    StoneskinTotem = Spell(SpellRank('Stoneskin Totem')),
    StrengthofEarthTotem = Spell(SpellRank('Strength of Earth Totem')),
    LightningShield = Spell(SpellRank('Lightning Shield')),
    EarthbindTotem = Spell(SpellRank('Earthbind Totem')),
    StoneclawTotem = Spell(SpellRank('Stoneclaw Totem')),
	trinket = Spell(33697), -- Blood Fury
	trinket2 = Spell(26296), -- berserking

	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNovaTotem = Spell(SpellRank('Fire Nova Totem')),
	-- ElementalMastery = Spell(SpellRank('Elemental Mastery')),
	-- LesserHealingWave = Spell(SpellRank('Lesser Healing Wave')),
    -- ChainLightning = Spell(SpellRank('Chain Lightning')),
    -- WaterShield = Spell(33736),
	EarthShock = Spell(SpellRank('Earth Shock')),
	FlameShock = Spell(SpellRank('Flame Shock')),
	-- FrostShock =  Spell(SpellRank('Frost Shock')),
	-- GroundingTotem = Spell(SpellRank('Grounding Totem')),
};

local S = RubimRH.Spell[7]

if not Item.Shaman then
    Item.Shaman = {}
end
Item.Shaman.Elemental = {

	trinket = Item(28040, { 13, 14 }),
	trinket2 = Item(31615, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Shaman.Elemental;



S.AutoAttack.TextureSpellID = { 8017 }
S.LightningBolt:RegisterInFlight()






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


local function APL()
    targetRange25 = TargetInRange("Earth Shock")
    targetRange30 = TargetInRange("Lightning Bolt")

if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
    return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end


  
--    print(RubimRH.QueuedSpell():ID())
   if RubimRH.QueuedSpell():ID() == S.HealingWave:ID() and (not IsReady('Healing Wave') or Player:MovingFor()>1 or not Player:AffectingCombat()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.CurePoison:ID() and (not IsReady('Cure Poison') or not Player:AffectingCombat()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and (not IsReady('Earthbind Totem') or not Player:AffectingCombat() or S.EarthbindTotem:CooldownRemains() > Player:GCD())  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FireNovaTotem:ID() and (not IsReady('Fire Nova Totem') or not Player:AffectingCombat() or S.FireNovaTotem:CooldownRemains() > Player:GCD())  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.StoneclawTotem:ID() and (not IsReady('Stoneclaw Totem') or not Player:AffectingCombat() or S.StoneclawTotem:CooldownRemains() > Player:GCD())  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.Purge:ID() and (not IsReady('Purge') or not Player:AffectingCombat() or S.Purge:CooldownRemains() > Player:GCD()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.EarthShock:ID() and (not IsReady('Earth Shock') or not Player:AffectingCombat() or S.EarthShock:CooldownRemains() > Player:GCD()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end


if RubimRH.QueuedSpell():ID() == S.HealingWave:ID() then
    return RubimRH.QueuedSpell():Cast()
end

if RubimRH.QueuedSpell():ID() == S.CurePoison:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.EarthbindTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.FireNovaTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.StoneclawTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.Purge:ID() and Target:Exists() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.EarthShock:ID() and Target:Exists() then
    return RubimRH.QueuedSpell():Cast()
end


-- -- -- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
    if not mhenchant() and IsReady('Flametongue Weapon') then
        return S.FlametongueWeapon:Cast()
    end
    if  IsReady('Lightning Shield') and not AuraUtil.FindAuraByName("Lightning Shield", "player")  and  Player:IsMoving() and Player:ManaPercentage()>50 then
        return S.LightningShield:Cast()
    end

    -- if Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 

 
        if  IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
            return S.LightningBolt:Cast()
        end


    -- end





   return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



   -- In combat
   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then


    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt:InFlight()) and not Target:IsDeadOrGhost() then 
        if not IsCurrentSpell(6603)  and CheckInteractDistance("target", 3) then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
            return S.LightningBolt:Cast()
        end

        -- if IsReady('Earth Shock') and targetRange25  and Player:IsMoving() then
        --     return S.EarthShock:Cast()
        -- end

    end




   
return 135328


end
end


RubimRH.Rotation.SetAPL(7, APL);
