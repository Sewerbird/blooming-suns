-- PlanetsideTilemapTileOverviewComponent
PlanetsideTilemapInspectorComponent = {}

PlanetsideTilemapInspectorComponent.new = function (init)
  local init = init or {}
  local self = {
    target = init.target or nil,
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
    local lclSprite = SpriteInstance.new({sprite = self.target.units[1].sprite, sprite_ref = self.target.units[1].sprite.sprite_ref})
    lclSprite.position = self.ui_rect
    lclSprite.draw()
  end

  self.inspect = function (target)
    self.target = target
  end

  self.uninspect = function ()
    self.target = nil
  end

  return self
end
