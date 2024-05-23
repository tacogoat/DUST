class Wall {
  PVector p1;
  PVector p2; 

  Wall() {
    p1 = new PVector(0.0, 0.0);
    p2 = new PVector(0.0, 0.0);
  }

  Wall(PVector p1_, PVector p2_) {
    p1 = p1_;
    p2 = p2_;
  }

  String toString() {
    Utils u = new Utils();
    return u.stringifyVector2D(p1) + ", " + u.stringifyVector2D(p2);
  }
}
