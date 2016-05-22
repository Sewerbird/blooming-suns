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
    idx = init.idx
  }

  self.update = function (dt)
    if self.units[1] ~= nil then
      self.units[1].update(dt)
    end
  end

  self.draw = function (computed_position)

    --center
    computed_position.x = computed_position.x - self.owning_map.tilesize_x / 2
    computed_position.y = computed_position.y - self.owning_map.tilesize_y / 2

    for i, v in ipairs(TILE_SPRITE_ORDER) do
      if self.slayers[v] ~= nil then
          self.slayers[v].position = computed_position
          local do_center = false
          if v == "unit" then
            do_center = true
            computed_position.x = computed_position.x + self.owning_map.tilesize_x / 2
            computed_position.y = computed_position.y + self.owning_map.tilesize_y / 2
          end

          self.slayers[v].draw(computed_position, do_center)
          -- Debug sprite position
          local hex = self.owning_map.pixel_to_hex({x = self.position.x, y = self.position.y})
          love.graphics.print(
           self.position.col..", "..self.position.row.."\n::"..self.idx.."\n("..hex.col..","..hex.row..")",
           computed_position.x + self.owning_map.tilesize_x / 4,
           computed_position.y + self.owning_map.tilesize_y / 4)
          -- ]]
      end
    end

  end

  self.relocateUnit = function(unit)
    table.insert(self.units, unit)
    self.slayers.unit = self.units[1]
  end

  self.setTerrain = function (type)
    self.terrain_type = type
    --self.sprites.terrain = SpriteInstance.new({sprite = self.terrain_type})
    self.slayers.terrain = SpriteInstance.new({sprite = self.terrain_type})
  end

  self.onFocus = function ()
  end

  self.click = function ()
    if self.units[1] ~= nil then
      self.units[1].select()
    end
  end

  return self
end

