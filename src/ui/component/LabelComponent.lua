--LabelComponent

LabelComponent = {}

LabelComponent.new = function(init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect or self.ui_rect,
    text = init.text or "",
    background_color = init.background_color or nil
  }

  self.onDraw = function ()
    if self.background_color ~= nil then
      love.graphics.setColor(self.background_color)
      love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
      love.graphics.reset()
    end
    love.graphics.print(self.text, self.ui_rect.x, self.ui_rect.y)
  end

  return self
end
