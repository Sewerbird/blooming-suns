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

  self.draw = function (computed_position, centered)
    self.sprite.position = computed_position
    if centered == true then
      self.sprite.position.x = self.sprite.position.x - 16 --TODO: offset by sprite size
      self.sprite.position.y = self.sprite.position.y - 16 --TODO: offset by sprite size
    end
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
