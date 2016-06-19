Mutator = {}

Mutator.new = function (init)
  local init = init or {}
  local self = {}

  self.execute = init.execute or function ()
    error("No execute functor provided for mutator")
  end

  self.undo = init.undo or function ()
    error("No undo functor provided for mutator")
  end

  return self
end
