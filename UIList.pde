class UIList {
  UI ui;
  ArrayList<String> list;
  int textY;
  int spacing;

  UIList(UI ui_, ArrayList<String> list_, int y, int space) {
    this.ui = ui_;
    this.list = list_;
    this.textY = y;
    this.spacing = space;
  }

  void display() {
    ui.clampUINav(this.list);
    int textPos = textY;
    for (int i = 0; i < this.list.size(); i++) {
      if (i == itemSelected) {
        fill(ui.selectionColor);
      } else {
        fill(ui.textColor);
      }
      text(this.list.get(i), 0, textPos, ui.offset);
      textPos += this.spacing;
    }
  }
}
