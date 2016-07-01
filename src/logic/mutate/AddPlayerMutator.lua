AddPlayerMutator = {}

AddPlayerMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.player = init.player

  self.execute = function (state)
    self.addedIdx = #self.state.players+1
    state.addPlayer(self.addedIdx, self.player)
  end

  self.undo = function (state)
    state.removePlayer(self.addedIdx)
  end

  return self
end
