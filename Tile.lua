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
    for i, v in ipairs(TILE_SPRITE_ORDER) do
      if self.slayers[v] ~= nil then
        if v == "unit" then --center
          self.slayers[v].position = computed_position
          self.slayers[v].position.x = self.slayers[v].position.x + self.owning_map.tilesize_x / 2
          self.slayers[v].position.y = self.slayers[v].position.y + self.owning_map.tilesize_y / 2
          self.slayers[v].draw(computed_position, true)
        else --from tl
          self.slayers[v].position = computed_position
          self.slayers[v].draw(computed_position)
        end
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
    if self.terrain_type == "Grass" then
      self.setTerrain("Wood")
    else
      self.setTerrain("Grass")
    end

    if self.units[1] ~= nil then
      self.units[1].select()
    end
  end

  return self
end

