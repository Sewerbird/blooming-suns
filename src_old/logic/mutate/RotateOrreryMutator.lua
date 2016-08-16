RotateOrreryMutator = {}

RotateOrreryMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.dt = init.dt
  self.map = init.ma

  self.execute = function (state)
    state.spacemaps[self.map].time = state.spacemaps[self.map].time + self.dt
    for planet in ipairs(state.spacemaps[self.map].planets) do
      self.rotatePlanet(planet)
    end
  end

  self.undo = function (state)
    state.spacemaps[self.map].time = state.spacemaps[self.map].time - self.dt
    for planet in ipairs(state.spacemaps.getSpaceMap(self.map).planets) do
      self.rotatePlanet(state, planet)
    end
    self.dt = self.dt
  end

  self.rotatePlanet = function (state, planet)
    --This will model all planets with zero eccentricity, but let us shift Pluto/Haumea/Makemake/Eris a bit to keep them kind of looking kind of okay
    local a = 250 * math.log(planet.dist_AU * 3)
    local mu = 1.32712440018 * math.pow(10,20) --gravitational parameter of sol (GM)
    local T = 2 * math.pi * math.sqrt(math.pow(a,3)/mu)
    local time = state.spacemaps[self.map].time
    planet.position.w_x = a * math.cos(2 * math.pi * (time) / T)
    planet.position.w_y = a * math.sin(2 * math.pi * (time) / T)
    planet.position.a = a
    if planet.name == "Sol" then
      planet.position.w_x = 0
      planet.position.w_y = 0
    end
  end

  return self
end
