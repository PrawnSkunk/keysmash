class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    super.screenSetup();
    btn.setupSongSelection();
    radioPlay();
    if (firstMenuLoad == true) {
      loadMusic();
    } else {
      if (song.isPlaying() == false) 
      {
        loadMusic();
      }
    }
    firstMenuLoad = false;
  }
  void screenDraw() {
    super.screenDraw();
    display();
    loopMusic();
  }
  void display() {
    background(50);

    drawBackground();

    //filter(BLUR, 5);
    fill(0, 100); 
    rect(0, 0, width, height);
    vis.drawVisualization();
    cp5Menu.draw();

    fill(255);
    textAlign(CENTER, CORNER);
    textFont(basic_bold, height/5);
    text("KeySmash", width/2, height/2.3);

    fill(255, 175);
    textFont(basic_bold, height/22);
    text("advanced finger dancing game", width/2+width/8.5, height/2.3+height/20);

    fill(255);
    textFont(basic, height/30);
    text("< press enter >", width/2, height/1.7);

    drawBanner();
  }
}