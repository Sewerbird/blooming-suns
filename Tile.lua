-- Tile
Tile = {
  sprite = nil,
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

function Tile:update (dt)
  self.sprite:update(dt)
end
function Tile:draw (computed_position)
  self.sprite.position = computed_position
  self.sprite:draw()
end

function Tile:click ()
  if self.terrain_type == "Grass" then
    self.terrain_type = "Wood"
    self.sprite = SpriteInstance:new({sprite = "Wood"})
  else
    self.terrain_type = "Grass"
    self.sprite = SpriteInstance:new({sprite = "Grass"})
  end

  local my_neighbors = self.owning_map.terrain_connective_matrix[self.idx]['air']

  for k,v in pairs(my_neighbors) do
    local tgt = self.owning_map.tiles[k]
    if tgt ~= nil then
      tgt.terrain_type = self.terrain_type
      tgt.sprite = SpriteInstance:new({sprite = self.terrain_type})
    end
  end
end
