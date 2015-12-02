class Buttons {

  // Known bug: radiobuttons break upon clicking
  int radioXPos, radioYPos, radioHeight, radioWidthInactive, radioWidthActive, radioSpacing;

  Buttons() {
    this.radioWidthInactive = int(width/2);
    this.radioWidthActive= int(width/2);
    this.radioYPos = int(width/4);
    this.radioXPos = int(width-radioWidthInactive);
    this.radioHeight = 46;
    this.radioSpacing = 1;
  }

  // Called by .activateEvent(true) in Buttons class
  void controlEvent(ControlEvent theControlEvent) {
    if (theControlEvent.isGroup()) {
      // Get Value
      if (state == GAME_SELECT) {
        lastvalue = value;
        value = (int)theControlEvent.getValue();
      }
      if (state == GAME_MENU) {
        lastvalueMenu = valueMenu;
        valueMenu = (int)theControlEvent.getValue();
      }
      if (value >= 0 && state == GAME_SELECT) {
        radioTimer = 25;
        radioCanPlay = true;
        radio.setPosition(radioXPos, radioYPos-value*(radioHeight+radioSpacing));
        radio.getItems().get(value).setWidth(radioWidthActive);
        radio.getItems().get(lastvalue).setWidth(radioWidthInactive);
        parseStepfile(value, false);
      }
      if (value == -1 && state == GAME_SELECT) {
        value = lastvalue; // don't crash when clicking
        transition(state+1);
      }

      // Game Menu
      if (valueMenu == -1 && state == GAME_MENU) {
        valueMenu = lastvalueMenu; // don't crash when clicking
        if (valueMenu == 0) { 
          transition(state+1);
          if (menuSongPlaying == true) { 
            screenAL.get(state).fadeOut(); 
            menuSongPlaying = false;
          }
        } else if (valueMenu == 1) {
          exit();
        }
      }
    }
  }

  void setupMenuSelection() {
    // the item selected is always the last on the list

    if (firstMenuLoad == true) {
      cp5Menu.setAutoDraw(false);
      cp5Menu.setColorBackground(color(255, 1));
      cp5Menu.setColorForeground(color(255, 25));
      cp5Menu.setColorActive(color(255, 50));
      menu = cp5Menu.addRadioButton("radioButtonMenu", radioXPos, radioYPos);
      for (int i=0; i < menuList.length; i++) {
        menu.addItem(menuList[i], i).hideLabels();
      }
      // ACTIVATING CAUSES PROBLEMS?
      menu.activate(0);
      menu.setSpacingColumn(radioSpacing);
      menu.setSpacingRow(radioSpacing);
      menu.setSize(radioWidthInactive/2, radioHeight);

      firstMenuLoad = false;
    }
    menu.activate(valueMenu);
  }

  void setupSongSelection() {

    if (firstSelectLoad == true) {

      firstSelectLoad = false;


      cp5Select.setAutoDraw(false);
      cp5Select.setColorBackground(color(255, 25));
      cp5Select.setColorForeground(color(255, 50));
      cp5Select.setColorActive(color(255, 100));

      radio = cp5Select.addRadioButton("radioButton", 0, radioYPos);
      for (int i=0; i<songList.length; i++) {
        parseStepfile(i, false);
        String radioTitle = sm.title;
        if (radioTitle.length() == 0) {
          radioTitle = "No Song Title (id#"+i+")";
        }
        radio.addItem(radioTitle, i).hideLabels();
      }
      radio.setItemsPerRow(1);
      radio.setSpacingColumn(radioSpacing);
      radio.setSpacingRow(radioSpacing);
      radio.setSize(radioWidthInactive, radioHeight);  
      radio.setPosition(radioXPos, radioYPos-value*(radioHeight+radioSpacing));
      radio.activate(songname);
      radio.getItems().get(value).setWidth(radioWidthActive);
    }
  }

  void drawSelectLabels() {
    float[] rpos = radio.getPosition();
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, 18);
    for (int i=0; i < songList.length; i++) {
      fill(255);
      text(radio.getItems().get(i).getName(), rpos[0]+64, rpos[1]+(i*(radioHeight+radioSpacing))+22);
      fill(255, 50);
      rect(rpos[0], rpos[1]+(i*(radioHeight+radioSpacing)),radioHeight,radioHeight);
      fill(255, 150);
      text(difficultyArray[i], rpos[0]+16, rpos[1]+(i*(radioHeight+radioSpacing))+22);
      if (played[i] == false) { fill(255, 150); text("unplayed", rpos[0]+300, rpos[1]+(i*(radioHeight+radioSpacing))+22); }
      else if (played[i] == true) { fill(50,255,50, 150); text("played", rpos[0]+300, rpos[1]+(i*(radioHeight+radioSpacing))+22);}
    }
    // Library
    textFont(debug, 14);
    fill(255, 150);
    text((songList.length)+" songs in library", rpos[0]+16, rpos[1]+((songList.length)*(radioHeight+radioSpacing))+16);
  }

  void drawMenuLabels() {
    float[] mpos = menu.getPosition();
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, 18);
    for (int i=0; i < menuList.length; i++) {
      text(menu.getItems().get(i).getName(), mpos[0]+16, mpos[1]+(i*(radioHeight+radioSpacing))+22);
    }
  }

  void radioActivate(int i) {
    radio.activate(value+i);
    sfx_value.rewind();
    sfx_value.play();
  }
  void menuActivate(int i) {
    menu.activate(menuList[valueMenu+i]);
    sfx_value.rewind();
    sfx_value.play();
  }
}