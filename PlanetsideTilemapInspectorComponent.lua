-- PlanetsideTilemapTileOverviewComponent
PlanetsideTilemapInspectorComponent = {}
local PlanetsideTilemapInspectorUnitSelectorTileComponent = {}

PlanetsideTilemapInspectorComponent.new = function (init)
  local init = init or {}
  local self = {
    target = init.target or nil,
    selector_tiles = {},
    description = "Inspector",
    ui_rect = init.ui_rect or {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
    background_color = init.background_color or {200, 150, 190},
    super = init.super or self
  }

  self.onMousePressed = function (x, y, button)
  end

  self.onMouseReleased = function (x, y)
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

    local offset = 0
    --for i = self.target.stack.first, self.target.units.last do
    local fn = function(tgt_unit)
      --local tgt_unit = self.target.units[i]
      local lclSprite = SpriteInstance.new({sprite = tgt_unit.sprite, sprite_ref = tgt_unit.sprite.sprite_ref})
      lclSprite.position = { x = self.ui_rect.x, y = self.ui_rect.y + offset}
      offset = offset + 32
      --Draw backing
      love.graphics.setColor(tgt_unit.backColor)
      love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y,32,32)
      love.graphics.reset()
      --Draw selection status
      if self.target.stack.isUnitSelected(tgt_unit.idx) then
        love.graphics.setColor({255,255,255,100})
        love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y, 32, 32)
        love.graphics.reset()
      end
      lclSprite.draw()
      --Draw inactive status
      if self.target.stack.isUnitInactive(tgt_unit.idx) then
        love.graphics.setColor({0,0,0,100})
        love.graphics.rectangle("fill",lclSprite.position.x, lclSprite.position.y, 32, 32)
        love.graphics.reset()
      end
    end

    self.target.stack.forEach(fn)
  end

  self.inspect = function (target)
    print('inspecting' .. inspect(target,{depth=2}))
    self.target = target

    local showUnitTileSelectorElements = function (unit)
      local selector_tile = PlanetsideTilemapInspectorUnitSelectorTileComponent.new()
      table.insert(self.selector_tiles, selector_tile)
    end
    self.target.stack.forEach(showUnitTileSelectorElements)
  end

  self.uninspect = function ()
    self.selector_tiles = nil
    self.target = nil
  end

  return self
end

PlanetsideTilemapInspectorUnitSelectorTileComponent.new = function(init)
  local init = init or {}
  local self = {}
  return self
end
