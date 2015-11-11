class Screen {

  // Constructor
  Screen() {
  }

  // Functionality
  void display() {
    fill(0);
    rect(0, 0, width, height);
  }
  void HUD() {
    float maxWidth = width-height;
    fill(25);
    rect(0, 0, maxWidth/2, height);
    rect(width-maxWidth/2, 0, maxWidth/2, height);
  }

  void gameMenuSetup() {
    surface.setResizable(true);
    minim.stop();
    song.close();
  }

  void gameMenuDraw() {
    
    font = loadFont("Amelia-Basic-48.vlw");
    fill(25); 
    rect(0, 0, width, height*0.15); // Section 1

    fill(50); 
    rect(0, height*0.15, width, height*0.25); // Section 2

    strokeWeight(height/250);
    stroke(255);
    ellipseMode(CENTER);
    ellipse(width/2, height*0.15, height/9, height/9); // Avatar
    noStroke();

    fill(75); 
    rect(0, height*0.4, width, height*0.6); // Section 3

    fill(255); 
    textAlign(LEFT, CENTER);
    textFont(font, height/25);
    text(songname, height*0.15/4, height*0.15/3);

    textAlign(CENTER, BOTTOM);
    textFont(font, height/12);
    text("1,000,000", width/2, height*0.32);
    textFont(font, height/25);
    text("score", width/2, height*0.3+height/15);
    textFont(font, height/18);
    text("100.00%", width/4, height*0.32);
    textFont(font, height/25);
    text("accuracy", width/4, height*0.3+height/15);
    textFont(font, height/18);
    text("1,000x", width-width/4, height*0.32);
    textFont(font, height/25);
    text("combo", width-width/4, height*0.3+height/15);
    
    font = loadFont("Amelia-Basic-Bold-255.vlw");
    textFont(font, height/1.8);
    text("S", width/2, height);
    
  }

  void gamePlaySetup() {
    surface.setResizable(true);
    arrowAL = new ArrayList<Arrow>();
    receptorAL = new ArrayList<Receptor>();
    transmitterAL = new ArrayList<Transmitter>();
    grid = new PVector[]{ new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, -1), new PVector(-1, 1), new PVector(1, -1), new PVector(1, 1) };
    keys = new char[]{ '4', '2', '8', '6', '7', '1', '9', '3' };
    rotations = new int[]{2, 0, 4, 6, 3, 1, 5, 7};
    //rotations = new int[]{6,4,0,2,7,5,1,3};
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
    HUD();
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
      receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius, rotations[i]));
      transmitterAL.add(new Transmitter(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8));
    }
  }

  // Current time
  float getTime() {
    float currTime = (float)millis()-timeSinceLastStateSwitch;
    return (float)((currTime/1000)+sm.offset+(speedmod/30));
  }

  // Execute note data
  void spawnNotes() {
    for (int i=0; i<grid.length; i++) {
      for (int j=0; j<sm.notes[i].length; j++) {
        if (sm.notes[i][j] - time < 0.00833 && sm.notes[i][j] - time > -0.00833) {
          // spawn note at respective transmitter
          float[] gridArr = grid[i].array();
          arrowAL.add(new Arrow(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8, -gridArr[0]*speedmod, -gridArr[1]*speedmod, rotations[i]));
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