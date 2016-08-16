--OrderQueue

OrderQueue = {}

OrderQueue.new = function (init)
  local init = init or {}
  local self = {
    queue = init.queue or {},
    target = init.target or {}
  }

  self.hasNext = function (type)
    if type == nil then
      return self.queue ~= nil and #self.queue > 0
    else
      return self.queue ~= nil and #self.queue > 0 and self.queue[1].kind == type
    end
  end

  self.length = function ()
    return #self.queue
  end

  self.add = function (order)
    table.insert(self.queue, order)
  end

  self.peek = function ()
    return self.queue[1]
  end

  self.next = function ()
    return table.remove(self.queue, 1)
  end

  self.clear = function ()
    self.queue = {}
  end

  self.forEach = function (func)
    for i, v in ipairs(self.queue) do
      func(v)
    end
  end

  self.serialize = function ()
    local result = ""
    for i, v in ipairs(self.queue) do
      result = result .. "|" .. v.serialize()
    end
    return result
  end

  return self
end
