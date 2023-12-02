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

Wrath = Spell(5176),

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





S.Wrath:RegisterInFlight()



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
   

-- Out of combat rotation - heals,buffs, etc. 
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then

--Put out of combat rotation - heals,buffs, etc. 

    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.Wrath:InFlight()) and not Target:IsDeadOrGhost() then 
        if not IsCurrentSpell(6603) and TargetinRange(37) then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if S.Wrath:CanCast(Target) and not Player:IsMoving() then
            return S.Wrath:Cast()
        end












--end for out of combat rotation
    end


   return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end



   -- In combat rotation - 
   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
 

    if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.Wrath:InFlight()) and not Target:IsDeadOrGhost() then 
       --put in combat rotation in this section
       
        if not IsCurrentSpell(6603) and TargetinRange(37) then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if S.Wrath:CanCast(Target) and not Player:IsMoving() then
            return S.Wrath:Cast()
        end
















--end for in combat rotation

    end

   
return 135328
end
end



local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
RubimRH.Rotation.SetAPL(11, APL);
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