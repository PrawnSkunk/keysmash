// Import libraries //<>//
import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;
import java.util.Date;
import java.util.Arrays;

// Declare class objects
File songDir;
Minim minim;
AudioPlayer song;
ControlP5 controlP5, selectP5, menuP5;
Buttons btn;
Parse sm;
RadioButton radio;

// Declare array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Transmitter> transmitterAL;
ArrayList<Screen> screenAL;

// Initialize game state constants
final int GAME_MENU = 0;
final int GAME_SELECT = 1;
final int GAME_PLAY = 2;
final int GAME_RESULT = 3;

// Declare common global variables
PVector[] grid; // Receptor column position
int[] rotations; // Receptor rotation position
boolean[] pressed; // Current keys pressed
char[] keys; // Input keybinds
String[] songList; // List of folders in /data/songs/
String songname;
float receptorRadius, speedmod, timeSinceLastStateSwitch, time, manualOffset;
PFont basic, basic_bold, debug;
PImage background;
int index, state;
int cue, duration;
boolean isplaying = true;
float transitionTimerIn, transitionTimerOut, transitionTimerInMax, transitionTimerOutMax;
boolean canSetupState = false;
boolean canTransitionIn = true;
boolean firstLoad = true;
boolean firstSelectLoad = true;
int value, lastvalue;
int radioValue;
boolean navigating = false;
float navigationTimer = 0;

// New!
AudioMetaData meta;
BeatDetect beat;
int  r = 200;
float rad = 70;

void setup() { 
  size(800, 600);
  frameRate(60);
  setupSongs();
  setupSettings();
  setupState();
  btn.setupButtons();
  setupVizualization();
}

void draw() {
  setupStateFlag();
  drawCalibrate();
  drawState();
  drawVisualization();
  transitionIn();
  transitionOut();
}

// Is transition out done?
void setupStateFlag() {
  if (canSetupState == true) {
    setupState();
    canSetupState = false;
  }
}

// Calibrate events to window dimensions
void drawCalibrate() {
  speedmod = height/50;
  manualOffset = -speedmod*58.333; //-700 offset with 600px height
}

// Load songs directory and run parser
void setupSongs() {
  songDir = new File(dataPath("/songs/"));
  songList = songDir.list();
  value = lastvalue = (int)random(0, songList.length);
  songname = songList[value];
  sm = new Parse();
  sm.header("/songs/"+songname+"/"+songname+".sm");
}

void transitionIn() {
  if (transitionTimerIn>0) {
    fill(0, transitionTimerIn*(255/transitionTimerInMax));
    rect(0, 0, width, height);
    transitionTimerIn--;
  }
}
void transitionOut() {
  if (transitionTimerOut>0) {
    fill(0, 255-transitionTimerOut*(255/transitionTimerOutMax));
    rect(0, 0, width, height);
    transitionTimerOut--;
  }
}

// Main skecth settings
void setupSettings() { 
  smooth();
  noStroke();
  imageMode(CENTER);

  // Can the window be resized?
  surface.setResizable(true); 

  // Objects must be in setup()
  minim = new Minim(this);
  controlP5 = new ControlP5(this);

  selectP5 = new ControlP5(this);
  //selectP5.setControlFont(new ControlFont(createFont("Georgia", 20), 20));
  //PFont f = createFont("Arial",9);
  //menuP5.setControlFont(f);

  menuP5 = new ControlP5(this);
  btn = new Buttons();

  // Setup states
  screenAL = new ArrayList<Screen>();
  screenAL.add(new Menu());
  screenAL.add(new Select());
  screenAL.add(new Gameplay());
  screenAL.add(new Results());

  // Load fonts
  debug = createFont("/assets/Amelia-Basic.ttf", 18, true); 
  basic = createFont("/assets/Amelia-Basic.ttf", 200, true); 
  basic_bold = createFont("/assets/Amelia-Basic-Bold.ttf", 600, true);

  // Space between receptors
  receptorRadius = 72.0;

  // transition in/out times (in frames)
  transitionTimerInMax = transitionTimerOutMax = 20;
}

// Called once by setup()
void setupState() {
  switch(state) {
  case GAME_MENU:
    screenAL.get(GAME_MENU).screenSetup();
    break;
  case GAME_SELECT:
    screenAL.get(GAME_SELECT).screenSetup();
    break;
  case GAME_PLAY: 
    screenAL.get(GAME_PLAY).screenSetup();
    break;
  case GAME_RESULT:
    screenAL.get(GAME_RESULT).screenSetup(); 
    break;
  }
}

// Called every frame by draw()
void drawState() {
  if (transitionTimerOut == 0) {
    switch(state) {
    case GAME_MENU:
      screenAL.get(GAME_MENU).screenDraw();
      break;
    case GAME_SELECT:
      screenAL.get(GAME_SELECT).screenDraw();
      break;
    case GAME_PLAY: 
      screenAL.get(GAME_PLAY).screenDraw();
      break;
    case GAME_RESULT:
      screenAL.get(GAME_RESULT).screenDraw(); 
      break;
    }
  }
}

void transition(int s) {
  transitionTimerOut = transitionTimerOutMax;
  state = s;
  canSetupState = true;
}

// Called by .activateEvent(true) in Buttons class
void controlEvent(ControlEvent theControlEvent) {
  /*
  if (theControlEvent.isTab()) {
   transition(theControlEvent.getTab().getId());
   }
   */
  if (theControlEvent.isGroup()) {
    lastvalue = value;
    value = (int)theControlEvent.getValue();
    if (value >= 0) {
      sm = new Parse();
      sm.header("/songs/"+songList[value]+"/"+songList[value]+".sm");
      screenAL.get(GAME_SELECT).loadMusic(value);
      selectP5.setPosition(width/8,120-value*41);
    } else {
      // value is -1
      transition(GAME_PLAY);
    }
  } else if (theControlEvent.getController().getName().equals("bang")) {
    transition(GAME_SELECT);
  }
}
// Current time
// Make X smaller in X*framecount for the notes to arrive ealier
float getTime() {
  float currTime = (float(millis())-timeSinceLastStateSwitch)+(sm.offset*1000)+manualOffset+250;//+(-0.5*frameCount);
  return (float)((currTime));
}
void keyPressed() {
  if (key == ESC) {
    key = BACKSPACE;
  }

  // Override
  if (key == '!')transition(state+1);

  // Enter
  if (key == ENTER) {
    if (state == GAME_MENU) transition(state+1);
    else if (state == GAME_SELECT) {
      transition(state+1);
    }
  }

  // Restart
  if (key == '/') {
    if (state == GAME_PLAY) transition(GAME_PLAY);
    else if (state == GAME_RESULT) transition(GAME_PLAY);
  }

  // Quit
  if (key == CODED && keyCode == CONTROL) {
    if (state == GAME_PLAY) transition(GAME_RESULT);
    else if (state == GAME_RESULT) transition(GAME_SELECT);
    else if (state == GAME_SELECT) transition(GAME_MENU);
  }
  if (key == CODED) {
    if (getTime()-navigationTimer > 900) {
      navigationTimer = getTime();
      if (key == CODED && keyCode == UP) {
        if (value > 0) radio.activate(songList[--value]);
      }
      if (key == CODED && keyCode == DOWN) {
        if (value < songList.length-1) radio.activate(songList[++value]);
      }
    }
  }
}

void setupVizualization() {
  beat = new BeatDetect();
}

void drawVisualization() {
  pushMatrix();
  float t = map(mouseX, 0, width, 0, 1);
  beat.detect(song.mix);
  fill(#1A1F18, 10);
  noStroke();
  translate(width/2, height/2);
  noFill();
  fill(-1, 10);
  if (beat.isOnset()) rad = rad*0.9;
  else rad = 70;
  ellipse(0, 0, 4*rad, 4*rad);
  stroke(-1, 15);
  int bsize = song.bufferSize();
  for (int i = 0; i < bsize - 1; i+=5)
  {
    float x = (r)*cos(i*2*PI/bsize);
    float y = (r)*sin(i*2*PI/bsize);
    float x2 = (r + song.left.get(i)*100)*cos(i*2*PI/bsize);
    float y2 = (r + song.left.get(i)*100)*sin(i*2*PI/bsize);
    strokeWeight(1);
    line(x, y, x2, y2);
  }
  beginShape();
  noFill();
  stroke(-1, 20);
  for (int i = 0; i < bsize; i+=30)
  {
    float x2 = (r + song.left.get(i)*100)*cos(i*2*PI/bsize);
    float y2 = (r + song.left.get(i)*100)*sin(i*2*PI/bsize);
    vertex(x2, y2);
    pushStyle();
    stroke(-1,10);
    strokeWeight(2);
    point(x2, y2);
    popStyle();
  }
  endShape();
  popMatrix();
}