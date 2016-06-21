local sprite = {
  spritesheet = "units", --tileset reference
  sprite_name = "TestSpaceTransport", --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {0, 40, 48, 40}
    },
    selected = {
      {0, 40, 48, 40},
      {0, 0, 1, 1}
    }
  }
}
return sprite
