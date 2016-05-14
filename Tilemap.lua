-- Tilemap
Tilemap = {
  num_rows = 31, --MUST be Odd for current Adjacency logic
  num_cols = 62,
  tilesize = 32,
  tiles = {},
  terrain_connective_matrix = {}
}

function Tilemap:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tilemap:getTileAt (position)
  local row, col

  --TODO: Make Pixel location accomodate truly hexagonal tiles
  row = (position.y / 32)
  col = math.floor(position.x / 32)

  if col % 2 == 0 then
    row = row - 0.5
  end

  return self.tiles[col*self.num_rows+math.floor(row)]
end

