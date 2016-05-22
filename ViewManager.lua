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
    self.activeView = #self.views+1
    self.views[#self.views+1] = view
  end

  self.peek = function (view)
    return self.views[#self.views]
  end

  self.pop = function (view)
    local popped = self.views[#self.views]
    self.activeView = #self.views - 1
    self.views[#self.views] = nil
    return popped
  end

  self.onMousePressed = function (x, y, button)
    local tgt_view = self.getClickedView(x, y)
    if tgt_view ~= nil then tgt_view.onMousePressed(x, y, button) else print("Nothing clicked!")end
  end

  self.onMouseReleased = function (x, y, button)
    local tgt_view = self.getClickedView(x, y)
    if tgt_view ~= nil then tgt_view.onMouseReleased(x, y, button) else print("Nothing clicked!") end
  end

  self.getClickedView = function (x, y)
    local result = nil
    for i = 1 , #self.views do
      local v = self.views[#self.views - (i - 1)]
      local rect = v.rect
      if x <= rect.x + rect.w and x >= rect.x and y <= rect.y + rect.h and y > rect.y then
        result = i
        break
      end
    end
    return self.views[result] or nil
  end

  self.draw = function ()
    local cam = self.views[1].camera
    local toDraw = cam.getSeen()
    for i = 1, #toDraw.tiles do
      if toDraw.tiles[i] == nil then
        print("nillable" .. i)
      else
        local computedPosition = {
          x = toDraw.tiles[i].position.x - cam.position.x + cam.extent.half_width,
          y = toDraw.tiles[i].position.y - cam.position.y + cam.extent.half_height
        }
        local idx = toDraw.tiles[i].idx
        --East-West Tile Wrapping
        if toDraw.indices.wIdx ~= nil and idx <= #cam.target.tiles and idx >= toDraw.indices.wIdx then
          computedPosition.x = computedPosition.x - (cam.target.hex_size * cam.target.num_cols * 3 / 2)
        elseif toDraw.indices.eIdx ~= nil and idx >= 0 and idx <= toDraw.indices.eIdx then
          computedPosition.x = computedPosition.x + (cam.target.hex_size * cam.target.num_cols * 3 / 2)
        end
        toDraw.tiles[i].draw(computedPosition)
      end
    end
  end

  self.update = function (dt)
    self.views[1].update(dt)
  end

  return self
end
