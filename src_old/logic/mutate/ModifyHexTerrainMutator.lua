ModifyHexTerrainMutator = {}

ModifyHexTerrainMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.tile = init.tile
  self.type = init.type

  self.execute = function (state)
    self.oldType = self.tile.terrain_type
    self.tile.setTerrain(self.type)
  end

  self.undo = function (state)
    self.tile.setTerrain(self.oldType)
  end

  return self
end
