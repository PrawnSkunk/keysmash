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
ControlP5 cp5, cp5Select, cp5Menu;
Buttons btn;
Parse sm;
RadioButton radio, menu;
Visualization vis;
Audio audio;
Input input;
Group g1, g2;

// Declare array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Transmitter> transmitterAL;
ArrayList<Screen> screenAL;

// Initialize game state constants
final int GAME_TITLE = 0;
final int GAME_MENU = 1;
final int GAME_SELECT = 2;
final int GAME_PLAY = 3;
final int GAME_RESULT = 4;

// Declare common global variables
PVector[] grid; // Receptor column position
int[] rotations; // Receptor rotation position
boolean[] pressed; // Current keys pressed
char[] keys; // Input keybinds
String[] songList; // List of folders in /data/songs/
String[] menuList;
float receptorRadius, speedmod, timeSinceLastStateSwitch, time, manualOffset, transitionTimerIn, transitionTimerOut, transitionTimerInMax, transitionTimerOutMax, navigationTimer, radioTimer;
int index, state, cue, duration, value, lastvalue, valueMenu, lastvalueMenu, score;
PFont basic, basic_bold, debug;
PImage background;
String songname;
boolean isplaying = true;
boolean canTransitionIn = true;
boolean firstTitleLoad = true;
boolean firstMenuLoad = true;
boolean firstSelectLoad = true;
boolean radioCanPlay = true;
boolean menuSongPlaying = true;
float octPos;

void setup() { 
  size(800, 600);
  smooth();
  noStroke();
  imageMode(CENTER);
  setupProgram();
}

void draw() {
  drawState();
  vis.drawTransitions();
}

void setupProgram() {
  setupSongDirectory();
  setupSettings();
  setupState();
  vis.setupVizualization();
}

// Load songs directory and run parser
void setupSongDirectory() {
  songDir = new File(dataPath("/songs/"));
  songList = songDir.list();
  value = lastvalue = (int)random(0, songList.length);
  songname = songList[value];
  sm = new Parse();
  sm.header("/assets/Amanecer/Amanecer.sm");
}

// Main skecth settings
void setupSettings() { 

  // Can the window be resized?
  surface.setResizable(false); 

  // Objects must be in setup()
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  cp5Select = new ControlP5(this);
  cp5Menu = new ControlP5(this);
  btn = new Buttons();
  vis = new Visualization();
  audio = new Audio();
  input = new Input();

  // Setup states
  screenAL = new ArrayList<Screen>();
  screenAL.add(new Title());
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
  speedmod = 11;
  manualOffset = -680; //-700 offset with 600px height (smaller is ealier)
  menuList = new String[]{"Game Start","Options","Exit"};

  // transition in/out times (in frames)
  transitionTimerInMax = transitionTimerOutMax = 20;
}

// Called once by setup()
void setupState() {
  switch(state) {
  case GAME_TITLE:
    screenAL.get(state).screenSetup();
    break;
  case GAME_MENU:
    screenAL.get(state).screenSetup();
    break;
  case GAME_SELECT:
    screenAL.get(state).screenSetup();
    break;
  case GAME_PLAY: 
    screenAL.get(state).screenSetup();
    break;
  case GAME_RESULT:
    screenAL.get(state).screenSetup(); 
    break;
  }
}

// Called every frame by draw()
void drawState() {
  //if (transitionTimerOut == 0) {
    switch(state) {
    case GAME_TITLE:
      screenAL.get(state).screenDraw();
      break;
    case GAME_MENU:
      screenAL.get(state).screenDraw();
      break;
    case GAME_SELECT:
      screenAL.get(state).screenDraw();
      break;
    case GAME_PLAY: 
      screenAL.get(state).screenDraw();
      break;
    case GAME_RESULT:
      screenAL.get(state).screenDraw(); 
      break;
    }
  //}
}

// Current time (make X smaller in X*framecount for the notes to arrive ealier)
float getTime() {
  return float(millis())-timeSinceLastStateSwitch+(sm.offset*1000)+manualOffset+250;
}

// Forward controlEvent callback method
void controlEvent(ControlEvent theControlEvent) {
  btn.controlEvent(theControlEvent);
}
// Forward keyPressed callback method
void keyPressed() {
  input.keyPressed();
}
void mouseWheel(MouseEvent event) {
  input.mouseWheel(event);
}
void mousePressed() {
  input.mousePressed();
}