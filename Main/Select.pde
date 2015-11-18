class Select extends Screen {

  // Constructor
  Select() {
  }

  void screenSetup() {
    super.screenSetup();
    if (song.isPlaying() == false) loadMusic();

    fill(255);
    textAlign(CENTER, CORNER);
  }

  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
  }

  void display() {
    background(100);

    drawBackground();
    //filter(BLUR, 5);
    fill(0, 100); 
    rect(0, 0, width, height);
    
    selectP5.draw();

    fill(255); 
    textAlign(CENTER, CORNER);
    textFont(basic, height/15);
    text("Song Select", width/2, height/8);

    drawBanner();
  }
}