class Results extends Screen {

  // Fields
  PImage bg, avatar;
  PGraphics mask;

  // Constructor
  Results() {
    //this.bg = loadImage("/songs/"+sm.title+"/"+background);
    this.avatar = loadImage("/assets/avatar.png");
  }

  /********* MAIN FUNCTIONS *********/

  void screenSetup() {
    super.screenSetup();
    song.pause();
    //loadMusic();    
  }

  void screenDraw() {
    super.screenDraw();
    //loopMusic();
    drawMe();
  }

  /********* RESULTS SCREEN *********/

  // Ellipse mask avatar image
  PImage maskAvatar() {
    avatar = loadImage("assets/avatar.png");
    avatar.resize(height/9, height/9);
    mask = createGraphics(height/9, height/9); //draw the mask object
    mask.beginDraw();
    mask.ellipse(avatar.width/2, avatar.height/2, height/9, height/9);
    mask.endDraw();
    avatar.mask(mask);
    return avatar;
  }

  // Draw UI
  void drawMe() {

    image(background, width/2, height/2);

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
    strokeWeight(1);
    noStroke();

    // Line
    fill(255, 255); 
    rectMode(CENTER);
    rect(width/2, height*0.41, width/1.3, 1);
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
    //text(sm.difficulties[0][sm.selectedDifficulty], width*0.77, height*0.09);
    text("?", width*0.77, height*0.09);
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
    textFont(basic_bold, height/1.5);
    text("A+", width/2, height);
  }
}