--MoveAttackSprite_UI
local sprite = {
  spritesheet = "command_overlay", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.4,
  scale_y = 0.4,
  animations = {  --arrays of quads
    idle = {
      {200, 0, 200, 200}
    },
    selected = {
      {0, 0, 200, 200}
    }
  }
}
return sprite
