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

  self.addComponent(self.camera)
  self.addComponent(self.inspector)
  self.addComponent(self.minimap)
  self.addComponent(self.titlebar)
  self.addComponent(self.resourcebar)
  self.addComponent(self.spacesidebutton)
  self.addComponent(self.blastoffbutton)
  self.addComponent(self.commandpanel)

  --Events
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
  self.promptEndTurn = function()
    local nxt_turn = function ()
      GlobalViewManager.pop()
      GlobalMutatorBus.mutate(EndTurnMutator.new())
    end
    GlobalViewManager.push(ConfirmationView.new({
      prompt_text = "End Your Turn?",
      confirm_callback = nxt_turn,
      cancel_callback = GlobalViewManager.pop
    }))
  end
  self.goToNext = function()
    local curr_idx = (self.current_focus ~= nil and self.current_focus.idx) or 0
    for i = curr_idx+1, #self.model.tiles do
      local check_hex = self.model.getHexAtIdx(i)
      if check_hex.getStack().getOwner() == GlobalGameState.current_player then
        self.unfocus()
        self.focus(check_hex)
        break
      end
    end
  end

  self.toNextWaypoint = function()
    local wasAbleToMove = true

    while wasAbleToMove do
      if self.current_focus ~= nil and self.current_focus.getStack().getOwner() == GlobalGameState.current_player and self.current_focus.getStack().hasSelection() then
        wasAbleToMove = self.executeNextOrder()
      else
        wasAbleToMove = false
      end
    end
  end

  self.clickHex = function (fhex)
    print("Hex clicked" .. inspect(fhex.stack,{depth=2}))
    --[[
    if self.current_focus ~= nil and self.current_focus.getStack().size() == 0 then 
      print("bailing")
      self.unfocus() 
    end]]

    --Click on a selected hex should unselect it. If current focus tile is empty, make sure we're unfocused
    if self.current_focus ~= nil and (fhex == self.current_focus or self.current_focus.getStack().size() == 0) then
      print("unfocusing")
      self.unfocus()
    --Clicking on an adjacent hex while a selected stack with sufficient movement points against an opposing player should issue an attack command
    elseif self.current_focus ~= nil and self.current_focus.getStack().getOwner() == GlobalGameState.current_player and fhex.getStack().getOwner() ~= self.current_focus.getStack().getOwner() and fhex.getStack().getOwner() ~= nil then
      print("attacking")
      self.assignAttackOrder(self.current_focus, fhex)
    --Clicking on a hex while a selected stack is selected should issue a move command
    elseif self.current_focus ~= nil  and self.current_focus.getStack().getOwner() == GlobalGameState.current_player then
      print("moving")
      self.assignMovePath(self.current_focus, fhex)
    --Clicking on a stack, if not having selected anything else, should select the stack
    elseif self.current_focus == nil and fhex.getStack().size() > 0 then
      print("focusing")
      self.focus(fhex)
    end
  end

  self.focus = function (fhex)
    self.unfocus()
    self.current_focus = fhex
    self.inspector.inspect(self.current_focus)
    self.camera.focusOnTileByIdx(fhex.idx)
    self.camera.setOverlay(self.inspector.getOrderOverlay())
  end

  self.unfocus = function ()
    self.inspector.uninspect()
    self.camera.clearOverlay()
    self.current_focus = nil
  end

  self.assignAttackOrder = function (src_hex, destination_hex)
    local attackers = {}
    local defenders = {}

    src_hex.getStack().forEachSelected(function (unit)
      table.insert(attackers, unit.uid)
    end)

    destination_hex.getStack().forEach(function (unit)
      table.insert(defenders, unit.uid)
    end)

    local attackOrder = AttackStackOrder.new({
      src = src_hex.idx, 
      dst = destination_hex.idx, 
      attackers = attackers, 
      defenders = defenders, 
      map = 1})

    if attackOrder.verify() == true then
      GlobalMutatorBus.executeOrder(attackOrder)
    end
  end
  
  self.assignMovePath = function (src_hex, destination_hex)
    if destination_hex == nil then return end

    --TODO: Should move assignment be in a mutator?
    local start = {row = src_hex.location.row, col = src_hex.location.col, idx = src_hex.idx}
    local f_unit = src_hex.getStack().head()

    local goal = {row = destination_hex.location.row, col = destination_hex.location.col, idx = destination_hex.idx}
    local path = self.model.avoidPathfinder:findPath(start, goal, src_hex.getStack().head().move_domain)

    if path == nil then return end

    src_hex.getStack().forEach(function (unit)
      if src_hex.getStack().isUnitSelected(unit.uid) then
        unit.orders.clear()
        local lastHex = src_hex
        for i, j in ipairs(path.nodes) do
          local next_hex = self.model.getHexAtIdx(j.location.idx)
          if next_hex.getStack().size() > 0 and src_hex.getStack().getOwner() ~= next_hex.getStack().getOwner() then
            unit.orders.add(AttackStackOrder.new({
              map = self.model,
              src = src_hex,
              dst = next_hex
              }))
          else
            unit.orders.add(MoveUnitOrder.new({
              map = self.model,
              unit = unit,
              src=lastHex,
              dst=j.location
            }))
          end
          lastHex = self.model.getHexAtIdx(j.location.idx)
        end
      end
    end)

    local overlay = {}
    src_hex.getStack().headSelected().orders.forEach(function (order)
      if order.kind == 'move' then
        overlay[order.dst.idx] = {sprite = "MoveDot_UI"}
      elseif order.kind == 'attack' then
        overlay[order.dst.idx] = {sprite = "MoveAttack_UI"}
      end
    end)
    self.camera.setOverlay(overlay)
  end

  self.undoLastOrder = function()
    GlobalMutatorBus.rewind()
  end

  self.redoLastOrder = function()
    GlobalMutatorBus.replay()
  end

  self.executeNextOrder = function ()
    if self.current_focus ~= nil and self.current_focus.getStack().getOwner() == GlobalGameState.current_player then

      --Verify: all selected units asked to execute their next order must be able to do so legally, otherwise cancel
      local able = true
      self.current_focus.getStack().forEachSelected(function (unit)
        able = able and unit.orders.hasNext() and unit.orders.peek().verify()
      end)

      --Execute: If all selected units can perform their order, execute the order
      local movedTo = nil
      if able then
        self.current_focus.getStack().forEachSelected(function (unit)
          local order = unit.orders.next()
          GlobalMutatorBus.executeOrder(order)
          if unit.location == nil then print('mm..'..inspect(unit,{depth=2})) end
          movedTo = self.model.getHexAtIdx(unit.location.idx)
          movedTo.getStack().selectUnit(unit.uid)
        end)
      end

      if movedTo ~= nil then 
        self.unfocus()
        self.clickHex(movedTo)
        return true 
      end
    end
    return false
  end

  return self
end
