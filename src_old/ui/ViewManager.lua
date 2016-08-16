--ViewManager
ViewManager = class("ViewManager", {
  activeView = 0
  views = {}
})

function ViewManager:getActiveView()
  return self.activeView
end

function ViewManager:push(view)
  self.activeView = #self.views+1
  table.insert(self.views, view)
end

function ViewManager:pop()
  local popped = self.views[#self.views]
  self.activeView = #self.views - 1 or 0
  self.views[#self.views] = nil
end

function ViewManager:peek()
  return self.views[#self.views]
end


function ViewManager:onMousePressed(x, y, button)
  local tgt_view = self.getClickedView(x, y)
  if tgt_view ~= nil then tgt_view:onMousePressed(x, y, button) else print("Nothing clicked!")end
end

function ViewManager:onMouseReleased(x, y, button)
  local tgt_view = self.getClickedView(x, y)
  if tgt_view ~= nil then tgt_view:onMouseReleased(x, y, button) else print("Nothing clicked!") end
end

function ViewManager:onKeyPressed(key)
  if self.views[self.activeView].onKeyPressed ~= nil then
    self.views[self.activeView]:onKeyPressed(key)
  end
end

function ViewManager:onMutation(mut)
  if self.views[self.activeView].onMutation ~= nil then
    self.views[self.activeView]:onMutation(mut)
  end
end

function ViewManager:getClickedView(x, y)
  local result = nil
  for i = 1 , #self.views do
    local v = self.views[#self.views - (i - 1)]
    local rect = v.ui_rect
    if x <= rect.x + rect.w and x >= rect.x and y <= rect.y + rect.h and y > rect.y then
      result = #self.views - (i - 1)
      break
    end
  end
  return self.views[result] or nil
end

function ViewManager:draw()
  for i = 1, #self.views do
    self.views[i]:draw()
  end
end

function ViewManager:update(dt)
  if self.views[self.activeView] ~= nil then
    if self.views[self.activeView].onMouseMoved ~= nil then
      local x = love.mouse.getX()
      local y = love.mouse.getY()
      self.views[self.activeView]:onMouseMoved(x - self.views[self.activeView].ui_rect.x,y - self.views[self.activeView].ui_rect.y)
    end
    self.views[self.activeView]:update(dt)
  end
end
