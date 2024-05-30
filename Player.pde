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
  float jumpV = 16.0;

  Player(Map m_) {
    this.v = new PVector(0.0, 0.0);
    this.m = m_;
    this.currentSector = m_.startSect;
  }
  
  void move(PVector input, boolean rawInput) {
    Utils u = new Utils();
    this.currentSector = getSector();
    
    // horizontal movement
    PVector vMag;
    if (rawInput) {
      vMag = new PVector(input.x, input.y);
      vMag.normalize().mult(this.maxV / 60);
    } else {
      vMag = input;
    }

    this.v.x = lerp(this.v.x, vMag.x, vEase);
    this.v.y = lerp(this.v.y, vMag.y, vEase);

    if (this.currentSector != -1) {
      for (Wall w : this.m.sectors.get(this.currentSector).walls) {
        if (w.isWindow) continue;
        if (u.intersectExists(new PVector(0.0, 0.0), new PVector(v.x * 2, v.y * 2), w.p1, w.p2)) {
          this.handleCollision(w, input);
          return;
        }
      }
      for (int i : this.m.sectors.get(this.currentSector).adjacent) {
        Sector s = this.m.sectors.get(i);
        for (Wall w : s.walls) {
          if (w.isWindow) continue;
          if (u.intersectExists(new PVector(0.0, 0.0), new PVector(v.x * 2, v.y * 2), w.p1, w.p2)) {
            this.handleCollision(w, input);
            return;
          }
        }
      }
    }

    // potentially keep track of player position values, may be needed for something else

    this.m.shift(new PVector(-this.v.x, -this.v.y));
  }

  void handleCollision(Wall w, PVector input) {
    try {
      PVector wallNormal = new PVector(w.p2.x - w.p1.x, w.p2.y - w.p1.y);
      wallNormal.rotate(HALF_PI);
      float dot = PVector.dot(input, wallNormal); 
      // youtube.com/watch?v=oom6R-M2lvQ
      PVector motion = input.sub(wallNormal.mult(dot));
      this.move(motion, true);
    } catch (StackOverflowError e) {
      e.printStackTrace();
      return;
    }
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
