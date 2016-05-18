--ViewManager

ViewManager = {}

ViewManager.new = function (init)
  local init = init or {}
  local self = {
    activeView = init.activeView or nil,
    views = {}
  }

  self.getActiveView = function ()
    return self.activeView
  end

  self.push = function (view)
    self.views[#self.views+1] = view
  end

  self.peek = function (view)
    return self.views[#self.views]
  end

  self.pop = function (view)
    local popped = self.views[#self.views]
    self.views[#self.views] = nil
    return popped
  end

  self.onMousePressed = function (x, y, button)
    local cam = self.views[1].camera
    cam.onMousePressed(x,y,button)
  end

  self.onMouseReleased = function (x, y, button)
    local cam = self.views[1].camera
    cam.onMouseReleased(x,y,button)
  end

  self.draw = function ()
    local cam = self.views[1].camera
    local toDraw = cam.getSeen()
    for i = 0, table.getn(toDraw.tiles) do
      local computedPosition = {
        x = toDraw.tiles[i].position.x - cam.position.x + cam.extent.half_width,
        y = toDraw.tiles[i].position.y - cam.position.y + cam.extent.half_height
      }
      toDraw.tiles[i].draw(computedPosition)
    end
  end

  self.update = function (dt)
    self.views[1].update(dt)
  end

  return self
end
