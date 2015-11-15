class Results extends Screen {

  // Fields
  PImage bg, avatar;
  PGraphics mask;
  int cue, duration;
  boolean isplaying;

  // Constructor
  Results() {
    this.cue = (int)(sm.sampleStart*1000);
    this.duration = (int)(sm.sampleLength*1000);
    this.bg = loadImage(sm.title+"/"+sm.background);
    this.avatar = loadImage("avatar.png");
  }

  /********* MAIN FUNCTIONS *********/

  void screenSetup() {
    minim.stop();
    loadMusic();
  }

  void screenDraw() {
    loopMusic();
    drawMe();
  }

  /********* JUKEBOX *********/

  void loadMusic() {
    song = minim.loadFile(songname+"/"+songname+".mp3");
    // Set loop points if there is no sample cue in .sm data
    if (cue == 0) {
      cue = 46*1000;
      duration = 20*1000;
    } 
    fadeIn();
  }

  // Shift gain from -80dB to 0dB at loop start point
  void fadeIn() {
    song.pause();
    song.rewind();
    song.setLoopPoints(cue, cue+duration);
    song.shiftGain(-80.0, 0, 3*1000); // 3 second fade in
    song.play();
    song.loop();
  }

  // Shift gain from 0dB to -80dB at loop end point
  void fadeOut() {
    song.shiftGain(0, -80.0, 4*1000); // 4 second fade out
  }

  // Decide when to call fadeIn() and fadeOut()
  void loopMusic() {
    if (isplaying == true && song.position() > cue+duration-4000) {
      isplaying = false;
      fadeOut();
    } 
    // start fading in early
    else if (isplaying == false && song.position() > cue+duration-3000) { 
      isplaying = true;
      fadeIn();
    }
  }

  /********* RESULTS SCREEN *********/

  // Ellipse mask avatar image
  PImage maskAvatar() {
    avatar = loadImage("avatar.png");
    avatar.resize(height/9, height/9);
    mask = createGraphics(height/9, height/9); //draw the mask object
    mask.beginDraw();
    mask.ellipse(avatar.width/2, avatar.height/2, height/9, height/9);
    mask.endDraw();
    avatar.mask(mask);
    return avatar;
  }

  void drawBackground() {
    if (bg != null) { 
      image(bg, width/2, height/2, width, height);
    } else { 
      fill(50); 
      rect(0, 0, width, height);
    }
    // Blur does not work when setResizable(true);
    filter(BLUR, 5);
  }

  // Draw UI
  void drawMe() {

    drawBackground();

    // Header
    fill(0, 150); 
    rect(0, 0, width, height*0.15);

    // Body
    fill(0, 100); 
    rect(0, height*0.15, width, height);

    // Avatar
    stroke(255);
    ellipseMode(CENTER);
    strokeWeight(4);
    ellipse(width/2, height*0.15, height/9, height/9);
    image(maskAvatar(), width/2, height*0.15);  
    noStroke();

    // Line
    fill(255, 100); 
    rectMode(CENTER);
    rect(width/2, height*0.42, width/1.3, 1);
    rectMode(CORNER);

    // Main song information
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(basic, height/18);
    text(sm.artist+" - "+sm.title, width*0.15/10, height*0.15/5);
    textFont(basic, height/40);
    text(sm.subtitle, width*0.15/10, height*0.15/5+height/18);

    // Date
    Date d = new Date();
    long epoch = d.getTime();
    String date = new java.text.SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date (epoch));
    textFont(basic, height/35);
    text(date, width*0.88, height*0.09);
    textFont(basic, height/45);
    text("date", width*0.88, height*0.12);
    
    // Difficulty Info
    textFont(basic, height/35);
    text(sm.difficulties[0][sm.selectedDifficulty], width*0.77, height*0.09);
    textFont(basic, height/45);
    text("difficulty", width*0.77, height*0.12);

    // Stepartist Info
    textFont(basic, height/35);
    text(sm.credit, width*0.58, height*0.09);
    textFont(basic, height/45);
    text("stepartist", width*0.58, height*0.12);

    // Score
    textAlign(CENTER, BOTTOM);
    textFont(basic, height/12);
    text(nfc(sm.maxCombo*500), width/2, height*0.32);
    textFont(basic, height/25);
    text("score", width/2, height*0.3+height/15);
    textFont(basic, height/18);
    text("100.00%", width/4.5, height*0.32);
    textFont(basic, height/25);
    text("accuracy", width/4.5, height*0.3+height/15);
    textFont(basic, height/18);
    text(nfc(sm.maxCombo)+"x", width-width/4.5, height*0.32);
    textFont(basic, height/25);
    text("combo", width-width/4.5, height*0.3+height/15);

    // Grade
    fill(255, 200);
    textFont(basic_bold, height/1.6);
    text("A+", width/2, height);
  }
}