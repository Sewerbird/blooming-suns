--PlanetsideTile
local ViewComponent = require('src/ui/ViewComponent')

local PlanetsideTile = ViewComponent:extend("ViewComponent", {
	
})

function PlanetsideTile:init(tile_spec)
	PlanetsideTile.super.init(self,tile_spec.description,tile_spec.ui_poly, {0,0,0})
end

function PlanetsideTile:onDraw()
  --DEFAULT implementation. Just fills the background over the whole ui_poly with the background color
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.ui_poly.x, self.ui_poly.y, self.ui_poly.w, self.ui_poly.h, self.ui_poly.rx, self.ui_poly.ry)
  love.graphics.setColor(255,255,255)
  love.graphics.print(self.description, self.ui_poly.x + self.ui_poly.w/2 - 30, self.ui_poly.y + self.ui_poly.h/2)
  love.graphics.reset()
end

return PlanetsideTile