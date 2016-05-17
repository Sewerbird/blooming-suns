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

    --Set sprite speed
    self.sprites[identifier].frame_duration = 0.5

    --Set sprite animations to quad references
    for k, v in pairs(self.sprites[identifier].animations) do
      for i, s in ipairs(self.sprites[identifier].animations[k]) do
        self.sprites[identifier].animations[k][i] = love.graphics.newQuad(s[1], s[2], s[3], s[4], tilesetW, tilesetH)
      end
    end
  end

  self.loadAll = function ()
    --Load Spritesheets First
    self.loadSpritesheet("countryside", "assets/tilesets/countryside.png", 64, 64)
    self.loadSpritesheet("noble", "assets/tilesets/noble.png", 32, 32)
    --Load Sprites Next
    self.loadSprite("TestUnit", "assets/sprites/TestUnitSprite")
    self.loadSprite("Grass", "assets/sprites/GrassTileSprite")
    self.loadSprite("Wood", "assets/sprites/WoodTileSprite")
  end

  return self
end
