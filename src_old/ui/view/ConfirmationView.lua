--ConfirmationView

ConfirmationView = {}

ConfirmationView.new = function(init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil,
    ui_rect = init.ui_rect or  {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()},
    prompt_text = init.prompt_text or "Are you sure?",
    confirm_callback = init.confirm_callback or nil,
    cancel_callback = init.cancel_callback or nil
  }

  local label_width = self.ui_rect.w/4
  local label_height = 30
  local button_width = 100
  local button_height = 30
  local button_sep = 50
  self.prompt_label = LabelComponent.new({
    text = self.prompt_text,
    ui_rect = {x = self.ui_rect.w / 2 - label_width/2, y = self.ui_rect.h / 2 - self.ui_rect.h / 8, w = label_width, h = label_height}
  })
  self.prompt_label_panel = PanelComponent.new({
    ui_rect = self.prompt_label.ui_rect,
    background_color = {30, 60, 100}
  })
  self.panel = PanelComponent.new({
    ui_rect = {x = self.ui_rect.w/4, y = self.ui_rect.h/4, w = self.ui_rect.w/2, h = self.ui_rect.h/2},
    background_color = {20, 50, 75}
  })
  self.shade = PanelComponent.new({
    ui_rect = self.ui_rect,
    background_color = {0, 0, 0, 125}
  })
  self.confirm_button = ImmediateButtonComponent.new({
    text = "Confirm",
    ui_rect = {x = self.ui_rect.w /2 - button_sep/2 - button_width, y = self.ui_rect.h/2, w = button_width, h = button_height},
    callback = self.confirm_callback,
    background_color = {255, 100, 100}
  })
  self.cancel_button = ImmediateButtonComponent.new({
    text = "Cancel",
    ui_rect = {x = self.ui_rect.w /2 + button_sep, y = self.ui_rect.h/2, w = button_width, h = button_height},
    callback = self.cancel_callback,
    background_color = {100,255,100}
  })

  self.buttons = {self.confirm_button, self.cancel_button}

  self.draw = function ()
    self.shade.onDraw()
    self.panel.onDraw()
    self.prompt_label_panel.onDraw()
    self.prompt_label.onDraw()
    self.confirm_button.onDraw()
    self.cancel_button.onDraw()
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

  self.onMousePressed = function (x, y, button) end

  self.onMouseMoved = function (x, y) end

  self.onKeyPressed = function (x, y, button) end

  self.update = function ()
  end

  return self
end
