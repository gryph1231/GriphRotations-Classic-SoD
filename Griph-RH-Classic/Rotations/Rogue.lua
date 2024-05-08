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
    Garrote = Spell(703),
    KidneyShot = Spell(408),
    Rupture = Spell(1943),
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

local BehindTimer = GetTime() - BehindCheckTimer
local FrontTimer = GetTime() - FrontCheckTimer
local Behind
local Front

if BehindTimer < Player:GCD() then
	Behind = false
end

if FrontTimer < Player:GCD() then
	Front = false
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
local namehonoramongthieves = GetSpellInfo('Honor Among Thieves')

local namecuttothechase = GetSpellInfo('Cut to the Chase')
local namemasterofsublety = GetSpellInfo('Master of Sublety')
local namequickdraw = GetSpellInfo('Quick Draw')
local namecarnage = GetSpellInfo('Carnage')
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

    local targetttd20= (aoeTTD()>20 or UnitHealth('target')>2500 or Target:IsAPlayer() and Target:HealthPercentage()>75)
    local targetttd10= (aoeTTD()>10 or UnitHealth('target')>2250 or Target:IsAPlayer() and Target:HealthPercentage()>65 and Target:HealthPercentage()<=75)
    local targetttd8= (aoeTTD()>8 or UnitHealth('target')>2000 or Target:IsAPlayer() and Target:HealthPercentage()>55 and Target:HealthPercentage()<=65)
    local targetttd6= (aoeTTD()>6 or UnitHealth('target')>1750 or Target:IsAPlayer() and Target:HealthPercentage()<=55)
    local targetttd3= (aoeTTD()>3 or Target:IsAPlayer() and Target:HealthPercentage()<20)

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

    if GriphRH.QueuedSpell():ID() == S.Gouge:ID() and Player:Energy()> 35 and targetrange11() then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.KidneyShot:ID() and not Target:Debuff(S.CheapShot) and Player:ComboPoints()>=1 and Player:Energy()> 15 and targetrange11() then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Backstab:ID() and targetrange11() then
        return GriphRH.QueuedSpell():Cast()
    end
    if GriphRH.QueuedSpell():ID() == S.Kick:ID() and Player:Energy()> 15 and targetrange11() then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.Distract:ID() then
        return GriphRH.QueuedSpell():Cast()
    end

    if GriphRH.QueuedSpell():ID() == S.BladeFlurry:ID() then
        return GriphRH.QueuedSpell():Cast()
    end

    local GetItemCooldown =  (C_Container and C_Container.GetItemCooldown(7676)) or 0

    if 300-GetTime()+GetItemCooldown<=0 then
        thistleteaoffcooldown = true
    else
        thistleteaoffcooldown=false
    end

    if AuraUtil.FindAuraByName("Deadly Poison","target","PLAYER|HARMFUL") then
        deadlypoisonstack =select(3,AuraUtil.FindAuraByName("Deadly Poison","target","PLAYER|HARMFUL"))
    elseif AuraUtil.FindAuraByName("Deadly Poison II","target","PLAYER|HARMFUL") then 
        deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison II","target","PLAYER|HARMFUL"))
    elseif AuraUtil.FindAuraByName("Deadly Poison III","target","PLAYER|HARMFUL") then 
        deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison III","target","PLAYER|HARMFUL"))
    elseif AuraUtil.FindAuraByName("Deadly Poison IV","target","PLAYER|HARMFUL") then 
        deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison IV","target","PLAYER|HARMFUL"))
    elseif AuraUtil.FindAuraByName("Deadly Poison V","target","PLAYER|HARMFUL") then 
        deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison V","target","PLAYER|HARMFUL"))
    elseif AuraUtil.FindAuraByName("Deadly Poison VI","target","PLAYER|HARMFUL") then 
        deadlypoisonstack = select(3,AuraUtil.FindAuraByName("Deadly Poison VI","target","PLAYER|HARMFUL"))
    else
        deadlypoisonstack = 0
    end


    if AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL") then
        rupturedebuff = select(6,AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")) - GetTime()
         else
            rupturedebuff = 0 
        end
        if AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL") and namecarnage =='Carnage' then
            carnagedebuff = select(6,AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL")) - GetTime()
              else
                 carnageedebuff = 0 
             end

        if AuraUtil.FindAuraByName("Garrote","target","PLAYER|HARMFUL") then
           garrotedebuff = select(6,AuraUtil.FindAuraByName("Garrote","target","PLAYER|HARMFUL")) - GetTime()
             else
                garrotedebuff = 0 
            end

            -- print('rupturetime:',rupturedebuff)
            -- print('garrootetime:',garrotedebuff)
            -- print('is garrote castable:',IsReady('Garrote'))

            if namehonoramongthieves == 'Honor Among Thieves' and
                 (Player:ComboPoints()<=1   
                or
                 Player:Energy()>=70 and (S.AdrenalineRush:IsAvailable() and AuraUtil.FindAuraByName("Adrenaline Rush", "player") and Player:Energy()>=50
                        or EnergyTimeToNextTick()<1
                        or namemasterofsublety =='Master of Sublety' and AuraUtil.FindAuraByName("Master of Sublety", "player") and Player:ComboPoints()<=3)
                or targetttd6) then
                            

                            build = true
                        else
                            build = false
                        end
              

             
                        if AuraUtil.FindAuraByName("Divine Protection","target") 
                        or AuraUtil.FindAuraByName("Ice Block","target") 
                        or AuraUtil.FindAuraByName("Blessing of Protection","player") 
                        or AuraUtil.FindAuraByName("Blessing of Protection","target") 
                        or AuraUtil.FindAuraByName("Invulnerability","target") 
                        or AuraUtil.FindAuraByName("Dispersion","target") then
                            stoprotation = true
                        else
                            stoprotation = false
                        end


                

    if Player:AffectingCombat() and not AuraUtil.FindAuraByName("Stealth", "player") and not AuraUtil.FindAuraByName("Drink", "player") 
    and not AuraUtil.FindAuraByName("Food", "player") and (not AuraUtil.FindAuraByName("Vanish", "player") or AuraUtil.FindAuraByName("Cold Blood", "player")) and not AuraUtil.FindAuraByName("Food & Drink", "player")
    and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then -- In combat
        if not IsCurrentSpell(6603) and targetrange11() then
            return I.autoattack:ID()
        end

        if stoprotation == false then 


        if S.Kick:CooldownRemains()<2 and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and targetrange11() and GriphRH.InterruptsON() then
            return S.Kick:Cast()
        end


        if IsReady('Adrenaline Rush') and GriphRH.CDsON() and targetrange11() then
            return S.AdrenalineRush:Cast()
        end

        if (UnitName('target') == "STX-25/NB" and GriphRH.InterruptsON() and Player:Energy()>55 or not GriphRH.InterruptsON() or UnitName('target') ~= "STX-25/NB") then 
        if Player:Energy()<20 and UnitHealthMax('target')>100000 and IsUsableItem(7676)==true and thistleteaoffcooldown==true and GetItemCount(7676) >= 1 and GriphRH.CDsON() then
        return  S.ThistleTea:Cast()
        end 


        if IsReady('Gouge') and Behind == false and Target:IsAPlayer() and targetrange11() and HL.CombatTime()<3 then
            return S.Gouge:Cast()
        end

        if IsReady('Kidney Shot') and Player:ComboPoints()>=4 and Target:IsAPlayer() and targetrange11() then
            return S.KidneyShot:Cast()
        end
        if IsReady('Between the Eyes') and Player:ComboPoints()>=4 and Target:IsAPlayer() and targetrange11() then
            return S.legrune:Cast()
        end
 

        if IsReady('Rupture') and UnitCreatureType("target") ~= "Elemental" and not AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")  
        and namecarnage == 'Carnage' and (not AuraUtil.FindAuraByName("Carnage","target","PLAYER|HARMFUL")  
        or  rupturedebuff <1  
        or garrotedebuff<1.5 )
        and Player:ComboPoints()>=3 and targetttd8 then
            return S.Rupture:Cast()
        end

        if IsReady("Slice and Dice") and namecuttothechase == 'Cut to the Chase' and not AuraUtil.FindAuraByName("Slice and Dice", "player") and Player:ComboPoints()>=1 and (targetttd10 or inRange25>1 and aoeTTD()>5) then
            return S.SliceandDice:Cast()
        end
        if  IsReady("Slice and Dice") and namecuttothechase ~= 'Cut to the Chase' and SnDbuffremains<1 and Player:ComboPoints()>=3 and (HL.CombatTime()<3 or targetttd20 or inRange25>1 and aoeTTD()>5) then
            return S.SliceandDice:Cast()
        end
        
        if IsReady('Slice and Dice') and not AuraUtil.FindAuraByName("Cold Blood", "player") and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or SnDbuffremains<2 and inRange25>1) and targetrange11() and finish then
            return S.SliceandDice:Cast()
        end

        if IsReady('Blade Dance') and (isTanking == true or not Target:IsCasting() or inRange25>1) and not DungeonBoss() and aoeTTD()>3 and (not AuraUtil.FindAuraByName("Blade Dance", "player") or BDbuffremains<3 and inRange25>1) and targetrange11() and (finish or Player:ComboPoints()>=2 and (HL.CombatTime()<5 and not AuraUtil.FindAuraByName("Blade Dance", "player"))) then
            return S.legrune:Cast()
        end

        if IsReady('Vanish') and namemasterofsublety =='Master of Sublety' and deadlypoisonstack>=1 and GriphRH.CDsON() and IsReady('Envenom') and Player:ComboPoints()>=5 and targetrange11() and not AuraUtil.FindAuraByName("Master of Sublety", "player") then
            return S.Vanish :Cast()
        end

        if IsReady('Cold Blood') and GriphRH.CDsON() and deadlypoisonstack>=1 and finish and targetrange11() then
            return S.ColdBlood:Cast()
        end
      
      
        if IsReady('Envenom') and deadlypoisonstack>=1 and AuraUtil.FindAuraByName("Cold Blood", "player") and targetrange11() and finish then
            return S.legrune:Cast()
        end
        if IsReady('Envenom') and deadlypoisonstack>=1 and namehonoramongthieves~= 'Honor Among Thieves' and targetrange11() and Player:ComboPoints()>=4 then
            return S.legrune:Cast()
        end
        if IsReady('Envenom') and deadlypoisonstack>=1 and namehonoramongthieves== 'Honor Among Thieves' and targetrange11() and (Player:ComboPoints()>=5 or Player:ComboPoints()>=4 and Player:Energy()>=70) then
            return S.legrune:Cast()
        end
        if IsReady('Envenom') and targetrange11() and (Player:ComboPoints()>=3 and targetttd3 and deadlypoisonstack >=3) then
            return S.legrune:Cast()
        end


        if IsReady('Envenom') and targetrange11() and finish and deadlypoisonstack>=1 then
            return S.legrune:Cast()
        end

        if IsReady('Between the Eyes') and finish and (inRange25==1 or targetRange30) then
            return S.legrune:Cast()
        end

        if IsReady('Riposte') and AuraUtil.FindAuraByName("Blade Dance", "player") and targetrange11() then
            return S.Riposte:Cast()
        end

        if IsReady('Eviscerate') and targetrange11() and Player:ComboPoints()>=5 then
            return S.Eviscerate:Cast()
        end

        if IsReady('Shuriken Toss') and inRange25>4 and targetrange11() and not Player:Buff(S.BladeFlurry) and  Player:ComboPoints() < 5 then
            return S.beltrune:Cast()
        end
 

        if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
            return S.handrune:Cast()
        end

        if IsReady('Mutilate') and targetrange11() and Player:ComboPoints() <5 and namemutilate == 'Mutilate' and (build == true or namehonoramongthieves ~= 'Honor Among Thieves') then
            return S.handrune:Cast()
        end

        if  IsReady('Main Gauche') and targetrange11() and Player:ComboPoints() <=2 and namemainguache == 'Main Guache' then
            return S.handrune:Cast()
        end

        if IsReady('Shiv') and targetrange11() and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
            return S.handrune:Cast()
        end

        if  IsReady('Saber Slash') and targetrange11() and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' and (build == true or namehonoramongthieves ~= 'Honor Among Thieves') then
            return S.handrune:Cast()
        end

        if IsReady('Backstab') and namemutilate ~= 'Mutilate' and targetrange11() and not Player:IsTanking(Target) and Behind ~= false then
            return S.Backstab:Cast()
        end

        if IsReady('Sinister Strike') and targetrange11() and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
            return S.SinisterStrike:Cast()
        end
    end
    end
   

    end
  --     -- Out of combat

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
       
        if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
          
            if IsReady('Envenom') and deadlypoisonstack>=1 and AuraUtil.FindAuraByName("Cold Blood", "player") and targetrange11() and finish then
                return S.legrune:Cast()
            end
            if IsReady('Stealth') and targetrange11() and namecarnage == 'Carnage' then
                return S.Stealth:Cast()
            end

            if IsReady('Cheap Shot') and Target:IsAPlayer() and targetrange11() then
                return S.CheapShot:Cast()
            end

            if IsReady('Garrote') and UnitCreatureType("target") ~= "Elemental" and targetrange11() and namecarnage == 'Carnage' and Behind ~= false then
                return S.Garrote:Cast()
            end

            if IsReady('Ambush') and targetrange11() and namemutilate ~='mutilate' then
                return S.Ambush:Cast()
            end

            if IsReady('Shadowstrike') and AuraUtil.FindAuraByName("Stealth", "player") and (inRange25 >=1 or targetRange30) then
                return S.handrune:Cast()
            end

            if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 and namequickdraw == 'Quick Draw'  then
                return S.handrune:Cast()
            end

            if  IsReady('Mutilate') and targetrange11() and Player:ComboPoints() <4 and namemutilate == 'Mutilate' then
                return S.handrune:Cast()
            end
    
    
            if  IsReady('Main Gauche') and targetrange11() and Player:ComboPoints() < 5 and namemainguache == 'Main Guache' then
                return S.handrune:Cast()
            end
    
            if IsReady('Shiv') and targetrange11() and Player:ComboPoints() <5 and nameshiv == 'Shiv' then
                return S.handrune:Cast()
            end
    
            if  IsReady('Saber Slash') and targetrange11() and Player:ComboPoints() < 5 and namesaberslash == 'Saber Slash' then
                return S.handrune:Cast()
            end
    
            if IsReady('Sinister Strike') and targetrange11() and Player:ComboPoints() < 5 and (namesaberslash ~= 'Saber Slash' and namemutilate ~= 'Mutilate') then
                return S.SinisterStrike:Cast()
            end

            if not IsCurrentSpell(6603) and targetrange11() and not AuraUtil.FindAuraByName("Stealth", "player")  then
                return I.autoattack:ID()
            end

        end

        return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
    end



    return 135328
end

GriphRH.Rotation.SetAPL(4, APL);
