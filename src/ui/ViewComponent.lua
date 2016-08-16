--ViewComponent
local ViewComponent = class("ViewComponent",{
  ui_rect = {x = 0, y = 0, h = 25, w = 25},
  background_color = {200, 150, 190},
  description = "EXAMPLE"
})

function ViewComponent:onMousePressed(x, y, button)
  --Components can respond to mouse presses over themselves
end

function ViewComponent:onMouseReleased(x, y)
  --Components can respond to mouse releases over themselves
end

function ViewComponent:onMouseMoved(x, y, button)
  --Components can respond to mouse motions over themselves
end

function ViewComponent:onMouseCancelled()
  --If this component was MousePressed, but the mouse released was off-component, you can respond here
end

function ViewComponent:onUpdate(dt)
  --Components that are sensitive to time can get an onUpdate here
end

function ViewComponent:onDraw()
  --Components must be able to draw themselves

  --DEFAULT implementation. Just fills the background over the whole ui_rect with the background color
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
  love.graphics.setColor(255,255,255)
  love.graphics.reset()
end

return ViewComponent
