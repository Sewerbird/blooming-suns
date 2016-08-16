MoveSelectionMutator = {}

MoveSelectionMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.units = init.units --units
  self.src = init.src --hex
  self.dst = init.dst --hex
  self.map = init.map --tilemap


  self.execute = function (state)
    local map = state.getTilemap(self.map)
    for i, unit in self.units do
      local mover = map.getHexAtIdx(self.src).getStack().getUnit(unit)
      local move_cost = map.terrain_connective_matrix[self.dst]['mpcost'][mover.move_method]
      mover.curr_movepoints = math.max(mover.curr_movepoints - (move_cost or 1), 0)
      local moved = map.getHexAtIdx[self.src].delocateUnit(unit)
      moved.location = self.dst
      map.getHexAtIdx[self.dst].relocateUnit(moved)
    end
  end

  self.undo = function (state)
    for i, unit in self.units do
      local mover = self.map.getHexAtIdx(self.dst).getStack().getUnit(unit)
      local move_cost = self.map.terrain_connective_matrix[self.dst]['mpcost'][mover.move_method]
      mover.curr_movepoints = math.max(mover.curr_movepoints + (move_cost or 1), 0)
      local moved = self.map.getHexAtIdx(self.dst).delocateUnit(mover)
      moved.location = self.src
      self.map.getHexAtIdx(self.sr).relocateUnit(moved)
    end
  end

  return self
end
