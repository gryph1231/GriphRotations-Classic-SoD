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
	LightningBolt = Spell(6041),
    ChainLightning = Spell(421),
    EarthShock1 = Spell(408681),
    earthshock1 = Spell(20549), --war stomp
    TotemicProjection = Spell(437009),    
    totemicprojection = Spell(6495), --sentry totem
	AutoAttack = Spell(6603),
    HealingStreamTotem = Spell(6375),
    RockbiterWeapon = Spell(10399),
    Purge = Spell(8012),
    CurePoison = Spell(526),
    CureDisease = Spell(2870),
    AncestralSpirit = Spell(20609),
    HealingWave = Spell(959),
    LesserHealingWave = Spell(8008),
	FlametongueWeapon = Spell(8030),
    StoneskinTotem = Spell(8155),
    StrengthofEarthTotem = Spell(8160),
    LightningShield = Spell(945),
    EarthbindTotem = Spell(2484),
    StoneclawTotem = Spell(6391),
    SearingTotem = Spell(6364),
    -- LavaLash = Spell(SpellRank('Lava Lash')),
    handrune = Spell(20554),--berserking
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNovaTotem = Spell(8499),
    MagmaTotem = Spell(8190),
    WindfuryWeapon = Spell(8232),
    -- MoltenBlast = Spell(425339),
	-- ElementalMastery = Spell(SpellRank('Elemental Mastery')),
	-- LesserHealingWave = Spell(SpellRank('Lesser Healing Wave')),
    -- ChainLightning = Spell(SpellRank('Chain Lightning')),
    -- WaterShield = Spell(33736),
    MaelstromWeapon = Spell(408505),
	EarthShock = Spell(408687),
	FlameShock = Spell(8053),
	FrostShock =  Spell(8056),
    TremorTotem = Spell(8143),
    GhostWolf = Spell(2645),
	GroundingTotem = Spell(8177),
    WindfuryTotem = Spell(8512),
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

    local inRange25 = 0
    for i = 1, 40 do
        if UnitExists('nameplate' .. i) then
            inRange25 = inRange25 + 1
        end
    end

if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
    return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



if RubimRH.QueuedSpell():ID() == S.HealingWave:ID() and (not IsUsableSpell("Healing Wave") or Player:MovingFor()>1) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.LesserHealingWave:ID() and (not IsUsableSpell("Lesser Healing Wave") or Player:MovingFor()>1 ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.CurePoison:ID() and (not IsUsableSpell("Cure Poison") or GetAppropriateCureSpell() ~= "Poison" ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.CureDisease:ID() and (not IsUsableSpell("Cure Disease") or GetAppropriateCureSpell() ~= "Disease") then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Earthbind Totem") or S.EarthbindTotem:CooldownRemains()>2 or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FireNovaTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Fire Nova Totem") or S.FireNovaTotem:CooldownRemains()>2 or not Player:AffectingCombat())  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.StoneclawTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Stoneclaw Totem") or S.StoneclawTotem:CooldownRemains()>2 or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.TremorTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Tremor Totem") or not Player:AffectingCombat() )  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.EarthShock:ID() and (not targetRange25 or not IsUsableSpell("Earth Shock") or S.EarthShock:CooldownRemains()>2  or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.earthshock1:ID() and (not targetRange25 or S.EarthShock:CooldownRemains()>2  or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.FlameShock:ID() and (not targetRange25 or not IsUsableSpell("Flame Shock") or S.FlameShock:CooldownRemains()>2  or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.FrostShock:ID() and (not targetRange25 or not IsUsableSpell("Frost Shock") or S.FrostShock:CooldownRemains()>2 or not Player:AffectingCombat() ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.GhostWolf:ID() and (not targetRange25 or not IsUsableSpell("Ghost Wolf") or not Player:AffectingCombat() or Player:MovingFor()>1 ) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.Purge:ID() and (not targetRange25 or not IsUsableSpell("Purge") or not CanTargetBePurged()) then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.SearingTotem:ID() and (RangeCount11()<1 or not IsUsableSpell("Searing Totem"))  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end
if RubimRH.QueuedSpell():ID() == S.MagmaTotem:ID() and (RangeCount11()<2 or not IsUsableSpell("Magma Totem"))  then
    RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
end

  
        if RubimRH.QueuedSpell():ID() == S.Purge:ID() and not GetAppropriateCureSpell() == "Poison" 
        and not GetAppropriateCureSpell() == "Disease" and Target:Exists() and not Target:IsDeadOrGhost() 
        and Player:CanAttack(Target) and CanTargetBePurged() and IsUsableSpell("Purge") then
            return RubimRH.QueuedSpell():Cast()
        end
     
        if RubimRH.QueuedSpell():ID() == S.Purge:ID() and GetAppropriateCureSpell() == "Poison" and IsUsableSpell("Cure Poison") then
            RubimRH.queuedSpell = { RubimRH.Spell[7].CurePoison, 0 }
            return RubimRH.QueuedSpell():Cast()
        end        

        if RubimRH.QueuedSpell():ID() == S.Purge:ID() and GetAppropriateCureSpell() == "Disease" and IsUsableSpell("Cure Disease") then
            RubimRH.queuedSpell = { RubimRH.Spell[7].CureDisease, 0 }
            return RubimRH.QueuedSpell():Cast()
        end      

   
        if RubimRH.QueuedSpell():ID() == S.SearingTotem:ID() and RangeCount11() == 1 and IsUsableSpell("Searing Totem") then
            return RubimRH.QueuedSpell():Cast()
        end
        
        if RubimRH.QueuedSpell():ID() == S.SearingTotem:ID() and RangeCount11() > 1 and IsUsableSpell("Magma Totem") then
            RubimRH.queuedSpell = { RubimRH.Spell[7].MagmaTotem, 0 }
            return RubimRH.QueuedSpell():Cast()
        end


if RubimRH.QueuedSpell():ID() == S.TotemicProjection:ID() then
    RubimRH.queuedSpell = { RubimRH.Spell[7].totemicprojection, 0 }
    return RubimRH.QueuedSpell():Cast()
end

if RubimRH.QueuedSpell():CanCast() then
	return RubimRH.QueuedSpell():Cast()
end

local haveTotem1, totemName1, startTime1, duration1 = GetTotemInfo(1)
	local remainingDura1 = (duration1 - (GetTime() - startTime1))
local haveTotem2, totemName2, startTime2, duration2 = GetTotemInfo(2)
	local remainingDura2 = (duration2 - (GetTime() - startTime2))
local haveTotem3, totemName3, startTime3, duration3 = GetTotemInfo(3)
	local remainingDura3 = (duration3 - (GetTime() - startTime3))
local haveTotem4, totemName4, startTime4, duration4 = GetTotemInfo(4)
	local remainingDura4 = (duration4 - (GetTime() - startTime4))

if remainingDura1 < 0 then
	remainingDura1 = 0
end
if remainingDura2 < 0 then
	remainingDura2 = 0
end
if remainingDura3 < 0 then
	remainingDura3 = 0
end
if remainingDura4 < 0 then
	remainingDura4 = 0
end

if remainingDura1 > 0 then 
	haveFire = 1
else
	haveFire = 0
end
if remainingDura2 > 0 then 
	haveEarth = 1
else
	haveEarth = 0
end
if remainingDura3 > 0 then 
	haveWater = 1
else
	haveWater = 0
end
if remainingDura4 > 0 then 
	haveAir = 1
else
	haveAir = 0
end


local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()

if hasMainHandEnchant == true then
mhenchantseconds = mainHandExpiration/1000
else mhenchantseconds = 0
end

if hasOffHandEnchant == true then
    ohenchantseconds = offHandExpiration/1000
    else ohenchantseconds = 0
    end

    local haveTotem1, totemName1, startTime1, duration1 = GetTotemInfo(1) --Fire totems
	local remainingDura1 = (duration1 - (GetTime() - startTime1))
local haveTotem2, totemName2, startTime2, duration2 = GetTotemInfo(2) --Earth totems
	local remainingDura2 = (duration2 - (GetTime() - startTime2))
local haveTotem3, totemName3, startTime3, duration3 = GetTotemInfo(3) --Water totems
	local remainingDura3 = (duration3 - (GetTime() - startTime3))
local haveTotem4, totemName4, startTime4, duration4 = GetTotemInfo(4) --Air totems
	local remainingDura4 = (duration4 - (GetTime() - startTime4))


-- if air == false and AuraUtil.FindAuraByName("Windfury Totem", "player") then 
--     return S.WindfuryTotem:Cast()
-- end

-- -- -- Out of combat
if (not Player:AffectingCombat() or Target:IsCasting()) and not AuraUtil.FindAuraByName("Drink", "player") 
and not AuraUtil.FindAuraByName("Food", "player")  then


    if (mhenchantseconds <30 or mainHandEnchantID ~=283) and not IsEquippedItemType("Shield") and IsReady('Windfury Weapon') and HasMainhandWeapon()  and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and Player:IsMoving() then
        return S.WindfuryWeapon:Cast()
    end

    if (mhenchantseconds <30 or mainHandEnchantID ~=503) and IsEquippedItemType("Shield") and IsReady('Rockbiter Weapon') and HasMainhandWeapon()  and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and Player:IsMoving() then
        return S.RockbiterWeapon:Cast()
    end

    if (ohenchantseconds <30 or offHandEnchantID ~=3) and IsReady('Flametongue Weapon') and HasOffhandWeapon() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and Player:IsMoving() then
        return S.FlametongueWeapon:Cast()
    end

    if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return I.autoattack:ID()
    end


    if IsReady('Molten Blast') and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return S.handrune:Cast()
    end


    if IsReady('Lava Lash') and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return S.handrune:Cast()
    end

    if IsReady('Lightning Shield') and not IsInInstance() and not AuraUtil.FindAuraByName("Lightning Shield", "player")  and  Player:IsMoving() and Player:ManaPercentage()>50 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
        return S.LightningShield:Cast()
    end





    -- if Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 

 
        -- if  IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
        --     return S.LightningBolt:Cast()
        -- end


    -- end

    -- if IsReady(SpellRank('Totemic Projection')) 

    
    -- then
    --     return S.TotemicProjection:Cast()
    -- end 



   return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



   -- In combat
   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() 
   and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") 
 then


    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt:InFlight()) and not Target:IsDeadOrGhost() then 
  
 

    if mhenchantseconds <30 and not IsEquippedItemType("Shield") and IsReady('Windfury Weapon') and HasMainhandWeapon() 
     and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
        return S.WindfuryWeapon:Cast()
    end

    if mhenchantseconds <30 and IsEquippedItemType("Shield") and IsReady('Rockbiter Weapon') and HasMainhandWeapon()  
    and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
        return S.RockbiterWeapon:Cast()
    end
    
    if ohenchantseconds <30 and IsReady('Flametongue Weapon') and HasOffhandWeapon() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
        return S.FlametongueWeapon:Cast()
    end
       
        if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
            return I.autoattack:ID()
        end
    
    if IsReady('Healing Wave') and Player:HealthPercentage()<40 and Player:BuffStack(S.MaelstromWeapon)>=5 then
        return S.HealingWave:Cast()
    end
    

  
    

    if IsReady('Chain Lightning') and Player:BuffStack(S.MaelstromWeapon)>=5 and targetRange30 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return S.ChainLightning:Cast()
    end
    
     
    if IsReady('Lightning Bolt') and Player:BuffStack(S.MaelstromWeapon)>=5 and targetRange30 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return S.LightningBolt:Cast()
    end

    
        -- if IsReady('Lightning Bolt') and targetRange30 and not Player:IsMoving() then
        --     return S.LightningBolt:Cast()
        -- end
        if IsReady('Molten Blast') and CheckInteractDistance("target", 3) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.handrune:Cast()
        end

        if IsReady('Lava Lash') and CheckInteractDistance("target", 3) then
            return S.handrune:Cast()
        end


        -- if IsReady('Flame Shock') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
        --     return S.FlameShock:Cast()
        -- end     




    
        

    end




   
return 135328


end
end


RubimRH.Rotation.SetAPL(7, APL);
