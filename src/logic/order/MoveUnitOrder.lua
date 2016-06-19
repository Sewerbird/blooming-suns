--MoveUnitOrder.lua

MoveUnitOrder = {}

MoveUnitOrder.new = function (init)
  local init = init or {}
  local self = Order.new(init)

  self.kind = "move"
  self.src = init.src or nil
  self.dst = init.dst or nil
  self.map = init.map or nil
  self.unit = init.unit or nil

  self.mutator = MoveUnitMutator.new({
    src = self.src,
    dst = self.dst,
    map = self.map,
    unit = self.unit
  })

  self.verify = function ()
    return true
  end

  return self
end
