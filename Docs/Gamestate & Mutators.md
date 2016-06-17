# Gamestate & Mutators #

## Vocabulary ##

'Gamestate' consists of anything that I would need to load a game from the start menu. They support queries and 'read' operations

  -Participating players & their settings
  -Current game turn and time
  -Regency info
  -Player info (tax rate, name, cash, etc)
  -State of map (planets, tilemaps, tiles)
  -State & Selection of Units (stacks, units, order queues, stack selections)
  -Construction queues
  -Technological state

'Mutators' are required for any change to gamestate: they support execution and 'write' operations

  -Starting a Game
  -End Current Turn
  -Begin Next Turn
  -Ending a Game
  -Adding a Player
  -Removing a Player
  -Setting Player Order
  -Update Planet Orbit
  -Create Unit
  -Assign Unit Order
  -Cancel Unit Order
  -Move Unit
  -Spot Unit
  -Hide Unit
  -Damage Unit
  -Destroy Unit
  -Conduct Battle
  -Change Hex Terrain
  -Create Structure
  -Upgrade Structure
  -Destroy Structure
  -Add Technology
  -Remove Technology
  -Assign Build Order
  -Cancel Build Order
  -Deliver Diplomatic Message
  -Perform Diplomatic Action

'Orders' allow ui elements, units, and buildings to plan the mutators they wish to trigger without executing immediately. Orders are created by the user interface and stored in queues on the commanded object. Orders are best thought of as Player Actions: these are the interface by which the active player actually do things, and as such orders live pretty close to the user interface code.

  -Next Turn Order
  -Execute Next Unit Order
  -Execute All Unit Orders
  -Assign Build Order
  -Cancel Build Order
  -Select Unit Order
  -Deselect Unit Order
  -Deactivate Unit Order
  -Activate Unit Order
  -Disband Unit Order
  -Load Unit Order
  -Unload Unit Order
  -Launch Unit Order
  -Land Unit Order
  -Jump Unit Order
  -Bombard Space Order
  -Bombard Surface Order
  -Move Selected Units Order
  -Attak w/Selected Units Order
  -Build City Order
  -Raze City Order
  -Adjust Tax Rate Order
  -Send Diplomatic Message Order
  -Accept Diplomatic Offer Order
  -Decline Diplomatic Offer Order
  -Adjust Tax Rate Order
  -Assign Research Order
  -Assign Proscribe Order
  -Claim Throne Order
  -Cancel Throne Claim Order
  -Assign Ministry Order
  -Resign Ministry Order

## Process ##

0. Summary Phase

In this phase, the player is shown all the activity that they could see of the other players' turns since last time it was his/her last turn. This basically replays all the mutations accumulated between then and now, and creates Reports for each one interesting/available to the player

1. Command Phase

In this phase, the player has access to the main game view, and can browse the planets and orbits and units they have line of sight to. The government panel is available for administration, units may be commanded, and structures may be inspected and assigned production orders. All 'orders' are created during this phase.

3. End phase

In this phase, all orders that are unexecuted but must execute this turn are executed (diplomatic, tax/research, & meta orders mostly). The turn is then finished and the next player is shown their own Summary Phase.
