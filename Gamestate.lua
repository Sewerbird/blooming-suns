--Gamestate.lua

Gamestate = {}

Gamestate.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    tilemaps = {},
    players = {},
    turn_order = {},
    current_player = nil
  }

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

  self.setPlayerOrder = function (player_idx_order)
    self.turn_order = player_idx_order
  end

  self.getTilemap = function (idx)
    return self.tilemaps[idx]
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
    print("CURRENT_PLAYER IS " .. self.current_player)
  end

  return self
end
