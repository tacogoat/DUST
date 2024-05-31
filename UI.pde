class UI {
  float offset;

  color selectionColor = color(255, 0, 0);
  color textColor = color(255, 255, 255);

  UI(float z) {
    this.offset = z;
  }

  void pauseMenu() {
    hint(DISABLE_DEPTH_TEST);

    background(0, 255, 255);
    textSize(56); fill(255);
    text("paused - press space to resume", 0, height / 2, this.offset);

    hint(ENABLE_DEPTH_TEST);
  }

  void waitScreen() {
    hint(DISABLE_DEPTH_TEST);

    background(255, 0, 0);
    textSize(100); fill(255);
    text("press any key to start", 0, height / 2, this.offset);

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
