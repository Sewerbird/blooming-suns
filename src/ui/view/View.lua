--View

View = {}

View.new = function (init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect or {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()},
    model = init.model or nil,
    components = {},
    mouseDownComponent = nil
  }

  self.getClickedComponent = function (x, y)
    for i, component in ipairs(self.components) do
      if component.ui_rect.x < x and component.ui_rect.x + component.ui_rect.w > x and component.ui_rect.y < y and component.ui_rect.y + component.ui_rect.h > y then
        return component
      end
    end
    return nil
  end
  
  self.addComponent = function(component)
    table.insert(self.components, component)
  end

  --[[ EVENTS ]]--

  --The view can respond to draw loop calls
  self.draw = function ()
    for i, v in ipairs(self.components) do
      v.onDraw()
    end
  end

  --The view can respond to time-update events
  self.update = function (dt)
    for i, v in ipairs(self.components) do
      if v.onUpdate ~= nil then
        v.onUpdate(dt)
      end
    end
  end

  --The view can respond to gamestate mutations
  self.onMutation = function (mut)
    for i, v in ipairs(self.components) do
      if v.onMutation ~= nil then
        v.onMutation(dt)
      end
    end
  end

  --The view can respond to mouse presses over components
  self.onMousePressed = function (x, y, button)
    local component = self.getClickedComponent(x,y)
    if component ~= nil and component.onMousePressed ~= nil then
      mouseDownComponent = component
      component.onMousePressed(x - component.ui_rect.x, y - component.ui_rect.y, button)
    end
  end

  --The view can respond to mouse releases over components
  self.onMouseReleased = function (x, y, button)
    local component = self.getClickedComponent(x,y)
    if component ~= nil and component.onMouseReleased ~= nil then
      component.onMouseReleased(x - component.ui_rect.x, y - component.ui_rect.y, button)
    end
    if component ~= nil and component.onMouseCancelled ~= nil and self.mouseDownComponent ~= component then
      component.onMouseCancelled()
    end
  end

  --The view can respond to mouse motions over components
  self.onMouseMoved = function (x, y, button)
    local component = self.getClickedComponent(x,y)
    if component ~= nil and component.onMouseMoved ~= nil then
      component.onMouseMoved(x - component.ui_rect.x, y - component.ui_rect.y, button)
    end
  end

  return self
end
