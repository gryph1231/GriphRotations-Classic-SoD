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
	MoonkinForm = Spell(24858),
	Moonfire = Spell(8921),
	Sunfire = Spell(414684),
	Starfire = Spell(2912),
	Starsurge = Spell(417157),
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
	Prowl = Spell(6783),
	SavageRoar = Spell(407988),
	Furor = Spell(17061),
	TigersFury = Spell(5217),
	Rip = Spell(1079),
	MangleCat= Spell(20549), -- bp macro /cast Mangle(Cat) -- ggl war stomp
	Innervate = Spell(29166),
	legsrune = Spell(24977), --bp macro /use legs rune ability -- ggl keybind to insect swarm
	handsrune = Spell(2637), --bp macro /use hands rune ability -- ggl keybind to hibernate
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
	targetRange30 = TargetInRange("Wrath")


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

local targetttd9= (aoeTTD()>9 or UnitHealth('target')>2000 or Target:IsAPlayer() and Target:HealthPercentage()>55 and Target:HealthPercentage()<=65)

if AuraUtil.FindAuraByName("Sunfire","target","PLAYER|HARMFUL") then
	sunfiredebuff = select(6,AuraUtil.FindAuraByName("Sunfire","target","PLAYER|HARMFUL")) - GetTime()
	  else
		sunfiredebuff = 0 
	 end
	 if AuraUtil.FindAuraByName("Moonfire","target","PLAYER|HARMFUL") then
		sunfiredebuff = select(6,AuraUtil.FindAuraByName("Moonfire","target","PLAYER|HARMFUL")) - GetTime()
		  else
			sunfiredebuff = 0 
		 end
 if S.MoonkinForm:IsAvailable() then
	moonkindps = true
	feraldps = false

 else 
	moonkindps = false
	feraldps = true
 end

local nameMangle = GetSpellInfo('Mangle')

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
if not Player:AffectingCombat() then
	if GriphRH.InterruptsON() then
		if IsReady('Omen of Clarity') and not AuraUtil.FindAuraByName("Omen of Clarity", "player") and not AuraUtil.FindAuraByName("Prowl", "player") then
			return S.OmenofClarity:Cast()
		end
		
		if IsReady('Mark of the Wild') and not AuraUtil.FindAuraByName("Mark of the Wild", "player") and not AuraUtil.FindAuraByName("Prowl", "player") then
			return S.MarkoftheWild:Cast()
		end	
		if IsReady('Moonkin Form') and moonkindps==true and not Player:Buff(S.CatForm) and AuraUtil.FindAuraByName("Mark of the Wild", "player") and AuraUtil.FindAuraByName("Omen of Clarity", "player") then
			return S.MoonkinForm:Cast()
		end
		if IsReady('Cat Form') and feraldps==true and not Player:Buff(S.CatForm) and AuraUtil.FindAuraByName("Mark of the Wild", "player") and AuraUtil.FindAuraByName("Omen of Clarity", "player") then
			return S.CatForm:Cast()
		end

		if AuraUtil.FindAuraByName("Cat Form", "player") and not AuraUtil.FindAuraByName("Prowl", "player") and IsReady("Prowl") and Target:Exists() and Player:CanAttack(Target) and not Target:IsDeadOrGhost() and Player:IsMoving() then
			return S.Prowl:Cast()
		end
		-- if IsReady('Thorns') and not (Player:Buff(S.Thorns) or (not AuraUtil.FindAuraByName("Thorns", "target") and not Player:CanAttack(Target) and Target:Exists() and not Target:IsDeadOrGhost())) and Player:Mana() > 263 + 60 then
			-- return S.Thorns:Cast()
		-- end
	end
end

if IsReady('Omen of Clarity') and GriphRH.InterruptsON() and (not Player:Buff(S.CatForm) or IsReady('Cat Form')) and not Player:Buff(S.OmenofClarity) and Player:Mana() > 263 + 120 then
	return S.OmenofClarity:Cast()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--feraldps-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if Player:CanAttack(Target) and feraldps==true and (Target:AffectingCombat() or IsCurrentSpell(6603)) and not Target:IsDeadOrGhost() then 
	if IsReady('Cat Form') and not Player:Buff(S.CatForm)  then
		return S.CatForm:Cast()
	end

	if not IsCurrentSpell(6603) and targetrange11() then
		return Item(135274, { 13, 14 }):ID()
	end

	if IsReady('Rip') and CheckInteractDistance("target", 3) and (UnitHealth('target')<200 and not Target:IsAPlayer() or UnitHealthMax('target')>100000 and (Target:TimeToDie()<10 or UnitHealth('target')<2000) or Target:IsAPlayer() and Target:HealthPercentage()<20) and Player:ComboPoints()>=3  then
		return S.Rip:Cast()
	end


	if IsReady('Innervate') and Player:ManaPercentage()<=40 and Player:Energy()<= 20 and Player:Mana()>= 53 + 410 and Player:Mana()>= 410 then
		return S.Innervate:Cast()
	end


	if IsReady('Cat Form') 
	and ((not AuraUtil.FindAuraByName("Berserk", "player") and Player:Energy()< 20 
	or AuraUtil.FindAuraByName("Berserk", "player") and nameberserk == 'Berserk' or Player:Energy()<60)
	or Player:Mana()>= 410
	or S.Furor:IsAvailable())
	then
		return S.CatForm:Cast()
	end

	if IsReady("Tiger's Fury") and (Player:Energy()<20 or EnergyTimeToNextTick()>Player:GCD() and Player:Energy()<=40) and not AuraUtil.FindAuraByName("Tiger's Fury","player") then
		return S.TigersFury:Cast()
	end

	if IsReady("Savage Roar") and not AuraUtil.FindAuraByName("Savage Roar", "player")  then
		return S.legsrune:Cast()
	end

	if Player:Energy()>=35 and nameMangle =='Mangle'  and CheckInteractDistance("target", 3) and not AuraUtil.FindAuraByName("Mangle","target","PLAYER|HARMFUL") then
		return S.MangleCat:Cast()
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

	if Player:Energy()>=35 and nameMangle =='Mangle' and CheckInteractDistance("target", 3) and S.Furor:IsAvailable() and Player:Mana()>= 410 and EnergyTimeToNextTick()>1 then
		return S.MangleCat:Cast()
	end

	if IsReady("Rake") and CheckInteractDistance("target", 3) and S.Furor:IsAvailable() and Player:Mana()>= 410 and EnergyTimeToNextTick()>1 and not AuraUtil.FindAuraByName("Rake","target","PLAYER|HARMFUL") then
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

--------------------------------------------------------------------------------------------------------------------------------------------------------
--Moonkin-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
if Player:CanAttack(Target) and moonkindps==true and (Target:AffectingCombat() or IsCurrentSpell(6603)) and not Target:IsDeadOrGhost() then 
	if IsReady('Moonkin Form') and not AuraUtil.FindAuraByName("Moonkin Form", "player") and not AuraUtil.FindAuraByName("Cat Form", "player")  then
		return S.MoonkinForm:Cast()
	end

	if not IsCurrentSpell(6603) and targetrange11() then
		return Item(135274, { 13, 14 }):ID()
	end



	if IsReady('Innervate') and Player:ManaPercentage()<=40  then
		return S.Innervate:Cast()
	end



	if IsReady("Starsurge") and targetRange30 then
		return S.legsrune:Cast()
	end
	if IsReady("Starfire") and targetRange30 and not AuraUtil.FindAuraByName("Starsurge", "player") and not Player:IsMoving() then
		return S.Starfire:Cast()
	end

	if IsReady("Sunfire") and targetRange30 and sunfiredebuff<Player:GCD() and (targetttd9 or Player:IsMoving()) and S.Sunfire:TimeSinceLastCast()>Player:GCD()+ 0.2 then
		return S.Sunfire:Cast()
	end
	if IsReady("Moonfire") and targetRange30 and moonfiredebuff<Player:GCD() and (targetttd9 or Player:IsMoving()) and S.Moonfire:TimeSinceLastCast()>Player:GCD()+0.2 then
		return S.Moonfire:Cast()
	end

	if IsReady("Wrath") and targetRange30 and not Player:IsMoving() then
		return S.Wrath:Cast()
	end


end
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end

GriphRH.Rotation.SetAPL(11, APL);
GriphRH.Rotation.SetPvP(11, PvP)
GriphRH.Rotation.SetPASSIVE(11, PASSIVE);