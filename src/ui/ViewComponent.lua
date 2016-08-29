--ViewComponent
local UI_Poly = require('src/lib/ui_poly')

local ViewComponent = class("ViewComponent",{
  ui_poly = UI_Poly:new(),
  background_color = {200, 150, 190},
  description = "EXAMPLE",
  components = {} --subcomponents
})

function ViewComponent:init(desc, ui_poly, color)
  self.description = desc
  self.ui_poly = UI_Poly:new(ui_poly)
  self.background_color = color
end

function ViewComponent:addComponent(component)
  table.insert(self.components, component)
end

function ViewComponent:getClickedComponent(x, y)
  local topmostZ = -1
  local result = nil
  for i, component in ipairs(self.components) do
    if component.ui_poly:containsPoint(x - component.ui_poly.x,y - component.ui_poly.y) and component.ui_poly.z > topmostZ then
        result = component
        topmostZ = component.ui_poly.z
    end
  end
  if result == nil then
      result = self 
  end
  return result
end

function ViewComponent:onMousePressed(x, y, button)
  --Components can respond to mouse presses over themselves
  local tgt = self:getClickedComponent(x,y)
  if tgt ~= nil and tgt ~= self and tgt.onMousePressed ~= nil then 
    tgt:onMousePressed(x, y, button) 
  elseif tgt == self then
    print(self.description .. ' clicked')
  end
end

function ViewComponent:onMouseReleased(x, y)
  --Components can respond to mouse releases over themselves
  local tgt = self:getClickedComponent(x,y)
  if tgt ~= nil and tgt ~= self and tgt.onMouseReleased ~= nil then tgt:onMouseReleased(x, y, button) end
end

function ViewComponent:onMouseMoved(x, y, button)
  --Components can respond to mouse motions over themselves
  local tgt = self:getClickedComponent(x,y)
  if tgt ~= nil and tgt ~= self and tgt.onMouseMoved ~= nil then 
    tgt:onMouseMoved(x, y, button) 
  end
end

function ViewComponent:onUpdate(dt)
  --Components that are sensitive to time can get an onUpdate here
  for i, v in ipairs(self.components) do
    v:onUpdate(dt)
  end
end

function ViewComponent:onDraw()
  --Components must be able to draw themselves
  --DEFAULT implementation. Just fills the background over the whole ui_poly with the background color
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.ui_poly.x, self.ui_poly.y, self.ui_poly.w, self.ui_poly.h, self.ui_poly.rx, self.ui_poly.ry)
  love.graphics.setColor(255,255,255)
  love.graphics.print(self.description, self.ui_poly.x + self.ui_poly.w/2 - 30, self.ui_poly.y + self.ui_poly.h/2)
  love.graphics.reset()

  if self.ui_poly.vertices and #self.ui_poly.vertices > 0 then
    local increment = 255 / #self.ui_poly.vertices
    local j = #self.ui_poly.vertices
    for i = 1, #self.ui_poly.vertices do
        local vtx = self.ui_poly.vertices[i]
        local jtx = self.ui_poly.vertices[j]
        love.graphics.setColor(255,0,math.floor((i - 1) * increment) % 255)
        love.graphics.circle("fill", self.ui_poly.x + vtx[1]-2, self.ui_poly.y + vtx[2]-2, 4, 4, 16)
        love.graphics.line(jtx[1] + self.ui_poly.x ,jtx[2] + self.ui_poly.y,vtx[1] + self.ui_poly.x ,vtx[2] + self.ui_poly.y)
        love.graphics.reset()
        j = i
    end
  end

  --Draw subcomponents
  for i, v in ipairs(self.components) do
    v:onDraw()
  end
end

return ViewComponent
