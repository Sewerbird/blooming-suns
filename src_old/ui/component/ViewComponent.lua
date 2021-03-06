--ViewComponent
ViewComponent = {}

ViewComponent.new = function (init)
  local init = init or {}
  local self = init or {
    target = init.target or nil,
    description = init.target or "OOPS",
    ui_rect = init.ui_rect or {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
    background_color = init.background_color or {200, 150, 190},
    super = init.super or self
  }

  self.onMousePressed = function (x, y, button)
    --Components can respond to mouse presses over themselves
  end

  self.onMouseReleased = function (x, y)
    --Components can respond to mouse releases over themselves
  end

  self.onMouseMoved = function (x, y, button)
    --Components can respond to mouse motions over themselves
  end

  self.onMouseCancelled = function ()
    --If this component was MousePressed, but the mouse released was off-component, you can respond here
  end

  self.onUpdate = function (dt)
    --Components that are sensitive to time can get an onUpdate here
  end

  self.onDraw = function ()
    --Components must be able to draw themselves

    --DEFAULT implementation. Just fills the background over the whole ui_rect with the background color
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.reset()
  end

  return self
end
