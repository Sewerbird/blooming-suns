require('Tile');
require('Tilemap');
require('TilemapCamera');
require('Populator');
inspect = require('lib/inspect');

success = love.window.setMode( 800, 600 , {fullscreen = false})

function love.load()
   --TODO: Make hexagonal tilesets
  Tileset = love.graphics.newImage('assets/countryside.png')

  local tileW, tileH = 32,32
  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

  GrassQuad = love.graphics.newQuad(0,  0, tileW, tileH, tilesetW, tilesetH)
  BoxQuad = love.graphics.newQuad(32, 32, tileW, tileH, tilesetW, tilesetH)

  viewedTilemap = Tilemap:new()
  populator = Populator:new()

  populator:generateTileMapTerrainRandom(viewedTilemap)

  TilemapCamera = TilemapCamera:new(
    {
      target = viewedTilemap,
      position = {x = 0, y = 0},
      extent = {half_width = 400, half_height = 300}
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
    local computedQuad = nil
    if toDraw[i].terrain_type == "Grass" then
      computedQuad = GrassQuad
    elseif toDraw[i].terrain_type == "Wood" then
      computedQuad = BoxQuad
    end
    love.graphics.draw(Tileset, computedQuad, computedPosition.x, computedPosition.y)
  end
  love.graphics.setColor(255,0,255)
  love.graphics.rectangle(
    "line",
    (love.graphics.getWidth()/2) - cam.extent.half_width,
    (love.graphics.getHeight()/2) - cam.extent.half_height,
    2 * cam.extent.half_width, 2 * cam.extent.half_height);
  love.graphics.reset()
end

function love.mousepressed(x, y, button)
  TilemapCamera:onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  TilemapCamera:onMouseReleased(x,y,button)
end

function love.keypressed(k)
  TilemapCamera.position.y = TilemapCamera.position.y + 16
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
