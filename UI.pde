class UI {
  void pauseMenu() {
    background(0, 255, 255);
    textSize(56); fill(255);
    text("paused - press space to resume", 0, height / 2, -cameraZ);
  }

  void waitScreen() {
    background(255, 0, 0);
    textSize(100); fill(255);
    text("start the game (space)", 0, height / 2, -cameraZ);
  }

  void debugCurrentSector() {
    rotateX(-you.vertTheta); // this line will be important for drawing UI later
    textSize(1); fill(0, 255, 0);
    text(you.currentSector, -10, -5, -10);
  }
}
