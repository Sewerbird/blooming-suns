--IceTileSprite
local sprite = {
  spritesheet = "icetile", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.5,
  scale_y = 0.5,
  animations = {  --arrays of quads
    idle = {
      {0, 0, 168, 146}
    },
    selected = {
      {0, 0, 168, 146},
      {0, 0, 1, 1}
    }
  }
}
return sprite
