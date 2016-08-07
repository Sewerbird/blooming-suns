--Gamestate.lua

Gamestate = {}

Gamestate.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    stacks = {},
    tilemaps = {},
    spacemaps = {},
    players = {},
    turn_order = {},
    current_player = nil
  }

  self.addSpacemap = function (idx, spacemap)
    self.spacemaps[idx] = spacemap
  end

  self.getSpacemap = function (idx)
    return self.spacemaps[idx]
  end

  self.addTilemap = function (idx, tilemap)
    tilemap.uid = uid
    self.tilemaps[idx] = tilemap
  end

  self.getTilemap = function (idx)
    print('Getting tilemap' .. inspect(self.tilemaps,{depth=2}))
    return self.tilemaps[idx]
  end

  self.addPlayer = function (idx, player)
    self.players[idx] = player
    if self.current_player == nil then
      self.current_player = idx
      print("First player is " .. self.current_player)
    end
  end

  self.removePlayer = function (idx)
    self.players[idx] = nil
    local new_turn_order = {}
    for i, player in ipairs(self.turn_order) do
      if player ~= idx then
        table.insert(new_turn_order)
      end
    end
    self.setPlayerOrder(new_turn_order)
  end

  self.getPlayer = function (idx)
    return self.players[idx]
  end

  self.setPlayerOrder = function (player_idx_order)
    self.turn_order = player_idx_order
  end

  self.getPlayerOrder = function ()
    return self.turn_order
  end

  self.startTurn = function ()
    print("Turn Begun: Running Processes...")
    print("--> No Processes")
    print("Turn Processing Complete!")
  end

  self.nextTurn = function ()
    local nxt = nil
    for i, player in ipairs(self.turn_order) do
      if player == self.current_player then
        nxt = i + 1
        break
      end
    end
    if self.turn_order[nxt] == nil then
      self.current_player = self.turn_order[1]
    else
      self.current_player = self.turn_order[nxt]
    end
    print("CURRENT_PLAYER IS NOW " .. self.current_player)
    self.startTurn()
  end

  self.placeUnit = function (unit)
    table.insert(self.units,unit)
    print('Location:' .. inspect(unit.location,{depth=2}))
    print('Stack:' .. inspect(self.getTilemap(unit.location.map), {depth = 2}))
    self.getTilemap(unit.location.map).getStackAt(unit.location).addUnit(unit);
  end

  self.moveUnit = function (unit, dst_hex)
    
  end

  return self
end
