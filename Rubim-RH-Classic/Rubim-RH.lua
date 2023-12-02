local RubimRH = LibStub("AceAddon-3.0"):NewAddon("RubimRH", "AceEvent-3.0", "AceConsole-3.0")
_G["RubimRH"] = RubimRH

local foundError = false


local errorEvent = CreateFrame("Frame")
errorEvent:RegisterEvent("PLAYER_LOGIN")
errorEvent:SetScript("OnEvent", function(self, event)
    --[[
    if HeroLib == nil then
        message("Missing dependency: HeroLib")
        foundError = true
    end
    if HeroCache == nil then
        message("Missing dependency: HeroCache")
        foundError = true
    end

    if RubimExtra == false then
        message("Missing dependency: RubimExtra")
    end

    if RubimExtraVer ~= 01102018 then
        message("Update Extra :)")
    end
    --]]

    if GetCVar("nameplateShowEnemies") ~= "1" then
        message("Nameplates enabled to maximum AoE detection.");
        SetCVar("nameplateShowEnemies", 1)
    end
end)


RubimRH.burstCDtimer = GetTime()
RubimRH.debug = false

local AceGUI = LibStub("AceGUI-3.0")
RubimRH.config = {}
RubimRH.currentSpec = "None"
RubimRH.Spell = {}

local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;


-- Defines the APL
RubimRH.Rotation = {}
RubimRH.Rotation.APLs = {}
RubimRH.Rotation.PASSIVEs = {}
RubimRH.Rotation.PvP = {}
RubimRH.Rotation.CONFIG = {}

function RubimRH.Rotation.SetAPL (Class, APL)
    RubimRH.Rotation.APLs[Class] = APL;
end

function RubimRH.Rotation.SetPASSIVE (Class, APL)
    RubimRH.Rotation.PASSIVEs[Class] = APL;
end

function RubimRH.Rotation.SetPvP (Class, APL)
    RubimRH.Rotation.PvP[Class] = APL;
end

function RubimRH.Rotation.SetCONFIG (Class, APL)
    RubimRH.Rotation.CONFIG[Class] = APL;
end

local defaults = {
    profile = {
        mainOption = {
            version = 26092018,
            cooldownbind = nil,
            interruptsbind = nil,
            aoebind = nil,
            ccbreak = true,
            smartCleave = false,
            usePotion = true,
            useInterrupts = true,
            useRacial = true,
            startattack = false,
            healthstoneper = 20,
            healthstoneEnabled = true,
            mainIcon = true,
            mainIconOpacity = 100,
            mainIconScale = 150,
            mainIconLock = false,
            mute = false,
            align = "CENTER",
            xCord = 0,
            yCord = 0,
            disabledSpells = {},
            disabledSpellsCD = {},
            disabledSpellsCleave = {},
            interruptList = {},
            whiteList = true,
            useTrinkets = {
                [1] = false,
                [2] = false
            },
            cooldownsUsage = "Everything",
            burstCD = false,
            debug = false,
            hidetexture = false,
            glowactionbar = false,
        },
    }
}


--[[ RubimRH Initialize ]]--
function RubimRH:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("RubimRHDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
    self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
    self:SetupOptions()

    if RubimRH.db.profile.mainOption.version ~= (26092018) then
        self.db:ResetDB(defaultProfile)
        message("New version:\nResetting Profile")
        print("Reseting profile")
        RubimRH.db.profile.mainOption.version = 26092018
    end


end

local updateClassVariables = CreateFrame("Frame")
updateClassVariables:RegisterEvent("PLAYER_LOGIN")
updateClassVariables:RegisterEvent("PLAYER_ENTERING_WORLD")
updateClassVariables:SetScript("OnEvent", function(self, event, ...)
    RubimRH.playerClass = select(3,Player:Class()) or 0
    -- RubimRH.Rotation.CONFIG[RubimRH.playerClass]()
    if RubimRH.playerClass == 0 then
        return
    end

    if RubimRH.db.profile[RubimRH.playerClass] == nil then
        return
    end

    --if RubimRH.playerClass ~= 0 then
    --        Player:RegisterListenedSpells(RubimRH.playerClass)
    --    end
    RubimRH.config = {}
    RubimRH.allSpells = {}
    if RubimRH.playerClass ~= 0 then
        RubimRH.config = RubimRH.db.profile[RubimRH.playerClass]
        for pos, spell in pairs(RubimRH.Spell[RubimRH.playerClass]) do
            if spell:IsAvailable() then
                table.insert(RubimRH.allSpells, spell)
            end
        end
    end
    RubimRH.useCD = false or RubimRH.db.profile[RubimRH.playerClass].cooldown
end)

function RubimRH:OnEnable()
    print("|cffc41f3bRubim RH|r: |cffffff00/rubimrh|r for GUI menu")
end

function RubimRH:OnProfileChanged(event, db)
    self.db.profile = db.profile
end

function RubimRH:OnProfileReset(event, db)
    for k, v in pairs(defaults) do
        db.profile[k] = v
    end
    self.db.profile = db.profile
end

function RubimRH:OnNewProfile(event, db)
    for k, v in pairs(defaults) do
        db.profile[k] = v
    end
end

--IconRotation.texture:SetTexture(GetSpellTexture(BloodRotation()))

-- Last Update: 05/04/18 02:42
-- Author: Rubim
--if isEqual(thisobj:GetRealSettings().Name) == true then
--return true
--end

--- ============================   MAIN_ROT   ============================
function RubimRH.mainRotation(option)
    local Rotation = option or "SingleTarget"
    if foundError == true then
        return "ERROR"
    end

    if not RubimRH.Rotation.APLs[RubimRH.playerClass] then
        return "ERROR"
    end--]]

    --end
    if Player:IsDeadOrGhost() then
        return 133731, false
    end

    if Player:IsMounted() or (select(3, UnitClass("player")) == 11 and (GetShapeshiftForm() == 3 or GetShapeshiftForm() == 5)) then
        return 134176, false
    end

    if ACTIVE_CHAT_EDIT_BOX ~= nil then
        return 134332, false
    end

    if SpellIsTargeting() then
        return 136243, false
    end

    if _G.LootFrame:IsShown() then
        return 133639, false
    end

    --
    --UpdateCleave()
    --UpdateCD()

    --[[
    if Rotation == "Passive" then
        return RubimRH.Rotation.PASSIVEs[RubimRH.playerClass]()
    end

    if Rotation == "Defensive" then
        return RubimRH.Rotation.DEFENSIVE[RubimRH.playerClass]()
    end    --]]

    if Rotation == "SingleTarget" then
        local rotation = RubimRH.Rotation.APLs[RubimRH.playerClass]()

        if rotation then
            return rotation, true
        end
    end

    if Player:AffectingCombat() then
        return 135328, false
    end
    return 136090, false
end