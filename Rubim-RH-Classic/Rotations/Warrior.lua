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

RubimRH.Spell[1] = {
    HeroicStrike = Spell(25286),
    Rend = Spell(772),
	Warstomp = Spell(20549),
	Whirlwind = Spell(1680),
	Bloodthirst = Spell(23881),
	Bloodrage = Spell(2687),
	Execute = Spell(20662),
	Slam = Spell(11605),
	BattleShout = Spell(25289),
	Cleave = Spell(20569),
	ThunderClap = Spell(11581),
	
};

local S = RubimRH.Spell[1]

if not Item.Warrior then
    Item.Warrior = {}
end
Item.Warrior.Arms = {
autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Warrior.Arms;



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



local function APL()

    inRange5 = RangeCount("Heroic Strike")
    inRange25 = RangeCount("Charge")

    targetRange5 = TargetInRange("Heroic Strike")
    targetRange25 = TargetInRange("Charge")

-- 	-- In combat
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	
		if S.Bloodrage:CanCast(Player) and Player:Rage()<80 and targetRange5 then
		return S.Bloodrage:Cast()
	end
	
	
	if not IsCurrentSpell(6603) and HL.CombatTime()>2 then
		return I.autoattack:ID()
	end
	
		

-- Whirlwind IconWhirlwind — Whirlwind IconWhirlwind takes over as your top priority spell when fighting multiple enemies at once for the extra AoE damage.
	
	if S.Whirlwind:CanCast() and inRange5>=2 and RubimRH.AoEON() then
        return S.Whirlwind:Cast()
     end
-- Thunder Clap IconThunder Clap — Thunder Clap IconThunder Clap is not one of your main abilities, but as it is not limited to 4 targets like Whirlwind IconWhirlwind is, you will want to use this on large AoE pulls.
	
	if S.ThunderClap:CanCast() and inRange5>=4 and RubimRH.AoEON() then
        return S.ThunderClap:Cast()
     end
-- Cleave IconCleave — You replace Heroic Strike IconHeroic Strike with Cleave IconCleave in AoE situations to hit as many targets as possible. This is even better when paired together with Glyph of Cleaving Icon Glyph of Cleaving.
	if S.Cleave:CanCast() and inRange5>=2 and RubimRH.AoEON() then
        return S.Cleave:Cast()
     end
-- After this you will go back into your Single-Target rotation until a higher-priority AoE ability is ready.
	
	
-- Sunder Armor IconSunder Armor — Sunder Armor IconSunder Armor remains your best opening ability on bosses, increasing all Physical damage taken. You do not need to do this if someone else, such as a Rogue, is applying an Armor reduction debuff.
	if S.SunderArmor:CanCast(Target) and Target:TimeToDie()>20 and Target:DebuffStack(S.FesteringWoundDebuff) <= 5 then
        return S.SunderArmor:Cast()
    end	
-- Bloodthirst IconBloodthirst — This spell is the bread and butter of a Fury Warrior's rotation. It has a very low cooldown, letting you use it constantly. Make sure to use this ability as much as possible. It also has a 20% chance to proc Bloodsurge IconBloodsurge.
	if S.Bloodthirst:CanCast(Target) then
        return S.Bloodthirst:Cast()
    end	
-- Whirlwind IconWhirlwind — Whirlwind IconWhirlwind is your highest damage-dealing ability due to you wielding 2 two-handed weapons along with the talent Improved Whirlwind IconImproved Whirlwind. In situations with multiple targets, prioritize using Whirlwind IconWhirlwind over Bloodthirst IconBloodthirst as the AoE damage gained will outweigh the lost cooldown of Bloodthirst IconBloodthirst. It also has a 20% chance to proc Bloodsurge IconBloodsurge.
	if S.Whirlwind:CanCast() and inRange5>=2 then
        return S.Whirlwind:Cast()
    end	
-- Slam IconSlam — You will want to use Slam IconSlam after your two primary abilities are on cooldown if you have a Bloodsurge IconBloodsurge proc. Be aware of your buffs and do not use Slam IconSlam without a Bloodsurge IconBloodsurge proc as it will not be instant cast.
	if S.Slam:CanCast(Target) and not Player:IsMoving() then
        return S.Slam:Cast()
    end	
-- Heroic Strike IconHeroic Strike — You will start using Heroic Strike IconHeroic Strike when you have more than 60 Rage to prevent wasting excess Rage. This is great when paired with Glyph of Heroic Strike Icon Glyph of Heroic Strike for a bit of a Rage refund. It also has a 20% chance to proc Bloodsurge IconBloodsurge.
	if S.HeroicStrike:CanCast(Target) then
        return S.HeroicStrike:Cast()
    end	
-- Execute IconExecute — Execute IconExecute has dropped from being one of your highest-priority spells to your lowest as it has been nerfed greatly in WotLK.
	if S.Execute:CanCast(Target) then
        return S.Execute:Cast()
    end	






  
	
	
end

	
	
-- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then

	if S.BattleShout:CanCast(Player) 
	and not AuraUtil.FindAuraByName("Battle Shout", "player")  and inRange20==0
	and Player:BuffRemains(S.BattleShout)<60 then
		return S.BattleShout:Cast()
	end







return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end
	
return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

RubimRH.Rotation.SetAPL(1, APL);
