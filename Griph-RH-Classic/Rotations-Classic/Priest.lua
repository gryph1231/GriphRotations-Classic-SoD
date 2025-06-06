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


GriphRH.Spell[5] = {
    Smite = Spell(585),
	MindFlay = Spell(15407),
	PowerWordShield = Spell(17),
	FlashHeal = Spell(10916),
	MindFlay6 = Spell(18807),
	Heal = Spell(6064),
	GreaterHeal = Spell(10965),
	MindSear = Spell(413259),
	Renew = Spell(139),
	VoidZone = Spell(431681),
	LesserHeal = Spell(2053),
	Resurrection = Spell(2006),
	Fade = Spell(586),
	Homunculi = Spell(402799),
	DispelMagic = Spell(527),
	MindBlast = Spell(8092),
	ShadowWordPain = Spell(589),
	ShadowWordDeath = Spell(401955),
	InnerFocus = Spell(14751),
	PowerWordFortitude = Spell(1243),
	Penance = Spell(402174),
	ShadowProtection = Spell(976),
	Shoot = Spell(5019),
	ShadowReach = Spell(17325),
	EyeoftheVoid = Spell(402789),
	cancelchannel = Spell(20594), -- stone form used as keybind to cancel cast in game with T 2.5 2 piece set for mindflay so bindpad /stopcast to stoneform
	VoidPlague = Spell(425204),
	InnerFire = Spell(588),
	CureDisease = Spell(528),
	PsychicScream = Spell(8122),
	Silence = Spell(15487),
	Shadowfiend = Spell(401977), 
	Shadowform = Spell(15473),
	Default = Spell(1),
	TouchofWeakness = Spell(2652),
	DevouringPlague = Spell(2944),
	VampiricEmbrace = Spell(15286),
	VampiricTouch= Spell(402668), --BP keybind: /cast [mod:SELFCAST,@player][mod:FOCUSCAST,@focus][] Cloak Rune Ability -- GGL keybind shadowmeld
	vampirictouch= Spell(20580), --BP keybind: /cast [mod:SELFCAST,@player][mod:FOCUSCAST,@focus][] Cloak Rune Ability -- GGL keybind shadowmeld
	Dispersion = Spell(425294),
	AbolishDisease = Spell(552),
	MindSpike = Spell(431655),
};

local S = GriphRH.Spell[5]

S.VoidPlague.TextureSpellID = { 425294 }    -- kb void plague to boot rune - dispersion will show for the time-being as void plague not recognized



S.Smite:RegisterInFlight()
S.Shoot:RegisterInFlight()
S.MindSpike:RegisterInFlight()

	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	
local function APL()

	if S.ShadowReach:IsAvailable() then
		targetRange36 = IsSpellInRange("Mind Blast")
	else
		targetRange36 = TargetinRange(30)
	end


	if S.MindFlay6:IsAvailable() then
		targetRange24 = IsSpellInRange("Mind Flay")
	else
		targetRange24 = TargetinRange(25)
	end

	local Shoot = 0


	for ActionSlot = 1, 120 do
		local ActionText = GetActionTexture(ActionSlot)
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Shoot')
		
		if ActionText == icon then
			Shoot = ActionSlot
		end
	end

--  	local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo("player")

-- print(startTimeMS-endTimeMS)


	if Target:Exists() and getCurrentDPS() and getCurrentDPS()>0 then
targetTTD = UnitHealth('target')/getCurrentDPS()
else targetTTD = 8888
end

    local targetdying = (aoeTTD() < 3.5 and not Target:IsAPlayer() or targetTTD<3.5 and not Target:IsAPlayer() or Target:IsAPlayer() and Target:HealthPercentage()<20)

    local inRange25 = 0
        for i = 1, 10 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end
local targetrunning = (GetUnitSpeed("target") /7 *100)>90
local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

local _,instanceType = IsInInstance()
local startTimeMS = (select(4, UnitCastingInfo('target')) or select(4, UnitChannelInfo('target')) or 0)

local elapsedTimeca = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local elapsedTimech = ((startTimeMS > 0) and (GetTime() * 1000 - startTimeMS) or 0)

local channelTime = elapsedTimech / 1000

local castTime = elapsedTimeca / 1000

local castchannelTime = math.random(275, 500) / 1000

local nameSharedPain = GetSpellInfo('Shared Pain')


if AuraUtil.FindAuraByName("Mind Spike", "target", "PLAYER|HARMFUL") then
	mindspikestack = select(3, AuraUtil.FindAuraByName("Mind Spike", "target", "PLAYER|HARMFUL"))
else
	mindspikestack = 0
end


if AuraUtil.FindAuraByName("Mind Spike", "target", "PLAYER|HARMFUL") then
	mindspikeremains = select(6, AuraUtil.FindAuraByName("Mind Spike", "target", "PLAYER|HARMFUL")) - GetTime()
else
	mindspikeremains = 0
end

if Player:IsChanneling(S.MindFlay6) then

	channelremaining = Player:ChannelRemains()
else
	channelremaining = 3
end
if (Player:IsCasting() or Player:IsChanneling()) and Player:IsChanneling(S.MindFlay6) then
	mindflaytimer = Player:CastDuration()
else
mindflaytimer = 0
end

-- print(GetMobsInCombat())

-- print(Player:CastDuration())
if (channelremaining<1 or IsReady("Mind Blast")) and mindflaytimer>2.5 and Player:IsChanneling(S.MindFlay6)  then
	return S.cancelchannel:Cast()
end

if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", true
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") 
or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", true
end


if GriphRH.QueuedSpell():ID() == S.PsychicScream:ID() and (S.PsychicScream:CooldownRemains()>2 or not IsUsableSpell("Psychic Scream") or RangeCount(10)==0) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end

if GriphRH.QueuedSpell():ID() == S.PowerWordShield:ID() and (not IsUsableSpell("Power Word: Shield") or not IsReady("Power Word: Shield") or AuraUtil.FindAuraByName("Weakened Soul","player","PLAYER|HARMFUL")) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.Dispersion:ID() and (S.Dispersion:CooldownRemains()>2 or inRange25==0 or not Player:AffectingCombat()) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end

if GriphRH.QueuedSpell():ID() == S.Dispersion:ID() and S.Dispersion:CooldownRemains()<2 then
	return S.Dispersion:Cast()
end
if GriphRH.QueuedSpell():ID() == S.FlashHeal:ID() and (IsCurrentSpell(SpellRank('Flash Heal')) or not IsUsableSpell("Flash Heal") or Player:MovingFor()>.15) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.Heal:ID() and ( IsCurrentSpell(SpellRank('Heal')) or not IsUsableSpell("Heal") or Player:MovingFor()>.15) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.GreaterHeal:ID() and ( IsCurrentSpell(SpellRank('Greater Heal')) or not IsUsableSpell("Greater Heal") or Player:MovingFor()>.15) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.Fade:ID() and (not IsUsableSpell("Fade") or S.Fade:CooldownRemains()>2) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.DispelMagic:ID() and (not IsUsableSpell("Dispel Magic") or not CanTargetBePurged()) then
	GriphRH.queuedSpell = { GriphRH.Spell[5].Default, 0 }
end
if GriphRH.QueuedSpell():ID() == S.Fade:ID() and IsUsableSpell("Fade") then
	return GriphRH.QueuedSpell():Cast()
end
if GriphRH.QueuedSpell():ID() == S.PsychicScream:ID() and IsUsableSpell("Psychic Scream")then
	return GriphRH.QueuedSpell():Cast()
end
if GriphRH.QueuedSpell():ID() == S.DispelMagic:ID() and CanTargetBePurged() and IsUsableSpell("Dispel Magic") and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
	return GriphRH.QueuedSpell():Cast()
end
if GriphRH.QueuedSpell():ID() == S.PowerWordShield:ID() and S.PowerWordShield:CooldownRemains()<2  then
	return GriphRH.QueuedSpell():Cast()
end


if GriphRH.QueuedSpell():ID() == S.FlashHeal:ID() and not IsCurrentSpell(SpellRank('Flash Heal')) and IsUsableSpell("Flash Heal") then
	return GriphRH.QueuedSpell():Cast()
end

if GriphRH.QueuedSpell():ID() == S.GreaterHeal:ID() and not IsCurrentSpell(SpellRank('Greater Heal')) and IsUsableSpell("Greater Heal") then
	return GriphRH.QueuedSpell():Cast()
end

if GriphRH.QueuedSpell():ID() == S.Heal:ID() and not IsCurrentSpell(SpellRank('Heal')) and IsUsableSpell("Heal") then
	return GriphRH.QueuedSpell():Cast()
end

local aoeDots = (inRange25>=3 or GetMobsInCombat()>=3) and GriphRH.AoEON()


-- print(GetNumGroupMembers()())
if IsReady('Shadowform') and not AuraUtil.FindAuraByName("Shadowform","player") then
	return S.Shadowform:Cast()
end



if AuraUtil.FindAuraByName("Divine Protection","target") 
or AuraUtil.FindAuraByName("Ice Block","target") 
or AuraUtil.FindAuraByName("Invulnerability","target") 
 then
    stoprotation = true
else
    stoprotation = false
end

if stoprotation == false and Player:CanAttack(Target) and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") 
and (Player:AffectingCombat() or IsCurrentSpell(5019) or Target:AffectingCombat() or IsCurrentSpell(6603) or S.Smite:InFlight() or S.MindSpike:InFlight())
 and not Target:IsDeadOrGhost() then 


	if AuraUtil.FindAuraByName('Inner Focus', "player") then
		if not Player:IsMoving() and IsReady("Mind Blast") and targetRange36 then 
			return S.MindBlast:Cast()
			end
			if IsReady("Shadow Word: Death") and targetRange36 then
			return S.ShadowWordDeath:Cast()
		end
	end
	
	
	
		if IsReady("Mind Sear") and nameSharedPain == "Shared Pain" and  targetRange36 
		and AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") 
		and not Player:IsMoving() and targetRange36 and (GetMobsInCombat()>=5 or inRange25>=5) then
			return S.MindSear:Cast()
		end	
	
		if IsReady('Shadow Word: Death') and  targetRange36 
		and (AuraUtil.FindAuraByName("Inner Focus","player") and (Player:IsMoving() or not IsReady("Mind Blast") and not Player:IsMoving())  
		or not Target:IsAPlayer() and (UnitHealth('target')<1500 or UnitHealthMax('target')>100000 and (targetTTD<5 and HL.CombatTime()>3 or UnitHealth('target')<2500))
		or Target:IsAPlayer() and Target:HealthPercentage()<20) then
			return S.ShadowWordDeath:Cast()
		end
	
		if IsReady("Silence") and spellwidgetfort~='Widget Fortress' and (castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) and  targetRange36 and GriphRH.InterruptsON() then
			return S.Silence:Cast()
		end
	
		if IsReady("Psychic Scream") and RangeCount(10)>=1 and  ((castTime > 0.25+castchannelTime or channelTime > 0.25+castchannelTime) or Player:HealthPercentage() < 40 and Target:IsAPlayer())  and GriphRH.InterruptsON() then
			return S.PsychicScream:Cast()
		end	
		
		if IsReady("Dispersion") and inRange25>=1 and (instanceType == 'pvp' or Target:IsAPlayer()) and not AuraUtil.FindAuraByName("Power Word: Shield","player") and Player:HealthPercentage()<15 then
			return S.Dispersion:Cast()
		end	
	
		if IsReady("Power Word: Shield") and UnitName("targettarget") == UnitName("player") and RangeCount(10)>=1 
		and (instanceType== 'none' or isTanking == true or Target:IsAPlayer() or instanceType == 'pvp') and not AuraUtil.FindAuraByName("Dispersion","player") 
		and not AuraUtil.FindAuraByName("Power Word: Shield","player") and not AuraUtil.FindAuraByName("Weakened Soul","player","PLAYER|HARMFUL") then
			return S.PowerWordShield:Cast()
		end	
		
	
		-- if IsReady("Renew") and not AuraUtil.FindAuraByName("Shadowform","player") and Player:ManaPercentage()>40 and Player:HealthPercentage() < 60 and not AuraUtil.FindAuraByName("Renew","player") then
		-- 	return S.Renew:Cast()
		-- end	
	
		if IsReady("Abolish Disease") and GriphRH.InterruptsON() and GetAppropriateCureSpell() == "Disease" and not AuraUtil.FindAuraByName("Shadowform","player") then
			return S.AbolishDisease:Cast()
		end
	
		if IsReady("Cure Disease") and GriphRH.InterruptsON() and GetAppropriateCureSpell() == "Disease" and not Target:IsAPlayer() and Player:ManaPercentage()>80 and not AuraUtil.FindAuraByName("Shadowform","player")  then
			return S.CureDisease:Cast()
		end
	
	
		if IsReady('Shadow Word: Pain') and (HL.CombatTime()<4 or Target:IsAPlayer() or Player:IsMoving() or targetTTD>4) and aoeDots 
		and nameSharedPain == "Shared Pain" and  targetRange36 and not AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") then
			return S.ShadowWordPain:Cast()
		end
	
		if IsReady("Mind Sear") and nameSharedPain == "Shared Pain" and  targetRange36 
		and AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") and not Player:IsMoving() 
		 and targetRange36 and (inRange25>=4 or GetMobsInCombat()>=4) then
			return S.MindSear:Cast()
		end	
	
		if IsReady('Void Plague') and (HL.CombatTime()<4 or targetTTD>4 or Target:IsAPlayer() or Player:IsMoving()) 
		and targetRange36 and not AuraUtil.FindAuraByName("Void Plague","target","PLAYER|HARMFUL") then
			return S.VoidPlague:Cast()
		end
		if IsReady('Void Zone') and  targetRange36 and not Player:IsMoving() and aoeDots then
			return S.VoidZone:Cast() 
		end
	
		if IsReady("Dispersion") and not targetdying and targetRange36 and instanceType~= 'pvp' 
		and (not AuraUtil.FindAuraByName("Power Word: Shield","player") and inRange25>=1 and Player:HealthPercentage()<25 or Player:ManaPercentage()<50) 
		and GriphRH.CDsON() then
			return S.Dispersion:Cast()
		end	
	
		if IsReady('Eye of the Void') and  targetRange36 and GriphRH.CDsON() then
			return S.EyeoftheVoid:Cast()
		end
	
		if IsReady('Shadow Word: Pain') and (HL.CombatTime()<4 or Player:IsMoving() or targetTTD>4 or Target:IsAPlayer()) 
		and targetRange36 and not AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") then
			return S.ShadowWordPain:Cast()
		end
	

		if IsReady('Mind Flay') and targetRange24 and not Player:IsMoving() and AuraUtil.FindAuraByName("Melting Faces","player") then
			return S.MindFlay:Cast()
		end

		if not Player:IsMoving() and IsReady("Mind Blast") and targetRange36 and AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") then 
			return S.MindBlast:Cast()
		end
	

		if IsReady('Vampiric Touch') and aoeDots and CanCastWithTolerance("Vampiric Touch") and not Player:IsMoving() 
		and not AuraUtil.FindAuraByName("Inner Focus","player") and (targetTTD>4 or Target:IsAPlayer() and Target:HealthPercentage()>50) 
		and targetRange36 and not AuraUtil.FindAuraByName("Vampiric Touch","target","PLAYER|HARMFUL") then
			return S.vampirictouch:Cast()
		end
	
		if IsReady("Inner Focus") and GriphRH.CDsON() and ( IsReady("Mind Blast")  and not Player:IsMoving() or Player:IsMoving() 
		and IsReady("Shadow Word: Death") )then
			return S.InnerFocus:Cast()
		end

		
		if IsReady('Devouring Plague') and (targetTTD>7 or Target:IsAPlayer()) and  targetRange36 and GriphRH.CDsON() then
			return S.DevouringPlague:Cast()
		end

		if not Player:IsMoving() and IsReady("Mind Blast") and targetRange36  then 
			return S.MindBlast:Cast()
		end
	
		if IsReady('Shadow Word: Death') and targetRange36 then
			return S.ShadowWordDeath:Cast()
		end

		if IsReady('Homunculi') and targetRange36 and GriphRH.CDsON() then
			return S.Homunculi:Cast()
		end
	
		if IsReady('Shadowfiend') and Player:ManaPercentage()<=50 and targetRange36 and GriphRH.CDsON() then
			return S.Shadowfiend:Cast()
		end




		--heals
		if IsReady('Vampiric Embrace') and HL.CombatTime()>3 and (targetTTD>4 or Target:IsAPlayer() and Target:HealthPercentage()>50) 
		and targetRange36 and not AuraUtil.FindAuraByName("Vampiric Embrace","target","PLAYER|HARMFUL") then
			return S.VampiricEmbrace:Cast()
		end
	
		--mana
		if IsReady('Vampiric Touch') and CanCastWithTolerance("Vampiric Touch") and not Player:IsMoving() 
		and (targetTTD>4 or Target:IsAPlayer() and Target:HealthPercentage()>50) and HL.CombatTime()>3
		and targetRange36 and not AuraUtil.FindAuraByName("Vampiric Touch","target","PLAYER|HARMFUL") then
			return S.vampirictouch:Cast()
		end

		
		if IsReady('Penance') and not Player:IsMoving() and  targetRange36  then
			return S.Penance:Cast()
		end

		
	

		if IsReady('Mind Flay') and targetRange24 and not Player:IsMoving() then
			return S.MindFlay:Cast()
		end
		
		if IsReady('Mind Sear') and targetRange36 and (GetMobsInCombat()>=2) and not Player:IsMoving() and GriphRH.AoEON() then
			return S.MindSear:Cast()
		end

		if IsReady('Mind Spike') and targetRange36 and not Player:IsMoving() then
			return S.MindSpike:Cast() 
		end
	
		if IsReady('Mind Sear') and targetRange36 and not Player:IsMoving() then
			return S.MindSear:Cast()
		end
	
		if IsReady('Smite') and  targetRange36 and not Player:IsMoving() and not AuraUtil.FindAuraByName("Shadowform","player") then
			return S.Smite:Cast() 
		end
	
		if GCDRemaining()==0  and not IsAutoRepeatAction(Shoot) and not IsCurrentSpell(5019) and not Player:IsMoving() and  targetRange36 and Player:ManaPercentage()<10 then
			return "Interface\\Addons\\Griph-RH-Classic\\Media\\ABILITY_SHOOTWAND.blp", false
		end
	
		-- if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		-- 	return Item(135274, { 13, 14 }):ID()
		-- end
	--test test
	
	
	end
	
	
	
	if not Player:AffectingCombat() and not AuraUtil.FindAuraByName('Drained of Blood', "player", "PLAYER|HARMFUL") then 
	
		if IsReady("Power Word: Fortitude") and not Target:IsAPlayer() and Player:IsMoving() and not AuraUtil.FindAuraByName("Prayer of Fortitude","player") and not AuraUtil.FindAuraByName("Power Word: Fortitude","player") then
		return S.PowerWordFortitude:Cast()
		end	
	
		if IsReady("Inner Fire") and not Target:IsAPlayer() and Player:IsMoving() and not AuraUtil.FindAuraByName("Inner Fire","player") then
		return S.InnerFire:Cast()
		end	
	
		if IsReady('Shadow Protection') and not Target:IsAPlayer() and Player:IsMoving() and not AuraUtil.FindAuraByName("Prayer of Shadow Protection","player") and not AuraUtil.FindAuraByName("Shadow Protection","player") then
		return S.ShadowProtection:Cast()
		end
	
		if IsReady('Touch of Weakness') and not Target:IsAPlayer() and Player:ManaPercentage()>80 and Player:IsMoving() and instanceType== 'none'  and not AuraUtil.FindAuraByName("Touch of Weakness","player") then
			return S.TouchofWeakness:Cast()
		end
		
		end
		return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
	end
		
	GriphRH.Rotation.SetAPL(5, APL);
	GriphRH.Rotation.SetPASSIVE(5, PASSIVE);