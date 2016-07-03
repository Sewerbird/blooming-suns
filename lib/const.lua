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

function deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end