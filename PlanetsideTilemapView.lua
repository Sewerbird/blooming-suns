--TilemapView
PlanetsideTilemapView = {}

PlanetsideTilemapView.new = function (init)
  local init = init or {}
  local self = View.new(init)

  self.current_focus = nil

  --Components

  self.camera = PlanetsideTilemapCameraComponent.new(
    {
      target = self.model,
      ui_rect = {x = 150, y = 0, w = self.rect.w - 150, h = self.rect.h},
      position = {x = 0, y = 0},
      extent = {half_width = self.rect.w/2, half_height = self.rect.h/2},
      super = self
    })

  self.sidebar = ViewComponent.new(
    {
      target = nil,
      ui_rect = {x = 0, y = 100, w = 150, h = self.rect.h - 100, rx = 0, ry = 0},
      background_color = {r = 100, g = 80, b = 120},
      super = self
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
    self.camera.onMouseMoved(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y)
  end

  self.onKeyPressed = function (key)

  end

  self.focus = function (unit)
    print('focus called on ' .. inspect(unit,{depth = 2}))
    if unit == nil then return end
    if self.current_focus ~= nil or self.current_focus == unit then
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = nil
    else
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = unit
      self.current_focus.click()
    end
  end

  self.draw = function ()
    --self.camera.draw()
    local toDraw = self.camera.getSeen()
    for i = 1, #toDraw.tiles do
      if toDraw.tiles[i] == nil then
        print("nillable" .. i)
      else
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
    love.graphics.setColor(self.sidebar.background_color.r, self.sidebar.background_color.g, self.sidebar.background_color.b)
    love.graphics.rectangle("fill", self.sidebar.ui_rect.x, self.sidebar.ui_rect.y, self.sidebar.ui_rect.w, self.sidebar.ui_rect.h, self.sidebar.ui_rect.rx, self.sidebar.ui_rect.ry)
    love.graphics.reset()
  end

  return self
end
