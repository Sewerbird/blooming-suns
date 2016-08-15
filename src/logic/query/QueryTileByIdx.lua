QueryTileByIdx = {}
QueryTileByIdx.new = function(mapId, tileId)
	local self = {
		mapId = mapId,
		tileId = tileId
	}

	self.execute = function(gamestate)
		return gamestate.getTilemap(self.mapId).getHexAtIdx(self.tileId)
	end

	return self
end