MutatorBus = {}

MutatorBus.new = function (init)
  local init = init or {}
  local self = {
    history = {},
    pointer = 0,
    pubsub = PubSub.new()
  }

  self.executeOrder = function (order)
    self.mutate(order.mutator)
    self.pubsub.publish(order.mutator.kind,{})
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
    while self.pointer ~= #self.history do
      self.replay()
    end
  end

  self.seekBack = function (condition)
    while not condition(self.history[self.pointer]) do
      self.rewind()
    end
  end

  self.seekForward = function (condition)
    while not condition(self.history[self.pointer]) do
      self.replay()
    end
  end

  self.publish = function (mutation)
    --TODO: Decouple this
    GlobalViewManager.onMutation(mutation)
  end

  return self
end
