import java.awt.Robot;
import java.awt.AWTException;

Player you;
Robot r;

float mouseSens;

GameState state;

Map m;
Utils u;
UI ui;

// this is stupid fix it later
int forward, back, right, left;

// keybinds
char forwardKey = ',';
char backKey = 'o';
char leftKey = 'a';
char rightKey = 'e';

float cameraZ;

PImage bird;

void setup() {
  fullScreen(P3D, SPAN);
  u = new Utils();
  ui = new UI();

  mouseSens = 0.01;

  m = new Map("maps/newMap.txt");
  m.generate();
  m.init();
  println(m);

  you = new Player(m);

  float fov = u.fovX2Y(110);
  cameraZ = (height / 2.0) / tan(fov / 2.0);
  perspective(fov, (float) width / height, cameraZ / 100.0, cameraZ * 100.0);
  camera(width / 2.0, height / 2.0, 0, width / 2.0, height / 2.0, -cameraZ, 0, 1, 0);

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
      translate(width / 2, height / 2);

      you.move(passMovementInput());
      // for some reason you can't look while moving with trackpad on my computer
      // mouse works fine
      you.look(passLookInput());

      // when it moves the mouse to the center of the screen it is 27 pixels off
      // this is because the panel at the top of my computer is 26 pixels
      // processing uses the coords of the window, java uses the coords of the screen
      // whyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
      // fix: https://forum.processing.org/two/discussion/23136/fullscreen-mode-with-ubuntu.html
      r.mouseMove(width / 2, height / 2);

      // stroke(255); strokeWeight(2);
      // drawWireframe();
      drawScene();

      ui.debugCurrentSector();
      break;

    case PAUSED:
      ui.pauseMenu();
      break;

    case WAIT:
      ui.waitScreen();
      break;
  }
}

void drawWireframe() {
  for (int i = 0; i < m.sectors.size(); i++) {
    Sector s = m.sectors.get(i);
    for (int j = 0; j < s.walls.size(); j++) {
      Wall w = s.walls.get(j);
      if (w.isWindow = true) continue;

      PVector floorP1 = new PVector(w.p1.x, -s.floor + you.height, w.p1.y).mult(200);
      PVector floorP2 = new PVector(w.p2.x, -s.floor + you.height, w.p2.y).mult(200);
      PVector ceilP1 = new PVector(w.p1.x, -s.ceil + you.height, w.p1.y).mult(200);
      PVector ceilP2 = new PVector(w.p2.x, -s.ceil + you.height, w.p2.y).mult(200);

      line(floorP1.x, floorP1.y, floorP1.z, floorP2.x, floorP2.y, floorP2.z);
      line(ceilP1.x, ceilP1.y, ceilP1.z, ceilP2.x, ceilP2.y, ceilP2.z);
      line(floorP1.x, floorP1.y, floorP1.z, ceilP1.x, ceilP1.y, ceilP1.z);
    }
  }
}

void drawScene() {
  strokeWeight(0);
  for (Sector s : m.sectors) {
    ArrayList<PVector> floorPoints = new ArrayList<PVector>();
    ArrayList<PVector> ceilPoints = new ArrayList<PVector>();
    for (Wall w : s.walls) {
      PVector floorP1 = new PVector(w.p1.x, -s.floor + you.height, w.p1.y).mult(200);
      PVector floorP2 = new PVector(w.p2.x, -s.floor + you.height, w.p2.y).mult(200);
      PVector ceilP1 = new PVector(w.p1.x, -s.ceil + you.height, w.p1.y).mult(200);
      PVector ceilP2 = new PVector(w.p2.x, -s.ceil + you.height, w.p2.y).mult(200);

      floorPoints.add(floorP1);
      ceilPoints.add(ceilP1);

      if (w.isWindow) continue;

      PImage img = s.skin;

      beginShape();
        texture(img);
        vertex(ceilP1.x, ceilP1.y, ceilP1.z, 0, 0);
        vertex(ceilP2.x, ceilP2.y, ceilP2.z, img.width, 0);
        vertex(floorP2.x, floorP2.y, floorP2.z, img.width, img.height);
        vertex(floorP1.x, floorP1.y, floorP1.z, 0, img.height);
      endShape();
    }

    beginShape();
      fill(s.fColor);
      for (PVector p : floorPoints) {
        vertex(p.x, p.y, p.z);
      }
    endShape();

    beginShape();
      fill(s.cColor);
      for (PVector p : ceilPoints) {
        vertex(p.x, p.y, p.z);
      }
    endShape();
  }
}

PVector passMovementInput() {
  return new PVector(left + right, forward + back);
}

PVector passLookInput() { 
  PVector input = new PVector();
  input.x = (mouseX - width / 2);
  input.y = -(mouseY - height / 2);
  return input;
}

void keyPressed() {
  if (key == forwardKey) {forward = -1;}
  if (key == backKey) {back = 1;}
  if (key == leftKey) {left = -1;}
  if (key == rightKey) {right = 1;}

  if (key == ' ' && (state == GameState.WAIT || state == GameState.PAUSED)) {
    r.mouseMove(width / 2, height / 2);
    state = GameState.PLAY;
  }

  if (keyCode == TAB  && state == GameState.PLAY) {
    state = GameState.PAUSED;
  } else if (state == GameState.PAUSED) {
    state = GameState.PLAY;
  }
}

void keyReleased() {
  if (key == forwardKey) {forward = 0;}
  if (key == backKey) {back = 0;}
  if (key == leftKey) {left = 0;}
  if (key == rightKey) {right = 0;}
}
