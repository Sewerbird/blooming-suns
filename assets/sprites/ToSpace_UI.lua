--ToSpace
local sprite = {
  spritesheet = "space_ui", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.35,
  scale_y = 0.35,
  animations = {  --arrays of quads
    idle = {
      {3, 3, 70, 60}
    },
    selected = {
      {3, 3, 70, 60}
    }
  }
}
return sprite
