class Player {
  PVector pos;
  PVector v;
  Map m;
  float theta; // may not be necessary
  float height = 400;

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

  void look(float dTheta, float camZ) {
    this.m.rotate2(dTheta, camZ);
    // keep track of angle?
    // might need it for raycasting
  }
}
