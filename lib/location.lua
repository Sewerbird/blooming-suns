Location = {}

Location.new = function(init)
	local init = init or {}
	local self = {
    h_x = init.h_x , --hex-space x (pixel)
    h_y = init.h_y , --hex-space y (pixel)
		x = init.x ,     --map-space y (pixel)
		y = init.y ,     --map-space x (pixel)
		idx = init.idx , --hex uid
		map = init.map   --map uid
	}

	if x == nil or y == nil or idx == nil or map == nil then
		error('Attempt to create Location without all components specified' .. inspect(init))
	end

	return self
end