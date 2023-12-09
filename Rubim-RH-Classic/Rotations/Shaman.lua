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
	LightningBolt1 = Spell(403),
	AutoAttack = Spell(6603),
	Bloodlust = Spell(2825),
    Rockbiter = Spell(8017),
	FlameTongueWeapon = Spell(25489),

	trinket = Spell(33697), -- Blood Fury
	trinket2 = Spell(26296), -- berserking
	EarthElementalTotem = Spell(2062),
	FireElementalTotem = Spell(2894),
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNovaTotem = Spell(25547),
	ElementalMastery = Spell(16166),
	LesserHealingWave = Spell(25420),
    ChainLightning = Spell(25442),
    LightningBolt = Spell(25449),
    WaterShield = Spell(33736),
	EarthShock = Spell(25454),
	FlameShock = Spell(25457),
	FrostShock = Spell(25464),
	GroundingTotem = Spell(8177),
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

S.LightningBolt1:RegisterInFlight()

local function mhenchant()

hasMainHandEnchant, mainHandExpiration = GetWeaponEnchantInfo()

if (hasMainHandEnchant == true) then
return true else return false
end


end



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



if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
    return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

    if RubimRH.QueuedSpell():IsReadyQueue() then
       return RubimRH.QueuedSpell():Cast()
   end
   

-- -- -- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
    if not mhenchant() then
        return S.Rockbiter:Cast()
    end

    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt1:InFlight()) and not Target:IsDeadOrGhost() then 
        if not IsCurrentSpell(6603)  then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if S.LightningBolt1:CanCast(Target) and not Player:IsMoving() then
            return S.LightningBolt1:Cast()
        end



    end





   return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



   -- In combat
   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
    if not mhenchant() then
        return S.Rockbiter:Cast()
    end

    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt1:InFlight()) and not Target:IsDeadOrGhost() then 
        if not IsCurrentSpell(6603) then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if S.LightningBolt1:CanCast(Target) and not Player:IsMoving() then
            return S.LightningBolt1:Cast()
        end



    end




   
return 135328


end
end

-- local function APL()
--  UpdateRanges()

   
	-- if Player:IsMoving() and Cache.EnemiesCount[20]>=1 then print('enemies in 20yd') 
      -- else print('no enemies in 20yd') end
	  
	-- if Player:IsMoving() then
	 -- print(Cache.EnemiesCount[20]>=1)
-- end 

--  	if RubimRH.QueuedSpell():IsReadyQueue() then
--         return RubimRH.QueuedSpell():Cast()
-- 	end

	
	
	

-- 	if not Player:AffectingCombat() or RubimRH.queuedSpell[1]:CooldownRemains()>1.5 or (S.FlameShock:ID() ==  RubimRH.queuedSpell[1]:ID() and not IsSpellInRange(GetSpellInfo(25454), "target")) or (S.EarthShock:ID() ==  RubimRH.queuedSpell[1]:ID() and not IsSpellInRange(GetSpellInfo(25454), "target")) or (S.FrostShock:ID() ==  RubimRH.queuedSpell[1]:ID() and not IsSpellInRange(GetSpellInfo(25454), "target")) or (S.TotemofWrath:ID() ==  RubimRH.queuedSpell[1]:ID() and Player:Buff(S.TotemofWrathBuff)) or (S.LesserHealingWave:ID() ==  RubimRH.queuedSpell[1]:ID() and S.LesserHealingWave:CooldownRemains()>=1) then
-- 		RubimRH.queuedSpell = { RubimRH.Spell[7].Default, 0 }
-- 	end
	


-- --add in HL get time for pvp




-- 	-- In combat
--     if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) then




-- if RubimRH.AoEON() and not Player:IsMoving() then 
--         if S.ChainLightning:CanCast(Target) and not RubimRH.CDsON()	then
--             return S.ChainLightning:Cast()
--         end
--         if S.ChainLightning:CanCast(Target) and S.ElementalMastery:CooldownRemains()>5 and RubimRH.CDsON() then
--             return S.ChainLightning:Cast()
--         end
-- 		 if S.ChainLightning:CanCast(Target) and Player:Buff(S.ElementalMastery) then
--             return S.ChainLightning:Cast()
--         end
-- 	end
	
--         if S.LightningBolt:CanCast(Target) and not Player:IsMoving() and (not RubimRH.AoEON() or (not RubimRH.CDsON() or S.ElementalMastery:CooldownRemains()>0 or Player:Buff(S.ElementalMastery) and S.ChainLightning:CooldownRemains()>2)) then
--             return S.LightningBolt:Cast()
--         end

--         if S.WaterShield:CanCast() and not Player:Buff(S.WaterShield) and Player:ManaPercentage()<10  then
--             return S.WaterShield:Cast()
--         end

	
-- 		if not IsCurrentSpell(6603) then
-- 		return S.AutoAttack:Cast()
-- 	end
    

--     end
	
	
	
	
	
	
	
	-- if Player:IsMoving() then
	 -- print(mhenchant())
-- end
	
	
	
	
	
	
-- -- Out of combat
-- if not Player:AffectingCombat() then


-- 		-- if S.FlameTongueWeapon:CanCast() and (not Player:Buff(S.FlameTongueBuff) or Player:BuffRemains(S.FlameTongueBuff)<300) and not Player:Buff(S.Drink) then
--             -- return S.flametongue:Cast()
--         -- end
		
-- 	if not Player:IsMoving() then 
		
-- 		if S.ChainLightning:CanCast(Target) and Player:Buff(S.ElementalMastery) and RubimRH.AoEON() then
--             return S.ChainLightning:Cast()
--         end

--         if S.LightningBolt:CanCast(Target) then
--             return S.LightningBolt:Cast()
--         end
		
-- 	end

--         if S.WaterShield:CanCast() and (Player:BuffRemains(S.WaterShield)<120 or Player:BuffStack(S.WaterShield)<2) and not Player:Buff(S.Drink) then
--             return S.WaterShield:Cast()
--         end
		
--    if mhenchant() == false and not Player:Buff(S.Drink) then
--    return S.FlameTongueWeapon:Cast()
--    end
-- return 135600
-- end
	
	
-- end

local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
RubimRH.Rotation.SetAPL(7, APL);
-- RubimRH.Rotation.SetPvP(7, PvP)
-- RubimRH.Rotation.SetPASSIVE(7, PASSIVE);


local lastUpdate = 27082019
local function CONFIG()
    local function setVariables()
        RubimRH.db.profile[RubimRH.playerClass] = {}
        RubimRH.db.profile[RubimRH.playerClass].version = lastUpdate
        RubimRH.db.profile[RubimRH.playerClass].cooldown = true
    end

    if not RubimRH.db.profile[RubimRH.playerClass] then
       setVariables()
    end

    if RubimRH.db.profile[RubimRH.playerClass] and RubimRH.db.profile[RubimRH.playerClass].version ~= lastUpdate then
        setVariables()
    end
end
-- RubimRH.Rotation.SetCONFIG(7, CONFIG)