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
    --TODO: make it so I can click on the minimap and pan to the right spot
  end

  self.onMouseReleased = function (x, y)
    --TODO: make it so I can click on the minimap and pan to the right spot
  end

  self.onDraw = function ()
    --[[
    --Background
    love.graphics.setColor(self.background_color)
    love.graphics.rectangle("fill", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h, self.ui_rect.rx, self.ui_rect.ry)
    love.graphics.setColor(255,255,255)
    love.graphics.print(self.description, self.ui_rect.x + 25, self.ui_rect.y + self.ui_rect.h/2)
    love.graphics.reset()
    --Foreground
    --TODO: cache this image... doesn't tend to change
    local toDraw = self.target
    local scale_x = self.ui_rect.w / self.target.num_cols
    local scale_y = self.ui_rect.h / self.target.num_rows
    
    local metadata = self.tracked_camera.getSeenMetadata()

    for i = 0, #self.target.tiles do
      --Draws an offset grid of rectangles for each tile on the planet. Scaled.
      local computedPosition = {
        x = (self.target.tiles[i].location.col * scale_x) + self.ui_rect.x,
        y = (self.target.tiles[i].location.row * scale_y) + self.ui_rect.y
      }
      local color = toDraw.terrain_type_minimap_colors[self.target.tiles[i].terrain_type]
      if color == nil then color = {255,125,255} end

      love.graphics.setColor(color)
      local offset = 0
      if self.target.tiles[i].location.col % 2 == 0 then offset = scale_y/2 end
      love.graphics.rectangle("fill",computedPosition.x, computedPosition.y + offset, scale_x, scale_y)
      love.graphics.reset()
    end
    --View Quadrangle
    love.graphics.setColor({255,255,255})
    local boxW = metadata.lr.col - metadata.ul.col
    local boxH = metadata.lr.row - metadata.ul.row
    love.graphics.rectangle("line", scale_x * metadata.ul.col + self.ui_rect.x, scale_y * metadata.ul.row + self.ui_rect.y, scale_x * boxW, scale_y * boxH)
    love.graphics.reset()
    --Frame
    love.graphics.setLineWidth(math.max(scale_x,scale_y))
    love.graphics.setColor({20,20,20})
    love.graphics.rectangle("line", self.ui_rect.x, self.ui_rect.y, self.ui_rect.w, self.ui_rect.h)
    love.graphics.reset()
  ]]
  end

  return self
end
