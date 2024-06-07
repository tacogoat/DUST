class PauseMenu extends UI {
  ArrayList<String> items;
  UIList list;

  PauseMenu(float z) {
    super(z);
    this.items = new ArrayList<String>();
    this.items.add("Resume");
    this.items.add("Options");
    this.items.add("Exit");
    this.list = new UIList(this, this.items, -50, 100);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(this.normalSize); fill(this.textColor);
    text("Paused", 0, -200, this.offset);

    textSize(this.smallSize);
    list.display();

    hint(ENABLE_DEPTH_TEST);
  }

  void handleInput() {
    this.navigateUI();
    if (this.isSelectKey()) {
      switch (itemSelected) {
        case 0:
          r.mouseMove(width / 2, height / 2);
          initCamera(userFov);
          state = GameState.PLAY;
          break;

        case 1:
          initCamera();
          itemSelected = 0;
          state = GameState.M_OPTIONS;
          break;

        case 2:
          initCamera();
          itemSelected = 0;
          state = GameState.M_LEVELS;
          inGame = false;
          break;
      }
    }

    if (this.isBackKey()) {
      r.mouseMove(width / 2, height / 2);
      initCamera(userFov);
      state = GameState.PLAY;
    }
  }
}
