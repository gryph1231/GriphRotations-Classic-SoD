local GriphRH = LibStub("AceAddon-3.0"):NewAddon("GriphRH", "AceEvent-3.0", "AceConsole-3.0")
_G["GriphRH"] = GriphRH

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

    if GriphExtra == false then
        message("Missing dependency: GriphExtra")
    end

    if GriphExtraVer ~= 01102018 then
        message("Update Extra :)")
    end
    --]]

    if GetCVar("nameplateShowEnemies") ~= "1" then
        message("Nameplates enabled to maximum AoE detection.");
        SetCVar("nameplateShowEnemies", 1)
    end
end)


GriphRH.burstCDtimer = GetTime()
GriphRH.debug = false

local AceGUI = LibStub("AceGUI-3.0")
GriphRH.config = {}
GriphRH.currentSpec = "None"
GriphRH.Spell = {}

local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;
local Spell = HL.Spell;
local Item = HL.Item;


-- Defines the APL
GriphRH.Rotation = {}
GriphRH.Rotation.APLs = {}
GriphRH.Rotation.PASSIVEs = {}
GriphRH.Rotation.PvP = {}
GriphRH.Rotation.CONFIG = {}

function GriphRH.Rotation.SetAPL (Class, APL)
    GriphRH.Rotation.APLs[Class] = APL;
end

function GriphRH.Rotation.SetPASSIVE (Class, APL)
    GriphRH.Rotation.PASSIVEs[Class] = APL;
end

function GriphRH.Rotation.SetPvP (Class, APL)
    GriphRH.Rotation.PvP[Class] = APL;
end

function GriphRH.Rotation.SetCONFIG (Class, APL)
    GriphRH.Rotation.CONFIG[Class] = APL;
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


--[[ GriphRH Initialize ]]--
function GriphRH:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GriphRHDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
    self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
    self:SetupOptions()

    if GriphRH.db.profile.mainOption.version ~= (26092018) then
        self.db:ResetDB(defaultProfile)
        message("New version:\nResetting Profile")
        print("Reseting profile")
        GriphRH.db.profile.mainOption.version = 26092018
    end


end

local updateClassVariables = CreateFrame("Frame")
updateClassVariables:RegisterEvent("PLAYER_LOGIN")
updateClassVariables:RegisterEvent("PLAYER_ENTERING_WORLD")
updateClassVariables:SetScript("OnEvent", function(self, event, ...)
    GriphRH.playerClass = select(3,Player:Class()) or 0
    -- GriphRH.Rotation.CONFIG[GriphRH.playerClass]()
    if GriphRH.playerClass == 0 then
        return
    end

    if GriphRH.db.profile[GriphRH.playerClass] == nil then
        return
    end

    --if GriphRH.playerClass ~= 0 then
    --        Player:RegisterListenedSpells(GriphRH.playerClass)
    --    end
    GriphRH.config = {}
    GriphRH.allSpells = {}
    if GriphRH.playerClass ~= 0 then
        GriphRH.config = GriphRH.db.profile[GriphRH.playerClass]
        for pos, spell in pairs(GriphRH.Spell[GriphRH.playerClass]) do
            if spell:IsAvailable() then
                table.insert(GriphRH.allSpells, spell)
            end
        end
    end
    GriphRH.useCD = false or GriphRH.db.profile[GriphRH.playerClass].cooldown
end)

function GriphRH:OnEnable()
    print("|cffc41f3bGriph RH|r: |cffffff00/Griphrh|r for GUI menu")
end

function GriphRH:OnProfileChanged(event, db)
    self.db.profile = db.profile
end

function GriphRH:OnProfileReset(event, db)
    for k, v in pairs(defaults) do
        db.profile[k] = v
    end
    self.db.profile = db.profile
end

function GriphRH:OnNewProfile(event, db)
    for k, v in pairs(defaults) do
        db.profile[k] = v
    end
end

--IconRotation.texture:SetTexture(GetSpellTexture(BloodRotation()))

-- Last Update: 05/04/18 02:42
-- Author: Griph
--if isEqual(thisobj:GetRealSettings().Name) == true then
--return true
--end

--- ============================   MAIN_ROT   ============================
function GriphRH.mainRotation(option)
    local Rotation = option or "SingleTarget"
    if foundError == true then
        return "ERROR"
    end

    if not GriphRH.Rotation.APLs[GriphRH.playerClass] then
        return "ERROR"
    end--]]

    --end
    if Player:IsDeadOrGhost() then
        return 133731, false
    end

    if Player:IsMounted() then
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
        return GriphRH.Rotation.PASSIVEs[GriphRH.playerClass]()
    end

    if Rotation == "Defensive" then
        return GriphRH.Rotation.DEFENSIVE[GriphRH.playerClass]()
    end    --]]

    if Rotation == "SingleTarget" then
        local rotation = GriphRH.Rotation.APLs[GriphRH.playerClass]()

        if rotation then
            return rotation, true
        end
    end

    if Player:AffectingCombat() then
        return 135328, false
    end
    return "Interface\\Addons\\Griph-RH-Classic\\Media\\griph.tga", false
end