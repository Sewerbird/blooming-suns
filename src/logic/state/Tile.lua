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
    location = init.location,
    terrain_type = init.terrain_type,
    construction_type = init.construction_type,
    owning_map = init.owning_map,
    idx = init.idx
  }

  self.getStack = function ()
    return GlobalGameState.getTilemap(self.location.map).getStackAt(self.location);
  end

  self.update = function (dt)

  end

  self.draw = function (computed_position)
    --center
    computed_position.x = computed_position.x - self.owning_map.tilesize_x / 2
    computed_position.y = computed_position.y - self.owning_map.tilesize_y / 2

    for i, v in ipairs(TILE_SPRITE_ORDER) do
      if self.slayers[v] ~= nil then
        self.slayers[v].position = computed_position
        self.slayers[v].draw()
      end
    end
  end

  self.delocateUnit = function(unit)
    local result = self.getStack().removeUnit(unit)
    return result
  end

  self.relocateUnit = function(unit)
    self.getStack().addUnit(unit)
  end

  self.setTerrain = function (type)
    self.terrain_type = type
    self.slayers.terrain = SpriteInstance.new({sprite = self.terrain_type})
  end

  return self
end

