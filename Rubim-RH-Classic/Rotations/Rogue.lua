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
Default = Spell(1),
Blind = Spell(2094),
CloakofShadows = Spell(31224),
Distract = Spell(2836),
Sap = Spell(11297),
Stealth = Spell(1784),
Vanish = Spell(26889),
Ambush = Spell(48691),
CheapShot = Spell(1833),
DeadlyThrow = Spell(48674),
Envenom = Spell(57993),
DeadlyPoison = Spell(27187),
Eviscerate = Spell(48668),
ExposeArmor = Spell(26866),
Garrote = Spell(48676),
KidneyShot = Spell(8643),
Rupture = Spell(48672),
SnD = Spell(6774),
Backstab = Spell(48657),
Evasion = Spell(26669),
Feint = Spell(48659),
tott = Spell(57934),
Gouge = Spell(1776),
Kick = Spell(1766),
Shiv = Spell(5938),
SinisterStrike = Spell(48638), 
Sprint = Spell(11305),
WilloftheForsaken = Spell(7744),
AdrenalineRush = Spell(13750),
BladeFlurry = Spell(13877),
mainhandpoison_instant = Spell(6495), -- sentry totem
offhandpoison_instant = Spell(370), -- purge 
mainhandpoison_instant1 = Spell(25500), -- frostbrand weapon
offhandpoison_instant1 = Spell(8017), -- rockbiter weapon 
KillingSpree = Spell(51690),
FanofKnives = Spell(51723),
ColdBlood = Spell(14177),
SB = Spell(20777), -- ascestral spirit --/use [@player] Saronite Bomb
GTSC = Spell(20549), -- war stomp--/use [@player] Global Thermal Sapper Charge
trinket_gloves = Spell(52127), --water shield
HungerforBlood = Spell(51662),
HungerforBloodBuff = Spell(63848),
Mutilate = Spell(1329),

};
local S = RubimRH.Spell[4]

if not Item.Rogue then
    Item.Rogue = {}
end

    Item.Rogue = {
    trinket_gloves1 = Item(40496, { 10 }), --hyperspeed accelerators (using glove id) 
    SB = Item(41119), -- saronite bomb
    GTSC = Item(42641), -- global thermal sapper charge
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

    local function aoeTTD()
        local currHealth = {}
        local currHealthMax = {}
        local allGUID = {}
        local areaTTD = {}
        local count = 1
 
            for id = 1, 40 do
                local unitID = "nameplate" .. id
                if UnitCanAttack("player", unitID) and UnitAffectingCombat(unitID) 
                and ((UnitHealth(unitID) / UnitHealthMax(unitID)) * 100) < 100 then
                    if UnitGUID('Target') and UnitAffectingCombat('Target') then
                        currTarget = UnitGUID('Target')
                    end
                    table.insert(allGUID, UnitGUID(unitID))
                    table.insert(currHealth, UnitHealth(unitID))
                    table.insert(currHealthMax, UnitHealthMax(unitID))
                    if #currHealthMax >= 1 then
                        for id = 1, #currHealthMax do
                            dps = (currHealthMax[#currHealth] - currHealth[#currHealth]) / HL.CombatTime("nameplate" .. #currHealthMax)
                            areaTTD[#currHealthMax] = currHealth[#currHealth] / dps
                            end
                    end
                end
            end

            if #allGUID >= 1 and UnitGUID('Target') then 
                while(UnitGUID('Target') ~= allGUID[count]) do
                    count = count + 1
                    break
                end
            end

        if #currHealthMax >= 1 then
            return areaTTD[count]
        else
            return nil
        end

    end

    local function ruptureTime()
        local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL")

        if AuraUtil.FindAuraByName("Rupture","target","PLAYER|HARMFUL") then
            timer = expirationTime - HL.GetTime()
        else
            timer = 0
        end
            return timer
    end

    local function DungeonBoss()
        local guid = UnitGUID('target')
        if guid then
            local unit_type = strsplit("-", guid)
            if not UnitIsPlayer('target') and Player:CanAttack(Target) then
                local _, _, _, _, _, npc_id = strsplit("-", guid)
                npcid = npc_id
            end
        end

        if (npcid == '24201' or npcid == '23954' or npcid == '23953' or npcid == '24200' or npcid == '26763' or npcid == '26731' or npcid == '26723' 
        or npcid == '26794' or npcid == '29120' or npcid == '28921' or npcid == '28684' or npcid == '29309' or npcid == '29316' or npcid == '29311' 
        or npcid == '29310' or npcid == '29308' or npcid == '27483' or npcid == '26632' or npcid == '26630' or npcid == '31134' or npcid == '29266' 
        or npcid == '29314' or npcid == '29307' or npcid == '29932' or npcid == '29306' or npcid == '29305' or npcid == '29304' or npcid == '27977' 
        or npcid == '27975' or npcid == '27978' or npcid == '28586' or npcid == '28546' or npcid == '28923' or npcid == '28587' or npcid == '26532'
        or npcid == '32273' or npcid == '26533' or npcid == '26529' or npcid == '26530' or npcid == '27654' or npcid == '27656' or npcid == '27655' 
        or npcid == '27447' or npcid == '26687' or npcid == '26861' or npcid == '26693' or npcid == '26668' or npcid == '36497' or npcid == '36502'
        or npcid == '36494' or npcid == '36476' or npcid == '36477' or npcid == '36658' or npcid == '38112' or npcid == '38113' or npcid == '35119'
        or npcid == '34928' or npcid == '35451' or npcid == '24723' or npcid == '24664' or npcid == '24560' or npcid == '24744' or npcid == '29573') then
            DngBoss = true
        else
            DngBoss = false
        end
        return DngBoss
    end

local function APL()
--             DungeonBoss()
--             hstotal = GetItemCount('Minor Healthstone') + GetItemCount('Fel Healthstone') + GetItemCount('Lesser Healthstone') + GetItemCount('Demonic Healthstone') + GetItemCount('Master Healthstone') + GetItemCount('Major Healthstone') + GetItemCount('Greater Healthstone')
--             ass = S.HungerforBlood:IsAvailable()
--             comb = S.KillingSpree:IsAvailable()
--             aoeTTD()
--             ruptureTime()


--             if Target:Exists() and Player:CanAttack(Target) then
--                 mydps = ((UnitHealthMax('target')-UnitHealth('target'))/HL.CombatTime())
--                 STttd = Target:TimeToDie()
--                 if STttd>9999 then
--                     STttd = UnitHealth('target')/mydps
--                 end
--                 AOEttd = aoeTTD()
--                 if AOEttd == nil then
--                     AOEttd = STttd
--                 end
--             end

--             if Player:IsCasting() or Player:IsChanneling() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") then
--                 return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
--             end

--             local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
--             if hasMainHandEnchant ~= true then
--             mhenchantremains = 0
--             elseif hasMainHandEnchant == true then 
--             mhenchantremains = mainHandExpiration*0.001
--             end
--             if hasOffHandEnchant ~= true then
--             ohenchantremains = 0
--             elseif hasOffHandEnchant == true then 
--             ohenchantremains = offHandExpiration*0.001
--             end
 
-- KS_glyph = 63252 -- (socket 1 is top major glyph socket) 
-- SS_glyph = 56821 -- 4 is major bottom right
-- R_glyph =  56801 -- 6 is major bottom left
-- FoK_glyph = 63254
--     local _, _, tt1 = GetGlyphSocketInfo(1);
--     local _, _, tt2 = GetGlyphSocketInfo(4);
--     local _, _, tt3 = GetGlyphSocketInfo(6);

-- if tt1 == R_glyph or tt2 == R_glyph or tt3 == R_glyph then
--     ruptureglyph = true
-- else
--     ruptureglyph = false
-- end

--         --item ids for wotlk range checks with nameplate
--         --<5 37727
--         --<8 34368
--         --<10 32321
--         --<15 33069
--         --<20 10645
--         --<25 13289
--         --<30 835
--         --<35 18904
--         --<40 4945 

--         local inRange5 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(37727, unitID) then
--             inRange5 = inRange5 + 1
--         end
--         end

--         local inRange8 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(34368, unitID) then
--             inRange8 = inRange8 + 1
--         end
--         end

--         local inRange10 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(32321, unitID) then
--             inRange10 = inRange10 + 1
--         end
--         end

--         local inRange15 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(33069, unitID) then
--             inRange15 = inRange15 + 1
--         end
--         end

--         local inRange20 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(10645, unitID) then
--             inRange20 = inRange20 + 1
--         end
--         end

--         local inRange25 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(13289, unitID) then
--             inRange25 = inRange25 + 1
--         end
--         end

--         local inRange30 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(835, unitID) then
--             inRange30 = inRange30 + 1
--         end
--         end

--         local inRange35 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(18904, unitID) then
--             inRange35 = inRange35 + 1
--         end
--         end

--         local inRange40 = 0
--         for id = 1, 40 do
--         local unitID = "nameplate" .. id
--         if UnitCanAttack("player", unitID) and IsItemInRange(4945, unitID) then
--                 inRange40 = inRange40 + 1
--         end
--         end
--         -- print(RubimRH.queuedSpell[1]:ID())

--         if not Player:AffectingCombat() 
--         -- or S.KillingSpree:ID() ==  RubimRH.queuedSpell[1]:ID() and Player:BuffRemains(S.AdrenalineRush)>2
--         or S.KidneyShot:ID() ==  RubimRH.queuedSpell[1]:ID() and Target:Debuff(S.CheapShot)
--         or S.Blind:ID() ==  RubimRH.queuedSpell[1]:ID() and not IsItemInRange(33069, 'target')
--         or S.KillingSpree:ID() ==  RubimRH.queuedSpell[1]:ID() and (not IsItemInRange(33069, 'target') or not S.KillingSpree:IsAvailable())
--         or S.Kick:ID() ==  RubimRH.queuedSpell[1]:ID() and not IsItemInRange(34368, 'target')
--         or S.tott:ID() ==  RubimRH.queuedSpell[1]:ID() and not UnitExists("focus")
--         or RubimRH.queuedSpell[1]:CooldownRemains()>2 
--         then
--             RubimRH.queuedSpell =  { RubimRH.Spell[4].Default, 0 }
--         end

            
--         if RubimRH.QueuedSpell():IsReadyQueue() then
--             return RubimRH.QueuedSpell():Cast()
--         end



--     if  Player:AffectingCombat() and not Player:Buff(S.Stealth) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then -- In combat

--                 -- if S.Kick:CanCast() and RubimRH.CDsON() and S.Kick:CooldownUp() and Target:CastPercentage()> math.random(20, 80) and IsItemInRange(34368, 'target') then
--                 --     return S.Kick:Cast()
--                 --     end

--                 if S.Evasion:CanCast() and (inRange10==1 and STttd>4 and Player:IsTanking(Target) or inRange10>1) and Player:HealthPercentage()<55 then
--                     return S.Evasion:Cast()
--                     end

--                 if not IsCurrentSpell(6603) then
--                     return I.autoattack:ID()
--                 end

--                 if (inRange10>=4 or DungeonBoss()) and RubimRH.CDsON() and Player:BuffRemains(S.SnD)>5 and IsItemInRange(34368, 'target') then
--                     -- if (Player:Buff(S.AdrenalineRush) or Player:Buff(S.BladeFlurry)) and inRange10>=4 and GetItemCount('Global Thermal Sapper Charge')>=1 and I.GTSC:CooldownUp() then
--                     --     return S.GTSC:Cast()
--                     -- end
--                     -- if (Player:Buff(S.AdrenalineRush) or Player:Buff(S.BladeFlurry)) and GetItemCount('Saronite Bomb')>=1 and I.SB:CooldownUp() then
--                     --     return S.SB:Cast()
--                     -- end
--                     if I.trinket_gloves1:CooldownUp() and IsEquippedItem(I.trinket_gloves1:ID())
--                     and (Player:Buff(S.AdrenalineRush) or S.AdrenalineRush:CooldownRemains()>60 or Player:Buff(S.BladeFlurry)) then
--                         return S.trinket_gloves:Cast()
--                     end

--                 end


-- absdiffSND_Rupture = math.abs(ruptureTime()-Player:BuffRemains(S.SnD))

--             if S.SnD:CanCast() 
--                 and ((HL.CombatTime()<4 and Player:ComboPoints()>=1 and Player:BuffRemains(S.SnD) <Player:GCD()
--                 or (Player:ComboPoints()>=3 and Player:BuffRemains(S.SnD) <Player:GCD() or Player:ComboPoints()>=2 and Player:EnergyTimeToX(55)>Player:GCD() and Player:BuffRemains(S.SnD) <Player:GCD())
--                 or (Player:ComboPoints()>=3 and ruptureTime()>0 and Player:BuffRemains(S.SnD)<4 and absdiffSND_Rupture<3.5))
--                 or (STttd<2 or UnitName('target') == "Veteran's Training Dummy") and RubimRH:AoEON() and inRange10>1 and Player:BuffRemains(S.SnD) <4.5 and Player:ComboPoints()>=2
--                 or (AOEttd>5 and STttd<5 or UnitName('target') == "Veteran's Training Dummy") and RubimRH:AoEON() and inRange10>1 and Player:BuffRemains(S.SnD) <3.375
--                 )
--                 then
--                     return S.SnD:Cast()
--             end

--             --==================CDS=====================

--             if RubimRH.CDsON() and IsItemInRange(34368, 'target') then 

--                 if S.BladeFlurry:CanCast() and (Player:BuffRemains(S.SnD)>5 and (not RubimRH.AoEON() or inRange10==1) or inRange10>1 and RubimRH.AoEON()) then
--                     return S.BladeFlurry:Cast()
--                 end

--                 if S.KillingSpree:CanCast() and Player:BuffRemains(S.SnD)>5 and STttd>2.5 then
--                     return S.KillingSpree:Cast()
--                 end

--                 if S.ColdBlood:CanCast() and Player:Buff(S.AdrenalineRush) and Player:BuffRemains(S.SnD)>5 then
--                     return S.ColdBlood:Cast()
--                 end

--             end


--         ---------combat rotation---------------------------------------------------------------------------------------------------------------------------------------------------------------
--         --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--         if comb then 

--             if inRange10<3 then

--                 if S.Rupture:CanCast() and STttd>10 and IsItemInRange(34368, 'target') and ruptureTime()<0.05 
--                     and 
--                     ((Player:ComboPoints()>=5 
--                     or Player:ComboPoints()>=3 and HL.CombatTime()<12 
--                     or Player:ComboPoints()>=4 and Player:BuffRemains(S.SnD)>Player:GCD()*3)
--                     and ((not Player:Buff(S.BladeFlurry) or Player:Buff(S.BladeFlurry)) and not RubimRH.AoEON() and inRange10>=2 
--                     or inRange10<2 and Player:Buff(S.BladeFlurry) 
--                     or inRange10==1)
--                     )
--                     then
--                     return S.Rupture:Cast()
--                 end

--                 if S.Eviscerate:CanCast() and IsItemInRange(34368, 'target')
--                     and 
--                     (
--                     Player:ComboPoints()>=4 and Player:BuffRemains(S.SnD)>Player:GCD()*8 and ruptureTime()>Player:GCD()*4
--                     or
--                     Player:ComboPoints()>=4 and Player:BuffRemains(S.SnD)>Player:GCD()*3 and ruptureTime()>Player:GCD()*7 and Player:Energy()>40
--                     or
--                     Player:ComboPoints()>=5 and Player:EnergyTimeToX(95)<ruptureTime() and Player:EnergyTimeToX(95)<Player:BuffRemains(S.SnD)
--                     or 
--                     Player:ComboPoints()==5 and (AOEttd<10 or STttd<10)
--                     or 
--                     Player:ComboPoints()>=3 and STttd<2
--                     or 
--                     Player:ComboPoints()>=4 and STttd<10
--                     )
--                     then
--                     return S.Eviscerate:Cast()
--                 end

--             end

--             if (Player:BuffRemains(S.SnD)>Player:EnergyTimeToX(50) 
--             or Player:BuffRemains(S.SnD)>AOEttd or STttd<4) and RubimRH.AoEON() and inRange10>=3 and IsItemInRange(34368, 'target') then 

--                 if S.ColdBlood:CanCast() and Player:Buff(S.BladeFlurry) and Player:Buff(S.SnD) then
--                     return S.ColdBlood:Cast()
--                 end

--                 if S.FanofKnives:CanCast() then
--                     return S.FanofKnives:Cast()
--                 end

--             end

--             if S.SinisterStrike:CanCast() and IsItemInRange(34368, 'target') 
--             and (
--             Player:ComboPoints()<4 
--             or Player:ComboPoints()==4 and Player:Energy()>85
--             and (not RubimRH.AoEON() or inRange10<3 or inRange10>=3 and (Player:BuffRemains(S.SnD)<1 or STttd>4))
--             )
--             then
--                 return S.SinisterStrike:Cast()
--             end

--             if S.AdrenalineRush:CanCast() and Player:Energy()<20 and IsItemInRange(34368, 'target') and RubimRH.CDsON() then
--                 return S.AdrenalineRush:Cast()
--             end


--         end -- end combat rotation (in combat)

--     end -- end in combat rotation

--     -- Out of combat
--     if not Player:AffectingCombat()  then

--         if not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
--             --combat
--             if comb then
--             if mhenchantremains<300 and not Player:IsMoving() and GetItemCount('Instant Poison IX')>=1 then
--             return S.mainhandpoison_instant1:Cast()
--             end
--             if ohenchantremains<300 and not Player:IsMoving() and comb and GetItemCount('Deadly Poison IX')>=1 then
--             return S.offhandpoison_instant1:Cast()
--             end
--             end


        -- end

        return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
    end
    
RubimRH.Rotation.SetAPL(4, APL);