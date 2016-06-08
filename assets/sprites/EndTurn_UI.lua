--EndTurn
local sprite = {
  spritesheet = "endturn", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.5,
  scale_y = 0.5,
  animations = {  --arrays of quads
    idle = {
      {0, 0, 162, 150}
    },
    selected = {
      {0, 0, 162, 150}
    }
  }
}
return sprite
