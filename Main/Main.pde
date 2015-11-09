/* @pjs preload="video out e/video out e.mp3";  */
/* @pjs preload="note_red.png"; */
/* @pjs preload="receptor.png"; */

// Initialize empty array lists
ArrayList<Arrow> arrowAL = new ArrayList<Arrow>();
ArrayList<Receptor> receptorAL = new ArrayList<Receptor>();
ArrayList<Transmitter> transmitterAL = new ArrayList<Transmitter>();

import ddf.minim.*;

// Declare script as a global variable
Parse sm;

// timing
float m, time;
float timeRead;

// Numeric Keypad Grid
PVector[] pos = { 
  new PVector(-1, 0), 
  new PVector(-1, -1), 
  new PVector(0, -1), 
  new PVector(1, -1), 
  new PVector(1, 0), 
  new PVector(1, 1), 
  new PVector(0, 1), 
  new PVector(-1, 1) };

// Key Setup
char[] keys = { '4', '7', '8', '9', '6', '3', '2', '1' };
boolean[] pressed = new boolean[keys.length];

// Fixed object locations
float receptorRadius = 64;

// Options
float speedmod = 10.0;

void keyPressed() {

  // Check if directional keys are pressed
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = true;
      addArrow(i);
    }
  }
}

void keyReleased() {

  // Check if directional keys are released
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = false;
    }
  }
}

// Instantiate Arrow at respective transmitter
void addArrow(int i) {
  float[] posArr = pos[i].array();
  arrowAL.add(new Arrow(posArr[0]*width, posArr[1]*height, -posArr[0]*speedmod, -posArr[1]*speedmod));
}

void setup() {
  size(640, 640);
  noStroke();
  // Load Audio
  Minim minim = new Minim(this);
  AudioPlayer song = minim.loadFile("video out e/video out e.mp3");

  // Run parser
  sm = new Parse();
  sm.run();
  //mStart = (int)sm.offset;

  // Instantiate objects
  for (int i = 0; i < pos.length; i++) {
    float[] posArr = pos[i].array();
    receptorAL.add(new Receptor(posArr[0]*receptorRadius, posArr[1]*receptorRadius));
    transmitterAL.add(new Transmitter(posArr[0]*width, posArr[1]*height));
  }

  // Play Audio
  song.play();
}

void draw() {

  m = millis();
  time = (m/1000)+sm.offset+0.45;

  background (0);

  for (int i=0; i<sm.r0.length; i++) {
    if (sm.r0[i] - time < 0 && sm.r0[i] - time > -0.02) { 
      addArrow(0); 
      break;
    }
  }
  for (int i=0; i<sm.r1.length; i++) {
    if (sm.r1[i] - time < 0 && sm.r1[i] - time > -0.02) { 
      addArrow(1); 
      break;
    }
  }
  for (int i=0; i<sm.r2.length; i++) {
    if (sm.r2[i] - time < 0 && sm.r2[i] - time > -0.02) { 
      addArrow(2); 
      break;
    }
  }
  for (int i=0; i<sm.r3.length; i++) {
    if (sm.r3[i] - time < 0 && sm.r3[i] - time > -0.02) { 
      addArrow(3); 
      break;
    }
  }
  for (int i=0; i<sm.r4.length; i++) {
    if (sm.r4[i] - time < 0 && sm.r4[i] - time > -0.02) { 
      addArrow(4); 
      break;
    }
  }
  for (int i=0; i<sm.r5.length; i++) {
    if (sm.r5[i] - time < 0 && sm.r5[i] - time > -0.02) { 
      addArrow(5); 
      break;
    }
  }
  for (int i=0; i<sm.r6.length; i++) {
    if (sm.r6[i] - time < 0 && sm.r6[i] - time > -0.02) { 
      addArrow(6); 
      break;
    }
  }
  for (int i=0; i<sm.r7.length; i++) {
    if (sm.r7[i] - time < 0 && sm.r7[i] - time > -0.02) { 
      addArrow(7); 
      break;
    }
  }

  // Update Objects
  for (int i=0; i<pos.length; i++) {
    receptorAL.get(i).update();
    transmitterAL.get(i).update();
  }

  for (int i=0; i<arrowAL.size(); i++) {

    // Update Arrows
    arrowAL.get(i).update();
  }
}