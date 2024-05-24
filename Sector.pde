import java.util.ArrayList;

class Sector {
  float floor;
  float ceil;
  PImage skin;
  ArrayList<Wall> walls;

  Sector() {
    this.floor = 0.0;
    this.ceil = 0.0;
    this.skin = loadImage("missing.jpg");
    this.walls = new ArrayList<Wall>();
  }

  void add(Wall w) {this.walls.add(w);}

  String toString() {
    Utils u = new Utils();
    String s1 = "Texture: " + this.skin.toString() + "\n";
    String s2 = "";
    for (int i = 0; i < this.walls.size(); i++) {
      s2 += "Wall " + i + ": " + this.walls.get(i).toString();
      if (i != this.walls.size() - 1) {
        s2 += "\n";
      }
    }
    return s1 + s2;
  }
}
