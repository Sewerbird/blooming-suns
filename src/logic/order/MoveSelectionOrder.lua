--MoveSelectionOrder.lua

MoveSelectionOrder = {}

MoveSelectionOrder.new = function (init)
  local init = init or {}
  local self = Order.new(init)

  self.kind = "move"
  self.dst = init.dst or nil
  self.src = init.src or nil
  self.map = init.map or nil
  self.units = init.unit or nil

  self.mutator = MoveUnitsMutator.new({
    src = self.src,
    dst = self.dst,
    map = self.map,
    units = self.units
  })

  self.verify = function ()
    local units = self.units
    local map = self.map
    local dst_idx = self.dst.idx
    for i, unit in ipairs(self.units) do
      --A unit must have enough move points for the move into the square, unless they have full movepoints: in which case they may move (using up all)
      local move_cost = map.terrain_connective_matrix[dst_idx]['mpcost'][unit.move_method]
      if unit.curr_movepoints < move_cost and unit.curr_movepoints < unit.max_movepoints then
          return false
      end
      --A Unit may only move into a tile owned by no one or owned by the player
      local dst_owner = map.tiles[dst_idx].stack.getOwner()
      if dst_owner ~= nil and unit.owner ~= dst_owner then
        return false
      end
    end

    return true
  end

  return self
end
