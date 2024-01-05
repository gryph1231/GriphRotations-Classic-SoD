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
        SealoftheCrusaderDebuff = Spell(20300),

        SealoftheCrusader = Spell(20305),
FrostRA = Spell(27152),
FireRA = Spell(27153),
Consecration = Spell(26573),
ArcaneTorrent = Spell(28730),
RighteousFury = Spell(25780),
SealofCommand = Spell(20375),
SealofRighteousness = Spell(21084),
Exorcism = Spell(415068),
Judgement = Spell(20271),
BlessingofMight = Spell(19740),
DivineProtection = Spell(498),
BlessingofProtection = Spell(1022),
HammerofJustice = Spell(5588),
Forbearance = Spell(25771),
LayonHands = Spell(633),
RetributionAura = Spell(7294),
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
impblessingofmight = Spell(20048),
HolyWrath = Spell(27139),
GreaterBlessingofWisdom = Spell(25894),
GreaterBlessingofMight = Spell(27141),
trinket = Spell(28880),
AvengingWrath = Spell(31884),
gloverune = Spell(20594), --stoneform -- crusader strike and hand of reckoning
chestrune = Spell(5502),--sense undead -- divine storm and seal of martyrdom
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





local function APL()

    -- local start, duration = GetSpellCooldown(61304) -- 61304 is a dummy spell used to represent the GCD


        inRange10 = RangeCount("Judgement")
        targetRange10 = TargetInRange("Judgement")


        local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i)  then
                inRange25 = inRange25 + 1
            end
        end

        TTDlong =  UnitHealth('target')>5000
        nextauto = math.max(0, (RubimRH.lasthit()-UnitAttackSpeed('player'))*-1)


     if AuraUtil.FindAuraByName("Seal of the Crusader", "player") then
        sealbuffremains = select(6,AuraUtil.FindAuraByName("Seal of the Crusader","player","PLAYER")) - GetTime()
         elseif AuraUtil.FindAuraByName("Seal of Command", "player") then
        sealbuffremains = select(6,AuraUtil.FindAuraByName("Seal of Command","player","PLAYER"))- GetTime()
         elseif AuraUtil.FindAuraByName("Seal of Righteousness", "player") then
        sealbuffremains = select(6,AuraUtil.FindAuraByName("Seal of Righteousness","player","PLAYER"))- GetTime()
         elseif AuraUtil.FindAuraByName("Seal of Martyrdom", "player") then
        sealbuffremains = select(6,AuraUtil.FindAuraByName("Seal of Martyrdom","player","PLAYER"))- GetTime()
         else
            sealbuffremains = 0 
        end


-- print(S.impblessingofmight:IsAvailable())
if inRange10==0 and AuraUtil.FindAuraByName("Forbearance","player","PLAYER|HARMFUL") 
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
	
	if Player:IsCasting() or Player:IsChanneling() or AuraUtil.FindAuraByName("First Aid", "player") then
		return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
	elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player")  then
		return "Interface\\Addons\\Rubim-RH-Classic\\Media\\prot.tga", false
	end 
	
-- print('next auto',nextauto)

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


   
    if IsReady("Blessing of Wisdom") and not S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and Player:IsMoving() then
        return S.BlessingofWisdom:Cast()
    end

    if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and IsEquippedItemType("Shields") then
        return S.DevotionAura:Cast()
    end

    if IsReady("Retribution Aura") and not AuraUtil.FindAuraByName("Retribution Aura", "player") and not IsEquippedItemType("Shields") then
        return S.RetributionAura:Cast()
    end

    if IsReady("Blessing of Might") and S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Might", "player") and Player:IsMoving() then
        return S.BlessingofMight:Cast()
    end


    if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 

        if not IsCurrentSpell(6603) and targetRange10 then
            return I.autoattack:ID()
            end
        
            
            if IsReady("Avenger's Shield") and RubimRH.CDsON() and targetRange10  then
                return S.AvengersShield:Cast()
            end
    
            if IsReady("Crusader Strike") and IsActionInRange(61) and (sealbuffremains> GCDRemaining()+0.15 or sealbuffremains==0 and Player:ManaPercentage()<10) then
                return S.gloverune:Cast()
            end
    
            if IsReady("Divine Storm") and IsActionInRange(61) and sealbuffremains> GCDRemaining()+0.15 then
                return S.chestrune:Cast()
            end
    
      
        
            if IsReady("Judgement")
            and RubimRH.CDsON() and 
            (
                nextauto+0.15>GCDRemaining()
            or TTDlong and not Target:Debuff(S.SealoftheCrusaderDebuff) and AuraUtil.FindAuraByName("Seal of the Crusader","player","PLAYER")
            )
            and targetRange10 then
                return S.Judgement:Cast()
            end
    
            if sealbuffremains<Player:GCD()+nextauto + 0.15 then 
    
                if IsReady("Seal of the Crusader") 
                and TTDlong
                and not Target:Debuff(S.SealoftheCrusaderDebuff) then
                    return S.SealoftheCrusader:Cast()
                end
        
                if IsReady("Seal of Command") then
                    return S.SealofCommand:Cast()
                end
        
                if IsReady("Seal of Martyrdom") then
                    return S.chestrune:Cast()
                end
                
                if IsReady("Seal of Righteousness") then
                    return S.SealofRighteousness:Cast()
                end
    
                end
    
    
    
            if IsReady('Exorcism') and targetRange10 
            and Target:AffectingCombat() and RubimRH.CDsON() 
            and Target:Exists() 
            and Player:CanAttack(Target) 
             then
               return S.Exorcism:Cast()
            end
    
                
     
                if IsReady("Consecration") and IsActionInRange(61) and not Player:IsMoving() then
                    return S.Consecration:Cast()
                end
    
            end


	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\prot.tga", false
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------IN COMBAT ROTATION--------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    if Player:AffectingCombat() then
       
        if IsReady("Righteous Fury") and not AuraUtil.FindAuraByName("Righteous Fury", "player") 
         and IsEquippedItemType("Shield") 
        then
            return S.RighteousFury:Cast()
        end
    
        if Player:HealthPercentage()<20 and IsReady("Lay on Hands") and not AuraUtil.FindAuraByName("Divine Protection", "player") then
        return S.LayonHands:Cast()
       end
       
        if IsReady("Blessing of Wisdom") and not S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player")  and Player:IsMoving() and not  AuraUtil.FindAuraByName("Blessing of Protection", "player") then
            return S.BlessingofWisdom:Cast()
        end
    
        if IsReady("Devotion Aura") and not AuraUtil.FindAuraByName("Devotion Aura", "player") and IsEquippedItemType("Shields") then
            return S.DevotionAura:Cast()
        end
    
        if IsReady("Retribution Aura") and not AuraUtil.FindAuraByName("Retribution Aura", "player") and not IsEquippedItemType("Shields") then
            return S.RetributionAura:Cast()
        end
    
        if IsReady("Blessing of Might") and S.impblessingofmight:IsAvailable() and not AuraUtil.FindAuraByName("Blessing of Wisdom", "player") and not AuraUtil.FindAuraByName("Blessing of Might", "player") and Player:IsMoving() and not  AuraUtil.FindAuraByName("Blessing of Protection", "player") then
            return S.BlessingofMight:Cast()
        end
    
    
        if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then 

          
        if not IsCurrentSpell(6603) and targetRange10 then
            return I.autoattack:ID()
            end
        
            
            if IsReady("Avenger's Shield") and RubimRH.CDsON() and targetRange10  then
                return S.AvengersShield:Cast()
            end
    
            if IsReady("Crusader Strike") and IsActionInRange(61) and (sealbuffremains> GCDRemaining()+0.15 or sealbuffremains==0 and Player:ManaPercentage()<10) then
                return S.gloverune:Cast()
            end
    
            if IsReady("Divine Storm") and IsActionInRange(61) and sealbuffremains> GCDRemaining()+0.15 then
                return S.chestrune:Cast()
            end
    
      
        
            if IsReady("Judgement")
            and RubimRH.CDsON() and  
            (
                nextauto+0.15>GCDRemaining()
            or TTDlong and not Target:Debuff(S.SealoftheCrusaderDebuff) and AuraUtil.FindAuraByName("Seal of the Crusader","player","PLAYER")
            )
            and targetRange10 then
                return S.Judgement:Cast()
            end
    
            if sealbuffremains<Player:GCD()+nextauto + 0.15 then 
    
                if IsReady("Seal of the Crusader") 
                and TTDlong
                and not Target:Debuff(S.SealoftheCrusaderDebuff) then
                    return S.SealoftheCrusader:Cast()
                end
        
                if IsReady("Seal of Command") then
                    return S.SealofCommand:Cast()
                end
        
                if IsReady("Seal of Martyrdom") then
                    return S.chestrune:Cast()
                end
                
                if IsReady("Seal of Righteousness") then
                    return S.SealofRighteousness:Cast()
                end
    
                end
    
    
    
            if IsReady('Exorcism') and IsActionInRange(62)
            and Target:AffectingCombat() and RubimRH.CDsON()  
            and Target:Exists() 
            and Player:CanAttack(Target) 
             then
               return S.Exorcism:Cast()
            end
    
                
     
                if IsReady("Consecration") and IsActionInRange(61) and not Player:IsMoving() then
                    return S.Consecration:Cast()
                end
    
            end


return 135328


end
end



RubimRH.Rotation.SetAPL(2, APL);


