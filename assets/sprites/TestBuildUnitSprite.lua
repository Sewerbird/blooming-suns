local sprite = {
  spritesheet = "units", --tileset reference
  sprite_name = nil, --name of this sprite
  frame_duration = nil, --speed of animation
  animations = {  --arrays of quads
    idle = {
      {96, 80, 48, 40}
    },
    selected = {
      {96, 80, 48, 40},
      {0, 0, 1, 1}
    }
  }
}
return sprite
