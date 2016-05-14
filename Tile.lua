-- Tile
Tile = {
  position = nil,
  terrain_type = nil,
  construction_type = nil,
  owning_map = nil,
  idx = nil
}

function Tile:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tile:click ()
  if self.terrain_type == "Grass" then
    self.terrain_type = "Wood"
  else
    self.terrain_type = "Grass"
  end

  local my_neighbors = self.owning_map.terrain_connective_matrix[self.idx]['air']

  for k,v in pairs(my_neighbors) do
    local tgt = self.owning_map.tiles[k]
    if tgt ~= nil then
      tgt.terrain_type = self.terrain_type
    end
  end
end
