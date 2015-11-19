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
    
    fill(255, 20); 
    rect(width/8,0,width/4,height);
    
    selectP5.draw();

    drawBanner();
  }
}