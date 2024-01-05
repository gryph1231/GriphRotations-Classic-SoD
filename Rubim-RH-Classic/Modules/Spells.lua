
-- HeroLib
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Arena = Unit.Arena
local Spell = HL.Spell;
local Item = HL.Item;

-- General Spells / Potion Icon
RubimRH.Spell[1] = {
    Empty = Spell(1),

}

RubimRH.Spell[3] = {
	Wrath = Spell(5177),
	CatForm = Spell(768),
	BearForm = Spell(5487),
	Mangle = Spell(407993),
	Claw = Spell(1082),
	MarkoftheWild = Spell(6756),
	Thorns = Spell(782),
	OmenofClarity = Spell(16864),
	Shred = Spell(5221),
	Clearcasting = Spell(16870),
	Prowl = Spell(5215),
	SavageRoar = Spell(407988),
	Rip = Spell(1079),
	Powershift = Spell(5225), -- track humanoids
}



--20594 DWARF
--20549 TAUREN
--28730 ARCANE TORRENT
--68992 DARK FLIGHT
--58984 SHADOWMELD


----WARRIOR
-----MONK
--Brewing
RubimRH.Spell[268] = {
    -- Spells
    ArcaneTorrent = Spell(50613),
    Berserking = Spell(26297),
    BlackoutCombo = Spell(196736),
    BlackoutComboBuff = Spell(228563),
    BlackoutStrike = Spell(205523),
    BlackOxBrew = Spell(115399),
    BloodFury = Spell(20572),
    BreathOfFire = Spell(115181),
    BreathofFireDotDebuff = Spell(123725),
    Brews = Spell(115308),
    ChiBurst = Spell(123986),
    ChiWave = Spell(115098),
    DampenHarm = Spell(122278),
    DampenHarmBuff = Spell(122278),
    ExpelHarm = Spell(115072),
    ExplodingKeg = Spell(214326),
    FortifyingBrew = Spell(115203),
    FortifyingBrewBuff = Spell(115203),
    InvokeNiuzaotheBlackOx = Spell(132578),
    IronskinBrew = Spell(115308),
    IronskinBrewBuff = Spell(215479),
    KegSmash = Spell(121253),
    LightBrewing = Spell(196721),
    PotentKick = Spell(213047),
    PurifyingBrew = Spell(119582),
    RushingJadeWind = Spell(116847),
    TigerPalm = Spell(100780),
    HeavyStagger = Spell(124273),
    ModerateStagger = Spell(124274),
    LightStagger = Spell(124275),
    SpearHandStrike = Spell(116705),
    ModerateStagger = Spell(124274),
    HeavyStagger = Spell(124273),
    HealingElixir = Spell(122281),
    BlackOxStatue = Spell(115315),
    Guard = Spell(202162),
    LegSweep = Spell(119381)
}

--Windwalker
RubimRH.Spell[269] = {
    -- Racials
    Bloodlust = Spell(2825),
    ArcaneTorrent = Spell(25046),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    GiftoftheNaaru = Spell(59547),
    Shadowmeld = Spell(58984),
    QuakingPalm = Spell(107079),
    LightsJudgment = Spell(255647),


    -- Abilities
    TigerPalm = Spell(100780),
    RisingSunKick = Spell(107428),
    FistsOfFury = Spell(113656),
    SpinningCraneKick = Spell(101546),
    StormEarthAndFire = Spell(137639),
    FlyingSerpentKick = Spell(101545),
    FlyingSerpentKick2 = Spell(115057),
    TouchOfDeath = Spell(115080),
    CracklingJadeLightning = Spell(117952),
    BlackoutKick = Spell(100784),
    BlackoutKickBuff = Spell(116768),

    -- Talents
    ChiWave = Spell(115098),
    InvokeXuentheWhiteTiger = Spell(123904),
    RushingJadeWind = Spell(116847),
    HitCombo = Spell(196741),
    Serenity = Spell(152173),
    WhirlingDragonPunch = Spell(152175),
    ChiBurst = Spell(123986),
    FistOfTheWhiteTiger = Spell(261947),

    -- Artifact
    StrikeOfTheWindlord = Spell(205320),

    -- Defensive
    TouchOfKarma = Spell(122470),
    DiffuseMagic = Spell(122783), --Talent
    DampenHarm = Spell(122278), --Talent

    -- Utility
    Detox = Spell(218164),
    Effuse = Spell(116694),
    EnergizingElixir = Spell(115288), --Talent
    TigersLust = Spell(116841), --Talent
    LegSweep = Spell(119381), --Talent
    Disable = Spell(116095),
    HealingElixir = Spell(122281), --Talent
    Paralysis = Spell(115078),

    -- Legendaries
    TheEmperorsCapacitor = Spell(235054),

    -- Tier Set
    PressurePoint = Spell(247255),
}

RubimRH.Spell[4] = {
    Evasion = Spell(5277),
    SliceandDice = Spell(5171),
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
    Eviscerate = Spell(6761),
    ExposeArmor = Spell(26866),
    Garrote = Spell(48676),
    KidneyShot = Spell(8643),
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
    mainhandpoison_instant = Spell(6495), -- sentry totem
    offhandpoison_instant = Spell(370), -- purge
    mainhandpoison_instant1 = Spell(25500), -- frostbrand weapon
    offhandpoison_instant1 = Spell(8017), -- rockbiter weapon
    KillingSpree = Spell(51690),
    FanofKnives = Spell(51723),
    ColdBlood = Spell(14177),
    SB = Spell(20777),         -- ascestral spirit --/use [@player] Saronite Bomb
    GTSC = Spell(20549),       -- war stomp--/use [@player] Global Thermal Sapper Charge
    trinket_gloves = Spell(52127), --water shield
    HungerforBlood = Spell(51662),
    HungerforBloodBuff = Spell(63848),
    Mutilate = Spell(1329),
    Shadowstrike = Spell(399985),
    shadowstrike = Spell(20594), --human racials
}


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
}

--ELE
RubimRH.Spell[7] = {
	LightningBolt1 = Spell(403),
	lightningbolt1 = Spell(25203), -- demo shout
	Bloodlust = Spell(2825),
	bloodlust = Spell(1719), -- recklessness
	FlameTongueBuff = Spell(24384),
	FlameTongueWeapon = Spell(16342),
	flametongue = Spell(2457), -- battle stance
	trinket = Spell(30219), -- cleave
	trinket2 = Spell(26296), -- warstomp
	EarthElementalTotem = Spell(2062),
	earthelementaltotem = Spell(20549), -- warstomp
	FireElementalTotem = Spell(2894),
	fireelementaltotem = Spell(7744), -- will of the forsaken
	Drink = Spell(27089),
	TotemofWrathBuff = Spell(30708),
	TotemofWrath = Spell(30706),
	totemofwrath = Spell(33697),--blood fury
	Default = Spell(1),
	FireNovaTotem = Spell(25547),
	firenovatotem = Spell(12328), --sweeping strikes
	ElementalMastery = Spell(16166),
	elementalmastery = Spell(12292), --death wish
	LesserHealingWave = Spell(25420),
	lesserhealingwave = Spell(1161), --challenging shout
    ChainLightning = Spell(25442),
	chainlightning = Spell(7384), -- overpower
    LightningBolt = Spell(25449),
	lightningbolt = Spell(2458), -- berserker stance
    WaterShield = Spell(33736),
	watershield = Spell(6673), --battle shout
	EarthShock = Spell(25454),
	earthshock = Spell(23881), --bloodthirst
	FlameShock = Spell(25457),
	flameshock = Spell(1464), --slam
	FrostShock = Spell(25464),
	frostshock = Spell(5246), --intimidating shout
	GroundingTotem = Spell(8177),
	groundingtotem = Spell(136147), --piercing howl
}

-- Enhancement
RubimRH.Spell[263] = {
    -- Racials
    BloodFury = Spell(336970),
    Berserking = Spell(26297),
    -- Abilities
    WindShear = Spell(57994),
    AncestralSpirit = Spell(2008),
    CrashLightning = Spell(187874),
    EarthElemental = Spell(198103),
    AstralShift = Spell(108271),
    EarthbindTotem = Spell(2484),
    Bloodlust = Spell(2825),
    CapacitorTotem = Spell(192058),
    FeralSpirit = Spell(51533),
    CleanseSpirit = Spell(51886),
    Flametongue = Spell(193796),
    Frostbrand = Spell(196834),
    Purge = Spell(370),
    GhostWolf = Spell(2645),
    Rockbiter = Spell(193786),
    HealingSurge = Spell(188070),
    SpiritWalk = Spell(58875),
    Hex = Spell(51514),
    Stormstrike = Spell(17364),
    LavaLash = Spell(60103),
    TremorTotem = Spell(8143),
    LightningBolt = Spell(187837),
    -- Talents
    LightningShield = Spell(192106),
    HotHand = Spell(201900),
    BoulderFist = Spell(246035),
    Landslide = Spell(197992),
    ForcefulWinds = Spell(262647),
    TotemMastery = Spell(262395),
    SpiritWolf = Spell(260878),
    EarthShield = Spell(974),
    StaticCharge = Spell(265046),
    SearingAssault = Spell(192087),
    Hailstorm = Spell(210853),
    Overcharge = Spell(210727),
    NaturesGuardian = Spell(30884),
    FeralLunge = Spell(196884),
    WindRushTotem = Spell(192077),
    CrashingStorm = Spell(192246),
    FuryOfAir = Spell(197211),
    Sundering = Spell(197214),
    ElementalSpirits = Spell(262624),
    EarthenSpike = Spell(188089),
    Ascendance = Spell(114051),
    TotemMastery = Spell(262395),
    -- Passives // Buffs
    GatheringStorms = Spell(198300),
    Stormbringer = Spell(201845),
    ResonanceTotemBuff = Spell(262417),
    LandslideBuff = Spell(202004),
    -- Morphed Spells
    Windstrike = Spell(115356)
}

----ROGUE
--ASS

--SUB
RubimRH.Spell[261] = {
    -- Racials
    ArcanePulse = Spell(260364),
    ArcaneTorrent = Spell(50613),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    Shadowmeld = Spell(58984),
    -- Abilities
    Backstab = Spell(53),
    Eviscerate = Spell(196819),
    Nightblade = Spell(195452),
    ShadowBlades = Spell(121471),
    ShurikenComboBuff = Spell(245640),
    ShadowDance = Spell(185313),
    ShadowDanceBuff = Spell(185422),
    Shadowstrike = Spell(185438),
    ShurikenStorm = Spell(197835),
    ShurikenToss = Spell(114014),
    Stealth = Spell(1784),
    Stealth2 = Spell(115191), -- w/ Subterfuge Talent
    SymbolsofDeath = Spell(212283),
    Vanish = Spell(1856),
    VanishBuff = Spell(11327),
    VanishBuff2 = Spell(115193), -- w/ Subterfuge Talent
    -- Talents
    Alacrity = Spell(193539),
    DarkShadow = Spell(245687),
    DeeperStratagem = Spell(193531),
    EnvelopingShadows = Spell(238104),
    FindWeaknessDebuff = Spell(91021),
    Gloomblade = Spell(200758),
    MarkedforDeath = Spell(137619),
    MasterofShadows = Spell(196976),
    Nightstalker = Spell(14062),
    SecretTechnique = Spell(280719),
    ShadowFocus = Spell(108209),
    ShurikenTornado = Spell(277925),
    Subterfuge = Spell(108208),
    Vigor = Spell(14983),
    -- Azerite Traits
    SharpenedBladesBuff = Spell(272916),
    -- Defensive
    CrimsonVial = Spell(185311),
    Feint = Spell(1966),
    -- Utility
    Blind = Spell(2094),
    CheapShot = Spell(1833),
    Kick = Spell(1766),
    KidneyShot = Spell(408),
    Sprint = Spell(2983),
    -- Misc
}

----HUNTER
--BeastMastery

----DRUID
-- Feral
RubimRH.Spell[103] = {
    Regrowth = Spell(8936),
    Bloodtalons = Spell(155672),
    CatForm = Spell(768),
    Prowl = Spell(5215),
    IncarnationBuff = Spell(102543),
    JungleStalkerBuff = Spell(252071),
    Berserk = Spell(106951),
    TigersFury = Spell(5217),
    TigersFuryBuff = Spell(5217),
    Berserking = Spell(26297),
    FeralFrenzy = Spell(274837),
    Incarnation = Spell(102543),
    BerserkBuff = Spell(106951),
    Shadowmeld = Spell(58984),
    Rake = Spell(1822),
    RakeDebuff = Spell(155722),
    BloodtalonsBuff = Spell(145152),
    CatFormBuff = Spell(768),
    ProwlBuff = Spell(5215),
    ShadowmeldBuff = Spell(58984),
    FerociousBite = Spell(22568),
    RipDebuff = Spell(1079),
    Sabertooth = Spell(202031),
    PredatorySwiftnessBuff = Spell(69369),
    ApexPredatorBuff = Spell(252752),
    MomentofClarity = Spell(236068),
    SavageRoar = Spell(52610),
    SavageRoarBuff = Spell(52610),
    Rip = Spell(1079),
    FerociousBiteMaxEnergy = Spell(22568),
    BrutalSlash = Spell(202028),
    ThrashCat = Spell(106830),
    ThrashCatDebuff = Spell(106830),
    MoonfireCat = Spell(155625),
    MoonfireCatDebuff = Spell(155625),
    ClearcastingBuff = Spell(135700),
    SwipeCat = Spell(106785),
    Shred = Spell(5221),
    LunarInspiration = Spell(155580)
}
-- Guardian
RubimRH.Spell[104] = {
    -- Racials
    WarStomp = Spell(20549),
    Berserking = Spell(26297),
    -- Abilities
    FrenziedRegeneration = Spell(22842),
    Gore = Spell(210706),
    GoreBuff = Spell(93622),
    GoryFur = Spell(201671),
    Ironfur = Spell(192081),
    Mangle = Spell(33917),
    Maul = Spell(6807),
    Moonfire = Spell(8921),
    MoonfireDebuff = Spell(164812),
    Sunfire = Spell(197630),
    SunfireDebuff = Spell(164815),
    Starsurge = Spell(197626),
    LunarEmpowerment = Spell(164547),
    SolarEmpowerment = Spell(164545),
    LunarStrike = Spell(197628),
    Wrath = Spell(197629),
    Regrowth = Spell(8936),
    Swipe = Spell(213771),
    Thrash = Spell(77758),
    ThrashDebuff = Spell(192090),
    ThrashCat = Spell(106830),
    Prowl = Spell(5215),
    -- Talents
    BalanceAffinity = Spell(197488),
    BloodFrenzy = Spell(203962),
    Brambles = Spell(203953),
    BristlingFur = Spell(155835),
    Earthwarden = Spell(203974),
    EarthwardenBuff = Spell(203975),
    FeralAffinity = Spell(202155),
    GalacticGuardian = Spell(203964),
    GalacticGuardianBuff = Spell(213708),
    GuardianOfElune = Spell(155578),
    GuardianOfEluneBuff = Spell(213680),
    Incarnation = Spell(102558),
    LunarBeam = Spell(204066),
    Pulverize = Spell(80313),
    PulverizeBuff = Spell(158792),
    RestorationAffinity = Spell(197492),
    SouloftheForest = Spell(158477),
    MightyBash = Spell(5211),
    Typhoon = Spell(132469),
    Entanglement = Spell(102359),
    -- Artifact
    RageoftheSleeper = Spell(200851),
    -- Defensive
    SurvivalInstincts = Spell(61336),
    Barkskin = Spell(22812),
    -- Utility
    Growl = Spell(6795),
    SkullBash = Spell(106839),
    -- Affinity
    FerociousBite = Spell(22568),
    HealingTouch = Spell(5185),
    Rake = Spell(1822),
    RakeDebuff = Spell(155722),
    Rejuvenation = Spell(774),
    Rip = Spell(1079),
    Shred = Spell(5221),
    Swiftmend = Spell(18562),
    -- Shapeshift
    BearForm = Spell(5487),
    CatForm = Spell(768),
    MoonkinForm = Spell(197625),
    TravelForm = Spell(783)
}

----DEATH KNIGHT
--FROST

----DEMONHUNTER
-- Vengeance

--- Warlock

-- Affliction
RubimRH.Spell[265] = {
    -- Baseline
    DemonicGateway = Spell(111771),
    CreateSoulwell = Spell(29893),
    EnslaveDemon = Spell(1098),
    UnendingResolve = Spell(104773),
    Soulstone = Spell(20707),
    RitualOfSummoning = Spell(698),
    CommandDemon = Spell(119898),
    SummonFelhunter = Spell(691),
    Banish = Spell(710),
    SummonSuccubus = Spell(712),
    UnendingBreath = Spell(5697),
    HealthFunnel = Spell(755),
    SummonVoidwalker = Spell(697),
    CreateHealthstone = Spell(6201),
    Fear = Spell(5782),
    SummonImp = Spell(688),
    -- Specialization
    PotentAfflictions = Spell(77215),
    Shadowfury = Spell(30283),
    SummonDarkglare = Spell(205180),
    Agony = Spell(980),
    SeedOfCorruption = Spell(27243),
    UnstableAffliction = Spell(30108),
    UnstableAfflictionDot = Spell(233490),
    DrainLife = Spell(234153),
    Corruption = Spell(172),
    CorruptionPerma = Spell(146739),
    ShadowBolt = Spell(232670),
    -- Talents
    CreepingDeath = Spell(264000),
    Deathbolt = Spell(264106),
    DarkSoulMisery = Spell(113860),
    SoulConduit = Spell(215941),
    GrimoireOfSacrifice = Spell(108503),
    Haunt = Spell(48181),
    PhantomSingularity = Spell(205179),
    SowTheSeeds = Spell(196226),
    VileTaint = Spell(278350),
    AbsoluteCorruption = Spell(196103),
    WritheInAgony = Spell(196102),
    DrainSoul = Spell(198590),
    Nightfall = Spell(108558),
    SiphonLife = Spell(63106)
}

--Demonology
RubimRH.Spell[266] = {
    -- Racials
    ArcaneTorrent = Spell(25046),
    Berserking = Spell(26297),
    BloodFury = Spell(20572),
    GiftoftheNaaru = Spell(59547),
    Shadowmeld = Spell(58984),
    LightsJudgment = Spell(255647),

    -- Abilities
    DrainLife = Spell(234153),
    LifeTap = Spell(1454),
    SummonDoomGuard = Spell(18540),
    SummonDoomGuardSuppremacy = Spell(157757),
    SummonInfernal = Spell(1122),
    SummonInfernalSuppremacy = Spell(157898),
    SummonImp = Spell(688),
    GrimoireImp = Spell(111859),
    SummonFelguard = Spell(30146),
    GrimoireFelguard = Spell(111898),
    DemonicEmpowerment = Spell(193396),
    DemonWrath = Spell(193440),
    Doom = Spell(603),
    HandOfGuldan = Spell(105174),
    ShadowBolt = Spell(686),
    CallDreadStalkers = Spell(104316),
    Fear = Spell(5782),

    -- Pet abilities
    CauterizeMaster = Spell(119905), --imp
    Suffering = Spell(119907), --voidwalker
    SpellLock = Spell(119910), --Dogi
    Whiplash = Spell(119909), --Bitch
    FelStorm = Spell(119914), --FelGuard
    ShadowLock = Spell(171140), --doomguard
    MeteorStrike = Spell(171152), --infernal
    AxeToss = Spell(89766), --FelGuard

    -- Talents
    ShadowyInspiration = Spell(196269),
    ShadowFlame = Spell(205181),
    DemonicCalling = Spell(205145),

    ImpendingDoom = Spell(196270),
    ImprovedStalkers = Spell(196272),
    Implosion = Spell(196277),

    DemonicCircle = Spell(48018),
    MortalCoil = Spell(6789),
    ShadowFury = Spell(30283),

    HandOfDoom = Spell(196283),
    PowerTrip = Spell(196605),
    SoulHarvest = Spell(196098),

    GrimoireOfSupremacy = Spell(152107),
    GrimoireOfService = Spell(108501),
    GrimoireOfSynergy = Spell(171975),

    SummonDarkGlare = Spell(205180),
    Demonbolt = Spell(157695),
    SoulConduit = Spell(215941),

    -- Artifact
    TalkielConsumption = Spell(211714),
    StolenPower = Spell(211530),
    ThalkielsAscendance = Spell(238145),

    -- Defensive
    UnendingResolve = Spell(104773),

    -- Utility

    -- Legendaries
    SephuzBuff = Spell(208052),
    NorgannonsBuff = Spell(236431),

    -- Misc
    Concordance = Spell(242586),
    DemonicCallingBuff = Spell(205146),
    GrimoireOfSynergyBuff = Spell(171982),
    ShadowyInspirationBuff = Spell(196606)
}