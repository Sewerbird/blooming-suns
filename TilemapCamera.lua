-- TilemapCamera
TilemapCamera = {
  position = nil,
  extent = nil,
  target = nil,
  dragLocus = nil,
  lastClick = nil
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
  --Camera Pan
  if self.dragLocus ~= nil then
    self.position.x = self.dragLocus.camx + (self.dragLocus.x - love.mouse.getX())
    self.position.y = self.dragLocus.camy + (self.dragLocus.y - love.mouse.getY())
    local topEdge = self.position.y - self.extent.half_height;
    local bottomEdge = self.position.y + self.extent.half_height;
    if topEdge < 16 then self.position.y = self.extent.half_height + 16 end
    if bottomEdge > self.target.num_rows * 32 then self.position.y = self.target.num_rows * 32 - self.extent.half_height end
  end
end

function TilemapCamera:doClick(x, y, button)
  local clickable = self:getSeenAt(x,y)
  if clickable ~= nil then
    clickable:click()
  end
end
