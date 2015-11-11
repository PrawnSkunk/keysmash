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
Screen scn;

// Gameplay data
PVector[] grid; // Receptor column position
char[] keys; // Input keysetup
boolean[] pressed; // Current keys pressed

String songname = "video out e";
float receptorRadius = 64.0;
float speedmod = 10.0;
float timeSinceLastStateSwitch;
float time;

final int GAME_MENU = 0;
final int GAME_PLAY = 1;
int state = GAME_MENU;

void setup() {  
  scn = new Screen();
  size(640, 640);
  smooth();
  noStroke();
  imageMode(CENTER);
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

void state(boolean theFlag) {
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
  cp5.addToggle("state") .setPosition(40, 250) .setSize(50, 20) .setValue(true) .setColorActive(color(#ff0000)) .setColorBackground(color(#00ff00));
}