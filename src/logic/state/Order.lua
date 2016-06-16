--Order.lua
Order = {}

Order.new = function (init)
  local init = init or {}
  local self = {
    kind = init.kind,
    dst = init.dst
  }

  self.serialize = function()
    return "{" .. init.kind .. "." .. init.dst.idx .. "}"
  end

  return self
end
