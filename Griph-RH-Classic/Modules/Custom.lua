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
function GriphRH.lastMoved()
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

-- print("5:",IsItemInRange(8149,"target")) --voodoo charm
-- print("10 original:",IsItemInRange(17626,"target")) --test
-- print("15:",IsItemInRange(4559,"target")) --chus quest item
-- print("20:",IsItemInRange(1191,"target")) --chus quest item
-- print("25:",IsItemInRange(13289,"target")) --chus quest item
-- print("30:",IsItemInRange(835,"target")) --chus quest item

function RangeCount(range,spell_range_check)
	local range_counter = 0
		
		if range and not spell_range_check then
			if range == 5 then
				input = 8149
			elseif range == 10 then
				input = 17626
			elseif range == 15 then
				input = 4559
			elseif range == 20 then
				input = 1191
			elseif range == 25 then
				input = 13289
			elseif range == 30 then
				input = 835
			else
				local input = nil
			end

			for i=1,40 do
				local unitID = "nameplate" .. i
				if UnitExists("nameplate"..i) then           
					local nameplate_guid = UnitGUID("nameplate"..i) 
					local npc_id = select(6, strsplit("-",nameplate_guid))
					if npc_id ~='120651' and npc_id ~='161895' then
						if UnitCanAttack("player",unitID) and IsItemInRange(input, unitID) and UnitHealthMax(unitID) > 5
						and UnitName(unitID) ~= "Incorporeal Being" then
							range_counter = range_counter + 1
						end                    
					end
				end
			end
		elseif spell_range_check and not range then
			for i=1,40 do
				local unitID = "nameplate" .. i
				if UnitExists("nameplate"..i) then           
					local nameplate_guid = UnitGUID("nameplate"..i) 
					local npc_id = select(6, strsplit("-",nameplate_guid))
					if npc_id ~='120651' and npc_id ~='161895' then
						if UnitCanAttack("player",unitID) and IsSpellInRange(spell_range_check, unitID) == 1 and UnitHealthMax(unitID) > 5
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







function TargetinRange(range,spell_range_check)
    if range and not spell_range_check then
        if range == 5 then
            input = 8149
        elseif range == 10 then
            input = 17626
        elseif range == 15 then
            input = 4559
        elseif range == 20 then
            input = 1191
        elseif range == 25 then
            input = 13289
        elseif range == 30 then
            input = 835
        else
            local input = nil
        end

        if IsItemInRange(input,"target") then
            return true
        else
            return false
        end
    elseif spell_range_check and not range then
        if IsSpellInRange(spell_range_check,"target") == 1 then
            return true
        else
            return false
        end    
    else
        return false
    end
end




 function IsPlayerFeared()
    for i = 1, 10 do  -- Check all buffs and debuffs on the player
        local name, _, _, _, _, _, _, _, _, spellId = UnitDebuff("player", i)
        if not name then break end  -- Stop if there are no more debuffs
        
        -- List of common Fear spell IDs
        local fearSpells = {
            [5782] = true,  -- Fear (Warlock)
            [8122] = true,  -- Psychic Scream (Priest)
            [1513] = true,  -- Scare Beast (Hunter)
            [6358] = true,  -- Seduction (Succubus)
            [5246] = true,  -- Intimidating Shout (Warrior)
            [10326] = true, -- Turn Evil (Paladin)
            [113792] = true -- Psychic Terror (Psyfiend)
        }

        if fearSpells[spellId] then
            return true
        end
    end
    return false
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

function IsReady(spell,range_check,aoe_check)
	local start,duration,enabled = GetSpellCooldown(tostring(spell))
	local usable, noMana = IsUsableSpell(tostring(spell))
	local range_counter = 0
	local in_range = false

	if range_check then
		for lActionSlot = 1, 120 do
			local lActionText = GetActionTexture(lActionSlot)
			local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spell)
		
			if lActionText == icon then
				if UnitExists("target") then
					in_range = IsActionInRange(lActionSlot,"target")
					break
				end
			end
		end
	end

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

	--if usable and enabled and cooldown_remains - gcd_remains < 0.5 and gcd_remains < 0.5 then
	if usable and enabled and cooldown_remains < 0.5 then
		if range_check then
			if in_range == true then 
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


function GriphRH.lasthit()
if not Player:AffectingCombat() then
return 1000000
end
    if lastmelee > 0 then
        return GetTime() - lastmelee
    end
return 1000000

end

-- function GriphRH.lastSwing()
    -- if lastMeleeHit > 0 then
        -- return GetTime() - lastMeleeHit
    -- end
    -- return 0
-- end

function GriphRH.getLastDamage()
    return damageInLast3Seconds
end

function GriphRH.clearLastDamage()
    damageInLast3Seconds = 0
end

function GriphRH.LastDamage()
    local IncomingDPS = (damageInLast3Seconds / UnitHealthMax("player")) * 100
    return (math.floor((IncomingDPS * ((100) + 0.5)) / (100)))
end

function GriphRH.SetFramePos(frame, x, y, w, h)
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

function GriphRH.ColorOnOff(boolean)
    if boolean == true then
        return "|cFF00FF00"
    else
        return "|cFFFF0000"
    end
end

-- Target Valid
function GriphRH.TargetIsValid(override)
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
function GriphRH.azerite(slot, azeriteID)
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

function GriphRH.DebugPrint(Text)
    if GriphRH.db.profile.mainOption.debug == true then
        print("DEBUG: " .. Text)
    end
end


--NeP RIP
GriphRH.Buttons = {}

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
    wipe(GriphRH.Buttons)
    for _, group in ipairs(nBars) do
        for i = 1, 12 do
            local button = _G[group .. i]
            if button then
                local actionType, id = _G.GetActionInfo(_G.ActionButton_CalculateAction(button, "LeftButton"))
                if actionType == 'spell' then
                    --local spell = GetSpellInfo(id)
                    local spell = id
                    if spell then
                        GriphRH.Buttons[spell] = button
                        --GriphRH.Buttons[spell].glow = false
                        --GriphRH.Buttons[spell].text = GriphRH.Buttons[spell]:CreateFontString('ButtonText')
                        --GriphRH.Buttons[spell].text:SetFont("Fonts\\ARIALN.TTF", 22, "OUTLINE")
                        --GriphRH.Buttons[spell].text:SetPoint("CENTER", GriphRH.Buttons[spell])
                        --GriphRH.Buttons[spell].GlowTexture = GriphRH.Buttons[spell]:CreateTexture(nil, "TOOLTIP")
                        --GriphRH.Buttons[spell].GlowTexture:SetScale(0.8)
                        --GriphRH.Buttons[spell].GlowTexture:SetAlpha(0.5)
                        --GriphRH.Buttons[spell].GlowTexture:SetPoint("CENTER")
                        --GriphRH.Buttons[spell] = button:GetName()
                    end
                end
            end
        end
    end

end

function GriphRH.HideButtonGlow(spellID)
    local isString = (type(spellID) == "string")

    if isString and spellID == "All" then
        for i, button in pairs(GriphRH.Buttons) do
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

    if GriphRH.Buttons[spellID] ~= nil then
        --GriphRH.Buttons[spellID].GlowTexture:SetTexture(nil)
        --GriphRH.Buttons[spellID].glow = false
        --GriphRH.Buttons[spellID].text:SetText("")
        --GriphRH.Buttons[spellID].NormalTexture:SetColorTexture(0, 0, 0, 0)
        --for i, button in pairs(GriphRH.Buttons) do
        --button.NormalTexture:SetColorTexture(0, 0, 0, 0)
        --ActionButton_HideOverlayGlow(button)
        --end
    end
end

function GriphRH.OLDShowButtonGlow(spellID)
    GriphRH.HideButtonGlow("All")
    if GriphRH.Buttons[spellID] ~= nil then
        if lastSpell > 0 and spellID ~= lastSpell then
            --GriphRH.Buttons[spellID].glow = false
           -- GriphRH.Buttons[spellID].GlowTexture:SetTexture(nil)
            lastSpell = spellID
        end
        --ActionButton_ShowOverlayGlow(GriphRH.Buttons[spellID])
        --GriphRH.Buttons[spellID].text:SetText("|cffff0000=>|r")
        GriphRH.Buttons[spellID].GlowTexture:SetTexture("Interface\\Addons\\Griph-RH\\Media\\combat.tga")
        GriphRH.Buttons[spellID].glow = true
        lastSpell = spellID
    end
end

function GriphRH.ShowButtonGlowQueue(spellID)
    if GriphRH.Buttons[spellID] ~= nil then
        GriphRH.Buttons[spellID].GlowTexture:SetTexture("Interface\\Addons\\Griph-RH\\Media\\disarmed.tga")
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
activeFrame.texture:SetTexture("Interface/Addons/Griph-RH/Media/combat.tga")
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

function GriphRH.ShowButtonGlow(spellID)

    if GriphRH.db.profile.mainOption.glowactionbar == false then
        return
    end

    local spellButton = GriphRH.Buttons[spellID]
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

function GriphRH.HideButtonGlow()
    activeFrame:Hide()
end

function GriphRH.print(text, color)
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






-- local eventframe = CreateFrame("Frame")
-- eventframe:RegisterEvent("UNIT_SPELLCAST_START")
-- eventframe:RegisterEvent("UNIT_SPELLCAST_STOP")
-- eventframe:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
-- eventframe:SetScript("OnEvent", OnEvent)

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


-- This flag tracks the success or dodge state of Overpower
local canoverpower = false

local function OnEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType = CombatLogGetCurrentEventInfo()

        -- Check if Overpower was successfully cast
        if eventType == "SPELL_CAST_SUCCESS" and spellName == 'Overpower' and sourceName == UnitName("player") or GetShapeshiftFormID() == 17 and not IsReady('Overpower') then
            canoverpower = false
        end

        -- Check if the target dodged an attack
        if eventType == "SPELL_MISSED" and missType == "DODGE" and sourceName == UnitName("player") then
            canoverpower = true
        end
    end
end

-- Function to call to check the status of Overpower
function checkOverpower()
    return canoverpower
end

-- Setup the event frame and register for combat log events
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:SetScript("OnEvent", OnEvent)



  


function partyInRange()
    local range_counter = 0
    local spellName = "Cure Disease" -- Replace SPELL_NAME with a valid spell name for your class
    
    for i = 1, GetNumGroupMembers() do
        local unitID = "party" .. i
        if UnitExists(unitID) and not UnitIsUnit(unitID, "player") then
            if IsSpellInRange(spellName, unitID) == 1 then
                range_counter = range_counter + 1
            end
        end
    end
    
    return range_counter
end








-- Variables to hold the time of the last melee swings
local lastMainHandSwingTime = GetTime()
local lastOffHandSwingTime = GetTime()
local mainHandSpeed, offHandSpeed

local function UpdateWeaponSpeed()
    mainHandSpeed, offHandSpeed = UnitAttackSpeed("player")
end

-- Update weapon speeds on load
UpdateWeaponSpeed()

local function OnCombatLogEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, eventType, hideCaster, sourceGUID, _, _, _, _, _, _, _, spellName, _, _, _, _, _, _, _, _, isOffHand = CombatLogGetCurrentEventInfo()
        if sourceGUID == UnitGUID("player") then
            if eventType == "SWING_DAMAGE" or eventType == "SWING_MISSED" then
                -- Check if the swing was from the main hand or off hand
                if isOffHand then
                    lastOffHandSwingTime = GetTime()
                else
                    lastMainHandSwingTime = GetTime()
                end
            end
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        UpdateWeaponSpeed()
    end
end

-- Create a frame to listen for relevant events
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:SetScript("OnEvent", OnCombatLogEvent)

-- Function to get the time since the last swing for main hand and offhand
function GetLastSwingTimes()
    local currentTime = GetTime()
    local timeSinceMainHandSwing = currentTime - lastMainHandSwingTime
    local timeSinceOffHandSwing = currentTime - lastOffHandSwingTime

    -- If the main hand is ready to swing again but hasn't, reset the time since the last main hand swing to 0
    if mainHandSpeed and timeSinceMainHandSwing >= mainHandSpeed then
        timeSinceMainHandSwing = 0
        lastMainHandSwingTime = currentTime - mainHandSpeed  -- Set to one swing cycle in the past
    end

    -- If the off hand is ready to swing again but hasn't, reset the time since the last off hand swing to 0
    if offHandSpeed and timeSinceOffHandSwing >= offHandSpeed then
        timeSinceOffHandSwing = 0
        lastOffHandSwingTime = currentTime - offHandSpeed  -- Set to one swing cycle in the past
    end

    return timeSinceMainHandSwing, timeSinceOffHandSwing
end

-- Make sure the weapon speeds are updated when the player's equipment changes
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- Example usage:
-- local mhTime, ohTime = GetLastSwingTimes()
-- print("Main Hand: "..mhTime.."s since last swing.")
-- print("Off Hand: "..ohTime.."s since last swing.")


local lastEnergyTick = GetTime()
local ENERGY_TICK_TIME = 2

local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_POWER_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
    local unitId, powerType = ...
    if unitId == "player" and powerType == "ENERGY" then
        local currentEnergy = UnitPower("player", Enum.PowerType.Energy)
        local maxEnergy = UnitPowerMax("player", Enum.PowerType.Energy)
        if currentEnergy < maxEnergy then
            lastEnergyTick = GetTime()
        end
    end
end)

function EnergyTimeToNextTick()
    local timeSinceLastTick = GetTime() - lastEnergyTick
    local timeToNextTick = ENERGY_TICK_TIME - timeSinceLastTick
    if timeToNextTick < 0 then
        timeToNextTick = ENERGY_TICK_TIME
    end
    return timeToNextTick
end



































-- Create a table to hold the spell cast tracking data and functions
SpellCastTracker = {}
local spellStartTime = {}

local previousTarget = nil

-- Function to get the current target name and detect if it has changed
local function CheckTargetChange()
    -- Get the current target's name
    local currentTarget = UnitName("target")
    
    -- Check if the target has changed
    if currentTarget ~= previousTarget then
        -- Print the name of the new target
        -- if currentTarget then
        --     -- print("Target changed to: " .. currentTarget)
        -- else
        --     print("No target")
        -- end
        
        -- Update the previous target variable
        previousTarget = currentTarget
        
        -- Reset all spell start times when the target changes
        for spell, _ in pairs(spellStartTime) do
            spellStartTime[spell] = nil -- Reset the start time for all spells when the target is changed
            -- print("Target changed, reset spell: " .. spell) -- Debug print
        end
    end
end

-- Function to check if the spell can be cast considering the tolerance
function SpellCastTracker.CanCastSpellWithTolerance(spellName, tolerance)
    local currentTime = GetTime()
    if spellStartTime[spellName] then
        local timeSinceLastCast = currentTime - spellStartTime[spellName]
        -- print("Time since last cast of " .. spellName .. ": " .. timeSinceLastCast) -- Debug print
        if timeSinceLastCast > tolerance then
            return true
        else
            return false
        end
    else
        return true -- Allow casting if the spell has never been cast
    end
end

-- Event handler function
local function OnEvent(self, event, unit, _, spellID)
    if unit == "player" then
        local spellName = GetSpellInfo(spellID)
        if event == "UNIT_SPELLCAST_START" then
            spellStartTime[spellName] = GetTime()
            -- print("Spell started: " .. spellName .. " at " .. spellStartTime[spellName]) -- Debug print
        elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
            spellStartTime[spellName] = nil -- Reset the start time when the spell cast is interrupted
            -- print("Spell interrupted: " .. spellName) -- Debug print
        end
    end
    
    if event == "PLAYER_TARGET_CHANGED" then
        CheckTargetChange()
    end
end

-- Create a frame to listen for relevant events
local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:SetScript("OnEvent", OnEvent)

-- Global function to check if a spell can be cast with tolerance
function CanCastWithTolerance(spellName)
    local castTime = select(4, GetSpellInfo(spellName)) * 0.001 -- Convert from milliseconds to seconds
    return SpellCastTracker.CanCastSpellWithTolerance(spellName, castTime + 0.5)
end






-- -- Table to hold the GUIDs of mobs in combat with the player
-- local mobsInCombat = {}

-- -- Function to extract NPC ID from GUID
-- local function GetNPCIDFromGUID(guid)
--     local type, _, _, _, _, npcID = strsplit("-", guid)
--     if type == "Creature" or type == "Vehicle" then
--         return tonumber(npcID)
--     end
--     return nil
-- end

-- -- Function to handle combat log events
-- local function OnCombatLogEvent(self, event)
--     local _, subEvent, _, sourceGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
--     local playerGUID = UnitGUID("player")

--     -- Track combat events involving the player
--     if subEvent == "SWING_DAMAGE" or subEvent == "SWING_MISSED" or subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_MISSED" or subEvent == "SPELL_AURA_APPLIED"  or subEvent == "SPELL_PERIODIC_DAMAGE" then
--         local npcID = GetNPCIDFromGUID(destGUID)
--         if sourceGUID == playerGUID and destGUID ~= playerGUID then
--             if not mobsInCombat[destGUID] then
--                 print("Adding mob to counter: " .. destGUID)
--             end
--             mobsInCombat[destGUID] = GetTime()
--         elseif destGUID == playerGUID and sourceGUID ~= playerGUID then
--             if not mobsInCombat[sourceGUID] then
--                 print("Adding mob to counter: " .. sourceGUID)
--             end
--             mobsInCombat[sourceGUID] = GetTime()
--         end
--     elseif subEvent == "UNIT_DIED" then
--         if mobsInCombat[destGUID] then
--             print("Removing mob from counter (died): " .. destGUID)
--         end
--         mobsInCombat[destGUID] = nil
--     end
-- end

-- -- Function to handle leaving combat
-- local function OnPlayerRegenEnabled(self, event)
--     mobsInCombat = {}
--     print("Player left combat. Resetting mobsInCombat.")
-- end

-- -- Create a frame to listen for relevant events
-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- frame:RegisterEvent("PLAYER_REGEN_ENABLED")  -- Fired when the player leaves combat
-- frame:SetScript("OnEvent", function(self, event, ...)
--     if event == "COMBAT_LOG_EVENT_UNFILTERED" then
--         OnCombatLogEvent(self, event, ...)
--     elseif event == "PLAYER_REGEN_ENABLED" then
--         OnPlayerRegenEnabled(self, event)
--     end
-- end)

-- -- Function to get the number of mobs in combat with the player
-- function GetMobsInCombat()
--     local currentTime = GetTime()
--     local numMobsInCombat = 0

--     for guid, timestamp in pairs(mobsInCombat) do
--         if currentTime - timestamp < 15 then
--             numMobsInCombat = numMobsInCombat + 1
--         else
--             print("Removing mob from counter (timeout): " .. guid)
--             mobsInCombat[guid] = nil
--         end
--     end

--     return numMobsInCombat
-- end











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
function num(val)
    if val then
        return 1
    else
        return 0
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

GriphRH.Listener:Add('Griph_Events', 'NAME_PLATE_UNIT_ADDED', function(...)
    local unitID = ...
    --AddNameplate(unitID)
end)

GriphRH.Listener:Add('Griph_Events', 'NAME_PLATE_UNIT_REMOVED', function(...)
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
        if TargetinRange(20) then
            totalmobs = totalmobs + 1
        end
    end
    return totalmobs
end

function GetMobsDying()
    local totalmobs = 0
    local dyingmobs = 0
    for reference, unit in pairs(activeUnitPlates) do
        if TargetinRange(20) then
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































































-- Table to hold the GUIDs and names of mobs in combat with the player
local mobsInCombat = {}
local mobNames = {}

-- Function to extract NPC ID from GUID
local function GetNPCIDFromGUID(guid)
    local type, _, _, _, _, npcID = strsplit("-", guid)
    if type == "Creature" or type == "Vehicle" then
        return tonumber(npcID)
    end
    return nil
end

-- Function to handle combat log events
local function OnCombatLogEvent(self, event)
    local _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName = CombatLogGetCurrentEventInfo()
    local playerGUID = UnitGUID("player")

    -- Track combat events involving the player
    if subEvent == "SWING_DAMAGE" or subEvent == "SWING_MISSED" or subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_MISSED" or subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_PERIODIC_DAMAGE" then
        local npcIDSource = GetNPCIDFromGUID(sourceGUID)
        local npcIDDest = GetNPCIDFromGUID(destGUID)
        if sourceGUID == playerGUID and destGUID ~= playerGUID and npcIDDest then
            if not mobsInCombat[destGUID] then
                -- print("Adding mob to counter: " .. (destName or "Unknown") .. " (" .. destGUID .. ")")
                mobNames[destGUID] = destName
            end
            mobsInCombat[destGUID] = GetTime()
        elseif destGUID == playerGUID and sourceGUID ~= playerGUID and npcIDSource then
            if not mobsInCombat[sourceGUID] then
                -- print("Adding mob to counter: " .. (sourceName or "Unknown") .. " (" .. sourceGUID .. ")")
                mobNames[sourceGUID] = sourceName
            end
            mobsInCombat[sourceGUID] = GetTime()
        end
    elseif subEvent == "UNIT_DIED" then
        if mobsInCombat[destGUID] then
            -- print("Removing mob from counter (died): " .. (mobNames[destGUID] or "Unknown") .. " (" .. destGUID .. ")")
            mobNames[destGUID] = nil
        end
        mobsInCombat[destGUID] = nil
    end
end

-- Function to handle leaving combat
local function OnPlayerRegenEnabled(self, event)
    mobsInCombat = {}
    mobNames = {}
    -- print("Player left combat. Resetting mobsInCombat.")
end

-- Create a frame to listen for relevant events
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")  -- Fired when the player leaves combat
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        OnCombatLogEvent(self, event, ...)
    elseif event == "PLAYER_REGEN_ENABLED" then
        OnPlayerRegenEnabled(self, event)
    end
end)

-- Function to get the number of mobs in combat with the player
function GetMobsInCombat()
    local currentTime = GetTime()
    local numMobsInCombat = 0

    for guid, timestamp in pairs(mobsInCombat) do
        if currentTime - timestamp < 15 then
            numMobsInCombat = numMobsInCombat + 1
        else
            -- print("Removing mob from counter (timeout): " .. (mobNames[guid] or "Unknown") .. " (" .. guid .. ")")
            mobsInCombat[guid] = nil
            mobNames[guid] = nil
        end
    end

    return numMobsInCombat
end
