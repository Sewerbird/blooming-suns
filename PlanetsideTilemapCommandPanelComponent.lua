--PlanetsideTilemapCommandPanelComponent
PlanetsideTilemapCommandPanelComponent = {}

PlanetsideTilemapCommandPanelComponent.new = function (init)
  local init = init or {}
  local self = {
    target = init.target or nil,
    description = init.description or "Commands",
    ui_rect = init.ui_rect or {x = 0, y = 0, w = 150, h = 50, rx = 0, ry = 0},
    background_color = init.background_color or {50, 10, 70},
    super = init.super or nil
  }

  self.endTurn = function ()
    GlobalGameState.nextTurn()
  end

  self.endTurnButton = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite = "EndTurn_UI"}),
    ui_rect = self.ui_rect,
    callback = self.endTurn
  })

  self.onDraw = function ()
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill",self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
    love.graphics.reset()
    self.endTurnButton.onDraw()
  end

  self.onMousePressed = function ()
  end

  self.onMouseReleased = function ()
    self.endTurn()
  end

  return self
end
