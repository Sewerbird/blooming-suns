--Unit
Unit = {}
IDX_CNTR = 0
UUID_CNTR = 0

Unit.new = function (init)
  local init = init or {}
  local self = {
    uid = UUID_CNTR,
    sprite = init.sprite or nil,
    location = init.location or nil,
    orders = init.order_queue or OrderQueue.new(),
    move_queue = nil,
    move_domain = init.move_domain or 'land',
    move_method = init.move_method or 'walk',
    owner = init.owner or 'Hazat',
    backColor = init.backColor or {200,50,50},
    idx = init.idx or IDX_CNTR + 1,
    health = 100 - math.floor(math.random() * 50),
    curr_movepoints = 50,
    max_movepoints = 50
  }
  UUID_CNTR = UUID_CNTR + 1
  IDX_CNTR = IDX_CNTR + 1
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
      self.sprite.position.x = self.sprite.position.x - 24 --TODO: offset by sprite size
      self.sprite.position.y = self.sprite.position.y - 20 --TODO: offset by sprite size
    end
    --Draw backing
    love.graphics.setColor(50,50,50)
    love.graphics.rectangle("fill",self.sprite.position.x-2 + 8, self.sprite.position.y-2 + 4,36,36)
    love.graphics.setColor(self.backColor)
    love.graphics.rectangle("fill",self.sprite.position.x + 8, self.sprite.position.y + 4,32,32)
    love.graphics.reset()
    --Draw Sprite
    self.sprite.draw()
    --Draw health bar
    love.graphics.setColor({0,255,125})
    love.graphics.rectangle("fill",self.sprite.position.x + 8, self.sprite.position.y + 32 - 2 + 4, 32 * (self.health / 100), 2)
    love.graphics.reset()
  end

  self.setAnim = function(anim_name)
    self.sprite.changeAnim(anim_name)
  end
  
  return self
end
