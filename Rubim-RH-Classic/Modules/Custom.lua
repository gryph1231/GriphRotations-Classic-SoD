function table.removeKey(t, k)
    local i = 0
    local keys, values = {}, {}
    for k, v in pairs(t) do
        i = i + 1
        keys[i] = k
        values[i] = v
    end

    while i > 0 do
        if keys[i] == k then
            table.remove(keys, i)
            table.remove(values, i)
            break
        end
        i = i - 1
    end

    local a = {}
    for i = 1, #keys do
        a[keys[i]] = values[i]
    end

    return a
end

local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;

--- ============================   CUSTOM   ============================
local function round2(num, idp)
    mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function ttd(unit)
    unit = unit or "target";
    if thpcurr == nil then
        thpcurr = 0
    end
    if thpstart == nil then
        thpstart = 0
    end
    if timestart == nil then
        timestart = 0
    end
    if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
        if currtar ~= UnitGUID(unit) then
            priortar = currtar
            currtar = UnitGUID(unit)
        end
        if thpstart == 0 and timestart == 0 then
            thpstart = UnitHealth(unit)
            timestart = GetTime()
        else
            thpcurr = UnitHealth(unit)
            timecurr = GetTime()
            if thpcurr >= thpstart then
                thpstart = thpcurr
                timeToDie = 999
            else
                if ((timecurr - timestart) == 0) or ((thpstart - thpcurr) == 0) then
                    timeToDie = 999
                else
                    timeToDie = round2(thpcurr / ((thpstart - thpcurr) / (timecurr - timestart)), 2)
                end
            end
        end
    elseif not UnitExists(unit) or currtar ~= UnitGUID(unit) then
        currtar = 0
        priortar = 0
        thpstart = 0
        timestart = 0
        timeToDie = 9999999999999999
    end
    if timeToDie == nil then
        return 99999999
    else
        return timeToDie
    end
end

local activeUnitPlates = {}
local function AddNameplate(unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    local unitframe = nameplate.UnitFrame

    -- store nameplate and its unitID
    activeUnitPlates[unitframe] = unitID
end

local function RemoveNameplate(unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    local unitframe = nameplate.UnitFrame
    -- recycle the nameplate
    activeUnitPlates[unitframe] = nil
end

RubimRH.Listener:Add('Rubim_Events', 'NAME_PLATE_UNIT_ADDED', function(...)
    local unitID = ...
    --AddNameplate(unitID)
end)

RubimRH.Listener:Add('Rubim_Events', 'NAME_PLATE_UNIT_REMOVED', function(...)
    local unitID = ...
    --RemoveNameplate(unitID)
end)

function DiyingIn()
    HL.GetEnemies(10, true); -- Blood Boil
    totalmobs = 0
    dyingmobs = 0
    for _, CycleUnit in pairs(Cache.Enemies[10]) do
        totalmobs = totalmobs + 1;
        if CycleUnit:TimeToDie() <= 20 then
            dyingmobs = dyingmobs + 1;
        end
    end
    if dyingmobs == 0 then
        return 0
    else
        return totalmobs / dyingmobs
    end
end

function GetTotalMobs()
    local totalmobs = 0
    for reference, unit in pairs(activeUnitPlates) do
        if CheckInteractDistance(unit, 3) then
            totalmobs = totalmobs + 1
        end
    end
    return totalmobs
end

function GetMobsDying()
    local totalmobs = 0
    local dyingmobs = 0
    for reference, unit in pairs(activeUnitPlates) do
        if CheckInteractDistance(unit, 3) then
            totalmobs = totalmobs + 1
            if ttd(unit) <= 6 then
                dyingmobs = dyingmobs + 1
            end
        end
    end

    if totalmobs == 0 then
        return 0
    end

    return (dyingmobs / totalmobs) * 100
end

function GetMobs(spellId)
    local totalmobs = 0
    for reference, unit in pairs(activeUnitPlates) do
        if IsSpellInRange(GetSpellInfo(spellId), unit) then
            totalmobs = totalmobs + 1
        end
    end
    return totalmobs
end

local SpellsInterrupt = {
    194610, 198405, 194657, 199514, 199589, 216197, --Maw of Souls
    0
}

local function ShouldInterrupt()
    local importantCast = false
    local castName, _, _, _, castStartTime, castEndTime, _, _, notInterruptable, spellID = UnitCastingInfo("target")

    if castName == nil then
        local castName, nameSubtext, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo("unit")
    end

    if spellID == nil or notInterruptable == true then
        return false
    end

    for i, v in ipairs(SpellsInterrupt) do
        if spellID == v then
            importantCast = true
            break
        end
    end

    if spellID == nil or castInterruptable == false then
        return false
    end

    if int_smart == false then
        importantCast = false
    end

    if importantCast == false then
        return false
    end

    local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
    local timeLeft = ((GetTime() * 1000 - castEndTime) * -1) / 1000
    local castTime = castEndTime - castStartTime
    local currentPercent = timeSinceStart / castTime * 100000
    local interruptPercent = math.random(10, 30)
    if currentPercent >= interruptPercent then
        return true
    end
    return false
end

local movedTimer = 0
function RubimRH.lastMoved()
    if Player:IsMoving() then
        movedTimer = GetTime()
    end
    return GetTime() - movedTimer
end

local damageAmounts, damageTimestamps = {}, {}
local damageInLast3Seconds = 0
local playerGUID = UnitGUID("player")
local lastmelee = 0


local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
    self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
end)

function f:COMBAT_LOG_EVENT_UNFILTERED(...)
    local timestamp, subevent,_, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
        -- if destGUID ~= playerGUID then
            -- return
        -- end
    local amount = nil

    if subevent == "SWING_DAMAGE" and sourceGUID == playerGUID then
	lastmelee = GetTime()
        amount = select(12, ...)
    elseif subevent == "SWING_MISSED" and sourceGUID == playerGUID  then
	lastmelee = GetTime()
        amount = select(12, ...)
    end

    if amount then

            -- Record new damage at the top of the log:
            tinsert(damageAmounts, 1, amount)
            tinsert(damageTimestamps, 1, timestamp)
            -- Clear out old entries from the bottom, and add up the remaining ones:
            local cutoff = timestamp - 3

            for i = #damageTimestamps, 1, -1 do
                local timestamp = damageTimestamps[i]
                if timestamp < cutoff then
                    damageTimestamps[i] = nil
                    damageAmounts[i] = nil
        -- else
                    -- damageInLast3Seconds = damageInLast3Seconds + damageAmounts[i]
                end
            end
        end

end



function RangeCount(spellName)
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


function RangeCount11()
    local range_counter = 0

  
        for i = 1, 40 do
            local unitID = "nameplate" .. i
            if UnitExists(unitID) then
                local nameplate_guid = UnitGUID(unitID)
                local npc_id = select(6, strsplit("-", nameplate_guid))
                if npc_id ~= '120651' and npc_id ~= '161895' then
                    if UnitCanAttack("player", unitID) and CheckInteractDistance(unitID,2) and UnitHealthMax(unitID) > 5 then
                        range_counter = range_counter + 1
                    end
                end
            end
        end
    

    return range_counter
end
function RangeCount10()
    local range_counter = 0

  
        for i = 1, 40 do
            local unitID = "nameplate" .. i
            if UnitExists(unitID) then
                local nameplate_guid = UnitGUID(unitID)
                local npc_id = select(6, strsplit("-", nameplate_guid))
                if npc_id ~= '120651' and npc_id ~= '161895' then
                    if UnitCanAttack("player", unitID) and CheckInteractDistance(unitID,3) and UnitHealthMax(unitID) > 5 then
                        range_counter = range_counter + 1
                    end
                end
            end
        end
    

    return range_counter
end

 function TargetInRange(spellName)
    if spellName and IsSpellInRange(spellName, "target") == 1 then
        return true
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

function getCurrentDPS()
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



 function aoeTTD()
    local currentDPS = getCurrentDPS()
    local totalCurrentHealth = select(2, getTotalHealthOfCombatMobs())

    if currentDPS and currentDPS > 0 then
        local TTD = totalCurrentHealth / currentDPS
        return TTD
    else
       return 8888
    end
end




 function IsReady(spell, range_check, aoe_check)
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

local lastMoveTime = GetTime()  -- Initialize with the current time

-- Function to get the time since last moved
function TimeSinceLastMoved()
    return GetTime() - lastMoveTime
end

-- Frame to track player movement
local moveFrame = CreateFrame("Frame")
moveFrame:SetScript("OnUpdate", function(self, elapsed)
    local currentSpeed = GetUnitSpeed("player")
    if currentSpeed > 0 then
        -- Update the last move time to the current time if the player is moving
        lastMoveTime = GetTime()
    end
end)


function RubimRH.lasthit()
if not Player:AffectingCombat() then
return 1000000
end
    if lastmelee > 0 then
        return GetTime() - lastmelee
    end
return 1000000

end

-- function RubimRH.lastSwing()
    -- if lastMeleeHit > 0 then
        -- return GetTime() - lastMeleeHit
    -- end
    -- return 0
-- end

function RubimRH.getLastDamage()
    return damageInLast3Seconds
end

function RubimRH.clearLastDamage()
    damageInLast3Seconds = 0
end

function RubimRH.LastDamage()
    local IncomingDPS = (damageInLast3Seconds / UnitHealthMax("player")) * 100
    return (math.floor((IncomingDPS * ((100) + 0.5)) / (100)))
end

function RubimRH.SetFramePos(frame, x, y, w, h)
    local xOffset0 = 1
    if frame == nil then
        return
    end
    if GetCVar("gxMaximize") == "0" then
        xOffset0 = 0.9411764705882353
    end
    xPixel, yPixel, wPixel, hPixel = x, y, w, h
    xRes, yRes = string.match(({ GetScreenResolutions() })[GetCurrentResolution()], "(%d+)x(%d+)");
    uiscale = UIParent:GetScale();
    XCoord = xPixel * (768.0 / xRes) * GetMonitorAspectRatio() / uiscale / xOffset0
    YCoord = yPixel * (768.0 / yRes) / uiscale;
    Weight = wPixel * (768.0 / xRes) * GetMonitorAspectRatio() / uiscale
    Height = hPixel * (768.0 / yRes) / uiscale;
    if x and y then
        frame:SetPoint("TOPLEFT", XCoord, YCoord)
    end
    if w and h then
        frame:SetSize(Weight, Height)
    end
end

function RubimRH.ColorOnOff(boolean)
    if boolean == true then
        return "|cFF00FF00"
    else
        return "|cFFFF0000"
    end
end

-- Target Valid
function RubimRH.TargetIsValid(override)
    local override = override or false

    local unitReaction = UnitReaction("Player", "Target") or 0
    if not override and unitReaction >= 4 and not Player:AffectingCombat() then
        return false
    end

    local isValid = false

    if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
        isValid = true
    end

    return isValid
end

-- will be replaced
function RubimRH.azerite(slot, azeriteID)
    local IsArmor = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(ItemLocation:CreateFromEquipmentSlot(slot));
    if IsArmor == true then
        local azeriteLearned = C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(slot), azeriteID);
        if azeriteLearned == true then
            return true
        else
            return false
        end
    end
    return false
end

function RubimRH.DebugPrint(Text)
    if RubimRH.db.profile.mainOption.debug == true then
        print("DEBUG: " .. Text)
    end
end


--NeP RIP
RubimRH.Buttons = {}

local nBars = {
    "ActionButton",
    "MultiBarBottomRightButton",
    "MultiBarBottomLeftButton",
    "MultiBarRightButton",
    "MultiBarLeftButton"
}

local lastSpell = 0
local function UpdateButtons()
    lastSpell = 0
    wipe(RubimRH.Buttons)
    for _, group in ipairs(nBars) do
        for i = 1, 12 do
            local button = _G[group .. i]
            if button then
                local actionType, id = _G.GetActionInfo(_G.ActionButton_CalculateAction(button, "LeftButton"))
                if actionType == 'spell' then
                    --local spell = GetSpellInfo(id)
                    local spell = id
                    if spell then
                        RubimRH.Buttons[spell] = button
                        --RubimRH.Buttons[spell].glow = false
                        --RubimRH.Buttons[spell].text = RubimRH.Buttons[spell]:CreateFontString('ButtonText')
                        --RubimRH.Buttons[spell].text:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
                        --RubimRH.Buttons[spell].text:SetPoint("CENTER", RubimRH.Buttons[spell])
                        --RubimRH.Buttons[spell].GlowTexture = RubimRH.Buttons[spell]:CreateTexture(nil, "TOOLTIP")
                        --RubimRH.Buttons[spell].GlowTexture:SetScale(0.8)
                        --RubimRH.Buttons[spell].GlowTexture:SetAlpha(0.5)
                        --RubimRH.Buttons[spell].GlowTexture:SetPoint("CENTER")
                        --RubimRH.Buttons[spell] = button:GetName()
                    end
                end
            end
        end
    end

end

function RubimRH.HideButtonGlow(spellID)
    local isString = (type(spellID) == "string")

    if isString and spellID == "All" then
        for i, button in pairs(RubimRH.Buttons) do
            --if button.glow == true then
                button.glow = false
                button.GlowTexture:SetTexture(nil)
                --button.text:SetText("")
                --button.NormalTexture:SetColorTexture(0, 0, 0, 0)
                --ActionButton_HideOverlayGlow(button)
            --end
        end
        return
    end

    if RubimRH.Buttons[spellID] ~= nil then
        --RubimRH.Buttons[spellID].GlowTexture:SetTexture(nil)
        --RubimRH.Buttons[spellID].glow = false
        --RubimRH.Buttons[spellID].text:SetText("")
        --RubimRH.Buttons[spellID].NormalTexture:SetColorTexture(0, 0, 0, 0)
        --for i, button in pairs(RubimRH.Buttons) do
        --button.NormalTexture:SetColorTexture(0, 0, 0, 0)
        --ActionButton_HideOverlayGlow(button)
        --end
    end
end

function RubimRH.OLDShowButtonGlow(spellID)
    RubimRH.HideButtonGlow("All")
    if RubimRH.Buttons[spellID] ~= nil then
        if lastSpell > 0 and spellID ~= lastSpell then
            --RubimRH.Buttons[spellID].glow = false
           -- RubimRH.Buttons[spellID].GlowTexture:SetTexture(nil)
            lastSpell = spellID
        end
        --ActionButton_ShowOverlayGlow(RubimRH.Buttons[spellID])
        --RubimRH.Buttons[spellID].text:SetText("|cffff0000=>|r")
        RubimRH.Buttons[spellID].GlowTexture:SetTexture("Interface\\Addons\\Rubim-RH\\Media\\combat.tga")
        RubimRH.Buttons[spellID].glow = true
        lastSpell = spellID
    end
end

function RubimRH.ShowButtonGlowQueue(spellID)
    if RubimRH.Buttons[spellID] ~= nil then
        RubimRH.Buttons[spellID].GlowTexture:SetTexture("Interface\\Addons\\Rubim-RH\\Media\\disarmed.tga")
    end
end

local activeFrame = CreateFrame('Frame', 'ShowIcon', _G.UIParent)
-- activeFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                         -- edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                         -- tile = true, tileSize = 16, edgeSize = 16,
                         -- insets = { left = 4, right = 4, top = 4, bottom = 4 }
-- });


-- activeFrame:SetBackdropColor(0,0,0,0);
activeFrame.texture = activeFrame:CreateTexture()
activeFrame.texture:SetTexture("Interface/Addons/Rubim-RH/Media/combat.tga")
activeFrame.texture:SetPoint("CENTER")
activeFrame:SetFrameStrata('HIGH')
activeFrame:Hide()

local display = CreateFrame('Frame', 'Faceroll_Info', activeFrame)
display:SetClampedToScreen(true)
display:SetSize(0, 0)
display:SetPoint("TOP")
-- display:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                     -- edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                     -- tile = true, tileSize = 16, edgeSize = 16,
                     -- insets = { left = 4, right = 4, top = 4, bottom = 4 }
-- });
-- display:SetBackdropColor(0,0,0,1);
display.text = display:CreateFontString('Nothing')
display.text:SetFont("Fonts\\ARIALN.TTF", 16)
display.text:SetPoint("CENTER", display)

function RubimRH.ShowButtonGlow(spellID)

    if RubimRH.db.profile.mainOption.glowactionbar == false then
        return
    end

    local spellButton = RubimRH.Buttons[spellID]
    if not spellButton then return end
    local bSize = spellButton:GetWidth()
    activeFrame:SetSize(bSize+5, bSize+5)
    --display:SetSize(display.text:GetStringWidth()+20, display.text:GetStringHeight()+20)
    activeFrame.texture:SetSize(activeFrame:GetWidth()-5,activeFrame:GetHeight()-5)
    activeFrame:SetPoint("CENTER", spellButton, "CENTER")
    --display:SetPoint("TOP", spellButton, 0, display.text:GetStringHeight()+20)
    --spell = '|cff'..NeP.Color.."Spell:|r "..spell
    --local isTargeting = '|cff'..NeP.Color..tostring(_G.UnitIsUnit("target", target or 'player'))
    --target = '|cff'..NeP.Color.."\nTarget:|r"..(_G.UnitName(target or 'player') or '')
    --display.text:SetText(spell..target.."("..isTargeting..")")
    activeFrame:Show()
end

function RubimRH.HideButtonGlow()
    activeFrame:Hide()
end

function RubimRH.print(text, color)
    print("|cff828282RRH: |r" .. text)
end


local lastGCDTime = nil
local gcdDuration = 1.5  -- Typical GCD duration, may need adjustment for haste

-- Function to print the remaining GCD
 function GCDRemaining()
    if lastGCDTime then
        local remainingTime = (lastGCDTime + gcdDuration) - GetTime()
        return math.max(0, remainingTime)
    else
        return 0
    end
end

-- Round helper function
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Event Frame to track spell casts and GCD
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

eventFrame:SetScript("OnEvent", function()
    local _, eventType, _, sourceGUID, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
    if eventType == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
        local start, duration = GetSpellCooldown(spellID)
        if start and duration and duration > 0 then
            lastGCDTime = start  -- Record the start time of the GCD
            gcdDuration = duration  -- Update the GCD duration which can change with haste
        end
    end
end)



function SpellRank(spell_name)

    if spell_name then
        local _,_,_,_,_,_,spellID,_ = GetSpellInfo(spell_name)
        
        return spellID
    else
        return 0
    end

end






-- -- Create a frame for event handling
-- local eventFrame = CreateFrame("Frame")

-- -- Register events related to spell casting
-- eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
-- eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
-- eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
-- eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
-- eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

-- -- Variable to hold the name of the currently casting spell
-- local currentlyCasting = false

-- -- Event handling function
-- eventFrame:SetScript("OnEvent", function(self, event, unit, _, spellID)
--     if unit == "player" then  -- Check if the event is for the player
--         if event == "UNIT_SPELLCAST_START" then
--             local spellName = GetSpellInfo(spellID)
--             currentlyCasting = spellName
--         elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_SUCCEEDED" then
--             currentlyCasting = false
--         end
--     end
-- end)

-- -- Function to get the name of the spell currently being cast, if any, or false if not casting
-- function GetCurrentSpellBeingCast()
--     return currentlyCasting
-- end



        
        -- Function to check for an offhand weapon
function HasOffhandWeapon()
    local offhandItemID = GetInventoryItemID("player", 17) -- 17 is the slot ID for the offhand
    if offhandItemID then
        -- An item is equipped in the offhand slot. This could be a weapon, shield, or held-in-offhand item.
        -- To ensure it's a weapon, you might need additional checks, such as item class and subclass.
        local _, _, _, _, _, itemType, itemSubType = GetItemInfo(offhandItemID)
        if itemType == "Weapon" then
            -- This confirms an offhand weapon is equipped. Shields and off-hand items like tomes are not considered here.
            return true
        else
            -- This means the item is not a weapon. It could be a shield or an off-hand item.
            return false
        end
    else
        -- No item is equipped in the offhand slot.
        return false
    end
end



        
        -- Function to check for an offhand weapon
        function HasMainhandWeapon()
            local mainhandItemID = GetInventoryItemID("player", 16) -- 17 is the slot ID for the offhand
            if mainhandItemID then
                -- An item is equipped in the offhand slot. This could be a weapon, shield, or held-in-offhand item.
                -- To ensure it's a weapon, you might need additional checks, such as item class and subclass.
                local _, _, _, _, _, itemType, itemSubType = GetItemInfo(mainhandItemID)
                if itemType == "Weapon" then
                    -- This confirms an offhand weapon is equipped. Shields and off-hand items like tomes are not considered here.
                    return true
                else
                    -- This means the item is not a weapon. It could be a shield or an off-hand item.
                    return false
                end
            else
                -- No item is equipped in the offhand slot.
                return false
            end
        end


function CheckActiveElementalTotems()
    local isFireTotemActive, isEarthTotemActive, isWaterTotemActive, isAirTotemActive = false, false, false, false
    
    -- Fire Totem
    local haveTotem, name, startTime, duration = GetTotemInfo(1)
    if haveTotem and duration > 0 then
        isFireTotemActive = true
    end

    -- Earth Totem
    haveTotem, name, startTime, duration = GetTotemInfo(2)
    if haveTotem and duration > 0 then
        isEarthTotemActive = true
    end

    -- Water Totem
    haveTotem, name, startTime, duration = GetTotemInfo(3)
    if haveTotem and duration > 0 then
        isWaterTotemActive = true
    end

    -- Air Totem
    haveTotem, name, startTime, duration = GetTotemInfo(4)
    if haveTotem and duration > 0 then
        isAirTotemActive = true
    end

    return isFireTotemActive, isEarthTotemActive, isWaterTotemActive, isAirTotemActive
end


function GetAppropriateCureSpell()
    local debuffTypePoison = "Poison"
    local debuffTypeDisease = "Disease"
    
    for i = 1, 40 do
        local name, _, _, debuffType = UnitDebuff("player", i)
        if not name then break end  -- No more debuffs, exit the loop

        if debuffType == debuffTypePoison then
            return debuffTypePoison
        elseif debuffType == debuffTypeDisease then
            return debuffTypeDisease
        end
    end
    
    return nil  -- No poison or disease found
end

function CanTargetBePurged()
    local i = 1
    while true do
        local name, _, _, debuffType = UnitBuff("target", i)
        if not name then
            return false -- No more buffs, target cannot be purged
        end

        if debuffType == "Magic" then
            return true -- Found a Magic buff, target can be purged
        end

        i = i + 1
    end
end



-- function overpower()
-- local function OnEvent(self, event, unitTarget, event1, flagText, amount, schoolMask)
--     if unitTarget == 'target' and event1 == 'DODGE' and S.Overpower:TimeSinceLastCast()>2 then
--         overpower = true 
--     else
--         overpower = false
--     end
-- end

-- local f = CreateFrame("Frame")
-- f:RegisterEvent("UNIT_COMBAT")
-- f:SetScript("OnEvent", OnEvent)
-- end


-- -- Global variable for the last dodge timestamp
-- lastDodgeTime = nil
-- overpowerSpellID = 7384 -- Ensure this is the correct spell ID for Overpower

-- -- Setup the event frame for listening to combat log events if not already defined
-- if not dodgeTrackerFrame then
--     dodgeTrackerFrame = CreateFrame("Frame", "DodgeTrackerFrame")
--     dodgeTrackerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--     dodgeTrackerFrame:SetScript("OnEvent", function(_, ...)
--         local function OnEvent(self, event, unitTarget, event1, flagText, amount, schoolMask)
        
--         -- If the player's melee attack was dodged by the target, update lastDodgeTime
--         if unitTarget == 'target' and event1 == 'DODGE' then
--             lastDodgeTime = GetTime()
--         end
--     end)
-- end

-- -- Function to check if Overpower is ready based on a recent dodge
-- function overpower()
--     local DODGE_WINDOW = 5 -- Time window in seconds to consider a dodge recent
    
--     -- Check if a dodge occurred within the last 5 seconds
--     if lastDodgeTime and (GetTime() - lastDodgeTime <= DODGE_WINDOW) then
--         local isUsable, notEnoughRage = IsUsableSpell(overpowerSpellID)
--         -- Check if Overpower is usable (off cooldown and player has enough rage)
--         if isUsable and not notEnoughRage then
--             return true
--         end
--     end
    
--     return false
-- end



function overpower()
-- combat log function
    local eventSearchingFor = "DODGE" -- name of event to be searched for
    local arr = {}
    local function OnEvent(self, event)
        if(GetSpellInfo(NAME_OVERPOWER)) then -- only load if player knows the spell
            arr[1], arr[2], arr[3], arr[4],arr[5],arr[6],arr[7],arr[8],arr[9],arr[10],arr[11],arr[12],arr[13],arr[14],arr[15],arr[16],arr[17],arr[18],arr[19],arr[20] = CombatLogGetCurrentEventInfo() 
            
            -- read thru players combat log
            if arr[5] == UnitName("player") then
                
                
                
    
                --this will hide alert after player overpowers successfully
                if(arr[2]=="SPELL_CAST_SUCCESS" and arr[13]==NAME_OVERPOWER) then 
                    print('overpower false')
                    
                end
    
    
    
                -- below works (on swings and spell)
                if arr[12]==eventSearchingFor or arr[15] == eventSearchingFor then
                    print('use overpower')
                    
                end
            end
            
            -- this code fades out overpower alert when overpower is still on cd
            local start, duration, enabled, _ = GetSpellCooldown(NAME_OVERPOWER)
            local opCD = start + duration - GetTime()
                if(opCD > 1.5) then
                print('overpower true')
            else
                print('overpower false')
            end
        end
    
    
    end


    local f = CreateFrame("Frame")
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
    f:SetScript("OnEvent", OnEvent)
    
    NAME_OVERPOWER = GetSpellInfo(11585)
end
