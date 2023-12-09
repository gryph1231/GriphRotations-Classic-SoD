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

    Barkskin = {
        -- Only one rank
        Spell(22812)
    },
    EntanglingRoots = {
        Rank1 = Spell(339),
        Rank2 = Spell(1062),
        Rank3 = Spell(5195),
        Rank4 = Spell(9852),
        Rank5 = Spell(9853)
    },
    FaerieFire = {
        Rank1 = Spell(770),
        Rank2 = Spell(778),
        Rank3 = Spell(9749),
        Rank4 = Spell(9907)
    },
    Hibernate = {
        Rank1 = Spell(2637),
        Rank2 = Spell(18657),
        Rank3 = Spell(18658)
    },
    Moonfire = {
        Rank1 = Spell(8921),
        Rank2 = Spell(8924),
        Rank3 = Spell(8925),
        Rank4 = Spell(8926)
    },
    Wrath = {
        Rank1 = Spell(5176),
        Rank2 = Spell(5177),
        Rank3 = Spell(5178),
        Rank4 = Spell(5179)
    },
    NaturesGrasp = {
        Rank1 = Spell(16689),
        Rank2 = Spell(16810),
        Rank3 = Spell(16811),
        Rank4 = Spell(16812),
        Rank5 = Spell(16813),
        Rank6 = Spell(17329)
    },
    OmenOfClarity = {
        -- Only one rank
        Spell(16864)
    },
    Thorns = {
        Rank1 = Spell(467),
        Rank2 = Spell(782),
        Rank3 = Spell(1075),
        Rank4 = Spell(8914),
        Rank5 = Spell(9756),
        Rank6 = Spell(9910)
    },
    HealingTouch = {
        Rank1 = Spell(5185),
        Rank2 = Spell(5186),
        Rank3 = Spell(5187),
        Rank4 = Spell(5188),
        Rank5 = Spell(5189),
        Rank6 = Spell(6778),
        Rank7 = Spell(8903),
        Rank8 = Spell(9758),
        Rank9 = Spell(9888),
        Rank10 = Spell(9889),
        Rank11 = Spell(25297)
    },
    Innervate = {
        -- Only one rank
        Spell(29166)
    },
    MarkOfTheWild = {
        Rank1 = Spell(1126),
        Rank2 = Spell(5232),
        Rank3 = Spell(5234),
        Rank4 = Spell(6756),
        Rank5 = Spell(8907),
        Rank6 = Spell(9884),
        Rank7 = Spell(9885)
    },
    Regrowth = {
        Rank1 = Spell(8936),
        Rank2 = Spell(8938),
        Rank3 = Spell(8939),
        Rank4 = Spell(8940),
        Rank5 = Spell(8941),
        Rank6 = Spell(9750),
        Rank7 = Spell(9856),
        Rank8 = Spell(9857),
        Rank9 = Spell(9858)
    },
    Rejuvenation = {
        Rank1 = Spell(774),
        Rank2 = Spell(1058),
        Rank3 = Spell(1430),
        Rank4 = Spell(2090),
        Rank5 = Spell(2091),
        Rank6 = Spell(3627),
        Rank7 = Spell(8910),
        Rank8 = Spell(9839),
        Rank9 = Spell(9840),
        Rank10 = Spell(9841),
        Rank11 = Spell(25299)
    },
    Bash = {
        Rank1 = Spell(5211),
        Rank2 = Spell(6798),
        Rank3 = Spell(8983)
    },
    CatForm = {
        -- Only one rank
        Spell(768)
    },
    ChallengingRoar = {
        -- Only one rank
        Spell(5209)
    },
    Claw = {
        Rank1 = Spell(1082),
        Rank2 = Spell(3029),
        Rank3 = Spell(5201),
        Rank4 = Spell(9849),
        Rank5 = Spell(9850)
    },
    Cower = {
        Rank1 = Spell(8998),
        Rank2 = Spell(9000),
        Rank3 = Spell(9892)
    },
    Dash = {
        Rank1 = Spell(1850),
        Rank2 = Spell(9821)
    },
    DemoralizingRoar = {
        Rank1 = Spell(99),
        Rank2 = Spell(1735),
        Rank3 = Spell(9490),
        Rank4 = Spell(9747),
        Rank5 = Spell(9898)
    },
    BearForm = {
        -- Only one rank
        Spell(5487)
    },
    DireBearForm = {
        -- Only one rank
        Spell(9634)
    },
    Enrage = {
        -- Only one rank
        Spell(5229)
    },
    FaerieFireFeral = {
        Rank1 = Spell(16857),
        Rank2 = Spell(17390),
        Rank3 = Spell(17391),
        Rank4 = Spell(17392)
    },
    FeralCharge = {
        -- Only one rank
        Spell(16979)
    },
    FerociousBite = {
        Rank1 = Spell(22568),
        Rank2 = Spell(22827),
        Rank3 = Spell(22828),
        Rank4 = Spell(22829),
        Rank5 = Spell(31018)
    },
    FrenziedRegeneration = {
        Rank1 = Spell(22842),
        Rank2 = Spell(22895),
        Rank3 = Spell(22896)
    },
    Growl = {
        -- Only one rank
        Spell(6795)
    },
    Maul = {
        Rank1 = Spell(6807),
        Rank2 = Spell(6808),
        Rank3 = Spell(6809),
        Rank4 = Spell(8972),
        Rank5 = Spell(9745),
        Rank6 = Spell(9880),
        Rank7 = Spell(9881)
    },
    Pounce = {
        Rank1 = Spell(9005),
        Rank2 = Spell(9823),
        Rank3 = Spell(9827)
    },
    Prowl = {
        Rank1 = Spell(5215),
        Rank2 = Spell(6783),
        Rank3 = Spell(9913)
    },
    Rake = {
        Rank1 = Spell(1822),
        Rank2 = Spell(1823),
        Rank3 = Spell(1824),
        Rank4 = Spell(9904)
    },
    Ravage = {
        Rank1 = Spell(6785),
        Rank2 = Spell(6787),
        Rank3 = Spell(9866),
        Rank4 = Spell(9867)
    },
    Rip = {
        Rank1 = Spell(1079),
        Rank2 = Spell(9492),
        Rank3 = Spell(9493),
        Rank4 = Spell(9752),
        Rank5 = Spell(9894),
        Rank6 = Spell(9896)
    },
    Shred = {
        Rank1 = Spell(5221),
        Rank2 = Spell(6800),
        Rank3 = Spell(8992),
        Rank4 = Spell(9829),
        Rank5 = Spell(9830)
    },
    Swipe = {
        Rank1 = Spell(769),
        Rank2 = Spell(779),
        Rank3 = Spell(780),
        Rank4 = Spell(9754),
        Rank5 = Spell(9908)
    },
    TigersFury = {
        Rank1 = Spell(5217),
        Rank2 = Spell(6793),
        Rank3 = Spell(9845),
        Rank4 = Spell(9846)
    }
    -- End of spells
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
    inRange5 = RangeCount("Rake")
    inRange5 = RangeCount("Feral Charge")

    targetRange5 = TargetInRange("Rake")
    targetRange25 = TargetInRange("Feral Charge")


        if Player:IsCasting() or Player:IsChanneling() then
            return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
        elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
            return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
        end

    if RubimRH.QueuedSpell():IsReadyQueue() then
       return RubimRH.QueuedSpell():Cast()
   end
   
    -- In combat rotation - 
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
 

        --put in combat rotation in this section
       
        if not IsCurrentSpell(6603)  then
            return Item(135274, { 13, 14 }):ID()
        end
    
        if S.Wrath:CanCast(Target) and not Player:IsMoving() then
            return S.Wrath:Cast()
        end


		-- Health Check for Crowd Control
		if Player:HealthPercentage() < 50 then
			-- Exit form if in Cat or Bear Form
		  
			if Player:Buff(S.CatForm) then
			return S.CatForm:Cast()
			end
			if Player:Buff(S.BearForm) then
			return S.BearForm:Cast()
			end

			-- Primary Crowd Control: Nature's Grasp
			if S.NaturesGrasp:CanCast(Target) then
				return S.NaturesGrasp:Cast()
			end

			-- Secondary Crowd Control: Hibernate or Entangling Roots
			if (UnitCreatureType('target') == "Beast" or UnitCreatureType('target') == "Dragonkin") and S.Hibernate:CanCast() then
				return S.Hibernate:Cast()
			end

			if not UnitDebuff('target','Polymorph') and not UnitDebuff('target','Fear') and not UnitDebuff('target','Horror') and not UnitDebuff('target','Disorient') and not UnitDebuff('target','Banish') and not UnitDebuff('target','Sleep')
			and not UnitDebuff('target','Snare') and not UnitDebuff('target','Entangling Roots') and S.EntanglingRoots:CanCast(Target) then
				return S.EntanglingRoots:Cast()
			end

			if Player:HealthPercentage() < 50 and S.HealingTouch:CanCast() then
				return S.HealingTouch:Cast()
			end

			if Player:HealthPercentage() < 60 and S.Regrowth:CanCast() then
				return S.Regrowth:Cast()
			end

			if S.Rejuvenation:CanCast() and not Player:Buff(S.Rejuvenation) then
				return S.Rejuvenation:Cast()
			end

		end

		-- Health Check for Healing
		if Player:HealthPercentage() < 60 then
			-- Check if in Cat or Bear Form and exit if so
	   
			if Player:Buff(S.CatForm) then
				return S.CatForm:Cast()
				end
				if Player:Buff(S.BearForm) then
				return S.BearForm:Cast()
				end

			-- Cast Healing Touch if Health < 50%
			if Player:HealthPercentage() < 50 and S.HealingTouch:CanCast() then
				return S.HealingTouch:Cast()
			end

			-- Cast Regrowth if Health between 50-60%
			if Player:HealthPercentage() >= 50 and Player:HealthPercentage() <= 60 and S.Regrowth:CanCast() then
				return S.Regrowth:Cast()
			end

		end


		-- Check for multiple enemies: Opt for Bear Form for defense
		if inRange25 > 1 then
			if not Player:InBearForm() and S.BearForm:CanCast() then
				return S.BearForm:Cast()
			end
		

			-- Check for Bear Form specific abilities
			if Player:InBearForm() then
				-- Frenzied Regeneration: Activate when health falls below 25% and you have more than 30 Rage
				if Player:HealthPercentage() < 25 and Player:Rage() > 30 and S.FrenziedRegeneration:CanCast() then
					return S.FrenziedRegeneration:Cast()
				end

				-- Feral Charge: Employ when the target is too far for melee attacks
				if not targetRange5 and targetRange25 and S.FeralCharge:CanCast() then
					return S.FeralCharge:Cast()
				end

				-- Growl: Use to attract enemy attention
				if Target:IsNotTargetingPlayer() and S.Growl:CanCast() then -- Assuming IsNotTargetingPlayer() checks target's focus
					return S.Growl:Cast()
				end

				-- Faerie Fire (Feral): Apply to enemies not currently affected by this debuff
				if not Target:Debuff(S.FaerieFireFeral) and S.FaerieFireFeral:CanCast() then
					return S.FaerieFireFeral:Cast()
				end

				-- Enrage: Activate when Rage is under 15 and health exceeds 80%
				if Player:Rage() < 15 and Player:HealthPercentage() > 80 and S.Enrage:CanCast() then
					return S.Enrage:Cast()
				end

				-- Demoralizing Roar: Apply to enemies not already debuffed by this
				if not Target:Debuff(S.DemoralizingRoar) and S.DemoralizingRoar:CanCast() then
					return S.DemoralizingRoar:Cast()
				end

				-- Maul: Utilize as soon as it becomes available
				if S.Maul:CanCast() then
					return S.Maul:Cast()
				end

				-- Swipe: Use when Rage exceeds 35
				if Player:Rage() > 35 and S.Swipe:CanCast() then
					return S.Swipe:Cast()
				end
			end
		end

		    -- Check for single enemy and DPS purposes: Opt for Cat Form
            if inRange25 == 1 then
                if Player:HealthPercentage() < 60 and not Player:Buff(S.BearForm) and S.BearForm:CanCast() then
                    -- Switch to Bear Form if health is below 60%
                    return S.BearForm:Cast()
                elseif not Player:Buff(S.CatForm) and S.CatForm:CanCast() then
                    -- Switch to Cat Form for DPS
                    return S.CatForm:Cast()
                end
            



                if Player:Buff(S.CatForm) then
                    -- Faerie Fire (Feral): Cast if the target is not debuffed by it
                    if not Target:Debuff(S.FaerieFireFeral) and S.FaerieFireFeral:CanCast() then
                        return S.FaerieFireFeral:Cast()
                    end

                    -- Rake: Use when the target lacks its debuff and your Combo Points are below 5
                    if not Target:Debuff(S.Rake) and Player:ComboPoints() < 5 and S.Rake:CanCast() then
                        return S.Rake:Cast()
                    end

                    -- Shred: Employ if your Combo Points are under 5 or if you have the Clearcasting buff
                    if (Player:ComboPoints() < 5 or Player:Buff(S.Clearcasting)) and S.Shred:CanCast() then
                        return S.Shred:Cast()
                    end

                    -- Claw: Opt for this if Shred is not viable due to positioning or fails for other reasons
                    if S.Claw:CanCast() then 
                        return S.Claw:Cast()
                    end

                    -- Rip: Apply when the target lacks its debuff and you've accumulated 5 Combo Points
                    if not Target:Debuff(S.Rip) and Player:ComboPoints() == 5 and S.Rip:CanCast() then
                        return S.Rip:Cast()
                    end

                    -- Ferocious Bite: Best used when you've reached 5 Combo Points
                    if Player:ComboPoints() == 5 and S.FerociousBite:CanCast() then
                        return S.FerociousBite:Cast()
                    end
                end
            
		

		        if Player:CanAttack(Target) and targetRange5 then
                    -- Form-Specific Rotation
                    if Player:Buff(S.BearForm) then
                    -- Frenzied Regeneration: Activate when health falls below 25% and you have more than 30 Rage
                    if Player:HealthPercentage() < 25 and Player:Rage() > 30 and S.FrenziedRegeneration:CanCast() then
                        return S.FrenziedRegeneration:Cast()
                    end

                    -- Feral Charge: Employ when the target is too far for melee attacks
                    if not targetRange5 and targetRange25 and S.FeralCharge:CanCast() then -- Assuming IsFarAway() checks target distance
                        return S.FeralCharge:Cast()
                    end

                    -- Growl: Use to attract enemy attention
                    if not Player:IsTanking(Target) and S.Growl:CanCast() then -- Assuming IsNotTargetingPlayer() checks target's focus
                        return S.Growl:Cast()
                    end

                    -- Faerie Fire (Feral): Apply to enemies not currently affected by this debuff
                    if not Target:Debuff(S.FaerieFireFeral) and S.FaerieFireFeral:CanCast() then
                        return S.FaerieFireFeral:Cast()
                    end

                    -- Enrage: Activate when Rage is under 15 and health exceeds 80%
                    if Player:Rage() < 15 and Player:HealthPercentage() > 80 and S.Enrage:CanCast() then
                        return S.Enrage:Cast()
                    end

                    -- Demoralizing Roar: Apply to enemies not already debuffed by this
                    if not Target:Debuff(S.DemoralizingRoar) and S.DemoralizingRoar:CanCast() then
                        return S.DemoralizingRoar:Cast()
                    end

                    -- Maul: Utilize as soon as it becomes available
                    if S.Maul:CanCast() then
                        return S.Maul:Cast()
                    end

                    -- Swipe: Use when Rage exceeds 35
                    if Player:Rage() > 35 and S.Swipe:CanCast() then
                        return S.Swipe:Cast()
                    end

		        end

			    if Player:Buff(S.CatForm) then
                    -- Faerie Fire (Feral): Cast if the target is not debuffed by it
                    if not Target:Debuff(S.FaerieFireFeral) and S.FaerieFireFeral:CanCast() then
                        return S.FaerieFireFeral:Cast()
                    end

                    -- Rake: Use when the target lacks its debuff and your Combo Points are below 5
                    if not Target:Debuff(S.Rake) and Player:ComboPoints() < 5 and S.Rake:CanCast() then
                        return S.Rake:Cast()
                    end

                    -- Shred: Employ if your Combo Points are under 5 or if you have the Clearcasting buff
                    if (Player:ComboPoints() < 5 or Player:Buff(S.Clearcasting)) and S.Shred:CanCast() then
                        return S.Shred:Cast()
                    end

                    -- Claw: Opt for this if Shred is not viable due to positioning or fails for other reasons
                    if S.Claw:CanCast() then 
                        return S.Claw:Cast()
                    end

                    -- Rip: Apply when the target lacks its debuff and you've accumulated 5 Combo Points
                    if not Target:Debuff(S.Rip) and Player:ComboPoints() == 5 and S.Rip:CanCast() then
                        return S.Rip:Cast()
                    end

                    -- Ferocious Bite: Best used when you've reached 5 Combo Points
                    if Player:ComboPoints() == 5 and S.FerociousBite:CanCast() then
                        return S.FerociousBite:Cast()
                    end

		        end
            end
    
        end
    end

    -- Out of combat rotation - heals,buffs, etc. 
    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then

    --Put out of combat rotation - heals,buffs, etc. 

    if Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 
         if not IsCurrentSpell(6603) and targetRange5 then
             return Item(135274, { 13, 14 }):ID()
         end
    
    -- Buff: Mark of the Wild
    if S.MarkOfTheWild:IsReady() and not Player:Buff(S.MarkOfTheWild) then
        return S.MarkOfTheWild:Cast()
    end

    -- Buff: Thorns
    if S.Thorns:IsReady() and not Player:Buff(S.Thorns) then
        return S.Thorns:Cast()
    end

    -- Buff: Omen of Clarity
    if S.OmenOfClarity:IsReady() and not Player:Buff(S.OmenOfClarity) then
        return S.OmenOfClarity:Cast()
    end
    end








    

    return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
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