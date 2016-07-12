MoveSelectionMutator = {}

MoveSelectionMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.units = init.units --units
  self.src = init.src --hex
  self.dst = init.dst --hex
  self.map = init.map --tilemap


  self.execute = function (state)
    for i, unit in self.units do
      local unit = self.src.stack.getUnit(unit.uid)
      local move_cost = self.map.terrain_connective_matrix[self.dst.idx]['mpcost'][unit.move_method]
      unit.curr_movepoints = math.max(self.unit.curr_movepoints - (move_cost or 1), 0)
      local moved = self.map.tiles[self.src.idx].delocateUnit(unit.uid)
      moved.location = self.dst
      self.map.tiles[self.dst.idx].relocateUnit(moved)
    end
  end

  self.undo = function (state)
    for i, unit in self.units do
      local unit = self.map.getHexAtIdx(self.dst.idx).stack.getUnit(unit.uid)
      local move_cost = self.map.terrain_connective_matrix[self.dst.idx]['mpcost'][unit.move_method]
      unit.curr_movepoints = math.max(unit.curr_movepoints + (move_cost or 1), 0)
      local moved = self.map.getHexAtIdx(self.dst.idx).delocateUnit(unit.uid)
      moved.location = self.src.position
      self.map.getHexAtIdx(self.src.idx).relocateUnit(moved)
    end
  end

  return self
end
