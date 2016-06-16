--Spacemap
Spacemap = {}

Spacemap.new = function (init)
  local init = init or {}
  local self = {
    planets = init.planets or {
      { name = "Sol",
        dist_mKM = 0,
        dist_logMkm = 0,
        dist_AU = 0,
        parent = nil
        },
      { name = "Mercury",
        dist_Mkm = 58,
        dist_logMkm = 1.76275,
        dist_AU = 0.38709224,
        parent = "Sol"
        },
      { name = "Venus",
        dist_Mkm = 108,
        dist_logMkm = 2.03422,
        dist_AU = 0.72326203,
        parent = "Sol"
        },
      { name = "Earth",
        dist_Mkm = 149,
        dist_logMkm = 2.17493,
        dist_AU = 1.00000000,
        parent = "Sol"
        },
      { name = "Mars",
        dist_Mkm = 228,
        dist_logMkm = 2.35782,
        dist_AU = 1.52366310,
        parent = "Sol"
        },
      { name = "Jupiter",
        dist_Mkm = 778,
        dist_logMkm = 2.89120,
        dist_AU = 5.20320855,
        parent = "Sol"
        },
      { name = "Saturn",
        dist_Mkm = 1423,
        dist_logMkm = 3.15338,
        dist_AU = 9.51604278,
        parent = "Sol"
        },
      { name = "Uranus",
        dist_Mkm = 2867,
        dist_logMkm = 3.45742,
        dist_AU = 19.1644385,
        parent = "Sol"
        },
      { name = "Neptune",
        dist_Mkm = 4488,
        dist_logMkm = 3.65209,
        dist_AU = 30.0026738,
        parent = "Sol"
        },
      { name = "Pluto",
        dist_Mkm = 5909,
        dist_logMkm = 3.77155,
        dist_AU = 39.5026738,
        parent = "Sol"
        },
      { name = "Haumea",
        dist_Mkm = 6850,
        dist_logMkm = 3.83569,
        dist_AU = 43.2180000,
        parent = "Sol"
        },
      { name = "Makemake",
        dist_Mkm = 7840,
        dist_logMkm = 3.89413,
        dist_AU = 45.7150000,
        parent = "Sol"
      }
    }
  }
end
