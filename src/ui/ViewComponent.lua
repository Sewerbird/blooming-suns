--ViewComponent
local ViewComponent = class("ViewComponent",{
  ui_rect = {x = 0, y = 0, h = 25, w = 25, z = 0},
  background_color = {200, 150, 190},
  description = "EXAMPLE",
  components = {} --subcomponents
})

function ViewComponent:init(desc, rect, color)
  self.ui_rect = rect
  self.background_color = color
  self.description = desc
end

function ViewComponent:getClickedComponent(x, y)
  local topmostZ = -1
  local result = nil
  for i, component in ipairs(self.components) do
    if self.ui_rect.x + component.ui_rect.x < x and 
      self.ui_rect.x + component.ui_rect.x + component.ui_rect.w > x and 
      self.ui_rect.y + component.ui_rect.y < y and 
      self.ui_rect.y + component.ui_rect.y + component.ui_rect.h > y and
      component.ui_rect.z > topmostZ then
        result = component
        topmostZ = component.ui_rect.z
    end
  end
  return result
end

function ViewComponent:onMousePressed(x, y, button)
  --Components can respond to mouse presses over themselves
  local tgt = self:getClickedComponent(x,y)
  print(self.description .. ' clicked')
  if tgt ~= nil and tgt.onMousePressed ~= nil then tgt:onMousePressed(x, y, button) end
end

function ViewComponent:onMouseReleased(x, y)
  --Components can respond to mouse releases over themselves
  local tgt = self:getClickedComponent(x,y)
  if tgt ~= nil and tgt.onMouseReleased ~= nil then tgt:onMouseReleased(x, y, button) end
end

function ViewComponent:onMouseMoved(x, y, button)
  --Components can respond to mouse motions over themselves
  local tgt = self:getClickedComponent(x,y)
  if tgt ~= nil and tgt.onMouseMoved ~= nil then tgt:onMouseMoved(x, y, button) end
end

function ViewComponent:onUpdate(dt)
  --Components that are sensitive to time can get an onUpdate here
  for i, v in ipairs(self.components) do
    v:onUpdate(dt)
  end
end

function ViewComponent:onDraw()
  --Components must be able to draw themselves
  for i, v in ipairs(self.components) do
    v:onDraw(dt)
  end
  --DEFAULT implementation. Just fills the background over the whole ui_rect with the background color
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
  love.graphics.setColor(255,255,255)
  love.graphics.print(self.description, self.ui_rect.x + self.ui_rect.w/2 - 30, self.ui_rect.y + self.ui_rect.h/2)
  love.graphics.reset()
end

return ViewComponent
