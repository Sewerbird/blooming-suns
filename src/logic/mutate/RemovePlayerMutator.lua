RemovePlayerMutator = {}

RemovePlayerMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.state = init.state
  self.player_idx = init.player_idx

  self.execute = function ()
    self.removedPlayer = self.state.getPlayer(self.player_idx)
    self.state.removePlayer(self.addedIdx, self.player)
  end

  self.undo = function ()
    self.state.addPlayer(self.removed_player)
  end

  return self
end
