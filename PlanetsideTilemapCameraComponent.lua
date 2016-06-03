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
    keyboard_speed = 800
  }

  self.getSeenMetadata = function ()
    local metadata = {}

    --[[
      I take advantage of the layout of the world map indices here and the fact the camera doesn't rotate.
      The hexes are laid out in even-q arrangement:
             04    12
          00 05 08 13
          01 06 09 14
          02 07 10 15
          03    11
      So I can find the upper left corner (00) and the lower right (15) and all the hexes in between will
      potentially be visible. This simplifies east-west seamless scrolling too, with negative indices used.

      --TODO: On tall maps I can improve this with a more refined approach, but the performance
      isn't so bad/critical on that part yet.
    ]]

    local ul,ur,lIdx,rIdx --extremum of camera view, in hex coords

    ul = self.target.pixel_to_hex({x = self.position.x - self.extent.half_width, y = self.position.y - self.extent.half_height})
    lr = self.target.pixel_to_hex({x = self.position.x + self.extent.half_width, y = self.position.y + self.extent.half_height})

    lIdx = self.target.getIdxAtCoord(ul) - self.target.num_rows
    rIdx = self.target.getIdxAtCoord(lr) + self.target.num_rows
    local wIdx = nil
    local eIdx = nil

    if lIdx < 0 then --show far west tiles
      wIdx = #self.target.tiles + lIdx
      lIdx = 0
    end
    if rIdx > #self.target.tiles then --show far east tiles
      eIdx = rIdx - #self.target.tiles
      rIdx = #self.target.tiles
    end

    metadata.wIdx = wIdx
    metadata.eIdx = eIdx
    metadata.lIdx = lIdx
    metadata.rIdx = rIdx
    metadata.ul = ul
    metadata.lr = lr

    return metadata

  end

  self.getSeen = function ()
    local seen = {
      tiles = {},
      units = {},
      indices = {}
    }

    seen.indices = self.getSeenMetadata()

    for i, v in pairs(self.target.tiles) do
      if (i >= seen.indices.lIdx and i <= seen.indices.rIdx) or     --normal case
         (seen.indices.wIdx ~= nil and i >= seen.indices.wIdx and i <= #self.target.tiles) or   --near left end of map
         (seen.indices.eIdx ~= nil and i <= seen.indices.eIdx and i >= 0) then --near right end of map
        table.insert(seen.tiles, v)
      end
    end

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

  self.onMouseMoved = function (x, y)
    --Mouse Pan
    if self.dragLocus ~= nil then
      self.position.x = self.dragLocus.camx + (self.dragLocus.x - x)
      self.position.y = self.dragLocus.camy + (self.dragLocus.y - y)
      moved = true
    end
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
      local rightWorldEdge = self.target.num_cols * self.target.tilesize_x * 3 /4;
      local leftWorldEdge = 0;


      if topEdge < self.target.tilesize_y / 2 then self.position.y = self.extent.half_height + self.target.tilesize_y /2 end
      if bottomEdge > (self.target.num_rows - 1) * math.sqrt(3) * self.target.hex_size then
        self.position.y = (self.target.num_rows - 1) * math.sqrt(3) * self.target.hex_size - self.extent.half_height
      end
      if self.position.x > rightWorldEdge then self.position.x = self.position.x - rightWorldEdge end
      if self.position.x < leftWorldEdge then self.position.x = rightWorldEdge + self.position.x end
      self.position.y = math.floor(self.position.y)
      self.position.x = math.floor(self.position.x)
    end
  end

  self.doClick = function (x, y, button)
    local clickable = self.getSeenAt(x,y)
    self.super.focus(clickable)
  end

  return self
end
