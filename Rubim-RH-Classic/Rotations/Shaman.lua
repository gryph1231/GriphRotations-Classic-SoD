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
    LesserHealingWave = Spell(SpellRank('Lesser Healing Wave')),
	FlametongueWeapon = Spell(SpellRank('Flametongue Weapon')),
    StoneskinTotem = Spell(SpellRank('Stoneskin Totem')),
    StrengthofEarthTotem = Spell(SpellRank('Strength of Earth Totem')),
    LightningShield = Spell(SpellRank('Lightning Shield')),
    EarthbindTotem = Spell(SpellRank('Earthbind Totem')),
    StoneclawTotem = Spell(SpellRank('Stoneclaw Totem')),
    SearingTotem = Spell(SpellRank('Searing Totem')),
    LavaLash = Spell(SpellRank('Lava Lash')),
    handrune = Spell(20554),--berserking
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNovaTotem = Spell(SpellRank('Fire Nova Totem')),
    MagmaTotem = Spell(SpellRank('Magma Totem')),
	-- ElementalMastery = Spell(SpellRank('Elemental Mastery')),
	-- LesserHealingWave = Spell(SpellRank('Lesser Healing Wave')),
    -- ChainLightning = Spell(SpellRank('Chain Lightning')),
    -- WaterShield = Spell(33736),
	EarthShock = Spell(SpellRank('Earth Shock')),
	FlameShock = Spell(SpellRank('Flame Shock')),
	FrostShock =  Spell(SpellRank('Frost Shock')),
    TremorTotem = Spell(SpellRank('Tremor Totem')),
    GhostWolf = Spell(SpellRank('Ghost Wolf')),
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
if RubimRH.QueuedSpell():ID() == S.LesserHealingWave:ID() and (not IsReady('Lesser Healing Wave') or Player:MovingFor()>1 or not Player:AffectingCombat()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.CurePoison:ID() and (Player:ManaPercentage()<10 or not Player:AffectingCombat()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and (not IsReady('Earthbind Totem') or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FireNovaTotem:ID() and (not IsReady('Fire Nova Totem') or not Player:AffectingCombat())  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.StoneclawTotem:ID() and (not IsReady('Stoneclaw Totem') or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.SearingTotem:ID() and (not IsReady('Searing Totem') or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.TremorTotem:ID() and (not IsReady('Tremor Totem') or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.MagmaTotem:ID() and (not IsReady('Magma Totem') or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.Purge:ID() and (not IsReady('Purge') or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.EarthShock:ID() and (not IsReady('Earth Shock') or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FlameShock:ID() and (not IsReady('Flame Shock') or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FrostShock:ID() and (not IsReady('Frost Shock') or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.GhostWolf:ID() and (not IsReady('Ghost Wolf') or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.HealingWave:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.LesserHealingWave:ID() then
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
if RubimRH.QueuedSpell():ID() == S.MagmaTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.StoneclawTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.SearingTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.TremorTotem:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.Purge:ID() and Target:Exists() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.EarthShock:ID() and Target:Exists() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.FrostShock:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.FlameShock:ID() then
    return RubimRH.QueuedSpell():Cast()
end
if RubimRH.QueuedSpell():ID() == S.GhostWolf:ID() and not Player:IsMoving() then
    return RubimRH.QueuedSpell():Cast()
end


local mhenchant,mhenchantduration,_,_,ohenchant,ohenchantduration = GetWeaponEnchantInfo()
if mhenchant == true then
mhenchantseconds = mhenchantduration/1000
else mhenchantseconds = 0
end

if ohenchant == true then
    ohenchantseconds = ohenchantduration/1000
    else ohenchantseconds = 0
    end

    
    local fire, earth, water, air = CheckActiveElementalTotems()


-- -- -- Out of combat
if (not Player:AffectingCombat() or Target:IsCasting()) and not AuraUtil.FindAuraByName("Drink", "player") 
and not AuraUtil.FindAuraByName("Food", "player")  then


    if mhenchantseconds <30 and IsReady('Rockbiter Weapon') and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and Player:IsMoving() then
        return S.RockbiterWeapon:Cast()
    end
    if ohenchantseconds <30 and IsReady('Flametongue Weapon') and HasOffhandWeapon() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and Player:IsMoving() then
        return S.FlametongueWeapon:Cast()
    end

    if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return I.autoattack:ID()
    end
    
    if IsReady('Lava Lash') and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return S.handrune:Cast()
    end

    if  IsReady('Lightning Shield') and not AuraUtil.FindAuraByName("Lightning Shield", "player")  and  Player:IsMoving() and Player:ManaPercentage()>50 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
        return S.LightningShield:Cast()
    end

    -- if Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 

 
        -- if  IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
        --     return S.LightningBolt:Cast()
        -- end


    -- end





   return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



   -- In combat
   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() 
   and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") 
 then


    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt:InFlight()) and not Target:IsDeadOrGhost() then 
  
        
        if mhenchantseconds <30 and IsReady('Flametongue Weapon') and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.RockbiterWeapon:Cast()
        end
        if ohenchantseconds <30 and IsReady('Flametongue Weapon') and HasOffhandWeapon() and not AuraUtil.FindAuraByName("Ghost Wolf", "player")  then
            return S.FlametongueWeapon:Cast()
        end
       
        if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
            return I.autoattack:ID()
        end
    
        -- if IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
        --     return S.LightningBolt:Cast()
        -- end


        if IsReady('Lava Lash') and CheckInteractDistance("target", 3) then
            return S.handrune:Cast()
        end


        -- if IsReady('Flame Shock') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
        --     return S.FlameShock:Cast()
        -- end     




        -- if IsReady('Searing Totem') and CheckInteractDistance("target", 3) and fire == false then
        --     return S.SearingTotem:Cast()
        -- end 
        

    end




   
return 135328


end
end


RubimRH.Rotation.SetAPL(7, APL);
