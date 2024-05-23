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
}
