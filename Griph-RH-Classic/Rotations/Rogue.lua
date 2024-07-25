-- Localize Vars
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;
local Pet = Unit.Pet;

-- Define Spells
GriphRH.Spell[11] = { --I replaced [105] with [11]. This is where the class ID goes (11 was holy pally I think)
    WildGrowth = Spell(48438),
    Lifebloom = Spell(33763), --Make this macro /cast [@target,exists][@player]Lifebloom
	Lifebloom_Party1 = Spell(16914), --hurricane
	Lifebloom_Party2 = Spell(2649), --growl					--Unfortunately, there are only so many keybinds so these are tied to the commented spells. Usage example would be keybind cower in ggl to /cast [@party3]Lifebloom
	Lifebloom_Party3 = Spell(16697), --cower
	Lifebloom_Party4 = Spell(6807), --maul
    Efflorescence = Spell(145205),
    Rejuvenation = Spell(774),
    Regrowth = Spell(8936),
    HealingTouch = Spell(5185),
    NaturesSwiftness = Spell(132158),
    Tranquility = Spell(740),
    Barkskin = Spell(22812),
    TreeOfLife = Spell(33891),
    SurvivalInstincts = Spell(61336),
    Nourish = Spell(50464),
    Ironbark = Spell(102342),
    Swiftmend = Spell(18562),
    Innervate = Spell(29166),
    Rebirth = Spell(20484),
    Revitalize = Spell(207640),
};

local S = GriphRH.Spell[11]

if not Item.Druid then
    Item.Druid = {};
end

Item.Druid.Restoration = {
    Potion = Item(169451), -- Example item ID for potion
};
local I = Item.Druid.Restoration;

-- Utility Functions
local function num(val)
    if val then
        return 1
    else
        return 0
    end
end

local function LowestAlly(check,glimmer_check) --This returns the unit guid of the said lowest ally that is lower than check. For example, if you have LowestAlly(75) it returns the lowest ally <= 75%
    for id = 1, 5 do
        if UnitExists("player") and not UnitIsDeadOrGhost("player") then
            if glimmer_check then
                if not AuraUtil.FindAuraByName("Glimmer of Light","player") then
                    player_health = ((UnitHealth("player") / UnitHealthMax("player")) * 100)
                else
                    player_health = 100
                end
            elseif not glimmer_check then
                player_health = ((UnitHealth("player") / UnitHealthMax("player")) * 100)
            end
        else
            player_health = 100
        end

        if IsSpellInRange("Flash of Light","party1") == 1 and UnitExists("party1") and not UnitIsDeadOrGhost("party1") then
            if glimmer_check then
                if not AuraUtil.FindAuraByName("Glimmer of Light","party1") then
                    party1_health = ((UnitHealth("party1") / UnitHealthMax("party1")) * 100)
                else
                    party1_health = 100
                end
            elseif not glimmer_check then
                party1_health = ((UnitHealth("party1") / UnitHealthMax("party1")) * 100)
            end
        else
            party1_health = 100
        end

        if IsSpellInRange("Flash of Light","party2") == 1 and UnitExists("party2") and not UnitIsDeadOrGhost("party2") then
            if glimmer_check then
                if not AuraUtil.FindAuraByName("Glimmer of Light","party2") then
                    party2_health = ((UnitHealth("party2") / UnitHealthMax("party2")) * 100)
                else
                    party2_health = 100
                end
            elseif not glimmer_check then
                party2_health = ((UnitHealth("party2") / UnitHealthMax("party2")) * 100)
            end
        else
            party2_health = 100
        end

        if IsSpellInRange("Flash of Light","party3") == 1 and UnitExists("party3") and not UnitIsDeadOrGhost("party3") then
            if glimmer_check then
                if not AuraUtil.FindAuraByName("Glimmer of Light","party3") then
                    party3_health = ((UnitHealth("party3") / UnitHealthMax("party3")) * 100)
                else
                    party3_health = 100
                end
            elseif not glimmer_check then
                party3_health = ((UnitHealth("party3") / UnitHealthMax("party3")) * 100)
            end
        else
            party3_health = 100
        end

        if IsSpellInRange("Flash of Light","party4") == 1 and UnitExists("party4") and not UnitIsDeadOrGhost("party4") then
            if glimmer_check then
                if not AuraUtil.FindAuraByName("Glimmer of Light","party4") then
                    party4_health = ((UnitHealth("party4") / UnitHealthMax("party4")) * 100)
                else
                    party4_health = 100
                end
            elseif not glimmer_check then
                party4_health = ((UnitHealth("party4") / UnitHealthMax("party4")) * 100)
            end
        else
            party4_health = 100
        end
	end

    if player_health <= party1_health and player_health <= party2_health and player_health <= party3_health and player_health <= party4_health then
        lowest_percent = player_health
        lowest_guid = "player"
    elseif party1_health <= player_health and party1_health <= party2_health and party1_health <= party3_health and party1_health <= party4_health then
        lowest_percent = party1_health
        lowest_guid = "party1"
    elseif party2_health <= player_health and party2_health <= party1_health and party2_health <= party3_health and party2_health <= party4_health then
        lowest_percent = party2_health
        lowest_guid = "party2"
    elseif party3_health <= player_health and party3_health <= party1_health and party3_health <= party2_health and party3_health <= party4_health then
        lowest_percent = party3_health
        lowest_guid = "party3"
    elseif party4_health <= player_health and party4_health <= party1_health and party4_health <= party2_health and party4_health <= party3_health then
        lowest_percent = party4_health
        lowest_guid = "party4"
    end

    if check == "HP" then
        return lowest_percent
    elseif check == "UnitID" then
        return lowest_guid
    end
end

local function GetLowHealthUnit()
    local lowestHealth = 1
    local lowestHealthUnit = nil

    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and UnitHealth(unit) > 0 and not UnitIsDeadOrGhost(unit) then
            local health = UnitHealth(unit) / UnitHealthMax(unit)
            if health < lowestHealth then
                lowestHealth = health
                lowestHealthUnit = unit
            end
        end
    end

    return lowestHealthUnit
end

local function MissingHealth(threshold) --Returns the number of players missing <= a missing % of health
    local missingHealth = 0
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) and UnitHealth(unit) > 0 and not UnitIsDeadOrGhost(unit) then
            if (UnitHealth(unit) / UnitHealthMax(unit)) * 100 <= threshold then
                missingHealth = missingHealth + 1
			end
        end
    end
    return missingHealth
end

-- Action Priority List (APL)
local function APL() --Everything inside this function is where the rotation should be written
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then --This returns a channeling icon when your character is casting so it doesnt get interrupted
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or (AuraUtil.FindAuraByName("Stealth", "player") and S.Pull:ID() ~= GriphRH.queuedSpell[1]:ID()) or AuraUtil.FindAuraByName("Food", "player") 
or AuraUtil.FindAuraByName("Food & Drink", "player") or AuraUtil.FindAuraByName('Gouge','target') or AuraUtil.FindAuraByName('Blind','target') then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if GriphRH.queuedSpell[1]:CooldownRemains() > 2 or not Player:AffectingCombat() then --This clears the spell queue
	GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
end

if S.Regrowth:ID() == GriphRH.queuedSpell[1]:ID() then	--This is an example of a regrowth spell queue. Below is the in game macro. Remember that it needs cleared or it will spam. Above you can see that it will clear if cd remains > 2 or not affecting combat. If the spell doesnt have a cd then you might add to clear if the target or player has regrowth
	return S.Regrowth:Cast()							--#showtooltip Regrowth
end														--/run GriphRH.queuedSpell ={ GriphRH.Spell[11].Regrowth, 0 }

--Be sure to add the spell (Regrowth = Spell(8936),) under GriphRH.Spell[11] in Modules > Spells for each that you want to queue
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Cooldowns--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:AffectingCombat() and GriphRH.CDsON() then --I added a cooldowns toggle which can be found in the keybinds
	if IsReady('Tree of Life') and MissingHealth(50) >= 3 then
		return S.TreeOfLife:Cast()
	end

	if IsReady('Barkskin') and Player:HealthPercentage() < 50 then
		return S.Barkskin:Cast()
	end

	if IsReady('Ironbark') and not AuraUtil.FindAuraByName("Ironbark", "player") then
		return S.Ironbark:Cast()
	end

	if IsReady('Survival Instincts') and Player:HealthPercentage() < 30 then
		return S.SurvivalInstincts:Cast()
	end

	if IsReady('Innervate') and Player:ManaPercentage() < 30 then
		return S.Innervate:Cast()
	end

	if I.Potion:IsReady() and Player:HealthPercentage() < 20 then
		return I.Potion:Cast()
	end
end

if GriphRH.InterruptsON() then 
	if IsReady('Rebirth') and UnitIsDeadOrGhost('target') then
		return S.Rebirth:Cast()
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() then

end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation----------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:AffectingCombat() then --This is the condition that fires the main rotation. I simply added that if you're affecting combat to start.
    if S.WildGrowth:IsReady() and MissingHealth(85) >= 2 then
        return S.WildGrowth:Cast()
    end

	if IsReady('Lifebloom') and IsUsableSpell("Lifebloom") then
		if Target:HealthPercentage() <= 80 then				   --Checks your target first as for raid healing youll have to manually target with the single target heals
			return S.Lifebloom:Cast()
		elseif LowestAlly("HP") <= 80 then
			if IsSpellInRange("Lifebloom",LowestAlly("UnitID")) == 1 then
				if LowestAlly("UnitID") == "player" then
					return S.Lifebloom_Player:Cast()		
				elseif LowestAlly("UnitID") == "party1" then	
					return S.Lifebloom_Party1:Cast()				
				elseif LowestAlly("UnitID") == "party2" then			
					return S.Lifebloom_Party2:Cast()			--Every one of these is a different keybind, so Lifebloom_Player is an in game macro for /cast [@player]Lifebloom etc. 
				elseif LowestAlly("UnitID") == "party3" then	--Use whatever icons you can find to define them up top. I defined these ones so you can see how it's done
					return S.Lifebloom_Party3:Cast()				
				elseif LowestAlly("UnitID") == "party4" then	
					return S.Lifebloom_Party4:Cast()		
				end
			end
		end
	end
	
    if S.Efflorescence:IsReady() and MissingHealth(85) >= 3 then
        return S.Efflorescence:Cast()
    end

	if IsReady('Rejuvenation') and IsUsableSpell("Rejuvenation") then
		if Target:HealthPercentage() <= 80 then					
			return S.Rejuvenation:Cast()
		elseif LowestAlly("HP") <= 80 and GriphRH.AoEON() then
			if IsSpellInRange("Rejuvenation",LowestAlly("UnitID")) == 1 then
				if LowestAlly("UnitID") == "player" then
					return S.Rejuvenation:Cast()		
				elseif LowestAlly("UnitID") == "party1" then	
					return S.Rejuvenation_Party1:Cast()				
				elseif LowestAlly("UnitID") == "party2" then	
					return S.Rejuvenation_Party2:Cast()			--Same deal as the Lifebloom, except youll have to define Rejuvenation_Player, Rejuvenation_Party1, Rejuvenation_Party2, etc
				elseif LowestAlly("UnitID") == "party3" then	--up top similar to how Lifebloom is
					return S.Rejuvenation_Party3:Cast()				
				elseif LowestAlly("UnitID") == "party4" then	
					return S.Rejuvenation_Party4:Cast()		
				end
			end
		end
	end

    if IsReady('Regrowth') and Target:HealthPercentage() <= 100 then --Here is an example of how it would be done if you want to do the targeting yourself
        return S.Regrowth:Cast()
    end

    -- if S.Regrowth:IsReady() and Unit(unit):HealthPercentage() <= 60 then
    --     return S.Regrowth:Cast()
    -- end

    -- if S.NaturesSwiftness:IsReady() and Unit(unit):HealthPercentage() <= 40 then
    --     return S.NaturesSwiftness:Cast()
    -- end

    -- if S.HealingTouch:IsReady() and Unit(unit):HealthPercentage() <= 40 then
    --     return S.HealingTouch:Cast()
    -- end																			--Here is the remainder of what you had. Notice I used IsReady('spell') instead which is what we use for classic instead (make sure the ability is somewhere on your bars for the rangecheck)

    -- if S.Swiftmend:IsReady() and Unit(unit):HealthPercentage() <= 50 then
    --     return S.Swiftmend:Cast()
    -- end

    -- if S.Tranquility:IsReady() and MissingHealth(50) >= 3 then
    --     return S.Tranquility:Cast()
    -- end

    -- if S.Ironbark:IsReady() and Unit(unit):HealthPercentage() <= 30 then
    --     return S.Ironbark:Cast()
    -- end
end
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(11, APL);