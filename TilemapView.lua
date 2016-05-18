--TilemapView
TilemapView = {}

TilemapView.new = function (init)
  local init = init or {}
  local self = View.new(init)

  self.current_focus = nil

  self.camera = TilemapCamera.new(
    {
      target = self.model,
      position = {x = self.rect.w/ 2 + self.rect.x, y = self.rect.h/2 + self.rect.y},
      extent = {half_width = self.rect.w/2, half_height = self.rect.h/2},
      super = self
    })

  self.update = function (dt)
    self.camera.onUpdate(dt)
  end

  self.onMousePressed = function (x, y, button)
    local cam = self.camera
    cam.onMousePressed(x,y,button)
  end

  self.onMouseReleased = function (x, y, button)
    local cam = self.camera
    cam.onMouseReleased(x,y,button)
  end

  self.focus = function (unit)
    if self.current_focus ~= nil then
      self.unfocus()
    end
    self.current_focus = unit
    unit.click()
  end

  self.unfocus = function ()
    self.current_focus.click()
  end

  return self
end
