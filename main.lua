--game classes
require('src/logic/Player');
require('src/logic/Gamestate');
require('src/logic/Stack');
require('src/logic/Tile');
require('src/logic/Tilemap');
require('src/logic/Populator');
require('src/logic/Unit');

require('src/ui/component/PlanetsideTilemapCommandPanelComponent');
require('src/ui/component/PlanetsideTilemapInspectorComponent');
require('src/ui/component/PlanetsideTilemapCameraComponent');
require('src/ui/component/PlanetsideMinimapComponent');
require('src/ui/component/LabelComponent');
require('src/ui/component/PanelComponent');
require('src/ui/component/ImmediateButtonComponent');
require('src/ui/component/ViewComponent');
require('src/ui/view/ConfirmationView');
require('src/ui/view/PlanetsideTilemapView');
require('src/ui/view/AlertBoxView');
require('src/ui/view/View');
require('src/ui/ViewManager');


require('src/resource/SpriteBank');
require('src/resource/Sprite');
require('src/resource/SpriteInstance');

--libs
require('lib/astar');
require('lib/data_structures')
inspect = require('lib/inspect');
__ = require('lib/underscore');

function love.load()

  --Load Tileset Sprites
  GlobalSpriteBank = SpriteBank.new()
  GlobalSpriteBank.loadAll()

  --Load View Manager
  GlobalViewManager = ViewManager.new()

  --Create Gamestate
  GlobalGameState = Populator.new().generateGameState()

  --Create Views
  local def_view = PlanetsideTilemapView.new({
    model = GlobalGameState.getTilemap(1),
    rect = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()}
  })
  GlobalViewManager.push(def_view)
end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then
    GlobalViewManager.update(dt)
  end
end

function love.draw()
  if not GLOBAL_PAUSE then
    GlobalViewManager.draw()
  end
end

function love.mousepressed(x, y, button)
  GlobalViewManager.onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  GlobalViewManager.onMouseReleased(x,y,button)
end

function love.keypressed(key)
  GlobalViewManager.onKeyPressed(key)
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
