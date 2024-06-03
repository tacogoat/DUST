import java.awt.Robot;
import java.awt.AWTException;

Player you;
Robot r;

String chooseMouseSens = "150";
String chooseFov = "110";

String oldSens = "150";
String oldFov = "110";

int menuFov = 110;

GameState state;

Map m;
Utils u;
UI ui;

String map2Load;
boolean doneLoading;

int forward, back, right, left;

// keybinds
char forwardKey = ',';
char backKey = 'o';
char leftKey = 'a';
char rightKey = 'e';

float cameraZ; // distance between eye of camera and display

boolean isTyping;
char typedKey;

void setup() {
  fullScreen(P3D, SPAN);
  u = new Utils();

  initCamera(Integer.parseInt(chooseFov));

  ui = new UI(-cameraZ);

  try {
    r = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
  }
  noCursor();

  state = GameState.M_START;
  translate(width / 2, height / 2);
  ui.loading();
}

void initCamera(int fovVal) {
  float fov = u.fovX2Y(fovVal);
  cameraZ = (height / 2.0) / tan(fov / 2.0);
  perspective(fov, (float) width / height, cameraZ / 100.0, cameraZ * 100.0);
  camera(width / 2.0, height / 2.0, 0, width / 2.0, height / 2.0, -cameraZ, 0, 1, 0);
}

void initCamera() {
  float fov = u.fovX2Y(menuFov);
  cameraZ = (height / 2.0) / tan(fov / 2.0);
  perspective(fov, (float) width / height, cameraZ / 100.0, cameraZ * 100.0);
  camera(width / 2.0, height / 2.0, 0, width / 2.0, height / 2.0, -cameraZ, 0, 1, 0);
}

void draw() {
  // fix for windowing issues: https://forum.processing.org/two/discussion/23136/fullscreen-mode-with-ubuntu.html
  r.mouseMove(width / 2, height / 2);
  translate(width / 2, height / 2);
  
  switch (state) {
    case PLAY:
      background(20);

      you.move(passMovementInput(), true);
      // for some reason you can't look while moving with trackpad on my computer
      // mouse works fine
      you.look(passLookInput());

      // lightFalloff(1.0, 0.0001, 0.0);
      // drawLights();
      drawScene();
      break;

    case M_START:
      ui.startMenu();
      break;

    case M_OPTIONS:
      ui.options();
      break;

    case M_LEVELS:
      ui.levels();
      break;

    case LOAD:
      ui.loading();
      if (doneLoading) state = GameState.WAIT;
      break;

    case M_PAUSED:
      ui.pauseMenu();
      break;

    case WAIT:
      you = new Player(m, Integer.parseInt(chooseMouseSens));
      ui.waitScreen();
      break;
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

void drawLights() {
  ambientLight(0, 0, 0);
  for (LightData l : m.lights) {
    pointLight(l.r, l.g, l.b, l.x, l.y, l.z);
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
  switch (state) {
    case PLAY:
      if (key == forwardKey) forward = -1;
      if (key == backKey) back = 1;
      if (key == leftKey) left = -1;
      if (key == rightKey) right = 1;

      if (keyCode == ESC) {
        key = 0;
        initCamera();
        state = GameState.M_PAUSED;
      }
      break;

    case M_START:
      ui.navigateUI();
      if (ui.isBackKey()); // do nothing, stops the window from closing

      if (ui.isSelectKey()) {
        switch (ui.itemSelected) {
          case 0:
            state = GameState.M_LEVELS;
            ui.itemSelected = 0;
            break;

          case 1:
            state = GameState.M_OPTIONS;
            ui.itemSelected = 0;
            break;

          case 2:
            ui.isBackKey();
            if (ui.isSelectKey()) exit();
        }
      }
      break;

    case M_LEVELS:
      ui.navigateUI();
      if (ui.isSelectKey()) {
        switch (ui.itemSelected) {
          case 0:
            map2Load = "maps/newMap.txt";
            thread("loadMap");
            state = GameState.LOAD;
            break;
        }
      }
      if (ui.isBackKey()) {
        state = GameState.M_START;
      }
      break;

    case M_OPTIONS:
      if (isTyping) {
        switch (ui.itemSelected) {
          case 0:
            if (ui.isBackKey()) {
              chooseFov = oldFov;
              isTyping = false;
              ui.selectionColor = color(255, 0, 0);
            } else if (ui.isSelectKey()) {
              try {
                int intFovVal = u.clamp(Integer.parseInt(chooseFov), 30, 150);
                chooseFov = "" + intFovVal;
                isTyping = false;
                ui.selectionColor = color(255, 0, 0);
              } catch (NumberFormatException e) {
                chooseFov = "";
              }
            } else {
              chooseFov += key;
            }
            break;

          case 1:
            if (ui.isBackKey()) {
              chooseMouseSens = oldSens;
              isTyping = false;
              ui.selectionColor = color(255, 0, 0);
            } else if (ui.isSelectKey()) {
              try {
                int intSensVal = u.clamp(Integer.parseInt(chooseMouseSens), 25, 400);
                chooseMouseSens = "" + intSensVal;
                isTyping = false;
                ui.selectionColor = color (255, 0, 0);
              } catch (NumberFormatException e) {
                chooseMouseSens = "";
              }
            } else {
              chooseMouseSens += key;
            }
            break;
        }
      } else {
        ui.navigateUI(); 

        if (ui.isSelectKey()) {
          ui.selectionColor = color(0, 255, 0);
          isTyping = true;

          switch (ui.itemSelected) {
            case 0:
              oldFov = chooseFov;
              chooseFov = "";
              break;

            case 1:
              oldSens = chooseMouseSens;
              chooseMouseSens = "";
              break;
          }
        }

        if (ui.isBackKey()) {
          state = GameState.M_START;
        }
      }
      break;

    case WAIT:
      r.mouseMove(width / 2, height / 2);
      initCamera(Integer.parseInt(chooseFov));
      state = GameState.PLAY;
      break;

    case M_PAUSED:
      if (key == ' ' || keyCode == ESC) {
        key = 0;
        r.mouseMove(width / 2, height / 2);
        initCamera(Integer.parseInt(chooseFov));
        state = GameState.PLAY;
      }

      if (keyCode == TAB) {
        state = GameState.PLAY;
      }
      break;
  }
}

void keyReleased() {
  if (key == forwardKey) forward = 0;
  if (key == backKey) back = 0;
  if (key == leftKey) left = 0;
  if (key == rightKey) right = 0;
}

void keyTyped() {
  if (isTyping) {
    typedKey = key;
  }
}

void loadMap() {
  doneLoading = false;
  m = new Map(map2Load);
  m.init();
  doneLoading = true;
}
