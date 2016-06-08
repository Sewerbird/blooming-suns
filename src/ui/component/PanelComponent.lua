--PanelComponent

PanelComponent = {}

PanelComponent.new = function(init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect or self.ui_rect,
    text = init.text or ""
  }

  self.onDraw = function ()

  end

  return self
end
