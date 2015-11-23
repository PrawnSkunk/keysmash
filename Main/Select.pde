class Select extends Screen {

  int difficulties, maxDifficulty;
  
  // Constructor
  Select() {
    maxDifficulty = 13;
  }

  void screenSetup() {
    
    super.screenSetup();
    //loadMusic();
    parse();

    fill(255);
    textAlign(CENTER, CORNER);
  }

  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
    radioPlay();
    translation();
  }
    void translation() {
    if ((transitionTimerIn != 0 || transitionTimerIn != 0) && octPos > -200) {
      octPos -= 20;
    }
  }
  void display() {
    drawBackground();
    
    fill(255);
    textFont(basic_bold,22);
    textAlign(CENTER,CENTER);
    text(sm.title,width/4,height/2-height/16);
    textFont(basic,18);
    text(sm.artist,width/4,height/2-height/32);
    textFont(basic_bold,25);
    textAlign(LEFT,CENTER);
    text("Difficulty "+sm.difficulties[0][0],width/5.9,height/2+height/32);
    for (difficulties=0; difficulties<int(sm.difficulties[0][0]); difficulties++){
        rect(width/5.8+(10*difficulties),height/2+height/16,9,12);
    }
    while (difficulties < maxDifficulty){
        fill(255,50);
        rect(width/5.8+(10*difficulties),height/2+height/16,9,12);
        difficulties++;
    }

    cp5Select.draw();
    btn.drawSelectLabels();
    drawBanner();
  }
}