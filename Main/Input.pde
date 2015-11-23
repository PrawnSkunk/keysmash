class Input {

  Input() {
  }


  // Mouse Wheel
  void mouseWheel(MouseEvent event) {
    if (state == GAME_SELECT) {
      float e = event.getCount();
      if (e > 0 && value > 0) {
        btn.radioActivate(-1);
      }
      if (e < 0 && value < songList.length-1) {
        btn.radioActivate(1);
      }
    }
    if (state == GAME_MENU) {
      float e = event.getCount();
      if (e > 0 && valueMenu > 0) {
        btn.menuActivate(-1);
      }
      if (e < 0 && valueMenu < menuList.length-1) {
        btn.menuActivate(1);
      }
    }
  }

  void mousePressed() {
    if (state == GAME_TITLE) {
      screenAL.get(state).transition(state+1);
    }
  }

  void keyPressed() {
    // Escape
    if (key == ESC) key = BACKSPACE;

    // Enter
    if (key == ENTER) {
      if (state == GAME_TITLE) {
        screenAL.get(state).transition(GAME_MENU);
      } else if (state == GAME_MENU) { 
        if (valueMenu == 0) { 
          screenAL.get(state).transition(state+1);
          if (menuSongPlaying == true) { 
            screenAL.get(state).fadeOut(); 
            menuSongPlaying = false;
          }
        } else if (valueMenu == 1) {
        } else if (valueMenu == 2) {
          exit();
        }
      } else if (state == GAME_SELECT) screenAL.get(state).transition(state+1);
    }

    // Restart
    if (key == '/') {
      if (state == GAME_PLAY) screenAL.get(state).transition(GAME_PLAY);
      else if (state == GAME_RESULT) screenAL.get(state).transition(GAME_PLAY);
    }

    // Quit
    if (key == CODED && keyCode == CONTROL) {
      if (state == GAME_PLAY) screenAL.get(state).transition(GAME_RESULT);
      else if (state == GAME_RESULT) screenAL.get(state).transition(GAME_SELECT);
      else if (state == GAME_SELECT) screenAL.get(state).transition(GAME_MENU);
      else if (state == GAME_MENU) screenAL.get(state).transition(GAME_TITLE);
    } 

    // Song Selection
    else if (key == CODED) {
      if (key == CODED && keyCode == UP) {
        if (value > 0 && state == GAME_SELECT) {
          btn.radioActivate(-1);
        } else if (valueMenu > 0 && state == GAME_MENU) {
          btn.menuActivate(-1);
        }
      }
      if (key == CODED && keyCode == DOWN) {
        if (value < songList.length-1  && state == GAME_SELECT) {
          btn.radioActivate(1);
        } else if (valueMenu < menuList.length-1 && state == GAME_MENU) {
          btn.menuActivate(1);
        }
      }
    }
  }
}