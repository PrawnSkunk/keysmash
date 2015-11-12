class Screen {

  // Constructor
  Screen() {
  }

  void screenSetup() {
    return;
  }
  void screenDraw() {
    return;
  }

  // Parse note data
  void parse() {
    sm.run(songname+"/"+songname+".sm");
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
    return (float)((currTime/1000)+sm.offset-0.2);
  }
}