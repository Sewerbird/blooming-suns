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

  self.getHexAtIdx = function (idx)
    return self.tiles[getTileAtIdx]
  end

  self.getCoordFromIdx = function (idx)
  print("xx"..idx)
  print("::"..inspect(self.tiles[idx],{depth=2}))
    return {
      col = self.tiles[idx].position.col,
      row = self.tiles[idx].position.row,
      idx = idx
    }
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

  --[[

    A* Methods for lua-astar

  ]]--


  self.getNode = function (this, location)
    -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
    -- if the location is not valid, return nil, otherwise return a new Node object
    local idx = self.getIdxAtCoord(location)
    local move_cost = 1

    if idx < 0 or idx > #self.tiles then
      return nil
    else
      return Node:new(location, move_cost, idx)
    end
  end

  self.locationsAreEqual = function (this, a, b)
    -- Here you check to see if two locations (not nodes) are equivalent
    return a.idx == b.idx
  end

  self.getAdjacentNodes = function (this, curnode, dest)
    -- Given a node, return a table containing all adjacent nodes
    local result = {}

    for i, v in pairs(self.terrain_connective_matrix[curnode.lid].air) do
      print("QQ:"..i..","..tostring(v)..","..inspect(self.getCoordFromIdx(i)))
      local coord = self.getCoordFromIdx(i)
      print("XXZZ" .. inspect(coord))
      local dN = self:getNode(coord)
      local n = self._handleNode(this, dN.location, curnode)
      print("ADJACENT:" .. n.lid)
      table.insert(result, n)
    end

    return result
  end

  self._handleNode = function (this, location, fromnode)
    -- Fetch a Node for the given location and set its parameters
    local idx = self.getIdxAtCoord({col = location.col, row = location.row})
    local n = Node:new(location, 0, idx)

    if n ~= nil then
      local dx = 1 -- math.max(x, destx) - math.min(x, destx)
      local dy = 1 -- math.max(y, desty) - math.min(y, desty)
      local emCost = dx + dy

      n.mCost = 1 --n.mCost + fromnode.mCost
      n.score = n.mCost + emCost
      n.parent = fromnode
      n.lid = idx

      return n
    end

    return nil
  end

  self.astar = AStar(self)
  return self
end
