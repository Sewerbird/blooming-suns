require('Tile');
require('Tilemap');
require('TilemapCamera');
require('SpriteBank');
require('Sprite');
require('SpriteInstance');
require('Populator');
inspect = require('lib/inspect');


function love.load()

  --Initialize
  local WINDOW_WIDTH = 800
  local WINDOW_HEIGHT = 600
  love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT , {fullscreen = false})

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
      position = {x = WINDOW_WIDTH / 2, y = WINDOW_HEIGHT / 2},
      extent = {half_width = WINDOW_WIDTH / 2, half_height = WINDOW_HEIGHT / 2}
    })
end

function love.update(dt)
  TilemapCamera:onUpdate(dt)
end

function love.draw()
  local cam = TilemapCamera
  local toDraw = cam:getSeen()
  for i = 0, table.getn(toDraw) do
    local computedPosition = {
      x = toDraw[i].position.x - cam.position.x + cam.extent.half_width,
      y = toDraw[i].position.y - cam.position.y + cam.extent.half_height
    }
    toDraw[i]:draw(computedPosition)
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
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
