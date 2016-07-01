require('lib/pubsub')

MutatorBus = {}

MutatorBus.new = function (init)
  local init = init or {}
  local self = {
    history = {},
    pointer = 0,
    pubsub = PubSub.new()
  }

  self.executeOrder = function (order)
    if order.verify() == false then
      return false
    end
    self.mutate(order.mutator)
    self.pubsub.publish(order.mutator.kind,{})
    return true
  end

  self.mutate = function (mutator)
    if self.pointer ~= #self.history then
      error('Trying to mutate a rewound mutator queue: please fastforward')
    end

    table.insert(self.history, mutator)
    mutator.execute()
    self.pointer = self.pointer + 1
    self.publish(mutator)
  end

  self.rewind = function ()
    if self.pointer == 0 then
      print ('Cannot rewind last change: all mutations rewound')
      return nil
    end

    local mut = self.history[self.pointer]
    self.history[self.pointer].undo()
    self.pointer = self.pointer - 1
    self.publish(mut)
    return mut
  end

  self.replay = function ()
    if self.pointer == #self.history then
      print ('Cannot replay next change: all mutations played')
      return nil
    end
    self.pointer = self.pointer + 1
    local mut = self.history[self.pointer]
    self.history[self.pointer].execute()
    self.publish(mut)
    return mut
  end

  self.peek = function ()
    return self.history[self.pointer]
  end

  self.fastForward = function ()
    self.seekForward(function() return false end)
  end

  self.seekBack = function (condition)
    while not condition(self.history[self.pointer]) and self.pointer > 0 do
      self.rewind()
    end
  end

  self.seekForward = function (condition)
    while not condition(self.history[self.pointer]) and self.pointer < #self.history do
      self.replay()
    end
  end

  self.subscribe = function (topic, callback)
    return self.pubsub.subscribe(topic, callback)
  end
  self.publish = function (mutation)
    --TODO: Decouple this
    self.pubsub.publish("mutation", mutation)
    --GlobalViewManager.onMutation(mutation)
  end

  return self
end
