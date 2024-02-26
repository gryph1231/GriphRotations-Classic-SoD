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
};

local S = RubimRH.Spell[5]

S.Smite:RegisterInFlight()

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
if UnitCastingInfo('Player') or UnitChannelInfo('Player') or IsCurrentSpell(19434) then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") then
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end

if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603) or S.Smite:InFlight()) and not Target:IsDeadOrGhost() then 

	if not IsCurrentSpell(6603) and CheckInteractDistance("target",3) then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Smite',1) and not Player:IsMoving() then
		return S.Smite:Cast()
	end

end
	return "Interface\\Addons\\Rubim-RH-Classic\\Media\\mount2.tga", false
end
	
RubimRH.Rotation.SetAPL(5, APL);
RubimRH.Rotation.SetPASSIVE(5, PASSIVE);
