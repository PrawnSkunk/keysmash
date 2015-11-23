class Title extends Screen {

  Title() {
  }

  void screenSetup() {
    super.screenSetup();
    btn.setupSongSelection();
    //radioPlay();
    if (firstTitleLoad == true) {
      song = minim.loadFile("/assets/Amanecer/Amanecer.mp3");
      song.play();
      song.loop();
      menuSongPlaying = true;
    } else {
      if (song.isPlaying() == false) 
      {
        loadMusic();
      }
    }
    firstTitleLoad = false;
  }
  void screenDraw() {
    super.screenDraw();
    translation();
    display();
  }
  void translation() {
    if ((transitionTimerIn != 0 || transitionTimerIn != 0) && octPos < 0) {
      octPos += 20;
    }
  }
  void display() {
    drawBackground();

    fill(255, frameCount*1.5);
    textAlign(CENTER, CORNER);
    textFont(basic_bold, height/5);
    text("KeySmash", width/2, height/2);

    fill(255, frameCount*1.5-150);
    textFont(basic_bold, height/22);
    text("advanced finger dancing game", width/2+width/8.8, height/2+height/20);

    drawBanner();
  }
}