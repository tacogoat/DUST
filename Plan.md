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
