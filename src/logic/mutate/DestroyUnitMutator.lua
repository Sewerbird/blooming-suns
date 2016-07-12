DestroyUnitMutator = {}

DestroyUnitMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.destroyed = init.destroyed--destroyed unit
  self.hex = init.hex
  self.map = init.map --tilemap
  self.unit = nil


  self.execute = function (state)
    print(inspect(self))
    self.unit = state.getTilemap(self.map).getHexAtIdx(self.hex).delocateUnit(self.destroyed)
  end

  self.undo = function (state)
    state.getTilemap(self.map).getHexAtIdx(self.hex).stack.addUnit(self.unit)
  end

  return self
end
