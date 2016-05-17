--Unit
Unit = {}

Unit.new = function (init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil,
    selected = false
  }
  --reify
  if self.sprite ~= nil then
    self.sprite = SpriteInstance.new({sprite = self.sprite})
  end

  --members
  self.update = function (dt)
    self.sprite.update(dt)
  end

  self.draw = function (computed_position)
    self.sprite.position = computed_position
    self.sprite.draw()
  end

  self.select = function ()
    self.selected = not self.selected
    if self.selected then
      self.sprite.changeAnim("selected")
    else
      self.sprite.changeAnim("idle")
    end
  end

  return self
end
