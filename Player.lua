--Player.lua

Player = {}

Player.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    tilemaps = {},
    players = {}
  }
end
