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

GriphRH.Spell[11] = {
    Moonfire = Spell(8921),
    hearth = Spell(8143), --tremor totem
    Moonglade = Spell(18960),
    Moongladez = Spell(33736), --water shield
    MarkoftheWild = Spell(1126),
    MarkoftheWildz = Spell(8512), --wf totem
};

local S = GriphRH.Spell[11]



Item.Druid = {
	hearthstone = Item(6948),
};
local I = Item.Druid;

local EnemyRanges = { "Melee", 8 }
local function UpdateRanges()
    for _, i in ipairs(EnemyRanges) do
        HL.GetEnemies(i);
    end
end

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

local OffensiveCDs = {
}

local function UpdateCDs()
    if GriphRH.CDsON() then
        for i, spell in pairs(OffensiveCDs) do
            if not spell:IsEnabledCD() then
                mainAddon.delSpellDisabledCD(spell:ID())
            end
        end

    end
    if not GriphRH.CDsON() then
        for i, spell in pairs(OffensiveCDs) do
            if spell:IsEnabledCD() then
                mainAddon.addSpellDisabledCD(spell:ID())
            end
        end
    end
end

local function ManaPct()
    return (UnitPower("Player", 0) / UnitPowerMax("Player", 0)) * 100
end

local EnemyRanges = {8}
local function UpdateRanges()
  for _, i in ipairs(EnemyRanges) do
    HL.GetEnemies(i);
  end
end

local function APL()

--GetMinimapZoneText() == "Nighthaven"

--GetMinimapZoneText() == "Thunder Bluff"

-- if I.hearthstone:IsReady() then
	-- print('asdf')
-- end

if Player:IsCasting() or Player:IsChanneling() or AuraUtil.FindAuraByName("Drink", "player") or AuraUtil.FindAuraByName("Food", "player") then
	return "Interface\\Addons\\Griph-RH-Classic\\Media\\channel.tga", false
end 



if not Player:BuffP(S.MarkoftheWild) then
	return S.MarkoftheWildz:Cast()
end

if Player:BuffRemainsP(S.MarkoftheWild) <= 918 then

	if GetMinimapZoneText() == "Thunder Bluff" and ManaPct() == 100 then
		return S.Moongladez:Cast()
	end

	if GetMinimapZoneText() == "Nighthaven" and I.hearthstone:IsReady() then
		return S.hearth:Cast()
	end


end


-- if ((Target:AffectingCombat() or S.Wrath:InFlight()) or Target:IsDummy()) and Player:CanAttack(Target) and Target:Exists() then

	-- if S.Wrath:CanCast(Target) and not Target:AffectingCombat() then
		-- return S.Wrathz:Cast()
	-- end

	-- if S.Moonfire:CanCast(Target) and not Target:Debuff(S.Moonfire) then
		-- return S.Moonfirez:Cast()
	-- end
	
	-- if S.Wrath:CanCast(Target) then
		-- return S.Wrathz:Cast()
	-- end

-- end

	return "Interface\\Addons\\Griph-RH-Classic\\Media\\mount2.tga", false
end

local function PASSIVE()
    return AutomataRH.Shared()
end

local function PvP()
end
GriphRH.Rotation.SetAPL(11, APL);
GriphRH.Rotation.SetPvP(11, PvP)
GriphRH.Rotation.SetPASSIVE(1, PASSIVE);


local lastUpdate = 27082019
local function CONFIG()
    local function setVariables()
        GriphRH.db.profile[GriphRH.playerClass] = {}
        GriphRH.db.profile[GriphRH.playerClass].version = lastUpdate
        GriphRH.db.profile[GriphRH.playerClass].cooldown = true
    end

    if not GriphRH.db.profile[GriphRH.playerClass] then
       setVariables()
    end

    if GriphRH.db.profile[GriphRH.playerClass] and GriphRH.db.profile[GriphRH.playerClass].version ~= lastUpdate then
        setVariables()
    end
end
-- GriphRH.Rotation.SetCONFIG(1, CONFIG)