--View
local UI_Poly = require('src/lib/ui_poly')

local View = class("View",{
  ui_poly = UI_Poly:new(),
  background_color = {220, 210, 220, 100},
  mouseDownComponent = nil,
  components = {}
})

function View:init (ui_poly, color)
  self.ui_poly = UI_Poly:new(ui_poly)
  self.background_color = color
end

function View:getClickedComponent(x, y)
  local topmostZ = -9999
  local result = nil
  for i, component in ipairs(self.components) do
    if component.ui_poly:containsPoint(x - component.ui_poly.x,y - component.ui_poly.y) and component.ui_poly.z > topmostZ then
        result = component
        topmostZ = component.ui_poly.z
    end
  end
  return result
end

function View:addComponent(component)
  table.insert(self.components, component)
end

--[[ EVENTS ]]--

--The view can respond to draw loop calls
function View:draw()
  if self.background_color ~= nil then
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill", self.ui_poly.x, self.ui_poly.y, self.ui_poly.w, self.ui_poly.h, self.ui_poly.rx, self.ui_poly.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.reset()
  end

  for i, v in ipairs(self.components) do
    v:onDraw()
  end
end

--The view can respond to time-update events
function View:update(dt)
  for i, v in ipairs(self.components) do
    if v.onUpdate ~= nil then
      v:onUpdate(dt)
    end
  end
end

--The view can respond to gamestate mutations
function View:onMutation(mut)
  for i, v in ipairs(self.components) do
    if v.onMutation ~= nil then
      v:onMutation(dt)
    end
  end
end

--The view can respond to mouse presses over components
function View:onMousePressed(x, y, button)
  local component = self:getClickedComponent(x,y)
  if component ~= nil and component.onMousePressed ~= nil then
    mouseDownComponent = component
    component:onMousePressed(x - component.ui_poly.x, y - component.ui_poly.y, button)
  end
end

--The view can respond to mouse releases over components
function View:onMouseReleased(x, y, button)
  local component = self:getClickedComponent(x,y)
  if component ~= nil and component.onMouseReleased ~= nil then
    component:onMouseReleased(x - component.ui_poly.x, y - component.ui_poly.y, button)
  end
  if component ~= nil and component.onMouseCancelled ~= nil and self.mouseDownComponent ~= component then
    component:onMouseCancelled()
  end
end

--The view can respond to mouse motions over components
function View:onMouseMoved(x, y, button)
  local component = self:getClickedComponent(x,y)
  if component ~= nil and component.onMouseMoved ~= nil then
    component:onMouseMoved(x - component.ui_poly.x, y - component.ui_poly.y, button)
  end
end

--The view can respond to key presses
function View:onKeyPressed(key)
end

return View
