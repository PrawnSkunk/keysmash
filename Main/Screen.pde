class Screen {

  // Constructor
  Screen() {
  }

  void screenSetup() {
    canTransitionIn = true;
  }

  void screenDraw() {
    if (canTransitionIn == true) {
      transitionTimerIn = transitionTimerInMax;
      canTransitionIn = false;
    }
  }

  void radioPlay() {
    if (radioTimer < 0 && radioCanPlay == true) {
      screenAL.get(GAME_SELECT).loadMusic(value); 
      radioCanPlay = false;
    }
    radioTimer--;
  }

  void drawObjects() {

    // Update Receptors
    for (int i=0; i<grid.length; i++) {
      receptorAL.get(i).update();
    }
    // Update Arrows
    for (int i=0; i<arrowAL.size(); i++) {
      arrowAL.get(i).update();
    }
  }


  void drawBackground() {
    if (background == null) { 
      background = loadImage("/assets/gradient-01.jpg");
    } 
    background(50);
    image(background, width/2, height/2);
    fill(0, 100); 
    rect(0, 0, width, height);
    vis.drawVisualization(int(octPos));
  }

  /********* JUKEBOX *********/

  void loadMusic() {
    song = minim.loadFile("/songs/"+songList[value]+"/"+sm.music);
    // Set loop points if there is no sample cue in .sm data
    cue = (int)(sm.sampleStart*1000);
    duration = (int)(sm.sampleLength*1000);
    if (cue == 0) {
      cue = 46*1000;
      duration = 20*1000;
    } 
    fadeIn();
  }
  void loadMusic(int i) {
    fadeOut();
    song = minim.loadFile("/songs/"+songList[i]+"/"+sm.music);
    // Set loop points if there is no sample cue in .sm data
    cue = (int)(sm.sampleStart*1000);
    duration = (int)(sm.sampleLength*1000);
    if (cue == 0) {
      cue = 46*1000;
      duration = 20*1000;
    } 
    fadeIn();
  }

  void drawBanner() {
    fill(20);
    //rect(0, 0, width, height*0.075);
    rect(0, height, width, -height*0.075);

    //SFU Logo
    fill(#c51230);
    rect(0, height, 85, -height*0.075);
    fill(255);
    textAlign(LEFT, LEFT);
    textFont(basic_bold, height/25);
    text("SFU", 39, height-6);

    // Main song information
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(basic_bold, height/28);
    text("Max Proske", 95, height-32);
    textFont(basic, height/48);
    text(menuDescription[state], 95, height-13);
    text("Start: ENTER", 230, height-37);
    text("Back: ESC", 230, height-24);
    text("Restart: /", 230, height-11);
    text("Laptop controls: QWE AD ZXC", 310, height-24);
    text("Desktop controls: 789 46 123", 310, height-11);
  }

  // Shift gain from -80dB to 0dB at loop start point
  void fadeIn() {
    song.pause();
    song.rewind();
    song.setLoopPoints(cue, cue+duration);
    song.shiftGain(-80.0, 0, 1*1000); // 3 second fade in
    song.play();
    song.loop();
  }

  // Shift gain from 0dB to -80dB at loop end point
  void fadeOut() {
    song.shiftGain(0, -80.0, 1*1000); // 4 second fade out
  }

  // Decide when to call fadeIn() and fadeOut()
  void loopMusic() {
    if (isplaying == true && song.position() > cue+duration-1000) {
      isplaying = false;
      fadeOut();
    } 
    // start fading in early
    else if (isplaying == false && song.position() > cue+duration-200) { 
      isplaying = true;
      fadeIn();
    }
  }
}