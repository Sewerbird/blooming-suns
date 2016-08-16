local PubSub = require('src/lib/PubSub')

--MutateBus
local MutateBus = class("MutateBus", {
  history = {},
  pointer = 0,
  writeable = {},
  pubsub = PubSub:new()
})

function MutateBus:executeOrder(order)
  if order:verify() == false then
    return false
  end
  self:mutate(order.mutator)
  return true
end

function MutateBus:mutate(mutator)
  if self.pointer ~= #self.history then
    error('Trying to mutate a rewound mutator queue: please fastforward')
  end

  table.insert(self.history, mutator)
  mutator:execute(writeable_state)
  self.pointer = self.pointer + 1
end

function MutateBus:rewind()
  if self.pointer == 0 then
    print('Cannot rewind last change: all mutations rewound')
    return nil
  end

  local mut = self.history[self.pointer]
  self.history[self.pointer].undo(self.writeable)
  self.pointer = self.pointer -1 
  return mut 
end


function MutateBus:replay()
  if self.pointer == #self.history then
    print ('Cannot replay next change: all mutations played')
    return nil
  end
  self.pointer = self.pointer + 1
  local mut = self.history[self.pointer]
  self.history[self.pointer]:execute(self.writeable)
  return mut
end

function MutateBus:peek()
  return self.history[self.pointer]
end

function MutateBus:fastForward()
  self:seekForward(function() return false end)
end

function MutateBus:seekBack(condition)
  while not condition(self.history[self.pointer]) and self.pointer > 0 do
    self:rewind()
  end
end

function MutateBus:seekForward(condition)
  while not condition(self.history[self.pointer]) and self.pointer < #self.history do
    self:replay()
  end
end

function MutateBus:subscribe(topic, callback)
    return self.pubsub:subscribe(topic, callback)
end

return MutateBus
