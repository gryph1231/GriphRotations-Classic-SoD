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
local Pet = Unit.Pet;

RubimRH.Spell[11] = {
	Wrath = Spell(5177),
	CatForm = Spell(768),
	BearForm = Spell(5487),
	Mangle = Spell(407993),
	Claw = Spell(1082),
	MarkoftheWild = Spell(6756),
	Thorns = Spell(782),
	OmenofClarity = Spell(16864),
	Shred = Spell(5221),
	Clearcasting = Spell(16870),
	Prowl = Spell(5215),
	SavageRoar = Spell(407988),
	Rip = Spell(1079),
	Powershift = Spell(5225), -- track humanoids
};

local S = RubimRH.Spell[11]

S.Claw.TextureSpellID = { 16827 }
S.SavageRoar.TextureSpellID = { 5209 }

-- if not Item.Druid then
    -- Item.Druid = {}
-- end

-- Item.Druid.Feral = {
	-- autoattack = Item(135274, { 13, 14 }),
	-- trinket = Item(28288, { 13, 14 }),
	-- trinket2 = Item(25628, { 13, 14 }),
-- };
-- local I = Item.Druid.Feral;

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

local function RangeCount(range_check)
local range_counter = 0
    
	if range_check then
		for i=1,40 do
			local unitID = "nameplate" .. i
			if UnitExists("nameplate"..i) then           
				local nameplate_guid = UnitGUID("nameplate"..i) 
				local npc_id = select(6, strsplit("-",nameplate_guid))
				if npc_id ~='120651' and npc_id ~='161895' then
					if UnitCanAttack("player",unitID) and IsActionInRange(range_check,unitID) and UnitHealthMax(unitID) > 5
					and UnitName(unitID) ~= "Incorporeal Being" then
						range_counter = range_counter + 1
					end                    
				end
			end
		end
	else
		range_counter = 0
	end
    
    return range_counter
end

local function CleaveCount()
local cleave_counter = 0
     
        for i=1,40 do
			local unitID = "nameplate" .. i
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if UnitCanAttack("player",unitID) and IsActionInRange(37,unitID) and UnitHealthMax(unitID) > 5
					and UnitName(unitID) ~= "Incorporeal Being"	then
                        cleave_counter = cleave_counter + 1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function TargetinRange(range_check)
	if range_check then
		if IsActionInRange(range_check,"target") then
			return true
		else
			return false
		end
	else
		return false	
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
			if IsSpellInRange(spell,"target") == 1 then 
				return true
			else
				return false
			end
		elseif aoe_check and not range_check then
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

if not behindCheck then
    behindCheck = CreateFrame("Frame")
end

local BehindCheckTimer = 0
local FrontCheckTimer = 0

local frame = behindCheck
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:SetScript("OnEvent", function(self,event,errorType,message)
	if message == 'You must be behind your target' then
		BehindCheckTimer = GetTime()
	elseif message == 'You must be in front of your target' then
		FrontCheckTimer = GetTime()
	end	
end)


local function APL()
RangeCount()
TargetTTD()
TargetinRange()
IsReady()
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") or Player:Buff(S.Prowl) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end 

local BehindTimer = GetTime() - BehindCheckTimer
local FrontTimer = GetTime() - FrontCheckTimer
local Behind
local Front

if BehindTimer < Player:GCD() then
	Behind = false
end

if FrontTimer < Player:GCD() then
	Front = false
end

local finisher_condition = 
	(Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
	or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
	or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
	or (TargetTTD() < 2 and 
	   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
	or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
	or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
	or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
	or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24)))
	or (Player:ComboPoints() >= 5 and TargetTTD() > 12 and not Target:Debuff(S.Rip))
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not RubimRH.queuedSpell[1]:CanCast() or not RubimRH.queuedSpell[1]:IsAvailable() then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if RubimRH.QueuedSpell():CanCast() then
	return RubimRH.QueuedSpell():Cast()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() and (not Player:Buff(S.CatForm) or IsReady('Cat Form')) then
	if RubimRH.InterruptsON() then
		if IsReady('Omen of Clarity') and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
			return S.OmenofClarity:Cast()
		end
		
		if IsReady('Mark of the Wild') and not Player:Buff(S.MarkoftheWild) and Player:Mana() > 263 + 75 then
			return S.MarkoftheWild:Cast()
		end	
		
		-- if IsReady('Thorns') and not Player:Buff(S.Thorns) and Player:Mana() > 263 + 60 then
			-- return S.Thorns:Cast()
		-- end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
	if IsReady('Omen of Clarity') and RubimRH.InterruptsON() and (not Player:Buff(S.CatForm) or IsReady('Cat Form')) 
	and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
		return S.OmenofClarity:Cast()
	end

if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603)) and not Target:IsDeadOrGhost() then 
	if IsReady('Cat Form') and not Player:Buff(S.CatForm) then
		return S.CatForm:Cast()
	end

	if not IsCurrentSpell(6603) and TargetinRange(37) then
		return Item(135274, { 13, 14 }):ID()
	end

	if Player:Buff(S.CatForm)then
		if (Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
		or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
		or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
		or (TargetTTD() < 2 and 
		   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
		or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
		or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
		or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
		or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24))) then
			if IsReady('Savage Roar') then
				return S.SavageRoar:Cast()
			elseif IsReady('Cat Form') and TargetinRange(37) and Player:Energy() < 5 and RubimRH.CDsON() then
				return S.Powershift:Cast()
			end
		end

		if Player:ComboPoints() >= 5 and TargetTTD() > 12 and not Target:Debuff(S.Rip) then
			if IsReady('Rip',true) then
				return S.Rip:Cast()
			elseif IsReady('Cat Form') and TargetinRange(37) and Player:Energy() < 10 and RubimRH.CDsON() then
				return S.Powershift:Cast()
			end
		end
		
		if Player:Buff(S.Clearcasting) then
			if IsReady('Shred',true) and Behind ~= false then
				return S.Shred:Cast()
			end
			
			if IsReady('Claw',true) then
				return S.Claw:Cast()
			end
		end
		
		if IsReady('Claw',true) then
			return S.Claw:Cast()
		elseif IsReady('Cat Form') and not finisher_condition and TargetinRange(37) and Player:Energy() < 20 and RubimRH.CDsON() then
			return S.Powershift:Cast()
		end
		
		-- if IsReady('Cat Form') and RubimRH.CDsON() and Player:Energy() < 10 then
			-- return S.Powershift:Cast()
		-- end
	end
end

	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

RubimRH.Rotation.SetAPL(11, APL);
RubimRH.Rotation.SetPvP(11, PvP)
RubimRH.Rotation.SetPASSIVE(11, PASSIVE);