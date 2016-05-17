require('Tile');
require('Tilemap');
require('TilemapCamera');
require('SpriteBank');
require('Sprite');
require('SpriteInstance');
require('Populator');
require('Unit');

inspect = require('lib/inspect');


function love.load()

  --Initialize
  local WINDOW_WIDTH = 800
  local WINDOW_HEIGHT = 600
  love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT , {fullscreen = false})

  --Load Tileset Sprites
  --TODO: Make hexagonal tilesets
  GlobalSpriteBank = SpriteBank.new()
  GlobalSpriteBank.loadAll()

  --Setup Tilemap View
  viewedTilemap = Tilemap.new()
  populator = Populator.new()

  populator.generateTileMapTerrainRandom(viewedTilemap)

  ActiveCamera = TilemapCamera.new(
    {
      target = viewedTilemap,
      position = {x = WINDOW_WIDTH / 2, y = WINDOW_HEIGHT / 2},
      extent = {half_width = WINDOW_WIDTH / 2, half_height = WINDOW_HEIGHT / 2}
    })
end

function love.update(dt)
  if not GLOBAL_PAUSE then
    ActiveCamera.onUpdate(dt)
  end
end

function love.draw()
  local cam = ActiveCamera
  local toDraw = cam.getSeen()
  for i = 0, table.getn(toDraw.tiles) do
    local computedPosition = {
      x = toDraw.tiles[i].position.x - cam.position.x + cam.extent.half_width,
      y = toDraw.tiles[i].position.y - cam.position.y + cam.extent.half_height
    }
    toDraw.tiles[i].draw(computedPosition)
  end
end

function love.mousepressed(x, y, button)
  ActiveCamera.onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  ActiveCamera.onMouseReleased(x,y,button)
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
