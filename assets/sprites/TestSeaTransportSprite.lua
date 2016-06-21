local sprite = {
  spritesheet = "units", --tileset reference
  sprite_name = "TestSeaTransport", --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {0, 0, 48, 40}
    },
    selected = {
      {0, 0, 48, 40},
      {0, 0, 1, 1}
    }
  }
}
return sprite
