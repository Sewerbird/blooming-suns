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
      ui_rect = {x = 150, y = 20, w = self.ui_rect.w - 150, h = self.ui_rect.h - 50 - 20},
      position = {x = 0, y = self.ui_rect.h / 2},
      extent = {half_width = self.ui_rect.w/2, half_height = self.ui_rect.h/2},
      super = self
    })

  self.inspector = PlanetsideTilemapInspectorComponent.new(
    {
      target = nil,
      description = "Inspector DONE",
      ui_rect = {x = 0, y = 20 + 100, w = 150, h = self.ui_rect.h - 100 - 20 - 50, rx = 0, ry = 0},
      background_color = {100, 80, 120},
      super = self
    })

  self.commandpanel = PlanetsideTilemapCommandPanelComponent.new({
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

  self.minimap = PlanetsideMinimapComponent.new(
    {
      target = self.model,
      tracked_camera = self.camera,
      description = "Minimap",
      ui_rect = {x = 0, y = 20, w = 125, h = 100, rx = 0, ry = 0},
      background_color = {140, 110, 170},
      super = self
    })

  self.spacesidebutton =  ImmediateButtonComponent.new({
    target = nil,
    description = "SPAAAAACE",
    sprite = SpriteInstance.new({sprite = "ToSpace_UI"}),
    ui_rect = {x = 125, y = 20, h = 25, w = 25, rx = 0, ry = 0},
    super = self,
    callback = function () print("SPAAAACE") end
  })

  self.blastoffbutton = ViewComponent.new({
      target = nil,
      description = "TAKEOFF",
      ui_rect = {x = 125, y = 45, h = 75, w = 25, rx = 0, ry = 0},
      background_color = {230, 190, 220}
    })

  self.components = {
    self.camera,
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
    self.camera.onUpdate(dt)
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
    self.camera.onMouseMoved(x - self.camera.ui_rect.x, y - self.camera.ui_rect.y)
    self.inspector.onMouseMoved(x - self.inspector.ui_rect.x, y - self.inspector.ui_rect.y,button)
  end

  self.onKeyPressed = function (key)
    if key == 'space' then
      self.executeNextOrder()
    elseif key == 'z' then
      self.undoLastOrder()
    elseif key == 'x' then
      self.redoLastOrder()
    elseif key == 'i' and self.current_focus ~= nil then
      print(inspect(self.current_focus))
    end
  end

  self.onMutation = function (mut)
    for i, component in ipairs(self.components) do
      if component.onMutation ~= nil then
        component.onMutation(mut)
      end
    end
  end

  --Logic
  self.goToNext = function()
    local curr_idx = (self.current_focus ~= nil and self.current_focus.idx) or 0
    for i = curr_idx+1, #self.model.tiles do
      local check_hex = self.model.getHexAtIdx(i)
      if check_hex.stack.getOwner() == GlobalGameState.current_player then
        if self.current_focus ~= nil then
          self.focus(self.current_focus)
        end
        self.focus(check_hex)
        break
      end
    end
  end

  self.toNextWaypoint = function()
    local wasAbleToMove = true

    while wasAbleToMove do
      if self.current_focus ~= nil and self.current_focus.stack.getOwner() == GlobalGameState.current_player and self.current_focus.stack.hasSelection() then
        wasAbleToMove = self.executeNextOrder()
      else
        wasAbleToMove = false
      end
    end
  end

  self.focus = function (fhex)
    if self.current_focus ~= nil and self.current_focus == fhex then
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = nil
      self.inspector.uninspect()
    elseif self.current_focus ~= nil and self.current_focus ~= fhex and self.current_focus.stack.getOwner() == GlobalGameState.current_player then
      self.assignMovePath(fhex)
    elseif fhex.stack.size() > 0 then
      if self.current_focus ~= nil then
        self.current_focus.click()
      end
      self.current_focus = fhex
      self.current_focus.click()
      self.inspector.inspect(fhex)
      self.camera.focusOnTileByIdx(fhex.idx)
    end
  end

  self.assignMovePath = function (destination_hex)
    --TODO: Should move assignment be in a mutator?
    local start = {row = self.current_focus.position.row, col = self.current_focus.position.col, idx = self.current_focus.idx}
    local f_unit = self.current_focus.stack.head()

    local goal = {row = destination_hex.position.row, col = destination_hex.position.col, idx = destination_hex.idx}
    local path = self.model.avoidPathfinder:findPath(start, goal, self.current_focus.stack.head().move_domain)

    if path == nil then return end

    self.current_focus.stack.forEach(function (unit)
      if self.current_focus.stack.isUnitSelected(unit.uid) then
        unit.orders.clear()
        for i, j in ipairs(path.nodes) do
          unit.orders.add(MoveUnitOrder.new({map = self.model, unit = unit, src=(path.nodes[i-1] and self.model.tiles[path.nodes[i-1].location.idx]) or self.current_focus, dst=j.location}))
        end
      end
    end)

    local overlay = {}
    for i, v in ipairs(path.nodes) do
      overlay[v.lid] = {sprite="MoveDot_UI"}
    end
    self.camera.setOverlay(overlay)
  end

  self.undoLastOrder = function()
    GlobalMutatorBus.rewind()
  end

  self.redoLastOrder = function()
    GlobalMutatorBus.replay()
  end

  self.executeNextOrder = function ()
    if self.current_focus ~= nil and self.current_focus.stack.getOwner() == GlobalGameState.current_player then
      --TODO: this logic shouldn't live in the view, but in a gamestate mutator

      --TODO: think through verification process
      local verifyOrder = function (unit, order)
        if order.kind == "move" then
          local move_cost = self.model.terrain_connective_matrix[order.dst.idx]['mpcost'][unit.move_method]
          if unit.curr_movepoints < move_cost and unit.curr_movepoints < unit.max_movepoints then
              return false
          end
          --A Unit may only move into a tile owned by no one or owned by the player
          local dst_owner = self.model.tiles[order.dst.idx].stack.getOwner()
          if dst_owner ~= nil and unit.owner ~= dst_owner then
            return false
          end
        end
        return true
      end


      --Verify: all selected units asked to execute their next order must be able to do so legally, otherwise cancel
      local able = true
      self.current_focus.stack.forEachSelected(function (unit)
        able = able and unit.orders.hasNext() and verifyOrder(unit, unit.orders.peek())
      end)

      --Execute: If all selected units can perform their order, execute the order
      local movedTo = nil
      if able then
        self.current_focus.stack.forEachSelected(function (unit)
          local order = unit.orders.next()
          GlobalMutatorBus.executeOrder(order)
          movedTo = self.model.getHexAtIdx(unit.location.idx)
          movedTo.stack.selectUnit(unit.uid)
        end)
      end

      if movedTo == nil then return false end

      --Refocus if Committed
      self.current_focus.stack.clearSelection()
      self.current_focus = movedTo
      self.inspector.inspect(self.current_focus)

      return true
    end
    return false
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
