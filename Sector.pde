import java.util.ArrayList;

class Sector {
  float floor;
  float ceil;
  color fColor;
  color cColor;
  PImage skin;
  ArrayList<Wall> walls;

  Sector() {
    this.floor = 0.0;
    this.ceil = 0.0;
    this.fColor = color(255);
    this.cColor = color(255);
    this.skin = loadImage("missing.png");
    this.walls = new ArrayList<Wall>();
  }

  void add(Wall w) {this.walls.add(w);}

  String toString() {
    String s1 = "Texture: " + this.skin.toString() + "\n";
    String s2 = "Floor Color: " + this.fColor + "\n";
    String s3 = "Ceiling Color: " + this.cColor + "\n";
    String s4 = "";
    for (int i = 0; i < this.walls.size(); i++) {
      s4 += "Wall " + i + ": " + this.walls.get(i).toString();
      if (i != this.walls.size() - 1) {
        s4 += "\n";
      }
    }
    return s1 + s2 + s3 + s4;
  }
}
