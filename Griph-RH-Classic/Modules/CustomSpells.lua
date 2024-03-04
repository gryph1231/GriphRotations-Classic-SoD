local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;

local function GetTexture (Object)
    -- Spells
    local SpellID = Object.SpellID;
    if SpellID then
        if Object.TextureSpellID ~= nil then
            if #Object.TextureSpellID == 1 then
                return GetSpellTexture(Object.TextureSpellID[1]);
            else
                return Object.TextureSpellID[2];
            end
        else
            return GetSpellTexture(SpellID);
        end

    end
    -- Items
    local ItemID = Object.ItemID;
    if ItemID then
        if Object.TextureSpellID ~= nil then
            if #Object.TextureSpellID == 1 then
                return GetSpellTexture(Object.TextureSpellID[1]);
            else
                return Object.TextureSpellID[2];
            end
        else
            local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(ItemID);
            return texture
        end
    end
end

GriphRH.castSpellSequence = {}
local lastCast = 1

function GriphRH.CastSequence()
    if not Player:AffectingCombat() then
        lastCast = 1
        return nil
    end

    if GriphRH.castSpellSequence ~= nil and Player:PrevGCD(1, GriphRH.castSpellSequence[lastCast]) then
        lastCast = lastCast + 1
    end

    if lastCast > #GriphRH.castSpellSequence then
        GriphRH.castSpellSequence = {}
        return nil
    end

    return GriphRH.castSpellSequence[lastCast]
end

GriphRH.queuedSpellAuto = { GriphRH.Spell[7].Default, 0 }
function Spell:QueueAuto(powerExtra)
    local powerEx = powerExtra or 0
    GriphRH.queuedSpellAuto = { self, powerEx }
end

GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
function Spell:Queue(powerExtra, bypassRemove)
    local bypassRemove = bypassRemove or false
    local powerEx = powerExtra or 0
    if self:ID() == GriphRH.queuedSpell[1]:ID() and bypassRemove == false then
        GriphRH.print("|cFFFF0000Removed from Queue:|r " .. GetSpellLink(self:ID()))
        GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        GriphRH.playSoundR("Interface\\Addons\\Griph-RH\\Media\\queuecast.ogg")
        return
    end

    if self:IsAvailable() then
        GriphRH.queuedSpell = { self, powerEx }
        GriphRH.print("|cFFFFFF00Queued:|r " .. GetSpellLink(self:ID()))
        GriphRH.playSoundR("Interface\\Addons\\Griph-RH\\Media\\queue.ogg")
        return
    end
    GriphRH.print("|cFFFF0000Can't Queue:|r " .. GetSpellLink(self:ID()))

end

function GriphRH.QueuedSpell()
    return GriphRH.queuedSpell[1] or GriphRH.Spell[7].Default
end

function GriphRH.QueuedSpellAuto()
    return GriphRH.queuedSpellAuto[1] or GriphRH.Spell[7].Default
end

--/run GriphRH.queuedSpell ={ GriphRH.Spell[103].Prowl, 0 }

function Spell:IsQueuedPowerCheck(powerEx)
    local powerExtra = powerEx or 0
    if GriphRH.queuedSpell[1] == GriphRH.Spell[7].Default and GriphRH.queuedSpellAuto[1] == GriphRH.Spell[7].Default then
        return false
    end

    local powerCostQ, queuedSpellCD, queuedSpellID
    if GriphRH.queuedSpell[1] == GriphRH.Spell[7].Default then
        powerCostQ = GetSpellPowerCost(GriphRH.queuedSpellAuto[1]:ID())
        queuedSpellCD = GriphRH.queuedSpellAuto[1]:CooldownRemains()
        queuedSpellID = GriphRH.queuedSpellAuto[1]:ID()
    else
        powerCostQ = GetSpellPowerCost(GriphRH.queuedSpell[1]:ID())
        queuedSpellCD = GriphRH.queuedSpell[1]:CooldownRemains()
        queuedSpellID = GriphRH.queuedSpell[1]:ID()
    end

    local powerCost = GetSpellPowerCost(self:ID())
    local costType = nil
    local costTypeQ = nil
    local costs = 0
    local costsQ = 0

    for i = 1, #powerCost do
        if powerCost[i].cost > 0 then
            costType = powerCost[i].type
            break
        end
    end

    for i = 1, #powerCostQ do
        if powerCostQ[i].cost > 0 or powerCostQ[i].costPerSec > 0 or powerCostQ[i].costPercent > 0 then
            costTypeQ = powerCostQ[i].type
            costsQ = powerCostQ[i].cost
            break
        end
    end

    if costType == 3 and queuedSpellCD >= Player:EnergyTimeToX(costsQ) then
        return true
    end

    if self:ID() == queuedSpellID then
        return false
    end

    if costType ~= costTypeQ then
        return false
    end
    return true
end

function Spell:IsAvailable(CheckPet)
    return CheckPet and IsSpellKnown(self.SpellID, true) or IsPlayerSpell(self.SpellID);
end

function Spell:IsEnabled()
    if GriphRH.db.profile.mainOption.disabledSpells[self.SpellID] ~= nil then
        return false
    end

    return true
end

function Spell:IsEnabledCD()
    if #GriphRH.db.profile.mainOption.disabledSpellsCD == 0 and GriphRH.CDsON() then
        return true
    end

    for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCD do
        if self.SpellID == GriphRH.db.profile.mainOption.disabledSpellsCD[i].value then
            return false
        end
    end
    return true
end

function GriphRH.addSpellDisabledCD(spellid)
    local exists = false

    if #GriphRH.db.profile.mainOption.disabledSpellsCD > 0 then
        for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCD do
            if spellid == GriphRH.db.profile.mainOption.disabledSpellsCD[i].value then
                exists = true
            end
        end
    end

    if exists == false then
        table.insert(GriphRH.db.profile.mainOption.disabledSpellsCD, { text = GetSpellInfo(spellid), value = spellid })
    end
end

function GriphRH.delSpellDisabledCD(spellid)
    if #GriphRH.db.profile.mainOption.disabledSpellsCD > 0 then
        for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCD do
            if spellid == GriphRH.db.profile.mainOption.disabledSpellsCD[i].value then
                table.remove(GriphRH.db.profile.mainOption.disabledSpellsCD, i)
            end
            break
        end
    end
end

function Spell:IsEnabledCleave()
    if #GriphRH.db.profile.mainOption.disabledSpellsCleave == 0 and not GriphRH.db.profile.mainOption.smartCleave then
        return true
    end

    for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCleave do
        if self.SpellID == GriphRH.db.profile.mainOption.disabledSpellsCleave[i].value then
            return false
        end
    end
    return true
end

function GriphRH.addSpellDisabledCleave(spellid)
    local exists = false

    if #GriphRH.db.profile.mainOption.disabledSpellsCleave > 0 then
        for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCleave do
            if spellid == GriphRH.db.profile.mainOption.disabledSpellsCleave[i].value then
                exists = true
            end
        end
    end

    if exists == false then
        table.insert(GriphRH.db.profile.mainOption.disabledSpellsCleave, { text = GetSpellInfo(spellid), value = spellid })
    end
end

function Spell:CooldownRemains(BypassRecovery, Offset)
    -- if GriphRH.db.profile[GriphRH.playerClass].Spells ~= nil then
        -- for i, v in pairs(GriphRH.db.profile[GriphRH.playerClass].Spells) do
            -- if v.spellID == self:ID() and v.isActive == false then
                -- return 1000
            -- end
        -- end
    -- end

    if self:IsEnabled() == false then
        return 1000
    end

    if self:IsEnabledCD() == false or self:IsEnabledCleave() == false then
        return 1000
    end

    local SpellInfo = Cache.SpellInfo[self.SpellID]
    if not SpellInfo then
        SpellInfo = {}
        Cache.SpellInfo[self.SpellID] = SpellInfo
    end
    local Cooldown = Cache.SpellInfo[self.SpellID].Cooldown
    local CooldownNoRecovery = Cache.SpellInfo[self.SpellID].CooldownNoRecovery
    if (not BypassRecovery and not Cooldown) or (BypassRecovery and not CooldownNoRecovery) then
        if BypassRecovery then
            CooldownNoRecovery = self:ComputeCooldown(BypassRecovery)
        else
            Cooldown = self:ComputeCooldown()
        end
    end
    if Offset then
        return BypassRecovery and math.max(HL.OffsetRemains(CooldownNoRecovery, Offset), 0) or math.max(HL.OffsetRemains(Cooldown, Offset), 0)
    else
        return BypassRecovery and CooldownNoRecovery or Cooldown
    end
end

function Spell:CooldownRemainsTrue(BypassRecovery, Offset)
    local SpellInfo = Cache.SpellInfo[self.SpellID]
    if not SpellInfo then
        SpellInfo = {}
        Cache.SpellInfo[self.SpellID] = SpellInfo
    end
    local Cooldown = Cache.SpellInfo[self.SpellID].Cooldown
    local CooldownNoRecovery = Cache.SpellInfo[self.SpellID].CooldownNoRecovery
    if (not BypassRecovery and not Cooldown) or (BypassRecovery and not CooldownNoRecovery) then
        if BypassRecovery then
            CooldownNoRecovery = self:ComputeCooldown(BypassRecovery)
        else
            Cooldown = self:ComputeCooldown()
        end
    end
    if Offset then
        return BypassRecovery and math.max(HL.OffsetRemains(CooldownNoRecovery, Offset), 0) or math.max(HL.OffsetRemains(Cooldown, Offset), 0)
    else
        return BypassRecovery and CooldownNoRecovery or Cooldown
    end
end


function Spell:IsCastableQueue(Range, AoESpell, ThisUnit)

	if Range then
        local RangeUnit = ThisUnit or Target;
        return self:IsLearned() and self:CooldownRemainsTrue() <= 0.2 and RangeUnit:IsInRange(Range, AoESpell);
    else
        return self:IsLearned() and self:CooldownRemainsTrue() <= 0.2;
    end
end


function Spell:IsReadyQueue(Range, AoESpell, ThisUnit)
    if not GriphRH.TargetIsValid() then
        return false
    end

    return self:IsCastableQueue(Range, AoESpell, ThisUnit) and self:IsUsable();
end


function GriphRH.delSpellDisabledCleave(spellid)
    if #GriphRH.db.profile.mainOption.disabledSpellsCleave > 0 then
        for i = 1, #GriphRH.db.profile.mainOption.disabledSpellsCleave do
            if spellid == GriphRH.db.profile.mainOption.disabledSpellsCleave[i].value then
                table.remove(GriphRH.db.profile.mainOption.disabledSpellsCleave, i)
            end
            break
        end
    end
end

local GroundSpells = {
    [43265] = true,
    [152280] = true,
}

-- function Spell:Cast()
    -- --GriphRH.ShowButtonGlow(self:ID())
	-- CallSecureFunction('CastSpellByName', self:Name())
    -- return GetTexture(self)
-- end

function Spell:Cast()
    GriphRH.ShowButtonGlow(self:ID())
    return GetTexture(self)
end

function Item:Cast()
    return GetTexture(self)
end

function Spell:SetTexture(id)
    self.TextureID = id
end


-- Player On Cast Success Listener
HL:RegisterForSelfCombatEvent(function(_, _, _, _, _, _, _, _, _, _, _, SpellID)
    if SpellID == 49998 then
        GriphRH.clearLastDamage()
    end

    if GriphRH.QueuedSpellAuto().SpellID == SpellID then
        GriphRH.queuedSpellAuto = { GriphRH.Spell[2].Default, 0 }
    end

    if GriphRH.QueuedSpell().SpellID == SpellID then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
        GriphRH.print("|cFFFFFF00Queued:|r " .. GetSpellLink(SpellID) .. " casted!")
        GriphRH.playSoundR("Interface\\Addons\\Griph-RH\\Media\\queuecast.ogg")
    end
    for i, spell in pairs(GriphRH.Spell[GriphRH.playerClass]) do
        if SpellID == spell.SpellID then
            spell.LastCastTime = HL.GetTime()
            spell.LastHitTime = HL.GetTime() + spell:TravelTime()
        end
    end
end, "SPELL_CAST_SUCCESS")

-- Pet On Cast Success Listener
HL:RegisterForPetCombatEvent(function(_, _, _, _, _, _, _, _, _, _, _, SpellID)
    for i, spell in pairs(GriphRH.allSpells) do
        if SpellID == spell.SpellID then
            spell.LastCastTime = HL.GetTime()
            spell.LastHitTime = HL.GetTime() + spell:TravelTime()
        end
    end
end, "SPELL_CAST_SUCCESS")

-- Player Aura Applied Listener
HL:RegisterForSelfCombatEvent(function(_, _, _, _, _, _, _, _, _, _, _, SpellID)
    for i, spell in pairs(GriphRH.Spell[GriphRH.playerClass]) do
        if SpellID == spell.SpellID then
            spell.LastAppliedOnPlayerTime = HL.GetTime()
        end
    end
end, "SPELL_AURA_APPLIED")

-- Player Aura Removed Listener
HL:RegisterForSelfCombatEvent(function(_, _, _, _, _, _, _, _, _, _, _, SpellID)
    for i, spell in pairs(GriphRH.Spell[GriphRH.playerClass]) do
        if SpellID == spell.SpellID then
            spell.LastRemovedFromPlayerTime = HL.GetTime()
        end
    end
end, "SPELL_AURA_REMOVED")

local lustBuffs = {
    Spell(80353),
    Spell(2825),
    Spell(32182),
    Spell(90355),
    Spell(160452),
    Spell(178207),
    Spell(35475),
    Spell(230935),
    Spell(256740),
}

function Unit:LustDuration()
    for i = 1, #HeroismBuff do
        local Buff = HeroismBuff[i]
        if self:Buff(Buff, nil, true) then
            return ThisUnit:BuffRemains(Buff, true) or 0
        end
    end
    return 0
end

function Spell:ArenaCast(arenaTarget)
    local arenaTarget = arenaTarget:ID()
    if UnitName(arenaTarget) == UnitName('arena1') then
        GriphRH.Arena1Icon(self:Cast())
    elseif UnitName(arenaTarget) == UnitName('arena2') then
        GriphRH.Arena2Icon(self:Cast())
    elseif UnitName(arenaTarget) == UnitName('arena3') then
        GriphRH.Arena3Icon(self:Cast())
    end
end

function Spell:CanCast(TargetedUnit)
    if not self:IsUsable() then
        return false, 'Not usable'
    end

    if not self:IsCastable() then
        return false, 'Not Castable'
    end

    if TargetedUnit and TargetedUnit:ID() ~= 'player' then
        if not TargetedUnit:IsInRange(self) then
            return false, 'Not in Range'
        end
    end

    if IsCurrentSpell(self:ID()) then
        return false, 'Current Spell'
    end

    return true
end
