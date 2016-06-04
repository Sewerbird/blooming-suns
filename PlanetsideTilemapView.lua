--TilemapView
PlanetsideTilemapView = {}

PlanetsideTilemapView.new = function (init)
  local init = init or {}
  local self = View.new(init)

  self.current_focus = nil

  --Components
  --TODO: auto-layout, load-config-from-file, or at least dynamic/% sizing
  local uicruft_alpha = 255
  self.camera = PlanetsideTilemapCameraComponent.new(
    {
      target = self.model,
      ui_rect = {x = 150, y = 20, w = self.rect.w - 150, h = self.rect.h - 50 - 20},
      position = {x = 0, y = self.rect.h / 2},
      extent = {half_width = self.rect.w/2, half_height = self.rect.h/2},
      super = self
    })

  self.inspector = PlanetsideTilemapInspectorComponent.new(
    {
      target = nil,
      description = "Inspector DONE",
      ui_rect = {x = 0, y = 20 + 100, w = 150, h = self.rect.h - 100 - 20 - 50, rx = 0, ry = 0},
      background_color = {100, 80, 120},
      super = self
    })

  self.commandpanel = ViewComponent.new({
      target = nil,
      description = "Commands",
      ui_rect = {x = 0, y = self.rect.h - 50, w = 150, h = 50, rx = 0, ry = 0},
      background_color = {50, 10, 70}
    })

  self.titlebar = ViewComponent.new(
    {
      target = nil,
      description = "Titlebar",
      ui_rect = {x = 0, y = 0, w = self.rect.w, h = 20, rx = 0, ry = 0},
      background_color = {110, 90, 140},
      super = self
    })

  self.resourcebar = ViewComponent.new(
    {
      target = nil,
      description = "Resourcebar",
      ui_rect = {x = 150, y = self.rect.h - 50, w = self.rect.w - 150, h = 50},
      background_color = {110, 90, 140},
      super = self
    })

  self.minimap = PlanetsideMinimapComponent.new(
    {
      target = self.model,
      tracked_camera = self.camera,
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

  --Events
  --TODO: emit events to all/some components, not just the camera
  self.update = function (dt)
    self.camera.onUpdate(dt)
  end

  self.onMousePressed = function (x, y, button)
    self.camera.onMousePressed(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y,button)
  end

  self.onMouseReleased = function (x, y, button)
    self.camera.onMouseReleased(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y,button)
  end

  self.onMouseMoved = function (x, y)
    local w_x = x - self.camera.ui_rect.x;
    local w_y = y - self.camera.ui_rect.y
    self.camera.onMouseMoved(w_x, w_y)
  end

  self.onKeyPressed = function (key)
    if key == 'space' then
      self.executeNextOrder()
    end
  end

  --Logic
  self.focus = function (fhex)
    --if unit == nil then return end
    if self.current_focus ~= nil and self.current_focus == fhex then
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = nil
      self.inspector.uninspect()
    elseif self.current_focus ~= nil and self.current_focus ~= fhex then
      --TODO: The unit movement logic belongs in a gamestate mutator
      local start = {row = self.current_focus.position.row, col = self.current_focus.position.col, idx = self.current_focus.idx}
      local f_unit = self.current_focus.units.head()
      local path_append = false
      if (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) and f_unit.hasMoveOrder() then
        path_append = true
        start = f_unit.move_queue.tail()
      end

      local goal = {row = fhex.position.row, col = fhex.position.col, idx = fhex.idx}

      local path = self.model.astar:findPath(start, goal, self.current_focus.units.head().move_domain)

      if path == nil then return end

      for i = self.current_focus.units.first, self.current_focus.units.last do
        --TODO: fix appending paths to movequeus in katamari-situations
        if false and path_append then
          self.current_focus.units[i].appendMoveQueue(path)
        else
          self.current_focus.units[i].setMoveQueue(path)
        end
      end

      for i, v in ipairs(self.model.tiles) do
        self.model.tiles[i].debug = false;
      end
      for i, v in ipairs(path.nodes) do
        self.model.tiles[v.lid].debug = true;
      end
    elseif fhex.units.length() > 0 then
      print('a')
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = fhex
      self.current_focus.click()
      self.inspector.inspect(fhex)
    end
  end

  self.executeNextOrder = function ()
    if self.current_focus ~= nil then
      --TODO: this logic shouldn't live in the view, but in a gamestate mutator
      for i, v in ipairs(self.model.tiles) do
        self.model.tiles[i].debug = false;
      end
      local movedTo = nil
      for j = self.current_focus.units.first, self.current_focus.units.last do
        if self.current_focus.units[j].hasMoveOrder() then
          local moving_unit = self.current_focus.units[j]
          self.current_focus.delocateUnit(moving_unit)
          moving_unit.performMoveOrder()
          movedTo = moving_unit.location.idx
          self.model.tiles[moving_unit.location.idx].relocateUnit(moving_unit)
          for i = moving_unit.move_queue.first , moving_unit.move_queue.last do
            self.model.tiles[moving_unit.move_queue[i].idx].debug = true;
          end
        end
      end
      self.current_focus = self.model.tiles[movedTo]
      self.inspector.target = self.current_focus
    end
  end

  self.draw = function ()
    --Note: Camera is drawn under the other UI elements since it tends to draw outside its boundaries on the edges
    self.camera.onDraw()
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
