local addonName, addonTable = ...;

local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;
local SwingTimerLib = LibStub("LibClassicSwingTimerAPI", true)

RubimRH.Spell[7] = {
	AutoAttack = Spell(6603),
	Thunderstorm = Spell(51490),
	FeralSpirit = Spell(51533),
	FeralSpiritz = Spell(6495),
	ShamanisticRage = Spell(30823),
	WindfuryWeapon = Spell(25505),
	LightningBolt1 = Spell(403),
	AutoAttack = Spell(6603),
	Bloodlust = Spell(2825),
	Stormstrike = Spell(17364),
	FlameTongue = Spell(16342),
	HealingWave = Spell(25391),
	trinket = Spell(33697), -- Blood Fury
	trinket2 = Spell(26296), -- berserking
	EarthElementalTotem = Spell(2062),
	FireElementalTotem = Spell(2894),
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	Default = Spell(1),
	FireNova = Spell(61657),
	ElementalMastery = Spell(16166),
	LesserHealingWave = Spell(10468),
    ChainLightning = Spell(49271),
    LightningBolt = Spell(49238),
    WaterShield = Spell(57960),
	EarthShock = Spell(49231),
	FlameShock = Spell(49233),
	FrostShock = Spell(10472),
	CleansingTotem = Spell(8170),
	CleansingTotemz = Spell(8017), --rockbiter weapon
	GroundingTotem = Spell(8177),
	TotemicRecall = Spell(36936),
	TotemicRecallz = Spell(17116), --natures swiftness
	LavaLash = Spell(60103),
	LavaLashz = Spell(26297), --berserking
	NaturesSwiftness = Spell(16188),
	EarthShield = Spell(32594),
	EarthBind = Spell(2484),
	MagmaTotem = Spell(58734),
	TremorTotem = Spell(8143),
	SearingTotem = Spell(3599),
	GraceofAirTotem = Spell(25359),
	GraceofAirTotemBuff = Spell(25360),
	StrengthofEarthTotem = Spell(25528),
	StrengthofEarthTotemBuff = Spell(25527),
	WindfuryTotem = Spell(10486),
	WindShear = Spell(57994),
	MaelStromWeapon = Spell(53817),
	WindShearz = Spell(2008), --Ancestral Spirit
	Stormstrikedebuff = Spell(17364),
	LightningShield = Spell(49281),
	CalloftheAncestors = Spell(66843),
	CalloftheAncestorsz = Spell(131), --waterbreathing
	CalloftheElements = Spell(66842),
	CalloftheElementsz = Spell(20549), --warstomp
	CalloftheSpirits = Spell(66844),
	weaponsync = Spell(28880), --gift of naaru
	snake = Spell(10713),
};

local S = RubimRH.Spell[7]

if not Item.Shaman then
    Item.Shaman = {}
end
Item.Shaman = {
	autoattack = Item(135274, { 13, 14 }),
};
local I = Item.Shaman;

S.TotemicRecall.TextureSpellID = {136233} --old recall icon fuck u blizz

local function Range5()
local inRange5 = 0

	for id = 1, 40 do
		local unitID = "nameplate" .. id
		if UnitCanAttack("player", unitID) and IsItemInRange(37727, unitID) then
			inRange5 = inRange5 + 1
		end
    end

	return inRange5
end

local function Range8()
local inRange8 = 0

	for id = 1, 40 do
		local unitID = "nameplate" .. id
		if UnitCanAttack("player", unitID) and IsItemInRange(34368, unitID) then
			inRange8 = inRange8 + 1
		end
    end

	return inRange8
end

local function Range40()
local inRange40 = 0

	for id = 1, 40 do
		local unitID = "nameplate" .. id
		if UnitCanAttack("player", unitID) and IsItemInRange(4945, unitID) and UnitAffectingCombat(unitID) then
			inRange40 = inRange40 + 1
		end
    end

	return inRange40
end

local function allMobsinRange(range)
local totalRange40 = 0
local allMobsinRange = false

	for id = 1, 40 do
		local unitID = "nameplate" .. id
		if UnitCanAttack("player", unitID) and IsItemInRange(4945, unitID)
		and UnitHealthMax(unitID) > 5 and UnitAffectingCombat(unitID) then
			totalRange40 = totalRange40 + 1
		end
    end

	if range == totalRange40 and totalRange40 >= 1 then
		allMobsinRange = true
	else
		allMobsinRange = false
	end

	return allMobsinRange
	
end

local function ManaPct()
    return (UnitPower("Player", 0) / UnitPowerMax("Player", 0)) * 100
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
	or npcid == '34928' or npcid == '35451') or npcid == '24723' or npcid == '24664' or npcid == '24560' or npcid == '24744' or npcid == '29573'
	or npcid == '29312'	then
		DngBoss = true
	else
		DngBoss = false
	end
	
	return DngBoss
end

local function FSTime()
local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL")

if AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") then
	timer = expirationTime - HL.GetTime()
else
	timer = nil
end
    return timer
end

-- TOTEM AOE TRACKER + SWING DISPLACEMENT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local playerGUID = UnitGUID("player")
	local lastResetTime = 0

	local f = CreateFrame("Frame")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:SetScript("OnEvent", function(self, event)
		self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
	end)

	function f:COMBAT_LOG_EVENT_UNFILTERED(...)
		local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		local spellId, spellName, spellSchool
		local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

		if subevent == "SPELL_DAMAGE" or subevent == "SPELL_MISSED" then
			spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
		end
--	if subevent == "SPELL_SUMMON" and sourceGUID == playerGUID and (destName == 'Magma Totem VII' or destName == 'Fire Elemental Totem') then	
		if subevent == "SPELL_SUMMON" and sourceGUID == playerGUID and destName == 'Magma Totem VII' then
			lastResetTime = GetTime()
			numTargetsHit = Range8()
			-- if destName == 'Magma Totem VII' then
				-- myTotemGUID = destGUID
			-- elseif destName == 'Fire Elemental Totem' then
				-- FEGUID = destGUID:sub(-10)
			-- end
			myTotemGUID = destGUID:sub(-10)
			--print('myTotemGUID: ',myTotemGUID)
		end
--and ((spellId == 58732 or spellId == 13376) and sourceGUID:sub(-10) == myTotemGUID) then
		if (subevent == "SPELL_DAMAGE" or subevent == "SPELL_MISSED") 
		and (spellId == 58735 and sourceGUID:sub(-10) == myTotemGUID) then
		--print('numTargetsHit: ',numTargetsHit,' myTotemGUID: ',myTotemGUID,'sourceGUID: ',sourceGUID:sub(-10))
			if GetTime() - lastResetTime > 1 then
				lastResetTime = GetTime()
				numTargetsHit = 0
			end
			numTargetsHit = numTargetsHit + 1
			lastResetTime = GetTime()
		end
	end

local function APL()
Range5()
Range8()
Range40()
ManaPct()
allMobsinRange()
DungeonBoss()
FSTime()

mainSpeed, offSpeed = UnitAttackSpeed('player')
tarSpeed,_,_,_ = GetUnitSpeed('target')

if getglobal("TimerMH") and getglobal("TimerOH") then
	MHPercent = 100 - (100 / UnitAttackSpeed('player')) * getglobal("TimerMH")
	OHPercent = 100 - (100 / UnitAttackSpeed('player')) * getglobal("TimerOH")
end

delta = getglobal("delta")

if delta and IsItemInRange(37727, 'target') and IsPlayerAttacking('target') then
	if MHPercent > OHPercent then
		deltaPercent = MHPercent - OHPercent
	elseif OHPercent > MHPercent then
		deltaPercent = OHPercent - MHPercent
	end
end

local weaponsyncd = nil

if delta and delta <= 0.2 then
	weaponsyncd = true
elseif delta and delta > 0.2 then
	weaponsyncd = false
end

if getglobal("TimerMH") and getglobal("TimerOH") and mainSpeed and offSpeed then
	mhTimeSinceSwing = mainSpeed - getglobal("TimerMH")
	ohTimeSinceSwing = offSpeed - getglobal("TimerOH")
end

local justSwung = nil

if mhTimeSinceSwing and ohTimeSinceSwing then
	if mhTimeSinceSwing + ohTimeSinceSwing <= 0.3 then
		justSwung = true
	else
		justSwung = false
	end
end

if getglobal("TimerMH") and getglobal("TimerOH") then
	if getglobal("TimerMH") <= getglobal("TimerOH") then
		swingTimer = getglobal("TimerMH")
	elseif getglobal("TimerOH") <= getglobal("TimerMH") then
		swingTimer = getglobal("TimerOH")
	end
end

if getglobal("TimerMH") and getglobal("TimerOH") then
	if getglobal("TimerMH") >= getglobal("TimerOH") then
		swingTimerBehind = getglobal("TimerMH")
	elseif getglobal("TimerOH") >= getglobal("TimerMH") then
		swingTimerBehind = getglobal("TimerOH")
	end
end

_,_,_, CLcastTime = GetSpellInfo(49270)
_,_,_, LBcastTime = GetSpellInfo(49237)

CLCastTime = CLcastTime/1000
LBCastTime = LBcastTime/1000

LBTimeUntilWeaveMH = nil
LBTimeUntilWeaveOH = nil
LBTimeUntilWeaveFR = nil

CLTimeUntilWeaveMH = nil
CLTimeUntilWeaveOH = nil
CLTimeUntilWeaveFR = nil

if mainSpeed and offSpeed and getglobal("TimerMH") and getglobal("TimerOH") and LBCastTime and CLCastTime then

	if delta and delta < (mainSpeed - LBCastTime) then
		if (mainSpeed - getglobal("TimerMH")) > (mainSpeed - LBCastTime) then
			LBTimeUntilWeaveMH = ((getglobal("TimerMH") + (mainSpeed - LBCastTime)))
		elseif (mainSpeed - getglobal("TimerMH")) < (mainSpeed - LBCastTime) then
			LBTimeUntilWeaveMH = (((getglobal("TimerMH") + (mainSpeed - LBCastTime)) - mainSpeed))
		end

		if (offSpeed - getglobal("TimerOH")) > (offSpeed - LBCastTime) then
			LBTimeUntilWeaveOH = ((getglobal("TimerOH") + (offSpeed - LBCastTime)))
		elseif (offSpeed - getglobal("TimerOH")) < (offSpeed - LBCastTime) then
			LBTimeUntilWeaveOH = (((getglobal("TimerOH") + (offSpeed - LBCastTime)) - offSpeed))
		end
	end

	-- if (mainSpeed - getglobal("TimerMH")) < (mainSpeed - LBCastTime) and (offSpeed - getglobal("TimerOH")) < (offSpeed - LBCastTime) then
		-- LBTimeUntilWeaveFR = 0
	-- else
		if LBTimeUntilWeaveMH and LBTimeUntilWeaveOH then
			if LBTimeUntilWeaveMH >= LBTimeUntilWeaveOH then
				LBTimeUntilWeaveFR = LBTimeUntilWeaveMH
			elseif LBTimeUntilWeaveOH > LBTimeUntilWeaveMH then
				LBTimeUntilWeaveFR = LBTimeUntilWeaveOH
			end
		end
	-- end

	if delta and delta < (mainSpeed - CLCastTime) then
		if (mainSpeed - getglobal("TimerMH")) > (mainSpeed - CLCastTime) then
			CLTimeUntilWeaveMH = ((getglobal("TimerMH") + (mainSpeed - CLCastTime)))
		elseif (mainSpeed - getglobal("TimerMH")) < (mainSpeed - CLCastTime) then
			CLTimeUntilWeaveMH = (((getglobal("TimerMH") + (mainSpeed - CLCastTime)) - mainSpeed))
		end

		if (offSpeed - getglobal("TimerOH")) > (offSpeed - CLCastTime) then
			CLTimeUntilWeaveOH = ((getglobal("TimerOH") + (offSpeed - CLCastTime)))
		elseif (offSpeed - getglobal("TimerOH")) < (offSpeed - CLCastTime) then
			CLTimeUntilWeaveOH = (((getglobal("TimerOH") + (offSpeed - CLCastTime)) - offSpeed))
		end
	end

	-- if (mainSpeed - getglobal("TimerMH")) < (mainSpeed - CLCastTime) and (offSpeed - getglobal("TimerOH")) < (offSpeed - CLCastTime) then
		-- CLTimeUntilWeaveFR = 0
	-- else
		if CLTimeUntilWeaveMH and CLTimeUntilWeaveOH then
			if CLTimeUntilWeaveMH >= CLTimeUntilWeaveOH then
				CLTimeUntilWeaveFR = CLTimeUntilWeaveMH
			elseif CLTimeUntilWeaveOH > CLTimeUntilWeaveMH then
				CLTimeUntilWeaveFR = CLTimeUntilWeaveOH
			end
		end
	-- end
end

local haveTotem1, totemName1, startTime1, duration1 = GetTotemInfo(1)
	local remainingDura1 = (duration1 - (GetTime() - startTime1))
local haveTotem2, totemName2, startTime2, duration2 = GetTotemInfo(2)
	local remainingDura2 = (duration2 - (GetTime() - startTime2))
local haveTotem3, totemName3, startTime3, duration3 = GetTotemInfo(3)
	local remainingDura3 = (duration3 - (GetTime() - startTime3))
local haveTotem4, totemName4, startTime4, duration4 = GetTotemInfo(4)
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

local totemCount = haveFire + haveEarth + haveWater + haveAir

local tslt = GetTime() - lastResetTime

	-- if (tslt > 3.13 or remainingDura1 <= Player:GCD()) and totemName1 == 'Fire Elemental Totem' then
		-- numTargetsHit = 0
	-- elseif (tslt > 2.13 or remainingDura1 <= Player:GCD()) and totemName1 == 'Magma Totem VII' then
		-- numTargetsHit = 0
	-- elseif totemName1 ~= 'Magma Totem VII' and totemName1 ~= 'Fire Elemental Totem' then
		-- numTargetsHit = 0
	-- end

	if tslt > 2.13 or remainingDura1 <= Player:GCD() then
		numTargetsHit = 0
	end

--print('TARGETS HIT: ',numTargetsHit, 'TSLT: ',tslt, 'RANGE 8: ',Range8(),' TOTEM NAME: ',totemName1)
--print(numTargetsHit)

local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()

if hasMainHandEnchant ~= true then
	mhenchantremains = 0
elseif hasMainHandEnchant == true then 
	mhenchantremains = mainHandExpiration*0.001
end
if hasOffHandEnchant ~= true then
	ohenchantremains = 0
elseif hasOffHandEnchant == true then 
	ohenchantremains = offHandExpiration*0.001
end

-- FREEZE ROT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:IsCasting() or Player:IsChanneling() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") 
or AuraUtil.FindAuraByName("Ghost Wolf", "player") or (IsResting() and not Target:IsDummy()) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
end 

-- SPELL QUEUE CLEAR
--------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
if not RubimRH.queuedSpell[1]:CanCast() or not Player:AffectingCombat() then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if S.LesserHealingWave:ID() == RubimRH.queuedSpell[1]:ID() and Player:IsMoving() then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if S.CleansingTotem:ID() == RubimRH.queuedSpell[1]:ID() and totemName3 == 'Cleansing Totem' then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if S.CleansingTotem:ID() == RubimRH.queuedSpell[1]:ID() and totemName3 == 'Magma Totem VII' then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

if S.TotemicRecall:ID() == RubimRH.queuedSpell[1]:ID() and remainingDura1 + remainingDura2 + remainingDura3 + remainingDura4 == 0 then
	RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
end

-- SPELL QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if S.EarthBind:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.EarthBind:Cast()
	end
	
	if S.ShamanisticRage:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.ShamanisticRage:Cast()
	end
	
	if S.TremorTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.TremorTotem:Cast()
	end
	
	if S.GroundingTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.GroundingTotem:Cast()
	end
	
	if S.LesserHealingWave:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.LesserHealingWave:Cast()
	end

	if S.MagmaTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.MagmaTotem:Cast()
	end

	if S.CleansingTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.CleansingTotemz:Cast()
	end

	if S.FireElementalTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.FireElementalTotem:Cast()
	end
	
	if S.EarthElementalTotem:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.EarthElementalTotem:Cast()
	end
	
	if S.Bloodlust:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.Bloodlust:Cast()
	end
	
	if S.FeralSpirit:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.FeralSpiritz:Cast()
	end
	
	if S.TotemicRecall:ID() == RubimRH.queuedSpell[1]:ID() then
		return S.TotemicRecallz:Cast()
	end

-- OUT OF COMBAT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() and not IsResting() then

	if S.TotemicRecall:CanCast() 
	and totemName2 == 'Strength of Earth Totem VIII' and not AuraUtil.FindAuraByName("Strength of Earth","player","HELPFUL") then
		return S.TotemicRecallz:Cast()
	end

	if S.WindfuryWeapon:CanCast() and ohenchantremains < 300 then
		return S.WindfuryWeapon:Cast()
	end

	if S.FlameTongue:CanCast() and mhenchantremains < 300 then
		return S.FlameTongue:Cast()
	end

	if S.LightningShield:CanCast()
	and (not Player:BuffP(S.LightningShield) or Player:BuffStack(S.LightningShield) < 9) then
		return S.LightningShield:Cast()
	end
	
end

	if S.WindfuryWeapon:CanCast() and ohenchantremains < 10 then
		return S.WindfuryWeapon:Cast()
	end

	if S.FlameTongue:CanCast() and mhenchantremains < 10 then
		return S.FlameTongue:Cast()
	end

-- IN COMBAT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--print('OH PERCENT: ',OHPercent,' MH PERCENT: ',MHPercent,' DELTA: ',delta, ' DELTAPERCENT: ',deltaPercent)
--local MHUntilCenter = getglobal("TimerMH") - (UnitAttackSpeed('player') / 2)

	if IsPlayerAttacking('target') == false and Player:CanAttack(Target) and Target:Exists() 
	and not Target:IsDeadOrGhost() and IsItemInRange(37727, 'target') then
		return I.autoattack:ID()
	end

	if IsItemInRange(37727, 'target') and Target:Exists() and not Target:IsDeadOrGhost() and IsPlayerAttacking('target') == true
	and delta and delta > 0.15 and OHPercent > 50 and ((OHPercent > MHPercent and MHPercent >= 40 
	and MHPercent < 44) or (OHPercent - MHPercent) >= 50) then
		return S.weaponsync:Cast()
	end

	-- if IsItemInRange(37727, 'target') and Target:Exists() and not Target:IsDeadOrGhost() and IsPlayerAttacking('target') == true
	-- and delta and delta > 0.1 and OHPercent > 50 and ((OHPercent > MHPercent and MHPercent > 40 
	-- and MHPercent < 44) or (MHPercent >= 90 and (OHPercent - MHPercent) < 0) or (OHPercent - MHPercent) >= 50) then
		-- return S.weaponsync:Cast()
	-- end

	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists()
	and S.WindShear:CanCast(Target) and Target:CastPercentage() > math.random(43, 82) and RubimRH.CDsON() then
		return S.WindShearz:Cast()
	end

	if S.ShamanisticRage:CanCast() and Target:IsDummy() and IsPlayerAttacking('target') == true then
		return S.ShamanisticRage:Cast()
	end

-- NO WEAVE ROTATION
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
if (RubimRH.AoEON() and not (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()))
or not RubimRH.AoEON() then

	--5 STACK
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsSpellInRange('Lightning Bolt','target')
	and Player:BuffStack(S.MaelStromWeapon) == 5 then
		if S.ChainLightning:CanCast(Target) and Range8() >= 2 then
			return S.ChainLightning:Cast()
		end
		if S.LightningBolt:CanCast(Target) then
			return S.LightningBolt:Cast()
		end		
	end

	--TOTEMS
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (Player:MovingFor() <= Player:GCD() or (allMobsinRange(Range8()) and tarSpeed == 0)) then
		if (S.CalloftheElements:CanCast() and S.CalloftheAncestors:CanCast()) and Range8() >= 1 
		and (totemCount <= 2 
		or totemName2 == 'Strength of Earth Totem VIII' and not AuraUtil.FindAuraByName("Strength of Earth","player","HELPFUL")
		or (totemName4 == 'Windfury Totem' and (not AuraUtil.FindAuraByName("Windfury Totem","player","HELPFUL") 
		and not AuraUtil.FindAuraByName("Improved Icy Talons","player","HELPFUL")))
		or totemName4 == 'Wrath of Air Totem' and not AuraUtil.FindAuraByName("Wrath of Air Totem","player","HELPFUL"))	then
			if ManaPct() >= 25 and ((numTargetsHit < 2 and not (DungeonBoss() or UnitClassification("target") == "worldboss")) 
			or (numTargetsHit == 0 and (DungeonBoss() or UnitClassification("target") == "worldboss"))) and totemName1 ~= 'Fire Elemental Totem'
			and (Range8() > 1 or (Range8() == 1 and (DungeonBoss() or UnitClassification("target") == "worldboss"))) then
				return S.CalloftheElementsz:Cast()
			elseif Range5() >= 1 and ManaPct() >= 25 then
				return S.CalloftheAncestorsz:Cast()
			end
		elseif S.MagmaTotem:CanCast() and numTargetsHit < 2 and Range8() >= 2 and totemName1 ~= 'Fire Elemental Totem' then
			return S.MagmaTotem:Cast()
		end
	end

	--NOVA IN AOE
	if S.FireNova:CanCast() and Player:AffectingCombat() and Range40() >= 1
	and (numTargetsHit >= 2 or (totemName1 == 'Fire Elemental Totem' and Range8() >= 2)) then
		return S.FireNova:Cast()
	end

	--FERAL SPIRIT
	if S.FeralSpirit:CanCast() and RubimRH.CDsON()
	and Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.FeralSpiritz:Cast()
	end

	--FIRE ELE
	if S.FireElementalTotem:CanCast() and RubimRH.CDsON()
	and	Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.FireElementalTotem:Cast()
	end

	--STORMSTRIKE
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists()
	and S.Stormstrike:CanCast(Target) then
		return S.Stormstrike:Cast()
	end

	--FLAME SHOCK
	if S.FlameShock:CanCast(Target) and IsSpellInRange('Flame Shock','target') 
	and (not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") 
	or (AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") and FSTime() < 3))
	and (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then
		return S.FlameShock:Cast()
	end
	
	--MAGMA TOTEM
	if S.MagmaTotem:CanCast() and totemName1 ~= 'Fire Elemental Totem'
	and remainingDura1 < 3 and numTargetsHit == 0 and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.MagmaTotem:Cast()
	end

	--ST NOVA
	if S.FireNova:CanCast() and Player:AffectingCombat() and Range40() >= 1
	and (DungeonBoss() or UnitClassification("target") == "worldboss" or Target:IsDummy())
	and (numTargetsHit == 1 or (totemName1 == 'Fire Elemental Totem' and Range8() == 1)) then
		return S.FireNova:Cast()
	end

	--LIGHTNING SHIELD	
	if S.LightningShield:CanCast() and Player:BuffStack(S.LightningShield) <= 1 then
		return S.LightningShield:Cast()
	end

	--EARTH SHOCK
	if S.EarthShock:CanCast(Target) and IsSpellInRange('Earth Shock','target')
	and (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then
		return S.EarthShock:Cast()
	end

	--LAVA LASH
	if S.LavaLash:CanCast() and IsSpellInRange('Lava Lash','target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.LavaLashz:Cast()
	end

	--MAGMA TOTEM
	if S.MagmaTotem:CanCast() and totemName1 ~= 'Fire Elemental Totem'
	and remainingDura1 < 10 and numTargetsHit == 0 and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.MagmaTotem:Cast()
	end

-- WEAVE ROTATION
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
elseif RubimRH.AoEON() and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then

	--5 STACK
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsSpellInRange('Lightning Bolt','target')
	and Player:BuffStack(S.MaelStromWeapon) == 5 then
		if S.ChainLightning:CanCast(Target) and Range8() >= 2 then
			return S.ChainLightning:Cast()
		end
		if S.LightningBolt:CanCast(Target) then
			return S.LightningBolt:Cast()
		end		
	end

	--TOTEMS
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (Player:MovingFor() <= Player:GCD() or (allMobsinRange(Range8()) and tarSpeed == 0)) then
		if (S.CalloftheElements:CanCast() and S.CalloftheAncestors:CanCast()) and Range8() >= 1 
		and (totemCount <= 2 
		or totemName2 == 'Strength of Earth Totem VIII' and not AuraUtil.FindAuraByName("Strength of Earth","player","HELPFUL")
		or (totemName4 == 'Windfury Totem' and (not AuraUtil.FindAuraByName("Windfury Totem","player","HELPFUL") 
		and not AuraUtil.FindAuraByName("Improved Icy Talons","player","HELPFUL")))
		or totemName4 == 'Wrath of Air Totem' and not AuraUtil.FindAuraByName("Wrath of Air Totem","player","HELPFUL"))	then
			if ManaPct() >= 25 and ((numTargetsHit < 2 and not (DungeonBoss() or UnitClassification("target") == "worldboss")) 
			or (numTargetsHit == 0 and (DungeonBoss() or UnitClassification("target") == "worldboss"))) and totemName1 ~= 'Fire Elemental Totem'
			and (Range8() > 1 or (Range8() == 1 and (DungeonBoss() or UnitClassification("target") == "worldboss"))) then
				return S.CalloftheElementsz:Cast()
			elseif Range5() >= 1 and ManaPct() >= 25 then
				return S.CalloftheAncestorsz:Cast()
			end
		elseif S.MagmaTotem:CanCast() and numTargetsHit < 2 and Range8() >= 2 and totemName1 ~= 'Fire Elemental Totem' then
			return S.MagmaTotem:Cast()
		end
	end

	--NOVA IN AOE
	if S.FireNova:CanCast() and Player:AffectingCombat() and Range40() >= 1
	and (numTargetsHit >= 2 or (totemName1 == 'Fire Elemental Totem' and Range8() >= 2)) then
		return S.FireNova:Cast()
	end

	--FERAL SPIRIT
	if S.FeralSpirit:CanCast() and RubimRH.CDsON()
	and Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.FeralSpiritz:Cast()
	end

	--FIRE ELE
	if S.FireElementalTotem:CanCast() and RubimRH.CDsON()
	and	Player:CanAttack(Target) and Target:Exists() and IsItemInRange(37727, 'target')
	and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
		return S.FireElementalTotem:Cast()
	end

	--APPLY STORMSTRIKE
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsSpellInRange('Stormstrike','target')
	and S.Stormstrike:CanCast(Target) and not AuraUtil.FindAuraByName("Stormstrike","target","PLAYER|HARMFUL") then
		return S.Stormstrike:Cast()
	end

	--WEAVE
	if (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() and IsSpellInRange('Lightning Bolt','target')
	and (not Player:IsMoving() and Player:BuffStack(S.MaelStromWeapon) >= 3 and Player:BuffStack(S.MaelStromWeapon) < 5) then
		if S.ChainLightning:CanCast(Target) and Range8() >= 2 and CLCastTime * 1.3 < swingTimer then
			return S.ChainLightning:Cast()
		end
		if S.LightningBolt:CanCast(Target) and LBCastTime * 1.3 < swingTimer then
			return S.LightningBolt:Cast()
		end
	end

	if Player:BuffStack(S.MaelStromWeapon) <= 2 or Player:IsMoving() then
		
		--SS FOR DAMAGE
		if S.Stormstrike:CanCast(Target) and IsSpellInRange('Stormstrike','target') 
		and (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then
			return S.Stormstrike:Cast()
		end

		--FLAME SHOCK
		if S.FlameShock:CanCast(Target) and IsSpellInRange('Flame Shock','target') 
		and (not AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") 
		or (AuraUtil.FindAuraByName("Flame Shock","target","PLAYER|HARMFUL") and FSTime() < 3))
		and (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then
			return S.FlameShock:Cast()
		end

		--MAGMA TOTEM
		if S.MagmaTotem:CanCast() and totemName1 ~= 'Fire Elemental Totem'
		and remainingDura1 < 3 and numTargetsHit == 0 and IsItemInRange(37727, 'target')
		and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
			return S.MagmaTotem:Cast()
		end

		--ST NOVA
		if S.FireNova:CanCast() and Player:AffectingCombat() and Range40() >= 1
		and (DungeonBoss() or UnitClassification("target") == "worldboss" or Target:IsDummy())
		and (numTargetsHit == 1 or (totemName1 == 'Fire Elemental Totem' and Range8() == 1)) then
			return S.FireNova:Cast()
		end

		--LIGHTNING SHIELD	
		if S.LightningShield:CanCast() and Player:BuffStack(S.LightningShield) <= 1 then
			return S.LightningShield:Cast()
		end

		--EARTH SHOCK
		if S.EarthShock:CanCast(Target) and IsSpellInRange('Earth Shock','target')
		and (Target:AffectingCombat() or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then
			return S.EarthShock:Cast()
		end

		--LAVA LASH
		if S.LavaLash:CanCast() and IsSpellInRange('Lava Lash','target')
		and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
			return S.LavaLashz:Cast()
		end

		--MAGMA TOTEM
		if S.MagmaTotem:CanCast() and totemName1 ~= 'Fire Elemental Totem'
		and remainingDura1 < 10 and numTargetsHit == 0 and IsItemInRange(37727, 'target')
		and (((DungeonBoss() or UnitClassification("target") == "worldboss") and Target:AffectingCombat()) or Target:IsDummy()) then
			return S.MagmaTotem:Cast()
		end
	end
end
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

RubimRH.Rotation.SetAPL(7, APL);