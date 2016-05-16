-- Tile
local TILE_SPRITE_ORDER = {"terrain","fringe","feature","river","road","resource"}

Tile = {
  sprite = nil,
  sprites = {},
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

function Tile:update (dt)--[[
  for k,v in pairs(self.sprites) do
    self.sprites[k]:update(dt)
  end]]
end

function Tile:draw (computed_position)--
  local v = "terrain"
  for i,v in ipairs(TILE_SPRITE_ORDER) do
    if self.sprites[v] ~= nil then
      self.sprites[v].position = computed_position
      self.sprites[v]:draw()
    end
  end
end

function Tile:setTerrain(type)
  self.terrain_type = type
  --self.sprites.terrain = SpriteInstance:new({sprite = self.terrain_type})
  self.sprites = {terrain = SpriteInstance:new({sprite = self.terrain_type})}
end

function Tile:click ()
  if self.terrain_type == "Grass" then
    self:setTerrain("Wood")
  else
    self:setTerrain("Grass")
  end

  --Change neighbors too using connective matrix
  local my_neighbors = self.owning_map.terrain_connective_matrix[self.idx]['air']

  for k,v in pairs(my_neighbors) do
    local tgt = self.owning_map.tiles[k]
    if tgt ~= nil then
      tgt:setTerrain(self.terrain_type)
    end
  end
end
