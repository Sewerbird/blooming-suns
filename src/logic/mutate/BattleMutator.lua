BattleMutator = {}

BattleMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.attackers = init.attackers
  self.defenders = init.defenders
  self.src = init.src --hex
  self.dst = init.dst --hex
  self.map = init.map --tilemap
  self.createdMutators = nil


  self.execute = function (state)
    --TODO: units straight up cancel each other out in a battle right now. Pretty boring, haha
    if self.createdMutators == nil then
      local orders = {}
      for i, v in ipairs(self.attackers) do
        if i > #self.defenders then break end

        table.insert(orders, DestroyUnitMutator.new({map = self.map, hex = self.dst, destroyed = self.defenders[i]}))
        table.insert(orders, DestroyUnitMutator.new({map = self.map, hex = self.src, destroyed = v}))
      end
      self.createdMutators = orders;
    end

    for i,v in ipairs(self.createdMutators) do
      v.execute(state)
    end
  end

  self.undo = function (state)
    if self.createdMutators == nil then return end
    for i, v in ipairs(self.createdMutators) do
      v.undo(state)
    end
  end

  return self
end
