---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Griph.
--- DateTime: 02/06/2018 12:53
---

local GriphRH = LibStub("AceAddon-3.0"):GetAddon("GriphRH")
local HL = HeroLibEx;
local Cache = HeroCache;
local Unit = HL.Unit;
local Player = Unit.Player;
local Target = Unit.Target;

function GriphRH.playSoundR(soundID)
    local isString = (type(soundID) == "string")
    if GriphRH.db.profile.mainOption.mute then
    else
        if not isString then
            PlaySound(soundID, "Master");
        else
            PlaySoundFile(soundID, "Master");
        end
    end
end

function GriphRH.GlowActionBarToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.glowactionbar == false then
        GriphRH.db.profile.mainOption.glowactionbar = true
    else
        GriphRH.HideButtonGlow()
        GriphRH.db.profile.mainOption.glowactionbar = false
    end
    print("|cFF69CCF0Glow Action Bar" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.glowactionbar))
end

function GriphRH.HideTextureToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.hidetexture == false then
        GriphRH.db.profile.mainOption.hidetexture = true
    else
        GriphRH.db.profile.mainOption.hidetexture = false
    end
    print("|cFF69CCF0Hide Texture" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.hidetexture))
end

function GriphRH.DebugToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.debug == false then
        GriphRH.db.profile.mainOption.debug = true
    else
        GriphRH.db.profile.mainOption.debug = false
    end
    print("|cFF69CCF0Verbose Debug" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.debug))
end

function GriphRH.CleaveToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.smartCleave == false then
        GriphRH.db.profile.mainOption.smartCleave = true
        GriphRH.db.profile.mainOption.disabledSpellsCleave = {}
    else
        GriphRH.db.profile.mainOption.smartCleave = false
    end
    print("|cFF69CCF0Use Cleave" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.smartCleave))
end

function GriphRH.burstCDToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.burstCD == false then
        GriphRH.db.profile.mainOption.burstCD = true
    else
        GriphRH.db.profile.mainOption.burstCD = false
    end
    print("|cFF69CCF0Burst CD" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.burstCD))
end

function GriphRH.MuteToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.mute == false then
        GriphRH.db.profile.mainOption.mute = true
    else
        GriphRH.db.profile.mainOption.mute = false
    end
    print("|cFF69CCF0Mutting Sounds" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.mute))
end

function GriphRH.MainIconToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.mainIcon == false then
        GriphRH.db.profile.mainOption.mainIcon = false
    else
        GriphRH.db.profile.mainOption.mainIcon = false
    end
    print("|cFF69CCF0Show Interface" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.mainIcon))
end

function GriphRH.MainIconLockToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.mainIconLock == false then
        GriphRH.db.profile.mainOption.mainIconLock = true
    else
        GriphRH.db.profile.mainOption.mainIconLock = false
    end
    print("|cFF69CCF0Icon Lock" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.mainIconLock))
end

function GriphRH.InterruptsToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.useInterrupts == false then
        GriphRH.db.profile.mainOption.useInterrupts = true
    else
        GriphRH.db.profile.mainOption.useInterrupts = false
    end
    print("|cFF69CCF0Use Interrupts" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.useInterrupts))
end

function GriphRH.CCToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.ccbreak == false then
        GriphRH.db.profile.mainOption.ccbreak = true
    else
        GriphRH.db.profile.mainOption.ccbreak = false
    end
    print("|cFF69CCF0CC Break" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.ccbreak))
end



function GriphRH.InstantInterruptToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.InstantInterrupt == false then
        GriphRH.db.profile.mainOption.InstantInterrupt = true

    else
        GriphRH.db.profile.mainOption.InstantInterrupt = false
    end
    print("|cFF69CCF0Instant Interrupt" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.InstantInterrupt))
end

function GriphRH.InterruptEverythingToggle()
    GriphRH.playSoundR(891);
    if GriphRH.db.profile.mainOption.InterruptEverything == false then
        GriphRH.db.profile.mainOption.InterruptEverything = true

    else
        GriphRH.db.profile.mainOption.InterruptEverything = false
    end
    print("|cFF69CCF0Interrupt Everything" .. "|r: |cFF00FF00" .. tostring(GriphRH.db.profile.mainOption.InterruptEverything))
end

GriphRH.config.cooldown = true
function GriphRH.CDToggle()
    GriphRH.playSoundR(891);
    if GriphRH.config.cooldown == false then
        GriphRH.config.cooldown = true
        GriphRH.burstCDtimer = GetTime()
    else
        GriphRH.db.profile.mainOption.disabledSpellsCD = {}
        GriphRH.config.cooldown = false
    end
    print("|cFF69CCF0CD" .. "|r: |cFF00FF00" .. tostring(GriphRH.config.cooldown))
end


GriphRH.useAoE = true
function GriphRH.AoEToggle()
    GriphRH.playSoundR(891);
    if GriphRH.useAoE == false then
        GriphRH.useAoE = true
    else
        GriphRH.useAoE = false
    end
    print("|cFF69CCF0AoE" .. "|r: |cFF00FF00" .. tostring(GriphRH.useAoE))
end

function GriphRH.CDsON()
    if GriphRH.config.cooldown == true then
        if GriphRH.db.profile.mainOption.cooldownsUsage == "Everything" then
            return true
        end

        if Target:IsDummy() then
            return true
        end

        if Target:IsAPvPDummy() then
            return true
        end

        if UnitIsPlayer("target") then
            return true
        end

        if GriphRH.db.profile.mainOption.cooldownsUsage == "Boss Only" then
            if UnitExists("boss1") == true then
                return true
            end

            if UnitExists("target") and (UnitClassification("target") == "worldboss" 
            or UnitClassification("target") == "rareelite" or UnitClassification("target") == "rare") then
                return true
            end
        end
    end
    return false
end

function GriphRH.AoEON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.useAoE == true then
        return true
    else
        return false
    end
end

function GriphRH.RacialON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.useRacial == true then
        return true
    else
        return false
    end
end

function GriphRH.CleaveON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.smartCleave == true then
        return true
    else
        return false
    end
end

function GriphRH.CCBreakON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.ccbreak == true then
        return true
    else
        return false
    end
end

function GriphRH.PerfectPullON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.PerfectPull == true then
        return true
    else
        return false
    end
end

function GriphRH.AutoAttackON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.startattack == true then
        return true
    else
        return false
    end
end

-- Prot Paladin Avenger Shield UI function
function GriphRH.ASInterruptON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[66].ASInterrupt == true then
        return true
    else
        return false
    end
end

-- Shadow priest
function GriphRH.ShadowAutoAoEON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[258].AutoAoE == true then
        return true
    else
        return false
    end
end

-- Affli lock UI function
function GriphRH.AffliAutoAoEON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[265].AutoAoE == true then
        return true
    else
        return false
    end
end

-- Assa Rogue UI function
function GriphRH.AssaAutoAoEON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[259].AutoAoE == true then
        return true
    else
        return false
    end
end

-- Druid Auto Morph UI
function GriphRH.AutoMorphON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[102].AutoMorph == true then
        return true
    else
        return false
    end
end

-- Protection Warrior
function GriphRH.UseShieldBlockDefON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[73].UseShieldBlockDefensively == true then
        return true
    else
        return false
    end
end

function GriphRH.UseRageDefON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[73].UseRageDefensively == true then
        return true
    else
        return false
    end
end

function GriphRH.ForceRejuvON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[105].force_rejuv == true then
        return true
    else
        return false
    end
end

function GriphRH.DBMSyncON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile[105].dbm_sync == true then
        return true
    else
        return false
    end
end

function GriphRH.PrecombatON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.Precombat == true then
        return true
    else
        return false
    end
end

function GriphRH.InstantInterruptON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.InstantInterrupt == true then
        return true
    else
        return false
    end
end

function GriphRH.InterruptEverythingON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.InterruptEverything == true then
        return true
    else
        return false
    end
end

function GriphRH.InterruptsON()
    if GriphRH.db == nil then
        return false
    end
    if GriphRH.db.profile.mainOption.useInterrupts == true then
        return true
    else
        return false
    end
end

local options, configOptions = nil, {}
--[[ This options table is used in the GUI config. ]]--


local function getOptions()
    if not options then
        options = {
            type = "group",
            name = "GriphRH",
            args = {
                mainOptions = {
                    order = 1,
                    type = "group",
                    name = "General",
                    childGroups = "tab",
                    args = {
                        keybind = {
                            order = 3,
                            type = "group",
                            childGroups = "tree",
                            inline = true,
                            name = "Keybinds",
                            get = function(info)
                                local key = info.arg or info[#info]
                                return GriphRH.db.profile.mainOption[key]
                            end,
                            set = function(info, value)
                                local key = info.arg or info[#info]
                                GriphRH.db.profile.mainOption[key] = value
                            end,
                            args = {
                                bindingsText = {
                                    order = 1,
                                    type = "description",
                                    name = "To change keybindgs, press ESC > Keybindings > GriphRH.",
                                    fontSize = "large",
                                },
                            }
                        },
                        classConfig = {
                            order = 2,
                            type = "group",
                            childGroups = "tree",
                            inline = true,
                            name = "Configuration",
                            args = {
                                description = {
                                    order = 1,
                                    type = "description",
                                    name = "All configuration was moved to the Class Config.",
                                    fontSize = "large",
                                },
                            }
                        },
                    }
                },
            }
        }
        for k, v in pairs(configOptions) do
            options.args[k] = (type(v) == "function") and v() or v
        end
    end

    return options
end

local function openConfig()
    InterfaceOptionsFrame_OpenToCategory(GriphRH.optionsFrames.Profiles)
    InterfaceOptionsFrame_OpenToCategory(GriphRH.optionsFrames.GriphRH)

    InterfaceOptionsFrame:Raise()
end

function GriphRH:SetupOptions()
    self.optionsFrames = {}
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("GriphRH", getOptions)
    self.optionsFrames.GriphRH = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GriphRH", nil, nil, "mainOptions")
    configOptions["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    self.optionsFrames["Profiles"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GriphRH", "Profiles", "GriphRH", "Profiles")
    LibStub("AceConsole-3.0"):RegisterChatCommand("GriphRH", openConfig)
end