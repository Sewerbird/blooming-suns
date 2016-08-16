RemovePlayerMutator = {}

RemovePlayerMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.player_idx = init.player_idx

  self.execute = function (state)
    self.removedPlayer = state.getPlayer(self.player_idx)
    state.removePlayer(self.addedIdx, self.player)
  end

  self.undo = function (state)
    state.addPlayer(self.removed_player)
  end

  return self
end
