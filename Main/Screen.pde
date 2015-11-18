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

  // Parse note data
  void parse() {
    sm = new Parse();
    sm.run("/songs/"+songList[lastvalue]+"/"+songList[lastvalue]+".sm");
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

  // Current time
  // Make X smaller in X*framecount for the notes to arrive ealier
  float getTime() {
    float currTime = (float(millis())-timeSinceLastStateSwitch)+(sm.offset*1000)+manualOffset+250;//+(-0.5*frameCount);
    return (float)((currTime));
  }
  
    void drawBackground() {
    if (background == null) { 
      background = loadImage("/assets/gradient-01.jpg");
    } 
    image(background, width/2, height/2, width, height);
  }
  
  /********* JUKEBOX *********/

  void loadMusic() {
    if(firstLoad==true) { song = minim.loadFile("/songs/"+songname+"/"+songname+".mp3"); }
    else { song = minim.loadFile("/songs/"+songList[lastvalue]+"/"+songList[lastvalue]+".mp3"); }
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
      song = minim.loadFile("/songs/"+songList[i]+"/"+songList[i]+".mp3");
      // Set loop points if there is no sample cue in .sm data
      cue = (int)(sm.sampleStart*1000);
      duration = (int)(sm.sampleLength*1000);
      if (cue == 0) {
        cue = 46*1000;
        duration = 20*1000;
      } 
      fadeIn();
  }
  void drawBanner(){
       fill(20);
    rect(0, 0, width, height*0.045);
    // Main song information
    fill(255);
    textAlign(LEFT, CENTER);
    textFont(debug, height/45);
    text(sm.artist+" - "+sm.title+", Difficulty "+sm.difficulties[0][0], width*0.01, height*0.02); 
  }

  // Shift gain from -80dB to 0dB at loop start point
  void fadeIn() {
    song.pause();
    song.rewind();
    song.setLoopPoints(cue, cue+duration);
    song.shiftGain(-40.0, 0, 1*1000); // 3 second fade in
    song.play();
    song.loop();
  }

  // Shift gain from 0dB to -80dB at loop end point
  void fadeOut() {
    song.shiftGain(0, -40.0, 1*1000); // 4 second fade out
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