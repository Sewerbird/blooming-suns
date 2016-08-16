--SpacesideOrreryCameraComponent
SpacesideOrreryCameraComponent = {}

SpacesideOrreryCameraComponent.new = function (init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect,
    position = init.position,
    extent = init.extent,
    target = init.target,
    super = init.super,
    dragLocus = init.dragLocus,
    lastClick = init.lastClick,
    keyboard_speed = 800
  }

  self.getSeen = function ()
    local seen = {
      planets = {},
      units = {},
      scalefactor = 10,
      time = 0
    }

    seen.time = self.target.time
    seen.scalefactor = self.target.scalefactor
    seen.planets = self.target.planets

    return seen
  end

  self.getSeenAt = function (x, y)
    local world_space_position = {
      x = (x - self.extent.half_width) + self.position.x,
      y = (y - self.extent.half_height) + self.position.y
    }
    return nil;
  end

  self.onMousePressed = function (x, y, button)
    --Camera Pan
    self.dragLocus = {x = x, y = y, camx = self.position.x, camy = self.position.y}
    self.lastClick = os.time()
  end

  self.onMouseReleased = function (x, y)
    --Camera Pan
    self.dragLocus = nil
    --Click done
    local now = os.time()
    if self.lastClick ~= nil and now - self.lastClick < 0.2 then self.doClick(x, y, button) end
    lastClick = nil
    now = nil
  end

  self.onMouseMoved = function (x, y)
    --Mouse Pan
    if self.dragLocus ~= nil then
      self.position.x = self.dragLocus.camx + (self.dragLocus.x - x)
      self.position.y = self.dragLocus.camy + (self.dragLocus.y - y)
      moved = true
    end
  end

  self.onDraw = function()
    local toDraw = self.getSeen()
    for i = 1, #self.target.planets do
      if self.target.planets[i] ~= nil then
        local zoomfactor = 0.25
        local computedPosition = {
          x = zoomfactor * self.target.planets[i].position.w_x - self.position.x + self.extent.half_width + self.ui_rect.x,
          y = zoomfactor * self.target.planets[i].position.w_y - self.position.y + self.extent.half_height + self.ui_rect.y
        }
        love.graphics.setColor({255,0,0})
        local a = zoomfactor * self.target.planets[i].position.a;
        local sunPosition = {
          x = -self.position.x + self.extent.half_width + self.ui_rect.x,
          y = -self.position.y + self.extent.half_height + self.ui_rect.y
        }
        love.graphics.circle("line", sunPosition.x, sunPosition.y, a, a)
        love.graphics.print(self.target.planets[i].name, computedPosition.x, computedPosition.y)
        love.graphics.setColor({125,255,200})
        love.graphics.circle("fill", computedPosition.x, computedPosition.y, 5, 5)
        --toDraw.planets[i].draw(computedPosition)
      end
    end
  end

  self.onUpdate = function (dt)
    local moved = false
    --Update tiles & units (for animation)
    local seen = self.getSeen()
    self.target.time = self.target.time + dt/10000000
    for i = 1, table.getn(self.target.planets) do
      --seen.planets[i].update(dt)
      self.rotatePlanet(self.target.planets[i])
    end
    for i = 1, table.getn(seen.units) do
      seen.units[i].update(dt)
    end

    --Keyboard Pan
    if love.keyboard.isDown('w','a','s','d') then
      if love.keyboard.isDown('w') then
        self.position.y = self.position.y - (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('a') then
        self.position.x = self.position.x - (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('s') then
        self.position.y = self.position.y + (dt * self.keyboard_speed)
      end
      if love.keyboard.isDown('d') then
        self.position.x = self.position.x + (dt * self.keyboard_speed)
      end
      moved = true
    end
    --bounds check
    if moved then
      --TODO: constrain
      self.position.y = math.floor(self.position.y)
      self.position.x = math.floor(self.position.x)
    end
  end

  self.doClick = function (x, y, button)
  end

  self.focus = function ()
  end

  --Logic

  self.rotatePlanet = function (planet)
    --This will model all planets with zero eccentricity, but let us shift Pluto/Haumea/Makemake/Eris a bit to keep them kind of looking kind of okay
    local a = 250 * math.log(planet.dist_AU * 3)
    local mu = 1.32712440018 * math.pow(10,20) --gravitational parameter of sol (GM)
    local T = 2 * math.pi * math.sqrt(math.pow(a,3)/mu)
    planet.position.w_x = a * math.cos(2 * math.pi * (self.target.time) / T)
    planet.position.w_y = a * math.sin(2 * math.pi * (self.target.time) / T)
    planet.position.a = a
    if planet.name == "Sol" then
      planet.position.w_x = 0
      planet.position.w_y = 0
    end
  end

  return self
end
