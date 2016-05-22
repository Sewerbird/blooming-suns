--TilemapView
PlanetsideTilemapView = {}

PlanetsideTilemapView.new = function (init)
  local init = init or {}
  local self = View.new(init)

  self.current_focus = nil

  self.camera = PlanetsideTilemapCameraComponent.new(
    {
      target = self.model,
      position = {x = self.rect.w/ 2 + self.rect.x, y = self.rect.h/2 + self.rect.y},
      extent = {half_width = self.rect.w/2, half_height = self.rect.h/2},
      super = self
    })

  self.update = function (dt)
    self.camera.onUpdate(dt)
  end

  self.onMousePressed = function (x, y, button)
    local cam = self.camera
    cam.onMousePressed(x,y,button)
  end

  self.onMouseReleased = function (x, y, button)
    local cam = self.camera
    cam.onMouseReleased(x,y,button)
  end

  self.focus = function (unit)
    if self.current_focus ~= nil or self.current_focus == unit then
      self.current_focus.click()
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
    local toDraw = self.camera.getSeen()
    for i = 1, #toDraw.tiles do
      if toDraw.tiles[i] == nil then
        print("nillable" .. i)
      else
        local computedPosition = {
          x = toDraw.tiles[i].position.x - self.camera.position.x + self.camera.extent.half_width,
          y = toDraw.tiles[i].position.y - self.camera.position.y + self.camera.extent.half_height
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
  end

  return self
end
