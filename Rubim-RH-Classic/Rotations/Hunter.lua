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
local Pet = Unit.Pet;
local MouseOver = Unit.MouseOver;

RubimRH.Spell[3] = {
	Default = Spell(1),
	SteadyShot = Spell(49052),
	SteadyShotz = Spell(25264), --thunder clap
	MultiShot = Spell(49048),
	MultiShotz = Spell(1715), --hamstring
	ArcaneShot = Spell(49045),
	ArcaneShotz = Spell(12328), --sweeping strikes
	AspectoftheDragonhawk = Spell(61847),
	AspectoftheDragonhawkz = Spell(2458),  --berserker stance
	AspectoftheMonkey = Spell(13163),
	AspectoftheCheetah = Spell(5118),
	AspectofthePack= Spell(13159),
	Drink = Spell(27089),
	MageDrink = Spell(46755),
	Food = Spell(35270),
	AutoShot = Spell(75),
	RaptorStrike = Spell(48996),
	RaptorStrikez = Spell(20230), --retaliation
	BestialWrath = Spell(37587),
	-- BestialWrath = Spell(37587),
	KillShot = Spell(61006),
	KillShotz = Spell(845), --cleave
	BloodFury = Spell(20572),
	BloodFuryCancelz = Spell(25241), --slam
	KillCommand = Spell(34026),
	KillCommandz = Spell(355), --taunt
	FeignDeath = Spell(5384),
	FeignDeathz = Spell(71), --defensive stance
	RapidFire = Spell(3045),
	RapidFirez = Spell(7386), --sunder
	HuntersMark = Spell(53338),
	HuntersMarkz = Spell(5246), --intimidating shout
	MongooseBite = Spell(53339),
	MongooseBitez = Spell(20560), --mocking blow
	WingClip = Spell(2974),
	WingClipz = Spell(20589), --escape artist
	AspectoftheViper = Spell(34074),
	AspectoftheViperz = Spell(2048), --battle shout
	TrackUndead = Spell(19884),
	TranqShot = Spell(19801),
	playerVolley = Spell(20594), --stoneform
	ExplosiveTrap = Spell(49067),
	ExplosiveTrapz = Spell(12975), --last stand
	ChimeraShot = Spell(53209),
	ChimeraShotz = Spell(20549), --war stomp
	FreezingTrap = Spell(31933),
	--FreezingTrapz = Spell(676), --disarm
	FreezingArrow = Spell(60192),
	FreezingArrowz = Spell(676), --disarm
	FrostTrap = Spell(13809),
	FrostTrapz = Spell(12292), --death wish
	TrackGiants = Spell(19882),
	ViperSting = Spell(3034),
	ViperStingz = Spell(25236), --execute
	Volley = Spell(58434),
	Volleyz = Spell(7744), --will of the forsaken
	AbominationsMight = Spell(53138),
	ConcussiveShot = Spell(5116),
	ConcussiveShotz = Spell(12323), --piercing howl
	SilencingShot = Spell(34490),
	SilencingShotz = Spell(78), --heroic strike
	Intimidation = Spell(24394), 
	Arcanetagz = Spell(1719), --recklessness
	SerpentSting = Spell(49001),
	SerpentStingz = Spell(1161), --challenging shout
	trueshotAura = Spell(19506),
	trueshotAuraz = Spell(12809), --concussive blow
	AimedShot = Spell(49050),
	AimedShotz = Spell(100), --charge
	mendpet = Spell(48990),
	mendpetz = Spell(2565), --shieldblock
	FeedPetBuff = Spell(1539),
	FeedPet = Spell(6991),
	FeedPetz = Spell(7165), --battle stance
	Misdirection = Spell(34477),
	Misdirectionz = Spell(2687), --bloodrage
	EatFood = Spell(1160), --demo shout
	Readiness = Spell(23989),
	Readinessz = Spell(14895), --overpower
	Rupture = Spell(26867),
};

local S = RubimRH.Spell[3]

if not Item.Hunter then
    Item.Hunter = {}
end
Item.Hunter.BeastMastery = {
	trink1 = Item(28041, { 13, 14 }),
	trink2 = Item(28288, { 13, 14 }),
};
local I = Item.Hunter.BeastMastery;

S.AimedShot:RegisterInFlight()
S.ChimeraShot:RegisterInFlight()
S.MultiShot:RegisterInFlight()
S.ArcaneShot:RegisterInFlight()
S.SteadyShot:RegisterInFlight()
S.Volley:RegisterInFlight()
S.SilencingShot:RegisterInFlight()
S.SerpentSting:RegisterInFlight()
S.KillShot:RegisterInFlight()
S.AutoShot:RegisterInFlight()

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

local function UpdateCDs()
    if RubimRH.CDsON() then
        for i, spell in pairs(OffensiveCDs) do
            if not spell:IsEnabledCD() then
                mainAddon.delSpellDisabledCD(spell:ID())
            end
        end

    end
    if not RubimRH.CDsON() then
        for i, spell in pairs(OffensiveCDs) do
            if spell:IsEnabledCD() then
                mainAddon.addSpellDisabledCD(spell:ID())
            end
        end
    end
end

local function PetActive()
    local petActive = false
    if Pet:Exists() then
        petActive = true
    end

    if Pet:IsActive() then
        petActive = true
    end

    if Pet:IsDeadOrGhost() then
        petActive = false
    end

    return petActive
end



local function PetHapiness()
local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local happy = ({"Unhappy", "Content", "Happy"})[happiness]
	local loyalty = loyaltyRate > 0 and "gaining" or "losing"
	-- print("Pet is "..happy)
	-- print("Pet is doing "..damagePercentage.."% damage")
	-- print("Pet is "..loyalty.." loyalty")
	return happy
end

local function ManaPct()
    return (UnitPower("Player", 0) / UnitPowerMax("Player", 0)) * 100
end

local function Range5()
local inRange5 = 0

for i = 1, 40 do
	if UnitExists('nameplate' .. i) and IsSpellInRange("Wing Clip", 'nameplate' .. i) == 1 then
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

local function CleaveCount()
local cleave_counter = 0
     
        for i=1,40 do
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if IsActionInRange(37,"nameplate"..i) then
                        cleave_counter = cleave_counter+1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function SwingTime()
	haste = (1 + GetRangedHaste()/100)
	ASCast = 0.5/haste
	
	-- FD resets swing timer**
	if S.FeignDeath:CooldownRemains() >= 30 - (UnitRangedDamage("player") - ASCast) then 
		Swing = (UnitRangedDamage("player") - ASCast) - (30 - S.FeignDeath:CooldownRemains()) 
	else
		Swing = (UnitRangedDamage("player") - ASCast) - S.AutoShot:TimeSinceLastCast()
	end
	
	if Swing <= 0 then Swing = 0 end
	
	return Swing
end

local function stingTime()
local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL")

if Target:Debuff(S.SerpentSting) then
	timer = expirationTime - HL.GetTime()
else
	timer = nil
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
	or npcid == '34928' or npcid == '35451') or npcid == '24723' or npcid == '24664' or npcid == '24560' or npcid == '24744' then
		DngBoss = true
	else
		DngBoss = false
	end
	
	return DngBoss
end

local function APL()
	Range5()
	Range8()
	DungeonBoss()
	PetHapiness()
	PetActive()
	SwingTime()
	stingTime()
	CleaveCount()

	if Player:BuffP(S.FeignDeath) then
		RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
	end

if IsKeyDown('R') and not IsLeftShiftKeyDown() then
	if Range5() >= 1 then	
		if S.ExplosiveTrap:CanCast() and Range8() >= 2 and not (ChannelInfo("Volley") or S.Volley:InFlight()) then
			return S.ExplosiveTrapz:Cast()
		end
		
		if not Player:IsMoving() and S.Volley:CanCast() and Range8() >= 3 then
			if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) then
				return S.AspectoftheDragonhawkz:Cast()
			end
			
			if S.Volley:CanCast() and Player:BuffP(S.AspectoftheDragonhawk) 
			and not IsCurrentSpell("58434") and not (ChannelInfo("Volley") or S.Volley:InFlight()) then
				return S.playerVolley:Cast()
			end
		end
	end
end

if Player:IsCasting() or (ChannelInfo("Volley") or S.Volley:InFlight()) or Player:IsChanneling() or Player:BuffP(S.FeignDeath) 
or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or (IsResting() and not Target:IsDummy()) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
end 

	if not Player:BuffP(S.FeignDeath) and not IsCurrentSpell("58434") and not IsCurrentSpell("5384") and not IsCurrentSpell("49067") then
	
		-- if S.mendpet:IsCastable() and Pet:HealthPercentage() <= 40 and PetActive() and not Pet:Buff(S.mendpet) and ManaPct() >= 10 then
			-- return S.mendpetz:Cast()
		-- end	

		if S.HuntersMark:CanCast(Target) and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and Target:Exists()
		and (DungeonBoss() or UnitClassification("target") == "worldboss") and not Target:Debuff(S.HuntersMark) then
			return S.HuntersMarkz:Cast()
		end

		if S.trueshotAura:CanCast() and not AuraUtil.FindAuraByName("Abomination's Might", "player") 
		and not AuraUtil.FindAuraByName("Trueshot Aura", "player")
		then
			return S.trueshotAuraz:Cast()
		end
-- SPELL QUEUE CLEAR
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
			if not RubimRH.queuedSpell[1]:CanCast() or ((S.Volley:ID() ~= RubimRH.queuedSpell[1]:ID() and not Player:AffectingCombat())
			or (S.Volley:ID() == RubimRH.queuedSpell[1]:ID() and (ChannelInfo("Volley") or S.Volley:InFlight() or IsKeyDown('RightButton')))) then
				RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
			end
				
			-- if S.Volley:ID() == RubimRH.queuedSpell[1]:ID() and (ChannelInfo("Volley") or S.Volley:InFlight() or IsKeyDown('RightButton')) then
				-- RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
			-- end
-- SPELL QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------			
			if S.Readiness:ID() == RubimRH.queuedSpell[1]:ID() and S.Readiness:CooldownRemains() <= 2 then
				return S.Readinessz:Cast()
			end
			
			if S.TranqShot:ID() == RubimRH.queuedSpell[1]:ID() and S.TranqShot:CooldownRemains() <= 2 then
				return S.TranqShotz:Cast()
			end
			
			if S.Misdirection:ID() == RubimRH.queuedSpell[1]:ID() and S.Misdirection:CooldownRemains() <= 2 then
				return S.Misdirectionz:Cast()
			end
			
			if S.ViperSting:ID() == RubimRH.queuedSpell[1]:ID() and S.ViperSting:CooldownRemains() <= 2 then
				return S.ViperStingz:Cast()
			end

			if S.ConcussiveShot:ID() == RubimRH.queuedSpell[1]:ID() and S.ConcussiveShot:CooldownRemains() <= 2 and Target:Exists() and Player:CanAttack(Target) then
				return S.ConcussiveShotz:Cast()
			end

			if S.TrackGiants:ID() == RubimRH.queuedSpell[1]:ID() and S.FrostTrap:CooldownRemains() <= 2 then
				return S.FrostTrapz:Cast()
			end

			if S.ExplosiveTrap:ID() == RubimRH.queuedSpell[1]:ID() and S.ExplosiveTrap:CooldownRemains() <= 2 and S.ExplosiveTrap:IsCastable() then
				return S.ExplosiveTrapz:Cast()
			end
			
			if S.FreezingArrow:ID() == RubimRH.queuedSpell[1]:ID() and S.FreezingArrow:CooldownRemains() <= 2 then
				return S.FreezingArrowz:Cast()
			end
			
			if S.HuntersMark:ID() == RubimRH.queuedSpell[1]:ID() and S.HuntersMark:CooldownRemains() <= 2 and Target:Exists() 
			and Player:CanAttack(Target) then
				return S.HuntersMarkz:Cast()
			end
			
			if S.Volley:ID() == RubimRH.queuedSpell[1]:ID() then
				
				if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) then
					return S.AspectoftheDragonhawkz:Cast()
				end
				
				if S.Volley:CanCast() and Player:BuffP(S.AspectoftheDragonhawk) then
					return S.Volleyz:Cast()
				end
				
			end
-- OUT OF COMBAT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		if not Player:AffectingCombat() and not IsCurrentSpell("58434") and S.Volley:ID() ~= RubimRH.queuedSpell[1]:ID() then
			
			if S.AspectoftheViper:CanCast() and not Player:BuffP(S.AspectoftheViper) and ManaPct() < 95
			and not Player:BuffP(S.AspectoftheCheetah) and not Player:BuffP(S.AspectofthePack) then 
				return S.AspectoftheViperz:Cast()
			end
			
			if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) and ManaPct() >= 95
			and not Player:BuffP(S.AspectoftheCheetah) and not Player:BuffP(S.AspectofthePack) then 
				return S.AspectoftheDragonhawkz:Cast()
			end
			
			if S.FeedPet:IsCastable() and (PetHapiness() == 'Content' or PetHapiness() == 'Unhappy') and PetActive() and not Pet:Buff(S.FeedPetBuff) then 
				return S.FeedPetz:Cast() 
			end
			
			if S.mendpet:IsCastable() and Pet:HealthPercentage() <= 45 and PetActive() and not Pet:Buff(S.mendpet) and ManaPct() >= 10 then
				return S.mendpetz:Cast()
			end		
		
		end	
-- MAIN ROTATION FUNCTION CALLS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
if ((Target:AffectingCombat() or S.AutoShot:InFlight()) or Target:IsDummy()) and Player:CanAttack(Target) 
and Target:Exists() and not IsCurrentSpell("58434") and not IsCurrentSpell("49067") then

		if PetActive() and S.KillCommand:CanCast() and ManaPct() >= 5 then
			return S.KillCommandz:Cast()
		end

if S.Volley:ID() ~= RubimRH.queuedSpell[1]:ID() then

		if S.SilencingShot:CanCast(Target) and (Player:BuffP(S.AspectoftheDragonhawk) or ManaPct() < 20) then
			return S.SilencingShotz:Cast()
		end

		if S.RaptorStrike:CanCast(Target) and IsItemInRange(37727, 'target') and not IsCurrentSpell(48996) then
			return S.RaptorStrikez:Cast()
		end
		
		if S.WingClip:CanCast(Target) and IsItemInRange(37727, 'target') and UnitIsPlayer('target') and not Target:Debuff(S.WingClip) then
			return S.WingClipz:Cast()
		end

		-- if S.ExplosiveTrap:CanCast() and IsItemInRange(37727, 'target') and (UnitClassification("target") == "worldboss" or Range5() > 1) then
			-- return S.ExplosiveTrapz:Cast()
		-- end

		if S.MongooseBite:CanCast(target) and IsItemInRange(37727, 'target') and not S.ExplosiveTrap:CanCast() then
			return S.MongooseBitez:Cast()
		end

		if not RubimRH.AoEON() then
--HAWK SYNC AFTER STEADY
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if S.SteadyShot:TimeSinceLastCast() < 0.1 and Player:BuffP(S.AspectoftheDragonhawk) then
					
						if S.KillShot:CanCast(Target) then
							return S.KillShotz:Cast()
						end
					
						if S.ChimeraShot:CanCast(Target) then
							return S.ChimeraShotz:Cast()
						end

						if S.AimedShot:CanCast(Target) and (CleaveCount() <= 1 or Player:IsMoving()) then
							return S.AimedShotz:Cast()
						end

						if S.ArcaneShot:CanCast(Target) then
							return S.ArcaneShotz:Cast()
						end
						
					end
--ROTATION	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
					if S.AspectoftheViper:CanCast() and not Player:BuffP(S.AspectoftheViper) and (((S.ChimeraShot:CooldownRemainsP() > Player:GCD() 
					and (S.KillShot:CooldownRemainsP() > Player:GCD() or Target:HealthPercentage() > 20) and ((S.AimedShot:CooldownRemainsP() > Player:GCD() 
					and (CleaveCount() <= 1 or Player:IsMoving())) or (S.MultiShot:CooldownRemainsP() > Player:GCD() and CleaveCount() > 1 
					and not Player:IsMoving()))) or S.SteadyShot:InFlight() and (S.AimedShot:InFlight() or S.ChimeraShot:InFlight() or S.ArcaneShot:InFlight() 
					or S.SerpentSting:InFlight() or S.MultiShot:InFlight() or S.SteadyShot:InFlight() or S.KillShot:InFlight())) and (S.AimedShot:InFlight() 
					or S.ChimeraShot:InFlight() or S.ArcaneShot:InFlight() or S.SerpentSting:InFlight() or S.MultiShot:InFlight() or S.SteadyShot:InFlight() 
					or S.KillShot:InFlight()) or ManaPct() < 20) then
						return S.AspectoftheViperz:Cast()
					end
					
					if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) and ManaPct() >= 20 and not S.SteadyShot:InFlight() 
					and not S.AimedShot:InFlight() and not S.ChimeraShot:InFlight() and not S.ArcaneShot:InFlight() and not S.SerpentSting:InFlight() 
					and not S.MultiShot:InFlight() and not S.SteadyShot:InFlight() and not S.SilencingShot:InFlight() and not S.KillShot:InFlight() then
						return S.AspectoftheDragonhawkz:Cast()
					end
					
					if S.KillShot:CanCast(Target) and Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp() then
						return S.KillShotz:Cast()
					end
					
					if S.MultiShot:CanCast(Target) and (CleaveCount() > 1 and not Player:IsMoving())
					and ((Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) or ManaPct() < 20) then
						return S.MultiShotz:Cast()
					end
					
					if S.SerpentSting:CanCast(Target) and (DungeonBoss() or UnitClassification("target") == "worldboss" or UnitClassification("target") == "rareelite" or Target:IsDummy() or UnitIsPlayer('target'))
					and (Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) and ManaPct() >= 5
					and ((Target:Debuff(S.SerpentSting) and stingTime() <= Player:GCD()) or not Target:Debuff(S.SerpentSting)) then
						return S.SerpentStingz:Cast()
					end
					
					if S.ChimeraShot:CanCast(Target) and Target:Debuff(S.SerpentSting) and ((Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) or ManaPct() < 20) then
						return S.ChimeraShotz:Cast()
					end

					if S.AimedShot:CanCast(Target) and (CleaveCount() <= 1 or Player:IsMoving())
					and ((Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) or ManaPct() < 20) then
						return S.AimedShotz:Cast()
					end

					if S.ChimeraShot:CanCast(Target) and ((Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) or ManaPct() < 20) then
						return S.ChimeraShotz:Cast()
					end

					if S.ArcaneShot:CanCast(Target) and S.AimedShot:CooldownRemainsP() > 0.5 and S.ChimeraShot:CooldownRemainsP() > 0.5 
					and ((Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) or ManaPct() < 20) then
						return S.ArcaneShotz:Cast()
					end
					
					if S.SteadyShot:CanCast(Target) and not S.SteadyShot:InFlight()
					and S.AimedShot:CooldownRemainsP() > 0.5 and S.ChimeraShot:CooldownRemainsP() > 0.5
					and (Player:BuffP(S.AspectoftheDragonhawk) or ManaPct() < 20) then
						return S.SteadyShotz:Cast()
					end
			
		elseif RubimRH.AoEON() then
		
					if  ManaPct() >= 20 then
					
						if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) then
							return S.AspectoftheDragonhawkz:Cast()
						end
						
						if S.KillShot:CanCast(Target) then
							return S.KillShotz:Cast()
						end
						
						if S.MultiShot:CanCast(Target) and (CleaveCount() > 1 and not Player:IsMoving()) and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.MultiShotz:Cast()
						end
						
						if S.SerpentSting:CanCast(Target) and (DungeonBoss() or UnitClassification("target") == "worldboss" or UnitClassification("target") == "rareelite" or Target:IsDummy() or UnitIsPlayer('target'))
						and ((Target:Debuff(S.SerpentSting) and Player:BuffP(S.AspectoftheDragonhawk)
						and stingTime() <= Player:GCD()) or not Target:Debuff(S.SerpentSting)) then
							return S.SerpentStingz:Cast()
						end
						
						if S.ChimeraShot:CanCast(Target) and Target:Debuff(S.SerpentSting) and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.ChimeraShotz:Cast()
						end

						if S.AimedShot:CanCast(Target) and (CleaveCount() <= 1 or Player:IsMoving()) and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.AimedShotz:Cast()
						end

						if S.ChimeraShot:CanCast(Target) and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.ChimeraShotz:Cast()
						end
						
						if S.ArcaneShot:CanCast(Target) and Player:IsMoving()
						and S.AimedShot:CooldownRemainsP() > 0.5 and S.ChimeraShot:CooldownRemainsP() > 0.5 and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.ArcaneShotz:Cast()
						end
						
						if S.SteadyShot:CanCast(Target) and not Player:IsMoving()
						and S.AimedShot:CooldownRemainsP() > 0.5 and S.ChimeraShot:CooldownRemainsP() > 0.5 and Player:BuffP(S.AspectoftheDragonhawk) then
							return S.SteadyShotz:Cast()
						end
						
--HAWK SYNC AFTER STEADY	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------	
					elseif ManaPct() < 20 then
					
						if S.SteadyShot:TimeSinceLastCast() < 0.1 and Player:BuffP(S.AspectoftheDragonhawk) then
						
							if S.KillShot:CanCast(Target) then
								return S.KillShotz:Cast()
							end
						
							if S.ChimeraShot:CanCast(Target) then
								return S.ChimeraShotz:Cast()
							end

							if S.AimedShot:CanCast(Target) and (CleaveCount() <= 1 or Player:IsMoving()) then
								return S.AimedShotz:Cast()
							end

							if S.ArcaneShot:CanCast(Target) then
								return S.ArcaneShotz:Cast()
							end
							
						end
--ROTATION
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------		
						if S.AspectoftheViper:CanCast() and not Player:BuffP(S.AspectoftheViper)
						and ((S.AimedShot:InFlight() or S.ChimeraShot:InFlight() or S.ArcaneShot:InFlight() or S.SerpentSting:InFlight()
						or S.MultiShot:InFlight() or S.SteadyShot:InFlight() or S.SilencingShot:InFlight() or S.KillShot:InFlight())
						or ManaPct() < 5) then
							return S.AspectoftheViperz:Cast()
						end
						
						if S.AspectoftheDragonhawk:CanCast() and not Player:BuffP(S.AspectoftheDragonhawk) and not S.SteadyShot:InFlight() and ManaPct() >= 5
						and not S.AimedShot:InFlight() and not S.ChimeraShot:InFlight() and not S.ArcaneShot:InFlight() and not S.SerpentSting:InFlight() 
						and not S.MultiShot:InFlight() and not S.SteadyShot:InFlight() and not S.SilencingShot:InFlight() and not S.KillShot:InFlight() then
							return S.AspectoftheDragonhawkz:Cast()
						end
						
						if S.KillShot:CanCast(Target) and Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp() then
							return S.KillShotz:Cast()
						end
						
						if S.MultiShot:CanCast(Target) and (CleaveCount() > 1 and not Player:IsMoving())
						and (Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) then
							return S.MultiShotz:Cast()
						end
						
						if S.SerpentSting:CanCast(Target) and (DungeonBoss() or UnitClassification("target") == "worldboss" or UnitClassification("target") == "rareelite" or Target:IsDummy() or UnitIsPlayer('target'))
						and ((Target:Debuff(S.SerpentSting) and ManaPct() >= 5 and (Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp()) 
						and stingTime() <= Player:GCD()) or not Target:Debuff(S.SerpentSting)) then
							return S.SerpentStingz:Cast()
						end
						
						if S.ChimeraShot:CanCast(Target) and Target:Debuff(S.SerpentSting) and (Player:BuffP(S.AspectoftheDragonhawk) 
						and S.AspectoftheViper:CooldownUp()) then
							return S.ChimeraShotz:Cast()
						end

						if S.AimedShot:CanCast(Target) and (CleaveCount() <= 1 or Player:IsMoving()) and Player:BuffP(S.AspectoftheDragonhawk) 
						and S.AspectoftheViper:CooldownUp() then
							return S.AimedShotz:Cast()
						end

						if S.ChimeraShot:CanCast(Target) and Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp() then
							return S.ChimeraShotz:Cast()
						end

						if S.ArcaneShot:CanCast(Target) and (S.AimedShot:CooldownRemainsP() > 0.5 and S.ChimeraShot:CooldownRemainsP() > 0.5 
						and Player:BuffP(S.AspectoftheDragonhawk) and S.AspectoftheViper:CooldownUp())
						or (ManaPct() < 5 and Player:BuffP(S.AspectoftheViper))	then
							return S.ArcaneShotz:Cast()
						end
						
						if S.SteadyShot:CanCast(Target) and (not S.SteadyShot:InFlight() and S.AimedShot:CooldownRemainsP() > 0.5 
						and S.ChimeraShot:CooldownRemainsP() > 0.5 and Player:BuffP(S.AspectoftheDragonhawk)) 
						or (ManaPct() < 5 and Player:BuffP(S.AspectoftheViper)) then
							return S.SteadyShotz:Cast()
						end
					end
				end
			end
		end
	end
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
RubimRH.Rotation.SetAPL(3, APL);
RubimRH.Rotation.SetPvP(3, PvP)
RubimRH.Rotation.SetPASSIVE(3, PASSIVE);

id, name, description, displayInfo, iconImage, uiModelSceneID = EJ_GetCreatureInfo(index [, encounterID])

print(name)

local lastUpdate = 27082019
local function CONFIG()
    local function setVariables()
        RubimRH.db.profile[RubimRH.playerClass] = {}
        RubimRH.db.profile[RubimRH.playerClass].version = lastUpdate
        RubimRH.db.profile[RubimRH.playerClass].cooldown = true
    end

    if not RubimRH.db.profile[RubimRH.playerClass] then
       setVariables()
    end

    if RubimRH.db.profile[RubimRH.playerClass] and RubimRH.db.profile[RubimRH.playerClass].version ~= lastUpdate then
        setVariables()
    end
end
-- RubimRH.Rotation.SetCONFIG(3, CONFIG)