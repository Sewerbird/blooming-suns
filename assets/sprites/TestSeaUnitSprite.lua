--TestSeaUnitSprite
local sprite = {
  spritesheet = "Destroyer", --tileset reference
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  scale_x = 0.5,
  scale_y = 0.5,
  animations = {  --arrays of quads
    idle = {
      {0, 0, 64, 64}
    },
    selected = {
      {0, 0, 64, 64},
      {0, 0, 1, 1}
    }
  }
}
return sprite
