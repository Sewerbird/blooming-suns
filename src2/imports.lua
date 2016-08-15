local importX = function(root)
	local paths = love.filesystem.getDirectoryItems(root)
	for i, path in paths do
		if love.filesystem.isFile(root .. "/" .. path) and then
			require(root .. "/" .. path)
		end
	end
end

--libraries
importX('src/lib/')

--game