--ViewComponent
ViewComponent = {}

ViewComponent.new = function (init)
  local init = init or {}
  local self = init or {}

  self.onMousePressed = function (x, y, button)
  end

  self.onMouseReleased = function (x, y)
  end

  self.onUpdate = function (dt)
  end

  return self
end
