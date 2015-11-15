class Buttons {

  Buttons() {
  }

  void setupButtons() {
    
    controlP5.setAutoDraw(true); 

    // By default all controllers are stored inside Tab 'default' 
    controlP5.addTab("Song Selection");
    controlP5.addTab("Gameplay");
    controlP5.addTab("Results Screen");
    controlP5.setColorActive(color(255, 255, 255, 100));
    controlP5.setColorBackground(color(255, 25));
    controlP5.setColorForeground(color(255, 50));
    controlP5.setColorActive(color(255, 100));
    controlP5.setPosition(0, height-40);

    controlP5.getTab("default")
      .setWidth(120)
      .setHeight(40) 
      .activateEvent(true) // receives a controlEvent
      .setLabel("Main Menu")
      .setId(0);

    controlP5.getTab("Song Selection")
      .setWidth(120)
      .setHeight(40) 
      .activateEvent(true)
      .setId(1);

    controlP5.getTab("Gameplay")
      .setWidth(120)
      .setHeight(40) 
      .activateEvent(true)
      .setId(2);

    controlP5.getTab("Results Screen")
      .setWidth(120)
      .setHeight(40) 
      .activateEvent(true)
      .setId(3);
  }

  void pressStart() {
  }
}