BattleMutator = {}

BattleMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.unit = init.unit --unit
  self.src = init.src --hex
  self.dst = init.dst --hex
  self.map = init.map --tilemap


  self.execute = function (state)
    print('DID A BATTLE')
    return
    --[[
    local unit = self.src.stack.getUnit(self.unit.uid)
    local move_cost = self.map.terrain_connective_matrix[self.dst.idx]['mpcost'][unit.move_method]
    unit.curr_movepoints = math.max(self.unit.curr_movepoints - (move_cost or 1), 0)
    local moved = self.map.tiles[self.src.idx].delocateUnit(unit)
    moved.location = self.dst
    self.map.tiles[self.dst.idx].relocateUnit(moved)
    ]]
  end

  self.undo = function (state)
    print('UNDID A BATTLE')
    return
    --[[
    local unit = self.map.getHexAtIdx(self.dst.idx).stack.getUnit(self.unit.uid)
    local move_cost = self.map.terrain_connective_matrix[self.dst.idx]['mpcost'][unit.move_method]
    unit.curr_movepoints = math.max(unit.curr_movepoints + (move_cost or 1), 0)
    local moved = self.map.getHexAtIdx(self.dst.idx).delocateUnit(unit)
    moved.location = self.src.position
    self.map.getHexAtIdx(self.src.idx).relocateUnit(moved)
    ]]
  end

  return self
end
