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

  --Logic
  self.promptEndTurn = function ()
    GlobalGameState.nextTurn()
  end

  --Subcomponents
  self.endTurnButton = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite = "EndTurn_UI"}),
    ui_rect = self.ui_rect,
    callback = self.promptEndTurn
  })

  self.buttons = {self.endTurnButton}

  --Events
  self.onDraw = function ()
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill",self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
    love.graphics.reset()
    self.endTurnButton.onDraw()
  end

  self.onMousePressed = function (x, y, button)
  end

  self.onMouseReleased = function (x, y, button)
    x = x + self.ui_rect.x
    y = y + self.ui_rect.y
    for i, v in ipairs(self.buttons) do
      local tgt_rect = v.ui_rect
      if tgt_rect.x < x and tgt_rect.x + tgt_rect.w > x and tgt_rect.y < y and tgt_rect.y + tgt_rect.h > y then
        v.onClick(x, y, button)
        break;
      end
    end
  end

  return self
end
