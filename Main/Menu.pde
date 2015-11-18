class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    super.screenSetup();
    controlP5.hide(1);
    btn.setupSongSelection();
    if (millis() > 1000) {
      if (song.isPlaying() == false) loadMusic();
    } else {
      loadMusic();
    }
    //btn.pressStart();
  }
  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
  }
  void display() {
    background(50);

    if (background == null) background = loadImage("/assets/gradient-01.jpg");
    image(background, width/2, height/2, width, height); 
    //filter(BLUR, 5);
    fill(0, 100); 
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CORNER);
    textFont(basic_bold, height/5);
    text("KeySmash", width/2, height/2);

    textFont(basic_bold, height/20);
    text("advanced finger dancing game", width/2, height/2+height/10);

    drawBanner();
  }
}