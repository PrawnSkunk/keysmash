// Import libraries //<>//
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
Results scn1;
Gameplay scn2;


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
PFont basic;
PFont basic_bold;

final int GAME_MENU = 0;
final int GAME_PLAY = 1;
int state = GAME_MENU;

void setup() {  
  basic = createFont("Amelia-Basic", 200); 
  basic_bold = createFont("Amelia-Basic-Bold", 600); 
  size(800, 600);
  smooth();
  noStroke();
  imageMode(CENTER);
  scn1 = new Results();
  scn2 = new Gameplay();
  setupLibraries();
}

void draw() {
  switch(state) {
  case GAME_PLAY: 
  scn2.gameDraw();
    
    break;
  case GAME_MENU:
    scn1.gameDraw(); 
    break;
  }
}

void toggle_state(boolean theFlag) {
  if (theFlag==false) {
    state = GAME_PLAY;
    scn2.gameSetup();
    timeSinceLastStateSwitch = millis();
  } else {
    state = GAME_MENU;
    scn1.gameSetup();
  }
}

void setupLibraries() {
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  cp5.addToggle("toggle_state") .setPosition(0, height-35) .setSize(100, 35) .setValue(true) .setColorForeground (color(#000000, 150)) .setColorActive(color(#000000, 150)) .setColorBackground(color(#333333, 150));
}