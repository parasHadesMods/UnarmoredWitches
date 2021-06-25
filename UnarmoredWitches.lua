ModUtil.RegisterMod("UnarmoredWitches")

-- In normal configuration, Devotion (trial of the gods)
-- rewards will never appear, because they require 2
-- interacted gods (and you will have zero).
local config = {
  ModName = "Unarmored Witches",
  Enabled = true
}

if ModConfigMenu then
  ModConfigMenu.Register(config)
end

local UnarmoredWitches = {
  Tartarus = "LightRanged",
  Asphodel = "SpreadShotUnit", 
  Elysium = "SplitShotUnit"
}

local function IsUnarmoredWitch( enemyName )
  for _, witch in pairs( UnarmoredWitches ) do
    if enemyName == witch then
      return true
    end
  end

  return false
end

local function HasUnarmoredWitch( enemySet )
  for _, enemy in pairs( enemySet ) do
    if IsUnarmoredWitch( enemy ) then
      return true
    end
  end
  return false
end

ModUtil.WrapBaseFunction("IsEnemyEligible", function(baseFunc, enemyName, encounter, wave)
  return IsUnarmoredWitch( enemyName ) and baseFunc( enemyName, encounter, wave )
end)

ModUtil.WrapBaseFunction("GenerateEncounter", function(baseFunc, currentRun, room, encounter)
  if encounter.EnemySet and HasUnarmoredWitch( encounter.EnemySet ) then
    baseFunc( currentRun, room, encounter )
  else
    if room.RoomSetName then
      encounter.EnemySet = { UnarmoredWitches[room.RoomSetName] }
    end
    baseFunc( currentRun, room, encounter )
  end
end)

