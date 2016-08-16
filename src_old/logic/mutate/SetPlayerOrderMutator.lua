SetPlayerOrderMutator = {}

SetPlayerOrderMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.player_idx_order = init.player_idx_order

  self.execute = function (state)
    self.oldOrder = state.getPlayerOrder()
    state.setPlayerOrder(self.player_idx_order)
  end

  self.undo = function (state)
    state.setPlayerOrder(self.oldOrder)
  end

  return self
end
