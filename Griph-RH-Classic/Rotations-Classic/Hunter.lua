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

GriphRH.Spell[3] = {
	AspectoftheFalcon = Spell(469145),
	Default = Spell(30681),
	ChimeraShot = Spell(409433),
KillShot = Spell(409974),
MongooseBite = Spell(14271),
	ViperSting = Spell(14279),
	BestialWrath = Spell(19574),
	RaptorStrike = Spell(14262),
	AutoShot = Spell(75),
	AimedShot = Spell(19434),
	WyvernStrike = Spell(458479),
	Multishot = Spell(14288),
	ExplosiveShot = Spell(409552),
	HeartoftheLion = Spell(409580),
	HeartoftheLionz = Spell(20190), --aspect of the wild
	AutoShotz = Spell(19263), --deterrence
	LockedIn = Spell(468388),
	AutoAttack = Spell(6603),
	MendPet = Spell(3662),
	MendPetz = Spell(20549), --war stomp
	Carve = Spell(425711),
    WyvernSting = Spell(19386),
	AspectoftheViper = Spell(415423),
	AspectoftheMonkey = Spell(13163),
	AspectoftheViperz = Spell(13161), --aspect of the beast
	AspectoftheCheetah = Spell(5118),
	AspectoftheCheetahCancel = Spell(19878), --track demons
	Carvez = Spell(20594), --stoneform
	AspectoftheHawk = Spell(13165),
	ArcaneShot = Spell(3044),
	FlankingStrike = Spell(415320),
	Counterattack = Spell(19306),
	SerpentSting = Spell(13550),
	RapidFire = Spell(3045),
	WingClip = Spell(14267),
	ConcussiveShot = Spell(5116),
	FeedPet = Spell(6991),
	Flare = Spell(1543),
	Intimidation = Spell(19577),
	FeedPetBuff = Spell(1539),
	FeignDeath = Spell(5384),
	FrostTrap = Spell(409520),
	ExplosiveTrap = Spell(409532),
	TrueshotAura = Spell(20906),
	ImmolationTrap = Spell(13813),
	Disengage = Spell(14272),
	BloodFury = Spell(20572),
	FreezingTrap = Spell(1499),
};

local S = GriphRH.Spell[3]
S.KillShot.TextureSpellID = { 409974 } --flanking strike / leg rune slot G.g. 

if not Item.Hunter then
    Item.Hunter = {}
end

Item.Hunter.BeastMastery = {
};
local I = Item.Hunter.BeastMastery;

S.AutoShot:RegisterInFlight()
S.SerpentSting:RegisterInFlight()

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

local function CleaveCount()
local cleave_counter = 0

        for i=1,40 do
			local unitID = "nameplate" .. i
            if UnitExists("nameplate"..i) then           
                local nameplate_guid = UnitGUID("nameplate"..i) 
                local npc_id = select(6, strsplit("-",nameplate_guid))
                if npc_id ~='120651' and npc_id ~='161895' then
                    if UnitCanAttack("player",unitID) and IsActionInRange(37,unitID) and UnitHealthMax(unitID) > 5 then
                        cleave_counter = cleave_counter + 1
                    end                    
                end
            end
        end
    
    return cleave_counter
end

local function StingTime()
local _,_,_,_,_,expirationTime = AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL")

if expirationTime then
	timer = expirationTime - HL.GetTime()
else
	timer = nil
end
    return timer
end

local function PetHapiness()
local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local happy = ({"Unhappy", "Content", "Happy"})[happiness]
	local loyalty = loyaltyRate > 0 and "gaining" or "losing"
	return happy
end

local function ManaPct()
    return (UnitPower("Player", 0) / UnitPowerMax("Player", 0)) * 100
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

local function IsReady(spell,range_check,aoe_check)
	local start,duration,enabled = GetSpellCooldown(tostring(spell))
	local usable, noMana = IsUsableSpell(tostring(spell))
	local range_counter = 0
	local in_range = false

	for lActionSlot = 1, 120 do
		local lActionText = GetActionTexture(lActionSlot)
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spell)
	
		if lActionText == icon then
			if UnitExists("target") then
				in_range = IsActionInRange(lActionSlot,"target")
			end
		end
	end

	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	
	-- if gcd_remains and gcd_remains < 0 then 
		-- gcd_remains = 0 
	-- end

	if aoe_check then
		if Spell then
			for i = 1, 40 do
				local unitID = "nameplate" .. i
				if UnitExists(unitID) then           
					local nameplate_guid = UnitGUID(unitID) 
					local npc_id = select(6, strsplit("-", nameplate_guid))
					if npc_id ~= '120651' and npc_id ~= '161895' then
						if UnitCanAttack("player", unitID) and IsSpellInRange(Spell, unitID) == 1 and UnitHealthMax(unitID) > 5 then
							range_counter = range_counter + 1
						end                    
					end
				end
			end
		end
	end

	--if usable and enabled and cooldown_remains - gcd_remains < 0.5 and gcd_remains < 0.5 then
	if usable and enabled and cooldown_remains < 0.5 then
		if range_check then
			if in_range == true then 
				return true
			else
				return false
			end
		elseif aoe_check and not range_check then
			if range_counter >= aoe_check then
				return true
			else
				return false
			end
		elseif range_check and aoe_check then
			return 'Input range check or aoe check, not both'
		elseif not range_check and not aoe_check then
			return true
		end
	else
		return false
	end
end






local function APL()
CleaveCount()
IsReady()
ManaPct()
PetActive()
PetHapiness()
StingTime()
local namechimerashot = GetSpellInfo('Chimera Shot' )
local namekillshot = GetSpellInfo('Kill Shot' )
local nameraptorfury = GetSpellInfo('Raptor Fury' )
local nameexposeweakness = GetSpellInfo('Expose Weakness' )
local namewyvernstrike = GetSpellInfo('Wyvern Strike' )


nextauto = math.max(0, (GriphRH.lasthit()-UnitAttackSpeed('player'))*-1)


if namechimerashot == "Chimera Shot" and namekillshot == "Kill Shot" and nameraptorfury == "Raptor Fury" 
and nameexposeweakness == "Expose Weakness" and namewyvernstrike == "Wyvern Strike" then
	weave = true
else
	weave = false
end
if AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL") then
	serpentstingdebuffremains = select(6,AuraUtil.FindAuraByName("Serpent Sting","target","PLAYER|HARMFUL")) - GetTime()
	 else
		serpentstingdebuffremains = 0 
	end

if AuraUtil.FindAuraByName("Explosive Trap","player","PLAYER") then
    explosivetrapbuffremains = select(6,AuraUtil.FindAuraByName("Explosive Trap","player","PLAYER"))- GetTime()
else
    explosivetrapbuffremains = 0
end

if AuraUtil.FindAuraByName("Jom Gabbor","player") then
    JomGabbor =select(3,AuraUtil.FindAuraByName("Jom Gabbor","player"))
else
    JomGabbor = 0
end


-- if currentBottomRightSpellID then 
-- 	return Spell(tonumber(currentBottomRightSpellID)):Cast() 
-- end

if AuraUtil.FindAuraByName("Flanking Strike","player","PLAYER") then
	_, _, flankingstrikestacks = AuraUtil.FindAuraByName('Flanking Strike','player')
else
	flankingstrikestacks = 0
end

if AuraUtil.FindAuraByName("Flanking Strike","player","PLAYER") then
	flankingstrikeremains = select(6,AuraUtil.FindAuraByName("Flanking Strike","player","PLAYER")) - GetTime()

	 else
		flankingstrikeremains = 0 
	end


--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

local AutoShot = 0

for ActionSlot = 1, 120 do
	local ActionText = GetActionTexture(ActionSlot)
	
	local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Auto Shot')
	--local name1, rank1, icon1, castTime1, minRange1, maxRange1, spellID1, originalIcon1 = GetSpellInfo('Shoot')
	
	if ActionText == icon then
		AutoShot = ActionSlot
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if S.BestialWrath:ID() == GriphRH.queuedSpell[1]:ID() then
	if PetActive() and S.BestialWrath:CooldownRemains() < 2 then
		return S.BestialWrath:Cast()
	end

	if S.RapidFire:CooldownRemains() < 2 and not Player:IsMoving() and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.RapidFire:Cast()
	end
end


if GriphRH.queuedSpell[1]:CooldownRemains() > 2 or not UnitAffectingCombat('player')
	or (S.AspectoftheCheetah:ID() == GriphRH.queuedSpell[1]:ID() and AuraUtil.FindAuraByName("Aspect of the Cheetah", "player"))
	or ((S.ConcussiveShot:ID() == GriphRH.queuedSpell[1]:ID() or S.ViperSting:ID() == GriphRH.queuedSpell[1]:ID()) and IsSpellInRange('Auto Shot', 'target') == 0)
	or (S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and not CheckInteractDistance("target",3))
	or (S.BestialWrath:ID() == GriphRH.queuedSpell[1]:ID() and not PetActive())
	or (S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and AuraUtil.FindAuraByName("Wing Clip", "target", "HARMFUL"))
	or (S.Intimidation:ID() == GriphRH.queuedSpell[1]:ID() and not PetActive())
	or (S.ViperSting:ID() == GriphRH.queuedSpell[1]:ID() and UnitPower('target', SPELL_POWER_MANA) <= 0)
	or ((S.FrostTrap:ID() == GriphRH.queuedSpell[1]:ID() or S.ExplosiveTrap:ID() == GriphRH.queuedSpell[1]:ID()) and (AuraUtil.FindAuraByName("Silence","HARMFUL") or AuraUtil.FindAuraByName("Sonic Burst","HARMFUL"))) then
	GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
end

if S.Flare:ID() == GriphRH.queuedSpell[1]:ID() and S.Flare:CooldownRemains() < 2 then
	return S.Flare:Cast()
end

if not (AuraUtil.FindAuraByName("Silence","player","PLAYER|HARMFUL") and AuraUtil.FindAuraByName("Sonic Burst","player","PLAYER|HARMFUL")) then
	if S.FrostTrap:ID() == GriphRH.queuedSpell[1]:ID() and S.FrostTrap:CooldownRemains() < 2 then
		return S.FrostTrap:Cast()
	end

	if S.ExplosiveTrap:ID() == GriphRH.queuedSpell[1]:ID() and S.ExplosiveTrap:CooldownRemains() < 2 then
		return S.ExplosiveTrap:Cast()
	end
end

if S.AspectoftheCheetah:ID() == GriphRH.queuedSpell[1]:ID() and S.AspectoftheCheetah:CooldownRemains() < 2 then
	return S.AspectoftheCheetah:Cast()
end

if S.BloodFury:ID() == GriphRH.queuedSpell[1]:ID() and S.BloodFury:CooldownRemains() < 2 then
	return S.BloodFury:Cast()
end

if S.ViperSting:ID() == GriphRH.queuedSpell[1]:ID() and S.ViperSting:CooldownRemains() < 2 then
	return S.ViperSting:Cast()
end

if S.Intimidation:ID() == GriphRH.queuedSpell[1]:ID() and S.Intimidation:CooldownRemains() < 2 and PetActive() then
	return S.Intimidation:Cast()
end

if S.ConcussiveShot:ID() == GriphRH.queuedSpell[1]:ID() and S.ConcussiveShot:CooldownRemains() < 2 then
	return S.ConcussiveShot:Cast()
end

if S.WingClip:ID() == GriphRH.queuedSpell[1]:ID() and S.WingClip:CooldownRemains() < 2 then
	return S.WingClip:Cast()
end

-- if GriphRH.QueuedSpell():CanCast() then
	-- return GriphRH.QueuedSpell():Cast()
-- end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() then
	if IsReady('Feed Pet') and (PetHapiness() == 'Content' or PetHapiness() == 'Unhappy') and PetActive() and not Pet:Buff(S.FeedPetBuff) then 
		return S.FeedPet:Cast() 
	end
	if not weave then
	if S.TrueshotAura:IsAvailable() then
	if IsCurrentSpell(6603) and IsReady("Aimed Shot") then
		return S.AimedShot:Cast()
	end
	if IsCurrentSpell(6603) and IsReady("Sepent Sting") then
		return S.SerpentSting:Cast()
	end
	end
end

if weave and TargetinRange(40) then


	if IsReady('Aspect of the Falcon') and  not AuraUtil.FindAuraByName("Aspect of the Falcon", "player") 
	and ((not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player") and not AuraUtil.FindAuraByName("Aspect of the Viper", "player") 
	and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")) 
	or (UnitAffectingCombat('player') and CheckInteractDistance("target",3))) then
		return S.AspectoftheFalcon:Cast()
	end
	
	if 	IsCurrentSpell(6603) then
	if  IsReady("Blood Fury") then
		return S.BloodFury:Cast()
	end
	if  IsReady("Berserking") then
		return S.Berserking:Cast()
	end

	if  IsReady("Rapid Fire") then
		return S.RapidFire:Cast()
	end


	if  IsReady("Sepent Sting") then
		return S.SerpentSting:Cast()
	end

end




end





end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if Player:AffectingCombat() and AuraUtil.FindAuraByName("Aspect of the Cheetah", "player") and ManaPct()>=50
and ((AuraUtil.FindAuraByName("Dazed", "player") and UnitAffectingCombat('player')) or CleaveCount() >= 1 or S.AutoShot:InFlight()) then
	return S.AspectoftheCheetahCancel:Cast()
end

if IsReady('Heart of the Lion') and not Player:Buff(S.HeartoftheLion) then
	return S.HeartoftheLion:Cast()
end

if IsReady('Aspect of the Viper') and ManaPct() < 25 and not AuraUtil.FindAuraByName("Aspect of the Viper", "player") 
and ((not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player") and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")) 
or (UnitAffectingCombat('player') and CheckInteractDistance("target",3))) then
	return S.AspectoftheViper:Cast()
end


if IsReady('Aspect of the Falcon') and  not AuraUtil.FindAuraByName("Aspect of the Falcon", "player") 
and ((not AuraUtil.FindAuraByName("Aspect of the Cheetah", "player") and not AuraUtil.FindAuraByName("Aspect of the Viper", "player") 
and not AuraUtil.FindAuraByName("Aspect of the Pack", "player")) 
or (UnitAffectingCombat('player') and CheckInteractDistance("target",3))) then
	return S.AspectoftheFalcon:Cast()
end


if UnitCanAttack('player', 'target') and (UnitAffectingCombat('target') or IsCurrentSpell(6603) or IsAutoRepeatAction(AutoShot)) and not Target:IsDeadOrGhost() then 

	if not IsAutoRepeatAction(AutoShot) and not Player:IsMoving() and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.AutoShotz:Cast()
	end

	if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		return Item(135274, { 13, 14 }):ID()
	end


	if weave then -- NEED SUPPORT FROM DUZTI
-- 		Serpent Sting on Pull
-- Pre-Rapid Fire: Chimera + Auto Shot -> Wyvern Strike + Raptor
-- During Rapid Fire: Kill Shot, only Chimera Shot once to refresh Serpent Sting
-- Normal >20% HP: Chimera + Auto Shot -> Wyvern Strike + Raptor -> Kill Shot + Auto Shot -> Chimera -> Kill Shot + Auto Shot -> Multi Shot/Arcane Shot
-- Execute <20% HP: Chimera + Auto Shot -> Wyvern Strike + Raptor -> Kill Shot + Auto Shot -> Kill Shot + Melee
	
if HL.CombatTime()<4 or S.RapidFire:CooldownRemains()<4 and GriphRH.CDsON() then
	
	if IsReady("Serpent Sting")  and serpentstingdebuffremains < 1.5 and IsSpellInRange('Auto Shot', 'target') == 1  then
		return S.SerpentSting:Cast() 
	end
	
	if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.ChimeraShot:Cast()
	end


	if  IsReady("Wyvern Strike") and  CheckInteractDistance("target",3) then
		return S.WyvernStrike:Cast()
	end 
	if  IsReady("Raptor Strike") and  CheckInteractDistance("target",3) then
		return S.RaptorStrike:Cast()
	end 
	


end

if  AuraUtil.FindAuraByName("Rapid Fire", "player") then
	

	if  IsReady("Kill Shot") and (IsSpellInRange('Auto Shot', 'target') == 1 or CheckInteractDistance("target",3)) then
		return S.KillShot:Cast()
	end 


	if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1 and serpentstingdebuffremains<2 then
		return S.ChimeraShot:Cast()
	end




end


if GriphRH.CDsON() and IsReady("Rapid Fire") and S.ChimeraShot:CooldownRemains()<6 and S.ChimeraShot:CooldownRemains()>4 and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.RapidFire:Cast() 
end

if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1 and serpentstingdebuffremains<2 then
	return S.ChimeraShot:Cast()
end



if  IsReady("Wyvern Strike") and  CheckInteractDistance("target",3) then
	return S.WyvernStrike:Cast()
end 
if  IsReady("Raptor Strike") and  CheckInteractDistance("target",3) then
	return S.RaptorStrike:Cast()
end 

if  IsReady("Kill Shot") and (IsSpellInRange('Auto Shot', 'target') == 1 or CheckInteractDistance("target",3)) then
	return S.KillShot:Cast()
end 

if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1  then
	return S.ChimeraShot:Cast()
end



end






















if namechimerashot ~= "Chimera Shot" and not weave then 



if GriphRH.CDsON() and IsReady("Rapid Fire") and flankingstrikestacks>=2 and CheckInteractDistance("target",3) then
	return S.RapidFire:Cast()
end 

if  IsReady("Flanking Strike") and flankingstrikestacks<1 and not AuraUtil.FindAuraByName("Raptor Fury", "player") and CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 


if  IsReady("Flanking Strike") and flankingstrikestacks>=1 and flankingstrikeremains<2 and CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 

if  IsReady("Raptor Strike") and  CheckInteractDistance("target",3) then
	return S.RaptorStrike:Cast()
end 

if  IsReady("Wyvern Strike") and  CheckInteractDistance("target",3) then
	return S.WyvernStrike:Cast()
end 


if  IsReady("Mongoose Bite") and  CheckInteractDistance("target",3) then
	return S.MongooseBite:Cast()
end 


if  IsReady("Flanking Strike") and  CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 


if  IsReady("Aspect of the Viper") and  CheckInteractDistance("target",3) and ManaPct()<5 then
	return S.AspectoftheViper:Cast()
end 

if  IsReady("Aspect of the Falcon") and  CheckInteractDistance("target",3) and ManaPct()>70 then
	return S.AspectoftheFalcon:Cast()
end 



	-- if IsReady("Immolation Trap") and CheckInteractDistance("target",3) and S.RaptorStrike:CooldownRemains()>=1.5 and S.MongooseBite:CooldownRemains()>1.5 then
	-- 	return S.ImmolationTrap:Cast()
	-- end 
end

if namechimerashot == "Chimera Shot" and not weave then

	if IsReady("Kill Shot") and Target:HealthPercentage()<20 and  CheckInteractDistance("target",3)  then
		return S.KillShot:Cast()
	end

if IsReady("Serpent Sting")  and serpentstingdebuffremains < 1.5 and IsSpellInRange('Auto Shot', 'target') == 1 and aoeTTD()>6 then
	return S.SerpentSting:Cast() 
end

if IsReady("Rapid Fire") and HL.CombatTime()<5 then
	if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.ChimeraShot:Cast()
	end
	if IsReady("Kill Shot") and  CheckInteractDistance("target",3)  then
		return S.KillShot:Cast()
	end
	-- if IsReady("Immolation Trap") and IsSpellInRange('Auto Shot', 'target') == 1 then
	-- 	return S.ImmolationTrap:Cast()
	-- end
	if IsReady("Multi-Shot")  and IsSpellInRange('Auto Shot', 'target') == 1 then
		return S.Multishot:Cast()
	end


end
if IsReady("Berserking") and JomGabbor >=5 then
	return S.Berserking:Cast()
end


if IsReady("Chimera Shot")  and serpentstingdebuffremains < 6 and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.ChimeraShot:Cast() 
end


if IsReady("Rapid Fire") and S.ChimeraShot:CooldownRemains()<6 and S.ChimeraShot:CooldownRemains()>4 and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.RapidFire:Cast() 
end
if IsReady("Kill Shot") and AuraUtil.FindAuraByName("Rapid Fire", "player")  and  CheckInteractDistance("target",3) then
	return S.KillShot:Cast() 
end

if IsReady("Locked In") and S.ImmolationTrap:CooldownRemains()>5 and S.Multishot:CooldownRemains()>8 and IsReady("ChimeraShot") and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.LockedIn:Cast() 
end
if IsReady("Chimera Shot") and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.ChimeraShot:Cast() 
end
if IsReady("Kill Shot") and  CheckInteractDistance("target",3) then
	return S.KillShot:Cast() 
end
-- if IsReady("Immolation Trap") and IsSpellInRange('Auto Shot', 'target') == 1 then
-- 	return S.ImmolationTrap:Cast() 
-- end
if IsReady("Multi-Shot") and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.Multishot:Cast()
end
if IsReady("Arcane Shot") and IsSpellInRange('Auto Shot', 'target') == 1 then
	return S.ArcaneShot:Cast()
end

-- in melee

if  IsReady("Flanking Strike") and flankingstrikestacks<1 and not AuraUtil.FindAuraByName("Raptor Fury", "player") and CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 


if  IsReady("Flanking Strike") and flankingstrikestacks>=1 and flankingstrikeremains<2 and CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 

if  IsReady("Raptor Strike") and  CheckInteractDistance("target",3) then
	return S.RaptorStrike:Cast()
end 

if  IsReady("Mongoose Bite") and  CheckInteractDistance("target",3) then
	return S.MongooseBite:Cast()
end 
if  IsReady("Flanking Strike") and  CheckInteractDistance("target",3) then
	return S.FlankingStrike:Cast()
end 

if  IsReady("Wing Clip") and  CheckInteractDistance("target",3) then
	return S.WingClip:Cast()
end 


end


	

end

	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(3, APL);
GriphRH.Rotation.SetPvP(3, PvP);
GriphRH.Rotation.SetPASSIVE(3, PASSIVE);




