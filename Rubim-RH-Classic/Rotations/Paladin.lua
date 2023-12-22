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


RubimRH.Spell[2] = {
	AutoAttack = Spell(6603),
		Default = Spell(1),
		DevotionAura = Spell(465),
		HolyLight = Spell(639),
        Purify = Spell(1152),
        
SealoftheCrusader = Spell(21082),
FrostRA = Spell(27152),
FireRA = Spell(27153),
Consecration = Spell(27173),
ArcaneTorrent = Spell(28730),
RighteousFury = Spell(25780),
SealofCommand = Spell(20375),
SealofRighteousness = Spell(21084),
Exorcism = Spell(27138),
Judgement = Spell(20271),
BlessingofMight = Spell(19740),
DivineProtection = Spell(498),
BlessingofProtection = Spell(1022),
HammerofJustice = Spell(853),
Forbearance = Spell(25771),
LayonHands = Spell(633),
RetributionAura = Spell(10301),
BlessingofFreedom = Spell(1044),
FlashofLight = Spell(27137),
ConcentrationAura = Spell(19746),
BlessingofKings = Spell(20217),
SealofLight = Spell(20165),	
BlessingofSalvation = Spell(1038),
DivineIntervention = Spell(19752),
DivineShield = Spell(642),
SealofJustice = Spell(20164),
HolyShield = Spell(20928),
SealofWisdom = Spell(20166),
SealofWisdomDebuff = Spell(20355),
SanctityAura = Spell(20218),
BlessingofWisdom = Spell(19742),
HammerofWrath = Spell(27180),
Repentance = Spell(20066),
BlessingofSacrifice = Spell(27148),
CrusaderStrike = Spell(20594),
HolyWrath = Spell(27139),
GreaterBlessingofWisdom = Spell(25894),
GreaterBlessingofMight = Spell(27141),
trinket = Spell(28880),
AvengingWrath = Spell(31884),
DivineStorm = Spell(5502),--sense undead
AvengersShield = Spell(19898),-- frost resist aura
BlessingofSanctuary = Spell(20914),
GreaterBlessingofKings = Spell(25898),
RighteousDefense = Spell(31789),
CrusaderAura = Spell(32223),
JoW = Spell(53408),
SealofBlood = Spell(31892),
-- DarkShell = Spell(32358),--pandemonius
-- StopAttack = Spell(20594),
SealofCorruption = Spell(348704),
thyartiswar = Spell(59578),
TurnEvil = Spell(10326),
JoJ = Spell(53407),
HammeroftheRighteous = Spell(53595),
HammeroftheRighteousz= Spell(27151), -- seal of the crusader
Cleanse = Spell(4987),
ShieldofRighteousness = Spell(53600),
};

local S = RubimRH.Spell[2]

if not Item.Paladin then
    Item.Paladin = {}
end
Item.Paladin.Protection = {

	trinket = Item(28288, { 13, 14 }),
	trinket2 = Item(25628, { 13, 14 }),
autoattack = Item(135274, { 13, 14 }),
};
local I = Item.Paladin.Protection;




local function IsReady(spell, range_check, aoe_check)
    local start, duration, enabled = GetSpellCooldown(tostring(spell))
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
    else
        return false
    end
end





local initialTotalMaxHealth = 0
local combatStartTime = 0
local inCombat = false

local function getTotalHealthOfCombatMobs()
    local totalMaxHealth = 0
    local totalCurrentHealth = 0

    for i = 1, 40 do
        local unitID = "nameplate" .. i
        if UnitExists(unitID) and UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) then
            totalMaxHealth = totalMaxHealth + UnitHealthMax(unitID)
            totalCurrentHealth = totalCurrentHealth + UnitHealth(unitID)
        end
    end

    return totalMaxHealth, totalCurrentHealth
end

-- Event Frame for tracking combat state
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- Player enters combat
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- Player leaves combat

eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        combatStartTime = GetTime()
        initialTotalMaxHealth, _ = getTotalHealthOfCombatMobs()
    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
    end
end)

local function getCurrentDPS()
    if inCombat and combatStartTime > 0 then
        local totalMaxHealth, totalCurrentHealth = getTotalHealthOfCombatMobs()
        if totalMaxHealth > initialTotalMaxHealth then
            initialTotalMaxHealth = totalMaxHealth
        end

        local totalDamageDone = initialTotalMaxHealth - totalCurrentHealth
        local combatDuration = GetTime() - combatStartTime
        return math.max(0, totalDamageDone / combatDuration)
    else
        return 0
    end
end



local function aoeTTD()
    local currentDPS = getCurrentDPS()
    local totalCurrentHealth = select(2, getTotalHealthOfCombatMobs())

    if currentDPS and currentDPS > 0 then
        local TTD = totalCurrentHealth / currentDPS
        return TTD
    else
       return 8888
    end
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
	-- inRange5 = RangeCount("Crusader Strike")
    inRange10 = RangeCount("Judgement")
    targetRange10 = TargetInRange("Judgement")
	-- targetRange5 = TargetInRange("Attack")

-- print(IsActionInRange(62) )	
local inRange25 = 0
for i = 1, 40 do
    if UnitExists('nameplate' .. i)  then
        inRange25 = inRange25 + 1
    end
end

if inRange10==0 and  not AuraUtil.FindAuraByName("Forbearance","player","PLAYER|HARMFUL") 
and (RubimRH.QueuedSpell():ID() == S.BlessingofProtection:ID() and S.BlessingofProtection:CooldownRemains()>Player:GCD() 
or RubimRH.QueuedSpell():ID() == S.DivineProtection:ID() and S.DivineProtection:CooldownRemains()>Player:GCD()) then
    RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.HammerofJustice:ID() and not targetRange10 then
    RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
end

if RubimRH.QueuedSpell():ID() == S.HolyLight:ID() and Player:MovingFor()>0.3 then
    RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
end

 	if RubimRH.QueuedSpell():IsReadyQueue() then
        return RubimRH.QueuedSpell():Cast()
	end
	
	if Player:IsCasting() or Player:IsChanneling() then
		return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
	elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player")  then
		return "Interface\\Addons\\Rubim-RH-Classic\\Media\\prot.tga", false
	end 
	

	-- print(IsReady("Devotion Aura") )

-- -- -- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
    
    
    if IsReady("Righteous Fury") and not AuraUtil.FindAuraByName("Righteous Fury", "player") and IsReady("Avenger's Shield") then
        return S.RighteousFury:Cast()
    end
    if Player:HealthPercentage()<20 and IsReady("Lay on Hands") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
    return S.LayonHands:Cast()
   end
   
    if IsReady("Blessing of Wisdom") and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player")  and Player:IsMoving() and not  AuraUtil.FindAuraByName("Blessing of Protection", "player") then
        return S.BlessingofWisdom:Cast()
    end
    if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Devotion Aura", "player") then
        return S.DevotionAura:Cast()
    end
    



    if not IsCurrentSpell(6603) and targetRange10 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        return I.autoattack:ID()
        end


        if IsReady("Seal of Righteousness")  and (Player:IsMoving() or Player:AffectingCombat()) and not AuraUtil.FindAuraByName("Seal of Righteousness", "player")  and (Target:Exists() or inRange25>=1) and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.SealofRighteousness:Cast()
        end

        if IsReady("Judgement") and AuraUtil.FindAuraByName("Seal of Righteousness", "player") and targetRange10 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.Judgement:Cast()
        end

    
        if IsReady("Avenger's Shield") and IsActionInRange(62) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.AvengersShield:Cast()
        end


        if IsReady("Crusader Strike") and IsActionInRange(61) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not S.Judgement:CooldownUp() then
            return S.CrusaderStrike:Cast()
        end
    


        if IsReady("Divine Storm") and IsActionInRange(61) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.DivineStorm:Cast()
        end
        if IsReady("Seal of Command") and not Player:Buff(S.SealofCommand) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return S.SealofCommand:Cast()
        end












	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\prot.tga", false
end



	-- In combat
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
       
        if IsReady("Righteous Fury") and not AuraUtil.FindAuraByName("Righteous Fury", "player") and IsReady("Avenger's Shield") then
            return S.RighteousFury:Cast()
        end
        if Player:HealthPercentage()<20 and IsReady("Lay on Hands") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
        return S.LayonHands:Cast()
       end
       
        if IsReady("Blessing of Wisdom") and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player")  and Player:IsMoving() and not  AuraUtil.FindAuraByName("Blessing of Protection", "player") then
            return S.BlessingofWisdom:Cast()
        end
        if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Devotion Aura", "player") then
            return S.DevotionAura:Cast()
        end
        
    
    
    
        if not IsCurrentSpell(6603) and targetRange10 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            return I.autoattack:ID()
            end
    
    
            if IsReady("Seal of Righteousness")  and (Player:IsMoving() or Player:AffectingCombat()) and not AuraUtil.FindAuraByName("Seal of Righteousness", "player")  and (Target:Exists() or inRange25>=1) and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.SealofRighteousness:Cast()
            end
    
            if IsReady("Judgement") and AuraUtil.FindAuraByName("Seal of Righteousness", "player") and targetRange10 and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.Judgement:Cast()
            end
 
        
            if IsReady("Avenger's Shield") and IsActionInRange(62) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.AvengersShield:Cast()
            end
    
    
            if IsReady("Crusader Strike") and IsActionInRange(61) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and not S.Judgement:CooldownUp() then
                return S.CrusaderStrike:Cast()
            end
        
    
    
            if IsReady("Divine Storm") and IsActionInRange(61) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.DivineStorm:Cast()
            end
            if IsReady("Seal of Command") and not Player:Buff(S.SealofCommand) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
                return S.SealofCommand:Cast()
            end
    

    
	




	
return 135328


end
end



RubimRH.Rotation.SetAPL(2, APL);


