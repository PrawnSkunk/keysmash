class Buttons {

  Buttons() {
  }

  void buttons() {
    //addButtonGameplay();
    //addButtonResults();
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

  void addTabs() {

    // By default all controllers are stored inside Tab 'default' 
    controlP5.addTab("Song Selection");
    controlP5.addTab("Gameplay");
    controlP5.addTab("Results Screen");

    // if you want to receive a controlEvent when
    // a  tab is clicked, use activeEvent(true)

    controlP5.getTab("default")
      .activateEvent(true)
      .setLabel("Main Menu")
      .setId(0)
      ;

    controlP5.getTab("Song Selection")
      .activateEvent(true)
      .setId(1)
      ;
    controlP5.getTab("Gameplay")
      .activateEvent(true)
      .setId(2)
      ;
    controlP5.getTab("Results Screen")
      .activateEvent(true)
      .setId(3)
      ;
  }
}