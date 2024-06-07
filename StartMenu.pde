class StartMenu extends UI {
  ArrayList<String> items;
  UIList list;

  StartMenu(float z) {
    super(z);
    this.items = new ArrayList<String>();
    this.items.add("Level Select");
    this.items.add("Options");
    this.items.add("Exit");
    this.list = new UIList(this, this.items, -50, 100);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(this.titleSize); fill(this.textColor);
    text("DUST", 0, -300, this.offset);

    textSize(this.normalSize);
    list.display();

    hint(ENABLE_DEPTH_TEST);
  }

  void handleInput() {
    this.navigateUI();
    this.isEsc(); // does nothing, stops the window from closing

    if (this.isSelectKey()) {
      switch (itemSelected) {
        case 0:
          state = GameState.M_LEVELS;
          itemSelected = 0;
          break;

        case 1:
          state = GameState.M_OPTIONS;
          itemSelected = 0;
          break;

        case 2:
          if (this.isSelectKey()) exit();
          break;
      }
    }
  }
}
