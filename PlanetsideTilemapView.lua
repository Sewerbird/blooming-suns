--TilemapView
PlanetsideTilemapView = {}

PlanetsideTilemapView.new = function (init)
  local init = init or {}
  local self = View.new(init)

  self.current_focus = nil

  --Components
  --TODO: auto-layout, load-config-from-file, or at least dynamic/% sizing
  local uicruft_alpha = 125
  self.camera = PlanetsideTilemapCameraComponent.new(
    {
      target = self.model,
      ui_rect = {x = 150, y = 20, w = self.rect.w - 150, h = self.rect.h - 50 - 20},
      position = {x = 0, y = self.rect.h / 2},
      extent = {half_width = self.rect.w/2, half_height = self.rect.h/2},
      super = self
    })

  self.inspector = ViewComponent.new(
    {
      target = nil,
      description = "Inspector",
      ui_rect = {x = 0, y = 20 + 100, w = 150, h = self.rect.h - 100 - 20 - 50, rx = 0, ry = 0},
      background_color = {r = 100, g = 80, b = 120, a = uicruft_alpha},
      super = self
    })

  self.commandpanel = ViewComponent.new({
      target = nil,
      description = "Commands",
      ui_rect = {x = 0, y = self.rect.h - 50, w = 150, h = 50, rx = 0, ry = 0},
      background_color = {r = 50, g = 10, b = 70}
    })
  self.titlebar = ViewComponent.new(
    {
      target = nil,
      description = "Titlebar",
      ui_rect = {x = 0, y = 0, w = self.rect.w, h = 20, rx = 0, ry = 0},
      background_color = {r = 110, g = 90, b = 140, a = uicruft_alpha},
      super = self
    })

  self.resourcebar = ViewComponent.new(
    {
      target = nil,
      description = "Resourcebar",
      ui_rect = {x = 150, y = self.rect.h - 50, w = self.rect.w - 150, h = 50},
      background_color = {r = 110, g = 90, b = 140, a = uicruft_alpha},
      super = self
    })

  self.minimap = ViewComponent.new(
    {
      target = nil,
      description = "Minimap",
      ui_rect = {x = 0, y = 20, w = 125, h = 100, rx = 0, ry = 0},
      background_color = {r = 140, g = 110, b = 170, a = uicruft_alpha},
      super = self
    })

  self.spacesidebutton = ViewComponent.new({
      target = nil,
      description = "SPAAAACE",
      ui_rect = {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
      background_color = {r = 200, g = 150, b = 190},
      super = self
    })

  self.blastoffbutton = ViewComponent.new({
      target = nil,
      description = "TAKEOFF",
      ui_rect = {x = 125, y = 45, h = 75, w = 25, rx = 0, ry = 0},
      background_color = {r = 230, g = 190, b = 220}
    })

  --Events
  self.update = function (dt)
    self.camera.onUpdate(dt)
  end

  self.onMousePressed = function (x, y, button)
    self.camera.onMousePressed(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y,button)
  end

  self.onMouseReleased = function (x, y, button)
    self.camera.onMouseReleased(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y,button)
  end

  self.onMouseMoved = function (x, y)
    local w_x = x - self.camera.ui_rect.x;
    local w_y = y - self.camera.ui_rect.y
    self.camera.onMouseMoved(w_x, w_y)
  end

  self.onKeyPressed = function (key)

  end

  self.focus = function (unit)
    --if unit == nil then return end
    if self.current_focus ~= nil and self.current_focus == unit then
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = nil
    elseif self.current_focus ~= nil and self.current_focus ~= unit then
      local start = {row = self.current_focus.position.row, col = self.current_focus.position.col, idx = self.current_focus.idx}
      local goal = {row = unit.position.row, col = unit.position.col, idx = unit.idx}
      --DEBUG: Show TIles On Path
      local path = self.model.astar:findPath(start, goal)

      if path == nil then return end

      self.current_focus.units[1].setMoveQueue(path)
      print("F::"..inspect(self.current_focus.units[1].move_queue))

      for i, v in ipairs(self.model.tiles) do
        self.model.tiles[i].debug = false;
      end
      for i, v in ipairs(path.nodes) do
        self.model.tiles[v.lid].debug = true;
      end
    else
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = unit
      self.current_focus.click()
    end
  end

  self.draw = function ()
    --TODO: self.camera.draw()
    local toDraw = self.camera.getSeen()
    for i = 1, #toDraw.tiles do
      if toDraw.tiles[i] ~= nil then
        local computedPosition = {
          x = toDraw.tiles[i].position.x - self.camera.position.x + self.camera.extent.half_width + self.camera.ui_rect.x,
          y = toDraw.tiles[i].position.y - self.camera.position.y + self.camera.extent.half_height + self.camera.ui_rect.y
        }
        local idx = toDraw.tiles[i].idx
        --East-West Tile Wrapping
        if toDraw.indices.wIdx ~= nil and idx <= #self.camera.target.tiles and idx >= toDraw.indices.wIdx then
          computedPosition.x = computedPosition.x - (self.camera.target.hex_size * self.camera.target.num_cols * 3 / 2)
        elseif toDraw.indices.eIdx ~= nil and idx >= 0 and idx <= toDraw.indices.eIdx then
          computedPosition.x = computedPosition.x + (self.camera.target.hex_size * self.camera.target.num_cols * 3 / 2)
        end
        toDraw.tiles[i].draw(computedPosition)
      end
    end
    --TODO: self.inspector.draw()
    love.graphics.setColor(self.inspector.background_color.r, self.inspector.background_color.g, self.inspector.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.inspector.ui_rect.x, self.inspector.ui_rect.y, self.inspector.ui_rect.w, self.inspector.ui_rect.h, self.inspector.ui_rect.rx, self.inspector.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.inspector.description, self.inspector.ui_rect.x + 25, self.inspector.ui_rect.y + self.inspector.ui_rect.h/2)
    love.graphics.reset()
    --TODO: self.minimap.draw()
    love.graphics.setColor(self.minimap.background_color.r, self.minimap.background_color.g, self.minimap.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.minimap.ui_rect.x, self.minimap.ui_rect.y, self.minimap.ui_rect.w, self.minimap.ui_rect.h, self.minimap.ui_rect.rx, self.minimap.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.minimap.description, self.minimap.ui_rect.x + 25, self.minimap.ui_rect.y + self.minimap.ui_rect.h/2)
    love.graphics.reset()
    --TODO: self.titlebar.draw()
    love.graphics.setColor(self.titlebar.background_color.r, self.titlebar.background_color.g, self.titlebar.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.titlebar.ui_rect.x, self.titlebar.ui_rect.y, self.titlebar.ui_rect.w, self.titlebar.ui_rect.h, self.titlebar.ui_rect.rx, self.titlebar.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.titlebar.description, self.titlebar.ui_rect.w/2, self.titlebar.ui_rect.h/3)
    love.graphics.reset()
    --TODO: self.resourcebar.draw()
    love.graphics.setColor(self.resourcebar.background_color.r, self.resourcebar.background_color.g, self.resourcebar.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.resourcebar.ui_rect.x, self.resourcebar.ui_rect.y, self.resourcebar.ui_rect.w, self.resourcebar.ui_rect.h, self.resourcebar.ui_rect.rx, self.resourcebar.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.resourcebar.description, self.resourcebar.ui_rect.x + 25, self.resourcebar.ui_rect.y + self.resourcebar.ui_rect.h/2)
    love.graphics.reset()
    --TODO: self.spacesidebutton.draw()
    love.graphics.setColor(self.spacesidebutton.background_color.r, self.spacesidebutton.background_color.g, self.spacesidebutton.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.spacesidebutton.ui_rect.x, self.spacesidebutton.ui_rect.y, self.spacesidebutton.ui_rect.w, self.spacesidebutton.ui_rect.h, self.spacesidebutton.ui_rect.rx, self.spacesidebutton.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.spacesidebutton.description, self.spacesidebutton.ui_rect.x, self.spacesidebutton.ui_rect.y + self.spacesidebutton.ui_rect.h/2)
    love.graphics.reset()
    --TODO: self.blastoffbutton.draw()
    love.graphics.setColor(self.blastoffbutton.background_color.r, self.blastoffbutton.background_color.g, self.blastoffbutton.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.blastoffbutton.ui_rect.x, self.blastoffbutton.ui_rect.y, self.blastoffbutton.ui_rect.w, self.blastoffbutton.ui_rect.h, self.blastoffbutton.ui_rect.rx, self.blastoffbutton.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.blastoffbutton.description, self.blastoffbutton.ui_rect.x, self.blastoffbutton.ui_rect.y + self.blastoffbutton.ui_rect.h/2)
    love.graphics.reset()
    --TODO: self.commandpanel.draw()
    love.graphics.setColor(self.commandpanel.background_color.r, self.commandpanel.background_color.g, self.commandpanel.background_color.b, uicruft_alpha)
    love.graphics.rectangle("fill", self.commandpanel.ui_rect.x, self.commandpanel.ui_rect.y, self.commandpanel.ui_rect.w, self.commandpanel.ui_rect.h, self.commandpanel.ui_rect.rx, self.commandpanel.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.commandpanel.description, self.commandpanel.ui_rect.x, self.commandpanel.ui_rect.y + self.commandpanel.ui_rect.h/2)
    love.graphics.reset()

  end

  return self
end
