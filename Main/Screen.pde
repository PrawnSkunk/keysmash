class Screen {

  // Constructor
  Screen() {
  }

  // Functionality
  void display() {
    fill(25);
    rect(0, 0, width, height);
  }

  void gameMenuSetup() {
    minim.stop();
    song.close();
  }

  void gameMenuDraw() {
    background(25);
  }

  void gamePlaySetup() {
    arrowAL = new ArrayList<Arrow>();
    receptorAL = new ArrayList<Receptor>();
    transmitterAL = new ArrayList<Transmitter>();
    grid = new PVector[]{ new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, -1), new PVector(-1, 1), new PVector(1, -1), new PVector(1, 1) };
    keys = new char[]{ '4', '2', '8', '6', '7', '1', '9', '3' };
    pressed = new boolean[keys.length];
    sm = new Parse();
    parse();
    gridSetup();
    loadAudio();
  }

  void gamePlayDraw() {
    time = getTime();
    scn.display();
    spawnNotes();
    drawObjects();
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

  // Load and play audio
  void loadAudio() {
    song = minim.loadFile(songname+"/"+songname+".mp3");
    song.rewind();
    song.play();
  }

  // Parse note data
  void parse() {
    sm.run(songname+"/"+songname+".sm");
  }

  // Instantiate stationary objects
  void gridSetup() {
    for (int i = 0; i < grid.length; i++) {
      float[] gridArr = grid[i].array();
      receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius));
      transmitterAL.add(new Transmitter(gridArr[0]*width, gridArr[1]*height));
    }
  }

  // Current time
  float getTime() {
    float currTime = (float)millis()-timeSinceLastStateSwitch;
    return (float)((currTime/1000)+sm.offset+(speedmod/40));
  }

  // Execute note data
  void spawnNotes() {
    for (int i=0; i<grid.length; i++) {
      for (int j=0; j<sm.notes[i].length; j++) {
        if (sm.notes[i][j] - time < 0.00833 && sm.notes[i][j] - time > -0.00833) {
          // spawn note at respective transmitter
          float[] gridArr = grid[i].array();
          arrowAL.add(new Arrow(gridArr[0]*width, gridArr[1]*height, -gridArr[0]*speedmod, -gridArr[1]*speedmod));
          sm.notes[i][j] = 0;
        }
      }
    }
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