-- Tilemap
--[[

  Implements a hexagonal grid of tiles. Provides location querying, adjacency, and path finding interface.
]]
Tilemap = {}

Tilemap.new = function (init)
  local init = init or {}
  local self = {
    num_rows = init.num_rows or 21, --MUST be Odd for current Adjacency logic
    num_cols = init.num_cols or 42,
    tilesize_x = init.tilesize_x or 84,
    tilesize_y = init.tilesize_y or 73,
    hex_size = init.hex_size or 42, --MUST be half of tilesize_x
    tiles = init.tiles or {},
    terrain_connective_matrix = init.terrain_connective_matrix or {}
  }

  self.getTileAt = function (position)
    local calc_hex = self.pixel_to_hex(position)
    local calc_idx = calc_hex.col*self.num_rows+math.floor(calc_hex.row)
    if calc_idx <= 0 then
      calc_idx = #self.tiles + calc_idx + 1
    elseif calc_idx >= #self.tiles then
      calc_idx = calc_idx - (#self.tiles + 1)
    end
    return self.tiles[calc_idx]
  end

  self.getIdxAtCoord = function (coord)
    return coord.col * self.num_rows + coord.row
  end

  self.getHexAtCoord = function (coord)
    return self.tiles[getIdxAtCoord(coord)]
  end

  self.pixel_to_hex = function (position)
    if position.x == nil or position.y == nil or position == nil then
      print('oops: no valid pixel provided')
      return {x = nil, y = nil}
    end
    local x = position.x
    local y = position.y
    local size = self.tilesize_x / 2 --TODO: Change to thingy

    local q = x * 2/3 / size
    local r = (-x / 3 + math.sqrt(3)/3 * y) / size

    --return self.hex_round({col = q, row = r})
    return self.cube_to_hex(self.cube_round({x = q, y = -q-r, z = r}))
  end

  self.cube_to_hex = function(h)
    --convert cube to even-q offset
    local col = h.x
    local row = h.z + (h.x + (h.x % 2)) / 2

    return {col = col, row = row}
  end

  self.hex_to_cube = function(h)
    --convert even-q offset to cube
    local x = h.col
    local z = h.row - (h.col + (h.col % 2)) / 2
    local y = -x-z

    return {x = x, y = y, z = z}
  end

  self.hex_round = function (h)
    return self.cube_to_hex(self.cube_round(self.hex_to_cube(h)))
  end

  self.round = function (num)
    return math.floor(num + 0.5)
  end

  self.cube_round = function (h)
    local rx = self.round(h.x)
    local ry = self.round(h.y)
    local rz = self.round(h.z)

    local x_diff = math.abs(rx - h.x)
    local y_diff = math.abs(ry - h.y)
    local z_diff = math.abs(rz - h.z)

    if x_diff > y_diff and x_diff > z_diff then
        rx = -ry-rz
    elseif y_diff > z_diff then
        ry = -rx-rz
    else
        rz = -rx-ry
    end

    return {x = rx, y = ry, z = rz}
  end

  return self
end
