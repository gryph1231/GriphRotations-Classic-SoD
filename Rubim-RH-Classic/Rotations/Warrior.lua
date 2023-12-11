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
    ragingblow = Spell(355),--taunt

    Overpower = Spell(7384),
    SunderArmor = Spell(7405),
    Rend = Spell(6547),
    QuickStrike = Spell(429765),
    quickStrike = Spell(20560), --mocking blow
    HeroicStrike = Spell(1608),
    Cleave = Spell(845),
	-- Warstomp = Spell(20549),
	Whirlwind = Spell(1680),
	Bloodthirst = Spell(23881),
	Bloodrage = Spell(2687),
	Execute = Spell(20662),
	Slam = Spell(11605),
	BattleShout = Spell(25289),
	
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

local function APL()

    inRange5 = RangeCount("Heroic Strike")
    inRange25 = RangeCount("Charge")

    targetRange5 = TargetInRange("Heroic Strike")
    targetRange25 = TargetInRange("Charge")

-- 	-- In combat
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	

		
    if S.Bloodrage:CanCast(Player) and not Player:Buff(S.Bloodrage) and targetRange25 and not Player:Buff(S.Enrage) and Player:Rage()<25 and RubimRH.CDsON() then
		return S.Bloodrage:Cast()
	end

	if not IsCurrentSpell(6603) and HL.CombatTime()>1 and targetRange5 then
		return I.autoattack:ID()
	end
    
    if S.RagingBlow:CanCast(Target) and targetRange5 then
        return S.ragingblow:Cast()
    end

    if S.Overpower:CanCast(Target) and targetRange5 then
        return S.Overpower:Cast()
    end	

	if S.SunderArmor:CanCast(Target) and targetRange5 and TargetTTD()>60 and TargetTTD()<1000 and Target:DebuffStack(S.SunderArmor)<5 then
        return S.SunderArmor:Cast()
    end	

	if S.Rend:CanCast()  and targetRange5 and not Target:Debuff(S.Rend) and TargetTTD()>15 then
        return S.Rend:Cast()
    end	

    if (Player:Rage()>=80 or Player:Buff(S.Enrage) or Player:Buff(S.Bloodrage)) and targetRange5 then
	
    	if S.Cleave:CanCast() and inRange5>=2 then
        return S.Cleave:Cast()
        end

        if S.QuickStrike:CanCast() then
        return S.quickStrike:Cast()
        end

        if S.HeroicStrike:CanCast() then
        return S.HeroicStrike:Cast()
        end

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
