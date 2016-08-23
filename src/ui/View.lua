--View
local View = class("View",{
  ui_rect = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()},
  background_color = {220, 210, 220, 100},
  mouseDownComponent = nil,
  components = {}
})

function View:getClickedComponent(x, y)
  local topmostZ = -1
  local result = nil
  for i, component in ipairs(self.components) do
    if component.ui_rect.x < x and 
       component.ui_rect.x + component.ui_rect.w > x and 
       component.ui_rect.y < y and 
       component.ui_rect.y + component.ui_rect.h > y  and
       component.ui_rect.z > topmostZ then
        result = component
        topmostZ = component.ui_rect.z
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
    love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
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
    component:onMousePressed(x - component.ui_rect.x, y - component.ui_rect.y, button)
  end
end

--The view can respond to mouse releases over components
function View:onMouseReleased(x, y, button)
  local component = self:getClickedComponent(x,y)
  if component ~= nil and component.onMouseReleased ~= nil then
    component:onMouseReleased(x - component.ui_rect.x, y - component.ui_rect.y, button)
  end
  if component ~= nil and component.onMouseCancelled ~= nil and self.mouseDownComponent ~= component then
    component:onMouseCancelled()
  end
end

--The view can respond to mouse motions over components
function View:onMouseMoved(x, y, button)
  local component = self:getClickedComponent(x,y)
  if component ~= nil and component.onMouseMoved ~= nil then
    component:onMouseMoved(x - component.ui_rect.x, y - component.ui_rect.y, button)
  end
end

--The view can respond to key presses
function View:onKeyPressed(key)
end

return View
