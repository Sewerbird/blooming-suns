--ImmediateButtonComponent

ImmediateButtonComponent = {}

ImmediateButtonComponent.new = function(init)
  local init = init or {}
  local self = {
    sprite = init.sprite or SpriteInstance.new({sprite="EndTurn_UI"}),
    ui_rect = init.ui_rect or self.ui_rect,
    callback = init.callback or nil
  }

  self.sprite.position = self.ui_rect

  self.onDraw = function ()
    self.sprite.draw()
  end

  self.onClick = self.callback

  return self
end
