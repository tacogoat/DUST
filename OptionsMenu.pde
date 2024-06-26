class OptionsMenu extends UI {
  ArrayList<String> options;
  UIList list;

  OptionsMenu(float z) {
    super(z);
    this.options = new ArrayList<String>();
    this.options.add("FOV: " + fovInput);
    this.options.add("Mouse Sensitivity: " + sensInput);
    this.list = new UIList(this, this.options, -150, 100);
  }

  void display() {
    hint(DISABLE_DEPTH_TEST);

    background(20);
    textAlign(CENTER, TOP); textSize(this.normalSize); fill(this.textColor);
    text("Options", 0, -300, this.offset);

    textSize(this.smallSize);
    list.display();

    hint(ENABLE_DEPTH_TEST);
  }

  void handleInput() {
    if (isTyping) {
      switch (itemSelected) {
        case 0:
          if (this.isBackKey()) {
            fovInput = "" + userFov;
            this.options.set(0, "FOV: " + fovInput);
            isTyping = false;
            this.selectionColor = color(255, 0, 0);

          } else if (this.isSelectKey()) {
            try {
              userFov = u.clamp(Integer.parseInt(fovInput), 30, 150);
              fovInput = "" + u.clamp(Integer.parseInt(fovInput), 30, 150);
              this.options.set(0, "FOV: " + fovInput);
              isTyping = false;
              this.selectionColor = color(255, 0, 0);
            } catch (NumberFormatException e) {
              fovInput = "";
              this.options.set(0, "FOV: " + fovInput);
            }

          } else {
            fovInput += key;
            this.options.set(0, "FOV: " + fovInput);
          }
          break;


        case 1:
          if (this.isBackKey()) {
            sensInput = "" + userSens;
            this.options.set(1, "Mouse Sensitivity: " + sensInput);
            isTyping = false;
            this.selectionColor = color(255, 0, 0);

          } else if (this.isSelectKey()) {
            try {
              userSens = u.clamp(Integer.parseInt(sensInput), 25, 400);
              sensInput = "" + u.clamp(Integer.parseInt(sensInput), 25, 400);
              this.options.set(1, "Mouse Sensitivity: " + sensInput);
              isTyping = false;
              this.selectionColor = color(255, 0, 0);
            } catch (NumberFormatException e) {
              sensInput = "";
              this.options.set(1, "Mouse Sensitivity: " + sensInput);
            }

          } else {
            sensInput += key;
            this.options.set(1, "Mouse Sensitivity: " + sensInput);
          }
          break;
      }


    } else { // not typing
      this.navigateUI();

      if (this.isSelectKey()) {
        this.selectionColor = color(0, 255, 0);
        isTyping = true;

        switch (itemSelected) {
          case 0:
            fovInput = "";
            this.options.set(0, "FOV: " + fovInput);
            break;

          case 1:
            sensInput = "";
            this.options.set(1, "Mouse Sensitivity: " + sensInput);
            break;
        }
      }

      if (this.isBackKey()) {
        if (inGame) {
          state = GameState.M_PAUSED;
        } else {
          state = GameState.M_START;
        }
      }
    }
  }
}
