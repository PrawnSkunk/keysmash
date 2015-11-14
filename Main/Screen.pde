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
  // Make X smaller in X*framecount for the notes to arrive ealier
  float getTime() {
    float currTime = (float(millis())-timeSinceLastStateSwitch)+(sm.offset*1000)+manualOffset;//+(-0.5*frameCount);
    return (float)((currTime));
  }
}