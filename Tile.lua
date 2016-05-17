-- Tile
Tile = {}

local TILE_SPRITE_ORDER = {"terrain_layer","fringe_layer","feature_layer","river_layer","road_layer","resource_layer","unit_layer"}

Tile.new = function (init)
  local init = init or {}
  local self = {
    --sprite layers
    terrain_layer = init.terrain_layer,
    fringe_layer = init.fringe_layer,
    feature_layer = init.feature_layer,
    river_layer = init.river_layer,
    road_layer = init.road_layer,
    resource_layer = init.resource_layer,
    unit_layer = init.unit_layer,
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
    self.terrain_layer.position = computed_position
    self.terrain_layer.draw()
    if self.unit_layer ~= nil then
      self.unit_layer.draw(computed_position)
    end
  end

  self.relocateUnit = function(unit)
    table.insert(self.units, unit)
    self.unit_layer = self.units[1]
  end

  self.setTerrain = function (type)
    self.terrain_type = type
    --self.sprites.terrain = SpriteInstance.new({sprite = self.terrain_type})
    self.terrain_layer = SpriteInstance.new({sprite = self.terrain_type})
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

