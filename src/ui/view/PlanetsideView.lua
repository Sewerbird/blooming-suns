--TilemapView
local View = require('src/ui/View')
local ViewComponent = require('src/ui/ViewComponent')
local PlanetsideCamera = require('src/ui/component/PlanetsideCamera')

local PlanetsideView = View:extend("PlanetsideView", {})

function PlanetsideView:init()
    self:addComponent(
        ViewComponent:new(
            "Titlebar",
            {x = 0, y = 0, w = love.graphics.getWidth(), h = 40, z = 1},
            {90,90,90}
        ))
    self:addComponent(
        PlanetsideCamera:new(
            "Camera",
            {x = 0, y = 40, w = love.graphics.getWidth(), h = love.graphics.getHeight()-100-40, z = 0},
            {100,100,100}
        ))
    self:addComponent(
        ViewComponent:new(
            "Minimap",
            {x = 0, y = love.graphics.getHeight()-150, w = 300, h = 150, z = 1},
            {125,125,125}
        ))
    self:addComponent(
        ViewComponent:new(
            "Inspector",
            {x = 300, y = love.graphics.getHeight()-100, w = love.graphics.getWidth()-300-300, h = 100, z = 1},
            {90,90,90}
        ))
    self:addComponent(
        ViewComponent:new(
            "Commands",
            {x = love.graphics.getWidth()-300, y = love.graphics.getHeight()-150, w = 300, h = 150, z = 1},
            {80,80,80}
        ))
end

return PlanetsideView
