class Results extends Screen {

  // Fields
  PImage bg;
  PImage avatar;

  // Constructor
  Results() {
    this.bg = loadImage("bg.jpg");
    this.avatar = avatar();
  }
  
  PImage avatar() {
    PGraphics mask;
    PImage avatar;
    avatar=loadImage("avatar.png");
    avatar.resize(height/9, height/9);
    mask = createGraphics(avatar.width, avatar.height);//draw the mask object
    mask.beginDraw();
    mask.ellipse(avatar.width/2, avatar.height/2, avatar.width, avatar.height);
    mask.endDraw();
    avatar.mask(mask);
    return avatar;
  }

  void gameSetup() {
    sm = new Parse();
    parse();
    surface.setResizable(false);
    minim.stop();
    song.close();
  }

  void gameDraw() {

    image(bg, width/2, height/2, width, height);
    filter(BLUR, 5);

    fill(0, 150); 
    rect(0, 0, width, height*0.15);

    fill(0, 100); 
    rect(0, height*0.15, width, height);

    stroke(255);
    strokeWeight(width/220);
    ellipse(width/2, height*0.15, height/9, height/9);
    noStroke();
    image(avatar, width/2, height*0.15);  

    fill(255, 100); 
    rectMode(CENTER);
    rect(width/2, height*0.42, width/1.3, 1);
    rectMode(CORNER);

    fill(255);
    textAlign(LEFT, CENTER);
    textFont(basic, height/18);
    text(sm.artist+" - "+sm.title, width*0.15/10, height*0.15/5);
    textFont(basic, height/40);
    text(sm.subtitle, width*0.15/10, height*0.15/5+height/18);

    Date d = new Date();
    long epoch = d.getTime();
    String date = new java.text.SimpleDateFormat("dd-MM-yyyy").format(new java.util.Date (epoch));
    textFont(basic, height/35);
    text(date, width*0.88, height*0.09);
    textFont(basic, height/45);
    text("date", width*0.88, height*0.12);

    textFont(basic, height/35);
    text(sm.difficulties[0][sm.selectedDifficulty], width*0.77, height*0.09);
    textFont(basic, height/45);
    text("difficulty", width*0.77, height*0.12);

    textFont(basic, height/35);
    text(sm.credit, width*0.58, height*0.09);
    textFont(basic, height/45);
    text("stepartist", width*0.58, height*0.12);

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

    fill(255, 150);
    textFont(basic_bold, height/1.6);
    text("A+", width/2, height);
  }
}