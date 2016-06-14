-- PlanetsideTilemapTileOverviewComponent
PlanetsideTilemapInspectorComponent = {}
local PlanetsideTilemapInspectorUnitSelectorTileComponent = {}

PlanetsideTilemapInspectorComponent.new = function (init)
  local init = init or {}
  local self = {
    target = init.target or nil,
    selector_tiles = {},
    selector_tile_array = {rows = 8, cols = 4},
    description = "Inspector",
    ui_rect = init.ui_rect or {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
    background_color = init.background_color or {200, 150, 190},
    super = init.super or self
  }

  self.onMousePressed = function (x, y, button)
    for i, tile in ipairs(self.selector_tiles) do
      local tgt_rect = tile.ui_rect
      if tgt_rect.x < x and tgt_rect.w + tgt_rect.x > x and tgt_rect.y < y and tgt_rect.h + tgt_rect.y > y then
        tile.onMousePressed()
      end
    end
  end

  self.onMouseReleased = function (x, y)
    for i, tile in ipairs(self.selector_tiles) do
      local tgt_rect = tile.ui_rect
      if tgt_rect.x - self.ui_rect.x < x and tgt_rect.y - self.ui_rect.y < y and tgt_rect.x - self.ui_rect.x + tgt_rect.w > x and tgt_rect.y - self.ui_rect.y + tgt_rect.h > y then
        tile.onMouseReleased()
      end
    end
  end

  self.onMouseMoved = function (x,y)
  end

  self.onUpdate = function (dt)
  end

  self.onDraw = function ()

    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.description, self.ui_rect.x + 25, self.ui_rect.y + self.ui_rect.h/2)
    love.graphics.reset()

    if self.target == nil then return end

    for i, v in ipairs(self.selector_tiles) do
      v.draw()
    end
  end

  self.inspect = function (target)
    self.uninspect()
    self.target = target

    self.target.stack.forEach(function (unit)
      local selector_tile = PlanetsideTilemapInspectorUnitSelectorTileComponent.new({
        target = unit,
        ui_rect = {w = 32, h = 32},
        super = self
      })
      table.insert(self.selector_tiles, selector_tile)
    end)

    for i, tile in ipairs(self.selector_tiles) do
      if i == 1 and not self.target.stack.hasSelection() then
        self.target.stack.selectUnit(self.selector_tiles[1].target.uid)
        self.target.stack.growSelectionBasedOnMoveQueue(self.selector_tiles[1].target.uid)
      end
      local xcoord = (((i-1) % self.selector_tile_array.cols) * self.selector_tiles[i].ui_rect.w) + self.ui_rect.x
      local ycoord = (math.floor((i-1) / self.selector_tile_array.cols) * self.selector_tiles[i].ui_rect.h) + self.ui_rect.y

      self.selector_tiles[i].ui_rect.x = xcoord
      self.selector_tiles[i].ui_rect.y = ycoord
    end
  end

  self.uninspect = function ()
    self.selector_tiles = {}
    self.target = nil
  end

  return self
end

PlanetsideTilemapInspectorUnitSelectorTileComponent.new = function(init)
  local init = init or {}
  local self = {
    target = init.target or nil,
    ui_rect = init.ui_rect or nil,
    super = init.super or nil
  }

  self.draw = function()
    local tgt_unit = self.target
    local lclSprite = SpriteInstance.new({sprite = tgt_unit.sprite, sprite_ref = tgt_unit.sprite.sprite_ref})
    lclSprite.position = self.ui_rect
    --Draw backing
    love.graphics.setColor(tgt_unit.backColor)
    love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y,32,32)
    love.graphics.reset()
    --Draw selection status
    if self.super.target.stack.isUnitSelected(tgt_unit.uid) then
      love.graphics.setColor({255,255,255,100})
      love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y, 32, 32)
      love.graphics.reset()
    end
    --Draw inactive status
    if self.super.target.stack.isUnitInactive(tgt_unit.uid) then
      love.graphics.setColor({0,0,0,100})
      love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y, 32, 32)
      love.graphics.reset()
    end
    lclSprite.draw()
    --Draw health bar
    love.graphics.setColor({0,255,125})
    love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y + 32 - 2, 32 * (tgt_unit.health / 100), 2)
    love.graphics.reset()
    --Draw remaining move points
    love.graphics.setColor({255,255,255})
    love.graphics.print(tgt_unit.curr_movepoints,lclSprite.position.x + 32 -9, lclSprite.position.y)
  end

  self.onMouseReleased = function (x, y)
    local tgt_stack = self.super.target.stack
    local wants_to_set_active = false
    if love.keyboard.isDown('lshift') then
      print("LSHIFT IS DOWN")
      wants_to_set_active = true
    end
    if tgt_stack.isUnitSelected(self.target.uid) then
      tgt_stack.deselectUnit(self.target.uid)
      if wants_to_set_active then
        tgt_stack.deactivateUnit(self.target.uid)
      end
    elseif tgt_stack.isUnitInactive(self.target.uid) then
      tgt_stack.activateUnit(self.target.uid)
    else
      if wants_to_set_active then
        tgt_stack.deactivateUnit(self.target.uid)
      else
        tgt_stack.selectUnit(self.target.uid)
      end
    end
  end
  return self
end
