--Gamestate.lua

Gamestate = {}

Gamestate.new = function(init){
  local init = init or {}
  local self = {
    units = {},
    tilemaps = {},
    players = {}
  }
}
