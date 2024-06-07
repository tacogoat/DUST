class UI {
  float offset;

  color selectionColor = color(255, 0, 0);
  color textColor = color(255);

  int titleSize = 100;
  int normalSize = 80;
  int smallSize = 60;

  UI(float z) {
    this.offset = z;
    itemSelected = 0;
  }

  void navigateUI() {
    if (key == forwardKey || keyCode == UP) itemSelected--;
    if (key == backKey || keyCode == DOWN || keyCode == TAB) itemSelected++;
  }

  void clampUINav(ArrayList<String> list) {
    if (itemSelected < 0) itemSelected = list.size() - 1;
    if (itemSelected >= list.size()) itemSelected = 0;
  }

  boolean isSelectKey() {
    return key == ' ' ||
           keyCode == ENTER ||
           keyCode == RETURN;
  }

  boolean isEsc() {
    if (keyCode == ESC) {
      key = 0;
      return true;
    } else {
      return false;
    }
  }

  boolean isBackKey() {
    return this.isEsc() ||
           keyCode == BACKSPACE ||
           keyCode == DELETE;
  }

  void loading() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, CENTER); textSize(80); fill(0, 255, 0);
    text("Loading", 0, 0, this.offset);

    hint(ENABLE_DEPTH_TEST);
  }

  void pauseMenu() {
    hint(DISABLE_DEPTH_TEST);

    background(0, 255, 255);
    textAlign(LEFT, CENTER); textSize(56); fill(255);
    text("paused - press space to resume", -width / 2, 0, this.offset);

    hint(ENABLE_DEPTH_TEST);
  }

  void waitScreen() {
    hint(DISABLE_DEPTH_TEST);

    background(255, 0, 0);
    textAlign(LEFT, CENTER); textSize(100); fill(255);
    text("press any key to start", -width / 2, 0, this.offset);

    hint(ENABLE_DEPTH_TEST);
  }

  void debugCurrentSector() {
    hint(DISABLE_DEPTH_TEST);

    rotateX(-you.vertTheta); // this line will be important for drawing UI later
    textSize(50); fill(0, 255, 0);
    text(you.currentSector, -width / 2 + 10, -height / 2 + 40, this.offset);
    // apparently variables declared in main class extend to inner classes

    hint(ENABLE_DEPTH_TEST);
  }
}
