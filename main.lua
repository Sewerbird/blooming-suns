require('Tile');
require('Tilemap');
require('TilemapCamera');
require('TilemapView');
require('SpriteBank');
require('Sprite');
require('SpriteInstance');
require('Populator');
require('Unit');
require('ViewManager');
require('ViewComponent');
require('View');

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
  GlobalSpriteBank = SpriteBank.new()
  GlobalSpriteBank.loadAll()

  --Load View Manager
  GlobalViewManager = ViewManager.new()

  --Create Gamestate
  local defaultTilemap = Tilemap.new()
  local populator = Populator.new()
  populator.generateTileMapTerrainRandom(defaultTilemap)

  --Create Views
  local def_view = TilemapView.new({
    model = defaultTilemap,
    rect = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()}
  })
  GlobalViewManager.push(def_view)

end

function love.update(dt)
  if not GLOBAL_PAUSE then
    GlobalViewManager.update(dt)
  end
end

function love.draw()
  GlobalViewManager.draw()
end

function love.mousepressed(x, y, button)
  GlobalViewManager.onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  GlobalViewManager.onMouseReleased(x,y,button)
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
