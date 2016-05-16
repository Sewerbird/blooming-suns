--TestUnitSprite
local sprite = {
  spritesheet = "noble", --tileset reference
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {0, 0, 32, 32}
    },
    selected = {
      {0, 0, 32, 32}
    }
  }
}
return sprite
