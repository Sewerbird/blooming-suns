--Unit
Unit = {
  sprite = nil
}

function Unit:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return self
end

function Unit:update (dt)
end

function Unit:setSprite (sprite_ref)
  self.sprite = SpriteInstance:new({sprite = sprite_ref})
end

function Unit:draw (computed_position)
  self.sprite.position = computed_position
  self.sprite:draw()
end
