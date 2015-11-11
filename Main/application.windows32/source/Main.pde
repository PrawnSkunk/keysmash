// Import libraries
import ddf.minim.*;
import controlP5.*;
import java.util.Date;
Minim minim;
AudioPlayer song;
ControlP5 cp5;
boolean toggleValue;

// Initialize empty array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Transmitter> transmitterAL;
Parse sm;
Screen scn;

// Gameplay data
PVector[] grid; // Receptor column position
char[] keys; // Input keysetup
boolean[] pressed; // Current keys pressed
int[] rotations;
PVector[] transl;

String songname = "video out e";
float receptorRadius = 72.0;
float speedmod = height/11;
float timeSinceLastStateSwitch;
float time;
PFont font;

final int GAME_MENU = 0;
final int GAME_PLAY = 1;
int state = GAME_MENU;

void setup() {  
  size(800, 600);
  smooth();
  noStroke();
  imageMode(CENTER);
  scn = new Screen();
  setupLibraries();
}

void draw() {
  switch(state) {
  case GAME_MENU: 
    scn.gameMenuDraw(); 
    break;
  case GAME_PLAY:
    scn.gamePlayDraw();
    break;
  }
}

void toggle_state(boolean theFlag) {
  if (theFlag==true) {
    state = GAME_MENU;
    scn.gameMenuSetup();
  } else {
    state = GAME_PLAY;
    scn.gamePlaySetup();
    timeSinceLastStateSwitch = millis();
  }
}

void setupLibraries() {
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  cp5.addToggle("toggle_state") .setPosition(50,50) .setSize(30, 30) .setValue(true) .setColorActive(color(#ff0000)) .setColorBackground(color(#00ff00));
}