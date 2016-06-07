List = {}

List.new = function(init)
  local init = init or {}
  local self = {
    first = 0,
    last = -1
  }

  self.pushleft = function(value)
    local first = self.first - 1
    self.first = first
    self[first] = value
  end

  self.pushright = function (value)
    local last = self.last + 1
    self.last = last
    self[last] = value
  end

  self.popleft = function ()
    local first = self.first
    if first > self.last then error("list is empty") end
    local value = self[first]
    self[first] = nil        -- to allow garbage collection
    self.first = first + 1
    return value
  end

  self.popright = function ()
    local last = self.last
    if self.first > last then error("list is empty") end
    local value = self[last]
    self[last] = nil         -- to allow garbage collection
    self.last = last - 1
    return value
  end

  self.length = function ()
    return self.last - self.first + 1
  end

  self.head = function ()
    return self[self.first]
  end

  self.tail = function ()
    return self[self.last]
  end

  return self;
end
