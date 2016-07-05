-- Tile
Tile = {}

local TILE_SPRITE_ORDER = {"terrain","fringe","feature","river","road","resource","unit"}

Tile.new = function (init)
  local init = init or {}
  local self = {
    --sprite layers
    slayers = init.slayers or {},
    --units
    units = init.units or {},
    --core
    position = init.position,
    terrain_type = init.terrain_type,
    construction_type = init.construction_type,
    owning_map = init.owning_map,
    idx = init.idx,
    stack = Stack.new()
  }

  self.update = function (dt)
    if self.stack.headSelected() ~= nil then
      self.stack.headSelected().update(dt)
    elseif self.stack.head() ~= nil then
      self.stack.head().update(dt)
    end
  end

  self.draw = function (computed_position)
    --center
    computed_position.x = computed_position.x - self.owning_map.tilesize_x / 2
    computed_position.y = computed_position.y - self.owning_map.tilesize_y / 2

    center_position = { x = computed_position.x + self.owning_map.tilesize_x / 2, y = computed_position.y + self.owning_map.tilesize_y / 2 }

    for i, v in ipairs(TILE_SPRITE_ORDER) do
      if self.slayers[v] ~= nil then
        self.slayers[v].position = computed_position
        local do_center = false
        if v == "unit" then
          if self.stack.hasSelection() then
            self.stack.headSelected().setAnim('selected')
          else
            self.stack.head().setAnim('idle')
          end
          do_center = true
          self.slayers[v].draw(center_position, do_center)
          --Draw stack size
          love.graphics.setColor({255,255,255})
          love.graphics.print(self.stack.size(),center_position.x + 32 -9 + 8, center_position.y + 4)
        else
          self.slayers[v].draw(computed_position, do_center)
          -- Debug sprite position
          local hex = self.owning_map.pixel_to_hex({x = self.position.x, y = self.position.y})
          love.graphics.print(
           self.position.col..", "..self.position.row.."\n::"..self.idx,
           computed_position.x + self.owning_map.tilesize_x / 4,
           computed_position.y + self.owning_map.tilesize_y / 4)
          --]]
        end
      end
    end
  end

  self.delocateUnit = function(unit)
    local result = self.stack.removeUnit(unit.uid)
    self.slayers.unit = self.stack.head()
    return result
  end

  self.relocateUnit = function(unit)
    self.stack.addUnit(unit)
    self.slayers.unit = self.stack.head()
  end

  self.setTerrain = function (type)
    self.terrain_type = type
    self.slayers.terrain = SpriteInstance.new({sprite = self.terrain_type})
  end

  return self
end

