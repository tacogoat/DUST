import java.awt.Robot;
import java.awt.AWTException;

Player you;
Robot r;

float mouseSens;

GameState state;

Map m;
Utils u;

// this is stupid fix it later
int forward, back, right, left;

char forwardKey = ',';
char backKey = 'o';
char leftKey = 'a';
char rightKey = 'e';

float cameraZ;

void setup() {
  fullScreen(P3D);
  u = new Utils();

  mouseSens = 0.01;

  m = new Map("maps/map.txt");
  m.generate();
  m.init();
  println(m);

  you = new Player(m);

  float fov = u.fovX2Y(110);
  cameraZ = (height / 2.0) / tan(fov / 2.0);
  perspective(fov, (float) width / height, cameraZ / 100.0, cameraZ * 100.0);

  try {
    r = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
  }
  r.mouseMove(width / 2, height / 2);
  noCursor();

  state = GameState.WAIT;
}

void draw() {
  switch (state) {
    case PLAY:
      background(20);
     
      you.move(passInput());

      float lookMag = (mouseX - width / 2) * mouseSens;
      you.look(lookMag, cameraZ);
      r.mouseMove(width / 2, height / 2);

      translate(width / 2, height / 2 + you.height, cameraZ / 3);
      stroke(255); strokeWeight(2);
      drawWireframe();
      break;

    case PAUSED:
      background(255, 0, 0);
      textSize(56);
      text("paused - press space to start", 0, height / 2);
      break;

    case WAIT:
      background(255, 0, 0);
      textSize(100);
      text("start the game (space)", 0, height / 2);
      break;
  }
}

void drawWireframe() {
  for (int i = 0; i < m.sectors.size(); i++) {
    Sector s = m.sectors.get(i);
    for (int j = 0; j < s.walls.size(); j++) {
      Wall w = s.walls.get(j);

      PVector floorP1 = new PVector(w.p1.x, -s.floor, w.p1.y).mult(200);
      PVector floorP2 = new PVector(w.p2.x, -s.floor, w.p2.y).mult(200);
      PVector ceilP1 = new PVector(w.p1.x, -s.ceil, w.p1.y).mult(200);
      PVector ceilP2 = new PVector(w.p2.x, -s.ceil, w.p2.y).mult(200);

      line(floorP1.x, floorP1.y, floorP1.z, floorP2.x, floorP2.y, floorP2.z);
      line(ceilP1.x, ceilP1.y, ceilP1.z, ceilP2.x, ceilP2.y, ceilP2.z);
      line(floorP1.x, floorP1.y, floorP1.z, ceilP1.x, ceilP1.y, ceilP1.z);
    }
  }
}

void keyPressed() {
  if (key == forwardKey) {forward = -1;}
  if (key == backKey) {back = 1;}
  if (key == leftKey) {left = -1;}
  if (key == rightKey) {right = 1;}
  if (key == ' ' && (state == GameState.WAIT || state == GameState.PAUSED)) {
    state = GameState.PLAY;
  }
  if (keyCode == TAB  && state == GameState.PLAY) {
    state = GameState.PAUSED;
  }
}

void keyReleased() {
  if (key == forwardKey) {forward = 0;}
  if (key == backKey) {back = 0;}
  if (key == leftKey) {left = 0;}
  if (key == rightKey) {right = 0;}
}

PVector passInput() {
  return new PVector(left + right, forward + back);
}
