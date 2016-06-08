--ImmediateButtonComponent

ImmediateButtonComponent = {}

ImmediateButtonComponent.new = function(init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil,
    text = init.text or "",
    ui_rect = init.ui_rect or self.ui_rect,
    callback = init.callback or nil,
    background_color = init.background_color or nil
  }

  if self.sprite ~= nil then self.sprite.position = self.ui_rect end

  self.onDraw = function ()
    if self.background_color ~= nil then
      love.graphics.setColor(self.background_color)
      love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
      love.graphics.reset()
    end
    if self.text ~= "" then
      love.graphics.print(self.text, self.ui_rect.x, self.ui_rect.y)
    end
    if self.sprite ~= nil then
      self.sprite.draw()
    end
  end

  self.onClick = self.callback

  return self
end
