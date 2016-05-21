-- Tilemap
Tilemap = {}

Tilemap.new = function (init)
  local init = init or {}
  local self = {
    num_rows = init.num_rows or 31, --MUST be Odd for current Adjacency logic
    num_cols = init.num_cols or 62,
    tilesize_x = init.tilesize_x or 168,
    tilesize_y = init.tilesize_y or 146,
    tiles = init.tiles or {},
    terrain_connective_matrix = init.terrain_connective_matrix or {}
  }

  self.getTileAt = function (position)
    local row, col

    --TODO: Make Pixel location accomodate truly hexagonal tiles
    row = (position.y / 32)
    col = math.floor(position.x / 32)

      if col % 2 == 0 then
    row = row - 0.5
    end

    return self.tiles[col*self.num_rows+math.floor(row)]
  end

  return self
end
