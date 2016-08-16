local PubSub = require('src/lib/PubSub')

--AccessBus
local AccessBus = class("AccessBus", {
  history = {},
  pointer = 0,
  readable = {},
  pubsub = PubSub:new()
})


function AccessBus:ask(query)
	return query:execute(self.readable)
end

function AccessBus:subscribe(topic, callback)
	return self.pubsub:subscribe(topic, callback)
end

return AccessBus