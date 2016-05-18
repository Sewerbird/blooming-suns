--TestSpaceUnitSprite
local sprite = {
  spritesheet = "cadiz", --tileset reference
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {0, 0, 32, 32}
    },
    selected = {
      {0, 0, 32, 32},
      {0, 0, 1, 1}
    }
  }
}
return sprite
