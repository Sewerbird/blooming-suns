importAll = function(root)
	local paths = love.filesystem.getDirectoryItems(root)
	for i, path in ipairs(paths) do
		local z = root .. "/" .. path
		if love.filesystem.isFile(z) and string.find(z,".lua",1) ~= nil then
			require(string.sub(z,1,string.find(z,".lua")-1))
		elseif love.filesystem.isDirectory(z) then
			importAll(z)
		end
	end
end

class = require 'src/lib/30log'
inspect = require 'src/lib/inspect'


importAll('src/logic')
importAll('src/lib')
importAll('src/resource')
importAll('src/ui')
