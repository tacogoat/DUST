class Player {
  PVector pos;
  PVector v;
  Map m;
  float theta; // may not be necessary
  float height = 2;

  float vertTheta;

  float mouseSens = 0.01;

  float maxV = 16.0;
  float vEase = 0.2;

  Player(Map m_) {
    this.v = new PVector(0.0, 0.0);
    this.m = m_;
  }

  void move(PVector input) {
    float xMag = input.x * maxV / 60;
    float zMag = input.y * maxV / 60;
    this.v.x = lerp(this.v.x, xMag, vEase);
    this.v.y = lerp(this.v.y, zMag, vEase);

    // potentially keep track of player position values, may be needed for something else

    this.m.shift(new PVector(-this.v.x, -this.v.y));
  }
  
  void moveV(PVector input) {
    float xMag = input.x;
    float zMag = input.y;
    PVector vMag = new PVector(xMag, zMag);
    vMag.normalize().mult(maxV / 60);
    this.v.x = lerp(this.v.x, vMag.x, vEase);
    this.v.y = lerp(this.v.y, vMag.y, vEase);

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
}
