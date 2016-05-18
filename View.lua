--View

View = {}

View.new = function (init)
  local init = init or {}
  local self = {
    position = init.position or {x = 0, y = 0},
    extent = init.extent or {width = 200, height = 100}
  }

  self.draw = function ()
  end

  self.update = function ()
  end

  return self
end
