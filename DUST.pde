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

// keybinds
char forwardKey = ',';
char backKey = 'o';
char leftKey = 'a';
char rightKey = 'e';

float cameraZ;
float vertTheta;

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
  camera(width / 2.0, height / 2.0, 0, width / 2.0, height / 2.0, -cameraZ, 0, 1, 0);

  vertTheta = 0;

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

      translate(width / 2, height / 2 + you.height);

      float xLookMag = (mouseX - width / 2) * mouseSens;
      you.look(xLookMag);
      float yLookMag = (mouseY - height / 2) * -mouseSens;
      vertTheta += yLookMag;
      rotateX(vertTheta);

      // when it moves the mouse to the center of the screen it is 27 pixels off
      // this is because the panel at the top of my computer is 26 pixels
      // processing uses the coords of the window, java uses the coords of the screen
      // whyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
      r.mouseMove(width / 2, 384 + 27);

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
    r.mouseMove(width / 2, height / 2 + 27);
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
