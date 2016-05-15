--WoodTileSprite
local sprite = {
  spritesheet = "countryside", --filepath to spritesheet file
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {32, 32, 32, 32},
      {32, 32, 32, 32}
    },
    selected = {
      {32, 32, 32, 32}
    }
  }
}
return sprite
