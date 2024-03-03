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


RubimRH.Spell[5] = {
    Smite = Spell(585),
	ShadowWordPain = Spell(589),
	PowerWordFortitude = Spell(1243),
	shoot = Spell(7744),
	Shoot = Spell(5019),
};

local S = RubimRH.Spell[5]

S.Smite:RegisterInFlight()


	if duration and start then 
		cooldown_remains = tonumber(duration) - (GetTime() - tonumber(start))
		--gcd_remains = 1.5 / (GetHaste() + 1) - (GetTime() - tonumber(start))
	end

	if cooldown_remains and cooldown_remains < 0 then 
		cooldown_remains = 0 
	end
	



local function APL()
	targetRange30 = TargetInRange("Shadow Word: Pain")

if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end


if IsReady("Power Word: Fortitude") and Player:IsMoving() and not AuraUtil.FindAuraByName("Power Word: Fortitude","player") then
	return S.PowerWordFortitude:Cast()
	end	


if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.Smite:InFlight()) and not Target:IsDeadOrGhost() then 

	
	if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Shadow Word: Pain') and targetRange30 and not AuraUtil.FindAuraByName("Shadow Word: Pain","target","PLAYER|HARMFUL") then
		return S.ShadowWordPain:Cast()
	end

	if IsReady('Smite') and targetRange30 and not Player:IsMoving() then
		return S.Smite:Cast() 
	end

	if not IsCurrentSpell(5019) and not Player:IsMoving() and targetRange30 and not IsReady('Smite') and Player:ManaPercentage()<30 then
		return S.shoot:Cast()
	end

end


	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\griph.tga", false
end
	
RubimRH.Rotation.SetAPL(5, APL);
RubimRH.Rotation.SetPASSIVE(5, PASSIVE);
