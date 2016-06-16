--OrderQueue

OrderQueue = {}

OrderQueue.new = function (init)
  local init = init or {}
  local self = {
    queue = init.queue or {},
    target = init.target or {}
  }

  self.hasNext = function ()
    return self.queue ~= nil and #self.queue > 0
  end

  self.length = function ()
    return #self.queue
  end

  self.add = function (order)
    table.insert(self.queue)
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

  self.serialize = function ()
    local result = ""
    for i, v in ipairs(self.queue) do
      result = result .. "|" .. v.serialize()
    end
    return result
  end

  return self
end
