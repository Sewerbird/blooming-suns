--Gamestate.lua

Gamestate = {}

Gamestate.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    tilemaps = {},
    players = {},
    turn_order = {}
  }

  self.addTilemap = function (idx, tilemap)
    self.tilemaps[idx] = tilemap
  end

  self.addPlayer = function (idx, player)
    self.players[idx] = player
  end

  self.setPlayerOrder = function (player_idx_order)
    self.turn_order = player_idx_order
  end

  self.getTilemap = function (idx)
    return self.tilemaps[idx]
  end

  return self
end
