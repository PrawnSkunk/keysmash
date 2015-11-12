class Screen {

  // Constructor
  Screen() {
  }
  
  void gameSetup(){}
  void gameDraw(){}

  // Parse note data
  void parse() {
    sm.run(songname+"/"+songname+".sm");
  }
  
  // Functionality
  void display() {
    fill(0);
    rect(0, 0, width, height);
  }

  void drawObjects() {

    // Update Receptors
    for (int i=0; i<grid.length; i++) {
      receptorAL.get(i).update();
    }
    // Update Arrows
    for (int i=0; i<arrowAL.size(); i++) {
      arrowAL.get(i).update();
    }
  }

  // Current time
  float getTime() {
    float currTime = (float)millis()-timeSinceLastStateSwitch;
    return (float)((currTime/1000)+sm.offset+(speedmod/30));
  }

  void keyPressed() {
    for (int i=0; i < keys.length; i++) {
      if (key == keys[i]) {
        pressed[i] = true;
      }
    }
  }

  void keyReleased() {
    for (int i=0; i < keys.length; i++) {
      if (key == keys[i]) {
        pressed[i] = false;
      }
    }
  }
}