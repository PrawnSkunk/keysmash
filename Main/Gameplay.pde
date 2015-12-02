class Gameplay extends Screen {

  int count;

  Gameplay() {
  }

  void screenSetup() {
    super.screenSetup();
    rawScore = 0;
    score = 0;
    count = 0;
    goal = 0;
    arrowAL = new ArrayList<Arrow>();
    receptorAL = new ArrayList<Receptor>();
    transmitterAL = new ArrayList<Transmitter>();
    grid = new PVector[]{ new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, -1), new PVector(-1, 1), new PVector(1, -1), new PVector(1, 1) };
    keys = new char[]{ '4', '2', '8', '6', '7', '1', '9', '3' };
    keys2 = new char[]{ 'a', 'x', 'w', 'd', 'q', 'z', 'e', 'c' };
    rotations = new int[]{2, 0, 4, 6, 3, 1, 5, 7};
    pressed = new boolean[keys.length];
    parseStepfile(value, true);
    gridSetup();
    loadAudio();
    timeSinceLastStateSwitch = float(millis());
  }

  void HUD() {
    float maxWidth = width-height;
    noStroke();
    fill(255);
    rect(0, 0, maxWidth/2.2+1, height);
    rect(width-maxWidth/2.2-1, 0, maxWidth/2.2, height);
    fill(10);
    rect(0, 0, maxWidth/2.2, height);
    rect(width-maxWidth/2.2, 0, maxWidth/2.2, height);
    fill(0);
    vis.polygon(width/2, height/2, 46);
    noStroke();
    textAlign(CENTER, CENTER);
    fill(80);
    textFont(basic, 30);
    text(score, width/2, height/2-15);
    fill(40);
    textFont(basic, 18);
    text("combo", width/2, height/2+8);

    // Song Progression (auto)
    /*
    float songProg = ((float)song.position()/song.length()*100);
     fill(255, 20);
     rect(100, 30, 100*2, 20);
     fill(255, 60);
     rect(100, 30, songProg*2, 20);
     textAlign(LEFT);
     text("Song Progress:", 100, 30-10);
     */

    // Text
    textAlign(CENTER);
    textFont(basic, 14);
    fill(50, 50, 255, 130);
    text("Player", 755, 420);
    fill(50, 255, 50, 130);
    text("Rank S", 755, 440);
    fill(255);
    stroke(255);
    text("F", 720+4, 400-2);
    line(720, 400, 785, 400);
    text("E", 720+4, 400-(30*3)-2);
    line(720, 400-(30*3), 785, 400-(30*3));
    text("D", 720+4, 400-(50*3)-2);
    line(720, 400-(50*3), 785, 400-(50*3));
    text("C", 720+4, 400-(67*3)-2);
    line(720, 400-(67*3), 785, 400-(67*3));
    text("B", 720+4, 400-(80*3)-2);
    line(720, 400-(80*3), 785, 400-(80*3));
    text("A", 720+4, 400-(92*3)-2);
    line(720, 400-(92*3), 785, 400-(92*3));
    text("S", 720+4, 400-(100*3)-2);
    line(720, 400-(100*3), 785, 400-(100*3));

    noStroke();

    // Score progression
    float scoreProg = ((float)rawScore/sm.maxCombo*100);
    fill(50, 50, 255, 40);
    rect(730, 400, 20, -100*3);
    fill(50, 50, 255, 200);
    rect(730, 400, 20, -scoreProg*3);
    textAlign(LEFT);

    // Goal progression
    float goalProg = ((float)goal/sm.maxCombo*100);
    fill(50, 255, 50, 40);
    rect(760, 400, 20, -100*3);
    fill(50, 255, 50, 200);
    rect(760, 400, 20, -goalProg*3);
    textAlign(LEFT);
  }

  // Execute note data to spawn note at respective transmitter
  void spawnNotes() {

    time = getTime();

    // for the length of the array (sm.notes = [8][1.1248313][3.0])
    for (int i=count; i<sm.notes.length; i++) {

      if (sm.notes[i].length > 0 && sm.notes[i][0] > 0) {

        index = (int)sm.notes[i][1];
        float[] gridArr = grid[index].array();

        if (time - sm.notes[i][0]*1000 < 0 && time - sm.notes[i][0]*1000 > -1000) {  
          arrowAL.add(new Arrow(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8, -gridArr[0]*speedmod, -gridArr[1]*speedmod, rotations[index]));
          sm.notes[i][0] = 0;
          count++;
        }
      }
    }
  }
  void screenDraw() {
    super.screenDraw();
    background(0);
    vis.drawVisualization();
    spawnNotes();
    drawObjects();
    HUD();
    if (song.isPlaying() == false) transition(GAME_RESULT);
  }

  // Load and play audio
  void loadAudio() {
    minim.stop();
    song = minim.loadFile("/songs/"+songList[value]+"/"+sm.music);
    song.rewind();
    song.play();
  }

  // Instantiate stationary objects
  void gridSetup() {
    for (int i = 0; i < grid.length; i++) {
      float[] gridArr = grid[i].array();
      receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius, rotations[i]));
      transmitterAL.add(new Transmitter(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8));
    }
  }
}