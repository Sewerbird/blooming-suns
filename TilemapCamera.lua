-- TilemapCamera
TilemapCamera = {}

TilemapCamera.new = function (init)
  local init = init or {}
  local self = {
    position = init.position,
    extent = init.extent,
    target = init.target,
    dragLocus = init.dragLocus,
    lastClick = init.lastClick,
    keyboard_speed = 800
  }


  self.getSeen = function ()
    local seen = {}
    seen.tiles = self.target.tiles
    seen.units = {}
    return seen
  end

  self.getSeenAt = function (x, y)
    local world_space_position = {
      x = (x - self.extent.half_width) + self.position.x,
      y = (y - self.extent.half_height) + self.position.y
    }
    return self.target.getTileAt(world_space_position)
  end

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

  self.onUpdate = function (dt)
        local moved = false
    --Update tiles & units (for animation)
    local seen = self.getSeen()
    for i = 1, table.getn(seen.tiles) do
      seen.tiles[i].update(dt)
    end
    for i = 1, table.getn(seen.units) do
      seen.units[i].update(dt)
    end

    --Mouse Pan
    if self.dragLocus ~= nil then
      self.position.x = self.dragLocus.camx + (self.dragLocus.x - love.mouse.getX())
      self.position.y = self.dragLocus.camy + (self.dragLocus.y - love.mouse.getY())
      moved = true
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
      moved = true
    end
    --bounds check
    if moved then
      local topEdge = self.position.y - self.extent.half_height;
      local bottomEdge = self.position.y + self.extent.half_height;
      local rightWorldEdge = self.target.num_cols * 32;
      local leftWorldEdge = 0;

      if topEdge < 16 then self.position.y = self.extent.half_height + 16 end
      if bottomEdge > self.target.num_rows * 32 then self.position.y = self.target.num_rows * 32 - self.extent.half_height end
      if self.position.x > rightWorldEdge then self.position.x = self.position.x - rightWorldEdge end
      if self.position.x < leftWorldEdge then self.position.x = rightWorldEdge + self.position.x end
      self.position.y = math.floor(self.position.y)
      self.position.x = math.floor(self.position.x)
    end
  end

  self.doClick = function (x, y, button)
    local clickable = self.getSeenAt(x,y)
    if clickable ~= nil then
      clickable:click()
    end
  end

  return self
end
