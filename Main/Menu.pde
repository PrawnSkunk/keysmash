class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    super.screenSetup();
    btn.setupMenuSelection();
  }
  void screenDraw() {
    super.screenDraw();
    translation();
    display();
    //loopMusic();
  }
  // move the octagon
  void translation() {
    if ((transitionTimerIn != 0 || transitionTimerIn != 0) && octPos > -200) {
      octPos -= 20;
    }
  }
  void display() {
    drawBackground();
    cp5Menu.draw();
    btn.drawMenuLabels();
    drawBanner();
  }
}