class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    super.screenSetup();
    if(millis() > 1000){
      if(song.isPlaying() == false) loadMusic();
    } else{
      loadMusic();
    }
    btn.pressStart();

  }
  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
  }
  void display() {
    background(50);

    image(background, width/2, height/2, width, height);
    //filter(BLUR, 5);
    fill(0, 100); 
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CORNER);
    textFont(basic_bold, height/5);
    text("num lock", width/2, height/2);
    
    textFont(basic_bold, height/20);
    text("an 8-key rhythm game", width/2, height/2+height/15);
    
    fill(20);
    rect(0,0,width,height*0.045);
    // Main song information
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, height/45);
    text("\uf04b"+sm.artist+" - "+sm.title, width*0.01, height*0.02);
  }
}