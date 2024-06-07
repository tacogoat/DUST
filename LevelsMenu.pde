class LevelsMenu extends UI {
  ArrayList<String> levels;
  UIList list;

  LevelsMenu(float z) {
    super(z);
    this.levels = new ArrayList<String>();
    this.levels.add("Castle of Torment");
    this.list = new UIList(this, this.levels, -150, 100);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(this.normalSize); fill(this.textColor);
    text("Level Select", 0, -300, this.offset);

    textSize(this.smallSize);
    list.display();

    hint(ENABLE_DEPTH_TEST);
  }

  void handleInput() {
    this.navigateUI();

    if (this.isSelectKey()) {
      switch (itemSelected) {
        case 0:
          map2Load = "maps/newMap.txt";
          thread("loadMap");
          state = GameState.LOAD;
          break;
      }
    }

    if (this.isBackKey()) {
      state = GameState.M_START;
    }
  }
}
