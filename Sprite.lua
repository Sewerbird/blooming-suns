--Sprite
Sprite = {}

Sprite.new = function(init)
  local init = init or {}
  local self = {
    spritesheet = init.spritesheet or nil, --filepath to spritesheet file
    sprite_name = init.sprite_name or nil, --name of this sprite
    frame_duration = init.frame_duration or nil, --speed of animation
    animations = init.animations or {} --animations available to the sprite
  }
end
