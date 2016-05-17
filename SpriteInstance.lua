--SpriteInstance
SpriteInstance = {}

SpriteInstance.new = function (init)
  local init = init or {}
  if init.sprite == nil then
    print("SPrite instance without sprite ref: " .. inspect(init))
  end
  local self = {
    sprite_ref = GlobalSpriteBank.sprites[init.sprite],
    curr_anim = init.curr_anim or "idle",
    curr_frame = init.curr_frame or 1,
    timer = init.timer or 0,
    position = init.position or nil
  }

  self.changeAnim = function (anim)
    self.curr_anim = anim
    self.curr_frame = 1
    self.timer = 0
  end

  self.update = function (dt)
    self.timer = self.timer + dt
    if self.timer > self.sprite_ref.frame_duration then
      self.timer = self.timer % self.sprite_ref.frame_duration
      self.curr_frame = self.curr_frame + 1
      if self.curr_frame > table.getn(self.sprite_ref.animations[self.curr_anim]) then
        self.curr_frame = 1
      end
    end
  end

  self.draw = function ()
    love.graphics.draw(
      self.sprite_ref.spritesheet.img,
      self.sprite_ref.animations[self.curr_anim][self.curr_frame],
      self.position.x,
      self.position.y
      )
  end

  return self
end
