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

RubimRH.Spell[3] = {
	Default = Spell(30681),
	SteadyShot = Spell(34120),
	SteadyShotz = Spell(25264), --thunder clap
	MultiShot = Spell(25294),
	MultiShotz = Spell(1715), --hamstring
	ArcaneShot = Spell(14287),
	ArcaneShotz = Spell(12328), --sweeping strikes
	AspectoftheHawk = Spell(14320),
	AspectoftheHawkr1 = Spell(27044),
	AspectoftheHawkz = Spell(2458),  --berserker stance
	AspectoftheMonkey = Spell(13163),
	AspectoftheCheetah = Spell(5118),
	AspectofthePack= Spell(13159),
	Drink = Spell(34291),
	Food = Spell(27094),
	AutoShot = Spell(75),
	RaptorStrike = Spell(14266),
	RaptorStrikez = Spell(25236), --execute
	BestialWrath = Spell(37587),
	BestialWrathr1 = Spell(19574),
	BestialWrathz = Spell(2687), --bloodrage
	BloodFury = Spell(20572),
	BloodFuryz = Spell(25241), --slam
	FeignDeath = Spell(5384),
	FeignDeathz = Spell(71), --defensive stance
	RapidFire = Spell(3045),
	RapidFirez = Spell(7386), --sunder
	HuntersMark = Spell(1130),
	HuntersMarkr1 = Spell(14325),
	HuntersMarkz = Spell(5246), --intimidating shout
	AutoAttkz = Spell(20230), --retaliation
	MongooseBite = Spell(14271),
	WingClip = Spell(14268),
	AspectoftheViper = Spell(34074),
	TrackUndead = Spell(19884),
	AspectoftheViperz = Spell(2048), --battle shout
	KillCommand = Spell(34026),
	KillCommandz = Spell(25231), --cleave
	ExplosiveTrap = Spell(14317),
	ExplosiveTrapz = Spell(12975), --last stand
	FreezingTrap = Spell(31933),
	FreezingTrapz = Spell(676), --disarm
	FrostTrap = Spell(13809),
	FrostTrapz = Spell(12292), --death wish
	TrackGiants = Spell(19882),
	Volley = Spell(1510),
	Volleyr1 = Spell(14295),
	Volleyz = Spell(1161), --challenging shout
	ConcussiveShot = Spell(5116),
	ConcussiveShotz = Spell(12323), --piercing howl
	Intimidation = Spell(24394), 
	Intimidationr1 = Spell(19577), 
	Intimidationz = Spell(1719), --recklessness
	SerpentSting  = Spell(1978),
	SerpentStingz  = Spell(2565), --shieldblock
};

local S = RubimRH.Spell[3]

if not Item.Hunter then
    Item.Hunter = {}
end
Item.Hunter.BeastMastery = {
};
local I = Item.Hunter.BeastMastery;

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

local function SwingTime()
	haste = 1.15 * (1 + GetRangedHaste()/100)
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

local function AutoPercent()
	ASCast = 0.5/haste
	Percent = 0
	
	if IsCurrentSpell(75) then
		Percent = (S.AutoShot:TimeSinceLastStart()/ASCast)*100
	end

	if Percent > 100 then 
		Percent = 0 
	end
		
	return Percent

end

local function CanMulti()
	SwingTime()
	AutoPercent()
	haste = 1.15 * (1 + GetRangedHaste()/100)
	ASCast = 0.5/haste
	MultiTime = 0.5/haste
	gcd = 1.5
	Swingtimetotal = UnitRangedDamage("player") - ASCast
	
	if S.MultiShot:CanCast(Target) and not Player:IsMoving() and ((SwingTime() > MultiTime) or AutoPercent() >= 50) then 
		return true else return false
	end
	
	-- if ((SwingTime() > (gcd - ASCast) - (Swingtimetotal - SteadyTime())) or IsCurrentSpell(75)) and S.MultiShot:CanCast(Target) and not Player:IsMoving() then 
		-- return true else return false
	-- end
	
end

local function CanSteady()
	SwingTime()
	AutoPercent()
	haste = 1.15 * (1 + GetRangedHaste()/100)
	SteadyTime = 1.5/haste
	
	if S.SteadyShot:CanCast(Target) and not Player:IsMoving() and ((SwingTime()) > SteadyTime or AutoPercent() >= 50) then
		return true else return false
	end

end

local function CanArcane()
	SwingTime()
	haste = 1.15 * (1 + GetRangedHaste()/100)
	ASCast = 0.5/haste
	MultiTime = 0.5/haste
	SteadyTime = 1.5/haste
	gcd = 1.5 
	SwingTotal = UnitRangedDamage("player") - ASCast
	
		if (S.ArcaneShot:CanCast(Target) and Target:AffectingCombat() and Player:AffectingCombat()) and S.MultiShot:CooldownRemains() >= (gcd-ASCast) + SwingTime() then
			if SwingTime() > ((gcd-ASCast) - (SwingTotal - SteadyTime))+0.35 then 
				return true else return false
			end
		end
		
		if (S.ArcaneShot:CanCast(Target) and Target:AffectingCombat() and Player:AffectingCombat()) and S.MultiShot:CooldownRemains() < (gcd-ASCast) + SwingTime() then
			if SwingTime() > ((gcd-ASCast) - (SwingTotal - MultiTime))+0.35 then 
				return true else return false
			end
		end

	-- if SwingTime() > (gcd-ASCast) - (Swingtimetotal - SteadyTime) then 
		-- return true else return false
	-- end
	
end

local EnemyRanges = {"Melee", 5, 8, 10, 15, 20, 25, 30, 35, 40}

local function UpdateRanges()
  for _, i in ipairs(EnemyRanges) do
    HL.GetEnemies(i);
  end
end

local function APL()
	CanMulti()
	CanArcane()
	CanSteady()
	AutoPercent()
	
	-- print(AutoPercent())

			if S.SerpentSting:CanCast(Target) and AutoPercent()>=50 then
				return S.SerpentStingz:Cast()
			end

if Player:IsCasting() or Player:IsChanneling() or Player:BuffP(S.Drink) or Player:BuffP(S.Food) or Player:BuffP(S.FeignDeath) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
end 

	if not Player:BuffP(S.FeignDeath) then

-- Spell Queues

		if Target:Exists() and Player:CanAttack(Target) then
			
		end

			if RubimRH.queuedSpell[1]:CooldownRemains() > 1.5 or not Player:AffectingCombat() then
				RubimRH.queuedSpell = { RubimRH.Spell[3].Default, 0 }
			end

			if S.FeignDeath:ID() == RubimRH.queuedSpell[1]:ID() and S.FeignDeath:CooldownRemains() <= 1.5 and not Player:IsMoving() then
				return S.FeignDeathz:Cast()
			end

			if S.TrackGiants:ID() == RubimRH.queuedSpell[1]:ID() and S.ExplosiveTrap:CooldownRemains() <= 1.5 then
				return S.FrostTrapz:Cast()
			end
			
			if S.AspectoftheHawk:ID() == RubimRH.queuedSpell[1]:ID() and S.AspectoftheHawkr1:CooldownRemains() <= 1.5 and not Player:BuffP(S.AspectoftheHawkr1) then
				return S.AspectoftheHawkz:Cast()
			end
			
			if S.TrackUndead:ID() == RubimRH.queuedSpell[1]:ID() and S.AspectoftheViper:CooldownRemains() <= 1.5 and not Player:BuffP(S.AspectoftheViper) then
				return S.AspectoftheViperz:Cast()
			end

			if S.ExplosiveTrap:ID() == RubimRH.queuedSpell[1]:ID() and S.ExplosiveTrap:CooldownRemains() <= 1.5 then
				return S.ExplosiveTrapz:Cast()
			end
			
			if S.FreezingTrap:ID() == RubimRH.queuedSpell[1]:ID() and S.FreezingTrap:CooldownRemains() <= 1.5 then
				return S.FreezingTrapz:Cast()
			end
			
			if S.BestialWrath:ID() == RubimRH.queuedSpell[1]:ID() and S.BestialWrathr1:CooldownRemains() <= 1.5 then
				return S.BestialWrathz:Cast()
			end

			if S.Volley:ID() == RubimRH.queuedSpell[1]:ID() and S.Volleyr1:CooldownRemains() <= 1.5 and not Player:IsMoving() then
				return S.Volleyz:Cast()
			end
			
			if S.ConcussiveShot:ID() == RubimRH.queuedSpell[1]:ID() and S.ConcussiveShot:CooldownRemains() <= 1.5 and Target:Exists() and Player:CanAttack(Target) then
				return S.ConcussiveShotz:Cast()
			end
			
			if S.Intimidation:ID() == RubimRH.queuedSpell[1]:ID() and S.Intimidationr1:CooldownRemains() <= 1.5 and IsPetActive() and Pet:AffectingCombat() then
				return S.Intimidationz:Cast()
			end
			
			-- if S.HuntersMark:ID() == RubimRH.queuedSpell[1]:ID() and S.HuntersMarkr1:CooldownRemains() <= 1.5 and Target:Exists() and Player:CanAttack(Target) and not Target:Debuff(S.HuntersMarkr1) then
				-- return S.HuntersMarkz:Cast()
			-- end

		-- Out of combat
		
		if not Player:AffectingCombat() then
			
			-- if S.AspectoftheHawk:IsCastable() and Player:ManaPercentage() >= 65 and not (Player:Buff(S.AspectoftheHawk) or Player:Buff(S.AspectoftheMonkey) or Player:Buff(S.AspectoftheCheetah) or Player:Buff(S.AspectofthePack)) then
				-- return S.AspectoftheHawkz:Cast()
			-- end	

			-- if S.AspectoftheViper:IsCastable() and Player:ManaPercentage() <= 25 and not (Player:Buff(S.AspectoftheViper) or Player:Buff(S.AspectoftheMonkey) or Player:Buff(S.AspectoftheCheetah) or Player:Buff(S.AspectofthePack)) then
				-- return S.AspectoftheViperz:Cast()
			-- end	
			
		end
		
		-- In combat

		if Player:AffectingCombat() then
		
			if S.AspectoftheViper:IsCastable() and (Player:ManaPercentage() <= 7 and not CanMulti() and not CanArcane() and not CanSteady()) and not (Player:Buff(S.AspectoftheViper) or Player:Buff(S.AspectoftheMonkey) or Player:Buff(S.AspectoftheCheetah) or Player:Buff(S.AspectofthePack)) then
				return S.AspectoftheViperz:Cast()
			end
			
			if S.KillCommand:CanCast(Player) and IsPetActive() and Target:AffectingCombat() and Pet:AffectingCombat() then
				return S.KillCommandz:Cast()
			end
		
			-- if RubimRH.CDsON() and Target:AffectingCombat() then
			
				-- if S.RapidFire:CanCast(Player) then
					-- return S.RapidFirez:Cast()
				-- end

				-- if S.BestialWrath:CanCast(Player) and IsPetActive() and Pet:AffectingCombat() then
					-- return S.BestialWrathz:Cast()
				-- end
				
				-- if S.BloodFury:CanCast(Player) then
					-- return S.BloodFuryz:Cast()
				-- end


			-- end

			if S.WingClip:CanCast(Target) and S.RaptorStrike:CanCast() then
				return S.RaptorStrikez:Cast()
			end
			
		end
		
		-- if S.HuntersMark:CanCast(Target) and not CanMulti() and not CanSteady() and not CanArcane() and not Target:Debuff(S.HuntersMark) and Target:AffectingCombat() then
			-- return S.HuntersMarkz:Cast()
		-- end
		
		if CanMulti() then
			return S.MultiShotz:Cast()
		end
		
		if CanSteady() then
			return S.SteadyShotz:Cast()
		end
	
		if CanArcane() then
			return S.ArcaneShotz:Cast()
		end
		
		if IsCurrentSpell(75) then
			return S.AutoShot:Cast(), false
		end
		
		return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
	end
	
end

-- TimeSinceLastCast() <= gcd + casttime?
-- swing timer total - TimeSinceLastCast() = swing time remaining
-- swing timer total = tooltip atk speed - 0.5 (atk cast) - UnitRangedDamage("player")
-- (UnitRangedDamage("player") - 0.5) - TimeSinceLastCast() = swing time remaining


local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
RubimRH.Rotation.SetAPL(3, APL);
RubimRH.Rotation.SetPvP(3, PvP)
RubimRH.Rotation.SetPASSIVE(3, PASSIVE);


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