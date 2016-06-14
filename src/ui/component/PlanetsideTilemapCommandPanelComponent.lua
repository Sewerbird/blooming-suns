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
    local nxt_turn = function ()
      GlobalViewManager.pop()
      GlobalGameState.nextTurn()
    end
    GlobalViewManager.push(ConfirmationView.new({
      prompt_text = "End Your Turn?",
      confirm_callback = nxt_turn,
      cancel_callback = GlobalViewManager.pop
    }))
  end

  self.focusNextUnit = function ()
    self.super.goToNext()
  end

  self.toNextWaypoint = function ()
    self.super.toNextWaypoint()
  end

  --Subcomponents
  self.endTurnButton = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite = "EndTurn_UI"}),
    ui_rect = {x = self.ui_rect.x, y = self.ui_rect.y, w = 50, h = 50},
    callback = self.promptEndTurn
  })

  self.nextUnitButton = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite = "NextUnit_UI"}),
    ui_rect = {x = self.ui_rect.x + 56, y = self.ui_rect.y, w = 25, h = 25},
    callback = self.focusNextUnit
  })

  self.toWaypointButton = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite = "ToWaypoint_UI"}),
    ui_rect = {x = self.ui_rect.x + 56, y = self.ui_rect.y + 25, w = 25, h = 25},
    callback = self.toNextWaypoint
  })

  self.buttons = {self.endTurnButton, self.nextUnitButton, self.toWaypointButton}

  --Events
  self.onDraw = function ()
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill",self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
    love.graphics.reset()
    for i, v in ipairs(self.buttons) do
      v.onDraw()
    end
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
