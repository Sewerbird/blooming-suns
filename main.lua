require('Tile');
require('Tilemap');
require('TilemapCamera');
require('SpriteBank');
require('Sprite');
require('SpriteInstance');
require('Populator');
require('Unit');

inspect = require('lib/inspect');

function love.conf(t) 
  t.title = 'Sovereign of the Blooming Suns'
  t.window.width = 800
  t.window.height = 600
  t.fullscreen = false
end

function love.load()

  --Load Tileset Sprites
  --TODO: Make hexagonal tilesets
  GlobalSpriteBank = SpriteBank:new()
  GlobalSpriteBank:loadAll()

  --Setup Tilemap View
  viewedTilemap = Tilemap:new()
  populator = Populator:new()

  populator:generateTileMapTerrainRandom(viewedTilemap)

  TilemapCamera = TilemapCamera:new(
    {
      target = viewedTilemap,
      position = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2},
      extent = {half_width = love.graphics.getWidth() / 2, half_height = love.graphics.getHeight() / 2}
    })
end

function love.update(dt)
  if not GLOBAL_PAUSE then
    TilemapCamera:onUpdate(dt)
  end
end

function love.draw()
  local cam = TilemapCamera
  local toDraw = cam:getSeen()
  for i = 0, table.getn(toDraw.tiles) do
    local computedPosition = {
      x = toDraw.tiles[i].position.x - cam.position.x + cam.extent.half_width,
      y = toDraw.tiles[i].position.y - cam.position.y + cam.extent.half_height
    }
    toDraw.tiles[i]:draw(computedPosition)
  end
end

function love.mousepressed(x, y, button)
  TilemapCamera:onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  TilemapCamera:onMouseReleased(x,y,button)
end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
    GLOBAL_PAUSE = true
  else
    print("GAINED FOCUS")
    GLOBAL_PAUSE = false
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
