--OceanTileSprite
local sprite = {
  spritesheet = "oceantile", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
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
