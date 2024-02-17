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
    ConsumedByRage = Spell(425418),
    Enrage = Spell(425415),
    RagingBlow = Spell(402911),
    ragingblow = Spell(20589),--escape artist
    Charge = Spell(100),
    Overpower = Spell(7384),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend1 = Spell(772),
    Rend2 = Spell(6546),

    Rend3 = Spell(6547),

    QuickStrike = Spell(429765),
    quickStrike = Spell(20594), --stone form
    HeroicStrike4 = Spell(1608),
    HeroicStrike2 = Spell(284),
    HeroicStrike3 = Spell(285),
    HeroicStrike1 = Spell(78),
    Cleave = Spell(845),
	-- Warstomp = Spell(20549),
	Whirlwind = Spell(1680),
	Bloodthirst = Spell(23881),
	Bloodrage = Spell(2687),
	-- Execute = Spell(20662),
	Slam = Spell(11605),
	BattleShout1 = Spell(6673),
    BattleShout2 = Spell(5242),

    BattleShout3 = Spell(6192),

	
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





local function APL()

    inRange5 = RangeCount("Rend")
    inRange25 = RangeCount("Charge")

    targetRange5 = TargetInRange("Rend")
    targetRange25 = TargetInRange("Charge")

    if AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL") then
        renddebuff = select(6,AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL")) - GetTime()
         else
            renddebuff = 0 
        end
        nextauto = math.max(0, (RubimRH.lasthit()-UnitAttackSpeed('player'))*-1)


        -- print(Player:PrevGCD(1, S.Cleave))

-- 	-- In combat
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	
        if IsReady("Battle Shout")
        and Player:IsMoving() and not AuraUtil.FindAuraByName("Battle Shout", "player") then
            return S.BattleShout1:Cast()
        end
        -- if S.BattleShout2:CanCast(Player) 
        -- and not AuraUtil.FindAuraByName("Battle Shout", "player")  and Player:IsMoving() and inRange25>=1
        -- and Player:BuffRemains(S.BattleShout2)<60 then
        --     return S.BattleShout2:Cast()
        -- end
        -- if S.BattleShout3:CanCast(Player) 
        -- and not AuraUtil.FindAuraByName("Battle Shout", "player") and Player:IsMoving() and inRange25>=1
        -- and Player:BuffRemains(S.BattleShout3)<60 then
        --     return S.BattleShout3:Cast()
        -- end
		
    if IsReady("Bloodrage") and not AuraUtil.FindAuraByName("Bloodrage", "player")  and CheckInteractDistance("target",3) and S.RagingBlow:CooldownRemains()<Player:GCD()
    and not AuraUtil.FindAuraByName("Enrage", "player")  and RubimRH.CDsON() then
		return S.Bloodrage:Cast()
	end

	if not IsCurrentSpell(6603) and HL.CombatTime()>1 and CheckInteractDistance("target",3) then
		return I.autoattack:ID()
	end
    

    if IsReady('Raging Blow')
    and CheckInteractDistance("target",3)  then
       return S.ragingblow:Cast()
   end
   if IsReady("Overpower") and CheckInteractDistance("target",3) then
    return S.Overpower:Cast()
end	



    if (Player:Rage()>=80 or AuraUtil.FindAuraByName("Enrage", "player"))  then



    if IsReady('Cleave') and RangeCount10() > 1 and CheckInteractDistance("target",3) 
    and not IsCurrentSpell(SpellRank('Cleave')) and IsCurrentSpell(6603) then
        return S.Cleave:Cast()
    end
    
    if IsReady('Quick Strike') and (Target:IsAPlayer() or not IsCurrentSpell(SpellRank('Cleave')) or Player:Rage()>37) and CheckInteractDistance("target",3) 
    and (RangeCount11() ==1 or RangeCount11()>1 and Player:Rage()>20)  then
        return S.quickStrike:Cast()
    end
    if IsReady('Heroic Strike') and RangeCount11() ==1 and Player:Rage()>80
    and CheckInteractDistance("target",3) and not IsCurrentSpell(SpellRank('Heroic Strike')) and IsCurrentSpell(6603) then
        return S.HeroicStrike1:Cast()
    end

end
end

	
	
-- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	if not IsCurrentSpell(6603) and targetRange5 then
		return I.autoattack:ID()
	end
    -- if S.BattleShout1:CanCast() 
    -- and Player:IsMoving() and not AuraUtil.FindAuraByName("Battle Shout", "player") 
    -- and Player:BuffRemains(S.BattleShout1)<45 then
    --     return S.BattleShout1:Cast()
    -- end
	-- if S.BattleShout2:CanCast(Player) 
	-- and not AuraUtil.FindAuraByName("Battle Shout", "player")  and Player:IsMoving() and inRange25>=1
	-- and Player:BuffRemains(S.BattleShout2)<60 then
	-- 	return S.BattleShout2:Cast()
	-- end
    if IsReady('Battle Shout')
	and not AuraUtil.FindAuraByName("Battle Shout", "player") and Player:IsMoving() and inRange25>=1 then
		return S.BattleShout1:Cast()
	end

if S.Charge:CanCast() and not IsCurrentSpell(SpellRank('Charge')) and targetRange25 then
    return S.Charge:Cast()
end




return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end
	
return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

RubimRH.Rotation.SetAPL(1, APL);
