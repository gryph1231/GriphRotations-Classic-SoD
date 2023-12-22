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
	HealingTouch = Spell(5188),
	Clearcasting = Spell(16870),
	Prowl = Spell(5215),
	SavageRoar = Spell(407988),
	WildGrowth = Spell(408120),
	WildGrowthz = Spell(18562), --swiftmend
	Starsurge = Spell(417157),
	Starsurgez = Spell(2912), --starfire
	Rip = Spell(1079),
	Powershift = Spell(5225), -- track humanoids
};

local S = RubimRH.Spell[11]

S.Claw.TextureSpellID = { 16827 }
S.SavageRoar.TextureSpellID = { 5209 }

S.Wrath:RegisterInFlight()

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

local function MissingHealth(healthPercent)
	--GetNumGroupMembers()
	if healthPercent then
	check =
	num(IsActionInRange(39,"player") and not AuraUtil.FindAuraByName("Wild Growth","player") and ((UnitHealth("player") / UnitHealthMax("player")) * 100) <= healthPercent) +
	num(IsActionInRange(39,"party1") and not AuraUtil.FindAuraByName("Wild Growth","party1") and ((UnitHealth("party1") / UnitHealthMax("party1")) * 100) <= healthPercent) +
	num(IsActionInRange(39,"party2") and not AuraUtil.FindAuraByName("Wild Growth","party2") and ((UnitHealth("party2") / UnitHealthMax("party2")) * 100) <= healthPercent) +
	num(IsActionInRange(39,"party3") and not AuraUtil.FindAuraByName("Wild Growth","party3") and ((UnitHealth("party3") / UnitHealthMax("party3")) * 100) <= healthPercent) +
	num(IsActionInRange(39,"party4") and not AuraUtil.FindAuraByName("Wild Growth","party4") and ((UnitHealth("party4") / UnitHealthMax("party4")) * 100) <= healthPercent)

	-- num(IsActionInRange(39,"player") and not AuraUtil.FindAuraByName("Wild Growth","player") and ((UnitHealth("player") / UnitHealthMax("player")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid1") and not AuraUtil.FindAuraByName("Wild Growth","raid1") and ((UnitHealth("raid1") / UnitHealthMax("raid1")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid2") and not AuraUtil.FindAuraByName("Wild Growth","raid2") and ((UnitHealth("raid2") / UnitHealthMax("raid2")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid3") and not AuraUtil.FindAuraByName("Wild Growth","raid3") and ((UnitHealth("raid3") / UnitHealthMax("raid3")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid4") and not AuraUtil.FindAuraByName("Wild Growth","raid4") and ((UnitHealth("raid4") / UnitHealthMax("raid4")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid5") and not AuraUtil.FindAuraByName("Wild Growth","raid5") and ((UnitHealth("raid5") / UnitHealthMax("raid5")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid6") and not AuraUtil.FindAuraByName("Wild Growth","raid6") and ((UnitHealth("raid6") / UnitHealthMax("raid6")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid7") and not AuraUtil.FindAuraByName("Wild Growth","raid7") and ((UnitHealth("raid7") / UnitHealthMax("raid7")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid8") and not AuraUtil.FindAuraByName("Wild Growth","raid8") and ((UnitHealth("raid8") / UnitHealthMax("raid8")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid9") and not AuraUtil.FindAuraByName("Wild Growth","raid9") and ((UnitHealth("raid9") / UnitHealthMax("raid9")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid10") and not AuraUtil.FindAuraByName("Wild Growth","raid10") and ((UnitHealth("raid10") / UnitHealthMax("raid10")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid11") and not AuraUtil.FindAuraByName("Wild Growth","raid11") and ((UnitHealth("raid11") / UnitHealthMax("raid11")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid12") and not AuraUtil.FindAuraByName("Wild Growth","raid12") and ((UnitHealth("raid12") / UnitHealthMax("raid12")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid13") and not AuraUtil.FindAuraByName("Wild Growth","raid13") and ((UnitHealth("raid13") / UnitHealthMax("raid13")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid14") and not AuraUtil.FindAuraByName("Wild Growth","raid14") and ((UnitHealth("raid14") / UnitHealthMax("raid14")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid15") and not AuraUtil.FindAuraByName("Wild Growth","raid15") and ((UnitHealth("raid15") / UnitHealthMax("raid15")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid16") and not AuraUtil.FindAuraByName("Wild Growth","raid16") and ((UnitHealth("raid16") / UnitHealthMax("raid16")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid17") and not AuraUtil.FindAuraByName("Wild Growth","raid17") and ((UnitHealth("raid17") / UnitHealthMax("raid17")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid18") and not AuraUtil.FindAuraByName("Wild Growth","raid18") and ((UnitHealth("raid18") / UnitHealthMax("raid18")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid19") and not AuraUtil.FindAuraByName("Wild Growth","raid19") and ((UnitHealth("raid19") / UnitHealthMax("raid19")) * 100) <= healthPercent) +
	-- num(IsActionInRange(39,"raid20") and not AuraUtil.FindAuraByName("Wild Growth","raid20") and ((UnitHealth("raid20") / UnitHealthMax("raid20")) * 100) <= healthPercent)

	else
		check = 0
	end
	
	return check
end

local function APL()
RangeCount()
TargetTTD()
TargetinRange()
MissingHealth()
IsReady()

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif not AuraUtil.FindAuraByName("Cat Form", "player") and (Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") or Player:Buff(S.Prowl)) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end 

if BehindCheckTimer then 
	BehindTimer = GetTime() - BehindCheckTimer
end

if FrontTimer then
	FrontTimer = GetTime() - FrontCheckTimer
end

local Behind = true
local Front = true

if BehindTimer and BehindTimer < Player:GCD() then
	Behind = false
end

if FrontTimer and FrontTimer < Player:GCD() then
	Front = false
end

local _,_,WildGrowthEnabled = GetSpellCooldown("Wild Growth")

local finisher_condition = 
	(Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
	or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
	or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
	or (TargetTTD() < 3 and 
	   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
	or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
	or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
	or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
	or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24)))
	or (Player:ComboPoints() >= 5 and TargetTTD() > 12 and not Target:Debuff(S.Rip))
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not RubimRH.queuedSpell[1]:CanCast() or not RubimRH.queuedSpell[1]:IsAvailable()
or (S.CatForm:ID() == RubimRH.queuedSpell[1]:ID() and Player:Buff(S.CatForm)) then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if RubimRH.QueuedSpell():CanCast() then
	return RubimRH.QueuedSpell():Cast()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() and not Player:Buff(S.CatForm) then
	if RubimRH.InterruptsON() then
		if IsReady('Omen of Clarity') and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
			return S.OmenofClarity:Cast()
		end
		
		if IsReady('Mark of the Wild') and (not Player:Buff(S.MarkoftheWild) or (not AuraUtil.FindAuraByName("Mark of the Wild", "target") and Target:IsAPlayer() and not Player:CanAttack(Target) and Target:Exists() and not Target:IsDeadOrGhost())) and Player:Mana() > 263 + 75 then
			return S.MarkoftheWild:Cast()
		end	
		
		-- if IsReady('Thorns') and not (Player:Buff(S.Thorns) or (not AuraUtil.FindAuraByName("Thorns", "target") and not Player:CanAttack(Target) and Target:Exists() and not Target:IsDeadOrGhost())) and Player:Mana() > 263 + 60 then
			-- return S.Thorns:Cast()
		-- end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if IsReady('Omen of Clarity') and RubimRH.InterruptsON() and (not Player:Buff(S.CatForm) or IsReady('Cat Form')) and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
	return S.OmenofClarity:Cast()
end

if IsReady('Wild Growth') and not AuraUtil.FindAuraByName("Cat Form", "player") and (MissingHealth(85) >= 2 or MissingHealth(90) >= 3 or (MissingHealth(75) >= 1 and MissingHealth(95) >= 2) 
or (Player:Buff(S.Clearcasting) and MissingHealth(99) >= 1)) then
	return S.WildGrowthz:Cast()
end

if Player:CanAttack(Target) and Player:AffectingCombat() and (Target:AffectingCombat() or IsCurrentSpell(6603)) and not Target:IsDeadOrGhost() then 
	if IsReady('Cat Form') and not Player:Buff(S.CatForm) then
		return S.CatForm:Cast()
	end

	if not IsCurrentSpell(6603) and TargetinRange(37) then
		return Item(135274, { 13, 14 }):ID()
	end
	
	if not AuraUtil.FindAuraByName("Cat Form", "player") then
		if IsReady('Starsurge') and TargetinRange(40) and not Player:Buff(S.Clearcasting) then
			return S.Starsurgez:Cast()
		end

		if IsReady('Wrath',true) and RubimRH.CDsON() and (not Player:Buff(S.Clearcasting) or MissingHealth(95) == 0) then
			return S.Wrath:Cast()
		end
	end

	if Player:Buff(S.CatForm) then
		if (Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
		or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
		or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
		or (TargetTTD() < 3 and 
		   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
		or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
		or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
		or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
		or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24))) then
			if IsReady('Savage Roar') then
				return S.SavageRoar:Cast()
			elseif IsReady('Cat Form') and not Player:Buff(S.Clearcasting) and TargetinRange(37) and Player:Energy() < 5 and RubimRH.CDsON() then
				return S.Powershift:Cast()
			end
		end


		if Player:ComboPoints() >= 5 and TargetTTD() > 12 and not Target:Debuff(S.Rip) then
			if IsReady('Rip',true) then
				return S.Rip:Cast()
			elseif IsReady('Cat Form') and not Player:Buff(S.Clearcasting) and TargetinRange(37) and Player:Energy() < 10 and RubimRH.CDsON() then
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
		elseif IsReady('Cat Form')and not Player:Buff(S.Clearcasting) and not finisher_condition and TargetinRange(37) and Player:Energy() < 20 and RubimRH.CDsON() then
			return S.Powershift:Cast()
		end
		
		if IsReady('Cat Form') and RubimRH.CDsON() and Player:Energy() < 10 then
			return S.Powershift:Cast()
		end
	end
end
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

RubimRH.Rotation.SetAPL(11, APL);
RubimRH.Rotation.SetPvP(11, PvP)
RubimRH.Rotation.SetPASSIVE(11, PASSIVE);