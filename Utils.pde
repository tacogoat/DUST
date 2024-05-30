class Utils {
  String stringifyVector2D(PVector v) {
    return "(" + v.x + ", " + v.y + ")";
  }

  Float fovX2Y(float fov) {
    // takes horizontal fov in degrees
    // returns vertical fov in radians
    float camZ = (width / 2.0) / tan(radians(fov) / 2.0);
    return 2 * atan((height / 2.0) / camZ);
  }

  Boolean intersectExists(PVector p1, PVector p2, PVector p3, PVector p4) {
    float t = ((p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)) /
              ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
    float u = -((p1.x - p2.x) * (p1.y - p3.y) - (p1.y - p2.y) * (p1.x - p3.x)) /
              ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
    return t >= 0.0 && t <= 1.0 && u >= 0.0 && u <= 1.0;
  }

  PVector proj(PVector u, PVector v) {
    // projection of vector u through vector v
    float dot = PVector.dot(u, v);
    float den = v.mag() * v.mag();
    return PVector.mult(v, dot / den);
  }
}
