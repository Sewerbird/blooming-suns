--Worldspace Location Class

Location = {}

Location.new = function(init)
	local init = init or {}
	local self = {
    --optional
    h_x = init.h_x or 0, --hex-space x (pixel)
    h_y = init.h_y or 0, --hex-space y (pixel)
    row = init.row or nil,
    col = init.col or nil,
    --required
		x = init.x ,     --map-space y (pixel)
		y = init.y ,     --map-space x (pixel)
		idx = init.idx , --hex uid
		map = init.map   --map uid
	}

	if self.x == nil or self.y == nil or self.idx == nil or self.map == nil then
		error('Attempt to create Location without all components specified' .. inspect(init))
	end

	return self
end