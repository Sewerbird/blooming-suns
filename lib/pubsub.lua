PubSub = {}

PubSub.new = function (init)
  local init = init or {}
  local self = {
    UID_CNTR = 0,
    topics = {}
  }

  self.addSubscriber = function(topic, callback)
    if self.topics[topic] == nil then
      self.topics[topic] = {}
    end
    local f = self.UID_CNTR + 1
    table.insert(self.topics[topic],{
      uid = f,
      cb = callback
    })
    return function ()
      for i, v in ipairs(self.topics[topic]) do
        if v.uid == f then
          table.remove(v)
        end
      end
    end
  end

  self.publish = function(topic, message)
    if self.topics[topic] == nil then return end

    for i, v in ipairs(self.topics[topic]) do
      v.cb(message)
    end
  end

  return self
end
