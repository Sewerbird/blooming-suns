--AttackStackOrder.lua

AttackStackOrder = {}

AttackStackOrder.new = function (init)
  local init = init or {}
  local self = Order.new(init)

  self.kind = "attack"
  self.dst = init.dst or nil
  self.src = init.src or nil
  self.map = init.map or nil
  self.unit = init.unit or nil

  self.mutator = BattleMutator.new({
    src = self.src,
    dst = self.dst,
    map = self.map,
    unit = self.unit
  })

  self.verify = function ()
    local unit = self.unit
    local map = self.map
    local dst_idx = self.dst.idx
    --A unit must have enough move points for the move into the square, unless they have full movepoints: in which case they may move (using up all)
    --local move_cost = map.terrain_connective_matrix[dst_idx]['mpcost'][unit.move_method]
    --if unit.curr_movepoints < move_cost and unit.curr_movepoints < unit.max_movepoints then
    --    return false
    --end

    return true
  end

  return self
end
