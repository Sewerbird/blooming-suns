--Gamestate.lua

Gamestate = {}

Gamestate.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    tilemaps = {},
    spacemaps = {},
    players = {},
    turn_order = {},
    current_player = nil
  }

  self.addSpacemap = function (idx, spacemap)
    self.spacemaps[idx] = spacemap
  end

  self.addTilemap = function (idx, tilemap)
    self.tilemaps[idx] = tilemap
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

  self.setPlayerOrder = function (player_idx_order)
    self.turn_order = player_idx_order
  end

  self.getTilemap = function (idx)
    return self.tilemaps[idx]
  end

  self.getSpacemap = function (idx)
    return self.spacemaps[idx]
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

  self.startTurn = function ()
    print("Turn Begun: Running Processes...")
    print("--> No Processes")
    print("Turn Processing Complete!")
  end

  return self
end
