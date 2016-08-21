local Location = class("Location", {
	map = "Earth",
	x = 0, 		-- pixel, x
	y = 0, 		-- pixel, y
	off_x = 0, 	-- pixel offset
	off_y = 0, 	-- pixel offset
	col = 0, 	-- hex coord, x
	row = 0, 	-- hex coord, y
	idx = 0, 	-- hex id
})

return Location