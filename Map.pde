import java.util.ArrayList;
import java.util.Scanner;

class Map {
  ArrayList<Sector> sectors;
  PVector startPos;
  Dir startDir;
  String src;

  Map(String src_) {
    this.sectors = new ArrayList<Sector>();
    this.startPos = new PVector(0.0, 0.0);
    this.startDir = Dir.N;
    this.src = src_;
  }

  void generate() {
    // create ArrayList<String> with each part of the map file separated by whitespace
    String[] lineArr = loadStrings(src);
    ArrayList<String> elements = new ArrayList<String>();
    for (int i = 0; i < lineArr.length; i++) {
      Scanner s = new Scanner(lineArr[i]);
      while (s.hasNext()) {
        elements.add(s.next());
      }
      s.close();
    }
    
    // create sectors from elements of map file ArrayList
    int currentSector = -1;
    int i = 0;
    ArrayList<PVector> tempPoints = new ArrayList<PVector>();

    while (i < elements.size()) {
      String current = elements.get(i);

      switch (current) {
        case "End":
        case "Sector":
          // adds points in list to the last sector as walls
          for (int j = 0; j < tempPoints.size(); j++) {
            if (j == tempPoints.size() - 1) {
              this.sectors.get(currentSector).add(new Wall(tempPoints.get(j).copy(), tempPoints.get(0).copy()));
            } else {
              this.sectors.get(currentSector).add(new Wall(tempPoints.get(j).copy(), tempPoints.get(j + 1).copy()));
            }
          }
          tempPoints = new ArrayList<PVector>();
          if (current.equals("End")) break;

          // creates a new sector in this.sectors
          currentSector++;
          this.sectors.add(new Sector());
          break;

        case "Floor":
          this.sectors.get(currentSector).floor = Float.parseFloat(elements.get(i + 1));
          i++;
          break;

        case "Ceil":
          this.sectors.get(currentSector).ceil = Float.parseFloat(elements.get(i + 1));
          i++;
          break;

        case "FloorColor":
          Scanner parseFColor = new Scanner(elements.get(i + 1)).useDelimiter(";");
          ArrayList<Integer> fColorVals = new ArrayList<Integer>();
          while (parseFColor.hasNext()) {
            fColorVals.add(parseFColor.nextInt());
          }
          if (fColorVals.size() > 1) {
            this.sectors.get(currentSector).fColor = color(fColorVals.get(0), fColorVals.get(1), fColorVals.get(2));
          } else {
            this.sectors.get(currentSector).fColor = color(fColorVals.get(0));
          }
          i++;
          break;

        case "CeilColor":
          Scanner parseCColor = new Scanner(elements.get(i + 1)).useDelimiter(";");
          ArrayList<Integer> cColorVals = new ArrayList<Integer>();
          while (parseCColor.hasNext()) {
            cColorVals.add(parseCColor.nextInt());
          }
          if (cColorVals.size() > 1) {
            this.sectors.get(currentSector).cColor = color(cColorVals.get(0), cColorVals.get(1), cColorVals.get(2));
          } else {
            this.sectors.get(currentSector).cColor = color(cColorVals.get(0));
          }
          i++;
          break;

        case "StartPos":
          Float startP1 = Float.parseFloat(elements.get(i + 1));
          Float startP2 = Float.parseFloat(elements.get(i + 2));
          this.startPos = new PVector(startP1, -startP2);
          i += 2;
          break;

        case "StartDir":
          this.startDir = Dir.valueOf(elements.get(i + 1));
          i++;
          break;

        case "Texture":
          this.sectors.get(currentSector).skin = loadImage(elements.get(i + 1));
          i++;
          break;

        default:
          // if there is no keyword, coords are added as PVectors to tempPoints
          Float xVal = Float.parseFloat(current);
          Float zVal = Float.parseFloat(elements.get(i + 1));
          tempPoints.add(new PVector(xVal, -zVal));
          i++;
      }
      i++;
    }
  }

  void init() {
    this.shift(new PVector(-this.startPos.x, -this.startPos.y));
    switch (this.startDir) {
      case N:
        break;
      case S:
        this.rotate(PI);
        break;
      case E:
        this.rotate(HALF_PI);
        break;
      case W:
        this.rotate(-HALF_PI);
        break;
    }
  }

  void shift(PVector v) {
    for (Sector s : this.sectors) {
      for (Wall w : s.walls) {
        w.p1.add(v);
        w.p2.add(v);
      }
    }
  }
  
  void rotate(float theta) {
    for (Sector s : this.sectors) {
      for (Wall w : s.walls) {
        // theta is negative so positive theta is counterclockwise
        w.p1.rotate(-theta);
        w.p2.rotate(-theta);
      }
    }
  }

  String toString() {
    Utils u = new Utils();
    String s1 = "Src: " + this.src + "\n";
    String s2 = "StartPos: " + u.stringifyVector2D(this.startPos) + "\n";
    String s3 = "StartDir: " + this.startDir + "\n\n";
    String s4 = "";
    for (int i = 0; i < this.sectors.size(); i++) {
      s4 += "Sector " + i + ":\n";
      s4 += this.sectors.get(i).toString();
      if (i != this.sectors.size() - 1) {
        s4 += "\n\n";
      }
    }
    return s1 + s2 + s3 + s4;
  }
}
