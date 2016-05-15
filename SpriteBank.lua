--SpriteBank
SpriteBank = {
  sprites = {},
  spritesheets = {}
}

function SpriteBank:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function SpriteBank:loadAll ()
  --Load Spritesheets First
  self:loadSpritesheet("countryside", "assets/tilesets/countryside.png", 64, 64)

  --Load Sprites Next
  self:loadSprite("Grass", "assets/sprites/GrassTileSprite")
  self:loadSprite("Wood", "assets/sprites/WoodTileSprite")
end

function SpriteBank:loadSpritesheet (identifier, filepath, sheet_width, sheet_height)
  self.spritesheets[identifier] = {
    img = love.graphics.newImage(filepath),
    width = sheet_width,
    height = sheet_height
  }
end

function SpriteBank:loadSprite (identifier, lua_spec)
  local me = require(lua_spec)
  local my_ss = me.spritesheet

  self.sprites[identifier] = me
  --Set sprite spritesheet to a reference instead of identifier
  self.sprites[identifier].spritesheet = self.spritesheets[my_ss]
  local tilesetW = self.spritesheets[my_ss].width
  local tilesetH = self.spritesheets[my_ss].height

  --Set sprite animations to quad references
  for k, v in pairs(self.sprites[identifier].animations) do
    for i, s in ipairs(self.sprites[identifier].animations[k]) do
      self.sprites[identifier].animations[k][i] = love.graphics.newQuad(s[1], s[2], s[3], s[4], tilesetW, tilesetH)
    end
  end
end
