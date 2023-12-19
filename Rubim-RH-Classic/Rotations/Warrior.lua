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
    ragingblow = Spell(20594),--taunt
    Charge = Spell(100),
    Overpower = Spell(7384),
    SunderArmor = Spell(7405),
    Execute = Spell(5308),
    Rend1 = Spell(772),
    Rend2 = Spell(6546),

    Rend3 = Spell(6547),

    QuickStrike = Spell(429765),
    quickStrike = Spell(20560), --mocking blow
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


local function IsReady(spell,range_check,aoe_check)
    local start,duration,enabled = GetSpellCooldown(tostring(spell))
    local usable, noMana = IsUsableSpell(tostring(spell))
    local range_counter = 0
    
    if duration and start then
    cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
    --gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
    end
    
    if cooldown_remains and cooldown_remains < 0 then
    cooldown_remains = 0
    end
    
    -- if gcd_remains and gcd_remains < 0 then
    -- gcd_remains = 0
    -- end
    
    if aoe_check then
    if Spell then
    for i = 1, 40 do
    local unitID = "nameplate" .. i
    if UnitExists(unitID) then          
    local nameplate_guid = UnitGUID(unitID)
    local npc_id = select(6, strsplit("-", nameplate_guid))
    if npc_id ~= '120651' and npc_id ~= '161895' then
    if UnitCanAttack("player", unitID) and IsSpellInRange(Spell, unitID) == 1 and UnitHealthMax(unitID) > 5 then
    range_counter = range_counter + 1
    end                    
    end
    end
    end
    end
    end
    
    
    -- if usable and enabled and cooldown_remains - gcd_remains < 0.5 and gcd_remains < 0.5 then
    if usable and enabled and cooldown_remains < 0.5 then
    if range_check then
    if IsSpellInRange(tostring(spell), "target") then
    return true
    else
    return false
    end
    elseif aoe_check then
    if range_counter >= aoe_check then
    return true
    else
    return false
    end
    elseif range_check and aoe_check then
    return 'Input range check or aoe check, not both'
    elseif not range_check and not aoe_check then
    return true
    end
    elseif not enabled then
    return 'Spell not learned'
    else
    return false
    end
    end


local function APL()

    inRange5 = RangeCount("Rend")
    inRange25 = RangeCount("Charge")

    targetRange5 = TargetInRange("Rend")
    targetRange25 = TargetInRange("Charge")
    local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Rend","target","PLAYER|HARMFUL")

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
		
    if IsReady("Bloodrage") and not Player:Buff(S.Bloodrage) and targetRange25 and not Player:Buff(S.Enrage) and Player:Rage()<25 and RubimRH.CDsON() then
		return S.Bloodrage:Cast()
	end

	if not IsCurrentSpell(6603) and HL.CombatTime()>1 and targetRange5 then
		return I.autoattack:ID()
	end
    
    if IsReady('Raging Blow') and targetRange5 then
        return S.ragingblow:Cast()
    end

    if IsReady("Overpower") and targetRange5 then
        return S.Overpower:Cast()
    end	

	if IsReady("Sunder Armor") and targetRange5 and TargetTTD()>60 and TargetTTD()<1000 and Target:DebuffStack(S.SunderArmor)<5 then
        return S.SunderArmor:Cast()
    end	


    if IsReady('Rend')  and targetRange5 and expirationTime<3 and TargetTTD()>15 then
        return S.Rend1:Cast()
    end	

    if (Player:Rage()>=80 or Player:Buff(S.Enrage) or Player:Buff(S.Bloodrage) or UnitLevel('player')<20) and targetRange5 then
	
        if IsReady("Execute") and Target:HealthPercentage()<=20 then
            return S.Execute:Cast()
        end

    	if IsReady("Cleave") and inRange5>=2 then
        return S.Cleave:Cast()
        end

        if IsReady("Quick Strike") and (inRange5 == 1 or not RubimRH.AOEON()) then
        return S.quickStrike:Cast()
        end

        if IsReady('Heroic Strike') and (inRange5 == 1 or not RubimRH.AOEON()) then
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

if S.Charge:CanCast() and targetRange25 then
    return S.Charge:Cast()
end




return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end
	
return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end

RubimRH.Rotation.SetAPL(1, APL);
