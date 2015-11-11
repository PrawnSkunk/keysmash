// Preload resources
/* @pjs preload="video out e/video out e.mp3";  */
/* @pjs preload="video out e/video out e.sm";  */
/* @pjs preload="note_red.png"; */
/* @pjs preload="receptor.png"; */

// Import libraries
import ddf.minim.*;
import controlP5.*;

// Initialize empty array lists
ArrayList<Arrow> arrowAL = new ArrayList<Arrow>();
ArrayList<Receptor> receptorAL = new ArrayList<Receptor>();
ArrayList<Transmitter> transmitterAL = new ArrayList<Transmitter>();

// Receptor column position
PVector[] grid = { new PVector(-1, 0), new PVector(-1, -1), new PVector(0, -1), new PVector(1, -1), new PVector(1, 0), new PVector(1, 1), new PVector(0, 1), new PVector(-1, 1) };

// Input keybinds
char[] keys = { '4', '7', '8', '9', '6', '3', '2', '1' };
boolean[] pressed = new boolean[keys.length];

// Common Variables
String songname = "video out e";
float receptorRadius = 64;
float speedmod = 10.0; // pixels per frame
float time = 0.0;
Parse sm = new Parse();
Screen scn = new Screen();
int col = 255;

// UI
ControlP5 cp5;
boolean toggleValue = false;

void setup() {
  size(640, 640);
  frameRate(60);
  smooth();
  noStroke();
  imageMode(CENTER); 
  parse();
  gridSetup();
  loadAudio();

  cp5 = new ControlP5(this);

  cp5.addToggle("dark")
     .setPosition(40,250)
     .setSize(50,20)
     .setValue(true)
     .setColorActive(color(#ff0000))
     .setColorBackground(color(#00ff00))
     ;
}

void dark(boolean theFlag) {
  if(theFlag==false) {
    col = 100;
  } else {
    col = 255;
  }
}

void draw() {

  if (toggleValue==true) {
    fill(255);
    ellipse(50, 50, 50, 50);
  }

  scn.display();
  spawnNotes();
  drawObjects();
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

// Load and play audio
void loadAudio() {
  Minim minim = new Minim(this);
  AudioPlayer song = minim.loadFile(songname+"/"+songname+".mp3");
  song.play();
}

// Parse note data
void parse() {
  sm.run(songname+"/"+songname+".sm");
}

// Instantiate stationary objects
void gridSetup() {
  for (int i = 0; i < grid.length; i++) {
    float[] gridArr = grid[i].array();
    receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius));
    transmitterAL.add(new Transmitter(gridArr[0]*width, gridArr[1]*height));
  }
}

// Current time
float getTime() {
  return ((float)millis()/1000)+sm.offset+(speedmod/80);
}

// Execute note data
void spawnNotes() {
  time = getTime();
  for (int i=0; i<grid.length; i++) {
    for (int j=0; j<sm.notes.length; j++) {
      if (sm.notes[i][j] - time < 0.01 && sm.notes[i][j] - time > -0.01) {

        // spawn note at respective transmitter
        float[] gridArr = grid[i].array();
        arrowAL.add(new Arrow(gridArr[0]*width, gridArr[1]*height, -gridArr[0]*speedmod, -gridArr[1]*speedmod));
        sm.notes[i][j] = 0.0;
      }
    }
  }
}

void keyPressed() {
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = true;
    }
  }
}

void keyReleased() {
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = false;
    }
  }
}