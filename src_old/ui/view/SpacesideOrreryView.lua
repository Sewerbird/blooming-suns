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

  self.commandpanel = ViewComponent.new(
  {
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

  self.spacesidebutton = ViewComponent.new(
  {
    target = nil,
    description = "SPAAAACE",
    ui_rect = {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
    background_color = {200, 150, 190},
    super = self
  })

  self.blastoffbutton = ViewComponent.new(
  {
    target = nil,
    description = "TAKEOFF",
    ui_rect = {x = 125, y = 45, h = 75, w = 25, rx = 0, ry = 0},
    background_color = {230, 190, 220}
  })

  self.addComponent(self.orrery)
  self.addComponent(self.inspector)
  self.addComponent(self.commandpanel)
  self.addOCmponent(self.titlebar)
  self.addComponent(self.resourcebar)
  self.addComponent(self.minimap)
  self.addComponent(self.spacesidebutton)
  self.addComponent(self.blastoffbutton)


  return self
end
