--game classes
require('src/logic/Populator');
require('src/logic/state/Gamestate');
  require('src/logic/state/Player');
  require('src/logic/state/Spacemap');
  require('src/logic/state/Tilemap');
    require('src/logic/state/Tile');
      require('src/logic/state/Stack');
        require('src/logic/state/Unit');
          require('src/logic/state/OrderQueue');
            require('src/logic/state/Order');

require('src/logic/mutate/Mutator');
require('src/logic/mutate/MutatorBus');
require('src/logic/mutate/MoveUnitMutator');
require('src/logic/order/MoveUnitOrder');

require('src/ui/view/PlanetsideTilemapView');
  require('src/ui/component/PlanetsideTilemapCommandPanelComponent');
  require('src/ui/component/PlanetsideTilemapInspectorComponent');
  require('src/ui/component/PlanetsideTilemapCameraComponent');
  require('src/ui/component/PlanetsideMinimapComponent');
require('src/ui/view/SpacesideOrreryView');
  require('src/ui/component/SpacesideOrreryCameraComponent');

require('src/ui/component/LabelComponent');
require('src/ui/component/PanelComponent');
require('src/ui/component/ImmediateButtonComponent');
require('src/ui/component/ViewComponent');

require('src/ui/view/ConfirmationView');
require('src/ui/view/AlertBoxView');
require('src/ui/view/View');
require('src/ui/ViewManager');


require('src/resource/SpriteBank');
require('src/resource/Sprite');
require('src/resource/SpriteInstance');

--libs
require('lib/astar');
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

  --Load MutatorBus
  GlobalMutatorBus = MutatorBus.new()

  --Create Views
  --
  local def_view = PlanetsideTilemapView.new({
    model = GlobalGameState.getTilemap(1),
    rect = {x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight()}
  })
  --[[
  local def_view = SpacesideOrreryView.new({
    model = GlobalGameState.getSpacemap(1)
  })
  --]]
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
