# Plan
rewrite everything in processing\
use vectors

## Map
- needs to use vectors for point values
- create wall class
- sectors should have walls instead of points

## Collisions
- write method that calculates line segment intersection
- write method that gets what sector you are in
- add adjacent sector ArrayList to Sector.pde
- each time you try to move make a vector that represents the movement
- if this vector intersects a wall in your current sector or adjacent sectors perform additional calculations\
Wall sliding:\
if move is invalid\
if:
- movement vector and wall vector are both within a certain angle\
then:
- adjust movement vector so it is parallel to wall vector
- repeat check to see if move is invalid
- maybe a recursive structure?

## Enemies
- enemies are 2d images (potentially 3d models / 2d images of rendered 3d models?)\
Hitboxes:
- enemy hitboxes are a 2d line
- always face towards the player
- to determine if a shot hits, cast a ray forward and check if it passes through the line
- similar to collision detections
- loop through array of enemies
- maybe also check if player camera is within a certain angle?\
Pathfinding:
- go to your last position
- check if path intersects a wall
- if so wait\
Attacks:
- hitscan attack that occurs like half a second after aiming
- player hitbox implemented in the same way as enemy hitboxes
- punch attack that is limited by distance
- gets close to player then attacks\
Spawning:
- enemy positions are predetermined
- some may spawn once the player enters a certain sector
- in infinite mode, once all enemies are cleared wait a couple seconds then spawn new ones\
Potential issues:
- enemy positions and targeting locations will need to move with the map when the player moves

## Update DUST.pde
- maps are loaded and player is created when map is selected
- rework input system to something more manageable

## Lights
- maybe remove lights

## Refactoring
- make each ui menu into its own class
- move a bunch of the input processing stuff from main into ui classes
