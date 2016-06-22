AddPlayerMutator = {}

AddPlayerMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.state = init.state
  self.player = init.player

  self.execute = function ()
    self.addedIdx = #self.state.players+1
    self.state.addPlayer(self.addedIdx, self.player)
  end

  self.undo = function ()
    self.state.removePlayer(self.addedIdx)
  end

  return self
end
