-- TilemapCamera
TilemapCamera = {
  position = nil,
  extent = nil,
  target = nil,
  dragLocus = nil,
  lastClick = nil,
  keyboard_speed = 800
}

function TilemapCamera:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function TilemapCamera:getSeen ()
  return self.target.tiles
end

function TilemapCamera:getSeenAt (x, y)
  local world_space_position = {
    x = (x - self.extent.half_width) + self.position.x,
    y = (y - self.extent.half_height) + self.position.y
  }
  return self.target:getTileAt(world_space_position)
end

function TilemapCamera:onMousePressed (x, y, button)
  --Camera Pan
  self.dragLocus = {x = x, y = y, camx = self.position.x, camy = self.position.y}
  self.lastClick = os.time()
end

function TilemapCamera:onMouseReleased (x, y)
  --Camera Pan
  self.dragLocus = nil
  --Click done
  local now = os.time()
  if self.lastClick ~= nil and now - self.lastClick < 0.2 then self:doClick(x, y, button) end
  lastClick = nil
  now = nil
end

function TilemapCamera:onUpdate (dt)
  local moved = false
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

function TilemapCamera:doClick(x, y, button)
  local clickable = self:getSeenAt(x,y)
  if clickable ~= nil then
    clickable:click()
  end
end
