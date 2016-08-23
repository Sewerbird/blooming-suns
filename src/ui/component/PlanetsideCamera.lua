--PlanetsideCamera
local ViewComponent = require('src/ui/ViewComponent')
local PlanetsideTile = require('src/ui/component/PlanetsideTile')

local PlanetsideCamera = ViewComponent:extend("ViewComponent", {
	planet = nil
})

function PlanetsideCamera:init(desc, rect, color, planet)
	self.super.init(self, desc, rect, color)
	self.planet = planet
	self:loadPlanetTiles()
end

function PlanetsideCamera:loadPlanetTiles()
	--TODO: load tiles from query
	for i = 1 , 10 do
		self:addComponent(PlanetsideTile:new({
			description = "Tile " .. i,
			ui_rect = {x = (i-1)*115, y = 100 + (i*25), w = 100, h = 100, z = 1}
		}))
	end
end

return PlanetsideCamera