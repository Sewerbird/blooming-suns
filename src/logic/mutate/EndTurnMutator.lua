EndTurnMutator = {}

EndTurnMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.state = init.state

  self.execute = function ()
    local nxt = nil
    for i, player in ipairs(self.state.turn_order) do
      if player == self.state.current_player then
        nxt = i + 1
        break
      end
    end
    if self.state.turn_order[nxt] == nil then
      self.state.current_player = self.state.turn_order[1]
    else
      self.state.current_player = self.state.turn_order[nxt]
    end
    print("CURRENT_PLAYER IS NOW " .. self.state.current_player)
  end

  self.undo = function ()
    local prev = nil
    for i, player in ipairs(self.state.turn_order) do
      if player == self.state.current_player then
        prev = i - 1
        break
      end
    end
    if self.state.turn_order[prev] == nil then
      self.state.current_player = self.state.turn_order[#self.state.turn_order]
    else
      self.state.current_player = self.state.turn_order[prev]
    end
    print("CURRENT_PLAYER IS NOW" .. self.state.current_player)
  end

  return self
end
