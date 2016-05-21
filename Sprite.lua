--Sprite
Sprite = {}

Sprite.new = function(init)
  local init = init or {}
  local self = {
    size = init.size or {x = 0, y = 0},
    spritesheet = init.spritesheet or nil, --filepath to spritesheet file
    sprite_name = init.sprite_name or nil, --name of this sprite
    frame_duration = init.frame_duration or nil, --speed of animation
    animations = init.animations or {} --animations available to the sprite
  }
end
