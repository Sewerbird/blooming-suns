local Location = require('src/logic/structure/Location')

local Renderable = class("Renderable", {
	sprite_ref = nil,
	sprite_instance = nil,
	curr_anim = nil,
	curr_frame = nil,
	loc = nil
})

function Renderable:draw(screen_loc)
	if not screen_loc.isInstance(screen_loc, Location) then
		error('Renderable needs a Location to draw, but got ' .. screen_loc)
	end

	local drawAt = Location:new()
	drawAt.x = self.loc.x + screen_loc.x + self.loc.off_x
	drawAt.y = self.loc.y + screen_loc.y + self.loc.off_y


    love.graphics.draw(
      self.sprite_ref.spritesheet.img,
      self.sprite_ref.animations[self.curr_anim][self.curr_frame],
      drawAt.x,
      drawAt.y,
      0, --rotation
      self.sprite_ref.scale_x,
      self.sprite_ref.scale_y
      )
end

function Renderable:getDimensions()
    local cutout = self.sprite_ref.anim_spec[self.curr_anim][self.curr_frame]
    local width = (cutout[3]) * self.sprite_ref.scale_x
    local height = (cutout[4]) * self.sprite_ref.scale_y
    return {w = width, h = height}
end

return Renderable