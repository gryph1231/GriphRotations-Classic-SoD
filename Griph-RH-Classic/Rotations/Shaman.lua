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

GriphRH.Spell[7] = {
    PoisonCleansingTotem = Spell(8166),
	LightningBolt = Spell(10391),
    ChainLightning = Spell(930),
    earthshock = Spell(8042),
    earthshock1 = Spell(10595), -- nature resist totem
    TotemicProjection = Spell(437009),    
    totemicprojection = Spell(6495), --sentry totem
	AutoAttack = Spell(6603),
    HealingStreamTotem = Spell(6377),
    ManaSpringTotem = Spell(10495),
    RockbiterWeapon = Spell(16314),
    Purge = Spell(8012),
    CurePoison = Spell(526),
    CureDisease = Spell(2870),
    AncestralSpirit = Spell(20610),
    HealingWave = Spell(8005),
    WindwallTotem = Spell(15107),
    LesserHealingWave = Spell(8010),
	FlametongueWeapon = Spell(16339),
    StoneskinTotem = Spell(10406),
    StrengthofEarthTotem = Spell(8161),
    LightningShield = Spell(8134),
    EarthbindTotem = Spell(2484),
    StoneclawTotem = Spell(6392),
    SearingTotem = Spell(6365),
    LavaLash = Spell(408507),
    handrune = Spell(20554),--berserking
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNovaTotem = Spell(8499),
    MagmaTotem = Spell(10585),
    WindfuryWeapon = Spell(8235),
    WindfuryWeaponTotem = Spell(8512),
    Stormstrike = Spell(17364),
    ChainHeal = Spell(1064),
    -- MoltenBlast = Spell(425339),
    legrune = Spell(20572),
	ElementalMastery = Spell(16166),

    DiseaseCleansingTotem = Spell(8170),
    -- WaterShield = Spell(33736),
    WindfuryWeaponR1 = Spell(8232),
    FlametongueWeaponR1 = Spell(8024),
    FrostbrandWeapon = Spell(10456),
    MaelstromWeapon = Spell(408505),
	EarthShock = Spell(10412),
	FlameShock = Spell(10447),
	FrostShock =  Spell(8058),
    TremorTotem = Spell(8143),
    GhostWolf = Spell(2645),
    LavaBurst = Spell(408490),
	GroundingTotem = Spell(8177),
    WindfuryTotem = Spell(8512),
    flameshock1 = Spell(8184), --fire resist totem
    SpiritoftheAlphaWolf = Spell(408696),
    feetrune = Spell(8227), --flametongue totem
        fsr1 = Spell(8050),
        esr1 = Spell(408681),
     
};

local S = GriphRH.Spell[7]

if not Item.Shaman then
    Item.Shaman = {}
end
Item.Shaman.Elemental = {

	trinket = Item(28040, { 13, 14 }),
	trinket2 = Item(31615, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),

};
local I = Item.Shaman.Elemental;



S.AutoAttack.TextureSpellID = { 8017 }
S.LightningBolt:RegisterInFlight()
S.LavaBurst:RegisterInFlight()


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


local function APL()


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------VARIABLES/FUNCTIONS----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        targetRange25 = TargetInRange("Earth Shock")

        targetRange30 = TargetInRange("Lightning Bolt")
    
        local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end


        if Player:IsCasting() or Player:IsChanneling() then
            return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
        elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") 
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
            return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
        end

        local namemoltenblast = GetSpellInfo('Molten Blast' )
        local nameshieldmastery = GetSpellInfo('Shield Mastery' )
        local nameoverload = GetSpellInfo('Overload' )
        local nameshamanisticrage = GetSpellInfo('Shamanistic Rage' )
        local namelavalash = GetSpellInfo('Lava Lash' )
        local nameWayofEarth = GetSpellInfo('Way of Earth' )
        local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
        local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
        
        if hasMainHandEnchant == true then
            mhenchantseconds = mainHandExpiration/1000
            else mhenchantseconds = 0
            end

            if hasOffHandEnchant == true then
                ohenchantseconds = offHandExpiration/1000
                else ohenchantseconds = 0
                end

        if nameWayofEarth == 'Way of Earth' then 
            rangecheck5 = TargetInRange("Earth Shock") -- range tracker for range 5
        else
            rangecheck5 = targetrange11()
        end

        local haveTotem1, totemName1, startTime1, duration1 = GetTotemInfo(1) --fire
            local remainingDura1 = (duration1 - (GetTime() - startTime1))
        local haveTotem2, totemName2, startTime2, duration2 = GetTotemInfo(2) --earth
            local remainingDura2 = (duration2 - (GetTime() - startTime2))
        local haveTotem3, totemName3, startTime3, duration3 = GetTotemInfo(3) --water
            local remainingDura3 = (duration3 - (GetTime() - startTime3))
        local haveTotem4, totemName4, startTime4, duration4 = GetTotemInfo(4) --air
            local remainingDura4 = (duration4 - (GetTime() - startTime4))

        if remainingDura1 < 0 then
            remainingDura1 = 0
        end
        if remainingDura2 < 0 then
            remainingDura2 = 0
        end
        if remainingDura3 < 0 then
            remainingDura3 = 0
        end
        if remainingDura4 < 0 then
            remainingDura4 = 0
        end

        if remainingDura1 > 0 then 
            haveFire = 1
        else
            haveFire = 0
        end
        if remainingDura2 > 0 then 
            haveEarth = 1
        else
            haveEarth = 0
        end
        if remainingDura3 > 0 then 
            haveWater = 1
        else
            haveWater = 0
        end
        if remainingDura4 > 0 then 
            haveAir = 1
        else
            haveAir = 0
        end

        local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

        local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
       
        local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
        
        local channelTime = elapsedTimech / 1000
    
        local castTime = elapsedTimeca / 1000
    
        local castchannelTime = math.random(275, 500) / 1000



    --     inRangeParty1 = (CheckInteractDistance("party1", 4))
    --     inRangeParty2 = (CheckInteractDistance("party2", 4));
    --     inRangeParty3 = (CheckInteractDistance("party3", 4));
    --     inRangeParty4 = (CheckInteractDistance("party4", 4));
    --  if inRangeParty1 == true or inRangeParty2 == true or inRangeParty3 == true or inRangeParty4 == true then
    --     partymemberinrange = true
    --  else
    --     partymemberinrange = false
    --  end
    --  if nameoverload == 'Overload' then
    --     elemental = true
    --     enhdps = false
    --     enhtank = false
    --  elseif IsEquippedItemType("Shield") then
    --     elemental = false
    --     enhdps = false
    --     enhtank = true
    --  else 
    --     enhdps = true
    --     enhtank = false
    --     elemental = false
    --  end
    --  local rockbitermh, rockbiteroh, flametonguemh, flametongueoh, windfurymh, windfuryoh = false, false, false, false, false, false
    --  local dualWielding = HasMainhandWeapon() and HasOffhandWeapon() 
    --  if not dualWielding then
    --     rockbiteroh = false
    --     flametongueoh = false
    --     windfuryoh = false
    --  end
    --  if dualWielding and not S.FlametongueWeaponR1:IsAvailable()  then
    --     rockbitermh = true
    --     rockbiteroh = true
    --  end
    --  if dualWielding and S.FlametongueWeaponR1:IsAvailable()  then
    --     flametongueoh = true
    --     rockbiteroh = false
    --     windfuryoh = false
    --  end
    --     if not HasMainhandWeapon() then
    --         rockbitermh = false
    --         windfurymh = false
    --         flametonguemh = false
    --     else
     
    
    --         if enhdps ==true then
    --             if S.WindfuryWeaponR1:IsAvailable() then
    --                 windfurymh = true
    --             else
    --                 rockbitermh = true
    --             end
    --         end
                    
    --         if elemental == true then
    --             if S.FlametongueWeaponR1:IsAvailable()  then
    --             flametonguemh = true
    --             else
    --                 rockbitermh = true
    --             end
    --         end
            
    --         if enhtank == true then
    --             if  nameWayofEarth == 'Way of Earth' then
    --                 rockbitermh = true
    --                 elseif  S.WindfuryWeaponR1:IsAvailable()  and nameWayofEarth~= 'Way of Earth' then
    --                     windfurymh = true
    --                 end
    --             end

    --     end


     if partyInRange()>=1 then
        partymemberinrange = true
     else
        partymemberinrange = false
     end
     if nameoverload == 'Overload' then
        elemental = true
        enhdps = false
        enhtank = false
     elseif IsEquippedItemType("Shield") then
        elemental = false
        enhdps = false
        enhtank = true
     else 
        enhdps = true
        enhtank = false
        elemental = false
     end
     local rockbitermh, rockbiteroh, flametonguemh, flametongueoh, windfurymh, windfuryoh = false, false, false, false, false, false
     local dualWielding = HasMainhandWeapon() and HasOffhandWeapon() 
     if not dualWielding then
        rockbiteroh = false
        flametongueoh = false
        windfuryoh = false
     end
     if dualWielding and not S.FlametongueWeaponR1:IsAvailable()  then
        rockbitermh = true
        rockbiteroh = true
     end
         if dualWielding and S.FlametongueWeaponR1:IsAvailable() and not S.WindfuryWeaponR1:IsAvailable() then
        flametongueoh = false
        rockbiteroh = true
        windfuryoh = false
     end
     if dualWielding and S.WindfuryWeaponR1:IsAvailable()  then
        flametongueoh = false
        rockbiteroh = true
        windfuryoh = false
     end
        if not HasMainhandWeapon() then
            rockbitermh = false
            windfurymh = false
            flametonguemh = false
        else
     
    
            if enhdps ==true then
                if S.WindfuryWeaponR1:IsAvailable() then
                    windfurymh = true
                else
                    rockbitermh = true
                end
        
            end
                    
            if elemental == true then
                if S.FlametongueWeaponR1:IsAvailable()  then
                flametonguemh = true
                else
                    rockbitermh = true
                end
            end
            
            if enhtank == true then
                if  nameWayofEarth == 'Way of Earth' then
                    rockbitermh = true
                    elseif  S.WindfuryWeaponR1:IsAvailable()  and nameWayofEarth~= 'Way of Earth' then
                        windfurymh = true
                    end
                end

        end


  
        -- print('flametongueMH:', flametonguemh)
        -- print('flametongueOH:', flametongueoh)
        -- print('rockbiterMH:', rockbitermh)
        -- print('rockbiterOH:', rockbiteroh)
        -- print('windfuryMH:', windfurymh)
        -- print('windfuryOH:', windfuryoh)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------SPELL QUEUES-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if GriphRH.QueuedSpell():ID() == S.earthshock1:ID() and S.EarthShock:CooldownRemains()<2 then 
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.Purge:ID() and (GetAppropriateCureSpell() ~= "Poison" 
        or GetAppropriateCureSpell() ~= "Disease" or not Target:Exists() or IsUsableSpell("Purge") or CanTargetBePurged()) then 
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.HealingWave:ID() and (not IsUsableSpell("Healing Wave") or Player:MovingFor()>0.5) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        
        if GriphRH.QueuedSpell():ID() == S.LesserHealingWave:ID() and (not IsUsableSpell("Lesser Healing Wave") or Player:MovingFor()>0.5 ) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Earthbind Totem") or S.EarthbindTotem:CooldownRemains()>2 or not Player:AffectingCombat() )  then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.FireNovaTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Fire Nova Totem") or S.FireNovaTotem:CooldownRemains()>2 or not Player:AffectingCombat())  then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.StoneclawTotem:ID() and (inRange25 ==0 or not IsUsableSpell("Stoneclaw Totem") or S.StoneclawTotem:CooldownRemains()>2 or not Player:AffectingCombat() )  then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.FrostShock:ID() and (not targetRange25 or not Player:AffectingCombat() )  then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.EarthShock:ID() and (not targetRange25 
        or S.EarthShock:CooldownRemains()>2  or S.esr1:CooldownRemains()>2) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.earthshock1:ID() and (not targetrange11() or S.esr1:CooldownRemains()>2) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.FlameShock:ID() and (not targetRange25 or not IsUsableSpell("Flame Shock") or S.FlameShock:CooldownRemains()>2   ) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.FrostShock:ID() and (not targetRange25 or not IsUsableSpell("Frost Shock") or S.FrostShock:CooldownRemains()>2  ) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.GhostWolf:ID() and ( not IsUsableSpell("Ghost Wolf") or Player:MovingFor()>0.5 ) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.SearingTotem:ID() and (not IsUsableSpell(S.SearingTotem) or S.SearingTotem:TimeSinceLastCast()<10) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.MagmaTotem:ID() and (not IsUsableSpell(S.MagmaTotem) or S.MagmaTotem:TimeSinceLastCast()<10) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and (not IsUsableSpell(S.EarthbindTotem) or S.EarthbindTotem:TimeSinceLastCast()<10) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end


        if GriphRH.QueuedSpell():ID() == S.CurePoison:ID() and (not IsUsableSpell("Cure Poison") or GetAppropriateCureSpell() ~= "Poison" ) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.CureDisease:ID() and (not IsUsableSpell("Cure Disease") or GetAppropriateCureSpell() ~= "Disease") then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end

        if GriphRH.QueuedSpell():ID() == S.Purge:ID() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and GetAppropriateCureSpell() ~= "Poison" 
        and GetAppropriateCureSpell() ~= "Disease" and Target:Exists() and not Target:IsDeadOrGhost() 
        and Player:CanAttack(Target) and CanTargetBePurged() and IsUsableSpell("Purge") then
            return GriphRH.QueuedSpell():Cast()
        end

        if GriphRH.QueuedSpell():ID() == S.Purge:ID() and GetAppropriateCureSpell() == "Poison" and IsUsableSpell("Cure Poison") then
            return S.CurePoison:Cast()
        end

        if GriphRH.QueuedSpell():ID() == S.Purge:ID() and GetAppropriateCureSpell() == "Disease" and IsUsableSpell("Cure Disease") then
            return S.CureDisease:Cast()
        end

        if GriphRH.QueuedSpell():ID() == S.SearingTotem:ID() and IsUsableSpell("Searing Totem") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.TremorTotem:ID() and IsUsableSpell("Tremor Totem") and totemName2 ~= 'Tremor Totem' then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.EarthbindTotem:ID() and IsUsableSpell("Earthbind Totem") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.GroundingTotem:ID() and (S.GroundingTotem:CooldownRemains()>2 or not IsUsableSpell("Grounding Totem")) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
      end
        if GriphRH.QueuedSpell():ID() == S.GroundingTotem:ID() and IsUsableSpell("Grounding Totem") and totemName4 ~= 'Grounding Totem' and S.GroundingTotem:TimeSinceLastCast()>2 and IsUsableSpell("Grounding Totem") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.MagmaTotem:ID() and IsUsableSpell("Magma Totem") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.FrostShock:ID() and IsUsableSpell("Frost Shock") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.FireNovaTotem:ID() and IsUsableSpell("Fire Nova Totem") then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.WindfuryTotem:ID() and IsUsableSpell("Windfury Totem") and totemName4 ~= 'Windfury Totem' and S.WindfuryTotem:TimeSinceLastCast()>2 then
            return GriphRH.QueuedSpell():Cast()
        end
        if GriphRH.QueuedSpell():ID() == S.EarthShock:ID() and (S.EarthShock:CooldownRemains()>1.5 or not IsUsableSpell("Earth Shock")) then
              GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
        end
        if GriphRH.QueuedSpell():ID() == S.TremorTotem:ID() and (S.TremorTotem:TimeSinceLastCast()>2 or not IsUsableSpell("Tremor Totem")) then
            GriphRH.queuedSpell = { GriphRH.Spell[7].Default, 0 }
      end


        if GriphRH.QueuedSpell():ID() == S.EarthShock:ID() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and S.EarthShock:CooldownRemains()<2 and namelavalash== 'Lava Lash' and IsUsableSpell("Earth Shock") then
            return GriphRH.QueuedSpell():Cast()
        end


        if GriphRH.QueuedSpell():ID() == S.TotemicProjection:ID() then
            GriphRH.queuedSpell = { GriphRH.Spell[7].totemicprojection, 0 }
            return GriphRH.QueuedSpell():Cast()
        end
  
        -- print( GetUnitSpeed("target") /7 *100)

    -- FTweaponenchantIDs = {5, 4, 3, 523}
-- WFweaponenchantIDs = {283, 284}
-- RBweaponenchantIDs = {29, 6, 1, 503, 1663}
if (Player:AffectingCombat() or  not Player:AffectingCombat() and Player:IsMoving()) and GCDRemaining()==0 and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then
    if rockbitermh == true and (mhenchantseconds<30 or (mainHandEnchantID~=29 and mainHandEnchantID~=6 and mainHandEnchantID~=1 and mainHandEnchantID~=503 and mainHandEnchantID~=1663)) then
        return S.RockbiterWeapon:Cast()
    end
    if flametonguemh == true and (mhenchantseconds<30  or (mainHandEnchantID~=5 and mainHandEnchantID~=4 and mainHandEnchantID~=3 and mainHandEnchantID~=523)) then
        return S.FlametongueWeapon:Cast()
    end
    if windfurymh == true and (mhenchantseconds<30  or (mainHandEnchantID~=283 and mainHandEnchantID~=284)) then
        return S.WindfuryWeapon:Cast()
    end
    if windfuryoh == true and (ohenchantseconds<30  or (mainHandEnchantID~=283 and mainHandEnchantID~=284)) then
        return S.WindfuryWeapon:Cast()
    end
    if rockbiteroh == true and (ohenchantseconds<30  or (offHandEnchantID~=29 and offHandEnchantID~=6 and offHandEnchantID~=503 and offHandEnchantID~=1 and offHandEnchantID~=1663)) then
        return S.RockbiterWeapon:Cast()
    end
    if flametongueoh == true and (ohenchantseconds<30  or (offHandEnchantID~=5 and offHandEnchantID~=4 and offHandEnchantID~=3 and offHandEnchantID~=523)) then
        return S.FlametongueWeapon:Cast()
    end
    end


    if (Player:AffectingCombat() or  not Player:AffectingCombat() and Player:IsMoving()) and GCDRemaining()==0 and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then
        if rockbitermh == true and (hasMainHandEnchant==false or (mainHandEnchantID~=29 and mainHandEnchantID~=6 and mainHandEnchantID~=1 and mainHandEnchantID~=503 and mainHandEnchantID~=1663)) then
            return S.RockbiterWeapon:Cast()
        end
        if flametonguemh == true and (hasMainHandEnchant==false or (mainHandEnchantID~=5 and mainHandEnchantID~=4 and mainHandEnchantID~=3 and mainHandEnchantID~=523)) then
            return S.FlametongueWeapon:Cast()
        end
        if windfurymh == true and (hasMainHandEnchant==false  or (mainHandEnchantID~=283 and mainHandEnchantID~=284)) then
            return S.WindfuryWeapon:Cast()
        end
        if rockbiteroh == true and (hasOffHandEnchant==false  or (offHandEnchantID~=29 and offHandEnchantID~=6 and offHandEnchantID~=503 and offHandEnchantID~=1 and offHandEnchantID~=1663)) then
            return S.RockbiterWeapon:Cast()
        end
        if flametongueoh == true and (hasOffHandEnchant==false  or (offHandEnchantID~=5 and offHandEnchantID~=4 and offHandEnchantID~=3 and offHandEnchantID~=523)) then
            return S.FlametongueWeapon:Cast()
        end
        end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------IN COMBAT ROTATION-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() 
   and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") and not AuraUtil.FindAuraByName("Ghost Wolf", "player")
   and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.LightningBolt:InFlight() or S.LavaBurst:InFlight()) then 
  

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------ENHDPS-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if enhdps == true  then

        if not IsCurrentSpell(6603) and targetrange11() then
            return I.autoattack:ID()
        end

        if IsReady('Shamanistic Rage') and (Player:ManaPercentage()<65 or Player:HealthPercentage()<80 and Player:ManaPercentage()<70 and Target:IsAPlayer()) and GriphRH.CDsON() and targetRange30  then
            return S.legrune:Cast()
        end

        if IsReady('Healing Wave') and Player:HealthPercentage()<55 and Player:BuffStack(S.MaelstromWeapon)>=5 then
            return S.HealingWave:Cast()
        end

        if Target:IsAPlayer() and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and IsReady('Earth Shock') and targetRange25 then
            return S.EarthShock:Cast()
        end
        if IsReady('Molten Blast') and RangeCount11()>1 then
            return S.handrune:Cast()
        end

        if IsReady('Stormstrike') and targetrange11() then
            return S.Stormstrike:Cast()
        end
        if IsReady('Molten Blast') and RangeCount11()==1 then
            return S.handrune:Cast()
        end
   
        if IsReady('Lava Lash') and targetrange11() then
            return S.handrune:Cast()
        end
        
        if IsReady("Poison Cleansing Totem") and S.PoisonCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Poison" and totemName3 ~= 'Poison Cleansing Totem' then
            return S.PoisonCleansingTotem:Cast()
        end

        if IsReady("Disease Cleansing Totem") and S.DiseaseCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Disease" and totemName3 ~= 'Disease Cleansing Totem' then
            return S.DiseaseCleansingTotem:Cast()
        end

        if IsReady('Chain Lightning') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and inRange25>1 then
            return S.ChainLightning:Cast()
        end

        if IsReady('Lava Burst') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and targetRange30  then
            return S.handrune:Cast()
        end

        if IsReady('Chain Lightning') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and targetRange30 then
            return S.ChainLightning:Cast()
        end


        if not Target:IsAPlayer() and UnitHealthMax('target')>100000 and Target:TimeToDie()<10 and IsReady('Earth Shock') and targetRange25 then
            return S.EarthShock:Cast()
        end


        if not Target:IsAPlayer() and Player:ManaPercentage()>=30 and IsReady('Flame Shock') and (aoeTTD()>3 or Target:TimeToDie()>3 or HL.CombatTime()<3) and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
            return S.FlameShock:Cast()
        end

        if not Target:IsAPlayer() and Player:ManaPercentage()<30 and IsReady('Flame Shock(rank 1)') and (aoeTTD()>3 or Target:TimeToDie()>3) and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
            return S.flameshock1:Cast()
        end

        if not Target:IsAPlayer() and Player:ManaPercentage()>=30 and (AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") or aoeTTD()<3 or Target:TimeToDie()<3 or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and IsReady('Earth Shock') and targetRange25 then
            return S.EarthShock:Cast()
        end


        if not Target:IsAPlayer() and S.earthshock1:CooldownRemains()<1.5 and  Player:ManaPercentage()<30 and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and IsReady('Earth Shock(rank 1)') and targetRange25 then
            return S.earthshock1:Cast()
        end
        
    
        if not Target:IsAPlayer() and IsReady(SpellRank('Windfury Totem')) and (mhenchantseconds>30 and (ohenchantseconds>30 or not HasOffhandWeapon())) and  haveTotem4 == false and partyInRange()>=1 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.WindfuryTotem:Cast()
        end
        
        
        if Target:IsAPlayer() and IsReady(SpellRank('Grounding Totem')) and Target:IsCasting() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.GroundingTotem:Cast()
        end  

        if not Target:IsAPlayer() and not Player:IsMoving() and Player:ManaPercentage()>70 and IsReady('Magma Totem') and aoeTTD()>5 and RangeCount11()>1 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.MagmaTotem:Cast()
        end

        if IsReady(SpellRank('Strength of Earth Totem')) and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and not AuraUtil.FindAuraByName("Strength of Earth", "player") and haveTotem2 == false then
            return S.StrengthofEarthTotem:Cast()
        end

        if IsReady(SpellRank('Totemic Projection')) and  mhenchantseconds>30 and ohenchantseconds>30 and (totemName4 == 'Windfury Totem' or not totemName4 ~= 'Windfury Totem') and (not AuraUtil.FindAuraByName("Ghost Wolf", "player")  
        and ((totemName2 == 'Strength of Earth Totem III' or totemName2 == 'Strength of Earth Totem II' or totemName2 == 'Strength of Earth Totem I') and not AuraUtil.FindAuraByName("Strength of Earth", "player") or
        totemName3 == 'Mana Spring Totem' and not AuraUtil.FindAuraByName("Mana Spring", "player"))) then
        return S.totemicprojection:Cast()
        end
        if IsReady('Searing Totem') and Player:ManaPercentage()>40 and RangeCount11()==1 and Target:TimeToDie()>5 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.SearingTotem:Cast()
        end

        if not Target:IsAPlayer() and IsReady(SpellRank('Mana Spring Totem')) and Target:TimeToDie()>60 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and IsInGroup() and  partyInRange()>=1 and not AuraUtil.FindAuraByName("Mana Spring", "player") and haveTotem3 == false then
            return S.ManaSpringTotem:Cast()
        end
       
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------ENHTANK-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if enhtank  == true then 
                
            if not IsCurrentSpell(6603) and targetrange11() then
                return I.autoattack:ID()
            end    
        
            if IsReady('Spirit of the Alpha') and not AuraUtil.FindAuraByName("Spirit of the Alpha", "player") and namelavalash~= 'Lava Lash' then
                return S.feetrune:Cast()
            end

            if IsReady('Shamanistic Rage') and (Player:ManaPercentage()<65 or Player:HealthPercentage()<80 and Player:ManaPercentage()<70 and Target:IsAPlayer()) and GriphRH.CDsON() and targetRange30  then
                return S.legrune:Cast()
            end

            if IsReady('Healing Wave') and Player:HealthPercentage()<55 and Player:BuffStack(S.MaelstromWeapon)>=5 then
                return S.HealingWave:Cast()
            end

            if IsReady('Molten Blast') and rangecheck5 and RangeCount11()>1 then
                return S.handrune:Cast()
            end

            -- if (Target:IsAPlayer() or Player:ManaPercentage()>=70) and (aoeTTD()<3 or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and IsReady('Earth Shock') and targetrange11() then
            --     return S.EarthShock:Cast()
            -- end

            if S.earthshock1:CooldownRemains()<1.5 and (isTanking == false or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and S.esr1:CooldownRemains()<1.5 and IsUsableSpell("Earth Shock(rank 1)") and targetrange11() then
                return S.earthshock1:Cast()
            end

            -- if Player:ManaPercentage()>=70 and IsReady('Flame Shock') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
            --     return S.FlameShock:Cast()
            -- end

            if IsReady('Chain Lightning') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and inRange25>1  and targetRange30 then
                return S.ChainLightning:Cast()
            end

            if IsReady('Stormstrike') and targetrange11() then
                return S.Stormstrike:Cast()
            end

            if IsReady('Molten Blast') and rangecheck5  then
                return S.handrune:Cast()
            end
            if IsReady('Lava Lash') and targetrange11() then
                return S.handrune:Cast()
            end

            if IsReady('Lava Burst') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and targetRange30  then
                return S.handrune:Cast()
            end

            if IsReady("Poison Cleansing Totem") and S.PoisonCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Poison" and totemName3 ~= 'Poison Cleansing Totem' then
                return S.PoisonCleansingTotem:Cast()
            end
    
            if IsReady("Disease Cleansing Totem") and S.DiseaseCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Disease" and totemName3 ~= 'Disease Cleansing Totem' then
                return S.DiseaseCleansingTotem:Cast()
            end

            if Target:IsAPlayer() and  IsReady(SpellRank('Grounding Totem')) and Target:IsCasting() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
                return S.GroundingTotem:Cast()
            end  
    
            if not Target:IsAPlayer() and not Player:IsMoving() and Player:ManaPercentage()>80 and IsReady('Magma Totem') and aoeTTD()>5 and RangeCount11()>1 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
                return S.MagmaTotem:Cast()
            end
    
            if IsReady(SpellRank('Strength of Earth Totem')) and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and not AuraUtil.FindAuraByName("Strength of Earth", "player") and haveTotem2 == false then
                return S.StrengthofEarthTotem:Cast()
            end
    
            if IsReady(SpellRank('Totemic Projection')) and (not AuraUtil.FindAuraByName("Ghost Wolf", "player")  
            and ((totemName2 == 'Strength of Earth Totem III' or totemName2 == 'Strength of Earth Totem II' or totemName2 == 'Strength of Earth Totem I') and not AuraUtil.FindAuraByName("Strength of Earth", "player") or
            totemName3 == 'Mana Spring Totem' and not AuraUtil.FindAuraByName("Mana Spring", "player"))) then
            return S.totemicprojection:Cast()
            end

            if IsReady('Chain Lightning') and (Player:BuffStack(S.MaelstromWeapon)>=5 or AuraUtil.FindAuraByName("Power Surge", "player")) and targetRange30 then
                return S.ChainLightning:Cast()
            end

            if IsReady('Flame Shock(rank 1)') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
                return S.flameshock1:Cast()
            end

            if IsReady('Searing Totem') and Player:ManaPercentage()>40 and RangeCount11()==1 and Target:TimeToDie()>5 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
                return S.SearingTotem:Cast()
            end
    
            if IsReady(SpellRank('Mana Spring Totem')) and Target:TimeToDie()>10 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and IsInGroup() and  partyInRange()>=1 and not AuraUtil.FindAuraByName("Mana Spring", "player") and haveTotem3 == false then
                return S.ManaSpringTotem:Cast()
            end




        end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------ELE-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if elemental == true then

        if not IsCurrentSpell(6603) and targetrange11() then
            return I.autoattack:ID()
        end

        if IsReady('Shamanistic Rage') and (Player:ManaPercentage()<65 or Player:HealthPercentage()<80 and Player:ManaPercentage()<70 and Target:IsAPlayer()) and GriphRH.CDsON() and targetRange30  then
            return S.legrune:Cast()
        end

        if IsReady('Chain Lightning') and targetRange30 and inRange25>1 then
            return S.ChainLightning:Cast()
        end

        if IsReady('Lava Burst') and targetRange30 then
            return S.handrune:Cast()
        end

        if IsReady('Chain Lightning') and targetRange30 then
            return S.ChainLightning:Cast()
        end
        if Player:ManaPercentage()>=30 and (aoeTTD()<3 or castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime or AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") or Target:TimeToDie()<3) and IsReady('Earth Shock') and targetRange25 then
            return S.EarthShock:Cast()
        end

        if Player:ManaPercentage()<30 and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime or AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL")) and IsReady('Earth Shock(rank 1)') and targetRange25 then
            return S.earthshock1:Cast()
        end

        if Player:ManaPercentage()>=30 and IsReady('Flame Shock') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
            return S.FlameShock:Cast()
        end

        if Player:ManaPercentage()<30 and IsReady('Flame Shock(rank 1)') and targetRange25 and not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
            return S.flameshock1:Cast()
        end
        if IsReady("Poison Cleansing Totem") and S.PoisonCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Poison" and totemName3 ~= 'Poison Cleansing Totem' then
            return S.PoisonCleansingTotem:Cast()
        end

        if IsReady("Disease Cleansing Totem") and S.DiseaseCleansingTotem:TimeSinceLastCast()> 30 and GetAppropriateCureSpell() == "Disease" and totemName3 ~= 'Disease Cleansing Totem' then
            return S.DiseaseCleansingTotem:Cast()
        end

       
        if not Target:IsAPlayer() and IsReady(SpellRank('Windfury Totem')) and (mhenchantseconds>30 and (ohenchantseconds>30 or not HasOffhandWeapon())) and  haveTotem4 == false and partyInRange()>=1 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.WindfuryTotem:Cast()
        end
        
        
        if Target:IsAPlayer() and  IsReady(SpellRank('Grounding Totem')) and Target:IsCasting() and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.GroundingTotem:Cast()
        end  

        if not Target:IsAPlayer() and not Player:IsMoving() and Player:ManaPercentage()>70 and IsReady('Magma Totem') and aoeTTD()>5 and RangeCount11()>1 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.MagmaTotem:Cast()
        end

        if IsReady(SpellRank('Strength of Earth Totem')) and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and not AuraUtil.FindAuraByName("Strength of Earth", "player") and haveTotem2 == false then
            return S.StrengthofEarthTotem:Cast()
        end

        if IsReady(SpellRank('Totemic Projection')) and (not AuraUtil.FindAuraByName("Ghost Wolf", "player")  
        and ((totemName2 == 'Strength of Earth Totem III' or totemName2 == 'Strength of Earth Totem II' or totemName2 == 'Strength of Earth Totem I') and not AuraUtil.FindAuraByName("Strength of Earth", "player") or
        totemName3 == 'Mana Spring Totem' and not AuraUtil.FindAuraByName("Mana Spring", "player"))) then
        return S.totemicprojection:Cast()
        end
        if IsReady('Searing Totem') and Player:ManaPercentage()>40 and RangeCount11()==1 and Target:TimeToDie()>5 and haveTotem1 == false and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.SearingTotem:Cast()
        end

        if IsReady(SpellRank('Mana Spring Totem')) and Target:TimeToDie()>10 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") and IsInGroup() and  partyInRange()>=1 and not AuraUtil.FindAuraByName("Mana Spring", "player") and haveTotem3 == false then
            return S.ManaSpringTotem:Cast()
        end

        if IsReady('Lightning Bolt') and targetRange30 then
            return S.LightningBolt:Cast()
        end

    end

        return 135328 -- sword icon id
    end --end of in combat rotation


    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------OUT OF COMBAT ROTATION-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if (not Player:AffectingCombat() or Target:IsCasting() and not Player:AffectingCombat() or Target:AffectingCombat() 
    or IsCurrentSpell(6603) or S.LightningBolt:InFlight()) and not AuraUtil.FindAuraByName("Ghost Wolf", "player") 
    and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player")  
    and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then
  
        if  Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and targetrange11() then 
            if not IsCurrentSpell(6603) and targetrange11() then
                return I.autoattack:ID()
            end
       
            if IsReady('Stormstrike') and targetrange11()  then
            return S.Stormstrike:Cast()
            end

            if IsReady('Lava Lash') and targetrange11()  then
                return S.handrune:Cast()
            end


            if IsReady('Lava Burst') then
                return S.handrune:Cast()
            end

            if IsReady('Chain Lightning') then
                return S.ChainLightning:Cast()
            end

            if IsReady('Lightning Bolt') then
                return S.LightningBolt:Cast()
            end
        end

        if IsReady('Lightning Shield') and S.LightningShield:TimeSinceLastCast()>4 and not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Lightning Shield", "player") and Player:IsMoving() and Player:ManaPercentage()>90 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.LightningShield:Cast()
        end
    
        if IsReady('Healing Wave') and Player:HealthPercentage()<80 and Player:BuffStack(S.MaelstromWeapon)>=5 and not AuraUtil.FindAuraByName("Ghost Wolf", "player") then
            return S.HealingWave:Cast()
        end

        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false -- ninja icon tga file location
    end -- end of out of combat rotation



    end --end of local APL

GriphRH.Rotation.SetAPL(7, APL);
