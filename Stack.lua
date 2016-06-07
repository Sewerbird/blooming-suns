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

  self.addAllToStack = function (unitList)
    while unitList.length() > 0 do
      local unit = unitList.popright()
      self.units[unit.idx] = unit
      self.stack_size = self.stack_size + 1
    end
    print("STACK SIZE IS NOW " .. self.stack_size)
  end

  self.popUnit = function(unit)
    for i, v in pairs(self.units) do
      if unit.idx == i then
        local result = v
        self.units[unit.idx] = nil
        self.selection[unit.idx] = nil
        self.inactive[unit.idx] = nil
        return result
      end
    end
    return nil
  end

  self.popSelected = function()
    local result = List.new()
    for i, v in pairs(self.units) do
      print("Popping " .. i .. " -- " .. tostring(v))
      result.pushleft(v)
      self.units[i] = nil
      self.stack_size = self.stack_size - 1
    end

    return result
  end

  self.selectUnit = function(idx)
    self.selection[idx] = true
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

  self.forEach = function (func)
    for i, v in pairs(self.units) do
      func(v)
    end
  end

  return self
end
