--ViewManager

ViewManager = {}

ViewManager.new = function (init)
  local init = init or {}
  local self = {
    activeView = init.activeView or nil
  }

  self.getActiveView = function ()
    return self.activeView
  end

  self.push = function (view)
  end

  self.pop = function (view)
  end

  self.draw = function ()
  end

  self.update = function (dt)
  end

  return self
end
