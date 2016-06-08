--AlertBoxView
AlertBoxView = {}

AlertBoxView.new = function (init)
  local init = init or {}
  local self = View.new(init)


  self.alert = ViewComponent.new({
      main_text = "An alert!",
      button_text = "Okay",
      ui_rect = {x = self.rect.w / 2 - 200, y = self.rect.h / 2 - 100, w = 400, h = 200, rx = 25, ry = 25},
      background_color = {r = 10, g = 80, b = 120},
      super = self
    })

  self.onMousePressed = function (x, y, button)
  end

  self.onMouseReleased = function (x, y)
  end

  self.draw = function ()
    love.graphics.setColor(self.alert.background_color.r, self.alert.background_color.g, self.alert.background_color.b)
    love.graphics.rectangle("fill", self.alert.ui_rect.x, self.alert.ui_rect.y, self.alert.ui_rect.w, self.alert.ui_rect.h, self.alert.ui_rect.rx, self.alert.ui_rect.ry)
    love.graphics.reset()
  end

  self.onUpdate = function (dt)
  end

  self.doClick = function()
  end

  return self
end
