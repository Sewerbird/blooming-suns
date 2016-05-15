--SpriteInstance

SpriteInstance = {
  sprite_ref = nil,
  curr_anim = "idle",
  curr_frame = 1,
  position = nil
}

function SpriteInstance:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.sprite_ref = GlobalSpriteBank.sprites[o.sprite]
  return o
end

function SpriteInstance:draw ()
  love.graphics.draw(
    self.sprite_ref.spritesheet.img,
    self.sprite_ref.animations[self.curr_anim][self.curr_frame],
    self.position.x,
    self.position.y
    )
end
