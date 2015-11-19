class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    super.screenSetup();
    controlP5.hide(1);
    btn.setupMenu();
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

   menuP5.draw();
   
    fill(255,200);
    textAlign(CENTER, CORNER);
    textFont(basic_bold, height/5);
    text("KeySmash", width/2, height/2.3);

    fill(255,100);
    textFont(basic_bold, height/22);
    text("advanced finger dancing game", width/2+width/8.5, height/2.3+height/20);
    
    fill(255,200);
    textFont(basic, height/30);
    text("< press enter >", width/2, height/1.7);

    drawBanner();
  }
}