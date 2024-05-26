class Player {
  PVector pos;
  PVector v;
  Map m;
  float theta; // may not be necessary
  float height = 2;
  int currentSector;

  float vertTheta;

  float mouseSens = 0.01;

  float maxV = 16.0;
  float vEase = 0.2;

  Player(Map m_) {
    this.v = new PVector(0.0, 0.0);
    this.m = m_;
    this.currentSector = m_.startSect;
  }
  
  void move(PVector input) {
    float xMag = input.x;
    float zMag = input.y;
    PVector vMag = new PVector(xMag, zMag);
    vMag.normalize().mult(maxV / 60);
    this.v.x = lerp(this.v.x, vMag.x, vEase);
    this.v.y = lerp(this.v.y, vMag.y, vEase);

    this.currentSector = getSector();

    // potentially keep track of player position values, may be needed for something else

    this.m.shift(new PVector(-this.v.x, -this.v.y));
  }

  void look(PVector lookVals) {
    lookVals.mult(mouseSens);
    this.m.rotate(lookVals.x);
    vertTheta += lookVals.y;
    vertTheta = constrain(vertTheta, -HALF_PI, HALF_PI);
    rotateX(vertTheta);
    // keep track of angle?
    // might need it for raycasting
  }

  int getSector() {
    // check all sectors if player is out of bounds
    if (this.currentSector == -1) {
      for (int i = 0; i < this.m.sectors.size(); i++) {
        if (isInSector(i)) {
          return i;
        }
      }

    // check if player has left the current sector
    } else if (isInSector(this.currentSector)) {
      return this.currentSector;

    // check only adjacent sectors if player is not in its former sector
    } else {
      ArrayList<Integer> adjacentSectors = this.m.sectors.get(this.currentSector).adjacent;
      for (int i = 0; i < adjacentSectors.size(); i++) {
        if (isInSector(adjacentSectors.get(i))) {
          return adjacentSectors.get(i);
        }
      }
    }

    return -1; // player is out of bounds
  }

  boolean isInSector(int sectorIndex) {
    Utils u = new Utils();
    PVector testLine = new PVector(-200.0, 0.0);
    Sector s = m.sectors.get(sectorIndex);

    int intersections = 0;
    for (int i = 0; i < s.walls.size(); i++) {
      Wall w = s.walls.get(i);
      if (u.intersectExists(new PVector(0.0, 0.0), testLine, w.p1, w.p2)) {
        intersections++;
      }
    }
    
    return intersections % 2 != 0;
  }
}
