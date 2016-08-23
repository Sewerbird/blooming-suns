--PlanetsideTile
local ViewComponent = require('src/ui/ViewComponent')

local PlanetsideTile = ViewComponent:extend("ViewComponent", {
	
})

function PlanetsideTile:init(tile_spec)
	PlanetsideTile.super.init(self,tile_spec.description,tile_spec.ui_rect, {0,0,0})
end

function PlanetsideTile:onDraw()
  --DEFAULT implementation. Just fills the background over the whole ui_rect with the background color
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
  love.graphics.setColor(255,255,255)
  love.graphics.print(self.description, self.ui_rect.x + self.ui_rect.w/2 - 30, self.ui_rect.y + self.ui_rect.h/2)
  love.graphics.reset()
end

return PlanetsideTile