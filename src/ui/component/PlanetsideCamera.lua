--PlanetsideCamera
local ViewComponent = require('src/ui/ViewComponent')
local PlanetsideTile = require('src/ui/component/PlanetsideTile')

local PlanetsideCamera = ViewComponent:extend("PlanetsideCamera", {
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
		self:addComponent(ViewComponent:new())
	end
end

return PlanetsideCamera