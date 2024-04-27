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

GriphRH.Spell[11] = {
	Wrath = Spell(5177),
	CatForm = Spell(768),
	BearForm = Spell(5487),
	Mangle = Spell(407993),
	Rake = Spell(1822),
	Claw = Spell(1082),
	MarkoftheWild = Spell(6756),
	Thorns = Spell(782),
	OmenofClarity = Spell(16864),
	Shred = Spell(5221),
	Clearcasting = Spell(16870),
	Prowl = Spell(5215),
	SavageRoar = Spell(407988),
	Furor = Spell(17061),
	TigersFury = Spell(5217),
	Rip = Spell(1079),
	Innervate = Spell(29166),
	legsrune = Spell(20580), --bp macro /use legs rune ability -- ggl keybind to shadowmeld
	Powershift = Spell(5225), -- track humanoids
};

local S = GriphRH.Spell[11]

S.Claw.TextureSpellID = { 16827 }
-- S.SavageRoar.TextureSpellID = { 5209 }

-- if not Item.Druid then
    -- Item.Druid = {}
-- end

-- Item.Druid.Feral = {
	-- autoattack = Item(135274, { 13, 14 }),
	-- trinket = Item(28288, { 13, 14 }),
	-- trinket2 = Item(25628, { 13, 14 }),
-- };
-- local I = Item.Druid.Feral;

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



if not behindCheck then
    behindCheck = CreateFrame("Frame")
end

local BehindCheckTimer = 0
local FrontCheckTimer = 0

local frame = behindCheck
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:SetScript("OnEvent", function(self,event,errorType,message)
	if message == 'You must be behind your target' then
		BehindCheckTimer = GetTime()
	elseif message == 'You must be in front of your target' then
		FrontCheckTimer = GetTime()
	end	
end)


local function APL()
	local nameberserk = GetSpellInfo('Berserk')


	if AuraUtil.FindAuraByName("Savage Roar","player") then
		SRbuffremains = select(6,AuraUtil.FindAuraByName("Savage Roar","player","PLAYER"))- GetTime()
	else
		SRbuffremains = 0
	end


--------------------------------------------------------------------------------------------------------------------------------------------------------
--Functions/Top priorities-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if Player:IsCasting() or Player:IsChanneling() then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
elseif Player:IsDeadOrGhost() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") or AuraUtil.FindAuraByName("Food & Drink", "player") or Player:Buff(S.Prowl) then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end 

local BehindTimer = GetTime() - BehindCheckTimer
local FrontTimer = GetTime() - FrontCheckTimer
local Behind
local Front

if BehindTimer < Player:GCD() then
	Behind = false
end

if FrontTimer < Player:GCD() then
	Front = false
end

local finisher_condition = 
	(Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
	or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
	or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
	or (aoeTTD() < 2 and 
	   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
	or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
	or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
	or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
	or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24)))
	or (Player:ComboPoints() >= 5 and aoeTTD() > 12 and not Target:Debuff(S.Rip))
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Spell Queue-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not GriphRH.queuedSpell[1]:CanCast() or not GriphRH.queuedSpell[1]:IsAvailable() then
	GriphRH.queuedSpell = { GriphRH.Spell[3].Default, 0 }
end

if GriphRH.QueuedSpell():CanCast() then
	return GriphRH.QueuedSpell():Cast()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Out of Combat-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
if not Player:AffectingCombat() and not Player:Buff(S.CatForm) then
	if GriphRH.InterruptsON() then
		if IsReady('Omen of Clarity') and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
			return S.OmenofClarity:Cast()
		end
		
		if IsReady('Mark of the Wild') and not AuraUtil.FindAuraByName("Mark of the Wild", "target") then
			return S.MarkoftheWild:Cast()
		end	
		
		-- if IsReady('Thorns') and not (Player:Buff(S.Thorns) or (not AuraUtil.FindAuraByName("Thorns", "target") and not Player:CanAttack(Target) and Target:Exists() and not Target:IsDeadOrGhost())) and Player:Mana() > 263 + 60 then
			-- return S.Thorns:Cast()
		-- end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--Rotation-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if IsReady('Omen of Clarity') and GriphRH.InterruptsON() and (not Player:Buff(S.CatForm) or IsReady('Cat Form')) and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
	return S.OmenofClarity:Cast()
end

if Player:CanAttack(Target) and (Target:AffectingCombat() or IsCurrentSpell(6603)) and not Target:IsDeadOrGhost() then 
	if IsReady('Cat Form') and not Player:Buff(S.CatForm) then
		return S.CatForm:Cast()
	end

	if not IsCurrentSpell(6603) and targetrange11() then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Innervate') and Player:ManaPercentage()<=40 and Player:Energy()<= 20 and Player:Mana()>= Player:ManaMax()*0.05 + Player:ManaMax()*0.55 and Player:Mana()>= Player:ManaMax()*0.55 then
		return S.Innervate:Cast()
	end


	if IsReady('Cat Form') 
	and ((not AuraUtil.FindAuraByName("Berserk", "player") and Player:Energy()< 20 
	or AuraUtil.FindAuraByName("Berserk", "player") and nameberserk == 'Berserk' or Player:Energy()<60)
	or Player:Mana()>= Player:ManaMax()*0.55 
	or S.Furor:IsAvailable())
	then
		return S.CatForm:Cast()
	end

	if IsReady("Tiger's Fury") and (Player:Energy()<20 or EnergyTimeToNextTick()>Player:GCD() and Player:Energy()<=40)  then
		return S.TigersFury:Cast()
	end

	if IsReady("Savage Roar") and not AuraUtil.FindAuraByName("Savage Roar", "player")  then
		return S.legsrune:Cast()
	end

	if IsReady("Mangle") and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Mangle","target","PLAYER|HARMFUL") then
		return S.Mangle:Cast()
	end


	if IsReady("Shred") and CheckInteractDistance("target", 3) and Behind ~= false and AuraUtil.FindAuraByName("Clearcasting", "player")  then
		return S.Shred:Cast()
	end


	if IsReady("Rip") and CheckInteractDistance("target", 3) and Player:ComboPoints()>=5 and SRbuffremains >=7 and aoeTTD()>=10 and not AuraUtil.FindAuraByName("Rip","target","PLAYER|HARMFUL")  then
		return S.Rip:Cast()
	end

	if IsReady("Shred") and CheckInteractDistance("target", 3) and Behind ~= false then
		return S.Shred:Cast()
	end

	if IsReady("Mangle") and CheckInteractDistance("target", 3) and S.Furor:IsAvailable() and Player:Mana()>= Player:ManaMax()*0.55 and EnergyTimeToNextTick()>1 then
		return S.Mangle:Cast()
	end

	if IsReady("Rake") and CheckInteractDistance("target", 3) and S.Furor:IsAvailable() and Player:Mana()>= Player:ManaMax()*0.55 and EnergyTimeToNextTick()>1 and not AuraUtil.FindAuraByName("Rake","target","PLAYER|HARMFUL") then
		return S.Rake:Cast()
	end


	-- if Player:Buff(S.CatForm)then
	-- 	if (Player:ComboPoints() >= 1 and not Player:Buff(S.SavageRoar) 
	-- 	or Player:ComboPoints() >= 5 and Player:BuffRemains(S.SavageRoar) < 8 
	-- 	or Player:ComboPoints() >= 4 and Player:BuffRemains(S.SavageRoar) < 4)
	-- 	or (aoeTTD() < 2 and 
	-- 	   ((Player:ComboPoints() == 1 and Player:BuffRemains(S.SavageRoar) < 10)
	-- 	or (Player:ComboPoints() == 2 and Player:BuffRemains(S.SavageRoar) < 13)
	-- 	or (Player:ComboPoints() == 3 and Player:BuffRemains(S.SavageRoar) < 16)
	-- 	or (Player:ComboPoints() == 4 and Player:BuffRemains(S.SavageRoar) < 20)
	-- 	or (Player:ComboPoints() == 5 and Player:BuffRemains(S.SavageRoar) < 24))) then
	-- 		if IsReady('Savage Roar') then
	-- 			return S.SavageRoar:Cast()
	-- 		elseif IsReady('Cat Form') and not Player:Buff(S.Clearcasting) and targetrange11() and Player:Energy() < 5 and GriphRH.CDsON() then
	-- 			return S.Powershift:Cast()
	-- 		end
	-- 	end

	-- 	if Player:ComboPoints() >= 5 and aoeTTD() > 12 and not Target:Debuff(S.Rip) then
	-- 		if IsReady('Rip',true) then
	-- 			return S.Rip:Cast()
	-- 		elseif IsReady('Cat Form') and not Player:Buff(S.Clearcasting) and targetrange11() and Player:Energy() < 10 and GriphRH.CDsON() then
	-- 			return S.Powershift:Cast()
	-- 		end
	-- 	end
		
	-- 	if Player:Buff(S.Clearcasting) then
	-- 		if IsReady('Shred',true) and Behind ~= false then
	-- 			return S.Shred:Cast()
	-- 		end
			
	-- 		if IsReady('Claw',true) then
	-- 			return S.Claw:Cast()
	-- 		end
	-- 	end
		
	-- 	if IsReady('Claw',true) then
	-- 		return S.Claw:Cast()
	-- 	elseif IsReady('Cat Form') and not Player:Buff(S.Clearcasting) and not finisher_condition and targetrange11() and Player:Energy() < 20 and GriphRH.CDsON() then
	-- 		return S.Powershift:Cast()
	-- 	end
		
		-- if IsReady('Cat Form') and GriphRH.CDsON() and Player:Energy() < 10 then
			-- return S.Powershift:Cast()
		-- end
	--end
end

	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(11, APL);
GriphRH.Rotation.SetPvP(11, PvP)
GriphRH.Rotation.SetPASSIVE(11, PASSIVE);