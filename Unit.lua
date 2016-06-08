require('lib/data_structures')
--Unit
Unit = {}
IDX_CNTR = 0
Unit.new = function (init)
  local init = init or {}
  local self = {
    sprite = init.sprite or nil,
    location = init.location or nil,
    selected = false,
    move_queue = nil,
    move_domain = init.move_domain or 'land',
    owner = 'Hazat',
    backColor = {200,50,50},
    idx = init.idx or IDX_CNTR + 1,
    health = 100 - math.floor(math.random() * 50)
  }
  IDX_CNTR = IDX_CNTR + 1
  --reify
  if self.sprite ~= nil then
    self.sprite = SpriteInstance.new({sprite = self.sprite})
  end

  self.hasMoveOrder = function ()
    return self.move_queue ~= nil and self.move_queue.length() > 0
  end

  self.performMoveOrder = function ()
    local tgt = self.move_queue.popleft()
    self.location = tgt
  end

  self.setMoveQueue = function (path)
    self.move_queue = List.new()
    self.appendMoveQueue(path)
  end

  self.appendMoveQueue = function (path)
    for i, j in ipairs(path.nodes) do
      self.move_queue.pushright(j.location)
    end
  end

  self.clearMoveQueue = function ()
    self.move_queue = nil
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
    --Draw backing
    love.graphics.setColor(50,50,50)
    love.graphics.rectangle("fill",self.sprite.position.x-2, self.sprite.position.y-2,36,36)
    love.graphics.setColor(self.backColor)
    love.graphics.rectangle("fill",self.sprite.position.x, self.sprite.position.y,32,32)
    love.graphics.reset()
    --Draw Sprite
    self.sprite.draw()
    --Draw health bar
    love.graphics.setColor({0,255,125})
    love.graphics.rectangle("fill",self.sprite.position.x, self.sprite.position.y + 32 - 2, 32 * (self.health / 100), 2)
    love.graphics.reset()
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
