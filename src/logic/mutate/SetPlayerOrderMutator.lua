SetPlayerOrderMutator = {}

SetPlayerOrderMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.state = init.state
  self.player_idx_order = init.player_idx_order

  self.execute = function ()
    self.oldOrder = self.state.getPlayerOrder()
    self.state.setPlayerOrder(self.player_idx_order)
  end

  self.undo = function ()
    self.state.setPlayerOrder(self.oldOrder)
  end

  return self
end
