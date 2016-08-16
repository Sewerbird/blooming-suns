QueryTilemapById = {}
QueryTilemapById.new = function(mapId)
	local self = {
		mapId = mapId
	}

	self.execute = function(gamestate)
		return gamestate.getTilemap(self.mapId);
	end

	return self
end