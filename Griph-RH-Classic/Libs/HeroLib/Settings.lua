--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, HL = ...


--- ============================ CONTENT ============================
-- All settings here should be moved into the GUI someday
HL.GUISettings = {
  General = {
    -- Debug Mode
    DebugMode = false,
    -- Recovery Timer
    RecoveryMode = "GCD", -- "GCD" to always display the next ability, "Custom" for Custom RecoveryTimer
    RecoveryTimer = 950,
    -- Reduce CPU Usage (decrease a little bit Rotation potential performance but saves FPS)
    ReduceCPULoad = false,
    ReduceCPULoadOffset = 0.034, -- Default:34ms | It'll be added to the default 66ms, can be positive or negative
    -- Blacklist Settings
    Blacklist = {
      -- During how many times the GCD time you want to blacklist an unit from Cycling
      -- when you got an error when trying to cast on it
      NotFacingExpireMultiplier = 3,
      -- Custom List (User Defined), must be a valid Lua Boolean or Function as Value and have the NPCID as Key
      UserDefined = {-- Example with fake NPCID:
        -- [123456] = true
        -- [123456] = function (self) return self:HealthPercentage() <= 80 and true or false end
      },
      -- Custom Cycle List (User Defined), must be a valid Lua Boolean or Function as Value and have the NPCID as Key
      CycleUserDefined = {
        -- Example with fake NPCID:
        -- [123456] = true
        -- [123456] = function (self) return self:HealthPercentage() <= 80 and true or false end

        --- Legion
        ----- Trial of Valor (T19 - 7.1 Patch) -----
        --- Helya
        -- Bilewater Slime
        [114553] = function(self) return self:HealthPercentage() >= 65 and true or false end,
        -- Decaying Minion
        [114568] = true,
        -- Helarjar Mistwatcher
        [116335] = true,
        ----- Nighthold (T19 - 7.1.5 Patch) -----
        --- Trilliax
        -- Scrubber
        [104596] = true,
        --- Spellblade Aluriel
        -- Fel Soul
        [115905] = true,
        --- Botanist Tel'Arn (Mythic Only)
        -- Naturalist Tel'Arn
        [109041] = function() return HL.GetInstanceDifficulty() == 16 and true or false end,
        -- Arcanist Tel'Arn
        [109040] = function() return HL.GetInstanceDifficulty() == 16 and true or false end,
        -- Solarist Tel'Arn
        [109038] = function() return HL.GetInstanceDifficulty() == 16 and true or false end,
        --- Star Augur Etraeus
        -- Voidling
        [104688] = true,
        ----- Tomb of Sargeras (T20 - 7.2.5 Patch) -----
        --- Mistress Sassz'ine
        -- Abyss Stalker
        [115795] = true,
        -- Razorjaw Waverunner
        [115902] = true,
        --- Fallen Avatar
        -- Maiden of Valor
        [120437] = true
      }
    }
  }
}
