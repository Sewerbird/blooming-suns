EndTurnMutator = {}

EndTurnMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.execute = function (state)
    local nxt = nil
    for i, player in ipairs(state.turn_order) do
      if player == state.current_player then
        nxt = i + 1
        break
      end
    end
    if state.turn_order[nxt] == nil then
      state.current_player = state.turn_order[1]
    else
      state.current_player = state.turn_order[nxt]
    end
    print("CURRENT_PLAYER IS NOW " .. state.current_player)
  end

  self.undo = function (state)
    local prev = nil
    for i, player in ipairs(state.turn_order) do
      if player == state.current_player then
        prev = i - 1
        break
      end
    end
    if state.turn_order[prev] == nil then
      state.current_player = state.turn_order[#state.turn_order]
    else
      state.current_player = state.turn_order[prev]
    end
    print("CURRENT_PLAYER IS NOW" .. state.current_player)
  end

  return self
end
