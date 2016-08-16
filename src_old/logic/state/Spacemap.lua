--Spacemap
Spacemap = {}

Spacemap.new = function (init)
  local init = init or {}
  local self = {
    time = 10,
    scalefactor = 150,
    planets = init.planets or {
      { name = "Sol",
        dist_mKM = 0,
        dist_logMkm = 0,
        dist_AU = 0,
        parent = nil,
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Mercury",
        dist_Mkm = 58,
        dist_logMkm = 1.76275,
        dist_AU = 0.48709224,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Venus",
        dist_Mkm = 108,
        dist_logMkm = 2.03422,
        dist_AU = 0.72326203,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Earth",
        dist_Mkm = 149,
        dist_logMkm = 2.17493,
        dist_AU = 1.00000000,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Mars",
        dist_Mkm = 228,
        dist_logMkm = 2.35782,
        dist_AU = 1.52366310,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      {
        name = "Ceres",
        dist_Mkm = 414,
        dist_AU = 2.7675,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Jupiter",
        dist_Mkm = 778,
        dist_logMkm = 2.89120,
        dist_AU = 5.20320855,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Saturn",
        dist_Mkm = 1423,
        dist_logMkm = 3.15338,
        dist_AU = 9.51604278,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Uranus",
        dist_Mkm = 2867,
        dist_logMkm = 3.45742,
        dist_AU = 19.1644385,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Neptune",
        dist_Mkm = 4488,
        dist_logMkm = 3.65209,
        dist_AU = 30.0026738,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        }--[[,
      { name = "Pluto",
        dist_Mkm = 5909,
        dist_logMkm = 3.77155,
        dist_AU = 39.5026738,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Haumea",
        dist_Mkm = 6850,
        dist_logMkm = 3.83569,
        dist_AU = 43.2180000,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
        },
      { name = "Makemake",
        dist_Mkm = 7840,
        dist_logMkm = 3.89413,
        dist_AU = 45.7150000,
        parent = "Sol",
        position = { x = 0, y = 0, w_x = 0, w_y = 0}
      }]]
    }
  }

  self.getPlanetByName = function (name)
    for i, planet in ipairs(self.planets) do
        if name == planet.name then return planet end
    end
  end

  self.getPlanetList = function()
    local result = {}
    for i, planet in ipairs(self.planets) do
        table.insert(result,planet.name)
    end
    return result
  end

  return self
end
