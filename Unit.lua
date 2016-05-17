--Unit
Unit = {}

Unit.new = function (init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil
  }
  --reify
  if self.sprite ~= nil then
    self.sprite = SpriteInstance.new({sprite = self.sprite})
  end

  --members
  self.update = function (dt)
  end

  self.draw = function (computed_position)
    self.sprite.position = computed_position
    self.sprite.draw()
  end

  return self
end
