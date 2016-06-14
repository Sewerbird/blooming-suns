--EndTurn
local sprite = {
  spritesheet = "command_ui", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.39,
  scale_y = 0.39,
  animations = {  --arrays of quads
    idle = {
      {140, 0, 64, 64}
    },
    selected = {
      {140, 0, 64, 64}
    }
  }
}
return sprite
