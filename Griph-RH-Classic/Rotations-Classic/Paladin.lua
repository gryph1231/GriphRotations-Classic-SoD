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


GriphRH.Spell[2] = {
    AutoAttack              = Spell(6603),
    Default                 = Spell(1),
    DevotionAura            = Spell(465),
    HolyShock               = Spell(20473),
    HolyLight               = Spell(639),
    Purify                  = Spell(1152),
    SealoftheCrusaderDebuff = Spell(20300),
    SealofMartyrdom         = Spell(407798),
    SealoftheCrusader       = Spell(20305),
    FrostRA                 = Spell(27152),
    FireRA                  = Spell(27153),
    Consecration            = Spell(26573),
    Consecration5           = Spell(20924),

    ArcaneTorrent           = Spell(28730),
    CrusaderSrike           = Spell(407676),
    RighteousFury           = Spell(25780),
    SealofCommand           = Spell(20375),
    SealofRighteousness     = Spell(21084),
    Exorcism                = Spell(415068),
    Judgement               = Spell(20271),
    BlessingofMight         = Spell(19740),
    DivineProtection        = Spell(498),
    BlessingofProtection    = Spell(1022),
    DivineStorm             = Spell(407778),
    HammerofJustice         = Spell(5588),
    Forbearance             = Spell(25771),
    LayonHands              = Spell(633),
    RetributionAura         = Spell(7294),
    BlessingofFreedom       = Spell(1044),
    FlashofLight            = Spell(27137),
    ConcentrationAura       = Spell(19746),
    Rebuke                  = Spell(425609),
    BlessingofKings         = Spell(20217),
    SealofLight             = Spell(20165),
    BlessingofSalvation     = Spell(1038),
    DivineIntervention      = Spell(19752),
    DivineShield            = Spell(642),
    DivineSteed             = Spell(461607),
    SealofJustice           = Spell(20164),
    HolyShield              = Spell(20928),
    SealofWisdom            = Spell(20357),
    SealofWisdomDebuff      = Spell(20355),
    SanctityAura            = Spell(20218),
    BlessingofWisdom2       = Spell(19850),
    BlessingofWisdom        = Spell(19742),
    HammerofWrath           = Spell(24275),
    Repentance              = Spell(20066),
    BlessingofSacrifice     = Spell(27148),
    CrusaderStrike          = Spell(407676),
    impblessingofmight      = Spell(20048),
    HandofReckoning         = Spell(407631),

    HolyWrath               = Spell(27139),
    GreaterBlessingofWisdom = Spell(25894),
    GreaterBlessingofMight  = Spell(27141),
    trinket                 = Spell(28880),
    AvengingWrath           = Spell(407788),
    gloverune               = Spell(20594), --stoneform -- crusader strike and hand of reckoning
    chestrune               = Spell(5502), --sense undead -- divine storm and seal of martyrdom
    AvengersShield          = Spell(407669), -- leg rune
    BlessingofSanctuary     = Spell(20914),
    Pool                    = Spell(155145),

    GreaterBlessingofKings  = Spell(25898),
    RighteousDefense        = Spell(31789),
    CrusaderAura            = Spell(32223),
    JoW                     = Spell(53408),
    SealofBlood             = Spell(31892),
    -- DarkShell = Spell(32358),--pandemonius
    -- StopAttack = Spell(20594),
    SealofCorruption        = Spell(348704),
    thyartiswar             = Spell(59578),
    TurnEvil                = Spell(10326),
    JoJ                     = Spell(53407),
    HammeroftheRighteous    = Spell(407632),
    Cleanse                 = Spell(4987),
    ShieldofRighteousness   = Spell(440658),
};

local S = GriphRH.Spell[2]

if not Item.Paladin then
    Item.Paladin = {}
end
Item.Paladin.Protection = {

    trinket = Item(28288, { 13, 14 }),
    trinket2 = Item(25628, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),
};
local I = Item.Paladin.Protection;

S.BlessingofSanctuary.TextureSpellID = { 19900 } -- fire res aura

S.DivineSteed.TextureSpellID = { 10326 }         -- turn undead
S.AvengingWrath.TextureSpellID = { 19898 }       --  frost res aura




local function APL()
    local inRange25 = 0
    for i = 1, 40 do
        if UnitExists('nameplate' .. i) then
            inRange25 = inRange25 + 1
        end
    end


    targetRange5 = IsItemInRange(8149, "target")
    targetRange10 = IsItemInRange(17626, "target")
    targetRange15 = IsItemInRange(4559, "target")
    targetRange20 = IsItemInRange(1191, "target")
    targetRange25 = IsItemInRange(13289, "target")
    targetRange30 = IsItemInRange(835, "target")

    TTDlong = UnitHealth('target') > 20000
    nextauto = math.max(0, (GriphRH.lasthit() - UnitAttackSpeed('player')) * -1)

    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

    local _, instanceType = IsInInstance()
    local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

    local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local channelTime = elapsedTimech / 1000

    local castTime = elapsedTimeca / 1000

    local castchannelTime = math.random(275, 500) / 1000

    local nameTheArtofWar = GetSpellInfo('The Art of War')
    local nameImprovedHammerofWrath = GetSpellInfo('Improved Hammer of Wrath')
    -- if range == 5 then
    --             input = 8149
    --         elseif range == 10 then
    --             input = 17626
    --         elseif range == 15 then
    --             input = 4559
    --         elseif range == 20 then
    --             input = 1191
    --         elseif range == 25 then
    --             input = 13289
    --         elseif range == 30 then
    --             input = 835
    --         else
    --             local input = nil
    --         end


    if AuraUtil.FindAuraByName("Judgement of Wisdom", "target", "PLAYER|HARMFUL") then
        judgementofwisdomremains = select(6, AuraUtil.FindAuraByName("Judgement of Wisdom", "target", "PLAYER|HARMFUL")) -
            GetTime()
    else
        judgementofwisdomremains = 0
    end
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")


    if AuraUtil.FindAuraByName("Seal of the Crusader", "player") then
        sealbuffremains = select(6, AuraUtil.FindAuraByName("Seal of the Crusader", "player", "PLAYER")) - GetTime()
    elseif AuraUtil.FindAuraByName("Seal of Command", "player") then
        sealbuffremains = select(6, AuraUtil.FindAuraByName("Seal of Command", "player", "PLAYER")) - GetTime()
    elseif AuraUtil.FindAuraByName("Seal of Righteousness", "player") then
        sealbuffremains = select(6, AuraUtil.FindAuraByName("Seal of Righteousness", "player", "PLAYER")) - GetTime()
    elseif AuraUtil.FindAuraByName("Seal of Martyrdom", "player") then
        sealbuffremains = select(6, AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER")) - GetTime()
    elseif AuraUtil.FindAuraByName("Seal of Wisdom", "player") then
        sealbuffremains = select(6, AuraUtil.FindAuraByName("Seal of Wisdom", "player", "PLAYER")) - GetTime()
    else
        sealbuffremains = 0
    end

    if inRange25 == 0 and AuraUtil.FindAuraByName("Forbearance", "player", "PLAYER|HARMFUL")
        and (GriphRH.QueuedSpell():ID() == S.BlessingofProtection:ID() and S.BlessingofProtection:CooldownRemains() > Player:GCD()
            or GriphRH.QueuedSpell():ID() == S.DivineProtection:ID() and S.DivineProtection:CooldownRemains() > Player:GCD()) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    elseif GriphRH.QueuedSpell():ID() == S.DivineProtection:ID() and IsReady("Divine Protection") then
        return GriphRH.QueuedSpell():Cast()
    end

    if inRange25 == 0 and AuraUtil.FindAuraByName("Forbearance", "player", "PLAYER|HARMFUL")
        and (GriphRH.QueuedSpell():ID() == S.BlessingofProtection:ID() and S.BlessingofProtection:CooldownRemains() > Player:GCD()
            or GriphRH.QueuedSpell():ID() == S.DivineShield:ID() and S.DivineShield:CooldownRemains() > Player:GCD()) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    elseif GriphRH.QueuedSpell():ID() == S.DivineShield:ID() and IsReady("Divine Shield") then
        return GriphRH.QueuedSpell():Cast()
    end


    if GriphRH.QueuedSpell():ID() == S.DivineSteed:ID() and (S.DivineSteed:CooldownRemains() > 2 or not IsUsableSpell("Divine Steed")) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    elseif GriphRH.QueuedSpell():ID() == S.DivineSteed:ID() then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.HammerofJustice:ID() and (not Player:CanAttack(Target) or S.HammerofJustice:CooldownRemains() > 2 or not IsUsableSpell("Hammer of Justice") or not Target:Exists() or Target:IsDeadOrGhost()) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    elseif GriphRH.QueuedSpell():ID() == S.HammerofJustice:ID() then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.HolyLight:ID() and IsReady("Holy Light") then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.HolyLight:ID() and (IsCurrentSpell(SpellRank('Holy Light')) or not IsUsableSpell("Holy Light") or Player:MovingFor() > .15) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    end


    if GriphRH.QueuedSpell():ID() == S.HolyLight:ID() and IsReady("Holy Light") then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.HolyLight:ID() and (IsCurrentSpell(SpellRank('Holy Light')) or not IsUsableSpell("Holy Light") or Player:MovingFor() > .15) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    end


    if GriphRH.QueuedSpell():ID() == S.FlashofLight:ID() and IsReady("Flash of Light") then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.FlashofLight:ID() and (IsCurrentSpell(SpellRank('Flash of Light')) or not IsUsableSpell("Flash of Light")
            or Player:MovingFor() > .15) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Rebuke:ID() and (S.Rebuke:CooldownRemains() > 2) then
        GriphRH.queuedSpell = { GriphRH.Spell[2].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Rebuke:ID() and IsReady("Rebuke") then
        return GriphRH.QueuedSpell():Cast()
    end


    if Player:IsCasting() or Player:IsChanneling() or AuraUtil.FindAuraByName("First Aid", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\prot.tga", false
    end




    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------IN COMBAT ROTATION--------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- if Player:HealthPercentage() < 20 and IsReady("Divine Shield") and not AuraUtil.FindAuraByName("Divine Shield", "player") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
    --     return S.DivineShield:Cast()
    -- end

    if Player:HealthPercentage() < 20 and IsReady("Lay on Hands") and S.DivineShield:CooldownRemains() > 2 and S.DivineProtection:CooldownRemains() > 2 and not AuraUtil.FindAuraByName("Divine Shield", "player") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
        return S.LayonHands:Cast()
    end

    -- if Player:HealthPercentage() < 20 and not AuraUtil.FindAuraByName("Divine Shield", "player") and S.DivineShield:CooldownRemains() > 2 and IsReady("Divine Protection") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
    --     return S.DivineProtection:Cast()
    -- end


    --    if IsReady("Blessing of Wisdom") and not S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player")  and Player:IsMoving() and not  AuraUtil.FindAuraByName("Blessing of Protection", "player") then
    --     return S.BlessingofWisdom:Cast()
    -- end
    if IsReady("Sanctity Aura") and not AuraUtil.FindAuraByName("Sanctity Aura", "player") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and not AuraUtil.FindAuraByName("Retribution Aura", "player") and not IsEquippedItemType("Shields") then
        return S.SanctityAura:Cast()
    end

    -- if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Retribution Aura", "player") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and IsEquippedItemType("Shields") then
    --     return S.DevotionAura:Cast()
    -- end

    if IsReady("Retribution Aura") and not AuraUtil.FindAuraByName("Sanctity Aura", "player") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and not AuraUtil.FindAuraByName("Retribution Aura", "player") then
        return S.RetributionAura:Cast()
    end

    if IsReady("Blessing of Sanctuary") and not UnitIsPlayer('target') and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Sanctuary", "player") then
        return S.BlessingofSanctuary:Cast()
    end


    if IsReady("Blessing of Might") and not AuraUtil.FindAuraByName("Blessing of Sanctuary", "player") and not UnitIsPlayer('target') and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Might", "player") and Player:IsMoving() and not AuraUtil.FindAuraByName("Blessing of Protection", "player") then
        return S.BlessingofMight:Cast()
    end

    if (Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and Player:AffectingCombat() or IsCurrentSpell(6603)) then
        if not IsCurrentSpell(6603) and Target:Exists() and targetRange10 then
            return I.autoattack:ID()
        end
        if IsReady("Rebuke") and spellwidgetfort ~= 'Widget Fortress' and (castTime > 0.25 + castchannelTime or channelTime > 0.25 + castchannelTime) and targetRange5 and GriphRH.InterruptsON() then
            return S.Rebuke:Cast()
        end



        -- tank rotation
        if IsEquippedItemType("Shields") then
            --   --hold aggro
            if targetRange5 and isTanking ~= true and not Target:IsAPlayer() and Target:AffectingCombat() and not UnitInRaid("player") then
                if IsReady("Hand of Reckoning") and S.AvengersShield:TimeSinceLastCast() > 0.5 and S.AvengersShield:CooldownRemains() > 2
                    and S.Judgement:TimeSinceLastCast() > 0.5 and S.Judgement:CooldownRemains() > 2 then
                    return S.HandofReckoning:Cast()
                end
            end


            if IsReady("Avenger's Shield") and GriphRH.CDsON() and targetRange30 and inRange25 >= 2 and GriphRH.AoEON() then
                return S.AvengersShield:Cast()
            end
            if IsReady("Hammer of the Righteous") and targetRange5 and inRange25 >= 2 then
                return S.HammeroftheRighteous:Cast()
            end
            --  if IsReady("Hammer of Wrath") and IsUsableSpell("Hammer of Wrath") and targetRange30 and not Player:IsMoving() then
            --         return S.HammerofWrath:Cast()
            --     end

            if IsReady("Seal of Wisdom") and Player:ManaPercentage() < 65 and targetRange5 and judgementofwisdomremains < 2
                and not AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER")
                and not AuraUtil.FindAuraByName("Seal of Wisdom", "player", "PLAYER")
                and sealbuffremains <= 0 then
                return S.SealofWisdom:Cast()
            end

            if IsReady("Seal of Martyrdom") and targetRange5
                and not AuraUtil.FindAuraByName("Seal of Wisdom", "player", "PLAYER") and not AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER")
                and sealbuffremains <= 0 then
                return S.SealofMartyrdom:Cast()
            end



            if IsReady("Holy Shield") and targetRange20 then
                return S.HolyShield:Cast()
            end

            if IsReady("Avenging Wrath") and GriphRH.CDsON() and targetRange10 then
                return S.AvengingWrath:Cast()
            end

            if IsReady("Hammer of the Righteous") and targetRange5 then
                return S.HammeroftheRighteous:Cast()
            end
            if IsReady("Shield of Righteousness") and targetRange5 then
                return S.ShieldofRighteousness:Cast()
            end


            if IsReady("Exorcism") and targetRange30 then
                return S.Exorcism:Cast()
            end

            if IsReady("Avenger's Shield") and GriphRH.CDsON() and targetRange30 and HL.CombatTime() >= 3 then
                return S.AvengersShield:Cast()
            end

            if IsReady("Judgement") and targetRange10 and sealbuffremains > 0 and (AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER")
                    or judgementofwisdomremains < 2 and AuraUtil.FindAuraByName("Seal of Wisdom", "player", "PLAYER")) then
                return S.Judgement:Cast()
            end
        end



        if not IsEquippedItemType("Shields") then
            if (nextauto >= UnitAttackSpeed('player') - 0.3 or not targetRange5) and targetRange10 and (AuraUtil.FindAuraByName("Seal of Command", "player", "PLAYER") or AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER")) then
                if IsReady("Judgement") then
                    return S.Judgement:Cast()
                end
            end

            if IsReady("Divine Storm") and (RangeCount(5) >= 2 and GriphRH.AoEON())  and targetRange5 then
                return S.DivineStorm:Cast()
            end

            if IsReady("Consecration") and S.Consecration5:TimeSinceLastCast() > 7 and targetRange5 and (Player:ManaPercentage() > 55 and RangeCount(10) >= 2 and GriphRH.AoEON()) then
                return S.Consecration:Cast()
            end

            --CHECK LINE BELOW - do we really only want to hammer of wrath with seal of martyrdom up?
            if IsReady("Seal of Martyrdom") and targetRange5 and not AuraUtil.FindAuraByName("Seal of Command", "player", "PLAYER")
                and not AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER") and IsReady("Hammer of Wrath") then
                return S.SealofMartyrdom:Cast()
            end

            if IsReady("Hammer of Wrath") and IsUsableSpell("Hammer of Wrath") and targetRange30 and (not IsEquippedItemType("Shields") or Target:IsAPlayer()) then
                return S.HammerofWrath:Cast()
            end


            if IsReady("Seal of Martyrdom") and targetRange5 and nextauto <= 0.5 and AuraUtil.FindAuraByName("Seal of Command", "player", "PLAYER") 
            and not AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER") then
                return S.SealofMartyrdom:Cast()
            end
              if IsReady("Seal of Command") and targetRange5 and nextauto <= 0.5 and AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER") and not AuraUtil.FindAuraByName("Seal of Command","player","PLAYER") then
                return S.SealofCommand:Cast()
                end
            if IsReady("Seal of Martyrdom") and targetRange5  and not AuraUtil.FindAuraByName("Seal of Command", "player", "PLAYER") and not AuraUtil.FindAuraByName("Seal of Martyrdom", "player", "PLAYER") then
                return S.SealofMartyrdom:Cast()
            end

            if IsReady("Avenging Wrath") and GriphRH.CDsON() and targetRange10 then
                return S.AvengingWrath:Cast()
            end

            if IsReady("Divine Storm") and targetRange5 and (nextauto>1.6 or RangeCount(10)>1 and GriphRH.AoEON())  then
                return S.DivineStorm:Cast()
            end
            if IsReady("Exorcism") and targetRange30 and (nextauto>1.6 or RangeCount(10)>1 and GriphRH.AoEON()) then
                return S.Exorcism:Cast()
            end


            if IsReady("Crusader Strike") and targetRange5 and (nextauto>1.6 or RangeCount(10)>1 and GriphRH.AoEON()) then
                return S.CrusaderStrike:Cast()
            end









            -- if IsReady("Divine Storm") and (RangeCount(5) >= 2 and GriphRH.AoEON()) and S.Judgement:CooldownRemains()>2 and targetRange5 then
            --         return S.DivineStorm:Cast()
            --     end

            --     if IsReady("Hammer of Wrath") and IsUsableSpell("Hammer of Wrath") and targetRange30 and (not IsEquippedItemType("Shields") or Target:IsAPlayer()) then
            --         return S.HammerofWrath:Cast()
            --     end

            --         if IsReady("Seal of Martyrdom") and targetRange5 and not AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER")
            --         and AuraUtil.FindAuraByName("Seal of Command","player","PLAYER") and nextauto<0.65 then
            --             return S.SealofMartyrdom:Cast()
            --         end

            --         if IsReady("Seal of Command") and targetRange5 and not AuraUtil.FindAuraByName("Seal of Command","player","PLAYER")
            --         and AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER") and nextauto<0.65 then
            --             return S.SealofCommand:Cast()
            --         end


            --         if IsReady("Seal of Martyrdom") and not AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER")
            --         and not AuraUtil.FindAuraByName("Seal of Command","player","PLAYER") and nextauto> GCDRemaining()+0.15 then
            --             return S.SealofMartyrdom:Cast()
            --         end

            --         if IsReady("Seal of Command") and not AuraUtil.FindAuraByName("Seal of Command","player","PLAYER")
            --         and not AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER") and nextauto> GCDRemaining()+0.15  then
            --             return S.SealofCommand:Cast()
            --         end


            --     if IsReady("Judgement")  and (nextauto >= UnitAttackSpeed('player') - 0.3 or not targetRange5) and targetRange10 and sealbuffremains > 0 then
            --         return S.Judgement:Cast()
            --     end
            --  if IsReady("Avenging Wrath") and GriphRH.CDsON() and targetRange10 then
            --         return S.AvengingWrath:Cast()
            --     end

            --     if  nextauto>1.7 or HL.CombatTime()<3  then







            --        if IsReady("Divine Storm") and targetRange5 then
            --         return S.DivineStorm:Cast()
            --     end


            --     if IsReady("Exorcism") and targetRange30
            --         and
            --         (nameTheArtofWar == "The Art of War" or UnitCreatureType("target") == "Undead"
            --             or UnitCreatureType("target") == "Demon")
            --     then
            --         return S.Exorcism:Cast()
            --     end



            --     if IsReady("Crusader Strike") and targetRange5 then
            --         return S.CrusaderStrike:Cast()
            --     end




            --     end

            if IsReady("Consecration") and nextauto>1.6 and S.Consecration5:TimeSinceLastCast() > 7 and targetRange5 and (Player:ManaPercentage() > 75) then
                return S.Consecration:Cast()
            end
        end
    end

    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------OUT OF COMBAT ROTATION----------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
        if IsReady("Righteous Fury") and not AuraUtil.FindAuraByName("Righteous Fury", "player")
            and IsEquippedItemType("Shield")
        then
            return S.RighteousFury:Cast()
        end



        -- if IsReady("Blessing of Wisdom") and not S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and Player:IsMoving() then
        --     return S.BlessingofWisdom:Cast()
        -- end
        if IsReady("Sanctity Aura") and not AuraUtil.FindAuraByName("Sanctity Aura", "player") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and not AuraUtil.FindAuraByName("Retribution Aura", "player") then
            return S.SanctityAura:Cast()
        end

        -- if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Retribution Aura", "player") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and IsEquippedItemType("Shields") then
        --     return S.DevotionAura:Cast()
        -- end

        if IsReady("Retribution Aura") and not AuraUtil.FindAuraByName("Sanctity Aura", "player") and not AuraUtil.FindAuraByName("Retribution Aura", "player") then
            return S.RetributionAura:Cast()
        end
        if IsReady("Blessing of Sanctuary") and not UnitIsPlayer('target') and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Sanctuary", "player") then
            return S.BlessingofSanctuary:Cast()
        end


        if IsReady("Blessing of Might") and not AuraUtil.FindAuraByName("Blessing of Sanctuary", "player") and not UnitIsPlayer('target') and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Might", "player") and Player:IsMoving() and not AuraUtil.FindAuraByName("Blessing of Protection", "player") then
            return S.BlessingofMight:Cast()
        end


        if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
            if not IsCurrentSpell(6603) and Target:Exists() and targetRange10 then
                return I.autoattack:ID()
            end

            if IsReady("Judgement") and targetRange10 and sealbuffremains > 0 and nextauto > UnitAttackSpeed('player') - GCDRemaining() - 0.15 then
                return S.Judgement:Cast()
            end


            if IsReady("Holy Shield") and targetRange20 and not AuraUtil.FindAuraByName("Holy Shield", "player", "PLAYER") then
                return S.HolyShield:Cast()
            end




            if sealbuffremains < Player:GCD() then
                if IsReady("Seal of the Crusader") and not IsEquippedItemType("Shields")
                    and TTDlong
                    and not Target:Debuff(S.SealoftheCrusaderDebuff) and not UnitIsPlayer('target') then
                    return S.SealoftheCrusader:Cast()
                end


                -- if IsReady("Seal of Command") then
                --     return S.SealofCommand:Cast()
                -- end
                if IsReady("Seal of Wisdom") and judgementofwisdomremains < 2 and IsEquippedItemType("Shields") then
                    return S.SealofWisdom:Cast()
                end

                if IsReady("Seal of Martyrdom") and not IsEquippedItemType("Shields") then
                    return S.SealofMartyrdom:Cast()
                end

                if IsReady("Seal of Righteousness") then
                    return S.SealofRighteousness:Cast()
                end
            end
        end


        return "Interface\\Addons\\Griph-RH-Classic\\Media\\prot.tga", false
    end

    return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end




GriphRH.Rotation.SetAPL(2, APL);
