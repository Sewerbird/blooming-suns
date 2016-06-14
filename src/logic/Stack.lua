--Stack.lua

Stack = {}

Stack.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    selection = {},
    inactive = {},
    unit_index = {},
    selection_index = {},
    inactive_index = {},
    stack_size = 0
  }

  self.addUnit = function(unit)
    table.insert(self.units, unit)
    self.unit_index[unit.uid] = true
    self.stack_size = self.stack_size + 1
  end

  self.removeUnit = function(uid)
    for i, v in ipairs(self.units) do
      if uid == v.uid then
        local unit = table.remove(self.units, i)
        self.unit_index[uid] = nil
        self.selection_index[uid] = nil
        self.inactive_index[uid] = nil
        self.stack_size = self.stack_size - 1
        return unit
      end
    end
  end

  self.getUnit = function(uid)
    if self.unit_index[uid] == nil then
      error("No unit with uid " .. uid .. " found.\n")
      return nil
    end

    for i, v in ipairs(self.units) do
      if uid == v.uid then
        return v
      end
    end
  end

  self.selectUnit = function(uid)
    if self.isUnitSelected(uid) == false and self.getUnit(uid) ~= nil then
      table.insert(self.selection, uid)
      self.selection_index[uid] = true
      --Reorder selection to preserve order
      local n_selection = {}
      for i, v in ipairs(self.units) do
        if self.isUnitSelected(v.uid) then
          table.insert(n_selection, v.uid)
        end
      end
      self.selection = n_selection
    end
  end

  self.deselectUnit = function(uid)
    if self.isUnitSelected(uid) == false then return false end

    for i, v in ipairs(self.selection) do
      if uid == v then
        table.remove(self.selection, i)
        self.selection_index[uid] = nil
        return true
      end
    end
    return false
  end

  self.hasSelection = function()
    return #self.selection > 0
  end

  self.isUnitSelected = function(uid)
    if self.unit_index[uid] == nil then
      error("No unit with uid " .. uid .. " found." .. inspect(self.unit_index, {depth = 2}))
      return false
    end
    return self.selection_index[uid] == true
  end

  self.growSelectionBasedOnMoveQueue = function(uid)
    local cmp = self.getUnit(uid).serializeMoveQueue()
    for i, v in ipairs(self.units) do
      if v.serializeMoveQueue() == cmp then
        self.selectUnit(v.uid)
      end
    end
  end

  self.clearSelection = function()
    self.selection = {}
    self.selection_index = {}
  end

  self.deactivateUnit = function(uid)
    if self.unit_index[uid] == nil then
      error("No unit with uid " .. uid .. " found.\n");
      return nil
    end

    if self.getUnit(uid) ~= nil and self.isUnitActive(uid) then
      table.insert(self.inactive, uid)
      self.inactive_index[uid] = true
    end
  end

  self.activateUnit = function(uid)
    if self.unit_index[uid] == nil then
      error("No unit with uid " .. uid .. " found.\n");
      return nil
    end

    for i, v in ipairs(self.inactive) do
      if uid == v then
        table.remove(self.inactive, i)
        self.inactive_index[uid] = nil
        return true
      end
    end
    return false
  end


  self.isUnitInactive = function(uid)
    return self.inactive_index[uid] == true
  end

  self.isUnitActive = function(uid)
    return self.inactive_index[uid] ~= true and self.selection_index[uid] ~= true
  end

  self.head = function()
    for i, v in ipairs(self.units) do
      return v
    end
  end

  self.size = function()
    return self.stack_size
  end

  self.forEachSelected = function (func)
    local results = List.new()
    for i, uid in ipairs(self.selection) do
      results.pushright(func(self.getUnit(uid)))
    end
    return results
  end

  self.forEach = function (func)
    local results = List.new()
    for i, v in ipairs(self.units) do
      results.pushright(func(v))
    end
    return results
  end

  self.getOwner = function ()
    local owner = nil
    for i, v in pairs(self.units) do
      if owner == nil then
        owner = v.owner
      elseif owner ~= nil and v.owner ~= nil and owner ~= v.owner then
        error("Units of different players in same stack!" .. inspect(self))
      end
    end
    return owner
  end
  return self
end
