--ConfirmationView

ConfirmationView = {}

ConfirmationView.new = function(init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil,
    ui_rect = init.ui_rect or self.ui_rect,
    prompt_text = init.prompt_text or "Are you sure?"
    confirm_callback = init.confirm_callback or nil
    cancel_callback = init.cancel_callback or nil
  }

  self.prompt_label = LabelComponent.new({
    text = self.prompt_text,
    ui_rect = self.ui_rect
  })
  self.panel = PanelComponent.new({
    ui_rect = self.ui_rect
  })
  self.confirm_button = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite="EndTurn_UI"}),
    ui_rect = self.ui_rect,
    callback = self.confirm_callback
  })
  self.cancel_button = ImmediateButtonComponent.new({
    sprite = SpriteInstance.new({sprite="EndTurn_UI"}),
    ui_rect = self.ui_rect,
    callback = self.cancel_callback
  })

  self.buttons = {self.confirm_button, self.cancel_button}

  self.draw = function ()
    self.panel.draw()
    self.prompt_label.draw()
    self.confirm_button.draw()
    self.cancel_button.draw()
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
