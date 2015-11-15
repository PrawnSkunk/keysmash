String songname = "Nocturnal Type"; //<>//
//String songname = "video out e";
int FPS = 60;
float manualOffset;

// Import libraries
import ddf.minim.*;
import controlP5.*;
import java.util.Date;
import java.util.Arrays;

Minim minim;
AudioPlayer song;
AudioPlayer tick;
ControlP5 controlP5;
Menu scn0;
Select scn1;
Gameplay scn2;
Results scn3;
Parse sm;
Buttons btn;

// Initialize empty array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Transmitter> transmitterAL;

// Global Variables
float[][] noteArr = new float[0][0];
PVector[] grid; // Receptor column position
int[] rotations; // Receptor rotation position
boolean[] pressed; // Current keys pressed
char[] keys; // Input keysetup
float receptorRadius, speedmod, timeSinceLastStateSwitch, time;
PFont basic, basic_bold, debug;
int state;
int index;
int fpsCount;
final int GAME_MENU = 0;
final int GAME_SELECT = 1;
final int GAME_PLAY = 2;
final int GAME_RESULT = 3;

void setup() { 
  size(800, 600);
  frameRate(FPS);

  sm = new Parse();
  sm.run(songname+"/"+songname+".sm");

  setting();
  stateSetup();
  btn.buttons();
  btn.addTabs();
}

void draw() {
  speedmod = height/50;
  manualOffset = -speedmod*58.333; //-700 offset with 600px height
  stateDraw();
}

void setting() {
  smooth();
  noStroke();
  imageMode(CENTER);
  surface.setResizable(false);
  scn0 = new Menu();
  scn1 = new Select();
  scn2 = new Gameplay();
  scn3 = new Results();
  minim = new Minim(this);
  controlP5 = new ControlP5(this);
  btn = new Buttons();
  receptorRadius = 72.0;
  debug = createFont("Amelia-Basic", 18, true); 
  basic = createFont("Amelia-Basic", 200, true); 
  basic_bold = createFont("Amelia-Basic-Bold", 600, true);
}

void stateSetup() {
  switch(state) {
  case GAME_MENU:
    scn0.screenSetup();
    break;
  case GAME_SELECT:
    scn1.screenSetup();
    break;
  case GAME_PLAY: 
    scn2.screenSetup();
    break;
  case GAME_RESULT:
    scn1.screenSetup(); 
    break;
  }
}

void stateDraw() {
  switch(state) {
  case GAME_MENU:
    scn0.screenDraw();
    break;
  case GAME_SELECT:
    scn1.screenDraw();
    break;
  case GAME_PLAY: 
    scn2.screenDraw();
    break;
  case GAME_RESULT:
    scn3.screenDraw(); 
    break;
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if (theControlEvent.getTab().getId() == GAME_MENU) {
      state = GAME_MENU;
      scn0.screenSetup();
    } else if (theControlEvent.getTab().getId() == GAME_SELECT) {
      state = GAME_SELECT;
      scn1.screenSetup();
    } else if (theControlEvent.getTab().getId() == GAME_PLAY) {
      state = GAME_PLAY;
      scn2.screenSetup();
    } else  if (theControlEvent.getTab().getId() == GAME_RESULT) {
      state = GAME_RESULT;
      scn3.screenSetup();
    }
  }
}

/*
void gameplay() {
 if (millis()<1000) return; // Flow will leave the function if called within 1 second of startup
 state = GAME_PLAY;
 scn2.screenSetup();
 }
 
 void results() {
 if (millis()<1000) return;
 state = GAME_RESULT;
 scn1.screenSetup();
 }
 */