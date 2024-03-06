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
	PowerWordShield = Spell(17),
	Renew = Spell(139),
	LesserHeal = Spell(2053),
	Resurrection = Spell(2006),
	Fade = Spell(586),
	MindBlast = Spell(8092),
	ShadowWordPain = Spell(589),
	PowerWordFortitude = Spell(1243),
	shoot = Spell(7744),
	Shoot = Spell(5019),
	chestrune = Spell(20594),--stoneform
	handrune = Spell(20554), --berserking
	legrune = Spell(20580), --shadowmeld
	VoidPlague = Spell(425204),
	InnerFire = Spell(588),
	CureDisease = Spell(528),
	PsychicScream = Spell(8122),

};

local S = GriphRH.Spell[5]

S.Smite:RegisterInFlight()
S.Smite:RegisterInFlight()

	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	



local function APL()


	local Shoot = 0

	for ActionSlot = 1, 120 do
		local ActionText = GetActionTexture(ActionSlot)
		local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo('Shoot')
		
		if ActionText == icon then
			Shoot = ActionSlot
		end
	end

	targetRange30 = TargetInRange("Mind Blast")
    local inRange25 = 0
        for i = 1, 40 do
            if UnitExists('nameplate' .. i) then
                inRange25 = inRange25 + 1
            end
        end
local targetrunning = (GetUnitSpeed("target") /7 *100)>90
local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

if targetrunning == true and isTanking == true then
	powerwordshield = true
else
	powerwordshield = false
end
-- print(IsCurrentSpell(5019))
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\mount2.tga", false
end


if IsReady("Power Word: Fortitude") and Player:IsMoving() and not AuraUtil.FindAuraByName("Power Word: Fortitude","player") then
	return S.PowerWordFortitude:Cast()
	end	
	if IsReady("Inner Fire") and Player:IsMoving() and not AuraUtil.FindAuraByName("Inner Fire","player") then
		return S.InnerFire:Cast()
		end	

if Player:CanAttack(Target) and (Player:AffectingCombat() or IsCurrentSpell(5019) or Target:AffectingCombat() or IsCurrentSpell(6603) or S.Smite:InFlight()) and not Target:IsDeadOrGhost() then 

	
	if IsReady("Psychic Scream") and Player:HealthPercentage() < 20 and GriphRH.InterruptsON() then
		return S.PsychicScream:Cast()
	end	

	if IsReady("Power Word: Shield") and (targetRange30 or Target:Exists() and Player:IsMoving() or powerwordshield== true) and not AuraUtil.FindAuraByName("Power Word: Shield","player") and not AuraUtil.FindAuraByName("Weakened Soul","player","PLAYER|HARMFUL") then
		return S.PowerWordShield:Cast()
	end	

	if IsReady("Renew") and Player:HealthPercentage() < 60 and not AuraUtil.FindAuraByName("Renew","player") then
		return S.Renew:Cast()
	end	

	if IsReady("Cure Disease") and GetAppropriateCureSpell() == "Disease" then
		return S.CureDisease:Cast()
	end
	if IsReady('Homunculi') and targetRange30 and GriphRH.CDsON() then
		return S.legrune:Cast()
	end
	if IsReady('Void Plague') and targetRange30 and not AuraUtil.FindAuraByName("Void Plague","target","PLAYER|HARMFUL") then
		return S.chestrune:Cast()
	end

	if IsReady('Shadow Word: Pain') and targetRange30 and not AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") then
		return S.ShadowWordPain:Cast()
	end

	if IsReady('Penance') and not Player:IsMoving() and targetRange30  then
		return S.handrune:Cast()
	end

	if IsReady('Mind Blast') and targetRange30 and not Player:IsMoving() then
		return S.MindBlast:Cast() 
	end

	if IsReady('Smite') and targetRange30 and not Player:IsMoving() then
		return S.Smite:Cast() 
	end

	if not IsAutoRepeatAction(Shoot) and not IsCurrentSpell(5019) and not Player:IsMoving() and targetRange30 and Player:ManaPercentage()<10  then
		return S.shoot:Cast()
	end

	-- if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
	-- 	return Item(135274, { 13, 14 }):ID()
	-- end



end


	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end
	
GriphRH.Rotation.SetAPL(5, APL);
GriphRH.Rotation.SetPASSIVE(5, PASSIVE);
