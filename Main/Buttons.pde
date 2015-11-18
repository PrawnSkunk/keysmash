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

  void setupSongSelection() {

    if (firstSelectLoad == true) {
      selectP5.setAutoDraw(false);
      RadioButton radio = selectP5.addRadioButton("radioButton", 0, 120);
      radio.setItemsPerRow(1);
      radio.setSpacingColumn(30);
      radio.setSpacingRow(10);
      radio.setSize(width/3, 30);

      selectP5.setColorActive(color(255, 255, 255, 100));
      selectP5.setColorBackground(color(255, 25));
      selectP5.setColorForeground(color(255, 50));
      selectP5.setColorActive(color(255, 100));

      for (int i=0; i<songList.length; i++) {
        radio.addItem(songList[i], i);
      }
    }
    firstSelectLoad = false;
  }
}