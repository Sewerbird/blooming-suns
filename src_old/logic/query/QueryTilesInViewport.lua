QueryTilesInViewport = {}
QueryTilesInViewport.new = function(mapId, positionObj, extentObj)
	local self = {
		mapId = mapId,
		position = positionObj,
		extent = extentObj
	}

	self.execute = function(gamestate)
		local map = gamestate.getTilemap(self.mapId)
		local result = {}
		local metadata = self.getSeenMetadata(map)
		local inwindow = true
		local cursor_idx = metadata.wIdx or metadata.lIdx

		while inwindow do
			table.insert(result, cursor_idx)
			cursor_idx = cursor_idx+1
			if cursor_idx > #map.tiles and metadata.eIdx then
				cursor_idx = 0
			elseif metadata.eIdx ~= nil and cursor_idx > metadata.eIdx then
				inwindow = false
			elseif metadata.eIdx == nil and cursor_idx > metadata.rIdx then
				inwindow = false
			end
		end
		return result
	end


	self.getSeenMetadata = function (map)
		local metadata = {}

		--[[
		  I take advantage of the layout of the world map indices here and the fact the camera doesn't rotate.
		  The hexes are laid out in even-q arrangement:
		         04    12
		      00 05 08 13
		      01 06 09 14
		      02 07 10 15
		      03    11
		  So I can find the upper left corner (00) and the lower right (15) and all the hexes in between will
		  potentially be visible. This simplifies east-west seamless scrolling too, with negative indices used.

		  --TODO: On tall maps I can improve this with a more refined approach, but the performance
		  isn't so bad/critical on that part yet.
		]]--

		local ul,ur,lIdx,rIdx --extremum of camera view, in hex coords

		ul = map.pixel_to_hex({x = self.position.x - self.extent.half_width, y = self.position.y - self.extent.half_height})
		lr = map.pixel_to_hex({x = self.position.x + self.extent.half_width, y = self.position.y + self.extent.half_height})

		lIdx = map.getIdxAtCoord(ul) - map.num_rows
		rIdx = map.getIdxAtCoord(lr) + map.num_rows
		local wIdx = nil
		local eIdx = nil

		if lIdx < 0 then --show far west tiles
		  wIdx = #map.tiles + lIdx
		  lIdx = 0
		end
		if rIdx > #map.tiles then --show far east tiles
		  eIdx = rIdx - #map.tiles
		  rIdx = #map.tiles
		end

		metadata.wIdx = wIdx
		metadata.eIdx = eIdx
		metadata.lIdx = lIdx
		metadata.rIdx = rIdx
		metadata.ul = ul
		metadata.lr = lr

		return metadata

	end

	return self
end