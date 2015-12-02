// Import libraries //<>//
import controlP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.Date;
import java.util.Arrays;

// Declare class objects
Audio audio;
AudioPlayer song, sfx_value, sfx_select;
Buttons btn;
ControlP5 cp5, cp5Select, cp5Menu;
File songDir;
Input input;
Minim minim;
Parse sm;
RadioButton radio, menu;
Visualization vis;

// Declare array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Screen> screenAL;
ArrayList<Transmitter> transmitterAL;

// Declare common global variables
PVector[] grid; // Receptor column position
int[] rotations; // Receptor rotation position
boolean[] pressed, played; // Current keys pressed
char[] keys, keys2; // Input keybinds
String[] songList, menuList, menuDescription;
float octPos, receptorRadius, speedmod, timeSinceLastStateSwitch, time, manualOffset, transitionTimerIn, transitionTimerOut, transitionTimerInMax, transitionTimerOutMax, navigationTimer, radioTimer;
int rawScore, index, state, cue, duration, value, lastvalue, valueMenu, lastvalueMenu, score, goal;
boolean isplaying, canTransitionIn, firstTitleLoad, firstMenuLoad, firstSelectLoad, radioCanPlay, menuSongPlaying;
PFont basic, basic_bold, debug;
PImage background, cursor, cursorTail;
String songname;
int[] difficultyArray;

// Initialize game state constants
final int GAME_TITLE = 0;
final int GAME_MENU = 1;
final int GAME_SELECT = 2;
final int GAME_PLAY = 3;
final int GAME_RESULT = 4;

void setup() { 
  size(800, 600);
  noCursor();
  setupProgram();
}

void draw() {
  drawState();
}

// Get current Screen object
Screen getState() {
  return screenAL.get(state);
}

// This method is called once by setup()
void setupState() { 
  getState().screenSetup();
}

// This method is called every frame by draw()
void drawState() {
  getState().screenDraw();
}

// Transition to another state
void transition(int s) {
  sfx_select.rewind();
  sfx_select.play();
  transitionTimerOut = transitionTimerOutMax;
  state = s;
  setupState();
}

// Get current time
float getTime() {
  return float(millis())-timeSinceLastStateSwitch+(sm.offset*1000)+manualOffset+250;
}

void setupProgram() {
  setupSongDirectory();
  setupSettings();
  setupState();
  vis.setupVizualization();
}

void parseStepfile(int index, boolean run) {

  // Destination folder contents
  File path = new File(dataPath("songs/"+songList[index]));
  String[] pathArray = path.list();

  // Get the name of the StepMania file type
  for (int i=0; i<pathArray.length; i++) {

    if (pathArray[i].indexOf(".sm") != -1) {
      sm = new Parse();
      if (run == true) { 
        sm.run("songs/"+songList[index]+"/"+pathArray[i]);
        played[index] = true;
      } else { 
        sm.header("songs/"+songList[index]+"/"+pathArray[i]);
        difficultyArray[index] = int(sm.difficulties[0][0]);
      }
    }
    if (pathArray[i].indexOf(".ogg") != -1) {
      println("ERROR: .ogg audio format is not supported by Minim!");
      exit();
    }
  }
}

// Load songs directory and run parser
void setupSongDirectory() {
  songDir = new File(dataPath("/songs/"));
  songList = songDir.list();
  value = lastvalue = (int)random(0, songList.length);
  difficultyArray = new int[songList.length];
  played = new boolean[songList.length];
  songname = songList[value];
  parseStepfile(value, false);
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
  cp5 = new ControlP5(this);
  cp5Select = new ControlP5(this);
  cp5Menu = new ControlP5(this);
  btn = new Buttons();
  vis = new Visualization();
  audio = new Audio();
  input = new Input();

  sfx_select = minim.loadFile("/assets/select.wav");
  sfx_value = minim.loadFile("/assets/value.wav");

  // Setup states
  screenAL = new ArrayList<Screen>();
  screenAL.add(new Title());
  screenAL.add(new Menu());
  screenAL.add(new Select());
  screenAL.add(new Gameplay());
  screenAL.add(new Results());

  // Boolean states
  isplaying = true;
  canTransitionIn = true;
  firstTitleLoad = true;
  firstMenuLoad = true;
  firstSelectLoad = true;
  radioCanPlay = true;
  menuSongPlaying = true;

  // Load fonts
  debug = createFont("/assets/Amelia-Basic.ttf", 18, true); 
  basic = createFont("/assets/Amelia-Basic.ttf", 200, true); 
  basic_bold = createFont("/assets/Amelia-Basic-Bold.ttf", 600, true);
  cursor = loadImage("assets/cursor.png");
  cursorTail = loadImage("assets/cursortrail.png");

  // Space between receptors
  receptorRadius = 72.0;
  speedmod = 9;
  manualOffset = -600; //-700 offset with 600px height (smaller is ealier)
  menuList = new String[]{ "Game Start", "Exit" };
  menuDescription = new String[]{ "Title screen", "Game menu", "Selecting a song", "Playing", "Viewing results" };

  // transition in/out times (in frames)
  transitionTimerInMax = transitionTimerOutMax = 20;
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