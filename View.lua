--View

View = {}

View.new = function (init)
  local init = init or {}
  local self = {
    rect = init.rect or {x = 0, y = 0, width = 200, height = 100},
    model = init.model or nil
  }

  self.draw = function ()
  end

  self.update = function ()
  end

  return self
end
