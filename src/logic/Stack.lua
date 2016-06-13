--Stack.lua

Stack = {}

Stack.new = function(init)
  local init = init or {}
  local self = {
    units = {},
    selection = {},
    inactive = {},
    stack_size = 0
  }

  self.addAllToStack = function (unitList, isSelected)
    while unitList.length() > 0 do
      local unit = unitList.popright()
      self.units[unit.idx] = unit
      self.stack_size = self.stack_size + 1
    end
  end

  self.popUnit = function(unit)
    for i, v in pairs(self.units) do
      if unit.idx == i then
        local result = v
        self.units[unit.idx] = nil
        self.selection[unit.idx] = nil
        self.inactive[unit.idx] = nil
        self.stack_size = self.stack_size - 1
        return result
      end
    end
    return nil
  end

  self.popSelected = function()
    local result = List.new()
    for i, v in pairs(self.units) do
      result.pushleft(v)
      self.units[i] = nil
      self.stack_size = self.stack_size - 1
    end

    return result
  end

  self.hasSelection = function()
    for i, v in pairs(self.selection) do
      return true
    end
    return false
  end

  self.selectUnit = function(idx)
    self.selection[idx] = true
  end

  self.growSelectionBasedOnMoveQueue = function(idx)
    local cmp = self.units[idx].serializeMoveQueue()
    for i, v in pairs(self.units) do
      if v.serializeMoveQueue() == cmp then
        self.selectUnit(i)
      end
    end
  end

  self.deselectUnit = function(idx)
    self.selection[idx] = nil
  end

  self.deactivateUnit = function(idx)
    self.inactive[idx] = true
  end

  self.activateUnit = function(idx)
    self.inactive[idx] = nil
  end

  self.isUnitSelected = function(idx)
    return self.selection[idx] == true
  end

  self.isUnitInactive = function(idx)
    return self.inactive[idx] == true
  end

  self.isUnitActive = function(idx)
    return self.inactive[idx] ~= true and self.selection[idx] ~= true
  end

  self.head = function()
    for i, v in pairs(self.units) do
      return v
    end
  end

  self.size = function()
    return self.stack_size
  end

  self.forEachSelected = function (func)
    local results = List.new()
    for i, v in pairs(self.selection) do
      results.pushright(func(self.units[i]))
    end
    return results
  end

  self.forEach = function (func)
    local results = List.new()
    for i, v in pairs(self.units) do
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
