--AttackStackOrder.lua

AttackStackOrder = {}

AttackStackOrder.new = function (init)
  local init = init or {}
  local self = Order.new(init)

  self.kind = "attack"
  self.dst = init.dst or nil
  self.src = init.src or nil
  self.map = init.map or nil
  self.attackers = init.attackers or nil
  self.defenders = init.defenders or nil

  self.mutator = BattleMutator.new({
    src = self.src,
    dst = self.dst,
    map = self.map,
    attackers = self.attackers,
    defenders = self.defenders
  })

  self.verify = function ()

    return true
  end

  return self
end
