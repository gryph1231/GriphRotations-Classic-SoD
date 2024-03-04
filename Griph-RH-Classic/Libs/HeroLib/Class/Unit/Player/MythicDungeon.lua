--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, HL = ...
-- HeroLib
local Cache, Utils = HeroCache, HL.Utils
local Unit = HL.Unit
local Player, Pet, Target = Unit.Player, Unit.Pet, Unit.Target
local Focus, MouseOver = Unit.Focus, Unit.MouseOver
local Arena, Boss, Nameplate = Unit.Arena, Unit.Boss, Unit.Nameplate
local Party, Raid = Unit.Party, Unit.Raid
local Spell = HL.Spell
local Item = HL.Item
-- Lua
local pairs = pairs
-- File Locals



--- ============================ CONTENT ============================
-- Mythic Dungeon Abilites
local MDA = {
  PlayerBuff = {},
  PlayerDebuff = {
    --- Legion
    ----- Dungeons (7.0 Patch) -----
    --- Vault of the Wardens
    -- Inquisitor Tormentorum
    { Spell(200904), "Sapped Soul" }
  },
  EnemiesBuff = {
    --- Legion
    ----- Dungeons (7.0 Patch) -----
    --- Black Rook Hold
    -- Trashes
    { Spell(200291), "Blade Dance Buff" } -- Risen Scout
  },
  EnemiesCast = {
    --- Legion
    ----- Dungeons (7.0 Patch) -----
    --- Black Rook Hold
    -- Trashes
    { Spell(200291), "Blade Dance Cast" } -- Risen Scout
  },
  EnemiesDebuff = {}
}
function HL.MythicDungeon()
  -- TODO: Optimize
  for Key, Value in pairs(MDA) do
    if Key == "PlayerBuff" then
      for i = 1, #Value do
        if Player:Buff(Value[i][1], nil, true) then
          return Value[i][2]
        end
      end
    elseif Key == "PlayerDebuff" then
      for i = 1, #Value do
        if Player:Debuff(Value[i][1], nil, true) then
          return Value[i][2]
        end
      end
    elseif Key == "EnemiesBuff" then

    elseif Key == "EnemiesCast" then

    elseif Key == "EnemiesDebuff" then
    end
  end
  return ""
end
