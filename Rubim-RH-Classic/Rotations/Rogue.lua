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


RubimRH.Spell[4] = {
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
    Mutilate = Spell(1329),
    Shadowstrike = Spell(399985),

  
    chestrune = Spell(20580), --GGL bind shadowmeld -- BP macro quick draw
    beltrune = Spell(20554), -- GGL bind berserking -- BP macro shadowstep, shuriken toss, 
    legrune = Spell(921), -- GGL bind pick pocket -- BP macro between the eyes, blade dance, envenom
    handrune = Spell(20594), --GGL bind stone form - BP macro mutilate, shadowstrike, saber slash, main gauche, shiv.
    
};
local S = RubimRH.Spell[4]

if not Item.Rogue then
    Item.Rogue = {}
end

Item.Rogue = {

    trinket = Item(28288, { 13, 14 }),
    trinket2 = Item(25628, { 13, 14 }),
    autoattack = Item(135274, { 13, 14 }),
};

local I = Item.Rogue;


-- S.BladeFlurry.TextureSpellID =  {58749} --nature resist totem
-- S.AdrenalineRush.TextureSpellID  = {16166} --elemental mastery
-- S.HungerforBlood.TextureSpellID = {25464} --frost shock
-- S.SinisterStrike.TextureSpellID = {30706} --totem of wrath
-- S.KillingSpree.TextureSpellID = {33697} -- Blood Fury
-- -- I.trinket.TextureSpellID = {26296} -- berserking
-- S.Evasion.TextureSpellID = {8143} --tremor totem
-- S.tott.TextureSpellID = {131} -- water walking
-- S.Blind.TextureSpellID = {16342} --flametongue weapon
-- S.CloakofShadows.TextureSpellID = {2062} --earth elemental totem
-- S.Distract.TextureSpellID = {2894} --fire elemental totem
-- S.Mutilate.TextureSpellID = {25420} --lesser healing wave
-- S.Stealth.TextureSpellID = {25547} --fire nova totem
-- S.ColdBlood.TextureSpellID = {8177} --grounding totem
-- S.CheapShot.TextureSpellID = {25560} --Frost resist totem
-- S.DeadlyThrow.TextureSpellID = {25557} --flametongue totem
-- S.Envenom.TextureSpellID = {25457} --flame shock
-- S.Eviscerate.TextureSpellID = {25442} --chain lightning
-- S.ExposeArmor.TextureSpellID = {25563} --fire resist totem
-- S.Garrote.TextureSpellID = {25359} --grace of air totem
-- S.KidneyShot.TextureSpellID = {25567} --healing stream totem
-- S.Rupture.TextureSpellID = {25449} -- lightning bolt
-- S.SnD.TextureSpellID = {2825} -- bloodlust
-- S.Feint.TextureSpellID = {25525} --stoneclaw totem
-- S.Kick.TextureSpellID = {8044} --earthshock
-- S.Gouge.TextureSpellID = {25509} --stoneskin totem
-- S.WilloftheForsaken.TextureSpellID = {59547} --gift of naaru
-- S.Vanish.TextureSpellID = {45528} --ghost wolf
-- S.FanofKnives.TextureSpellID = {25423} --chain heal
-- --S.ColdBlood.TextureSpellID = {135863} --natures swiftness



local function DungeonBoss()
	local guid = UnitGUID('target')
	if guid then
		local unit_type = strsplit("-", guid)
		if not UnitIsPlayer('target') and Player:CanAttack(Target) then
			local _, _, _, _, _, npc_id = strsplit("-", guid)
			npcid = npc_id
		end
	end
	
	if (npcid == '24201' or npcid == '23954' or npcid == '23953' or npcid == '24200') then --Mark - Look up boss ID and put here
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
   




-- print(targetTTD)
  
    local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

    local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

    local channelTime = elapsedTimech / 1000

    local castTime = elapsedTimeca / 1000

    local castchannelTime = math.random(275, 500) / 1000


    -- print(aoeTTD())


    if Player:IsCasting() or Player:IsChanneling() then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
    elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player")
        or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
    end

    --    print(Player:BuffRemains(S.SliceandDice) < 3)

    -- local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
    -- if hasMainHandEnchant ~= true then
    -- mhenchantremains = 0
    -- elseif hasMainHandEnchant == true then
    -- mhenchantremains = mainHandExpiration*0.001
    -- end
    -- if hasOffHandEnchant ~= true then
    -- ohenchantremains = 0
    -- elseif hasOffHandEnchant == true then
    -- ohenchantremains = offHandExpiration*0.001
    -- end
    if inRange25 == 0 then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Gouge:ID() and (S.Gouge:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.BladeFlurry:ID() and (S.BladeFlurry:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.KidneyShot:ID() and (S.KidneyShot:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Kick:ID() and (S.Kick:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Distract:ID() and (S.Distract:CooldownRemains() > Player:GCD() or not Player:AffectingCombat()) then
        RubimRH.queuedSpell = { RubimRH.Spell[4].Default, 0 }
    end

    if RubimRH.QueuedSpell():ID() == S.Gouge:ID() and Player:Energy()> 35 and CheckInteractDistance("target", 3) then
        return RubimRH.QueuedSpell():Cast()
    end

    if RubimRH.QueuedSpell():ID() == S.KidneyShot:ID() and not Target:Debuff(S.CheapShot) and Player:ComboPoints()>=1 and Player:Energy()> 15 and CheckInteractDistance("target", 3) then
        return RubimRH.QueuedSpell():Cast()
    end

    if RubimRH.QueuedSpell():ID() == S.Kick:ID() and Player:Energy()> 15 and CheckInteractDistance("target", 3) then
        return RubimRH.QueuedSpell():Cast()
    end

    if RubimRH.QueuedSpell():ID() == S.Distract:ID() then
        return RubimRH.QueuedSpell():Cast()
    end

    if RubimRH.QueuedSpell():ID() == S.BladeFlurry:ID() then
        return RubimRH.QueuedSpell():Cast()
    end


    if Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") and AuraUtil.FindAuraByName("Stealth", "player") and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then -- In combat
        if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) then
            return I.autoattack:ID()
        end

            if IsReady('Adrenaline Rush') and RubimRH.CDsON() and CheckInteractDistance("target", 3) and finish then
            return S.AdrenalineRush:Cast()
        end

        if IsReady('Slice and Dice') and aoeTTD()>1 and (not AuraUtil.FindAuraByName("Slice and Dice", "player") or SnDbuffremains<3 and inRange25>1) and CheckInteractDistance("target", 3) and (finish or Player:ComboPoints()>=1 and (HL.CombatTime()<5 or not AuraUtil.FindAuraByName("Slice and Dice", "player"))) then
            return S.SliceandDice:Cast()
        end

        if IsReady('Blade Dance') and not DungeonBoss() and aoeTTD()>1 and (not AuraUtil.FindAuraByName("Blade Dance", "player") or BDbuffremains<3 and inRange25>1) and CheckInteractDistance("target", 3) and (finish or Player:ComboPoints()>=1 and (HL.CombatTime()<5 or not AuraUtil.FindAuraByName("Blade Dance", "player"))) then
            return S.legrune:Cast()
        end

        if IsReady('Envenom') and not AuraUtil.FindAuraByName("Envenom", "player")  and CheckInteractDistance("target", 3) and finish then
            return S.legrune:Cast()
        end

        if IsReady('Between the Eyes') and finish and (inRange25==1 or targetRange30) then
            return S.legrune:Cast()
        end

        if IsReady('Eviscerate') and inRange25==1 and finish and CheckInteractDistance("target", 3) then
            return S.Eviscerate:Cast()
        end

        if IsReady('Shuriken Toss') and inRange25>4 and CheckInteractDistance("target", 3) and not Player:Buff(S.BladeFlurry) and  Player:ComboPoints() < 5 then
            return S.beltrune:Cast()
        end

        if IsReady('Backstab') and not IsReady('Mutilate') and CheckInteractDistance("target", 3) and not Player:IsTanking(Target) then
            return S.Backstab:Cast()
        end

        if  IsReady('Quick Draw') and (inRange25==1 or targetRange30) and Player:ComboPoints() < 5 then
            return S.handrune:Cast()
        end

        if IsReady('Mutilate') and CheckInteractDistance("target", 3) and Player:ComboPoints() <5 then
            return S.handrune:Cast()
        end

        if  IsReady('Main Gauche') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
            return S.handrune:Cast()
        end

        if IsReady('Shiv') and CheckInteractDistance("target", 3) and Player:ComboPoints() <5 then
            return S.handrune:Cast()
        end

        if  IsReady('Saber Slash') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
            return S.handrune:Cast()
        end

        if IsReady('Sinister Strike') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
            return S.SinisterStrike:Cast()
        end

    end
  --     -- Out of combat

    if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
       
        if Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost()  then
          

          
            if IsReady('Ambush') and CheckInteractDistance("target", 3) then
                return S.Ambush:Cast()
            end

            if IsReady('Shadowstrike') and AuraUtil.FindAuraByName("Stealth", "player") and (inRange25 >=1 or targetRange30) then
                return S.handrune:Cast()
            end

            if IsReady('Mutilate') and CheckInteractDistance("target", 3) and Player:ComboPoints() <=4 then
                return S.handrune:Cast()
            end

            if  IsReady('Main Gauche') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
                return S.handrune:Cast()
            end

            if  IsReady('Saber Slash') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
                return S.handrune:Cast()
            end
    
            if IsReady('Sinister Strike') and CheckInteractDistance("target", 3) and Player:ComboPoints() < 5 then
                return S.SinisterStrike:Cast()
            end

            if not IsCurrentSpell(6603) and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Stealth", "player")  then
                return I.autoattack:ID()
            end

        end
        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
    end



    return 135328
end

RubimRH.Rotation.SetAPL(4, APL);
