class Input {

  Input() {
  }

  // Callbacks
  void keyPressed() {
    // Escape
    if (key == ESC) key = BACKSPACE;

    // Enter
    if (key == ENTER) {
      if (state == GAME_MENU) screenAL.get(state).transition(state+1);
      else if (state == GAME_SELECT) screenAL.get(state).transition(state+1);
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
    } 

    // Song Selection
    else if (key == CODED && state == GAME_SELECT) {
      if (key == CODED && keyCode == UP) {
        if (value > 0) {
          btn.radioActivate(-1);
        }
      }
      if (key == CODED && keyCode == DOWN) {
        if (value < songList.length-1) {
          btn.radioActivate(1);
        }
      }
    }
  }
  
}