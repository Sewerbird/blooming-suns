--Order.lua
Order = {}

Order.new = function (init)
  local init = init or {}
  local self = {

  }

  self.serialize = function()
    return ""
  end

  return self
end
