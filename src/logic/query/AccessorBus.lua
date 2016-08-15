--AccessorBus.lua
require('lib/pubsub')

AccessorBus = {}

AccessorBus.new = function (init)
  local init = init or {}
  local self = {
    history = {},
    pointer = 0,
    pubsub = PubSub.new(),
    readable_gamestate = init.state
  }

  self.ask = function (query)
  	return query.execute(self.readable_gamestate)
  end

  self.subscribe = function (topic, callback)
    return self.pubsub.subscribe(topic, callback)
  end
  self.publish = function (mutation)
    self.pubsub.publish("mutation", mutation)
  end

  return self
end