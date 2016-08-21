--PlanetsideCamera
local ViewComponent = require('src/ui/ViewComponent')

local PlanetsideCamera = View:extend("ViewComponent", {
	planet = nil
})

function PlanetsideCamera:init(desc, rect, color, planet)
	PlanetsideCamera.super.init(desc, rect, color)
	self.planet = planet
end

function PlanetsideCamera:getClickedTile()
end

function PlanetsideCamera:onMousePressed(x, y, button)
  --Components can respond to mouse presses over themselves
  local tgt = self:getClickedTile(x,y)
  if tgt ~= nil and tgt.onMousePressed ~= nil then tgt:onMousePressed(x, y, button) end
end

function PlanetsideCamera:onMouseReleased(x, y)
  --Components can respond to mouse releases over themselves
  local tgt = self:getClickedTile(x,y)
  if tgt ~= nil and tgt.onMouseReleased ~= nil then tgt:onMouseReleased(x, y, button) end
end

function PlanetsideCamera:onMouseMoved(x, y, button)
  --Components can respond to mouse motions over themselves
  local tgt = self:getClickedTile(x,y)
  if tgt ~= nil and tgt.onMouseMoved ~= nil then tgt:onMouseMoved(x, y, button) end
end

return PlanetsideCamera