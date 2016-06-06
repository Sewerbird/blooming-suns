EFS Stack Logic

1. Only one Stack can be focused at a time
2. Only one Stack per Tile
3. A Stack has one only owner
4. Units in a Stack have one of three Stack States: Selected, Active, and Inactive
  - Selected units can Deselected to become Active
  - Selected units can Deactivated to become Inactive
  - Active & Inactive Units can be Selected to become Selected
  - Inactive Units are skipped by 'Next Unit'
  - Selected units are automatically Deselected when the Stack is unfocused.
5. A Stack can Move
  - Selected units in a stack are moved to an adjacent tile if the tile is empty or is owned by the player
  - Selected units remain selected and focused in their new tile
6. A Stack can Attack
  - Selected units in a stack perform an attack to an adjacent tile if the tile is owned by another player
7. A Stack can be attacked
  - All units (Active or Inactive) defend if in an attacked stack
8. Units in a Stack may be Loaded into another Carrier unit in the Stack
  - Loaded units inherit the Stack State of their Carrier
  - Loaded units, if Selected, instead cause their Carrier to be Selected (thus selecting them and co-loaded units)
  - Loaded units can be unloaded if their movement domain jives with their location (Land units on land/Space units in space/Sea units at sea, etc)
9. Order queues are stored on individual units
  - If an order is given to a stack, Selected units set their order queue to a singleton list of that order
  - If an order is shift+given to a stack, if all Selected units have the same order queue, they append the order to their order queue. If instead their order queues aren't equivalent, Selected units set their order queue to a singleton list of that order.
