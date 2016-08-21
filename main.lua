--[[
                         _oo0oo_
                        o8888888o
                        88" . "88
                        (| -_- |)
                        0\  =  /0
                      ___/`---'\___
                    .' \\|     |// '.
                   / \\|||  :  |||// \
                  / _||||| -:- |||||- \
                 |   | \\\  -  /// |   |
                 | \_|  ''\---/''  |_/ |
                 \  .-\__  '-'  ___/-. /
               ___'. .'  /--.--\  `. .'___
            ."" '<  `.___\_<|>_/___.' >' "".
           | | :  `- \`.;`\ _ /`;.`/ - ` : | |
           \  \ `_.   \_ __\ /__ _/   .-` /  /
       =====`-.____`.___ \_____/___.-`___.-'=====
                         `=---='


       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                 佛祖保佑         永无BUG
]]--

class = require 'src/lib/30log'
inspect = require 'src/lib/inspect'

local ViewManager = require('src/ui/ViewManager')
local MutateBus = require('src/logic/mutate/MutateBus')
local AccessBus = require('src/logic/query/AccessBus')

local View = require('src/ui/View')
local ViewComponent = require('src/ui/ViewComponent')
local PlanetsideView = require('src/ui/view/PlanetsideView')

function love.load()

  GlobalViewManager = ViewManager:new()
  GlobalMutateBus = MutateBus:new()
  GlobalAccessBus = AccessBus:new()

  --Default View
  GlobalViewManager:push(PlanetsideView:new())
end

function love.update(dt)
  --Debug mouse-to-hex output
  if not GLOBAL_PAUSE then
    GlobalViewManager:update(dt)
  end
end

function love.draw()
  if not GLOBAL_PAUSE then
    GlobalViewManager:draw()
  end
end

function love.mousepressed(x, y, button)
  GlobalViewManager:onMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
  GlobalViewManager:onMouseReleased(x,y,button)
end

function love.keypressed(key)
  GlobalViewManager:onKeyPressed(key)
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

