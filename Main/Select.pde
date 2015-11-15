class Select extends Screen {

  // Constructor
  Select() {
  }

  void screenSetup() {
    super.screenSetup();
    if(song.isPlaying() == false) loadMusic();
  }
  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
    
  }
  void display() {
    background(100);
    
    image(background, width/2, height/2, width, height);
    //filter(BLUR, 5);
    fill(0, 100); 
    rect(0,0,width,height);
    
    fill(255);
    textAlign(CENTER,CORNER);
    textFont(basic, height/5);
    text("Song Select",width/2,height/2);
    
        fill(20);
    rect(0,0,width,height*0.045);
    // Main song information
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, height/45);
    text("\uf04b"+sm.artist+" - "+sm.title, width*0.01, height*0.02);
  }
}