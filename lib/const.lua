--const.lua

-- converts a mutable object to an immutable one (as a proxy)
function const(obj)
  local mt = {}
  function mt.__index(proxy,k)
    local v = obj[k]
    if type(v) == 'table' then
      v = const(v)
    end
    return v
  end
  function mt.__newindex(proxy,k,v)
    error("object is constant", 2)
  end
  local tc = setmetatable({}, mt)
  return tc
end
