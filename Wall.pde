class Wall {
  PVector p1;
  PVector p2; 
  boolean isWindow;

  Wall() {
    this.p1 = new PVector(0.0, 0.0);
    this.p2 = new PVector(0.0, 0.0);
    this.isWindow = false;
  }

  Wall(PVector p1_, PVector p2_, boolean window) {
    this.p1 = p1_;
    this.p2 = p2_;
    this.isWindow = window;
  }

  String toString() {
    Utils u = new Utils();
    return u.stringifyVector2D(p1) + ", " + u.stringifyVector2D(p2) + " " + this.isWindow;
  }
}
