local addonName, addonTable = ...;
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;
local Nameplate = Unit.Nameplate;


GriphRH.Spell[4] = {
    Evasion = Spell(5277),
    EnvenomBuff = Spell(399963),
    Envenom = Spell(399963),
    DeadlyPoisonDebuff = Spell(434312),
    SliceandDice = Spell(5171),
    Default = Spell(1),
    Blind = Spell(2094),
    CloakofShadows = Spell(31224),
    Distract = Spell(1725),
    Sap = Spell(11297),
    Stealth = Spell(1784),
    Vanish = Spell(26889),
    Ambush = Spell(8724),
    CheapShot = Spell(1833),
    DeadlyThrow = Spell(48674),
    DeadlyPoison = Spell(27187),
    Eviscerate = Spell(6761),
    ExposeArmor = Spell(26866),
    Garrote = Spell(48676),
    KidneyShot = Spell(408),
    Rupture = Spell(48672),
    SnD = Spell(6774),
    Backstab = Spell(53),
    Feint = Spell(48659),
    tott = Spell(57934),
    Gouge = Spell(1776),
    Kick = Spell(1766),
    Shiv = Spell(5938),
    SinisterStrike = Spell(1757),
    Sprint = Spell(11305),
    WilloftheForsaken = Spell(7744),
    AdrenalineRush = Spell(13750),
    BladeFlurry = Spell(13877),
    KillingSpree = Spell(51690),
    FanofKnives = Spell(51723),
    ColdBlood = Spell(14177),
    HungerforBlood = Spell(51662),
    HungerforBloodBuff = Spell(63848),
    Mutilate = Spell(399956),
    Shadowstrike = Spell(399985),
    Riposte = Spell(14251),
    BladeDance = Spell(400012),
    WidgetVolley = Spell(436833), --gnomer kick tracking widget volley spell

    chestrune = Spell(20580), --GGL bind shadowmeld -- BP macro quick draw
    beltrune = Spell(20554), -- GGL bind berserking -- BP macro shadowstep, shuriken toss, 
    legrune = Spell(921), -- GGL bind pick pocket -- BP macro between the eyes, blade dance, envenom
    handrune = Spell(20594), --GGL bind stone form - BP macro mutilate, shadowstrike, saber slash, main gauche, shiv.

    ThistleTea = Spell(20589),--GGL escape artist

    
};
local S = GriphRH.Spell[4]

if not Item.Rogue then
    Item.Rogue = {}
end

Item.Rogue = {
thistletea = Item(7676),
    trinket = Item(28288, { 13, 14 }),
    trinket2 = Item(25628, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),
};

local I = Item.Rogue;




local function DungeonBoss()
	local guid = UnitGUID('target')
	if guid then
		local unit_type = strsplit("-", guid)
		if not UnitIsPlayer('target') and Player:CanAttack(Target) then
			local _, _, _, _, _, npc_id = strsplit("-", guid)
			npcid = npc_id
		end
	end
	
	if (npcid == '24201' or npcid == '23954' or npcid == '23953' or npcid == '24200') then
		DngBoss = true
	else
		DngBoss = false
	end
	
	return DngBoss
end







local function APL()
    inRange5 = RangeCount("Sinister Strike")

    targetRange5 = TargetInRange("Sinister Strike")
    targetRange30 = TargetInRange("Throw")
    --range checks with nameplate
    local inRange25 = 0
    for i = 1, 40 do
        if UnitExists('nameplate' .. i) then
            inRange25 = inRange25 + 1
        end
    end
    -- if Target:Exists() then
    --     return S.beltrune:Cast()
    -- end

if AuraUtil.FindAuraByName("Slice and Dice","player") then
    SnDbuffremains = select(6,AuraUtil.FindAuraByName("Slice and Dice","player","PLAYER"))- GetTime()
else
    SnDbuffremains = 0
end
if AuraUtil.FindAuraByName("Blade Dance","player") then
    BDbuffremains = select(6,AuraUtil.FindAuraByName("Blade Dance","player","PLAYER"))- GetTime()
else
    BDbuffremains = 0
end


if Target:Exists() and getCurrentDPS() and getCurrentDPS()>0 then
targetTTD = UnitHealth('target')/getCurrentDPS()
else targetTTD = 8888
end

    local targetdying = (aoeTTD() < 2.5 or targetTTD<2.5)

if targetdying and Player:ComboPoints()>=3 or Player:ComboPoints()>=4 then
    finish = true
else finish = false
end
   

local spellwidgetfort= UnitCastingInfo("target")
local namequickdraw = GetSpellInfo('Quick Draw')
local nameshiv = GetSpellInfo('Shiv')
local namemainguache = GetSpellInfo('Main Guache')
local namemutilate = GetSpellInfo(399956)
local namesaberslash = GetSpellInfo('Saber Slash')
local nameshadowstrike = GetSpellInfo('Shadowstrike')
-- print(namemutilate)
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
    local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

    local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
   
    local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)
    
    local channelTime = elapsedTimech / 1000

    local castTime = elapsedTimeca / 1000

    local castchannelTime = math.random(275, 500) / 1000


    
    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end


    if inRange25 == 0 then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Gouge:ID() and (S.Gouge:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.BladeFlurry:ID() and (S.BladeFlurry:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.KidneyShot:ID() and (S.KidneyShot:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Kick:ID() and (S.Kick:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end
    if GriphRH.QueuedSpell():ID() == S.Backstab:ID() and (Player:Energy()<60 or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Distract:ID() and (S.Distract:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        GriphRH.queuedSpell = { GriphRH.Spell[4].Default, 0 }
    end

    if GriphRH.QueuedSpell():ID() == S.Gouge:ID() and Player:Energy()> 35 and CheckInteractDistance("target", 3) then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.KidneyShot:ID() and not Target:Debuff(S.CheapShot) and Player:ComboPoints()>=1 and Player:Energy()> 15 and CheckInteractDistance("target", 3) then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Backstab:ID() and CheckInteractDistance("target", 3) then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Kick:ID() and Player:Energy()> 15 and CheckInteractDistance("target", 3) then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Distract:ID() then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.BladeFlurry:ID() then
        return GriphRH.QueuedSpell():Cast()
    end

    local GetItemCooldown =  (C_Container and C_Container.GetItemCooldown(7676)) or nil

    if 300-GetTime()+GetItemCooldown<=0 then
        thistleteaoffcooldown = true
    else
        thistleteaoffcooldown=false
    end


    if Player:AffectingCombat() and not AuraUtil.FindAuraByName("Stealth", "player") and not AuraUtil.FindAuraByName("Drink", "player") 
    and not AuraUtil.FindAuraByName("Food", "player") and not AuraUtil.FindAuraByName("Vanish", "player") and not AuraUtil.FindAuraByName("Food & Drink", "player")
    and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then -- In combat
        if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
            return I.autoattack:ID()
        end

        if S.Kick:CooldownRemains()<2 and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and CheckInteractDistance("target", 3) and GriphRH.InterruptsON() then
            return S.Kick:Cast()
        end


        if IsReady('Adrenaline Rush') and GriphRH.CDsON() and CheckInteractDistance("target", 3) then
            return S.AdrenalineRush:Cast()
        end

        if (UnitName('target') == "STX-25/NB" and GriphRH.InterruptsON() and Player:Energy()>25 or not GriphRH.InterruptsON() or UnitName('target') ~= "STX-25/NB") then 
        if Player:Energy()<20 and UnitHealthMax('target')>100000 and IsUsableItem(7676)==true and thistleteaoffcooldown==true and GetItemCount(7676) >= 1 and GriphRH.CDsON() then
        return  S.ThistleTea:Cast()
        end

        if IsReady('Blade Dance') and (isTanking == true or not Target:IsCasting() or inRange25>1) and not DungeonBoss() and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Blade Dance", "player") or BDbuffremains<3 and inRange25>1) and CheckInteractDistance("target", 3) and (finish or Player:ComboPoints()>=2 and (HL.CombatTime()<5 and not AuraUtil.FindAuraByName("Blade Dance", "player"))) then
            return S.legrune:Cast()
        end

        if IsReady('Slice and Dice') and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or SnDbuffremains<3 and inRange25>1) and CheckInteractDistance("target", 3) and (finish or Player:ComboPoints()>=2 and (HL.CombatTime()<5 and not AuraUtil.FindAuraByName("Slice and Dice", "player"))) then
            return S.SliceandDice:Cast()
        end

        if IsReady('Cold Blood') and GriphRH.CDsON() and finish and CheckInteractDistance("target", 3) and AuraUtil.FindAuraByName("Slice and Dice", "player") then
            return S.ColdBlood:Cast()
        end
      
        if IsReady('Envenom') and AuraUtil.FindAuraByName("Deadly Poison","target","PLAYER|HARMFUL") and CheckInteractDistance("target", 3) and finish then
            return S.legrune:Cast()
        end

        if IsReady('Between the Eyes') and finish and (inRange25==1 or targetRange30) then
            return S.legrune:Cast()
        end

        if IsReady('Riposte') and AuraUtil.FindAuraByName("Blade Dance", "player") and CheckInteractDistance("target", 3) then
            return S.Riposte:Cast()
        end

        if IsReady('Eviscerate') and inRange25==1 and finish and CheckInteractDistance("target", 3) and (AuraUtil.FindAuraByName("Envenom", "player") or not IsReady('Envenom')) then
            return S.Eviscerate:Cast()
        end

        if IsReady('Shuriken Toss') and inRange25>4 and CheckInteractDistance("target", 3) and not Player:Buff(S.BladeFlurry) and  Player:ComboPoints() < 5 then
            return S.beltrune:Cast()
        end
 

        if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
            return S.handrune:Cast()
        end

        if IsReady('Mutilate') and CheckInteractDistance("target", 3) and Player:ComboPoints() <5  then
            return S.handrune:Cast()
        end

        if  IsReady('Main Gauche') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and namemainguache == 'Main Guache' then
            return S.handrune:Cast()
        end

        if IsReady('Shiv') and CheckInteractDistance("target", 3) and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
            return S.handrune:Cast()
        end

        if  IsReady('Saber Slash') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' then
            return S.handrune:Cast()
        end

        if IsReady('Backstab') and namemutilate ~= 'Mutilate' and CheckInteractDistance("target", 3) and not Player:IsTanking(Target) then
            return S.Backstab:Cast()
        end

        if IsReady('Sinister Strike') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
            return S.SinisterStrike:Cast()
        end
    end
   

    end
  --     -- Out of combat

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
       
        if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and IsCurrentSpell(6603) then
          


            if IsReady('Ambush') and CheckInteractDistance("target", 3) then
                return S.Ambush:Cast()
            end

            if IsReady('Shadowstrike') and AuraUtil.FindAuraByName("Stealth", "player") and (inRange25 >=1 or targetRange30) then
                return S.handrune:Cast()
            end


            if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
                return S.handrune:Cast()
            end

            if S.Mutilate:CanCast() and CheckInteractDistance("target", 3) and Player:ComboPoints() <5 and namemutilate == 'Mutilate' then
                return S.handrune:Cast()
            end
    
    
            if  IsReady('Main Gauche') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and namemainguache == 'Main Guache' then
                return S.handrune:Cast()
            end
    
            if IsReady('Shiv') and CheckInteractDistance("target", 3) and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
                return S.handrune:Cast()
            end
    
            if  IsReady('Saber Slash') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' then
                return S.handrune:Cast()
            end
    
            if IsReady('Sinister Strike') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
                return S.SinisterStrike:Cast()
            end

            if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Stealth", "player")  then
                return I.autoattack:ID()
            end

        end

        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end



    return 135328
end

GriphRH.Rotation.SetAPL(4, APL);
