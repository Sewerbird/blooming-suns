--SpriteBank
SpriteBank = {}

SpriteBank.new = function (init)
  local init = init or {}
  local self = {
    sprites = init.sprites or {},
    spritesheets = init.spritesheets or {}
  }

  self.loadSpritesheet  = function (identifier, filepath, sheet_width, sheet_height)
    self.spritesheets[identifier] = {
      img = love.graphics.newImage(filepath),
      width = sheet_width,
      height = sheet_height
    }
  end

  self.loadSprite = function (identifier, lua_spec)
    local me = require(lua_spec)
    local my_ss = me.spritesheet

    self.sprites[identifier] = me
    --Set sprite spritesheet to a reference instead of identifier
    self.sprites[identifier].spritesheet = self.spritesheets[my_ss]
    local tilesetW = self.spritesheets[my_ss].width
    local tilesetH = self.spritesheets[my_ss].height
    local scale_x = me.scale_x
    local scale_y = me.scale_y

    --Set sprite speed
    self.sprites[identifier].frame_duration = 0.5
    self.sprites[identifier].anim_spec = deepcopy(me.animations)

    --Set sprite animations to quad references
    for k, v in pairs(self.sprites[identifier].animations) do
      for i, s in ipairs(self.sprites[identifier].animations[k]) do
        self.sprites[identifier].animations[k][i] = love.graphics.newQuad(s[1], s[2], s[3], s[4], tilesetW, tilesetH)
      end
    end
  end

  self.loadAll = function ()
    --TODO: Load Definitions From File

    --Load Spritesheets First
    self.loadSpritesheet("units", "assets/tilesets/units.png", 144, 120)

    self.loadSpritesheet("oceantile", "assets/tilesets/oceantile.png", 168, 146)
    self.loadSpritesheet("dunetile", "assets/tilesets/dunetile.png", 168, 146)
    self.loadSpritesheet("grasstile", "assets/tilesets/grasstile.png", 168, 146)
    self.loadSpritesheet("icetile", "assets/tilesets/icetile.png", 168, 146)
    self.loadSpritesheet("tundratile", "assets/tilesets/tundratile.png", 168, 146)
    self.loadSpritesheet("steppetile", "assets/tilesets/steppetile.png", 168, 146)

    self.loadSpritesheet("command_ui", "assets/tilesets/command_ui.png", 280, 128)
    self.loadSpritesheet("space_ui", "assets/tilesets/space_UI.png", 74, 174)

    self.loadSpritesheet("command_overlay", "assets/tilesets/command_overlay.png",600,400)
    --Load Sprites Next
    self.loadSprite("TestUnit", "assets/sprites/TestUnitSprite")
    self.loadSprite("TestSpaceUnit", "assets/sprites/TestSpaceUnitSprite")
    self.loadSprite("TestSeaUnit", "assets/sprites/TestSeaUnitSprite")
    self.loadSprite("TestSeaTransport", "assets/sprites/TestSeaTransportSprite")
    self.loadSprite("TestSpaceTransport", "assets/sprites/TestSpaceTransportSprite")
    self.loadSprite("TestSpyUnit", "assets/sprites/TestSpyUnitSprite")
    self.loadSprite("TestAirUnit", "assets/sprites/TestAirUnitSprite")
    self.loadSprite("TestAirTransport", "assets/sprites/TestAirTransportSprite")
    self.loadSprite("TestBuildUnit", "assets/sprites/TestBuildUnitSprite")

    self.loadSprite("Ocean", "assets/sprites/OceanTileSprite")
    self.loadSprite("Desert", "assets/sprites/DuneTileSprite")
    self.loadSprite("Grass", "assets/sprites/GrassTileSprite")
    self.loadSprite("Ice", "assets/sprites/IceTileSprite")
    self.loadSprite("Tundra", "assets/sprites/TundraTileSprite")
    self.loadSprite("Steppe", "assets/sprites/SteppeTileSprite")
    self.loadSprite("EndTurn_UI", "assets/sprites/EndTurn_UI")
    self.loadSprite("NextUnit_UI", "assets/sprites/NextUnit_UI")
    self.loadSprite("ToWaypoint_UI", "assets/sprites/ToWaypoint_UI")
    self.loadSprite("ToSpace_UI", "assets/sprites/ToSpace_UI")
    self.loadSprite("MoveDot_UI", "assets/sprites/MoveDotSprite_UI")
    self.loadSprite("MoveAttack_UI", "assets/sprites/MoveAttackSprite_UI")
  end

  return self
end
