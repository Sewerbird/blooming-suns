--Sprite
Sprite = {
  spritesheet = nil, --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = nil,
    move = nil,
    attack = nil,
    selected = nil
  }
}

function Sprite:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

