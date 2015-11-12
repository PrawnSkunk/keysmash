class Buttons {

  Buttons() {
  }

  void buttons() {
    addButtonGameplay();
    addButtonResults();
  }

  void addButtonGameplay() {
    controlP5.addButton("gameplay")  
      .setValue(0)
      .setPosition(0, height-30)
      .setSize(120, 30)
      .setColorBackground(color(255, 25))
      .setColorForeground(color(255, 50))
      .setColorActive(color(255, 150))
      .setColorLabel(color(255, 255));
  }
  void addButtonResults() {
    controlP5.addButton("results") 
      .setValue(0)
      .setPosition(120, height-30)
      .setSize(120, 30)
      .setColorBackground(color(255, 255, 255, 25))
      .setColorForeground(color(255, 255, 255, 50))
      .setColorActive(color(255, 255, 255, 150))
      .setColorLabel(color(255, 255, 255, 255));
  }

}