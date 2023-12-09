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
FrostRA = Spell(27152),
FireRA = Spell(27153),
Consecration = Spell(27173),
ArcaneTorrent = Spell(28730),
RighteousFury = Spell(25780),
HolyLight = Spell(27136),
SealofCommand = Spell(20375),
SealofRighteousness = Spell(20154),
Exorcism = Spell(27138),
Judgement = Spell(20271),
BlessingofMight = Spell(27140),
DivineProtection = Spell(5573),
BlessingofProtection = Spell(10278),
HammerofJustice = Spell(10308),
Forbearance = Spell(25771),
LayonHands = Spell(27154),
RetributionAura = Spell(10301),
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
BlessingofWisdom = Spell(25290),
HammerofWrath = Spell(27180),
Repentance = Spell(20066),
BlessingofSacrifice = Spell(27148),
CrusaderStrike = Spell(35395),
HolyWrath = Spell(27139),
GreaterBlessingofWisdom = Spell(25894),
GreaterBlessingofMight = Spell(27141),
trinket = Spell(28880),
AvengingWrath = Spell(31884),
DivineStorm = Spell(53385),
AvengersShield = Spell(32699),
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
BlessingofMight = Spell(20594),
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



 	if RubimRH.QueuedSpell():IsReadyQueue() then
        return RubimRH.QueuedSpell():Cast()
	end
	

-- -- -- Out of combat
if not Player:AffectingCombat() and not AuraUtil.FindAuraByName("Drink", "player") and not AuraUtil.FindAuraByName("Food", "player") then
	if not IsCurrentSpell(6603) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
		return I.autoattack:ID()
	end

	-- if S.SealofRighteousness:CanCast() and not Player:Buff(S.SealofRighteousness) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	-- 	return S.SealofRighteousness:Cast()
	-- end
	
	if S.CrusaderStrike:CanCast(Target) then
		return S.CrusaderStrike:Cast()
	end

	if S.DivineStorm:CanCast(Target) then
		return S.DivineStorm:Cast()
	end

	if S.SealofCommand:CanCast() and Player:BuffRemains(S.SealofCommand) then
		return S.DivineStorm:Cast()
	end

	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\prot.tga", false
end



	-- In combat
    if Player:AffectingCombat() and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
			if not IsCurrentSpell(6603) then
			return I.autoattack:ID()
			end


	

	-- if S.SealofRighteousness:CanCast() and not Player:Buff(S.SealofRighteousness) and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	-- 	return S.SealofRighteousness:Cast()
	-- end
	
	if S.CrusaderStrike:CanCast(Target) then
		return S.CrusaderStrike:Cast()
	end

	if S.DivineStorm:CanCast(Target) then
		return S.DivineStorm:Cast()
	end

	if S.SealofCommand:CanCast() and Player:BuffRemains(S.SealofCommand) then
		return S.DivineStorm:Cast()
	end
	
	
	




	
return 135328


end
end


local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
RubimRH.Rotation.SetAPL(2, APL);
RubimRH.Rotation.SetPvP(2, PvP)
RubimRH.Rotation.SetPASSIVE(2, PASSIVE);


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
-- RubimRH.Rotation.SetCONFIG(7, CONFIG)