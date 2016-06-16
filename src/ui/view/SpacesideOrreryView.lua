--SpacesideOrreryView
SpacesideOrreryView = {}

SpacesideOrreryView.new = function(init)
  local init = init or {}
  local self = View.new(init)

  self.orrery = SpacesideOrreryCameraComponent.new(
  {
    target = self.model,
    ui_rect = {x = 150, y = 20, w = self.ui_rect.w - 150, h = self.ui_rect.h - 50 - 20},
    position = {x = 0, y = self.ui_rect.h / 2},
    extent = {half_width = self.ui_rect.w/2, half_height = self.ui_rect.h/2},
    super = self
  })

  self.inspector = ViewComponent.new(
    {
      target = nil,
      description = "Inspector DONE",
      ui_rect = {x = 0, y = 20 + 100, w = 150, h = self.ui_rect.h - 100 - 20 - 50, rx = 0, ry = 0},
      background_color = {100, 80, 120},
      super = self
    })

  self.commandpanel = ViewComponent.new({
      target = nil,
      description = "Commands",
      ui_rect = {x = 0, y = self.ui_rect.h - 50, w = 150, h = 50, rx = 0, ry = 0},
      background_color = {50, 10, 70},
      super = self
    })

  self.titlebar = ViewComponent.new(
    {
      target = nil,
      description = "Titlebar",
      ui_rect = {x = 0, y = 0, w = self.ui_rect.w, h = 20, rx = 0, ry = 0},
      background_color = {110, 90, 140},
      super = self
    })

  self.resourcebar = ViewComponent.new(
    {
      target = nil,
      description = "Resourcebar",
      ui_rect = {x = 150, y = self.ui_rect.h - 50, w = self.ui_rect.w - 150, h = 50},
      background_color = {110, 90, 140},
      super = self
    })

  self.minimap = ViewComponent.new(
    {
      target = self.model,
      tracked_camera = self.orrery,
      description = "Minimap",
      ui_rect = {x = 0, y = 20, w = 125, h = 100, rx = 0, ry = 0},
      background_color = {140, 110, 170},
      super = self
    })

  self.spacesidebutton = ViewComponent.new({
      target = nil,
      description = "SPAAAACE",
      ui_rect = {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
      background_color = {200, 150, 190},
      super = self
    })

  self.blastoffbutton = ViewComponent.new({
      target = nil,
      description = "TAKEOFF",
      ui_rect = {x = 125, y = 45, h = 75, w = 25, rx = 0, ry = 0},
      background_color = {230, 190, 220}
    })

  self.components = {
    self.orrery,
    self.inspector,
    self.commandpanel,
    self.titlebar,
    self.resourcebar,
    self.minimap,
    self.spacesidebutton,
    self.blastoffbutton
  }

  --Events
  self.update = function (dt)
    self.orrery.onUpdate(dt)
  end

  self.onMousePressed = function (x, y, button)
    for i, component in ipairs(self.components) do
      if (component.ui_rect.x < x and
        component.ui_rect.x + component.ui_rect.w > x and
        component.ui_rect.y < y and
        component.ui_rect.y + component.ui_rect.h > y) then
        component.onMousePressed(x - component.ui_rect.x, y - component.ui_rect.y, button)
      end
    end
  end

  self.onMouseReleased = function (x, y, button)
    for i, component in ipairs(self.components) do
      if (component.ui_rect.x < x and
        component.ui_rect.x + component.ui_rect.w > x and
        component.ui_rect.y < y and
        component.ui_rect.y + component.ui_rect.h > y) then
        component.onMouseReleased(x - component.ui_rect.x, y - component.ui_rect.y, button)
      end
    end
  end

  self.onMouseMoved = function (x, y)
    self.orrery.onMouseMoved(x - self.orrery.ui_rect.x, y - self.orrery.ui_rect.y)
    --self.inspector.onMouseMoved(x - self.inspector.ui_rect.x, y - self.inspector.ui_rect.y,button)
  end

  self.onKeyPressed = function (key)

  end

  self.draw = function ()
    --Note: Camera is drawn under the other UI elements since it tends to draw outside its boundaries on the edges
    self.orrery.onDraw()
    --UI Interface Elements
    self.inspector.onDraw()
    self.minimap.onDraw()
    self.titlebar.onDraw()
    self.resourcebar.onDraw()
    self.spacesidebutton.onDraw()
    self.blastoffbutton.onDraw()
    self.commandpanel.onDraw()
  end

  return self
end
