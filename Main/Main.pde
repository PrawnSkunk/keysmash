// Import libraries //<>//
import ddf.minim.*;
import controlP5.*;
import java.util.Date;
import java.util.Arrays;

// Declare class objects
File songDir;
Minim minim;
AudioPlayer song;
ControlP5 controlP5;
Buttons btn;
Parse sm;

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
boolean isplaying;
float transitionTimerIn, transitionTimerOut, transitionTimerInMax, transitionTimerOutMax;
boolean canSetupState = false;
boolean canTransitionIn = true;

void setup() { 
  size(800, 600);
  frameRate(60);
  setupSongs();
  setupSettings();
  setupState();
  btn.setupButtons();
}

void draw() {
  setupStateFlag();
  drawCalibrate();
  drawState();
  transitionIn();
  transitionOut();
}

// Is transition out done?
void setupStateFlag(){
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
  songname = songList[0];
  sm = new Parse();
  sm.run("/songs/"+songname+"/"+songname+".sm");
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
  surface.setResizable(false); 

  // Objects must be in setup()
  minim = new Minim(this);
  controlP5 = new ControlP5(this);
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
  if (theControlEvent.isTab()) {
    transition(theControlEvent.getTab().getId());
  }
}