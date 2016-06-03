PlanetsideMinimapComponent = {}

PlanetsideMinimapComponent.new = function (init)
  local init = init or {}
  local self = {
    ui_rect = init.ui_rect,
    position = init.position,
    extent = init.extent,
    target = init.target,
    tracked_camera = init.tracked_camera,
    background_color = init.background_color,
    description = init.description,
    super = init.super
  }
  self.onMousePressed = function (x, y, button)
  end

  self.onMouseReleased = function (x, y)
  end

  self.onUpdate = function (dt)
  end

  self.onDraw = function ()
    local toDraw = self.target
    local scale_x = self.ui_rect.w / toDraw.num_cols
    local scale_y = self.ui_rect.h / toDraw.num_rows
    local metadata = self.tracked_camera.getSeenMetadata()

    for i = 0, #toDraw.tiles do
      local computedPosition = {
        x = (toDraw.tiles[i].position.col * scale_x) + self.ui_rect.x,
        y = (toDraw.tiles[i].position.row * scale_y) + self.ui_rect.y
      }
      local color = toDraw.terrain_type_minimap_colors[toDraw.tiles[i].terrain_type]
      if color == nil then color = {255,125,255} end

--[[
      if (i >= metadata.lIdx and i <= metadata.rIdx) or     --normal case
         (metadata.wIdx ~= nil and i == metadata.wIdx and i == #self.target.tiles) or   --near left end of map
         (metadata.eIdx ~= nil and i == metadata.eIdx and i == 0) then --near right end of map
        --table.insert(seen.tiles, v)
        color = {255,255,255}
      end]]--

      love.graphics.setColor(color)
      love.graphics.rectangle("fill",computedPosition.x, computedPosition.y, scale_x, scale_y)
      love.graphics.reset()
    end

    love.graphics.setColor({255,255,255})
    local boxW = metadata.lr.col - metadata.ul.col
    local boxH = metadata.lr.row - metadata.ul.row
    love.graphics.rectangle("line", scale_x * metadata.ul.col + self.ui_rect.x, scale_y * metadata.ul.row + self.ui_rect.y, scale_x * boxW, scale_y * boxH)
    love.graphics.reset()

  end

  return self
end
