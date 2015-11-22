class Buttons {

  // Known bug: radiobuttons break upon clicking
  int radioXPos, radioYPos, radioHeight, radioWidthInactive, radioWidthActive, radioSpacing;

  Buttons() {
    this.radioWidthInactive = int(width/2);
    this.radioWidthActive= int(width/2);
    this.radioYPos = int(width/4);
    this.radioXPos = int(width-radioWidthInactive);
    this.radioHeight = 50;
    this.radioSpacing = 0;
  }

  // Called by .activateEvent(true) in Buttons class
  void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isGroup()) {
      lastvalue = value;
      value = (int)theControlEvent.getValue();
      if (value >= 0) {
        radioTimer = 25;
        radioCanPlay = true;
        radio.setPosition(radioXPos, radioYPos-value*(radioHeight+radioSpacing));
        radio.getItems().get(value).setWidth(radioWidthActive);
        radio.getItems().get(lastvalue).setWidth(radioWidthInactive);
        sm = new Parse();
        sm.header("/songs/"+songList[value]+"/"+songList[value]+".sm");
      } else {
        // theControlEvent.getValue() == -1
        screenAL.get(state).transition(GAME_PLAY);
      }
    }
  }

  void setupSongSelection() {
    if (firstSelectLoad == true) {

      cp5Select.setAutoDraw(false);
      cp5Select.setColorBackground(color(255, 25));
      cp5Select.setColorForeground(color(255, 50));
      cp5Select.setColorActive(color(255, 100));

      radio = cp5Select.addRadioButton("radioButton", 0, radioYPos);
      for (int i=0; i<songList.length; i++) {
        radio.addItem(songList[i], i).hideLabels();
      }
      radio.setItemsPerRow(1);
      radio.setSpacingColumn(radioSpacing);
      radio.setSpacingRow(radioSpacing);
      radio.setSize(radioWidthInactive, radioHeight);  
      radio.setPosition(radioXPos, radioYPos-value*(radioHeight+radioSpacing));
      radio.activate(songname);
      radio.getItems().get(value).setWidth(radioWidthActive);
    }
    firstSelectLoad = false;
  }

  void drawLabels() {
    float[] rpos = radio.getPosition();
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, 18);
    for (int i=0; i < songList.length; i++) {
      text(radio.getItems().get(i).getName(), rpos[0]+16, rpos[1]+(i*(radioHeight+radioSpacing))+22);
    }
  }
  
  void radioActivate(int i) {
    radio.activate(songList[value+i]);
  }
}