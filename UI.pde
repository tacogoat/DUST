class UI {
  float offset;

  int itemSelected;

  color selectionColor = color(255, 0, 0);
  color textColor = color(255);

  UI(float z) {
    this.offset = z;
    this.itemSelected = 0;
  }

  void navigateUI() {
    if (key == forwardKey || keyCode == UP) this.itemSelected--;
    if (key == backKey || keyCode == DOWN) this.itemSelected++;
  }

  void clampUINav(ArrayList<String> list) {
    if (this.itemSelected < 0) this.itemSelected = list.size() - 1;
    if (this.itemSelected >= list.size()) this.itemSelected = 0;
  }

  boolean isSelectKey() {
    return key == ' ' ||
           key == ENTER ||
           key == RETURN;
  }

  void startMenu() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(100); fill(255);
    text("DUST", 0, -300, this.offset);

    ArrayList<String> items = new ArrayList<String>();
    items.add("Level Select");
    items.add("Options");
    items.add("test item");

    this.clampUINav(items);
    int textY = -50;
    textSize(80);
    for (int i = 0; i < items.size(); i++) {
      if (i == this.itemSelected) {
        fill(selectionColor);
      } else {
        fill(textColor);
      }
      text(items.get(i), 0, textY, this.offset);
      textY += 100;
    }

    hint(ENABLE_DEPTH_TEST);
  }

  void levels() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(80); fill(255);
    text("Level Select", 0, -300, this.offset);

    ArrayList<String> levels = new ArrayList<String>();
    levels.add("Castle of Torment");

    this.clampUINav(levels);
    int textY = -150;
    textSize(60);
    for (int i = 0; i < levels.size(); i++) {
      if (i == this.itemSelected) {
        fill(selectionColor);
      } else {
        fill(textColor);
      }
      text(levels.get(i), 0, textY, this.offset);
      textY += 100;
    }

    hint(ENABLE_DEPTH_TEST);
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
    text("paused - press space to resume", 0, 0, this.offset);

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
