-- PlanetsideTilemapCameraComponent
PlanetsideTilemapCameraComponent = {}

PlanetsideTilemapCameraComponent.new = function (init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect,
    position = init.position,
    extent = init.extent,
    target = init.target,
    super = init.super,
    dragLocus = init.dragLocus,
    lastClick = init.lastClick,
    tile_overlay = init.tile_overlay or {},
    keyboard_speed = 800,
    map = 1
  }

  self.onMousePressed = function (x, y, button)
    --Camera Pan
    self.dragLocus = {x = x, y = y, camx = self.position.x, camy = self.position.y}
    self.lastClick = os.time()
  end

  self.onMouseReleased = function (x, y)
    --Camera Pan
    self.dragLocus = nil
    --Click done
    local now = os.time()
    if self.lastClick ~= nil and now - self.lastClick < 0.2 then self.doClick(x, y, button) end
    lastClick = nil
    now = nil
  end

  self.onMouseMoved = function (x, y)
    --Mouse Pan
    if self.dragLocus ~= nil then
      self.position.x = self.dragLocus.camx + (self.dragLocus.x - x)
      self.position.y = self.dragLocus.camy + (self.dragLocus.y - y)
    end
  end

  self.onDraw = function()
    local toDraw = GlobalAccessorBus.ask(QueryTilesInViewport.new(self.map, self.position, self.extent))
    for i, tile in ipairs(toDraw) do
      local stack = GlobalAccessorBus.ask(QueryStackByTileIdx.new(self.map, tile))
      local hex = GlobalAccessorBus.ask(QueryTileByIdx.new(self.map, tile))
      local computedPosition = {
        x = hex.location.x - self.position.x + self.extent.half_width + self.ui_rect.x,
        y = hex.location.y - self.position.y + self.extent.half_height + self.ui_rect.y
      }
      hex.draw(computedPosition)
      if stack.size() > 0 then
        stack.head().draw(computedPosition)
      end
      if self.tile_overlay[tile] ~= nil then
        self.tile_overlay[tile].draw(computedPosition)
      end
    end
  end

  self.onUpdate = function (dt)
    --Update tiles & units (for animation)
    local toUpdate = GlobalAccessorBus.ask(QueryTilesInViewport.new(self.map, self.position, self.extent))
    for i, tile in ipairs(toUpdate) do
      local stack = GlobalAccessorBus.ask(QueryStackByTileIdx.new(self.map, tile))
      local hex = GlobalAccessorBus.ask(QueryTileByIdx.new(self.map, tile))
      hex.update(dt)
    end
    --Keyboard Pan
    if love.keyboard.isDown('w','a','s','d') then
      if love.keyboard.isDown('w') then
        self.position.y = self.position.y - (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('a') then
        self.position.x = self.position.x - (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('s') then
        self.position.y = self.position.y + (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('d') then
        self.position.x = self.position.x + (dt * self.keyboard_speed)
      end
      self.boundsCheck()
    end
  end


  self.doClick = function (x, y, button)
    local world_space_position = {
      x = (x - self.extent.half_width) + self.position.x,
      y = (y - self.extent.half_height) + self.position.y
    }
    local clickable = GlobalAccessorBus.ask(QueryTilemapById.new(self.map)).getTileAt(world_space_position)
    print('Clicking on ' .. inspect(clickable,{depth=2}))
    self.super.clickHex(clickable)
  end
  
  self.focusOnTileByIdx = function(idx)
    local hex = GlobalAccessorBus.ask(QueryTileByIdx.new(self.map, tile))
    self.position.x = hex.location.x + self.ui_rect.x
    self.position.y = hex.location.y + self.ui_rect.y
    self.boundsCheck()
  end

  self.boundsCheck = function()
    local tilemap = GlobalAccessorBus.ask(QueryTilemapById.new(self.map))
    local topEdge = self.position.y - self.extent.half_height;
    local bottomEdge = self.position.y + self.extent.half_height;
    local rightWorldEdge = self.target.num_cols * self.target.tilesize_x * 3 /4;
    local leftWorldEdge = 0;


    if topEdge < -tilemap.tilesize_y / 2 then self.position.y = self.extent.half_height - tilemap.tilesize_y /2 end
    if bottomEdge > tilemap.num_rows * math.sqrt(3) * tilemap.hex_size then
      self.position.y = tilemap.num_rows * math.sqrt(3) * tilemap.hex_size - self.extent.half_height
    end
    if self.position.x > rightWorldEdge then self.position.x = self.position.x - rightWorldEdge end
    if self.position.x < leftWorldEdge then self.position.x = rightWorldEdge + self.position.x end
    self.position.y = math.floor(self.position.y)
    self.position.x = math.floor(self.position.x)
  end

  self.setOverlay = function (tile_to_sprite_map)
    self.tile_overlay = tile_to_sprite_map
    for i, v in pairs(self.tile_overlay) do
      self.tile_overlay[i] = SpriteInstance.new({sprite = v.sprite})
    end
  end

  self.clearOverlay = function ()
    self.tile_overlay = {}
  end

  return self
end
